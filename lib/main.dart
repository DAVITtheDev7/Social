import 'package:firebase_core/firebase_core.dart';
import 'package:social/helper/check_user.dart';
import 'firebase/firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Social Media App',
      debugShowCheckedModeBanner: false,
      home: CheckUser(),
    );
  }
}
