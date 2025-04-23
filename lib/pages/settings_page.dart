import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Настройки", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red.shade900.withOpacity(0.8),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFFB71C1C),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text("Тёмная тема", style: TextStyle(color: Colors.white)),
            value: _darkMode,
            onChanged: (val) {
              setState(() {
                _darkMode = val;
              });
            },
          ),
          const Divider(color: Colors.white54),
          SwitchListTile(
            title: const Text("Уведомления", style: TextStyle(color: Colors.white)),
            value: _notifications,
            onChanged: (val) {
              setState(() {
                _notifications = val;
              });
              // TODO: Добавить обработку включения/отключения уведомлений
            },
          ),
          const Divider(color: Colors.white54),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.red,
            ),
            onPressed: () {
              // TODO: Добавить логику выхода
              Navigator.pop(context);
            },
            icon: const Icon(Icons.logout),
            label: const Text("Выйти из аккаунта"),
          )
        ],
      ),
    );
  }
}
