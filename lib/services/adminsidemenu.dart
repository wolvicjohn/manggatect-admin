import 'package:adminmangga/pages/alltreelocationpage.dart';
import 'package:adminmangga/pages/archivepage.dart';
import 'package:adminmangga/pages/dashboard.dart';
import 'package:adminmangga/pages/home_page.dart';
import 'package:adminmangga/pages/info.dart';
import 'package:adminmangga/pages/login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class AdminSideMenu extends StatefulWidget {
  @override
  _AdminSideMenuState createState() => _AdminSideMenuState();
}

class _AdminSideMenuState extends State<AdminSideMenu> {
  String _selectedRoute = '/';

  @override
  Widget build(BuildContext context) {
    
    // Check if the user is authenticated
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/loginpage');
      });
      return const SizedBox(); 
    }

    // If user is authenticated, show the admin menu
    return AdminScaffold(
      appBar: AdminAppBar.buildAppBar(context),
      sideBar: AdminAppBar.buildSideBar(
          context, _selectedRoute, _updateSelectedRoute),
      body: _getBodyContent(),
    );
  }

  // Function to update the selected route
  void _updateSelectedRoute(String route) {
    setState(() {
      _selectedRoute = route;
    });
  }

  // Function to map routes to body widgets
  Widget _getBodyContent() {
    switch (_selectedRoute) {
      case '/homepage':
        return const Homepage();
      case '/tree-map':
        return const AllTreeLocationPage();
      case '/archivepage':
        return const ArchivePage();
        case '/infopage':
        return const InfoPage();
      default:
        return const Dashboard();
    }
  }
}

class AdminAppBar {
  static AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 60,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.image_not_supported);
            },
          ),
          const SizedBox(width: 8),
          const Text(
            "MANGGATECH",
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 15),
          child: ElevatedButton(
            onPressed: () async {
              bool confirm = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Confirm Logging Out"),
                    content: const Text("Are you sure you want to log out?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text("Cancel",style: TextStyle(color: Colors.grey),),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text("Logout",style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              );
          
              if (confirm == true) {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              }
            },
            child: const Text(
              "Logout",
              style: TextStyle(color: Colors.black),
            ),
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
        AdminMenuItem(
          title: 'Mango Flowers Info',
          route: '/infopage',
          icon: Icons.info_outline_rounded,
        ),
      ],
      selectedRoute: selectedRoute,
      onSelected: (item) {
        if (item.route != null) {
          updateSelectedRoute(item.route!);
        }
      },
    );
  }
}
