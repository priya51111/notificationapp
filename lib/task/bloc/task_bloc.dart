import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notificationapp/login/repository/repository.dart';
import '../model.dart';
import '../repository/task_repository.dart';

import 'task_event.dart';
import 'task_state.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:logger/logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  String channelId = 'task_reminders';
  String channelName = 'Task Reminders';
  String channelDescription = 'Notifications for upcoming tasks and reminders.';

  final TaskRepository taskRepository;
  final FlutterLocalNotificationsPlugin localNotificationsPlugin;
  final Logger logger = Logger();
  final UserRepository userRepository; // Add UserRepository here

  TaskBloc({
    required this.taskRepository,
    required this.localNotificationsPlugin,
    required this.userRepository, // Initialize the userRepository
  }) : super(TaskInitial()) {
    on<TaskSubmitted>(_ontaskSubmitted);
    on<FetchTasksByUserId>(_onFetchTasksByUserId);
  }

  // Modify _ontaskSubmitted to use the stored userId
  Future<void> _ontaskSubmitted(
    TaskSubmitted event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());

    // Retrieve the userId from the UserRepository
    final userId = userRepository.getUserId();
    if (userId == null) {
      emit(TaskFailure(message: "User ID is missing"));
      return;
    }

    logger.i(
      'Creating task: ${event.task}, Time: ${event.time}, Date: ${event.date}, UserId: $userId, MenuId: ${event.menuId}'
    );

    try {
      final newTask = Task(
        task: event.task,
        time: event.time,
        date: event.date,
        userId: userId, // Use the retrieved userId here
        menuId: [],
      );

      final createdTask = await taskRepository.createTask(newTask);
      await _scheduleNotification(event.task, event.date, event.time);

      emit(TaskSuccess(tasks: [createdTask]));
      logger.i('Task created successfully and notification scheduled');
    } catch (error) {
      logger.e('Error creating task: $error');
      emit(TaskFailure(message: error.toString()));
    }
  }

  // Modify _onFetchTasksByUserId to use the stored userId
  Future<void> _onFetchTasksByUserId(
    FetchTasksByUserId event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());

    // Retrieve the userId from the UserRepository
    final userId = userRepository.getUserId();
    if (userId == null) {
      emit(TaskFailure(message: "User ID is missing"));
      return;
    }

    logger.i('Fetching tasks for userId: $userId');
    try {
      final tasks = await taskRepository.fetchTasksByUserId(userId);
      emit(TaskSuccess(tasks: tasks));
      logger.i('Tasks fetched successfully for userId: $userId');
    } catch (error) {
      logger.e('Error fetching tasks: $error');
      emit(TaskFailure(message: error.toString()));
    }
  }

  Future<void> _scheduleNotification(
      String task, String date, String time) async {
    var scheduledTime = DateTime.parse('$date $time');
    var tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await localNotificationsPlugin.zonedSchedule(
      0,
      'Task Reminder',
      task,
      tzScheduledTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
