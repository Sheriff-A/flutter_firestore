import 'package:fireship/quiz/quiz_state.dart';
import 'package:fireship/services/firestore.dart';
import 'package:fireship/services/models.dart';
import 'package:fireship/shared/error.dart';
import 'package:fireship/shared/loading.dart';
import 'package:fireship/shared/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key, required this.quizId});

  final String quizId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizState(),
      child: FutureBuilder<Quiz>(
        future: FirestoreService().getQuiz(quizId),
        builder: (context, snapshot) {
          var state = Provider.of<QuizState>(context);

          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          // Error
          else if (snapshot.hasError) {
            return ErrorMessage(message: snapshot.error.toString());
          }
          // Has Data
          else if (snapshot.hasData) {
            var quiz = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                title: AnimatedProgressBar(value: state.progress),
                leading: IconButton(
                  icon: const Icon(FontAwesomeIcons.xmark),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                controller: state.controller,
                onPageChanged: (int idx) => {
                  state.progress = (idx / (quiz.questions.length + 1)),
                },
                itemBuilder: (BuildContext context, int idx) {
                  if (idx == 0) {
                    return StartPage(quiz: quiz);
                  } else if (idx == quiz.questions.length + 1) {
                    return CongratsPage(quiz: quiz);
                  } else {
                    return QuestionPage(question: quiz.questions[idx - 1]);
                  }
                },
              ),
            );
          } else {
            return Text(
                'No Quiz under id: $quizId found in Firestore. Check database.');
          }
        },
      ),
    );
  }
}

class StartPage extends StatelessWidget {
  const StartPage({super.key, required this.quiz});

  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<QuizState>(context);
    return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              quiz.title,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const Divider(),
            Expanded(child: Text(quiz.description)),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton.icon(
                  onPressed: state.nextPage,
                  label: const Text('Start Quiz'),
                  icon: const Icon(Icons.poll),
                )
              ],
            )
          ],
        ));
  }
}

class CongratsPage extends StatelessWidget {
  const CongratsPage({super.key, required this.quiz});

  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Congrats! You completed the ${quiz.title} quiz',
            textAlign: TextAlign.center,
          ),
          const Divider(),
          Image.asset('assets/congrats.gif'),
          const Divider(),
          ElevatedButton.icon(
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            icon: const Icon(FontAwesomeIcons.check),
            label: const Text("Mark Complete!"),
            onPressed: () {
              FirestoreService().updateUserReport(quiz);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/topics',
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

class QuestionPage extends StatelessWidget {
  const QuestionPage({super.key, required this.question});

  final Question question;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
