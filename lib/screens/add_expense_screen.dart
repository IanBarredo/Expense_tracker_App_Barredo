import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? existing;
  const AddExpenseScreen({super.key, this.existing});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey   = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _amountCtrl;
  late ExpenseCategory _category;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _titleCtrl  = TextEditingController(text: widget.existing?.title ?? '');
    _amountCtrl = TextEditingController(
      text: widget.existing != null
          ? widget.existing!.amount.toStringAsFixed(2)
          : '',
    );
    _category = widget.existing?.category ?? ExpenseCategory.other;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<ExpenseProvider>();
    final amount   = double.parse(_amountCtrl.text);

    if (_isEditing) {
      provider.editExpense(widget.existing!.copyWith(
        title:    _titleCtrl.text.trim(),
        amount:   amount,
        category: _category,
      ));
    } else {
      provider.addExpense(Expense(
        title:    _titleCtrl.text.trim(),
        amount:   amount,
        category: _category,
        date:     DateTime.now(),
      ));
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F0FB),
      body: SafeArea(
        child: Column(
          children: [

            // ── Purple header ───────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6C3FC5), Color(0xFF9B5FE3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.add_circle_outline, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isEditing ? 'Edit Expense' : 'New Expense',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Text(
                        'Fill in the details below',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Form ────────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Title field
                      const Text(
                        'Expense title',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _titleCtrl,
                        decoration: InputDecoration(
                          hintText: 'e.g. Coffee, Groceries, Rent...',
                          hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
                          prefixIcon: const Icon(Icons.receipt_long_outlined,
                              color: Color(0xFF6C3FC5), size: 20),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF6C3FC5), width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF6C3FC5), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color(0xFF6C3FC5), width: 2),
                          ),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Please enter a title'
                            : null,
                      ),
                      const SizedBox(height: 20),

                      // Amount field
                      const SizedBox(height: 0),
                      TextFormField(
                        controller: _amountCtrl,
                        decoration: InputDecoration(
                          hintText: 'Amount',
                          hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 14, right: 4),
                            child: Text(
                              '₱',
                              style: TextStyle(
                                color: Color(0xFF6C3FC5),
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF6C3FC5), width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE0D6F5), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color(0xFF6C3FC5), width: 1.5),
                          ),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Please enter an amount';
                          final n = double.tryParse(v);
                          if (n == null || n <= 0) return 'Enter a valid amount';
                          return null;
                        },
                      ),

                      const Spacer(),

                      // Save button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C3FC5),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.save_outlined, size: 18),
                          label: const Text(
                            'Save Expense',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Cancel button
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}