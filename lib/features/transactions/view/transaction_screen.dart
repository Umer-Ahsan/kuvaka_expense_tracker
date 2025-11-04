import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuvaka_expense_tracker/constants/colors.dart';
import 'package:kuvaka_expense_tracker/features/shared/viewmodel/theme_provider.dart';
import 'package:provider/provider.dart';
import '../viewmodel/transaction_provider.dart';
import '../model/transaction_model.dart';
import 'package:uuid/uuid.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    return Scaffold(
     backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Transactions'),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Text(
                Provider.of<ThemeProvider>(context).isDarkMode
                    ? "Light Mode"
                    : "Dark Mode",
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: () {
                context.read<ThemeProvider>().toggleTheme();
              },
            ),
          ],
        ),
      ),
      body: provider.transactions.isEmpty
          ? const Center(child: Text('No transactions yet'))
          : ListView.builder(
              itemCount: provider.transactions.length,
              itemBuilder: (context, index) {
                final tx = provider.transactions[index];
                return ListTile(
                  title: Text(tx.description),
                  subtitle: Text(tx.category),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$${tx.amount.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await provider.deleteTransaction(tx.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTx = Transaction(
            id: const Uuid().v4(),
            description: 'Test Expense ${provider.transactions.length + 1}',
            amount: 25.0,
            category: 'Food',
            date: DateTime.now(),
          );
          await provider.addTransaction(newTx);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
