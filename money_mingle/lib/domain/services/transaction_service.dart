import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_mingle/models/transaction.dart' as my_models;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  /// Carga transacciones desde Firestore y SharedPreferences
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
      // Actualiza en la lista local
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
    final uploadTask = storageRef.putFile(File(image.path));
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  // Elimina la imagen anterior del storage
  Future<void> deleteReceiptImage(String url) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(url);
      await ref.delete();
    } catch (_) {
      // Si falla, ignora (puede que ya no exista)
    }
  }
}