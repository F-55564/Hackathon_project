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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Настройки", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red.shade800,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text("Тёмная тема", style: TextStyle(color: Colors.black)),
            value: _darkMode,
            activeColor: Colors.red.shade800,
            onChanged: (val) {
              setState(() {
                _darkMode = val;
              });
            },
          ),
          const Divider(color: Colors.black26),
          SwitchListTile(
            title: const Text("Уведомления", style: TextStyle(color: Colors.black)),
            value: _notifications,
            activeColor: Colors.red.shade800,
            onChanged: (val) {
              setState(() {
                _notifications = val;
              });
            },
          ),
          const Divider(color: Colors.black26),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade800,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
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
