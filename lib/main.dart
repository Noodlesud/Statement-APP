import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:teyake/firebase_options.dart';
import 'package:teyake/pages/add_item.dart';
import 'package:teyake/pages/display.dart';
import 'package:teyake/pages/repo.dart';
import 'package:teyake/pages/signin.dart';
import 'package:teyake/pages/signup.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  bool isDarkMode =
      prefs.getBool('isDarkMode') ?? false; // Get dark mode preference

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(Repo());

  // Pass the theme preference to MyApp constructor
  runApp(MyApp(isDarkMode));
}

class MyApp extends StatelessWidget {
  final bool isDarkMode;

  MyApp(this.isDarkMode);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Q & A',
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: SignIn(),
    );
  }
}
