import 'package:adminmangga/firebase_options.dart';
import 'package:adminmangga/(for%20future%20update)/layout.dart';
import 'package:adminmangga/pages/archivepage.dart';
import 'package:adminmangga/pages/dashboard.dart';
import 'package:adminmangga/pages/login/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/alltreelocationpage.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(MenuController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return
        // GetMaterialApp(
        //   debugShowCheckedModeBanner: false,
        //   title: "Dash",
        //   theme: ThemeData(
        //     scaffoldBackgroundColor: Colors.white,
        //     textTheme: GoogleFonts.mulishTextTheme(Theme.of(context).textTheme)
        //         .apply(bodyColor: Colors.black),
        //     pageTransitionsTheme: const PageTransitionsTheme(builders: {
        //       TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        //     }),
        //     primaryColor: Colors.blue,
        //   ),
        //   home: SiteLayout(),
        // );
        MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/archivepage': (context) => const ArchivePage(),
        '/homepage': (context) => const Homepage(),
        '/tree-map': (context) => const AllTreeLocationPage(),
        '/loginpage': (context) => const LoginPage(),
        '/': (context) => const Dashboard(),
      },
    );
  }
}

