import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_humor/core/widgets/humor_icon.dart';

import '../../mood_registration/entities/mood_entry.dart';
import '../../mood_registration/entities/mood_level.dart';

/// Pie chart: total de registros por humor no mês.
class MoodPieChart extends StatelessWidget {
  const MoodPieChart({super.key, required this.entries});

  final List<MoodEntry> entries;

  static const Map<MoodLevel, Color> _moodColors = {
    MoodLevel.horrible: Color(0xFFD32F2F),
    MoodLevel.bad: Color(0xFFF57C00),
    MoodLevel.okay: Color(0xFF757575),
    MoodLevel.good: Color(0xFF7CB342),
    MoodLevel.great: Color(0xFF388E3C),
  };

  @override
  Widget build(BuildContext context) {
    final counts = _countByMoodLevel(entries);
    final total = entries.length;
    final sections = MoodLevel.values
        .where((level) => counts[level]! > 0)
        .map(
          (level) => PieChartSectionData(
            value: counts[level]!.toDouble(),
            title: total > 0 ? '${counts[level]}' : '',
            color: _moodColors[level]!,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            radius: 60,
          ),
        )
        .toList();
    if (sections.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('Nenhum registro no mês')),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'Total de humores no mês',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SizedBox(
          height: 220,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: PieChart(
                  PieChartData(
                    sections: sections,
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                  ),
                ),
              ),
              Expanded(
                child: _buildLegend(counts),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Map<MoodLevel, int> _countByMoodLevel(List<MoodEntry> entries) {
    final counts = {
      MoodLevel.horrible: 0,
      MoodLevel.bad: 0,
      MoodLevel.okay: 0,
      MoodLevel.good: 0,
      MoodLevel.great: 0,
    };
    for (final e in entries) {
      counts[e.moodLevel] = counts[e.moodLevel]! + 1;
    }
    return counts;
  }

  Widget _buildLegend(Map<MoodLevel, int> counts) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: MoodLevel.values
          .where((level) => counts[level]! > 0)
          .map(
            (level) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _moodColors[level],
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  HumorIcon(text: switch (level) {
                    MoodLevel.horrible => "😞",
                    MoodLevel.bad => "😢",
                    MoodLevel.okay => "😐",
                    MoodLevel.good => "😊",
                    MoodLevel.great => "😀",
                  }, fontSize: 12,),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      '${level.label}: ${counts[level]}',
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
