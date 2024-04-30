import 'package:fl_chart/fl_chart.dart';
import './bar_chart_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BarChartContent extends StatelessWidget {
  const BarChartContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(BarChartData(
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              switch (value.toInt()) {
                case 1:
                  return const Text('Mon');
                case 2:
                  return const Text('Tues');
                case 3:
                  return const Text('Wed');
                case 4:
                  return const Text('Thu');
                case 5:
                  return const Text('Fri');
                case 6:
                  return const Text('Sat');
                case 7:
                  return const Text('Sun');
              }
              return const Text('');
            },
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            interval: 4,
            showTitles: true,
            getTitlesWidget: (value, meta) {
              if (value.toInt() == 0) {
                return const Text('');
              } else {
                return Text(value.toInt().toString());
              }
            },
            reservedSize: 40,
          ),
        ),
      ),
      borderData:
          FlBorderData(border: Border.all(color: Colors.white, width: 0.5)),
      alignment: BarChartAlignment.spaceEvenly,
      maxY: 15,
      barGroups: barChartGroupData,
    ));
  }
}
