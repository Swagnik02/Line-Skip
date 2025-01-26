import 'package:flutter/material.dart';

class PhoneInput extends StatelessWidget {
  final Function(String phoneNumber) onSendOtp;

  const PhoneInput({required this.onSendOtp, super.key});

  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter your phone number',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        TextField(
          // autofocus: true,
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            final phoneNumber = phoneController.text.trim();
            if (phoneNumber.isNotEmpty) {
              onSendOtp(phoneNumber);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a phone number')),
              );
            }
          },
          child: const Text('Send OTP'),
        ),
      ],
    );
  }
}

class OtpInput extends StatelessWidget {
  final Function(String otp) onVerifyOtp;

  const OtpInput({required this.onVerifyOtp, super.key});

  @override
  Widget build(BuildContext context) {
    final otpController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter the OTP',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: otpController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'OTP',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            final otp = otpController.text.trim();
            if (otp.isNotEmpty) {
              onVerifyOtp(otp);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter the OTP')),
              );
            }
          },
          child: const Text('Verify OTP'),
        ),
      ],
    );
  }
}

Widget customText(String str, double textSize) {
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
          fontSize: textSize,
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
        style: TextStyle(
          letterSpacing: 4,
          height: 0.8,
          fontFamily: 'Gagalin',
          fontSize: textSize,
          color: Colors.white,
        ),
      ),
    ],
  );
}
