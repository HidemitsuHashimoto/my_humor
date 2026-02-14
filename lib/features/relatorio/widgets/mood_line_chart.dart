import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../mood_registration/entities/mood_entry.dart';

/// Line chart: Y = Humores (1–5), X = Dias (PR01, PR01.1, PR01.2).
class MoodLineChart extends StatelessWidget {
  const MoodLineChart({super.key, required this.entries});

  final List<MoodEntry> entries;

  @override
  Widget build(BuildContext context) {
    final spots = List<MoodEntry>.from(entries)
      ..sort((a, b) => a.date.compareTo(b.date));
    final flSpots = spots
        .map((e) => FlSpot(e.date.day.toDouble(), e.moodLevel.value.toDouble()))
        .toList();
    final minX = flSpots.isEmpty ? 0.0 : flSpots.map((s) => s.x).reduce((a, b) => a < b ? a : b).floorToDouble();
    final maxX = flSpots.isEmpty ? 31.0 : flSpots.map((s) => s.x).reduce((a, b) => a > b ? a : b).ceilToDouble();
    final minY = 1.0;
    const maxY = 5.0;
    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          minX: (minX - 1).clamp(0, 31).toDouble(),
          maxX: (maxX + 1).clamp(1, 31).toDouble(),
          minY: minY - 0.5,
          maxY: maxY + 0.5,
          lineBarsData: [
            LineChartBarData(
              spots: flSpots,
              isCurved: true,
              barWidth: 2,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(show: false),
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
        ),
      ),
    );
  }
}
