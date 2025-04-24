import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../point_providers.dart';
import 'login_page.dart';
import 'settings_page.dart';
import 'friends_page.dart';
import 'profile_page.dart';

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
                      _gridCard("assets/news1.jpg", "Новый ивент"),
                      _gridCard("assets/news2.jpg", "Гача обновление"),
                      _gridCard("assets/news3.jpg", "Патч 1.2.5"),
                      _gridCard("assets/news4.jpg", "Арена"),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _wideBannerCard("assets/news5.jpg", "Награды за вход", "Не забудь получить ежедневный бонус"),
                  const SizedBox(height: 16),
                  _angledCard("assets/news6.jpg", "Секретный режим", "Новый скрытый ивент доступен ограниченно!"),
                  const SizedBox(height: 16),
                  _cornerCutCard("assets/news7.jpg", "PvP битвы", "Соревнуйся и поднимайся в рейтинге"),
                  const SizedBox(height: 16),
                  _highlightCard("assets/news8.jpg", "Эксклюзив!", "Ограниченная акция на редкие предметы"),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gridCard(String image, String title) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.red.shade50,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Image.asset(image, fit: BoxFit.cover, width: double.infinity)),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red.shade800),
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

  Widget _cornerCutCard(String image, String title, String desc) {
    return ClipPath(
      clipper: CornerClipper(),
      child: Container(
        color: Colors.red.shade50,
        child: Column(
          children: [
            Image.asset(image, width: double.infinity, height: 150, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red.shade800)),
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
            decoration: BoxDecoration(color: Colors.red.shade300),
            child: const Text('Меню', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          _drawerItem(Icons.person, "Профиль", context, const ProfilePage()),
          _drawerItem(Icons.group, "Друзья", context, const FriendsPage()),
          _drawerItem(Icons.settings, "Настройки", context, const SettingsPage()),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Выйти', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
            },
          ),
        ],
      ),
    );
  }

  ListTile _drawerItem(IconData icon, String label, BuildContext context, Widget page) {
    return ListTile(
      leading: Icon(icon, color: Colors.red.shade800),
      title: Text(label, style: TextStyle(color: Colors.red.shade800)),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
    );
  }
}

class CornerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const cutSize = 30.0;
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width - cutSize, 0);
    path.lineTo(size.width, cutSize);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
