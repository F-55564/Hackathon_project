import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PointsProvider extends ChangeNotifier {
  int _points = 0;

  int get points => _points;

  PointsProvider() {
    _loadPoints();
  }

  Future<void> _loadPoints() async {
    final prefs = await SharedPreferences.getInstance();
    _points = prefs.getInt('user_points') ?? 0;
    notifyListeners();
  }

  Future<void> addPoints(int value) async {
    _points += value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_points', _points);
  }

  Future<void> spendPoints(int cost) async {
    if (_points >= cost) {
      _points -= cost;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_points', _points);
    } else {
      debugPrint('Недостаточно баллов для списания.');
    }
  }
}
