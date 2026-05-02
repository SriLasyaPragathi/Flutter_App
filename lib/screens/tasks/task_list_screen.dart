import 'package:flutter/material.dart';
import '../../models/task_model.dart';
import '../../services/task_service.dart';
import 'task_create_screen.dart';
import 'task_edit_screen.dart';

/// Task List Screen - displays all tasks with CRUD operations
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  /// Load tasks from Back4App
  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
    });

    final loadedTasks = await TaskService.fetchAllTasks();
    if (mounted) {
      setState(() {
        tasks = loadedTasks;
        _isLoading = false;
      });
    }
  }

  /// Delete task with confirmation
  Future<void> _deleteTask(Task task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && task.id != null) {
      final success = await TaskService.deleteTask(task.id!);
      if (success) {
        _loadTasks();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Task deleted successfully')),
          );
        }
      }
    }
  }

  /// Handle task completion toggle
  Future<void> _toggleTaskCompletion(Task task) async {
    if (task.id != null) {
      await TaskService.toggleTaskCompletion(task.id!, task.isCompleted);
      _loadTasks();
    }
  }

  /// Navigate to edit task screen
  Future<void> _editTask(Task task) async {
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (context) => TaskEditScreen(task: task)),
    );

    if (updated == true) {
      _loadTasks();
    }
  }

  /// Navigate to create task screen
  Future<void> _createTask() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (context) => const TaskCreateScreen()),
    );

    if (created == true) {
      _loadTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : tasks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 80, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'No tasks yet',
                        style: TextStyle(
                            fontSize: 18, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap the button below to create one',
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadTasks,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Card(
                        color: task.isCompleted
                            ? Colors.green.shade50
                            : Colors.white,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            value: task.isCompleted,
                            onChanged: (value) {
                              if (value != null) {
                                _toggleTaskCompletion(task);
                              }
                            },
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  task.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: task.isCompleted
                                        ? Colors.green.shade800
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              if (task.isCompleted)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade600,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'Completed',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Text(
                            task.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: task.isCompleted
                                  ? Colors.green.shade700
                                  : Colors.grey.shade600,
                            ),
                          ),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Edit button
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () => _editTask(task),
                                ),
                                // Delete button
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _deleteTask(task),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createTask,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
