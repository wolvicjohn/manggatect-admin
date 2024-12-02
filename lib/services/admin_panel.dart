import 'package:adminmangga/services/adminsidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class AdminPanel extends StatefulWidget {
  final Widget body;

  const AdminPanel({super.key, required this.body});

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel>
    with AutomaticKeepAliveClientMixin {
  String selectedRoute = '/'; // Default selected route

  // Method to update selectedRoute when navigating
  void updateSelectedRoute(String newRoute) {
    setState(() {
      selectedRoute = newRoute;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(
        context); // Always call this in the `build` method of AutomaticKeepAliveClientMixin

    return AdminScaffold(
      appBar: AdminSideMenu.buildAppBar(context),
      sideBar: AdminSideMenu.buildSideBar(
        context,
        selectedRoute, // Pass the current selectedRoute to the sidebar
        updateSelectedRoute, // Pass the method to update selectedRoute
      ),
      body: widget.body,
    );
  }

  @override
  bool get wantKeepAlive => true; // Ensures the widget is kept alive
}
