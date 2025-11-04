import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/transaction_model.dart';

class TransactionProvider extends ChangeNotifier {
  static const String boxName = 'transactionsBox';

  late Box<Transaction> _box;
  List<Transaction> _transactions = [];

  TransactionProvider() {
    _init();
  }

  Future<void> _init() async {
    // Assumes Hive initialized and adapter registered in main.dart
    _box = Hive.box<Transaction>(boxName);
    _transactions = _box.values.toList();
    notifyListeners();
  }

  List<Transaction> get transactions => _transactions;

  Future<void> addTransaction(Transaction tx) async {
    await _box.put(tx.id, tx);
    _transactions = _box.values.toList();
    notifyListeners();
  }

  Future<void> updateTransaction(Transaction tx) async {
    await _box.put(tx.id, tx);
    _transactions = _box.values.toList();
    notifyListeners();
  }

  Future<void> deleteTransaction(String id) async {
    await _box.delete(id);
    _transactions = _box.values.toList();
    notifyListeners();
  }

  double get totalIncome => _transactions
      .where((t) => t.type.toLowerCase() == 'income')
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpenses => _transactions
      .where((t) => t.type.toLowerCase() == 'expense')
      .fold(0.0, (sum, t) => sum + t.amount);

  double get currentBalance => totalIncome - totalExpenses;
}
