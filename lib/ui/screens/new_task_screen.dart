import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/data/models/task_status_counter_provider.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/widgets/center_circular_progress.dart';
import 'package:task_manager/ui/widgets/center_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/delete_confirmation_dialog.dart';
import 'package:task_manager/ui/widgets/status_change_bottom_sheet.dart';
import 'package:task_manager/ui/widgets/task_count_by_status_card.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/snackbar_message.dart';
import '../widgets/task_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().getNewTasks();
      context.read<TaskProvider>().getTaskCountByStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Consumer<TaskProvider>(
              builder: (context, provider, _) {
                if (provider.inProgress) {
                  return const SizedBox(
                    height: 90,
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return SizedBox(
                    height: 90,
                    child: ListView.separated(
                      itemCount: provider.taskCountByStatus.taskCounts.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final taskCount = provider.taskCountByStatus.taskCounts[index];
                        return TaskCountByStatusCard(
                          title: taskCount.id,
                          count: taskCount.sum,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(width: 4);
                      },
                    ),
                  );
                }
              },
            ),
            Expanded(
              child: Consumer<TaskProvider>(
                builder: (context, provider, _) {
                  if (provider.inProgress) {
                    return const centerdCircularProgressIndicator();
                  } else if (provider.errorMessage.isNotEmpty) {
                    return Center(
                      child: Text(provider.errorMessage),
                    );
                  } else {
                    return RefreshIndicator(
                      onRefresh: () async {
                        await context.read<TaskProvider>().getNewTasks();
                        await context.read<TaskProvider>().getTaskCountByStatus();
                      },
                      child: ListView.separated(
                        itemCount: provider.newTasks.tasks.length,
                        itemBuilder: (context, index) {
                          final task = provider.newTasks.tasks[index];
                          return TaskCard(
                            task: task,
                            onEdit: () => _showStatusChangeBottomSheet(task),
                            onDelete: () => _showDeleteConfirmationDialog(task.id), status: '', statusColor: Colors.purpleAccent,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 10);
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const AddNewTaskScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmationDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        onConfirm: () async {
          final success = await context.read<TaskProvider>().deleteTask(id);
          if (success) {
            showSnackBarMessage(context, 'Task deleted successfully');
          } else {
            showSnackBarMessage(
                context, context.read<TaskProvider>().errorMessage);
          }
        },
      ),
    );
  }

  void _showStatusChangeBottomSheet(Task task) {
    showModalBottomSheet(
      context: context,
      builder: (context) => StatusChangeBottomSheet(
        currentStatus: task.status,
        onStatusChanged: (newStatus) async {
          final success = await context
              .read<TaskProvider>()
              .updateTaskStatus(task.id, newStatus);
          if (success) {
            showSnackBarMessage(context, 'Task status updated successfully');
          } else {
            showSnackBarMessage(
                context, context.read<TaskProvider>().errorMessage);
          }
        },
      ),
    );
  }
}
