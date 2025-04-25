import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  ui.Image? patternImage;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    loadImage('assets/image/fon.png');
  }

  Future<void> loadImage(String asset) async {
    final data = await DefaultAssetBundle.of(context).load(asset);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    setState(() {
      patternImage = frame.image;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Статичный белый фон
      body: Stack(
        children: [
          if (patternImage != null)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  painter: DiagonalPatternPainter(
                    image: patternImage!,
                    offset: Offset(_controller.value * 200, _controller.value * 200),
                  ),
                  size: MediaQuery.of(context).size,
                );
              },
            ),
          // Затемняющий слой
          if (patternImage != null)
            Container(
              color: Colors.black.withOpacity(0.4),
              width: double.infinity,
              height: double.infinity,
            ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: _AuthSwitcher(),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthSwitcher extends StatefulWidget {
  @override
  State<_AuthSwitcher> createState() => _AuthSwitcherState();
}

class _AuthSwitcherState extends State<_AuthSwitcher> {
  bool isLogin = true;

  @override
  void initState() {
    super.initState();
    _checkRegistration();
  }

  Future<void> _checkRegistration() async {
    final prefs = await SharedPreferences.getInstance();
    final regLogin = prefs.getString('reg_login');
    final regPassword = prefs.getString('reg_password');
    if (regLogin == null || regPassword == null) {
      setState(() {
        isLogin = false;
      });
    }
  }
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _regLoginController = TextEditingController();
  final _regPasswordController = TextEditingController();
  bool _obscurePass = true;
  bool _obscureRegPass = true;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _regLoginController.dispose();
    _regPasswordController.dispose();
    super.dispose();
  }

  Widget _buildLoginForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Text(
              'Вход',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 3
                  ..color = Colors.black,
              ),
            ),
            const Text(
              'Вход',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            border: Border.all(color: Colors.red.shade900, width: 2),
          ),
          child: TextField(
            controller: _loginController,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              labelText: 'Логин',
              labelStyle: TextStyle(color: Colors.black),
              hintStyle: TextStyle(color: Colors.black54),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            border: Border.all(color: Colors.red.shade900, width: 2),
          ),
          child: TextField(
            controller: _passwordController,
            obscureText: _obscurePass,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: 'Пароль',
              labelStyle: const TextStyle(color: Colors.black),
              hintStyle: const TextStyle(color: Colors.black54),
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: IconButton(
                icon: Icon(_obscurePass ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscurePass = !_obscurePass),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade900,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: const BorderSide(color: Colors.black, width: 2),
              ),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final login = _loginController.text;
              final password = _passwordController.text;
              final storedLogin = prefs.getString('reg_login');
              final storedPassword = prefs.getString('reg_password');
              if (storedLogin == null || storedPassword == null) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    title: const Text('Ошибка', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    content: const Text('Такого аккаунта не существует. Пожалуйста, зарегистрируйтесь.', style: TextStyle(color: Colors.black87)),
                    actions: [
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );
                return;
              }
              if (login != storedLogin) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    title: const Text('Ошибка', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    content: const Text('Такого аккаунта не существует. Пожалуйста, зарегистрируйтесь.', style: TextStyle(color: Colors.black87)),
                    actions: [
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );
                return;
              }
              if (password != storedPassword) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    title: const Text('Ошибка', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    content: const Text('Неверный пароль.', style: TextStyle(color: Colors.black87)),
                    actions: [
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );
                return;
              }
              await prefs.setString('profile_login', login);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            },
            child: const Text('Войти'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.red.shade900,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: BorderSide(color: Colors.red.shade900, width: 1.5),
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () => setState(() => isLogin = false),
            child: const Text('Нет аккаунта? Зарегистрироваться'),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Text(
              'Регистрация',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 3
                  ..color = Colors.black,
              ),
            ),
            const Text(
              'Регистрация',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            border: Border.all(color: Colors.red.shade900, width: 2),
          ),
          child: TextField(
            controller: _emailController,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              labelText: 'Почта',
              labelStyle: TextStyle(color: Colors.black),
              hintStyle: TextStyle(color: Colors.black54),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            border: Border.all(color: Colors.red.shade900, width: 2),
          ),
          child: TextField(
            controller: _regLoginController,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              labelText: 'Логин',
              labelStyle: TextStyle(color: Colors.black),
              hintStyle: TextStyle(color: Colors.black54),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            border: Border.all(color: Colors.red.shade900, width: 2),
          ),
          child: TextField(
            controller: _regPasswordController,
            obscureText: _obscureRegPass,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: 'Создать пароль',
              labelStyle: const TextStyle(color: Colors.black),
              hintStyle: const TextStyle(color: Colors.black54),
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: IconButton(
                icon: Icon(_obscureRegPass ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscureRegPass = !_obscureRegPass),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade900,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: const BorderSide(color: Colors.black, width: 2),
              ),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final login = _regLoginController.text;
              final password = _regPasswordController.text;
              await prefs.setString('reg_login', login);
              await prefs.setString('reg_password', password);
              await prefs.setString('profile_login', login);
              setState(() {
                isLogin = true;
              });
            },
            child: const Text('Зарегистрироваться'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.red.shade900,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: BorderSide(color: Colors.red.shade900, width: 1.5),
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () => setState(() => isLogin = true),
            child: const Text('Уже есть аккаунт? Войти'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: isLogin ? _buildLoginForm() : _buildRegisterForm(),
      transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
    );
  }
}

class DiagonalPatternPainter extends CustomPainter {
  final ui.Image image;
  final Offset offset;

  DiagonalPatternPainter({required this.image, required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final double imageWidth = image.width.toDouble();
    final double imageHeight = image.height.toDouble();

    for (double y = -imageHeight; y < size.height + imageHeight; y += imageHeight) {
      for (double x = -imageWidth; x < size.width + imageWidth; x += imageWidth) {
        canvas.drawImage(image, Offset(x, y) - offset, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
