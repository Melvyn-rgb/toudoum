import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';
import '../utils/colors.dart';
import '../utils/localization.dart';

// Phone Number Form Widget
class PhoneNumberForm extends StatelessWidget {
  final String action;
  final Localization localization;

  const PhoneNumberForm({Key? key, required this.action, required this.localization}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // Netflix dark background
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Adjust height to content
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            action == 'login' ? localization.get('login') : localization.get('register'),
            style: const TextStyle(
              color: Colors.white, // White text color
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          PhoneFormField(
            initialValue: PhoneNumber.parse('+33'),
            validator: PhoneValidator.compose(
                [PhoneValidator.required(context), PhoneValidator.validMobile(context)]
            ),
            onChanged: (phoneNumber) => print('changed into $phoneNumber'),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black, // Black background
              hintText: 'Enter your phone number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.white), // Border color
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.white), // Focused border color
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.white), // Default border color
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
              backgroundColor: mainColor, // Netflix red button
              minimumSize: const Size(double.infinity, 50), // Full-width button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              // Handle phone number submission logic
              print('Phone number submitted for $action');
            },
            child: Text(
              localization.get('submit'),
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}