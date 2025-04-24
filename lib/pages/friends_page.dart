import 'package:flutter/material.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final List<Map<String, String>> _friends = [];

  final List<Map<String, String>> _availableUsers = [
    {"name": "Эрбол", "image": "https://i.pravatar.cc/150?img=1"},
    {"name": "Умар", "image": "https://i.pravatar.cc/150?img=2"},
    {"name": "Самат", "image": "https://i.pravatar.cc/150?img=3"},
    {"name": "Диана", "image": "https://i.pravatar.cc/150?img=4"},
    {"name": "Айтенир", "image": "https://i.pravatar.cc/150?img=5"},
    {"name": "Сагынай", "image": "https://i.pravatar.cc/150?img=6"},
  ];

  void _addFriend(Map<String, String> user) {
    if (!_friends.any((f) => f['name'] == user['name'])) {
      setState(() {
        _friends.add(user);
      });
    }
  }

  void _showAddFriendDialog() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController _controller = TextEditingController();
        String query = '';
        List<Map<String, String>> suggestions = [];

        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text("Добавить друга"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _controller,
                  autofocus: true,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    hintText: "Введите имя друга",
                    hintStyle: TextStyle(color: Colors.black54),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  onChanged: (value) {
                    query = value.trim();
                    if (query.length >= 2) {
                      suggestions = _availableUsers
                          .where((user) =>
                      user['name']!
                          .toLowerCase()
                          .contains(query.toLowerCase()) &&
                          !_friends.any((f) => f['name'] == user['name']))
                          .toList();
                    } else {
                      suggestions = [];
                    }
                    setState(() {});
                  },
                ),
                const SizedBox(height: 10),
                ...suggestions.map((user) {
                  return ListTile(
                    leading:
                    CircleAvatar(backgroundImage: NetworkImage(user["image"]!)),
                    title: Text(user["name"]!),
                    onTap: () {
                      _addFriend(user);
                      Navigator.of(context).pop();
                    },
                  );
                }).toList(),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Закрыть"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Друзья"),
        backgroundColor: Colors.red.shade900,
      ),
      backgroundColor: Colors.white,
      body: _friends.isEmpty
          ? const Center(
        child: Text(
          "У тебя пока нет друзей 😢",
          style: TextStyle(color: Colors.black54, fontSize: 16),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _friends.length,
        itemBuilder: (context, index) {
          final friend = _friends[index];
          return Card(
            color: Colors.white.withOpacity(0.9),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(friend["image"]!),
              ),
              title: Text(
                friend["name"]!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.message, color: Colors.red),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                        Text('Функция чата пока не реализована')),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: const Icon(Icons.person_add, color: Colors.white),
        onPressed: _showAddFriendDialog,
      ),
    );
  }
}
