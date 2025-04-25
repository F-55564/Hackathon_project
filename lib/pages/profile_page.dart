import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../point_providers.dart';
import '../providers/currency_provider.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'menu_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _avatarImage;
  final ImagePicker _picker = ImagePicker();
  List<String> ownedFrames = [];
  String? selectedFrame;
  String? _profileLogin;

  @override
  void initState() {
    super.initState();
    _loadAvatar();
    _loadFrame();
    _loadProfileLogin();
  }

  Future<void> _loadProfileLogin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileLogin = prefs.getString('profile_login') ?? '';
    });
  }

  Future<void> _loadAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('avatar_path');
    if (path != null) {
      setState(() {
        _avatarImage = File(path);
      });
    }
  }

  Future<void> _loadFrame() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedFrame = prefs.getString('selected_frame');
      ownedFrames = prefs.getStringList('owned_frames') ?? [];
    });
  }

  Future<void> _changeAvatar() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              child: Text('Изменить аватар', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('avatar_path', image.path);
                    setState(() {
                      _avatarImage = File(image.path);
                    });
                  }
                },
                icon: Icon(Icons.photo, color: Colors.white),
                label: Text("Выбрать из галереи", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  minimumSize: Size(double.infinity, 48),
                  elevation: 2,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () async {
                  Navigator.pop(context);
                  final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                  if (photo != null) {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('avatar_path', photo.path);
                    setState(() {
                      _avatarImage = File(photo.path);
                    });
                  }
                },
                icon: Icon(Icons.camera_alt, color: Colors.white),
                label: Text("Сделать фото", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  minimumSize: Size(double.infinity, 48),
                  elevation: 2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _changeFrame() async {
    if (ownedFrames.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('У вас нет купленных рамок.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Выберите рамку"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ownedFrames.map((framePath) {
              return ListTile(
                leading: Image.asset(framePath, width: 40, height: 40),
                title: Text(framePath.split('/').last),
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('selected_frame', framePath);
                  setState(() {
                    selectedFrame = framePath;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int currentPoints = context.watch<PointsProvider>().points;
    final bool isMaxLevel = currentPoints >= 200;
    final (int lowerBound, int upperBound) = _getNextRankThreshold(currentPoints);
    final int pointsThisLevel = currentPoints - lowerBound;
    final int pointsRequired = upperBound - lowerBound;

    final int currentNomy = context.watch<CurrencyProvider>().nomy;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.red.shade800,
          title: const Text("Профиль", style: TextStyle(color: Colors.white)),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                children: [
                  Icon(Icons.monetization_on, color: Colors.amber.shade700, size: 28),
                  const SizedBox(width: 4),
                  Text(
                    '$currentNomy',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      shadows: [Shadow(color: Colors.black54, blurRadius: 2)],
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    tooltip: 'Выйти',
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),

        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 250,
                    height: 250,
                    decoration: _boxDecoration(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: _avatarImage != null
                                  ? FileImage(_avatarImage!)
                                  : const AssetImage('assets/image/profile.png') as ImageProvider,
                            ),
                            if (selectedFrame != null)
                              Image.asset(selectedFrame!, width: 110, height: 110),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _profileLogin ?? '',
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
  onPressed: _changeAvatar,
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: Colors.red,
    shadowColor: Colors.red.shade100,
    minimumSize: Size(120, 38),
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
      side: BorderSide(color: Colors.red.shade900, width: 2),
    ),
    elevation: 2,
    textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
  ).copyWith(
    overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
      if (states.contains(MaterialState.hovered)) {
        return Colors.red.withOpacity(0.08);
      }
      return null;
    }),
  ),
  child: Text('Изменить аватар'),
),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _changeFrame,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.red.shade900,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                              side: BorderSide(color: Colors.red.shade900, width: 2),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          child: const Text('Изменить рамку'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 250,
                      decoration: _boxDecoration(),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                _getRankImage(currentPoints),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 2,
                              left: 0,
                              right: 0,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_getRankName(currentPoints).isNotEmpty)
                                    Text(
                                      _getRankName(currentPoints),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 9,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black,
                                            blurRadius: 2,
                                            offset: Offset(1, 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  const SizedBox(height: 4),
                                  Text(
                                    isMaxLevel ? '$currentPoints очков' : '$currentPoints / $upperBound',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black,
                                          blurRadius: 2,
                                          offset: Offset(1, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (!isMaxLevel) ...[
                                    const SizedBox(height: 4),
                                    Center(
                                      child: SizedBox(
                                        width: 120,
                                        height: 4,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(2),
                                          child: LinearProgressIndicator(
                                            value: pointsRequired == 0 ? 1.0 : (pointsThisLevel / pointsRequired),
                                            backgroundColor: Colors.white.withAlpha(77),
                                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.yellow),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildStats(),
              const SizedBox(height: 20),
              _buildCalendar(),
              const SizedBox(height: 20),
              _buildTipOfDay(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<PointsProvider>().addPoints(10);
                    },
                    child: const Text('Получить 10 очков'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CurrencyProvider>().addNomy(10);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade100,
                      foregroundColor: Colors.amber.shade900,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.monetization_on, color: Colors.amber.shade700),
                        const SizedBox(width: 8),
                        const Text('Получить 10 номов'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRankImage(int currentPoints) {
    if (currentPoints >= 150) return 'assets/image/platinum.png';
    if (currentPoints >= 80) return 'assets/image/gold.png';
    if (currentPoints >= 30) return 'assets/image/silver.png';
    return 'assets/image/bronze.png';
  }

  String _getRankName(int currentPoints) {
    if (currentPoints >= 150) return '';
    if (currentPoints >= 80) return '';
    if (currentPoints >= 30) return '';
    return '';
  }

  (int, int) _getNextRankThreshold(int points) {
    final thresholds = [0, 30, 80, 150, 200];
    for (int i = 0; i < thresholds.length - 1; i++) {
      if (points < thresholds[i + 1]) {
        return (thresholds[i], thresholds[i + 1]);
      }
    }
    return (200, 200);
  }

  Widget _buildStats() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Статистика активности', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatBox("Сегодня", "3ч 45м"),
              _buildStatBox("Вчера", "5ч 10м"),
              _buildStatBox("За месяц", "92ч 20м"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Календарь активности', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 10),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: DateTime.now(),
            calendarFormat: CalendarFormat.month,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
              rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
            ),
            calendarStyle: CalendarStyle(
              defaultTextStyle: const TextStyle(color: Colors.greenAccent),
              weekendTextStyle: const TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
              outsideTextStyle: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipOfDay() {
    final tips = [
      "Делай перерывы каждые 50 минут.",
      "Учись регулярно.",
      "Записывай важные идеи.",
      "Здоровый сон — залог успеха.",
    ];
    final String tip = (tips..shuffle()).first;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.red.shade900.withAlpha(128), blurRadius: 8, spreadRadius: 2)],
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline, color: Colors.orange, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _boxDecoration().copyWith(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: const Color(0xCCe53935),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.red.shade900, width: 2),
      boxShadow: [BoxShadow(color: Colors.red.shade900.withAlpha(153), blurRadius: 10, spreadRadius: 2)],
    );
  }
}