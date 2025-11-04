import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String description;

  @HiveField(2)
  double amount;

  @HiveField(3)
  String category;

  @HiveField(4)
  DateTime date;

  @HiveField(5)
  String type; // 'income' or 'expense'

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
  });
}
