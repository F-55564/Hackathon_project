import '../models/user_model.dart';
import '../models/task_model.dart';

class DBService {
  static final DBService _instance = DBService._internal();

  factory DBService() => _instance;

  DBService._internal();

  UserModel currentUser = UserModel(name: 'Иван Студент');
  List<TaskModel> tasks = [
    TaskModel(title: 'Прийти в колледж', points: 1),
    TaskModel(title: 'Отсидеть все пары', points: 3),
    TaskModel(title: 'Получить хорошую оценку', points: 5),
  ];

  void completeTask(int index) {
    if (!tasks[index].isCompleted) {
      tasks[index].isCompleted = true;
      currentUser.points += tasks[index].points;
    }
  }
}
