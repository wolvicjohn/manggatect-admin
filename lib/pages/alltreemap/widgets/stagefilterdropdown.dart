import 'package:flutter/material.dart';

class StageFilterDropdown extends StatelessWidget {
  final String selectedStage;
  final List<String> stages;
  final ValueChanged<String> onChanged;

  const StageFilterDropdown({
    super.key,
    required this.selectedStage,
    required this.stages,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: const Color.fromARGB(255, 20, 116, 82)),
            ),
            child: DropdownButton<String>(
              value: selectedStage,
              icon: const Icon(Icons.arrow_downward, color: Colors.black87),
              elevation: 16,
              style: const TextStyle(color: Colors.black87),
              dropdownColor: Colors.white,
              onChanged: (String? newValue) {
                if (newValue != null) onChanged(newValue);
              },
              items: stages.map<DropdownMenuItem<String>>((String stage) {
                return DropdownMenuItem<String>(
                  value: stage,
                  child: Text(stage),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'LEGENDS',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _legendRow('assets/images/tree_icon.png', 'Stage 1'),
          _legendRow('assets/images/stage1_icon.png', 'Stage 2'),
          _legendRow('assets/images/stage2_icon.png', 'Stage 3'),
          _legendRow('assets/images/stage3_icon.png', 'Stage 4'),
          _legendRow('assets/images/no_flower.png', 'No Flower'),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _legendRow(String iconPath, String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(iconPath, height: 40, width: 40),
        const SizedBox(width: 10),
        Text(label),
      ],
    );
  }
}
