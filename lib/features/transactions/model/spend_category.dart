class SpendCategory {
  final String name;
  final int color; // optional (hex value)

  const SpendCategory({required this.name, required this.color});
}

const List<SpendCategory> spendCategories = [
  SpendCategory(name: 'Food', color: 0xFFFFB74D),
  SpendCategory(name: 'Transport', color: 0xFF64B5F6),
  SpendCategory(name: 'Shopping', color: 0xFFBA68C8),
  SpendCategory(name: 'Bills', color: 0xFFFF8A65),
  SpendCategory(name: 'Entertainment', color: 0xFF81C784),
];
