import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/add_habit_screen.dart';
import 'screens/edit_habit_screen.dart';
import 'screens/habit_history_screen.dart';
import 'providers/habit_provider.dart'; // ต้อง import HabitProvider

void main() {
  runApp(
    ChangeNotifierProvider<HabitProvider>( // ระบุประเภทให้ชัดเจน
      create: (context) => HabitProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/add-habit': (context) => AddHabitScreen(),
        '/edit-habit': (context) => EditHabitScreen(),
        '/habit-history': (context) => HabitHistoryScreen(),
      },
    );
  }
}