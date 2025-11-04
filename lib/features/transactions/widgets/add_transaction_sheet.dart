import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../model/transaction_model.dart';

class AddTransactionSheet extends StatefulWidget {
  final Function(Transaction) onAddTransaction;
  final Transaction? initialData; // optional for editing

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
  String _selectedType = 'expense';
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
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Enter description'
                      : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter amount';
                    final parsed = double.tryParse(v);
                    if (parsed == null || parsed <= 0)
                      return 'Enter valid amount';
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                if (_selectedType == 'expense') ...[
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(labelText: 'Category'),
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
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedType,
                        decoration: const InputDecoration(labelText: 'Type'),
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
                          decoration: const InputDecoration(labelText: 'Date'),
                          child: Text(
                            '${_selectedDate.toLocal()}'.split(' ')[0],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: _submit, child: const Text('Save')),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
