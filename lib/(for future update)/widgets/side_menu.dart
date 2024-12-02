import 'package:adminmangga/(for%20future%20update)/constants/controllers.dart';
import 'package:adminmangga/(for%20future%20update)/constants/style.dart';
import 'package:adminmangga/(for%20future%20update)/helpers/responsiveness.dart';
import 'package:adminmangga/(for%20future%20update)/routing/routes.dart';
import 'package:adminmangga/(for%20future%20update)/widgets/custom_text.dart';
import 'package:adminmangga/(for%20future%20update)/widgets/side_menu_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Container(
      color: light,
      child: ListView(
        children: [
          if (ResponsiveWidget.isSmallScreen(context))
            _buildLogoAndName(_width),
          SizedBox(height: 40),
          Divider(color: lightgrey.withOpacity(.1)),
          _buildMenuItems(context),
        ],
      ),
    );
  }

  // Helper method to build logo and app name for small screens
  Widget _buildLogoAndName(double width) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 40),
        Row(
          children: [
            SizedBox(width: width / 48),
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: Image.asset("assets/images/logo.png"),
            ),
            Flexible(
              child: CustomText(
                text: "MANGGACTECH",
                size: 20,
                color: active,
                weight: FontWeight.bold,
              ),
            ),
            SizedBox(width: width / 48),
          ],
        ),
      ],
    );
  }

  // Helper method to build menu items
  Widget _buildMenuItems(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: sideMenuItemsRoute.map((itemName) {
        return SideMenuItems(
          itemName: itemName,
          onTap: () {
            _handleMenuItemTap(itemName, context);
          },
        );
      }).toList(),
    );
  }

  // Handles menu item tap actions
  void _handleMenuItemTap(String itemName, BuildContext context) {
    if (itemName == authenticationPageRoute) {
      // Navigate to Authentication page (implement the navigation)
    }

    if (!menuController.isActive(itemName)) {
      menuController.changeActiveitemTo(itemName);
      if (ResponsiveWidget.isSmallScreen(context)) Get.back();
      // Navigate to the page associated with the item (implement actual navigation)
      Get.toNamed(itemName); // Replace with actual route name logic
    }
  }
}
