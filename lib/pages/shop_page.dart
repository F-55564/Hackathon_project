import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/currency_provider.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nomy = context.watch<CurrencyProvider>().nomy;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Магазин', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red.shade800,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber, size: 28),
                const SizedBox(width: 8),
                Text(
                  "Номов: $nomy",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.amber.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
                children: _shopItems(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _shopItems(BuildContext context) {
    return [
      _buildItem(context, "Золотая Рамка", "assets/image/frame_gold.png", 50),
      _buildItem(context, "Камелонная Рамка", "assets/image/kame.png", 75),
      _buildItem(context, "Светящаяся Рамка", "assets/image/rem.png", 60),
      _buildItem(context, "Профиль с анимацией", "assets/image/per.gif", 100),
      _buildItem(context, "Обсидиановая рамка", "assets/image/obsii.png", 40),
      _buildItem(context, "Темный Режим+", "assets/image/bss.png", 90),
    ];
  }

  Widget _buildItem(BuildContext context, String title, String imagePath, int cost) {
    final currencyProvider = context.read<CurrencyProvider>();
    final nomy = currencyProvider.nomy;
    final isFrame = imagePath.contains("frame");

    return FutureBuilder<List<String>>(
      future: SharedPreferences.getInstance()
          .then((prefs) => prefs.getStringList('owned_frames') ?? []),
      builder: (context, snapshot) {
        final ownedFrames = snapshot.data ?? [];
        final isOwned = isFrame && ownedFrames.contains(imagePath);

        return InkWell(
          borderRadius: BorderRadius.circular(24),
          splashColor: Colors.red.withOpacity(0.1),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Товар: $title'),
                duration: const Duration(milliseconds: 500),
              ),
            );
          },
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            color: Colors.red.shade50,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(imagePath, fit: BoxFit.contain),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Column(
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$cost номов",
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: isOwned
                            ? null
                            : nomy >= cost
                            ? () async {
                          currencyProvider.spendNomy(cost);
                          final prefs = await SharedPreferences.getInstance();
                          List<String> updated =
                              prefs.getStringList('owned_frames') ?? [];
                          if (isFrame && !updated.contains(imagePath)) {
                            updated.add(imagePath);
                            await prefs.setStringList('owned_frames', updated);
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isFrame
                                  ? "Рамка добавлена в ваш профиль!"
                                  : "Куплено: $title!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                            : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Недостаточно номов для покупки!"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isOwned ? Colors.grey : Colors.red.shade800,
                          disabledBackgroundColor: Colors.red.shade200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          isOwned ? "Куплено" : "Купить",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
