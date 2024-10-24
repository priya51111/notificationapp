import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart'; 
import 'package:notificationapp/login/bloc/login_bloc.dart';
import 'package:notificationapp/login/repository/repository.dart';
import 'package:notificationapp/logout/LogoutPage.dart';
import 'package:notificationapp/screens.dart/homepage.dart';
import 'package:notificationapp/screens.dart/loginpage.dart';
import 'package:notificationapp/menu/repo/menu_repository.dart';
import 'package:notificationapp/task/bloc/task_bloc.dart';
import 'package:notificationapp/task/repository/task_repository.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; 
import 'package:notificationapp/menu/bloc/menu_bloc.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await GetStorage.init(); 

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final UserRepository userRepository = UserRepository();
    final MenuRepository menuRepository =
        MenuRepository(userRepository: userRepository);
    final TaskRepository taskRepository = TaskRepository(
      userRepository: userRepository,
      menuRepository: menuRepository,
      
    );
    final FlutterLocalNotificationsPlugin localNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TaskBloc(
            taskRepository: taskRepository,
           
            localNotificationsPlugin: localNotificationsPlugin,
            userRepository: userRepository,
            menuRepository: MenuRepository(userRepository: userRepository),
          ), // Initialize TaskBloc
        ),
        BlocProvider(
          create: (context) =>
              UserBloc(userRepository: userRepository), // Initialize LoginBloc
        ),
        BlocProvider(
          create: (context) => MenuBloc(
            menuRepository: MenuRepository(userRepository: UserRepository()),
          ), // Initialize MenuBloc
        ),
      ],
      child: MaterialApp(
          title: 'Task Manager',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Loginpage()),
    );
  }
}
