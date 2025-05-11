import 'package:flutter/material.dart';

Stack textOutlinedEffect(String str) {
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

Text lineSkip1(String str) {
  return Text(
    str,
    style: const TextStyle(
      letterSpacing: 4,
      height: 0.8,
      fontFamily: 'Gagalin',
      fontSize: 60,
      color: Color.fromARGB(255, 73, 73, 73),
    ),
  );
}
