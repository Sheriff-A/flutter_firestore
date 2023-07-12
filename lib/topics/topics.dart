import 'package:fireship/services/firestore.dart';
import 'package:fireship/services/models.dart';
import 'package:fireship/shared/bottom_nav.dart';
import 'package:fireship/shared/error.dart';
import 'package:fireship/shared/loading.dart';
import 'package:fireship/topics/drawer.dart';
import 'package:fireship/topics/topic_item.dart';
import 'package:flutter/material.dart';

class TopicsScreen extends StatelessWidget {
  const TopicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Topic>>(
      future: FirestoreService().getTopics(),
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        }
        // Error
        else if (snapshot.hasError) {
          return ErrorMessage(message: snapshot.error.toString());
        }
        // Data
        else if (snapshot.hasData) {
          var topics = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Topics'),
              backgroundColor: Colors.deepPurple,
            ),
            drawer: TopicDrawer(topics: topics),
            body: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20.0),
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              children: topics.map((topic) => TopicItem(topic: topic)).toList(),
            ),
            bottomNavigationBar: const BottomNavBar(),
          );
        }
        // Something Else
        else {
          return const Text('No topics found in Firestore. Check database.');
        }
      },
    );
  }
}
