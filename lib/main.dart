import 'package:flutter/material.dart';
import 'stats_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const TodoListScreen(),
    );
  }
}

// ─── Modèle de données (ne pas modifier) ─────────────────────────────────────

class Task {
  final String title;
  bool isDone;

  Task({required this.title, this.isDone = false});
}

// ─── Écran principal ─────────────────────────────────────────────────────────

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<Task> _tasks = [
    Task(title: 'Acheter du pain'),
    Task(title: 'Réviser Flutter', isDone: true),
    Task(title: 'Préparer le rendu du projet'),
  ];

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma Todo List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            onPressed: () {
              final totalTasks = _tasks.length;
              final completedTasks = _tasks.where((task) => task.isDone).length;
              final remainingTasks = totalTasks - completedTasks;

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => StatsScreen(
                    totalTasks: totalTasks,
                    completedTasks: completedTasks,
                    remainingTasks: remainingTasks,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _tasks.isEmpty
          ? const Center(
              child: Text(
                'Aucune tâche pour le moment. Ajoutez-en une pour commencer.',
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];

                return Dismissible(
                  key: ValueKey('${task.title}_$index'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.redAccent,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    final deletedTask = _tasks[index];

                    setState(() {
                      _tasks.removeAt(index);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Task deleted: ${deletedTask.title}'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: Icon(
                      task.isDone
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: task.isDone
                          ? Colors.green
                          : Theme.of(context).colorScheme.outline,
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isDone
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isDone
                            ? Theme.of(context).colorScheme.outline
                            : null,
                        fontStyle: task.isDone
                            ? FontStyle.italic
                            : FontStyle.normal,
                      ),
                    ),
                    trailing: Switch(
                      value: task.isDone,
                      onChanged: (value) {
                        setState(() {
                          task.isDone = value;
                        });
                      },
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.clear();
          bool hasError = false;

          showDialog(
            context: context,
            builder: (dialogContext) {
              return StatefulBuilder(
                builder: (context, setDialogState) {
                  return AlertDialog(
                    title: const Text('Ajouter une tâche'),
                    content: TextField(
                      controller: _controller,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Titre de la tâche',
                        errorText: hasError
                            ? 'Le titre ne peut pas être vide ou composé d’espaces.'
                            : null,
                      ),
                      onChanged: (_) {
                        if (hasError) {
                          setDialogState(() => hasError = false);
                        }
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: const Text('Annuler'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final title = _controller.text.trim();

                          if (title.isEmpty) {
                            setDialogState(() => hasError = true);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Veuillez saisir une tâche valide.',
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }

                          setState(() {
                            _tasks.add(Task(title: title));
                          });
                          _controller.clear();
                          Navigator.of(dialogContext).pop();
                        },
                        child: const Text('Ajouter'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
