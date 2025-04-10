import 'package:adminmangga/firebase_options.dart';
import 'package:adminmangga/pages/archivepage.dart';
import 'package:adminmangga/pages/dashboard.dart';
import 'package:adminmangga/pages/info.dart';
import 'package:adminmangga/pages/login/login_page.dart';
import 'package:adminmangga/services/adminsidemenu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/alltreemap/alltreelocationpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Get.put(MenuController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // routes
      routes: {
        '/': (context) => const AdminPanel(),
        '/loginpage': (context) => const LoginPage(),
        '/tree-map': (context) => const AllTreeLocationPage(),
        '/archivepage': (context) => const ArchivePage(),
        '/dashboard': (context) => const Dashboard(),
        '/infopage': (context) => const InfoPage(),
      },
      initialRoute: '/',
    );
  }
}