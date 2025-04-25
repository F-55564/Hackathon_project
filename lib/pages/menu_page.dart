import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../point_providers.dart';

import 'event_page.dart';
import 'settings_page.dart';
import 'friends_page.dart';
import 'profile_page.dart';
import 'shop_page.dart';
import 'person_info_page.dart';
import 'login_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final int currentPoints = context.watch<PointsProvider>().points;
    final bool isMaxLevel = currentPoints >= 200;
    final int pointsThisLevel = currentPoints.clamp(0, 200);
    const int pointsRequired = 200;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: _buildDrawer(context),
      appBar: AppBar(
        backgroundColor: Colors.red.shade800,
        title: const Text("Главное меню", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isMaxLevel ? "Очки: $currentPoints (MAX LVL)" : "Очки: $currentPoints",
              style: TextStyle(fontSize: 24, color: Colors.red.shade800, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: pointsThisLevel / pointsRequired,
              backgroundColor: Colors.red.shade100,
              color: Colors.red.shade800,
              minHeight: 10,
            ),
            const SizedBox(height: 24),
            Text(
              "Новости и обновления",
              style: TextStyle(fontSize: 20, color: Colors.red.shade700, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.9,
                    children: [
                      _eventButton(
                        context,
                        'Актуальное',
                        'Самое важное и актуальное событие! Здесь будет подробная информация.',
                        'assets/image/hackaton.png',
                      ),
                      _eventButton(
                        context,
                        'Недавнее событие',
                        'Недавно прошедшее событие. Здесь можно узнать детали.',
                        'assets/image/news2.png',
                      ),
                      _eventButton(
                        context,
                        'Завершённое событие',
                        'Это событие уже завершилось, но его итоги можно посмотреть здесь.',
                        'assets/image/news3.png',
                      ),
                      _eventButton(
                        context,
                        'Уже не актуальное',
                        'Это событие уже не актуально. Но вы всегда можете посмотреть архив.',
                        'assets/image/news4.png',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    splashColor: Colors.red.withOpacity(0.2),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PersonInfoPage(
                            title: "Директор",
                            imagePath: "assets/image/news5.png",
                            description: "Жумукова Айзада Сулаймановна — директор Nomad College. Опытный руководитель, вдохновляющий студентов и преподавателей на новые достижения.",
                          ),
                        ),
                      );
                    },
                    child: _wideBannerCard("assets/image/news5.png", "Директор", "Жумукова Айзада Сулаймановна"),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    splashColor: Colors.red.withOpacity(0.2),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PersonInfoPage(
                            title: "Преподаватели",
                            imagePath: "assets/image/news6.png",
                            description: "Наши преподаватели — профессионалы своего дела, которые всегда готовы поддержать и вдохновить студентов на успех!",
                          ),
                        ),
                      );
                    },
                    child: _angledCard("assets/image/news6.png", "Преподаватели", "Самые лучшие!"),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PersonInfoPage(
                            title: "Направления",
                            imagePath: "assets/image/news8.png",
                            description: "В колледже представлены современные направления и профессии, востребованные на рынке труда.",
                          ),
                        ),
                      );
                    },
                    child: _highlightCard("assets/image/news8.png", "Направления!", "Професии"),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _eventButton(BuildContext context, String title, String description, String imagePath) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade50,
        foregroundColor: Colors.red.shade800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        padding: EdgeInsets.zero,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EventPage(
              title: title,
              imagePath: imagePath,
              description: description,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _wideBannerCard(String image, String title, String desc) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.red.shade50,
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Image.asset(image, width: 120, height: 100, fit: BoxFit.cover),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red.shade800)),
                  const SizedBox(height: 4),
                  Text(desc, style: TextStyle(color: Colors.red.shade700)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _angledCard(String image, String title, String desc) {
    return Transform.rotate(
      angle: -0.03,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.red.shade50,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Image.asset(image, height: 160, width: double.infinity, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red.shade800)),
                  const SizedBox(height: 4),
                  Text(desc, style: TextStyle(color: Colors.red.shade700)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _highlightCard(String image, String title, String desc) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.shade100.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200, width: 1),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
            child: Image.asset(image, width: 110, height: 110, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red.shade800)),
                  const SizedBox(height: 4),
                  Text(desc, style: TextStyle(color: Colors.red.shade700)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.red.shade50,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.red.shade800),
            child: const Text('Меню', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          _drawerItem(Icons.person, "Профиль", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()))),
          _drawerItem(Icons.group, "Друзья", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FriendsPage()))),
          _drawerItem(Icons.settings, "Настройки", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()))),
          _drawerItem(Icons.store, "Магазин", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopPage()))),
          _drawerItem(Icons.logout, "Выход", () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
            );
          }),
        ],
      ),
    );
  }

  ListTile _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.red.shade800),
      title: Text(title, style: TextStyle(color: Colors.red.shade800)),
      onTap: onTap,
    );
  }
}

class CornerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 20);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(20, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
