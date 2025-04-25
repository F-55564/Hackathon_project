import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyProvider with ChangeNotifier {
  int _nomy = 0;

  int get nomy => _nomy;

  CurrencyProvider() {
    _loadNomy();
  }

  Future<void> _loadNomy() async {
    final prefs = await SharedPreferences.getInstance();
    _nomy = prefs.getInt('user_nomy') ?? 0;
    notifyListeners();
  }

  Future<void> addNomy(int amount) async {
    _nomy += amount;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_nomy', _nomy);
  }

  Future<void> spendNomy(int amount) async {
    _nomy -= amount;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_nomy', _nomy);
  }

  Future<void> setNomy(int amount) async {
    _nomy = amount;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_nomy', _nomy);
  }
}