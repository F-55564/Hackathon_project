import 'package:flutter/material.dart';
import 'menu_page.dart';
import 'tasks_page.dart';
import 'ranking_page.dart';
import 'raspisanie_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    const MenuPage(),
    const TasksPage(),
    const RankingPage(),
    const SchedulePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.red.shade800, // Активная иконка
        unselectedItemColor: Colors.red.shade300, // Неактивные иконки
        onTap: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главное меню',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Задания',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Рейтинг',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Чат',
          ),
        ],
      ),
    );
  }
}
