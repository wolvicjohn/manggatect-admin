import 'package:flutter/material.dart';
import 'admin_panel_design.dart';

class AdminPanel extends StatelessWidget {
  final Widget body;

  const AdminPanel({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminPanelDesign.buildAppBar(context),
      body: Row(
        children: [
          // Persistent side menu
          const SideMenu(),
          // Main content area
          Expanded(
            child: body,
          ),
        ],
      ),
    );
  }
}
