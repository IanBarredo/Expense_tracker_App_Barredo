import 'package:flutter/foundation.dart';
import '../models/expense.dart';

class ExpenseProvider extends ChangeNotifier {
  // ── Seed data ──────────────────────────────────────────────────────────────
  final List<Expense> _expenses = [
    Expense(
      title: 'Netflix',
      amount: 15.99,
      category: ExpenseCategory.entertainment,
      date: DateTime(2025, 3, 3),
    ),
    Expense(
      title: 'Coffee Shop',
      amount: 12.75,
      category: ExpenseCategory.food,
      date: DateTime(2025, 3, 9),
    ),
  ];

  // ── READ ───────────────────────────────────────────────────────────────────

  /// Returns an unmodifiable view of all expenses.
  List<Expense> get expenses => List.unmodifiable(_expenses);

  /// Returns the expense with [id], or null if not found.
  Expense? getById(String id) {
    try {
      return _expenses.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Total amount across all expenses.
  double get total => _expenses.fold(0, (sum, e) => sum + e.amount);

  /// Average amount per expense.
  double get average => _expenses.isEmpty ? 0 : total / _expenses.length;

  /// Expenses filtered by [category].
  List<Expense> byCategory(ExpenseCategory category) =>
      _expenses.where((e) => e.category == category).toList();

  // ── WRITE (create) ─────────────────────────────────────────────────────────

  /// Adds a new [expense] to the list and notifies listeners.
  void addExpense(Expense expense) {
    _expenses.insert(0, expense);
    notifyListeners();
  }

  // ── EDIT (update) ──────────────────────────────────────────────────────────

  /// Replaces the expense matching [updated.id] and notifies listeners.
  /// Does nothing if no matching expense is found.
  void editExpense(Expense updated) {
    final index = _expenses.indexWhere((e) => e.id == updated.id);
    if (index == -1) return;
    _expenses[index] = updated;
    notifyListeners();
  }

  // ── DELETE ─────────────────────────────────────────────────────────────────

  /// Removes the expense with [id] and notifies listeners.
  void deleteExpense(String id) {
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  /// Removes all expenses and notifies listeners.
  void clearAll() {
    _expenses.clear();
    notifyListeners();
  }
}