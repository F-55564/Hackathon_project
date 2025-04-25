import 'package:flutter/material.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  bool _sortByPoints = true;

  final List<Map<String, dynamic>> students = [
    {'name': 'Самат', 'rank': 'S, Платина', 'points': 120},
    {'name': 'Диана', 'rank': 'A, Золото', 'points': 95},
    {'name': 'Арген', 'rank': 'B, Серебро', 'points': 80},
    {'name': 'Умар', 'rank': 'A, Золото', 'points': 90},
    {'name': 'Тима', 'rank': 'C, Бронзовый', 'points': 60},
    {'name': 'Айтенир', 'rank': 'S, Платина', 'points': 115},
    {'name': 'Алихан', 'rank': 'S, Платина', 'points': 105},
    {'name': 'Сагынай', 'rank': 'S, Платина', 'points': 111},
    {'name': 'Нурик', 'rank': 'C, Бронзовый', 'points': 70},
    {'name': 'Француз', 'rank': 'C, Бронзовый', 'points': 54},
    {'name': 'Назик', 'rank': 'A, Золото', 'points': 78},
    {'name': 'Байтик', 'rank': 'B, Серебро', 'points': 69},
    {'name': 'Жамиль', 'rank': 'B, Серебро', 'points': 55},
    {'name': 'Эрбол', 'rank': 'A, Золото', 'points': 85},
  ];

  @override
  Widget build(BuildContext context) {
    final sorted = [...students];
    sorted.sort((a, b) {
      if (_sortByPoints) {
        return b['points'].compareTo(a['points']);
      } else {
        const rankOrder = {'S': 3, 'A': 2, 'B': 1, 'C': 0};
        return rankOrder[b['rank'].split(',')[0]]!
            .compareTo(rankOrder[a['rank'].split(',')[0]]!);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red.shade800,
        title: const Text('Рейтинг студентов', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.card_giftcard, color: Colors.white),
            onPressed: _showRewardsDialog,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildToggle(),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: sorted.length,
                itemBuilder: (context, index) {
                  final student = sorted[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: _boxDecoration(),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.red.shade800,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(student['name'], style: const TextStyle(color: Colors.black)),
                      subtitle: Text(
                        _sortByPoints
                            ? 'Очки: ${student['points']}'
                            : 'Ранг: ${student['rank']}',
                        style: const TextStyle(color: Colors.black54),
                      ),
                      trailing: index < 3
                          ? const Icon(Icons.emoji_events, color: Colors.amber)
                          : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '🏆 В конце каждого месяца топ-3 получают сезонные награды!',
              style: TextStyle(color: Colors.black87, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ToggleButtons(
          isSelected: [_sortByPoints, !_sortByPoints],
          borderRadius: BorderRadius.circular(12),
          selectedColor: Colors.white,
          fillColor: Colors.red.shade800,
          borderColor: Colors.red.shade800,
          selectedBorderColor: Colors.amber,
          color: Colors.red,
          children: const [
            Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("По очкам")),
            Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("По рангу")),
          ],
          onPressed: (index) {
            setState(() {
              _sortByPoints = index == 0;
            });
          },
        ),
      ],
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.red.shade300, width: 1.5),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          blurRadius: 6,
          spreadRadius: 1,
          offset: const Offset(0, 2),
        )
      ],
    );
  }

  void _showRewardsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Награды месяца', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🥇 Топ 1: Платиновый никнейм', style: TextStyle(color: Colors.amber)),
            SizedBox(height: 8),
            Text('🥈 Топ 2: Кастомизация приложения', style: TextStyle(color: Colors.black)),
            SizedBox(height: 8),
            Text('🥉 Топ 3: Тёмный стиль приложения', style: TextStyle(color: Colors.black)),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
