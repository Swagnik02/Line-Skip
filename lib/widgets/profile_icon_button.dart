import 'package:flutter/material.dart';

GestureDetector profileIconBtn() {
  return GestureDetector(
    onTap: () {},
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black45, width: 1),
        borderRadius: BorderRadius.circular(30),
      ),
      width: 100,
      height: 55,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.0),
              child: Icon(Icons.arrow_back_ios, color: Colors.black54),
            ),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.brown[800],
              ),
              child: ClipOval(
                child: Icon(Icons.person, size: 35, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
