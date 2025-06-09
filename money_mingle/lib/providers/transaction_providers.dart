import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mingle/domain/services/transaction_service.dart';

final transactionServiceProvider = Provider<TransactionService>((ref) {
  return TransactionService();
});