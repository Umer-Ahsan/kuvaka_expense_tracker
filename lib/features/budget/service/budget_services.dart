import 'package:hive_flutter/hive_flutter.dart';
import '../model/budget_model.dart';

class BudgetService {
  final Box<Budget> _box = Hive.box<Budget>('budgets');

  List<Budget> getAllBudgets() => _box.values.toList();

  Future<void> addBudget(Budget budget) async {
    await _box.put(budget.id, budget);
  }

  Future<void> updateBudget(Budget budget) async {
    await _box.put(budget.id, budget);
  }

  Future<void> deleteBudget(String id) async {
    await _box.delete(id);
  }
}
