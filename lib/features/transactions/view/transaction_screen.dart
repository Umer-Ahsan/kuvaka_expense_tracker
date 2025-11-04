import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../model/chart_data_model.dart';
import '../model/transaction_model.dart';
import '../viewmodel/transaction_provider.dart';
import '../widgets/add_transaction_sheet.dart';
import '../../shared/viewmodel/theme_provider.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);

    // Group totals by category (only expenses for chart or both as you prefer)
    final Map<String, double> categoryTotals = {};
    for (var tx in provider.transactions) {
      // Only consider expenses in chart, or include income if you prefer
      if (tx.type.toLowerCase() == 'expense') {
        categoryTotals[tx.category] =
            (categoryTotals[tx.category] ?? 0) + tx.amount;
      }
    }

    final List<ChartData> chartData = categoryTotals.entries
        .map((e) => ChartData(e.key, e.value))
        .toList();

    final totalSpending = provider.totalExpenses;
    final balance = provider.currentBalance;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Row(
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
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top gradient header
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 30,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi there 👋",
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Current Balance",
                            style: TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '\$${balance.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Chart area
                          Expanded(
                            child: chartData.isEmpty
                                ? const Center(
                                    child: Text(
                                      'Add expenses to see breakdown',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  )
                                : SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SizedBox(
                                      width:
                                          chartData.length *
                                          90, // controls scroll width dynamically
                                      child: SfCartesianChart(
                                        plotAreaBorderWidth: 0,
                                        primaryXAxis: CategoryAxis(
                                          axisLine: const AxisLine(width: 0),
                                          labelStyle: const TextStyle(
                                            color: Colors.white70,
                                          ),
                                          labelRotation:
                                              0, // keep text horizontal
                                          interval: 1, // show every label
                                        ),
                                        primaryYAxis: NumericAxis(
                                          isVisible: false,
                                        ),
                                        series: <CartesianSeries>[
                                          ColumnSeries<ChartData, String>(
                                            dataSource: chartData,
                                            xValueMapper: (ChartData data, _) =>
                                                data.category,
                                            yValueMapper: (ChartData data, _) =>
                                                data.amount,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            width: 0.6,
                                            spacing: 0.3,
                                            color: Colors.white.withOpacity(
                                              0.95,
                                            ),
                                            animationDuration: 500,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Summary card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Total Spending",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "\$${totalSpending.toStringAsFixed(2)}",
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.trending_down,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Recent Transactions heading
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Recent Transactions",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // transactions list
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.transactions.length,
                    itemBuilder: (context, index) {
                      final tx = provider.transactions[index];
                      return ListTile(
                        leading: tx.type.toLowerCase() == 'income'
                            ? const Icon(
                                Icons.arrow_downward,
                                color: Colors.green,
                              )
                            : const Icon(Icons.arrow_upward, color: Colors.red),
                        title: Text(tx.description),
                        subtitle: Text(tx.category),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '\$${tx.amount.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await provider.deleteTransaction(tx.id);
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          // optional: open edit sheet
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (_) => AddTransactionSheet(
                              initialData: tx,
                              onAddTransaction: (updated) async {
                                await provider.updateTransaction(updated);
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => AddTransactionSheet(
              onAddTransaction: (newTx) async {
                await provider.addTransaction(newTx);
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
