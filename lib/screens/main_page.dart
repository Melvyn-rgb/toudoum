import 'package:flutter/material.dart';
import '../components/custom_button.dart';
import '../utils/colors.dart'; // Import resource colors
import '../utils/localization.dart';

class MainPage extends StatelessWidget {
  final Localization localization;

  const MainPage({Key? key, required this.localization}) : super(key: key);


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
              backgroundColor: mainColor, // Use resource color
              textColor: buttonTextColor, // Use white text
              onPressed: () {
                // Navigate to login page
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: localization.get('register'),
              backgroundColor: Colors.transparent, // Transparent background
              textColor: buttonTextColor, // White text
              onPressed: () {
                // Navigate to register page
              },
              hasBorder: true, // Add white border
            ),
            const SizedBox(height: 30), // Adjusted height here to match the space below the dashed line
            // Container with controlled width for the dashed line
            Container(
              width: 200, // Set fixed width for the dashed line
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Left dashed line
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                      indent: 20,
                    ),
                  ),
                  // Text in the middle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      localization.get('or_try'),
                      style: TextStyle(
                        color: Colors.grey, // Text color
                        fontSize: 14, // Adjust font size to be smaller
                      ),
                    ),
                  ),
                  // Right dashed line
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                      endIndent: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30), // Same height as above to match spacing
            GestureDetector(
              onTap: () {
                // Add your action here when the text is tapped
                print('Continue as a guest tapped');
              },
              child: Text(
                localization.get('continue_guest'),
                style: TextStyle(
                  color: Colors.grey, // Set text color to white
                  fontSize: 14, // Adjust the font size to be smaller
                  decoration: TextDecoration.underline, // Optional: add underline
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}