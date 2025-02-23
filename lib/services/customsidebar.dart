// import 'package:flutter/material.dart';
// import 'package:flutter_admin_scaffold/admin_scaffold.dart';

// class CustomSidebar extends StatelessWidget {
//   final String selectedRoute;
//   final Function(String) onRouteSelected;

//   const CustomSidebar({
//     Key? key,
//     required this.selectedRoute,
//     required this.onRouteSelected,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SideBar(
//       items: const [
//         AdminMenuItem(
//           title: 'Dashboard',
//           route: '/',
//           icon: Icons.dashboard,
//         ),
//         AdminMenuItem(
//           title: 'Data',
//           route: '/homepage',
//           icon: Icons.note,
//         ),
//         AdminMenuItem(
//           title: 'Map',
//           route: '/tree-map',
//           icon: Icons.map,
//         ),
//         AdminMenuItem(
//           title: 'Archive',
//           route: '/archivepage',
//           icon: Icons.archive,
//         ),
//       ],
//       selectedRoute:
//           selectedRoute, // This is passed to highlight the selected item
//       onSelected: (item) {
//         if (item.route != null) {
//           onRouteSelected(item.route!);
//         }
//       },
//     );
//   }
// }
