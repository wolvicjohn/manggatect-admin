import 'package:adminmangga/firebase_options.dart';
import 'package:adminmangga/pages/archivepage/archivepage.dart';
import 'package:adminmangga/pages/dashboard/dashboard.dart';
import 'package:adminmangga/pages/infopage/info.dart';
import 'package:adminmangga/pages/login/login_page.dart';
import 'package:adminmangga/services/admin_side_menu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/alltreemap/widgets/alltreelocationpage.dart';

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