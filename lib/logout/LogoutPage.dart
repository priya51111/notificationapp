import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/Logout_bloc.dart';
import 'bloc/logout_event.dart';
import 'bloc/logout_state.dart';

import 'repository/Logout_repository.dart';

class LogoutPage extends StatelessWidget {
  final String userId = '12345';                        
  final String token = 'your_token_here';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: BlocProvider(
          create: (context) => LogoutBloc(logoutRepository: LogoutRepository()),
          child: BlocListener<LogoutBloc, LogoutState>(
            listener: (context, state) {
              if (state is LogoutSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logout successful')),
                );
              } else if (state is LogoutFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logout failed: ${state.error}')),
                );
              }
            },
            child: BlocBuilder<LogoutBloc, LogoutState>(
              builder: (context, state) {
                if (state is LogoutLoading) {
                  return CircularProgressIndicator();
                }

                return ElevatedButton(
                  onPressed: () => _showLogoutConfirmationDialog(context),
                  child: Text('Logout'),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // This function shows the confirmation dialog
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout Confirmation'),
          content: Text('Do you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without logging out
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                // Trigger the logout event
                context.read<LogoutBloc>().add(
                  LogoutRequested(userId: userId, token: token),
                );
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
