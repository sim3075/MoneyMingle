import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_mingle/models/user.dart';

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
}