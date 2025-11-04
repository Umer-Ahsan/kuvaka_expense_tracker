import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kuvaka_expense_tracker/constants/themes.dart';
import 'package:kuvaka_expense_tracker/features/budget/model/budget_model.dart';
import 'package:kuvaka_expense_tracker/features/budget/viewmodel/budget_provider.dart';
import 'package:kuvaka_expense_tracker/features/shared/viewmodel/theme_provider.dart';
import 'package:kuvaka_expense_tracker/features/transactions/model/transaction_model.dart';
import 'package:kuvaka_expense_tracker/features/transactions/view/transaction_screen.dart';
import 'package:kuvaka_expense_tracker/features/transactions/viewmodel/transaction_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(TransactionAdapter());
    Hive.registerAdapter(BudgetAdapter());
  }

  await Hive.openBox<Budget>(BudgetProvider.boxName);
  await Hive.openBox<Transaction>(TransactionProvider.boxName);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => BudgetProvider()),
      ],
      child: kDebugMode
          ? DevicePreview(enabled: true, builder: (context) => const MyApp())
          : const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context).themeMode;
    return MaterialApp(
      title: 'Kuvaka Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.getLightTheme(),
      darkTheme: AppThemes.getDarkTheme(),
      themeMode: themeProvider,
      home: const TransactionsScreen(),
    );
  }
}
