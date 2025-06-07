import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mingle/domain/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Provider para el servicio de autenticación
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Provider reactivo para el usuario autenticado
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});