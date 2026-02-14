import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../mood_registration/entities/mood_entry.dart';

/// Line chart: Y = Humores (1–5), X = Dias (PR01, PR01.1, PR01.2).
class MoodLineChart extends StatelessWidget {
  const MoodLineChart({super.key, required this.entries});

  final List<MoodEntry> entries;

  static const int _lastDaysCount = 7;

  @override
  Widget build(BuildContext context) {
    final refDate = entries.isNotEmpty
        ? (entries.map((e) => e.date).reduce((a, b) => a.isAfter(b) ? a : b))
        : DateTime.now();
    final refDateOnly = DateTime(refDate.year, refDate.month, refDate.day);
    final startDateOnly =
        refDateOnly.subtract(const Duration(days: _lastDaysCount - 1));
    final endExclusive = refDateOnly.add(const Duration(days: 1));
    final spotsInRange = entries
        .where((e) =>
            !e.date.isBefore(startDateOnly) && e.date.isBefore(endExclusive))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    final flSpots = spotsInRange
        .map((e) => FlSpot(
              e.date.difference(startDateOnly).inDays + 1.0,
              e.moodLevel.value.toDouble(),
            ))
        .toList();
    const minX = 1.0;
    final maxX = spotsInRange.isNotEmpty ? spotsInRange.map((e) => e.date.difference(startDateOnly).inDays + 1.0).reduce((a, b) => a > b ? a : b).ceilToDouble() : 1.0;
    final minY = 1.0;
    const maxY = 5.0;
    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          minX: minX - 0.6,
          maxX: maxX + 0.6,
          minY: minY - 0.5,
          maxY: maxY + 0.5,
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (spot) => Colors.black.withValues(alpha: spot.y.toInt() == 1 ? 1.0 : 0.5),
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((spot) => LineTooltipItem(
                  switch (spot.y.toInt()) {
                    1 => "Horrível",
                    2 => "Mal",
                    3 => "Mais ou Menos",
                    4 => "Bem",
                    _ => "Ótimo",
                  },
                  TextStyle(color: Colors.white),
                )).toList();
            }),
          ),
          lineBarsData: [
            LineChartBarData(
              showingIndicators: [0],
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
                getTitlesWidget: (value, meta) {
                  final emoji = switch (value.toInt()) {
                    1 => "😞",
                    2 => "😢",
                    3 => "😐",
                    4 => "😊",
                    5 => "😀",
                    _ => "",
                  };
                  return Text(
                    emoji,
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                interval: 1.0,
                getTitlesWidget: (value, meta) {
                  final dayDate =
                      startDateOnly.add(Duration(days: value.round() - 1));
                  return Text(
                    dayDate.day.toString(),
                    style: const TextStyle(fontSize: 10),
                  );
                },
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
