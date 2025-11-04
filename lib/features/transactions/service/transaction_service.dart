import 'package:hive_flutter/hive_flutter.dart';
import '../model/transaction_model.dart';

class TransactionService {
  final Box<Transaction> _box = Hive.box<Transaction>('transactions');

  List<Transaction> getAllTransactions() => _box.values.toList();

  Future<void> addTransaction(Transaction transaction) async {
    await _box.put(transaction.id, transaction);
  }

  Future<void> deleteTransaction(String id) async {
    await _box.delete(id);
  }

  Future<void> updateTransaction(Transaction transaction) async {
    await _box.put(transaction.id, transaction);
  }
}
