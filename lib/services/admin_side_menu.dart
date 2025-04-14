import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../pages/alltreemap/widgets/alltreelocationpage.dart';
import '../pages/archivepage/archivepage.dart';
import '../pages/dashboard/dashboard.dart';
import '../pages/datatable/homepage.dart';
import '../pages/infopage/info.dart';
import '../pages/login/login_page.dart';
import '../pages/profile/profile_page.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    Dashboard(),
    Homepage(),
    AllTreeLocationPage(),
    ArchivePage(),
    InfoPage(),
  ];

  final List<String> titles = [
    'Dashboard',
    'Data',
    'Map',
    'Archive',
    'Mango Flowers Info',
  ];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Redirect to login if user is not authenticated
      Future.microtask(() => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const LoginPage())));
      return const SizedBox();
    }

    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              NavigationRailTheme(
                data: const NavigationRailThemeData(
                  backgroundColor: Colors.white,
                  selectedIconTheme: IconThemeData(
                      color: Color.fromARGB(255, 20, 116, 82), size: 27),
                  unselectedIconTheme: IconThemeData(
                      color: Color.fromARGB(255, 51, 51, 51), size: 23),
                  selectedLabelTextStyle: TextStyle(
                    color: Color.fromARGB(255, 20, 116, 82),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelTextStyle: TextStyle(
                    color: Color.fromARGB(255, 51, 51, 51),
                    fontSize: 15,
                  ),
                ),
                child: NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const LoadingIndicator(
                            indicatorType: Indicator.lineScalePulseOutRapid,
                            colors: [
                              Color.fromARGB(255, 20, 116, 82),
                              Colors.yellow,
                              Colors.red,
                              Colors.blue,
                              Colors.orange,
                            ],
                            strokeWidth: 3,
                          ),
                        ),
                      ),
                    );

                    await Future.delayed(const Duration(milliseconds: 800));

                    if (mounted) {
                      Navigator.pop(context);
                      setState(() {
                        selectedIndex = index;
                      });
                    }
                  },
                  labelType: NavigationRailLabelType.all,
                  leading: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = 0;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Image.asset('assets/images/logo.png', height: 50),
                              const SizedBox(height: 8),
                              const Text(
                                "MANGGATECH",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 51, 51, 51),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard),
                      label: Text('Dashboard'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.note),
                      label: Text('Data'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.map),
                      label: Text('Map'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.archive),
                      label: Text('Archive'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.info_outline),
                      label: Text('Info'),
                    ),
                  ],
                ),
              ),
              const VerticalDivider(thickness: 1, width: 1),
              Expanded(child: pages[selectedIndex]),
            ],
          ),
          Positioned(
            bottom: 80, // move this up a bit to leave space for logout
            left: 35,
            child: TextButton(
              onPressed: () {
                showUpdatePasswordDialog(context);
              },
              child: const Column(
                children: [
                  Icon(Icons.person, color: Color.fromARGB(255, 20, 116, 82)),
                  SizedBox(width: 8),
                  Text(
                    "Profile",
                    style: TextStyle(color: Color.fromARGB(255, 51, 51, 51)),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 35,
            child: TextButton(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Confirm Logout"),
                    content: const Text("Are you sure you want to log out?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text(
                          "Cancel",
                          style:
                              TextStyle(color: Color.fromARGB(255, 51, 51, 51)),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text(
                          "Logout",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                }
              },
              child: const Column(
                children: [
                  Icon(Icons.logout, color: Color.fromARGB(255, 20, 116, 82)),
                  SizedBox(width: 8),
                  Text(
                    "Logout",
                    style: TextStyle(color: Color.fromARGB(255, 51, 51, 51)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
