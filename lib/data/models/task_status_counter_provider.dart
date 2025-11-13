import 'package:flutter/material.dart';
import '../services/api_caller.dart';
import '../services/urls.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final String status;
  final String createdDate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdDate,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["_id"] ?? '',
        title: json["title"] ?? '',
        description: json["description"] ?? '',
        status: json["status"] ?? '',
        createdDate: json["createdDate"] ?? '',
      );
}

class TaskListModel {
  final List<Task> tasks;

  TaskListModel({required this.tasks});

  factory TaskListModel.fromJson(Map<String, dynamic> json) {
    return TaskListModel(
      tasks: json["data"] == null
          ? []
          : List<Task>.from(json["data"].map((x) => Task.fromJson(x))),
    );
  }
}

class TaskCount {
  final String id;
  final int sum;

  TaskCount({required this.id, required this.sum});

  factory TaskCount.fromJson(Map<String, dynamic> json) => TaskCount(
        id: json["_id"] ?? '',
        sum: json["sum"] ?? 0,
      );
}

class TaskCountByStatusModel {
  final List<TaskCount> taskCounts;

  TaskCountByStatusModel({required this.taskCounts});

  factory TaskCountByStatusModel.fromJson(Map<String, dynamic> json) {
    return TaskCountByStatusModel(
      taskCounts: json["data"] == null
          ? []
          : List<TaskCount>.from(
              json["data"].map((x) => TaskCount.fromJson(x))),
    );
  }
}

class TaskProvider extends ChangeNotifier {
  TaskListModel _newTasks = TaskListModel(tasks: []);
  TaskListModel _progressTasks = TaskListModel(tasks: []);
  TaskListModel _completedTasks = TaskListModel(tasks: []);
  TaskListModel _cancelledTasks = TaskListModel(tasks: []);
  TaskCountByStatusModel _taskCountByStatus = TaskCountByStatusModel(taskCounts: []);

  bool _inProgress = false;
  String _errorMessage = '';

  TaskListModel get newTasks => _newTasks;
  TaskListModel get progressTasks => _progressTasks;
  TaskListModel get completedTasks => _completedTasks;
  TaskListModel get cancelledTasks => _cancelledTasks;
  TaskCountByStatusModel get taskCountByStatus => _taskCountByStatus;

  bool get inProgress => _inProgress;
  String get errorMessage => _errorMessage;

  Future<bool> getNewTasks() async {
    return _getTasks(Urls.newTaskListUrl, (tasks) => _newTasks = tasks);
  }

  Future<bool> getProgressTasks() async {
    return _getTasks(Urls.progressTaskListUrl, (tasks) => _progressTasks = tasks);
  }

  Future<bool> getCompletedTasks() async {
    return _getTasks(Urls.completedTaskListUrl, (tasks) => _completedTasks = tasks);
  }

  Future<bool> getCancelledTasks() async {
    return _getTasks(Urls.cancelledTaskListUrl, (tasks) => _cancelledTasks = tasks);
  }

  Future<bool> getTaskCountByStatus() async {
    bool isSuccess = false;
    _inProgress = true;
    notifyListeners();

    final response = await NetworkCaller.getRequest(url: Urls.taskStatusCountUrl);

    if (response.isSuccess) {
      _taskCountByStatus = TaskCountByStatusModel.fromJson(response.body!);
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'Failed to fetch task count';
    }

    _inProgress = false;
    notifyListeners();
    return isSuccess;
  }

  Future<bool> _getTasks(String url, Function(TaskListModel) onsuccess) async {
    bool isSuccess = false;
    _inProgress = true;
    notifyListeners();

    final response = await NetworkCaller.getRequest(url: url);

    if (response.isSuccess) {
      onsuccess(TaskListModel.fromJson(response.body!));
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'Failed to fetch tasks';
    }

    _inProgress = false;
    notifyListeners();
    return isSuccess;
  }

  Future<bool> deleteTask(String id) async {
    final response = await NetworkCaller.getRequest(url: Urls.deleteTaskUrl(id));
    if (response.isSuccess) {
      _newTasks.tasks.removeWhere((element) => element.id == id);
      _progressTasks.tasks.removeWhere((element) => element.id == id);
      _completedTasks.tasks.removeWhere((element) => element.id == id);
      _cancelledTasks.tasks.removeWhere((element) => element.id == id);
      await getTaskCountByStatus();
      notifyListeners();
      return true;
    } else {
      _errorMessage = response.errorMessage ?? 'Failed to delete task';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTaskStatus(String id, String status) async {
    final response = await NetworkCaller.getRequest(url: Urls.updateTaskStatusUrl(id, status));
    if (response.isSuccess) {
      await getNewTasks();
      await getProgressTasks();
      await getCompletedTasks();
      await getCancelledTasks();
      await getTaskCountByStatus();
      return true;
    } else {
      _errorMessage = response.errorMessage ?? 'Failed to update task status';
      notifyListeners();
      return false;
    }
  }
}
