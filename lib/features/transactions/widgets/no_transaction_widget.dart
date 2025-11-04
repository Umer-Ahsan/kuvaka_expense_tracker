import 'package:flutter/material.dart';
import 'package:kuvaka_expense_tracker/constants/styles.dart';

class NoTransactionWidget extends StatelessWidget {
  const NoTransactionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 100,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
            ),
            const SizedBox(height: 20),
            Text(
              "No transactions yet!",
              style: AppStyles.f24w600.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Start by adding your first income to see your balance grow 📈",
              textAlign: TextAlign.center,
              style: AppStyles.f12w400.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
