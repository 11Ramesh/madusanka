import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartHome extends StatelessWidget {
  PieChartHome({
    required this.dataMap,
    super.key,
  });
  Map<String, double> dataMap;
  @override
  Widget build(BuildContext context) {
    List<Color> colorList = [
      Colors.blue,
      Colors.red,
    ];

    return PieChart(
      dataMap: dataMap,
      animationDuration: const Duration(milliseconds: 1000),
      chartLegendSpacing: MediaQuery.of(context).size.width / 30,
      chartRadius: MediaQuery.of(context).size.width / 2,
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: ChartType.disc,
      ringStrokeWidth: 32,
      //centerText: "HYBRID",
      legendOptions: const LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: true,
        legendShape: BoxShape.circle,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      chartValuesOptions: const ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: true,
        showChartValuesOutside: false,
        decimalPlaces: 0,
      ),
    );
  }
}
