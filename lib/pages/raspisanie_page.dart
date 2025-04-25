import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  String? _selectedGroup;
  final List<String> _groups = ['CS-1-22', 'CS-2-22', 'CS-3-22'];

  final List<String> _times = [
    '08:00', '09:00', '10:00', '11:00',
    '12:20', '13:20', '14:20', '15:20',
    '16:20', '17:20',
  ];

  final Map<String, Map<String, List<String>>> _schedule = {
    'CS-1-22': {
      'Понедельник': ['JAVA-программирование', 'JAVA-программирование'],
      'Вторник': ['Инфосистемы в сети', 'Инфосистемы в сети'],
      'Среда': ['JAVA-программирование', 'Инфосистемы в сети', 'Веб-приложения', 'Веб-приложения'],
      'Четверг': ['Инфосистемы в сети', 'Инфосистемы в сети'],
      'Пятница': ['Инфосистемы в сети', 'Инфосистемы в сети'],
      'Суббота': List.filled(10, 'Frontend-разработка'),
    },
    'CS-2-22': {
      'Понедельник': ['Backend-разработка', 'Backend-разработка'],
      'Вторник': ['JAVA-программирование', 'JAVA-программирование', 'Backend-разработка', 'Backend-разработка'],
      'Среда': [
        'JAVA-программирование', 'JAVA-программирование',
        'Инфокоммуникационные системы и сети ', 'Инфокоммуникационные системы и сети ',
        'Backend-разработка', 'Backend-разработка',
      ],
      'Четверг': ['Инфокоммуникационные системы и сети ', 'Инфокоммуникационные системы и сети ', 'Backend-разработка', 'Backend-разработка'],
      'Пятница': ['Backend-разработка'],
      'Суббота': List.filled(10, 'Frontend-разработка, Технология разработки мобильных приложений'),
    },
    'CS-3-22': {
      'Понедельник': [],
      'Вторник': [],
      'Среда': [],
      'Четверг': [],
      'Пятница': ['JAVA-программирование', 'JAVA-программирование', 'Инфосистемы в сети', 'Инфосистемы в сети'],
      'Суббота': List.filled(10, 'Frontend-разработка'),
    }
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red.shade800,
        title: const Text('Расписание', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedGroup,
              hint: const Text('Выберите группу'),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.red.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: _groups.map((group) {
                return DropdownMenuItem(
                  value: group,
                  child: Text(group),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGroup = value;
                });
              },
            ),
            const SizedBox(height: 40),
            if (_selectedGroup == null)
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/image/logo_raspisanie.png',
                    width: 400,
                    height: 400,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            if (_selectedGroup != null)
              Expanded(
                child: ListView(
                  children: _schedule[_selectedGroup]!.entries.map((entry) {
                    final day = entry.key;
                    final lessons = entry.value;

                    final shortDay = {
                      'Понедельник': 'Пн',
                      'Вторник': 'Вт',
                      'Среда': 'Ср',
                      'Четверг': 'Чт',
                      'Пятница': 'Пт',
                      'Суббота': 'Сб',
                    }[day] ?? '';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(shortDay, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                            ),
                            Text(day, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (lessons.isEmpty)
                          Card(
                            color: Colors.red.shade50,
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: const ListTile(
                              leading: Icon(Icons.info_outline, color: Colors.red),
                              title: Text('Пары в этот день отсутствуют', style: TextStyle(color: Colors.red)),
                            ),
                          )
                        else
                          ...List.generate(lessons.length, (index) {
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                leading: Icon(Icons.access_time, color: Colors.red.shade800),
                                title: Text('${_times[index]} — ${lessons[index]}'),
                              ),
                            );
                          }),
                        const SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
