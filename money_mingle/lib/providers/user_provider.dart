import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mingle/domain/services/user_service.dart';

final userServiceProvider = Provider<UserService>((ref) => UserService());
