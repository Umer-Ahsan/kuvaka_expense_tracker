import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:kuvaka_expense_tracker/features/transactions/view/transaction_screen.dart';
import 'package:kuvaka_expense_tracker/features/transactions/model/transaction_model.dart';
import 'package:kuvaka_expense_tracker/features/transactions/viewmodel/transaction_provider.dart';
import 'package:kuvaka_expense_tracker/features/shared/viewmodel/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  late Box<Transaction> box;

  setUp(() async {
    await setUpTestHive();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TransactionAdapter());
    }

    box = await Hive.openBox<Transaction>('transactions');
  });

  tearDown(() async {
    // Close and delete boxes explicitly to kill Hive isolates
    if (box.isOpen) {
      await box.clear();
      await box.close();
    }
    await Hive.deleteFromDisk();
    await Hive.close();
    await tearDownTestHive();
  });

  Widget buildTestableWidget(Widget child) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => TransactionProvider(testBox: box),
        ),
      ],
      child: MaterialApp(home: child),
    );
  }

  testWidgets('Shows NoTransactionWidget when there are no transactions', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestableWidget(const TransactionsScreen()));
    await tester.pumpAndSettle();

    expect(find.textContaining('No'), findsWidgets);

    // Give any pending microtasks time to complete
    await tester.idle();
  });

  testWidgets('Shows transaction list when transactions are available', (
    tester,
  ) async {
    final tx = Transaction(
      id: '1',
      amount: 50,
      type: 'expense',
      description: 'Coffee',
      category: 'Food',
      date: DateTime.now(),
    );
    await box.put(tx.id, tx);

    await tester.pumpWidget(buildTestableWidget(const TransactionsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Recent Transactions'), findsOneWidget);
    await tester.idle();
  });

  testWidgets('Opens AddTransactionSheet when FAB is tapped', (tester) async {
    await tester.pumpWidget(buildTestableWidget(const TransactionsScreen()));
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.textContaining('Add'), findsWidgets);
    await tester.idle();
  });
}
