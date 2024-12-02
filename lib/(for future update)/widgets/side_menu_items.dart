import 'package:adminmangga/(for%20future%20update)/helpers/responsiveness.dart';
import 'package:adminmangga/(for%20future%20update)/widgets/horizontal_menu_item.dart';
import 'package:adminmangga/(for%20future%20update)/widgets/vertical_menu_item.dart';
import 'package:flutter/material.dart';

class SideMenuItems extends StatelessWidget {
  final String itemName;
  final Function onTap;

  const SideMenuItems({
    super.key,
    required this.itemName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveWidget.isCustomSize(context)) {
      return VerticalMenuItem(
        itemName: itemName,
        onTap: onTap, 
      );
    }
    return HorizontalMenuItem(
      itemName: itemName,
      onTap: onTap,
    );
  }
}
