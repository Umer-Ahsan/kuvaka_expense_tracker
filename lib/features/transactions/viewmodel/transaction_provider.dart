import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/transaction_model.dart';

class TransactionProvider extends ChangeNotifier {
  static const String boxName = 'transactionsBox';

  late Box<Transaction> _box;
  List<Transaction> _transactions = [];

  /// Constructor allows dependency injection for testing
  TransactionProvider({Box<Transaction>? testBox}) {
    if (testBox != null) {
      _box = testBox;
      _transactions = _box.values.toList();
    } else {
      _init();
    }
  }

  /// Initialize Hive box (used in production)
  Future<void> _init() async {
    _box = Hive.box<Transaction>(boxName);
    _transactions = _box.values.toList();
    notifyListeners();
  }

  /// Getter for transactions list
  List<Transaction> get transactions => _transactions;

  /// Add a transaction
  Future<void> addTransaction(Transaction tx) async {
    await _box.put(tx.id, tx);
    _transactions = _box.values.toList();
    notifyListeners();
  }

  /// Update a transaction
  Future<void> updateTransaction(Transaction tx) async {
    await _box.put(tx.id, tx);
    _transactions = _box.values.toList();
    notifyListeners();
  }

  /// Delete a transaction
  Future<void> deleteTransaction(String id) async {
    await _box.delete(id);
    _transactions = _box.values.toList();
    notifyListeners();
  }

  /// Total income
  double get totalIncome => _transactions
      .where((t) => t.type.toLowerCase() == 'income')
      .fold(0.0, (sum, t) => sum + t.amount);

  /// Total expenses
  double get totalExpenses => _transactions
      .where((t) => t.type.toLowerCase() == 'expense')
      .fold(0.0, (sum, t) => sum + t.amount);

  /// Current balance
  double get currentBalance => totalIncome - totalExpenses;
}
