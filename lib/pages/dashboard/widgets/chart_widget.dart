import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DoughnutChartWidget extends StatelessWidget {
  final Map<String, List<dynamic>> stageData;
  final List<dynamic> mangoTreeList;

  const DoughnutChartWidget({
    Key? key,
    required this.stageData,
    required this.mangoTreeList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 600,
          height: 600,
          child: SfCircularChart(
            legend: Legend(isVisible: true),
            series: <DoughnutSeries<_ChartData, String>>[
              DoughnutSeries<_ChartData, String>(
                dataSource: [
                  _ChartData('Stage 1', stageData['stage-1']!.length),
                  _ChartData('Stage 2', stageData['stage-2']!.length),
                  _ChartData('Stage 3', stageData['stage-3']!.length),
                  _ChartData('Stage 4', stageData['stage-4']!.length),
                  _ChartData('No Data Yet', stageData['no data yet']!.length),
                ],
                xValueMapper: (_ChartData data, _) => data.stage,
                yValueMapper: (_ChartData data, _) => data.count,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                radius: '80%',
                innerRadius: '60%',
              )
            ],
          ),
        ),
      
        const Positioned(
          top: 260,
          left: 210,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 20, 116, 82),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 280,
          left: 210,
          child: Text(
            mangoTreeList.length.toString(),
            style: const TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 20, 116, 82),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChartData {
  _ChartData(this.stage, this.count);
  final String stage;
  final int count;
}
