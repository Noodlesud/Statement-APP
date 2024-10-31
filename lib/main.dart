import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:teyake/firebase_options.dart';
import 'package:teyake/pages/add_item.dart';
import 'package:teyake/pages/display.dart';
import 'package:teyake/pages/repo.dart';
import 'package:teyake/pages/signin.dart';
import 'package:teyake/pages/signup.dart';

import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(Repo());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Q & A',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SignIn(),
    );
  }
}
