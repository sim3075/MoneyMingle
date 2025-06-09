import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_mingle/models/transaction.dart' as my_models;
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class TransactionService {
  List<my_models.Transaction> _transactions = [];

  List<my_models.Transaction> get transactions => _transactions;

  double get totalIncome => _transactions
      .where((t) => t.type == my_models.TransactionType.income)
      .fold(0, (sum, t) => sum + t.amount);

  double get totalExpense => _transactions
      .where((t) => t.type == my_models.TransactionType.expense)
      .fold(0, (sum, t) => sum + t.amount);

  List<my_models.Transaction> getAllTransactions() => _transactions;

  Future<void> loadTransactions() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      // Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .orderBy('date', descending: true)
          .get();

      _transactions = snapshot.docs
          .map((doc) => my_models.Transaction.fromMap(doc.data(), doc.id))
          .toList();

      // Guarda localmente
      await saveTransactions();
    } else {
      // Si no hay usuario, carga solo local
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('transactions');
      if (raw != null) {
        _transactions = my_models.Transaction.listFromJson(raw);
      }
    }
  }

  /// Guarda transacciones localmente (SharedPreferences)
  Future<void> saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'transactions',
      my_models.Transaction.listToJson(_transactions),
    );
  }

  /// Agrega una transacción a Firestore y local
  Future<void> addTransaction(my_models.Transaction tx) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final docRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .add(tx.toMap());
      final txWithId = tx.copyWith(id: docRef.id);
      _transactions.insert(0, txWithId);
      await saveTransactions();
    } else {
      _transactions.insert(0, tx);
      await saveTransactions();
    }
  }

  /// Elimina una transacción de Firestore y local
  Future<void> deleteTransaction(my_models.Transaction tx) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && tx.id != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .doc(tx.id)
          .delete();
    }
    _transactions.removeWhere((t) => t.id == tx.id);
    await saveTransactions();
  }

  /// Obtiene los gastos agrupados por día del mes
  List<double> getExpensesByDay() {
    final List<double> expensesByDay = List.generate(30, (_) => 0.0);
    for (final transaction in _transactions) {
      if (transaction.type == my_models.TransactionType.expense) {
        final day = transaction.date.day;
        expensesByDay[day - 1] += transaction.amount;
      }
    }
    return expensesByDay;
  }

  /// Edita (actualiza) una transacción en Firestore y local
  Future<void> updateTransaction(my_models.Transaction tx) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && tx.id != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .doc(tx.id)
          .update(tx.toMap());
      final index = _transactions.indexWhere((t) => t.id == tx.id);
      if (index != -1) {
        _transactions[index] = tx;
        await saveTransactions();
      }
    }
  }

  // Sube la imagen y retorna la URL
  Future<String?> uploadReceiptImage(String uid, XFile image) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('users/$uid/receipts/${DateTime.now().millisecondsSinceEpoch}_${image.name}');
    final snapshot = await storageRef.putFile(File(image.path));
    return await snapshot.ref.getDownloadURL();
  }

  // Elimina la imagen anterior del storage
  Future<void> deleteReceiptImage(String url) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(url);
      await ref.delete();
    } catch (_) {
      // Si falla, ignora
    }
  }

  /// Exporta todas las transacciones como Excel en el sandbox y retorna la ruta
  Future<String> exportToExcel() async {
    final excel = Excel.createExcel();
    final sheet = excel['Transacciones'];
    sheet.appendRow([
      'Tipo', 'Título', 'Monto', 'Fecha', 'Categoría', 'Nota', 'Fijo'
    ]);
    for (final tx in _transactions) {
      sheet.appendRow([
        tx.type == my_models.TransactionType.expense ? 'Gasto' : 'Ingreso',
        tx.title,
        tx.amount.toStringAsFixed(2),
        tx.date.toIso8601String(),
        tx.category ?? '',
        tx.note ?? '',
        tx.isFixed ? 'Sí' : 'No',
      ]);
    }
    final dir = await getApplicationDocumentsDirectory();
    final stamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final filePath = '${dir.path}/transacciones_$stamp.xlsx';
    final bytes = excel.encode();
    await File(filePath).writeAsBytes(bytes!);
    return filePath;
  }

  /// Exporta todas las transacciones como PDF en el sandbox y retorna la ruta
  Future<String> exportToPdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context ctx) => [
          pw.Header(level: 0, child: pw.Text('Historial de Transacciones')),
          pw.Table.fromTextArray(
            headers: [
              'Tipo', 'Título', 'Monto', 'Fecha', 'Categoría', 'Nota', 'Fijo'
            ],
            data: _transactions.map((tx) => [
              tx.type == my_models.TransactionType.expense ? 'Gasto' : 'Ingreso',
              tx.title,
              tx.amount.toStringAsFixed(2),
              DateFormat('yyyy-MM-dd').format(tx.date),
              tx.category ?? '',
              tx.note ?? '',
              tx.isFixed ? 'Sí' : 'No',
            ]).toList(),
          ),
        ],
      ),
    );
    final dir = await getApplicationDocumentsDirectory();
    final stamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final filePath = '${dir.path}/transacciones_$stamp.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    return filePath;
  }
}
