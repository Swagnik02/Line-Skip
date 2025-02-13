import 'package:flutter/material.dart';
import 'package:line_skip/screens/profile/email_page.dart';
import 'package:line_skip/screens/profile/profile_photo_page.dart';
import 'package:line_skip/screens/profile/username_input_page.dart';
import 'package:line_skip/utils/constants.dart';

class ProfileInputPage extends StatefulWidget {
  ProfileInputPage({super.key});

  @override
  _ProfileInputPageState createState() => _ProfileInputPageState();
}

class _ProfileInputPageState extends State<ProfileInputPage> {
  final PageController _pageController = PageController();
  double _progressValue = 0.33;
  void _updateProgress(int pageIndex) {
    setState(() {
      _progressValue = (pageIndex + 1) / 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent[400],
      body: Column(
        children: [
          const SizedBox(height: 40),
          // Progress Indicator
          Container(
            width: double.infinity,
            height: 4,
            color: Colors.black12,
            child: LinearProgressIndicator(
              value: _progressValue,
              backgroundColor: Colors.black12,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          ),
          Expanded(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: _updateProgress,
              children: [
                // Username Page
                UsernameInputPage(onNext: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }),

                // Email Page
                EmailPage(
                  onNext: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  onSkip: () {
                    Navigator.pushReplacementNamed(context, homeRoute);
                  },
                ),

                // Profile Photo Page
                ProfilePhotoPage(onSkip: () {
                  Navigator.pushReplacementNamed(context, homeRoute);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
