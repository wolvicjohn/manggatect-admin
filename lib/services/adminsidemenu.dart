import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class AdminSideMenu {
  static AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          'assets/images/logo.png', // Replace with your logo's path
          fit: BoxFit.contain,
        ),
      ),
      title: const Text(
        "Manggatech",
        style: TextStyle(
          fontSize: 24,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            bool confirm = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Confirm Logout"),
                  content: const Text("Are you sure you want to log out?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text("Logout"),
                    ),
                  ],
                );
              },
            );

            if (confirm == true) {
              // Your logout logic
              Navigator.pushReplacementNamed(context, '/loginpage');
            }
          },
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

  static SideBar buildSideBar(
    BuildContext context,
    String selectedRoute,
    Function(String) updateSelectedRoute,
  ) {
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
      selectedRoute: selectedRoute,
      onSelected: (item) {
        if (item.route != null) {
          updateSelectedRoute(item.route!);
          Navigator.pushNamedAndRemoveUntil(
            context,
            item.route!,
            (route) => false, // Remove previous routes
          );
        }
      },
    );
  }
}
