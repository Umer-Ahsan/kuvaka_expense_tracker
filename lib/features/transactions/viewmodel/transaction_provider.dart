import 'package:flutter/material.dart';
import '../model/transaction_model.dart';
import '../service/transaction_service.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionService _service = TransactionService();
  List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  TransactionProvider() {
    loadTransactions();
  }

  void loadTransactions() {
    _transactions = _service.getAllTransactions();
    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _service.addTransaction(transaction);
    loadTransactions();
  }

  Future<void> deleteTransaction(String id) async {
    await _service.deleteTransaction(id);
    loadTransactions();
  }

  Future<void> updateTransaction(Transaction transaction) async {
    await _service.updateTransaction(transaction);
    loadTransactions();
  }
}
