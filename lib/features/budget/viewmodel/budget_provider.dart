import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/budget_model.dart';

class BudgetProvider extends ChangeNotifier {
  static const String boxName = 'budgetsBox';

  late Box<Budget> _box;
  List<Budget> _budgets = [];

  BudgetProvider() {
    _init();
  }

  Future<void> _init() async {
    _box = Hive.box<Budget>(boxName);
    _budgets = _box.values.toList();
    notifyListeners();
  }

  List<Budget> get budgets => _budgets;

  Future<void> addBudget(Budget budget) async {
    await _box.put(budget.id, budget);
    _budgets = _box.values.toList();
    notifyListeners();
  }

  Future<void> updateBudget(Budget budget) async {
    await _box.put(budget.id, budget);
    _budgets = _box.values.toList();
    notifyListeners();
  }

  Future<void> deleteBudget(String id) async {
    await _box.delete(id);
    _budgets = _box.values.toList();
    notifyListeners();
  }

  double? getBudgetLimit(String category) {
    return _budgets
        .firstWhere((b) => b.category == category, orElse: () => Budget(id: '', category: '', limit: 0))
        .limit;
  }

  /// Checks if the spent amount exceeds the budget
  bool isOverBudget(String category, double spent) {
    final limit = getBudgetLimit(category);
    if (limit == null || limit == 0) return false;
    return spent > limit;
  }

  /// Returns how close (0.0 - 1.0) the user is to the limit
  double budgetUsageRatio(String category, double spent) {
    final limit = getBudgetLimit(category);
    if (limit == null || limit == 0) return 0;
    return spent / limit;
  }
}
