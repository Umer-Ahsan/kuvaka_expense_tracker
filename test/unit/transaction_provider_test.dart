import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kuvaka_expense_tracker/features/transactions/model/transaction_model.dart';
import 'package:kuvaka_expense_tracker/features/transactions/viewmodel/transaction_provider.dart';

// 👇 Generate the mock class
@GenerateMocks([Box])
import 'transaction_provider_test.mocks.dart';

void main() {
  late MockBox<Transaction> mockBox;
  late TransactionProvider provider;

  setUp(() {
    mockBox = MockBox<Transaction>();

    // 👇 Very important — stub values before provider is created
    when(mockBox.values).thenReturn([]);

    // Use testBox constructor for testing
    provider = TransactionProvider(testBox: mockBox);
  });

  group('TransactionProvider Tests', () {
    test('should add a transaction', () async {
      final tx = Transaction(
        id: '1',
        amount: 100,
        type: 'income',
        description: 'Salary',
        category: 'Job',
        date: DateTime.now(),
      );

      // Mock Hive box methods
      when(mockBox.put(any, any)).thenAnswer((_) async => {});
      when(mockBox.values).thenReturn([tx]);

      await provider.addTransaction(tx);

      expect(provider.transactions.length, 1);
      expect(provider.transactions.first.amount, 100);
    });

    test('should delete a transaction', () async {
      final tx = Transaction(
        id: '1',
        amount: 50,
        type: 'expense',
        description: 'Food',
        category: 'Food',
        date: DateTime.now(),
      );

      when(mockBox.delete(any)).thenAnswer((_) async => {});
      when(mockBox.values).thenReturn([]);

      await provider.deleteTransaction('1');

      expect(provider.transactions.isEmpty, true);
    });

    test('should update a transaction', () async {
      final tx = Transaction(
        id: '1',
        amount: 75,
        type: 'expense',
        description: 'Groceries',
        category: 'Food',
        date: DateTime.now(),
      );

      when(mockBox.put(any, any)).thenAnswer((_) async => {});
      when(mockBox.values).thenReturn([tx]);

      await provider.updateTransaction(tx);

      expect(provider.transactions.first.amount, 75);
      verify(mockBox.put(tx.id, tx)).called(1);
    });

    test('should calculate total income and expense correctly', () async {
      final tx1 = Transaction(
        id: '1',
        amount: 100,
        type: 'income',
        description: 'Salary',
        category: 'Job',
        date: DateTime.now(),
      );
      final tx2 = Transaction(
        id: '2',
        amount: 40,
        type: 'expense',
        description: 'Food',
        category: 'Food',
        date: DateTime.now(),
      );

      when(mockBox.values).thenReturn([tx1, tx2]);

      // Force internal transaction list
      provider = TransactionProvider(testBox: mockBox);

      expect(provider.totalIncome, 100);
      expect(provider.totalExpenses, 40);
      expect(provider.currentBalance, 60);
    });
  });
}
