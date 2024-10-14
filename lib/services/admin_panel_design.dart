import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import '../pages/alltreelocationpage.dart';

class AdminPanelDesign {
  static AppBar buildAppBar() {
    return AppBar(
      title: const Text(
        "Admin Panel",
        style: TextStyle(
          fontSize: 24,
        ),
      ),
      backgroundColor: Colors.green,
      actions: const [],
    );
  }

  static SideBar buildSideBar(BuildContext context) {
    return SideBar(
      items: const [
        AdminMenuItem(
          title: 'Dashboard',
          route: '/',
          icon: Icons.dashboard,
        ),
        AdminMenuItem(
          title: 'Data',
          route: '/homepage',
          icon: Icons.note,
        ),
        AdminMenuItem(
          title: 'Tree Map',
          route: '/tree-map',
          icon: Icons.map,
        ),
      ],
      selectedRoute: '/',
      onSelected: (item) {
        if (item.route != null) {
          if (item.route == '/tree-map') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AllTreeLocationPage()),
            );
          } else {
            Navigator.pushReplacementNamed(context, item.route!);
          }
        }
      },
    );
  }
}
