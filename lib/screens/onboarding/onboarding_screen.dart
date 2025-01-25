import 'package:flutter/material.dart';
import 'package:line_skip/utils/constants.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: const [
              OnboardingSlide(
                image: Icons.store,
                title: 'Shop',
                subtitle: 'Discover stores near you and shop effortlessly.',
              ),
              OnboardingSlide(
                image: Icons.qr_code_scanner,
                title: 'Scan',
                subtitle: 'Scan items directly from your phone.',
              ),
              OnboardingSlide(
                image: Icons.skip_next,
                title: 'Skip',
                subtitle: 'Skip the line and save time at checkout.',
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  height: 10,
                  width: _currentPage == index ? 20 : 10,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ElevatedButton(
          onPressed: () {
            if (_currentPage == 2) {
              Navigator.pushReplacementNamed(context, loginRoute);
            } else {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(_currentPage == 2 ? 'Continue' : 'Next'),
        ),
      ),
    );
  }
}

class OnboardingSlide extends StatelessWidget {
  final IconData image;
  final String title;
  final String subtitle;

  const OnboardingSlide({
    required this.image,
    required this.title,
    required this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                image,
                size: 150,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
          const SizedBox(height: 40),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }
}

// CustomPainter for the blob shape based on the contour provided
class BlobPainter extends CustomPainter {
  final Color color;

  BlobPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final path = Path();

    // Shape coordinates based on the contour provided
    path.moveTo(100, 25); // Top-center
    path.cubicTo(170, 10, 230, 75, 190, 125); // Top-right curve
    path.quadraticBezierTo(180, 190, 120, 200); // Bottom-right curve
    path.quadraticBezierTo(60, 190, 30, 150); // Bottom-left curve
    path.cubicTo(10, 100, 30, 50, 100, 25); // Top-left curve

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
