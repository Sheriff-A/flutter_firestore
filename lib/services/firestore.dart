import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fireship/services/auth.dart';
import 'package:fireship/services/models.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Reads all documnets from the topics collection
  Future<List<Topic>> getTopics() async {
    var ref = _db.collection('topics');

    // One time read
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());

    // This returns and iterable object (like python)
    // Needs to be converted to a list/array
    var topics = data.map((m) => Topic.fromJson(m));
    return topics.toList();
  }

  // Gets a single quiz document
  Future<Quiz> getQuiz(String quizId) async {
    var ref = _db.collection('quizzes').doc(quizId);

    // One time read
    var snapshot = await ref.get();

    // No need to map as it's a single document
    return Quiz.fromJson(snapshot.data() ?? {});
  }

  // Listens to the current user's report document in firestore
  Stream<Report> streamReport() {
    return AuthService().userStream.switchMap((user) {
      if (user != null) {
        var ref = _db.collection('reports').doc(user.uid);

        // Assertion operator (!) means not null so dw about it
        return ref.snapshots().map((doc) => Report.fromJson(doc.data()!));
      } else {
        return Stream.fromIterable([Report()]);
      }
    });
  }

  // Updates the current user's report document in firestore after completing a quiz
  Future<void> updateUserReport(Quiz quiz) {
    // Assertion operator (!) as the user has to be logged in to call this function
    var user = AuthService().user!;
    var ref = _db.collection('reports').doc(user.uid);

    var data = {
      'total': FieldValue.increment(1),
      'topics': {
        quiz.topic: FieldValue.arrayUnion([quiz.id])
      }
    };

    // SetOptions(merge: true) means that if the document doesn't exist,
    // it will be created and if it exists, it will be updated
    // This makes it a non destructive update
    return ref.set(data, SetOptions(merge: true));
  }
}
