import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/expense_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
      ],
      child: const SpendrApp(),
    ),
  );
}

class SpendrApp extends StatelessWidget {
  const SpendrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        scaffoldBackgroundColor: const Color(0xFFF2F0FB),
        primaryColor: const Color(0xFF6C3FC5),
        fontFamily: 'sans-serif',
      ),
      home: const HomeScreen(),
    );
  }
}