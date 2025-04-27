import 'package:country_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_pickers/country_pickers.dart';

class PhoneInput extends StatefulWidget {
  final Function(String phoneNumber) onSendOtp;

  const PhoneInput({required this.onSendOtp, Key? key}) : super(key: key);

  @override
  _PhoneInputState createState() => _PhoneInputState();
}

class _PhoneInputState extends State<PhoneInput> {
  final phoneController = TextEditingController();
  Country selectedCountry = CountryPickerUtils.getCountryByIsoCode('IN');
  bool isButtonEnabled = false; // Track if the button is enabled or not

  @override
  void initState() {
    super.initState();
    phoneController.addListener(_onPhoneNumberChanged);
  }

  void _onPhoneNumberChanged() {
    setState(() {
      // Enable the button only when the phone number has 10 digits
      isButtonEnabled = phoneController.text.length == 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Shop, Scan, and Skip',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          'The Line',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            const Expanded(child: Divider(color: Colors.grey)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Log in or sign up',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const Expanded(child: Divider(color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 30),
        TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'Enter phone number',
            prefixIcon: GestureDetector(
              onTap: _openCountryPickerDialog,
              child: Container(
                width: 100,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CountryPickerUtils.getDefaultFlagImage(selectedCountry),
                    const SizedBox(width: 4),
                    Text('+${selectedCountry.phoneCode}'),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(10),
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 65,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isButtonEnabled
                  ? Colors.deepOrangeAccent // deep orange accent
                  : const Color(0xFFD3D3D3), // custom disabled color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: isButtonEnabled
                ? () {
                    final phoneNumber = phoneController.text.trim();
                    if (phoneNumber.isNotEmpty) {
                      widget.onSendOtp(
                          '+${selectedCountry.phoneCode}$phoneNumber');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please enter a phone number')),
                      );
                    }
                  }
                : null, // Disable the button when not enabled
            child: Text(
              'CONTINUE',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  void _openCountryPickerDialog() {
    showDialog(
      context: context,
      builder: (context) => CountryPickerDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        searchCursorColor: Colors.black,
        searchInputDecoration: const InputDecoration(hintText: 'Search...'),
        isSearchable: true,
        title: const Text(''),
        onValuePicked: (Country country) {
          setState(() {
            selectedCountry = country;
          });
        },
        priorityList: [
          CountryPickerUtils.getCountryByIsoCode('IN'),
          CountryPickerUtils.getCountryByIsoCode('US'),
        ],
        itemBuilder: _buildDialogItem,
      ),
    );
  }

  Widget _buildDialogItem(Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              "+${country.phoneCode} ${country.name}",
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
        ],
      );

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
}

class OtpInput extends StatefulWidget {
  final Function(String otp) onVerifyOtp;
  final String mobileNumber;
  final Function() onChangeNumber;

  const OtpInput({
    required this.onVerifyOtp,
    required this.mobileNumber,
    required this.onChangeNumber,
    Key? key,
  }) : super(key: key);

  @override
  _OtpInputState createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  final controllers = List.generate(6, (_) => TextEditingController());
  final focusNodes = List.generate(6, (_) => FocusNode());
  bool isOtpValid = false;

  @override
  void initState() {
    super.initState();
    for (var controller in controllers) {
      controller.addListener(_onOtpChanged);
    }
  }

  void _onOtpChanged() {
    setState(() {
      isOtpValid =
          controllers.every((controller) => controller.text.isNotEmpty);
    });
  }

  void _resendCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP code resent!')),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Verify Your OTP',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(
          "We've sent a 6-digit code to ${widget.mobileNumber}",
          style: TextStyle(color: Colors.grey[700]),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(6, (index) {
            return SizedBox(
              width: 45,
              child: TextField(
                controller: controllers[index],
                focusNode: focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding: const EdgeInsets.all(10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Colors.deepOrangeAccent),
                  ),
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  if (value.isNotEmpty && index < 5) {
                    FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                  } else if (value.isEmpty && index > 0) {
                    FocusScope.of(context).requestFocus(focusNodes[index - 1]);
                  }
                },
                onEditingComplete: () {
                  if (index < 5) {
                    FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                  }
                },
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Text('Didn\'t get the code?', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: _resendCode,
              child: const Text(
                'Resend Code',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.deepOrangeAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Text('Entered the wrong number?',
                style: TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: widget.onChangeNumber,
              child: const Text(
                'Edit Number',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.deepOrangeAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isOtpValid ? Colors.deepOrangeAccent : Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: isOtpValid
                ? () {
                    final otp = controllers.map((c) => c.text).join();
                    if (otp.length == 6) {
                      widget.onVerifyOtp(otp);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please enter the full OTP')),
                      );
                    }
                  }
                : null,
            child: const Text(
              'VERIFY',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
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
