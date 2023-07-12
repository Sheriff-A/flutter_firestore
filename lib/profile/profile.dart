import 'package:fireship/services/auth.dart';
import 'package:fireship/services/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var report = Provider.of<Report>(context);
    var user = AuthService().user;

    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(user.displayName ?? "Guest"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.only(top: 50.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(user.photoURL ??
                        'https://www.gravatar.com/avatar/placeholder'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.only(top: 20.0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    user.email ?? "Anonymous Email",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${report.total}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                'Quizzes Completed',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              ElevatedButton(
                child: const Text("Sign Out"),
                onPressed: () async {
                  await AuthService().signOut();

                  if (context.mounted) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (route) => false);
                  }
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
          appBar: AppBar(
        title: const Text("Profile"),
      ));
    }
  }
}
