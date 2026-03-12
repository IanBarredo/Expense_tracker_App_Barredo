import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

enum ExpenseCategory { food, transport, entertainment, utilities, health, shopping, other }

extension ExpenseCategoryExtension on ExpenseCategory {
  String get label => name[0].toUpperCase() + name.substring(1);

  String get emoji {
    switch (this) {
      case ExpenseCategory.food:          return '🍔';
      case ExpenseCategory.transport:     return '🚗';
      case ExpenseCategory.entertainment: return '🎬';
      case ExpenseCategory.utilities:     return '💡';
      case ExpenseCategory.health:        return '💊';
      case ExpenseCategory.shopping:      return '🛍️';
      case ExpenseCategory.other:         return '📦';
    }
  }
}

@immutable
class Expense {
  final String id;
  final String title;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;

  Expense({
    String? id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  }) : id = id ?? _uuid.v4();

  Expense copyWith({
    String? title,
    double? amount,
    ExpenseCategory? category,
    DateTime? date,
  }) {
    return Expense(
      id: id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
    );
  }

  @override
  bool operator ==(Object other) => other is Expense && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Expense(id: $id, title: $title, amount: $amount, category: $category, date: $date)';
}