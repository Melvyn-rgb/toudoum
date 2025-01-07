import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:toudoum/screens/loading_page.dart';
import '../utils/colors.dart';
import '../utils/localization.dart';

class PhoneNumberForm extends StatefulWidget {
  final String action;
  final Localization localization;

  const PhoneNumberForm({Key? key, required this.action, required this.localization}) : super(key: key);

  @override
  _PhoneNumberFormState createState() => _PhoneNumberFormState();
}

class _PhoneNumberFormState extends State<PhoneNumberForm> {
  late PhoneController _phoneController;
  final String testPhoneNumber = '+33777777777'; // Hardcoded test phone number
  bool _isLoading = false; // State variable to toggle views
  bool _isValidPhone = false; // Track phone validation

  @override
  void initState() {
    super.initState();
    _phoneController = PhoneController(initialValue: PhoneNumber.parse('+33'));
    _phoneController.addListener(_validatePhoneNumber);
  }

  void _validatePhoneNumber() {
    final phone = _phoneController.value;
    setState(() {
      _isValidPhone = phone != null && phone.isValid();
    });
  }

  @override
  void dispose() {
    _phoneController.removeListener(_validatePhoneNumber);
    _phoneController.dispose(); // Dispose the controller to free resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // Netflix dark background
      padding: const EdgeInsets.all(20),
      child: _isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Colors.red), // Show loading indicator
      )
          : Column(
        mainAxisSize: MainAxisSize.min, // Adjust height to content
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.action == 'login'
                ? widget.localization.get('login')
                : widget.localization.get('register'),
            style: const TextStyle(
              color: Colors.white, // White text color
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          PhoneFormField(
            controller: _phoneController,
            validator: PhoneValidator.compose(
              [PhoneValidator.required(context), PhoneValidator.validMobile(context)],
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black, // Black background
              hintText: 'Enter your phone number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.white), // Border color
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.white), // Focused border color
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.white), // Default border color
              ),
            ),
            style: const TextStyle(
              color: Colors.white, // White input text
            ),
            countrySelectorNavigator: const CountrySelectorNavigator.modalBottomSheet(),
            isCountrySelectionEnabled: true,
            isCountryButtonPersistent: true,
            countryButtonStyle: const CountryButtonStyle(
              textStyle: TextStyle(
                color: Colors.white, // White placeholder text
                fontSize: 16.0, // Optional: Adjust font size
              ),
              showDialCode: true,
              showIsoCode: false,
              showFlag: true,
              flagSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _isValidPhone ? mainColor : Colors.grey, // Red when enabled, grey when disabled
              minimumSize: const Size(double.infinity, 50), // Full-width button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _isValidPhone
                ? () {
              setState(() {
                _isLoading = true; // Show loading indicator
              });
              Future.delayed(const Duration(seconds: 2), () {
                if (_phoneController.value?.international == testPhoneNumber) {
                  Navigator.pop(context); // Close bottom sheet
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoadingPage(), // Navigate to Loading Screen
                    ),
                  );
                } else {
                  setState(() {
                    _isLoading = false; // Revert back to form view
                  });
                  // Show an error message if phone number doesn't match
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(widget.localization.get('invalid_phone_number')),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              });
            }
                : null, // Disable the button if phone is invalid
            child: Text(
              widget.localization.get('submit'),
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}