import 'package:adminmangga/services/header.dart';
import 'package:flutter/material.dart';
import '../report/tree_progress_report.dart';
import 'widgets/tree_details_content.dart';

class TreeDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> treeData;

  const TreeDetailsDialog({
    super.key,
    required this.treeData,
  });

  static void show(BuildContext context, Map<String, dynamic> treeData) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: TreeDetailsDialog(treeData: treeData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 1000,
          minWidth: 700,
          maxHeight: double.infinity,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // Header
            const CustomHeader(title: "Mango Tree Details", description: ""),

            // Content Section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tree details and flower stage image
                    TreeDetailsContent(treeData: treeData),

                    const Divider(),
                    const SizedBox(height: 24),

                    // Action Buttons
                    // ActionButtons(treeData: treeData),

                    // const SizedBox(height: 24.0),

                    // Progress Report Section
                    const Center(
                      child: Text(
                        "Progress Report",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TreeProgressReport(docID: treeData['docID']),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
