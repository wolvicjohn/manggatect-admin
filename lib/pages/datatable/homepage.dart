import 'package:adminmangga/pages/datatable/tree_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:adminmangga/pages/datatable/tree_data_table.dart';

class Homepage extends StatelessWidget {
  // Changed to StatelessWidget since we don't need state anymore
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 20, 116, 82),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0, 6),
                              blurRadius: 12.0,
                              spreadRadius: 0.0,
                            ),
                          ],
                        ),
                        // margin: EdgeInsets.all(16),
                        child: const Text(
                          'Mango Tree Records',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
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
      ),
    );
  }
}
