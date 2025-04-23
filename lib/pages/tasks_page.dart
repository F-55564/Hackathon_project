import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../models/task_model.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final db = DBService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Задания'),
      ),
      body: ListView.builder(
        itemCount: db.tasks.length,
        itemBuilder: (context, index) {
          final task = db.tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text('${task.points} балл(ов)'),
            trailing: task.isCompleted
                ? const Icon(Icons.check, color: Colors.green)
                : ElevatedButton(
              onPressed: () {
                setState(() {
                  db.completeTask(index);
                });
              },
              child: const Text('Выполнить'),
            ),
          );
        },
      ),
    );
  }
}
