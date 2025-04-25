import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../point_providers.dart';

class TaskModel {
  String title;
  int points;
  bool isCompleted;

  TaskModel({required this.title, required this.points, this.isCompleted = false});
}

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final List<TaskModel> tasks = [
    TaskModel(title: "Проведи 30 минут в коворкинге", points: 10),
    TaskModel(title: "Прочитай статью на интересную тему", points: 10),
    TaskModel(title: "Поделись идеей проекта с другом", points: 15),
    TaskModel(title: "Найди 3 ресурса по своей теме и запиши", points: 10),
    TaskModel(title: "Сделай скрин рабочего процесса", points: 15),
    TaskModel(title: "Посети мастер-класс или лекцию", points: 20),
    TaskModel(title: "Запланируй день с Notion / тетрадью", points: 10),
    TaskModel(title: "Соберись с друзьями и обсуди идеи", points: 15),
    TaskModel(title: "Нарисуй майндмап для проекта", points: 15),
    TaskModel(title: "Познакомься с новым человеком в колледже", points: 10),
  ];

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadTaskStates();
  }

  Future<void> _loadTaskStates() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < tasks.length; i++) {
      tasks[i].isCompleted = prefs.getBool('task_$i') ?? false;
    }
    setState(() {});
  }

  Future<void> _confirmTask(TaskModel task, int index, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final pointsProvider = Provider.of<PointsProvider>(context, listen: false);

    if (!task.isCompleted) {
      task.isCompleted = true;
      await prefs.setBool('task_$index', true);
      await pointsProvider.addPoints(task.points);
      setState(() {});
    }
  }

  Future<void> _showConfirmationDialog(TaskModel task, int index) async {
    final TextEditingController _textController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Как подтвердить задание?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    await _confirmTask(task, index, context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.white,
                        content: Text(
                          "Задание '${task.title}' подтверждено фото!",
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.photo),
                label: const Text("Подтвердить фото"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _textController,
                maxLines: 3,
                style: const TextStyle(color: Colors.red),
                decoration: const InputDecoration(
                  hintText: "Опиши выполнение задания",
                  hintStyle: TextStyle(color: Colors.red),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () async {
                  if (_textController.text.trim().isNotEmpty) {
                    await _confirmTask(task, index, context);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.white,
                        content: Text(
                          "Задание '${task.title}' подтверждено текстом!",
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.check),
                label: const Text("Подтвердить текстом"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                ),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red.shade800,
        title: const Text("Задания", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${task.points} балл(ов)", style: const TextStyle(color: Colors.red)),
                    task.isCompleted
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : ElevatedButton.icon(
                      onPressed: () => _showConfirmationDialog(task, index),
                      icon: const Icon(Icons.check),
                      label: const Text("Подтвердить"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
