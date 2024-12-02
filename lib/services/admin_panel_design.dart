import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../pages/alltreelocationpage.dart';

class AdminPanelPage extends StatelessWidget {
  const AdminPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminPanelDesign.buildAppBar(context),
      drawer: const SideMenu(),
      body: const Center(
        child: Text('Welcome to Manggatech Admin Panel!'),
      ),
    );
  }
}

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
}

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  String _activeMenu = '/';
  String _hoveredMenu = ''; // Track the currently hovered menu

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250, // Fixed width for the drawer
      color: Colors.blue[50],
      child: ListView(
        children: [
          _buildMenuItem(
            icon: Icons.dashboard,
            title: 'Dashboard',
            route: '/',
          ),
          _buildMenuItem(
            icon: Icons.note,
            title: 'Data',
            route: '/homepage',
          ),
          _buildMenuItem(
            icon: Icons.map,
            title: 'Map',
            route: '/map',
            customRoute: MaterialPageRoute(
              builder: (context) => const AllTreeLocationPage(),
            ),
          ),
          _buildMenuItem(
            icon: Icons.archive,
            title: 'Archive',
            route: '/archivepage',
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String route,
    MaterialPageRoute? customRoute,
  }) {
    final isActive = _activeMenu == route;
    final isHovered = _hoveredMenu == route;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _hoveredMenu = route;
        });
      },
      onExit: (_) {
        setState(() {
          _hoveredMenu = '';
        });
      },
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive || isHovered ? Colors.blue : Colors.black,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive || isHovered ? Colors.blue : Colors.black,
          ),
        ),
        tileColor: isActive
            ? Colors.blue[100]
            : isHovered
                ? Colors.blue[50]
                : Colors.transparent,
        onTap: () {
          setState(() {
            _activeMenu = route;
          });

          if (customRoute != null) {
            Navigator.push(context, customRoute);
          } else {
            Navigator.pushReplacementNamed(context, route);
          }
        },
      ),
    );
  }
}
