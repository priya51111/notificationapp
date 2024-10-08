import 'package:flutter_bloc/flutter_bloc.dart';

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
 
  TaskBloc({
    required this.taskRepository,
    required this.localNotificationsPlugin,
  }) : super(TaskInitial()) {
    on<TaskSubmitted>(_ontaskSubmitted);
    on<FetchTasksByUserId>(_onFetchTasksByUserId);
   
  }

  Future<void> _ontaskSubmitted(
    TaskSubmitted event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    logger.i(
        'Creating task: ${event.task}, Time: ${event.time}, Date: ${event.date},UserId: ${event.userId}, MenuId: ${event.menuId}');
    try {
      final newTask = Task(
        task: event.task,
        time: event.time,
        date: event.date,
        userId: event.userId,
        menuId: [],
      );

      final createdTask =await taskRepository.createTask(newTask);

      await _scheduleNotification(event.task, event.date, event.time);

      
      emit(TaskSuccess(tasks: [createdTask]));

      

      logger.i('Task created successfully and notification scheduled');
    } catch (error) {
      logger.e('Error creating task: $error');
      emit(TaskFailure(message: error.toString()));
    }
  }

  Future<void> _onFetchTasksByUserId(
    FetchTasksByUserId event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    logger.i('Fetching tasks for userId: ${event.userId}');
    try {
      final tasks = await taskRepository.fetchTasksByUserId(event.userId);
      emit(TaskSuccess(tasks: tasks));
      logger.i('Tasks fetched successfully for userId: ${event.userId}');
    } catch (error) {
      logger.e('Error fetching tasks: $error');
      emit(TaskFailure(message: error.toString()));
    }
  }

  Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await taskRepository.deleteTask(event.taskId);
      emit(TaskDeleted(taskId: event.taskId));
    } catch (error) {
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
