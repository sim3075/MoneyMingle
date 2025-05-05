import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpenseLineChart extends StatelessWidget {
  final List<double> expenses;

  const ExpenseLineChart({
    super.key,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          maxY: 1200, // Máximo valor en el eje Y
          minY: 0, // Mínimo valor en el eje Y
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 300, // Espaciado entre los valores del eje Y
                getTitlesWidget: (value, meta) {
                  return Text(
                    '\$${value.toInt()}',
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 10, // Espaciado entre los valores del eje X
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            horizontalInterval: 300,
            verticalInterval: 10,
          ),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              left: BorderSide(color: Colors.black, width: 1),
              bottom: BorderSide(color: Colors.black, width: 1),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                expenses.length,
                (index) => FlSpot(index.toDouble() + 1, expenses[index]),
              ),
              isCurved: true,
              color: Colors.red,
              barWidth: 3,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(
                show: true,
                color: Colors.red.withOpacity(0.2),
              ),
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}