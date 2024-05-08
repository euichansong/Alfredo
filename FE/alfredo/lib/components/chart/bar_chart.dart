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
                  return const Text('월');
                case 2:
                  return const Text('화');
                case 3:
                  return const Text('수');
                case 4:
                  return const Text('목');
                case 5:
                  return const Text('금');
                case 6:
                  return const Text('토');
                case 0:
                  return const Text('일');
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


// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import './chart_api.dart'; // ChartApi 경로를 확인하세요.

// class BarChartContent extends ConsumerWidget {
//   const BarChartContent({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return FutureBuilder<List<BarChartGroupData>>(
//       future: ChartApi.fetchChartData(ref), // API에서 데이터를 가져옵니다.
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           if (snapshot.hasData) {
//             return BarChart(BarChartData(
//               titlesData: FlTitlesData(
//                 bottomTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     reservedSize: 30,
//                     getTitlesWidget: (value, meta) {
//                       switch (value.toInt()) {
//                         case 0: return const Text('일');
//                         case 1: return const Text('월');
//                         case 2: return const Text('화');
//                         case 3: return const Text('수');
//                         case 4: return const Text('목');
//                         case 5: return const Text('금');
//                         case 6: return const Text('토');
//                         default: return const Text('');
//                       }
//                     },
//                     interval: 1,
//                   ),
//                 ),
//                 leftTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     interval: 4,
//                     showTitles: true,
//                     getTitlesWidget: (value, meta) {
//                       if (value.toInt() == 0) {
//                         return const Text('');
//                       } else {
//                         return Text(value.toInt().toString());
//                       }
//                     },
//                     reservedSize: 40,
//                   ),
//                 ),
//               ),
//               borderData: FlBorderData(
//                 border: Border.all(color: Colors.white, width: 0.5)
//               ),
//               alignment: BarChartAlignment.spaceEvenly,
//               maxY: 15,
//               barGroups: snapshot.data!, // 데이터를 차트에 적용합니다.
//             ));
//           } else if (snapshot.hasError) {
//             return Text("Error: ${snapshot.error}");
//           }
//         }
//         return const CircularProgressIndicator(); // 데이터 로딩 중 표시
//       },
//     );
//   }
// }
