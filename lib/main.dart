import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kuvaka_expense_tracker/constants/themes.dart';
import 'package:kuvaka_expense_tracker/features/shared/viewmodel/theme_provider.dart';
import 'package:kuvaka_expense_tracker/features/transactions/model/transaction_model.dart';
import 'package:kuvaka_expense_tracker/features/transactions/view/transaction_screen.dart';
import 'package:kuvaka_expense_tracker/features/transactions/viewmodel/transaction_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox<Transaction>('transactions');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
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
