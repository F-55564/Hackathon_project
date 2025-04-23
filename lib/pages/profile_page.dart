import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../point_providers.dart';
import 'login_page.dart';
import 'settings_page.dart';
import 'friends_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final int currentPoints = context.watch<PointsProvider>().points;
    final bool isMaxLevel = currentPoints >= 200;
    final (int lowerBound, int upperBound) = _getNextRankThreshold(currentPoints);
    final int pointsThisLevel = currentPoints - lowerBound;
    final int pointsRequired = upperBound - lowerBound;

    final List<String> tips = [
      "Делай перерывы каждые 50 минут, чтобы мозг не уставал.",
      "Учись регулярно, а не в последний момент.",
      "Записывай важные идеи — они быстро забываются.",
      "Здоровый сон — залог успешного дня.",
      "Пей достаточно воды в течение дня.",
      "Оставь время на отдых после учёбы.",
      "Задавай вопросы — это ускоряет понимание.",
      "Повторяй материал вслух — это улучшает запоминание.",
      "Организуй рабочее место для концентрации.",
      "Изучи хотя бы одно новое слово в день.",
    ];
    final String tipOfDay = (tips..shuffle()).first;

    return Scaffold(
      backgroundColor: const Color(0xFFB71C1C),
      appBar: AppBar(
        backgroundColor: Colors.red.shade900.withOpacity(0.8),
        title: const Text("Профиль", style: TextStyle(color: Colors.white)),
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 250,
                  height: 250,
                  decoration: _boxDecoration(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/image/profile.png'),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Иван Студент',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.8),
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Выйти'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 250,
                    decoration: _boxDecoration(),
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                _getRankImage(currentPoints),
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        isMaxLevel
                            ? const Text(
                          'Max lvl',
                          style: TextStyle(color: Colors.yellow, fontSize: 16, fontWeight: FontWeight.bold),
                        )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.star, color: Colors.yellow, size: 20),
                            const SizedBox(width: 4),
                            const Text('Очки: ',
                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                            const SizedBox(width: 4),
                            Text('$currentPoints / $upperBound',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        if (!isMaxLevel)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: LinearProgressIndicator(
                              value: pointsRequired == 0 ? 1.0 : (pointsThisLevel / pointsRequired),
                              backgroundColor: Colors.white.withOpacity(0.3),
                              color: Colors.white,
                            ),
                          ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildStats(),
            const SizedBox(height: 20),
            _buildCalendar(),
            const SizedBox(height: 20),
            _buildTipOfDay(tipOfDay),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<PointsProvider>().addPoints(10);
                },
                child: const Text('Получить 10 очков'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.red.shade900.withOpacity(0.95),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.red,
            ),
            child: Text('Меню', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.white),
            title: const Text('Профиль', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.group, color: Colors.white),
            title: const Text('Друзья', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FriendsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            title: const Text('Настройки', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
            },
          ),
        ],
      ),
    );
  }

  String _getRankImage(int currentPoints) {
    if (currentPoints >= 150) {
      return 'assets/image/platinum.png';
    } else if (currentPoints >= 80) {
      return 'assets/image/gold.png';
    } else if (currentPoints >= 30) {
      return 'assets/image/silver.png';
    } else {
      return 'assets/image/bronze.png';
    }
  }

  (int, int) _getNextRankThreshold(int points) {
    final List<int> thresholds = [0, 30, 80, 150, 200];
    for (int i = 0; i < thresholds.length - 1; i++) {
      if (points < thresholds[i + 1]) {
        return (thresholds[i], thresholds[i + 1]);
      }
    }
    return (200, 200); // Max level
  }

  Widget _buildStats() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Статистика активности',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatBox("Сегодня", "3ч 45м"),
              _buildStatBox("Вчера", "5ч 10м"),
              _buildStatBox("За месяц", "92ч 20м"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Календарь активности',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 10),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: DateTime.now(),
            calendarFormat: CalendarFormat.month,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
              rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
            ),
            calendarStyle: CalendarStyle(
              defaultTextStyle: const TextStyle(color: Colors.greenAccent),
              weekendTextStyle: const TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
              outsideTextStyle: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipOfDay(String tip) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, spreadRadius: 2),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline, color: Colors.orange, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _boxDecoration().copyWith(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: const Color(0xCCe53935),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white, width: 2),
      boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.6), blurRadius: 10, spreadRadius: 2)],
    );
  }
}
