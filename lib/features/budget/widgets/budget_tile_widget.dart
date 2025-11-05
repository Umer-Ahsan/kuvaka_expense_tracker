import 'package:flutter/material.dart';
import 'package:kuvaka_expense_tracker/constants/styles.dart';
import '../model/budget_model.dart';

class BudgetTile extends StatelessWidget {
  final Budget budget;
  final VoidCallback? onDelete;

  const BudgetTile({super.key, required this.budget, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.pie_chart_rounded, color: Colors.blueAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  budget.category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.f15w600,
                ),
                const SizedBox(height: 4),
                Text(
                  "Limit: \$${budget.limit.toStringAsFixed(2)}",
                  style: AppStyles.f14w400.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
