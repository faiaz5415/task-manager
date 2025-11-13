import 'package:flutter/material.dart';

class Status {
  static const String aNew = 'New';
  static const String progress = 'Progress';
  static const String completed = 'Completed';
  static const String cancelled = 'Cancelled';

  static List<String> get values => [aNew, progress, completed, cancelled];
}

class StatusChangeBottomSheet extends StatelessWidget {
  final String currentStatus;
  final Function(String) onStatusChanged;

  const StatusChangeBottomSheet({
    super.key,
    required this.currentStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: Status.values
          .map(
            (status) => RadioListTile<String>(
              title: Text(status),
              value: status,
              groupValue: currentStatus,
              onChanged: (String? newStatus) {
                if (newStatus != null) {
                  onStatusChanged(newStatus);
                  Navigator.pop(context);
                }
              },
            ),
          )
          .toList(),
    );
  }
}
