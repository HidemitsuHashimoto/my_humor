import 'package:flutter/material.dart';

import '../../../core/widgets/humor_icon.dart';
import '../../mood_registration/entities/mood_level.dart';

/// Five mood buttons in order (PH01): Horrível, Mal, Mais ou Menos, Bem, Ótimo.
class MoodButtonsRow extends StatelessWidget {
  const MoodButtonsRow({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  final MoodLevel? selectedMood;
  final ValueChanged<MoodLevel> onMoodSelected;

  static final List<MoodLevel> _order = MoodLevel.values;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _order.map((mood) => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: _MoodButton(
            mood: mood,
            isSelected: selectedMood == mood,
            onTap: () => onMoodSelected(mood),
          ),
        ),
      )).toList(),
    );
  }
}

class _MoodButton extends StatelessWidget {
  const _MoodButton({
    required this.mood,
    required this.isSelected,
    required this.onTap,
  });

  final MoodLevel mood;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              switch (mood) {
                MoodLevel.horrible => HumorIcon(text: "😞"),
                MoodLevel.bad => HumorIcon(text: "😢"),
                MoodLevel.okay => HumorIcon(text: "😐"),
                MoodLevel.good => HumorIcon(text: "😊"),
                MoodLevel.great => HumorIcon(text: "😀"),
              },
              const SizedBox(height: 4),
              Text(
                mood.label,
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
