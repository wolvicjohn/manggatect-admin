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
            // Show a confirmation dialog
            bool confirm = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Confirm Logout"),
                  content: const Text("Are you sure you want to log out?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // Close the dialog and return false
                        Navigator.of(context).pop(false);
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        // Close the dialog and return true
                        Navigator.of(context).pop(true);
                      },
                      child: const Text("Logout"),
                    ),
                  ],
                );
              },
            );

            // If the user confirms, sign out
            if (confirm == true) {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/loginpage');
            }
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
