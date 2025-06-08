import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_mingle/models/user.dart' as app_model;
import 'package:money_mingle/providers/user_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> registerUser(WidgetRef ref, fb.User firebaseUser) async {
  final userService = ref.read(userServiceProvider);

  final user = app_model.User(
    uid: firebaseUser.uid,
    email: firebaseUser.email ?? '',
    displayName: firebaseUser.displayName,
    photoUrl: firebaseUser.photoURL,
    createdAt: DateTime.now(),
    monthlyBudget: null,
    savingsGoal: null,
  );

  await userService.saveUser(user);
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream para escuchar el estado de autenticación
  Stream<fb.User?> authStateChanges() => _auth.authStateChanges();

  // Iniciar sesión con email y contraseña
  Future<fb.UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Registrar usuario con email y contraseña
  Future<fb.UserCredential> register(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  // Iniciar sesión con Google
  Future<fb.UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw fb.FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Inicio de sesión cancelado por el usuario',
      );
    }
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = fb.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await _auth.signInWithCredential(credential);
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }

  // Usuario actual
  fb.User? get currentUser => _auth.currentUser;
}