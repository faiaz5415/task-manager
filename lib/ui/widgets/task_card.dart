import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {

  final String status;
  final Color statusColor;

  const TaskCard({
    super.key, required this.status, required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(8),
      ),
      tileColor: Colors.white,
      title: Text('Title will be here'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text('Description'),
          Text('Date: 12/1/2021', style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),),
          Row(
            children: [
              Chip(label: Text(status, style: TextStyle(
                color: Colors.white,
              ),),
                backgroundColor: statusColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                labelPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                side: BorderSide.none,
              ),
              Spacer(),
              IconButton(onPressed: (){}, icon: Icon(Icons.edit_note_outlined),color: Colors.green,),
              IconButton(onPressed: (){}, icon: Icon(Icons.delete_forever_outlined),color: Colors.red,),
            ],
          )
        ],
      ),
    );
  }
}
