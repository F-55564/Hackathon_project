class TaskModel {
  final String title;
  final int points;
  bool isCompleted;

  TaskModel({
    required this.title,
    required this.points,
    this.isCompleted = false,
  });
}
