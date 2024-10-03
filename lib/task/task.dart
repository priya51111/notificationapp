import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'bloc/task_bloc.dart';
import 'repository/task_repository.dart';


class TaskCreate extends StatelessWidget {
  const TaskCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => TaskBloc(
            taskRepository: TaskRepository(),
            localNotificationsPlugin: FlutterLocalNotificationsPlugin()));
  }
}
