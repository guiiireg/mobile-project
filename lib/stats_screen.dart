import 'package:flutter/material.dart';

// ─── Écran Statistiques (F6) ─────────────────────────────────────────────────
// À compléter entièrement : propriétés, constructeur, affichage des données.

class StatsScreen extends StatelessWidget {
  final int totalTasks;
  final int completedTasks;
  final int remainingTasks;

  const StatsScreen({
    super.key,
    required this.totalTasks,
    required this.completedTasks,
    required this.remainingTasks,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              margin: const EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Total de tâches : $totalTasks'),
                    Text('Tâches terminées : $completedTasks'),
                    Text('Tâches restantes : $remainingTasks'),
                    Text(
                      'Pourcentage de complétion : ${totalTasks > 0 ? ((completedTasks / totalTasks) * 100).toStringAsFixed(2) : 'N/A'}%',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
