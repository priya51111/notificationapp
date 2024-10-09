import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart'; // Import GetStorage if you're using it
import 'package:notificationapp/login/bloc/login_bloc.dart';
import 'package:notificationapp/login/repository/repository.dart';
import 'package:notificationapp/screens.dart/loginpage.dart';
import 'package:notificationapp/menu/repo/menu_repository.dart';
import 'package:notificationapp/task/bloc/task_bloc.dart';
import 'package:notificationapp/task/repository/task_repository.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Import for local notifications
import 'package:notificationapp/menu/bloc/menu_bloc.dart'; // Import MenuBloc if it isn't already


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure binding is initialized
  await GetStorage.init(); // Initialize GetStorage

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize repositories and plugins
    final TaskRepository taskRepository = TaskRepository();
    final UserRepository userRepository = UserRepository();
    final FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TaskBloc(
            taskRepository: taskRepository,
            localNotificationsPlugin: localNotificationsPlugin,
            userRepository: userRepository,
          ), // Initialize TaskBloc
        ),
        BlocProvider(
          create: (context) => MenuBloc(menuRepository: MenuRepository()), // Initialize MenuBloc
        ),
        BlocProvider(
          create: (context) => UserBloc(userRepository: userRepository), // Initialize LoginBloc
        ),
      ],
      child: MaterialApp(
        title: 'Task Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Loginpage()
      ),
    );
  }
}
