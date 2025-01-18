import 'package:flutter/material.dart';
import 'package:line_skip/utils/constants.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: const [
          OnboardingSlide(text: 'Shop'),
          OnboardingSlide(text: 'Scan'),
          OnboardingSlide(text: 'Skip'),
        ],
      ),
      bottomSheet: TextButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, loginRoute);
        },
        child: const Text('Continue'),
      ),
    );
  }
}

// Onboarding Slide Widget
class OnboardingSlide extends StatelessWidget {
  final String text;
  const OnboardingSlide({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: Theme.of(context).textTheme.displayMedium,
      ),
    );
  }
}
