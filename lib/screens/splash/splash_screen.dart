import 'package:flutter/material.dart';
import 'package:line_skip/utils/constants.dart';
import 'package:line_skip/widgets/line_skip_text.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, authRoute);
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
            child: textOutlinedEffect('Line Skip'),
          ),
        ],
      ),
    );
  }
}
