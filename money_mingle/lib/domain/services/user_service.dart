import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_mingle/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final _usersRef = FirebaseFirestore.instance.collection('users');

  /// Guarda o actualiza el usuario en Firestore
  Future<void> saveUser(User user) async {
    await _usersRef.doc(user.uid).set(user.toMap(), SetOptions(merge: true));
  }

  /// Obtiene el usuario desde Firestore
  Future<User?> getUser(String uid) async {
    final doc = await _usersRef.doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return User.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  /// Actualiza un campo específico del usuario
  Future<void> updateUserField(String uid, String field, dynamic value) async {
    await _usersRef.doc(uid).update({field: value});
  }

  /// Sube una nueva foto de perfil y actualiza el campo photoUrl en Firestore
  Future<String?> updateProfilePhoto(String uid) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile == null) return null;

    final file = File(pickedFile.path);
    final storageRef = FirebaseStorage.instance.ref().child('profile_photos/$uid.jpg');

    final uploadTask = storageRef.putFile(file);
    final snapshot = await uploadTask; // Espera correctamente la subida
    final downloadUrl = await snapshot.ref.getDownloadURL();

    await _usersRef.doc(uid).update({'photoUrl': downloadUrl});
    return downloadUrl;
  }
}

Future<double> getUserBudget() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getDouble('user_budget') ?? 00.0;
}

Future<void> setUserBudget(double value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('user_budget', value);
}