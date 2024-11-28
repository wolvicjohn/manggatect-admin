import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import '../pages/alltreelocationpage.dart';

class AdminPanelDesign {
  static AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        "Manggatech",
        style: TextStyle(
          fontSize: 24,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            // Sign out the user and navigate back to login
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacementNamed(context, '/loginpage');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent, 
            elevation: 0, 
          ),
          child: const Text(
            "Logout",
            style: TextStyle(color: Colors.black), 
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0), 
        child: Container(
          color: Colors.grey, 
          height: 1.0, 
        ),
      ),
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
          title: 'Map',
          route: '/tree-map',
          icon: Icons.map,
        ),
        AdminMenuItem(
          title: 'Archive',
          route: '/archivepage',
          icon: Icons.archive,
        ),
      ],
      selectedRoute: '/loginpage',
      onSelected: (item) {
        if (item.route != null) {
          if (item.route == '/tree-map') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AllTreeLocationPage()),
            );
          } else {
            Navigator.pushReplacementNamed(context, item.route!);
          }
        }
      },
    );
  }
}
