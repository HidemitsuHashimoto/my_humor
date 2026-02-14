import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/routes/app_router.dart';
import '../controllers/home_controller.dart';
import '../widgets/mood_buttons_row.dart';

/// Home page: shown when user has not registered mood for today (N01).
/// PH01–PH06: 5 mood buttons, 1 option, 1 observation, save, local persistence.
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _observationController = TextEditingController();

  @override
  void dispose() {
    _observationController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final success = await ref.read(homeControllerProvider.notifier).save();
    if (!mounted) return;
    if (success) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.relatorio);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Como você está hoje?')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Text(
              'Como está o seu humor hoje?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            MoodButtonsRow(
              selectedMood: state.selectedMood,
              onMoodSelected: (mood) =>
                  ref.read(homeControllerProvider.notifier).selectMood(mood),
            ),
            const SizedBox(height: 24),
            Text(
              'Observação',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _observationController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Opcional',
                border: OutlineInputBorder(),
              ),
              onChanged: (text) =>
                  ref.read(homeControllerProvider.notifier).setObservation(text),
            ),
            if (state.saveError != null) ...[
              const SizedBox(height: 8),
              Text(
                state.saveError!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 32),
            FilledButton(
              onPressed: state.isSaving ? null : _handleSave,
              child: state.isSaving
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Salvar humor'),
            ),
          ],
        ),
      ),
    );
  }
}
