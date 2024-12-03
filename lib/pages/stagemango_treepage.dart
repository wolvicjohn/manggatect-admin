import 'package:adminmangga/services/admin_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class Stagemango_treePage extends StatelessWidget {
  final String stage;
  final List<Map<String, dynamic>> mango_tree;

  const Stagemango_treePage(
      {Key? key, required this.stage, required this.mango_tree})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Mango Tree Table",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: mango_tree.isNotEmpty
                    ? SingleChildScrollView(
                        child: Table(
                          border: TableBorder.all(color: Colors.grey),
                          columnWidths: const {
                            1: FlexColumnWidth(1), // Longitude
                            2: FlexColumnWidth(1), // Latitude
                            3: FlexColumnWidth(1), // ID
                          },
                          children: [
                            const TableRow(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 20, 116, 82),
                              ),
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "ID",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Longitude",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Latitude",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ...mango_tree.map((mango_tree) {
                              return TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(mango_tree['id'] ?? 'Unknown'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        mango_tree['longitude']?.toString() ??
                                            '0.0'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        mango_tree['latitude']?.toString() ??
                                            '0.0'),
                                  ),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      )
                    : const Center(child: Text("No Data...")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
