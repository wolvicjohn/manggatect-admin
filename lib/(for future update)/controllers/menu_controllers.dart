import 'package:adminmangga/(for%20future%20update)/constants/style.dart';
import 'package:adminmangga/(for%20future%20update)/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuController extends GetxController {
  // This line assumes that you have already registered MenuController via Get.put(MenuController())
  static MenuController instance = Get.find();

  var activeItem = dashboardPageRoute.obs; // The initial active item route (adjust if needed)
  var hoverItem = "".obs;

  // Change the active menu item
  void changeActiveitemTo(String itemName) {
    activeItem.value = itemName;
  }

  // Handle hover action for menu items
  void onhover(String itemName) {
    if (!isActive(itemName)) {
      hoverItem.value = itemName;
    }
  }

  // Check if the menu item is the active one
  bool isActive(String itemName) => activeItem.value == itemName;

  // Check if the menu item is being hovered over
  bool isHovering(String itemName) => hoverItem.value == itemName;

  // Return the appropriate icon for the menu item
  Widget returnIconFor(String itemName) {
    switch (itemName) {
      case dashboardPageRoute:
        return _customIcon(Icons.dashboard_rounded, itemName);
      case dataPageRoute:
        return _customIcon(Icons.notes_rounded, itemName);
      case mapPageRoute:
        return _customIcon(Icons.map, itemName);
      default:
        return _customIcon(Icons.exit_to_app, itemName);
    }
  }

  // Custom icon with color based on active or hover state
  Widget _customIcon(IconData icon, String itemName) {
    // Check if the item is active, and apply a color for the active item
    if (isActive(itemName)) {
      return Icon(icon, size: 22, color: dark);
    }

    // Check if the item is being hovered over, apply hover color
    return Icon(
      icon,
      color: isHovering(itemName) ? dark : lightgrey,
    );
  }
}
