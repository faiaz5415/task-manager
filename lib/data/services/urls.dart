class Urls{
  static const String _baseUrl = 'http://35.73.30.144:2005/api/v1';

  static const String registrationUrl = '$_baseUrl/Registration';
  static const String loginUrl = '$_baseUrl/login';
  static const String updateProfileUrl = '$_baseUrl/profileUpdate';

  static const String newTaskListUrl = '$_baseUrl/listTaskByStatus/New';
  static const String progressTaskListUrl = '$_baseUrl/listTaskByStatus/InProgress';
  static const String completedTaskListUrl = '$_baseUrl/listTaskByStatus/Completed';
  static const String cancelledTaskListUrl = '$_baseUrl/listTaskByStatus/Cancelled';

  static const String taskStatusCountUrl = '$_baseUrl/taskStatusCount';

  static String deleteTaskUrl(String id) => '$_baseUrl/deleteTask/$id';
  static String updateTaskStatusUrl(String id, String status) => '$_baseUrl/updateTaskStatus/$id/$status';
}