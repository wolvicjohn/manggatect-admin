// admin_panel.dart
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'admin_panel_design.dart';

class AdminPanel extends StatelessWidget {
  final Widget body;

  const AdminPanel({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AdminPanelDesign.buildAppBar(context),
      sideBar: AdminPanelDesign.buildSideBar(context),
      body: body,
    );
  }
}
