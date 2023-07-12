import 'package:fireship/login/login.dart';
import 'package:fireship/services/auth.dart';
import 'package:fireship/topics/topics.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // Stream to listen to for changes
      stream: AuthService().userStream,
      // Builder to handle stream response
      // Builds the widget tree based on the latest snapshot
      builder: (context, snapshot) {
        // Still Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }
        // Encountered an error
        else if (snapshot.hasError) {
          return const Center(
            child: Text("Error"),
          );
        }
        // Has Data
        else if (snapshot.hasData) {
          return const TopicsScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
