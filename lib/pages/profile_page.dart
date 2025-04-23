import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const int currentPoints = 15;
    const int pointsToNextRank = 30;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Профиль"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🧍 Блок с аватаром
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: const Color(0xCCe53935),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.redAccent.shade100, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.6),
                    blurRadius: 18,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // выбор аватара
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage:
                      const AssetImage('assets/image/default_avatar.png'),
                      backgroundColor: Colors.black.withOpacity(0.2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Иван Студент',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.8),
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Выйти'),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // 🏆 Блок с рангом и очками
            Expanded(
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  color: const Color(0xCCe53935),
                  borderRadius: BorderRadius.circular(20),
                  border:
                  Border.all(color: Colors.white.withOpacity(0.8), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.6),
                      blurRadius: 18,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child:
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 10, left: 10, right:
                        10),
                        child:
                        ClipRRect(
                          borderRadius:
                          BorderRadius.circular(16),
                          child:
                          Image.asset('assets/image/rank_icon.png',
                            fit:
                            BoxFit.cover,
                            width:
                            double.infinity,),
                        ),
                      ),
                    ),
                    const SizedBox(height:
                    6,),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children:[
                        const Icon(Icons.star, color:
                        Colors.yellow, size:
                        20,),
                        const SizedBox(width:
                        4,),
                        const Text('Очки:',
                          style:
                          TextStyle(color:
                          Colors.white, fontSize:
                          14, fontWeight:
                          FontWeight.w600,),),
                        const SizedBox(width:
                        4,),
                        Text('$currentPoints / $pointsToNextRank',
                          style:
                          TextStyle(color:
                          Colors.white, fontSize:
                          14, fontWeight:
                          FontWeight.w600,),),
                      ],
                    ),
                    const SizedBox(height:
                    6,),
                    Padding(padding:
                    const EdgeInsets.symmetric(horizontal:
                    16), child:
                    LinearProgressIndicator(value:
                    currentPoints / pointsToNextRank, backgroundColor:
                    Colors.white.withOpacity(0.3), color:
                    Colors.white,),),
                    const SizedBox(height:
                    10,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}