import 'package:flutter/material.dart';
import 'package:kuvaka_expense_tracker/features/budget/widgets/budget_tile_widget.dart';
import 'package:kuvaka_expense_tracker/features/shared/view/widgets/custom_button_widget.dart';
import 'package:kuvaka_expense_tracker/features/transactions/widgets/custom_textformfield.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../constants/styles.dart';
import '../model/budget_model.dart';
import '../viewmodel/budget_provider.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BudgetProvider>(context);
    final budgets = provider.budgets;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Budgets", style: AppStyles.f20w500),
        centerTitle: true,
      ),
      body: budgets.isEmpty
          ? const Center(child: Text("No budgets set yet"))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: budgets.length,
              itemBuilder: (context, index) {
                final b = budgets[index];
                return BudgetTile(
                  budget: b,
                  onDelete: () async {
                    await provider.deleteBudget(b.id);
                  },
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: _AddBudgetSheet(provider: provider),
            ),
          );
        },
      ),
    );
  }
}

class _AddBudgetSheet extends StatefulWidget {
  final BudgetProvider provider;
  const _AddBudgetSheet({required this.provider});

  @override
  State<_AddBudgetSheet> createState() => _AddBudgetSheetState();
}

class _AddBudgetSheetState extends State<_AddBudgetSheet> {
  final TextEditingController _limitController = TextEditingController();
  String? _selectedCategory;

  final List<String> _categories = [
    'Food',
    'Travel',
    'Shopping',
    'Bills',
    'Health',
    'Entertainment',
    'Others',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final inputFillColor = isDark
        ? Colors.white.withOpacity(0.05)
        : Colors.black.withOpacity(0.03);

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Add Budget",
                style: AppStyles.f20w500.copyWith(
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: InputDecoration(
                filled: true,
                fillColor: inputFillColor,
                hintText: "Category",
                hintStyle: AppStyles.f14w400.copyWith(color: theme.hintColor),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 18,
                ),
              ),
              items: _categories
                  .map(
                    (category) =>
                        DropdownMenuItem(value: category, child: Text(category)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
              labelText: "Limit Amount",
              controller: _limitController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: "Save",
                    onPressed: () async {
                      final id = const Uuid().v4();
                      final category = _selectedCategory;
                      final limit =
                          double.tryParse(_limitController.text.trim()) ?? 0;
      
                      if (category != null && limit > 0) {
                        await widget.provider.addBudget(
                          Budget(id: id, category: category, limit: limit),
                        );
                        if (context.mounted) Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
