import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Map<ExpenseCategory, IconData> _catIcons = {
    ExpenseCategory.food:          Icons.coffee,
    ExpenseCategory.transport:     Icons.directions_car,
    ExpenseCategory.entertainment: Icons.movie,
    ExpenseCategory.utilities:     Icons.bolt,
    ExpenseCategory.health:        Icons.favorite,
    ExpenseCategory.shopping:      Icons.shopping_cart,
    ExpenseCategory.other:         Icons.category,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F0FB),
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, _) {
          final expenses = provider.expenses;

          return Column(
            children: [

              // ── Purple header ──────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 52, 20, 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6C3FC5), Color(0xFF9B5FE3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Label
                    const Text(
                      'TOTAL SPENT',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Total amount
                    Text(
                      '₱${provider.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),

                  ],
                ),
              ),

              // ── Recent header ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'RECENT',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.black45,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      '${expenses.length} entries',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black38,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Expense list ───────────────────────────────────────
              Expanded(
                child: expenses.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.receipt_long_outlined,
                                size: 64, color: Color(0xFFB0A8D8)),
                            SizedBox(height: 16),
                            Text(
                              'No expenses yet',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Tap + Add Expense to get started',
                              style: TextStyle(fontSize: 13, color: Colors.black38),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                        itemCount: expenses.length,
                        itemBuilder: (context, index) {
                          final expense = expenses[index];
                          return _ExpenseTile(
                            expense: expense,
                            icon: _catIcons[expense.category] ?? Icons.category,
                            onEdit: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddExpenseScreen(existing: expense),
                              ),
                            ),
                            onDelete: () => provider.deleteExpense(expense.id),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),

      // ── Bottom Add Expense button ──────────────────────────────────
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C3FC5),
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.add, size: 20),
            label: const Text(
              'Add Expense',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Expense tile ──────────────────────────────────────────────────────────────
class _ExpenseTile extends StatelessWidget {
  final Expense      expense;
  final IconData     icon;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ExpenseTile({
    required this.expense,
    required this.icon,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Category icon box
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F0FB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF6C3FC5), size: 22),
          ),
          const SizedBox(width: 14),

          // Title — no date
          Expanded(
            child: Text(
              expense.title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),

          // Amount
          Text(
            '₱${expense.amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 10),

          // Edit icon
          GestureDetector(
            onTap: onEdit,
            child: const Icon(Icons.edit_outlined,
                color: Color(0xFF6C3FC5), size: 18),
          ),
          const SizedBox(width: 8),

          // Delete icon
          GestureDetector(
            onTap: onDelete,
            child: const Icon(Icons.delete_outline,
                color: Colors.redAccent, size: 18),
          ),
        ],
      ),
    );
  }
}