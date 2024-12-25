import 'package:flutter/material.dart';
import '../components/custom_button.dart';
import '../utils/colors.dart';
import '../utils/localization.dart';
import '../components/PhoneForm.dart';

class MainPage extends StatelessWidget {
  final Localization localization;

  const MainPage({Key? key, required this.localization}) : super(key: key);

  // Function to show the phone number input form as a sliding modal
  void _showPhoneNumberForm(BuildContext context, String action) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Set transparent background
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black, // Main modal background
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.8), // Subtle shadow color
                  blurRadius: 15, // Strength of the shadow blur
                  spreadRadius: 5, // Spread distance
                  offset: const Offset(0, -5), // Offset for the shadow
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: PhoneNumberForm(action: action, localization: localization),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', width: 200, height: 150),
            const SizedBox(height: 50),
            CustomButton(
              text: localization.get('login'),
              backgroundColor: mainColor,
              textColor: buttonTextColor,
              onPressed: () => _showPhoneNumberForm(context, 'login'), // Show phone number input modal
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: localization.get('register'),
              backgroundColor: Colors.transparent,
              textColor: buttonTextColor,
              onPressed: () => _showPhoneNumberForm(context, 'register'), // Show phone number input modal
              hasBorder: true,
            ),
            const SizedBox(height: 30),
            Container(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(color: Colors.grey, thickness: 1, indent: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      localization.get('or_try'),
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: Colors.grey, thickness: 1, endIndent: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                print('Continue as a guest tapped');
              },
              child: Text(
                localization.get('continue_guest'),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}