import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneInput extends StatefulWidget {
  final Function(String phoneNumber) onSendOtp;

  const PhoneInput({required this.onSendOtp, Key? key}) : super(key: key);

  @override
  _PhoneInputState createState() => _PhoneInputState();
}

class _PhoneInputState extends State<PhoneInput> {
  final phoneController = TextEditingController();
  String selectedCountryCode = '+91';

  final List<String> countryCodes = ['+1', '+91', '+44', '+61', '+81'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Enter your phone number', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        Row(
          children: [
            DropdownButton<String>(
              value: selectedCountryCode,
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedCountryCode = newValue;
                  });
                }
              },
              items: countryCodes.map((code) {
                return DropdownMenuItem<String>(
                  value: code,
                  child: Text(code),
                );
              }).toList(),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            final phoneNumber = phoneController.text.trim();
            if (phoneNumber.isNotEmpty) {
              widget.onSendOtp('$selectedCountryCode$phoneNumber');
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

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
}

class OtpInput extends StatefulWidget {
  final Function(String otp) onVerifyOtp;

  const OtpInput({required this.onVerifyOtp, Key? key}) : super(key: key);

  @override
  _OtpInputState createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  final controllers = List.generate(6, (_) => TextEditingController());
  final focusNodes = List.generate(6, (_) => FocusNode());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Enter the OTP', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            return Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: TextField(
                  controller: controllers[index],
                  focusNode: focusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    counterText: '',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    if (value.isNotEmpty && index < 5) {
                      focusNodes[index].unfocus();
                      FocusScope.of(context)
                          .requestFocus(focusNodes[index + 1]);
                    } else if (value.isEmpty && index > 0) {
                      focusNodes[index].unfocus();
                      FocusScope.of(context)
                          .requestFocus(focusNodes[index - 1]);
                    }
                  },
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            final otp = controllers.map((c) => c.text).join();
            if (otp.length == 6) {
              widget.onVerifyOtp(otp);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter the full OTP')),
              );
            }
          },
          child: const Text('Verify OTP'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
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
