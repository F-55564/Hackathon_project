class UserModel {
  final String name;
  int points;
  int rank;

  UserModel({
    required this.name,
    this.points = 0,
    this.rank = 0,
  });
}
