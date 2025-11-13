import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/data/models/task_status_counter_provider.dart';
import 'package:task_manager/ui/widgets/center_circular_progress.dart';
import 'package:task_manager/ui/widgets/center_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/delete_confirmation_dialog.dart';
import 'package:task_manager/ui/widgets/status_change_bottom_sheet.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/snackbar_message.dart';
import '../widgets/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().getCompletedTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  await context.read<TaskProvider>().getCompletedTasks();
                },
                child: ListView.separated(
                  itemCount: provider.completedTasks.tasks.length,
                  itemBuilder: (context, index) {
                    final task = provider.completedTasks.tasks[index];
                    return TaskCard(
                      task: task,
                      onEdit: () => _showStatusChangeBottomSheet(task),
                      onDelete: () => _showDeleteConfirmationDialog(task.id), status: '', statusColor: Colors.greenAccent,
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
