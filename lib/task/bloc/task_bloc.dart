import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';


import '../../login/repository/repository.dart';

import '../../menu/repo/menu_repository.dart';
import '../models.dart';
import '../repository/task_repository.dart';

import 'task_event.dart';
import 'task_state.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:logger/logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  String channelId = 'task_reminders';
  String channelName = 'Task Reminders';
  String channelDescription = 'Notifications for upcoming tasks and reminders.';
  final GetStorage box = GetStorage();
  final TaskRepository taskRepository;
  final FlutterLocalNotificationsPlugin localNotificationsPlugin;
  final Logger logger = Logger();
  final UserRepository userRepository;
  final MenuRepository menuRepository; // Add UserRepository here

  TaskBloc({
    required this.taskRepository,
    required this.localNotificationsPlugin,
    required this.userRepository,
    required this.menuRepository,
  }) : super(TaskInitial()) {
    on<TaskSubmitted>(_ontaskSubmitted);
    on<FetchTaskEvent>(_onFetchTask);
  }
  Future<void> _ontaskSubmitted(
      TaskSubmitted event, Emitter<TaskState> emit) async {
    emit(TaskLoading());

    try {
      final createdTask =
          await taskRepository.createTask(event.task, event.date, event.time);
      await _scheduleNotification(
        localNotificationsPlugin,
        createdTask.task,
        event.date,
        event.time,
      );
      emit(TaskCreated(task: createdTask));
      logger.i('Task created successfully and notification scheduled');
      final userId = box.read('userId');
      final date = box.read('date');

      if (userId == null || date == null) {
        emit(TaskFailure(message: 'User ID or date is missing'));
        return;
      }
      add(FetchTaskEvent(userId: userId, date: date));
    } catch (error) {
      logger.e('Error creating task: $error');
      emit(TaskFailure(message: error.toString()));
    }
  }

  Future<void> _onFetchTask(
      FetchTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading()); // Emit loading state

    try {
      final List<Tasks> tasks = await taskRepository.fetchTasks(
          userId: event.userId, date: event.date);

      emit(TaskSuccess(
          taskList: tasks, menuMap: {})); // Emit loaded state with menu list
    } catch (e) {
      logger.e("Error fetching menus: $e");
      emit(TaskFailure(message: 'Failed to fetch menus.'));
    }
  }

  Future<void> _scheduleNotification(
      FlutterLocalNotificationsPlugin localNotificationsPlugin,
      String task,
      String date,
      String time) async {
    try {
      // Combine date and time into a DateTime object
      var scheduledTime = DateTime.parse('$date $time');

      // Convert to the local timezone using timezone package
      var tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your_channel_id', // Replace with your channel ID
        'your_channel_name', // Replace with your channel name
        channelDescription:
            'Your channel description', // Replace with your channel description
        importance: Importance.max,
        priority: Priority.high,
      );

      var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      // Schedule the notification
      await localNotificationsPlugin.zonedSchedule(
        0, // Notification ID (use a unique one if needed)
        'Task Reminder', // Notification title
        task, // Notification body
        tzScheduledTime, // Scheduled time
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
           payload: jsonEncode({ // Convert your data to JSON
  
    'task': task,
    'date': date,
    'time': time,
    
  }),
      );

      logger.i('Notification scheduled successfully for $scheduledTime');
    } catch (e) {
      logger.i('Error scheduling notification: $e');
    }
  }
}
