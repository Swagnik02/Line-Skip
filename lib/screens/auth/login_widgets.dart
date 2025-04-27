import 'package:country_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_pickers/country_pickers.dart';

class PhoneInput extends StatefulWidget {
  final Function(String phoneNumber) onSendOtp;

  const PhoneInput({Key? key, required this.onSendOtp}) : super(key: key);

  @override
  _PhoneInputState createState() => _PhoneInputState();
}

class _PhoneInputState extends State<PhoneInput> {
  final TextEditingController _phoneController = TextEditingController();
  Country _selectedCountry = CountryPickerUtils.getCountryByIsoCode('IN');
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _phoneController.text.trim().length == 10;
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _openCountryPicker() {
    showDialog(
      context: context,
      builder: (context) => CountryPickerDialog(
        titlePadding: const EdgeInsets.all(0),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        searchCursorColor: Colors.black,
        searchInputDecoration: const InputDecoration(hintText: 'Search...'),
        isSearchable: true,
        onValuePicked: (Country country) {
          setState(() => _selectedCountry = country);
        },
        priorityList: [
          CountryPickerUtils.getCountryByIsoCode('IN'),
          CountryPickerUtils.getCountryByIsoCode('US'),
        ],
        itemBuilder: _buildCountryItem,
      ),
    );
  }

  Widget _buildCountryItem(Country country) {
    return Row(
      children: [
        CountryPickerUtils.getDefaultFlagImage(country),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            "+${country.phoneCode} ${country.name}",
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _sendOtp() {
    final phoneNumber = _phoneController.text.trim();
    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a phone number')),
      );
      return;
    }
    widget.onSendOtp('+${_selectedCountry.phoneCode}$phoneNumber');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Shop, Scan, and Skip',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const Text(
          'The Line',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        _buildDividerWithText('Log in or sign up'),
        const SizedBox(height: 30),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            LengthLimitingTextInputFormatter(10),
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'Enter phone number',
            prefixIcon: GestureDetector(
              onTap: _openCountryPicker,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CountryPickerUtils.getDefaultFlagImage(_selectedCountry),
                    const SizedBox(width: 4),
                    Text('+${_selectedCountry.phoneCode}'),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 65,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isButtonEnabled ? _sendOtp : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isButtonEnabled
                  ? Colors.deepOrangeAccent
                  : const Color(0xFFD3D3D3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
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

  Widget _buildDividerWithText(String text) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.grey)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(text, style: const TextStyle(fontSize: 16)),
        ),
        const Expanded(child: Divider(color: Colors.grey)),
      ],
    );
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
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late final List<TextEditingController> controllers;
  late final List<FocusNode> focusNodes;
  bool isOtpValid = false;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(6, (_) => TextEditingController());
    focusNodes = List.generate(6, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    for (final node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _checkOtpValidity() {
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

  Widget _buildOtpTextField(int index) {
    return SizedBox(
      width: 45,
      child: TextField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: const EdgeInsets.all(10),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.deepOrangeAccent),
          ),
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).requestFocus(focusNodes[index + 1]);
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).requestFocus(focusNodes[index - 1]);
          }
          _checkOtpValidity();
        },
      ),
    );
  }

  void _onVerify() {
    final otp = controllers.map((c) => c.text).join();
    if (otp.length == 6) {
      widget.onVerifyOtp(otp);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the full OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Verify Your OTP',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "We've sent a 6-digit code to ${widget.mobileNumber}",
          style: TextStyle(color: Colors.grey[700]),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(6, _buildOtpTextField),
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
            onPressed: isOtpValid ? _onVerify : null,
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
            ..strokeWidth = 5
            ..color = const Color(0xFF494949),
        ),
      ),
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
