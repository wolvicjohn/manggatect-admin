import 'package:adminmangga/(for%20future%20update)/constants/controllers.dart';
import 'package:adminmangga/(for%20future%20update)/constants/style.dart';
import 'package:adminmangga/(for%20future%20update)/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class VerticalMenuItem extends StatelessWidget {
  final String itemName;
  final Function onTap;
  const VerticalMenuItem({
    super.key,
    required this.itemName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap(),
      onHover: (value) {
        value
            ? menuController.onhover(itemName)
            : menuController.onhover("not hovering");
      },
      child: Obx(
        () => Container(
          color: menuController.isHovering(itemName)
              ? lightgrey.withOpacity(.1)
              : Colors.transparent,
          child: Row(
            children: [
              Visibility(
                visible: menuController.isHovering(itemName) ||
                    menuController.isActive(itemName),
                maintainSize: true,
                maintainState: true,
                maintainAnimation: true,
                child: Container(
                  width: 3,
                  height: 72,
                  color: dark,
                ),
              ),
              Expanded(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: menuController.returnIconFor(itemName),
                  ),
                  if (!menuController.isActive(itemName))
                    Flexible(
                      child: CustomText(
                          text: itemName,
                          size: 16,
                          color: menuController.isHovering(itemName)
                              ? dark
                              : lightgrey,
                          weight: FontWeight.normal),
                    )
                  else
                    Flexible(
                      child: CustomText(
                        text: itemName,
                        size: 18,
                        color: dark,
                        weight: FontWeight.bold,
                      ),
                    ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
