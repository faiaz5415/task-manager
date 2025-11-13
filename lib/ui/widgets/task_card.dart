import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_status_counter_provider.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete, required String status, required MaterialAccentColor statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      tileColor: Colors.white,
      title: Text(task.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(task.description),
          Text(
            'Date: ${task.createdDate}',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Row(
            children: [
              Chip(
                label: Text(
                  task.status,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                labelPadding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                visualDensity:
                    const VisualDensity(horizontal: -4, vertical: -4),
                side: BorderSide.none,
              ),
              const Spacer(),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_note_outlined),
                color: Colors.green,
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_forever_outlined),
                color: Colors.red,
              ),
            ],
          )
        ],
      ),
    );
  }
}
