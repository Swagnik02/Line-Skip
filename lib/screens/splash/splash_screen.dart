import 'package:flutter/material.dart';
import 'package:line_skip/utils/constants.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, onboardingRoute);
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFe0c1a4),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/bg.png',
            fit: BoxFit.fitHeight,
          ),
          Center(
            child: _styleText('Line Skip'),
          ),
        ],
      ),
    );
  }

  Stack _styleText(String str) {
    return Stack(
      children: [
        // Outline text
        Text(
          str,
          textAlign: TextAlign.center,
          style: TextStyle(
            letterSpacing: 4,
            height: 0.8,
            fontFamily: 'Gagalin',
            fontSize: 120,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 6
              ..color = const Color.fromARGB(255, 73, 73, 73),
          ),
        ),
        // Inner text
        Text(
          str,
          textAlign: TextAlign.center,
          style: const TextStyle(
            letterSpacing: 4,
            height: 0.8,
            fontFamily: 'Gagalin',
            fontSize: 120,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
