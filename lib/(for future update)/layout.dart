import 'package:adminmangga/(for%20future%20update)/helpers/responsiveness.dart';
import 'package:adminmangga/(for%20future%20update)/widgets/largescreen.dart';
import 'package:adminmangga/(for%20future%20update)/widgets/side_menu.dart';
import 'package:adminmangga/(for%20future%20update)/widgets/smallscreen.dart';
import 'package:adminmangga/(for%20future%20update)/widgets/top_nav.dart';
import 'package:flutter/material.dart';

class SiteLayout extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  SiteLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: topNavigationBar(context, scaffoldKey),
      drawer: const Drawer(
        child: SideMenu(),
      ),
      body: const ResponsiveWidget(
          largeScreen: LargeScreen(), smallScreen: SmallScreen()),
    );
  }
}
