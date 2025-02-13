import 'package:flutter/material.dart';

class CustomFloatingNextButton extends StatelessWidget {
  const CustomFloatingNextButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: CircleBorder(),
      backgroundColor: Colors.white70,
      onPressed: onPressed,
      child: Icon(
        Icons.arrow_forward_ios,
        color: Colors.orangeAccent,
      ),
    );
  }
}

class CustomFloatingSkip extends StatelessWidget {
  const CustomFloatingSkip({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      label: Text("Skip",
          style: TextStyle(color: Colors.orangeAccent, fontSize: 20)),
      backgroundColor: Colors.white70,
      onPressed: onPressed,
      icon: Icon(
        Icons.skip_next_rounded,
        size: 35,
        color: Colors.orangeAccent,
      ),
    );
  }
}
