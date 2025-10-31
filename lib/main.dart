import 'package:flutter/material.dart';
import 'package:task_manager/app.dart';
import 'package:task_manager/data/auth_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthController.initializeUserCache();
  runApp(const TaskManagerApp());
}
