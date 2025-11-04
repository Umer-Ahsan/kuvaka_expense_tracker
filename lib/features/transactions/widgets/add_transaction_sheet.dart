import 'package:flutter/material.dart';
import 'package:kuvaka_expense_tracker/constants/styles.dart';
import 'package:kuvaka_expense_tracker/features/shared/view/widgets/custom_button_widget.dart';
import 'package:kuvaka_expense_tracker/features/transactions/widgets/custom_textFormField.dart';
import 'package:uuid/uuid.dart';
import '../model/transaction_model.dart';

class AddTransactionSheet extends StatefulWidget {
  final Function(Transaction) onAddTransaction;
  final Transaction? initialData;

  const AddTransactionSheet({
    super.key,
    required this.onAddTransaction,
    this.initialData,
  });

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  final _amountController = TextEditingController();
  String? _selectedCategory;
  String _selectedType = 'income';
  DateTime _selectedDate = DateTime.now();

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
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      final d = widget.initialData!;
      _descController.text = d.description;
      _amountController.text = d.amount.toString();
      _selectedCategory = d.category;
      _selectedType = d.type;
      _selectedDate = d.date;
    }
  }

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final id = widget.initialData?.id ?? const Uuid().v4();
    final tx = Transaction(
      id: id,
      description: _descController.text.trim().isEmpty
          ? (_selectedType == 'income' ? 'Income' : 'Expense')
          : _descController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      category: _selectedType == 'income'
          ? 'Income'
          : (_selectedCategory ?? _categories.first),
      date: _selectedDate,
      type: _selectedType,
    );

    widget.onAddTransaction(tx);
    Navigator.of(context).pop();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.initialData == null
                      ? 'Add Transaction'
                      : 'Edit Transaction',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedType,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.03),
                          hintText: "Type",
                          hintStyle: AppStyles.f14w400.copyWith(
                            color: Color(0xFF6B7280),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(14)),
                            borderSide: BorderSide(color: Color(0xF0F0F0F0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(14),
                            ),
                            borderSide: BorderSide(color: Color(0xF0F0F0F0)),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 18,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'expense',
                            child: Text('Expense'),
                          ),
                          DropdownMenuItem(
                            value: 'income',
                            child: Text('Income'),
                          ),
                        ],
                        onChanged: (v) =>
                            setState(() => _selectedType = v ?? 'expense'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: _pickDate,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.black.withOpacity(0.03),
                            hintText: "Date",
                            hintStyle: AppStyles.f14w400.copyWith(
                              color: Color(0xFF6B7280),
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(14),
                              ),
                              borderSide: BorderSide(color: Color(0xF0F0F0F0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(14),
                              ),
                              borderSide: BorderSide(color: Color(0xF0F0F0F0)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 18,
                            ),
                          ),
                          child: Text(
                            '${_selectedDate.toLocal()}'.split(' ')[0],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  labelText: "Description",
                  controller: _descController,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Enter description'
                      : null,
                ),
                CustomTextFormField(
                  labelText: "Amount",
                  controller: _amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter amount';
                    final parsed = double.tryParse(v);
                    if (parsed == null || parsed <= 0) {
                      return 'Enter valid amount';
                    }
                    return null;
                  },
                ),
                if (_selectedType == 'expense') ...[
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.03),
                      hintText: "Category",
                      hintStyle: AppStyles.f14w400.copyWith(
                        color: Color(0xFF6B7280),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        borderSide: BorderSide(color: Color(0xF0F0F0F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(14),
                        ),
                        borderSide: BorderSide(color: Color(0xF0F0F0F0)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 18,
                      ),
                    ),
                    items: _categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedCategory = v),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Select category' : null,
                  ),
                ] else ...[
                  const SizedBox(height: 8),
                ],
                const SizedBox(height: 16),
                CustomButton(text: "Save", onPressed: _submit),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
