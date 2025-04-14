import 'package:adminmangga/pages/datatable/details/tree_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:adminmangga/pages/datatable/table/tree_data_table.dart';

import '../../services/header.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomHeader(
            title: 'All Mango Tree Records',
            description:
                'An interactive table that visualizes the records of all mango trees.',
          ),

          const SizedBox(
            height: 16,
          ),

          // Main Content
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TreeDataTable(
                onSelectTree: (treeData) {
                  TreeDetailsDialog.show(context, treeData);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
