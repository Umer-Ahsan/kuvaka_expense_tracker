import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kuvaka_expense_tracker/constants/colors.dart';
import 'package:kuvaka_expense_tracker/constants/styles.dart';
import 'package:kuvaka_expense_tracker/features/budget/view/budget_screen.dart';
import 'package:kuvaka_expense_tracker/features/budget/viewmodel/budget_provider.dart';
import 'package:kuvaka_expense_tracker/features/transactions/widgets/no_transaction_widget.dart';
import 'package:kuvaka_expense_tracker/features/transactions/widgets/transaction_tile_widget.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../model/chart_data_model.dart';
import '../viewmodel/transaction_provider.dart';
import '../widgets/add_transaction_sheet.dart';
import '../../shared/viewmodel/theme_provider.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);

    final Map<String, double> categoryTotals = {};
    for (var tx in provider.transactions) {
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kuvaka Expense Tracker',
                    style: AppStyles.f24w600.copyWith(color: Colors.white),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Dark Mode",
                        style: AppStyles.f16w400.copyWith(color: Colors.white),
                      ),
                      CupertinoSwitch(
                        value: Provider.of<ThemeProvider>(context).isDarkMode,
                        activeTrackColor: Colors.white,
                        inactiveTrackColor: Colors.grey,
                        onChanged: (_) {
                          context.read<ThemeProvider>().toggleTheme();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.account_balance_wallet,
                color: AppColors.primaryColor,
              ),
              title: const Text('Budgets', style: AppStyles.f16w400),
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const BudgetScreen()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Transactions', style: AppStyles.f20w500),
      ),
      body: provider.transactions.isEmpty
          ? const NoTransactionWidget()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------- Top Header with Chart ----------
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
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
                            style: AppStyles.f20w600.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Current Balance",
                            style: AppStyles.f14w400.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '\$${balance.toStringAsFixed(2)}',
                            style: AppStyles.f32w500.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: chartData.isEmpty
                                ? Center(
                                    child: Text(
                                      'Add expenses to see breakdown graph',
                                      style: AppStyles.f14w400.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : Consumer<BudgetProvider>(
                                    builder: (context, budgetProvider, _) {
                                      return SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: SizedBox(
                                          width: chartData.length * 90,
                                          child: SfCartesianChart(
                                            plotAreaBorderWidth: 0,
                                            primaryXAxis: CategoryAxis(
                                              axisLine: const AxisLine(
                                                width: 0,
                                              ),
                                              majorGridLines:
                                                  const MajorGridLines(
                                                    width: 0,
                                                  ),
                                              majorTickLines:
                                                  const MajorTickLines(
                                                    width: 0,
                                                  ),
                                              labelStyle: const TextStyle(
                                                color: Colors.white70,
                                              ),
                                              labelRotation: 0,
                                              interval: 1,
                                            ),
                                            primaryYAxis: NumericAxis(
                                              isVisible: false,
                                              axisLine: const AxisLine(
                                                width: 0,
                                              ),
                                            ),
                                            series: <CartesianSeries>[
                                              ColumnSeries<ChartData, String>(
                                                dataSource: chartData,
                                                xValueMapper:
                                                    (ChartData data, _) =>
                                                        data.category,
                                                yValueMapper:
                                                    (ChartData data, _) =>
                                                        data.amount,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                width: 0.4,
                                                spacing: 0.3,
                                                pointColorMapper: (ChartData data, _) {
                                                  final ratio = budgetProvider
                                                      .budgetUsageRatio(
                                                        data.category,
                                                        data.amount,
                                                      );

                                                  if (ratio >= 1.0) {
                                                    return Colors
                                                        .redAccent; // Over budget
                                                  } else if (ratio >= 0.8) {
                                                    return Colors
                                                        .orangeAccent; // Near limit
                                                  }
                                                  return Colors.white
                                                      .withOpacity(
                                                        0.9,
                                                      ); // Normal
                                                },
                                                animationDuration: 500,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // ---------- Summary Card ----------
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
                                style: AppStyles.f14w500,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "\$${totalSpending.toStringAsFixed(2)}",
                                style: AppStyles.f20w600.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
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
                  // ---------- Recent Transactions ----------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Recent Transactions",
                      style: AppStyles.f20w500.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // ---------- Transactions List ----------
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: provider.transactions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final tx = provider.transactions[index];

                      return Slidable(
                        key: ValueKey(tx.id),
                        endActionPane: ActionPane(
                          motion: const BehindMotion(),
                          extentRatio: 0.25,
                          children: [
                            CustomSlidableAction(
                              onPressed: (_) async {
                                final deletedTx = tx;
                                await provider.deleteTransaction(tx.id);
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      "Transaction deleted",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: AppColors.primaryColor,
                                    behavior: SnackBarBehavior.floating,
                                    duration: const Duration(seconds: 5),
                                    action: SnackBarAction(
                                      label: 'Undo',
                                      textColor: Colors.white,
                                      onPressed: () async {
                                        await provider.addTransaction(
                                          deletedTx,
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                              backgroundColor: Colors.redAccent,
                              borderRadius: BorderRadius.circular(16),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        child: TransactionTile(
                          tx: tx,
                          onTap: () {
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
                        ),
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
