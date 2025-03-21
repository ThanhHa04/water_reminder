import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lịch sử")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tháng 3 2025", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: [
                    BarChartGroupData(x: 3, barRods: [BarChartRodData(fromY: 0, toY: 40, color: Colors.blue)]),
                    BarChartGroupData(x: 21, barRods: [BarChartRodData(fromY: 0, toY: 50, color: Colors.blue)],),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) => Icon(Icons.shield, color: index >= 5 ? Colors.blue : Colors.grey)),
            ),
            SizedBox(height: 20),
            Text("Báo cáo nước uống", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Trung bình hàng tuần"),
                Text("200 ml/ngày", style: TextStyle(color: Colors.blue))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Trung bình hàng tháng"),
                Text("117 ml/ngày", style: TextStyle(color: Colors.blue))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Hoàn thành trung bình"),
                Text("5%", style: TextStyle(color: Colors.orange))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
