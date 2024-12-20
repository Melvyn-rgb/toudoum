import 'package:flutter/material.dart';
import 'utils/theme.dart';
import 'screens/splash_screen.dart';
import 'utils/localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Detect system locale
  final String systemLocale = WidgetsBinding.instance.window.locale.languageCode;

  // Load localization strings
  final Localization localization = Localization(systemLocale);
  await localization.load();

  runApp(MyApp(localization: localization));
}

class MyApp extends StatelessWidget {
  final Localization localization;

  const MyApp({super.key, required this.localization});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: localization.get('app_title'),
      theme: appTheme,
      home: SplashScreen(localization: localization),
    );
  }
}
