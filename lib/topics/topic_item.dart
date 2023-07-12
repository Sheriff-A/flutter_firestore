import 'package:fireship/services/models.dart';
import 'package:fireship/topics/drawer.dart';
import 'package:flutter/material.dart';

class TopicItem extends StatelessWidget {
  const TopicItem({
    super.key,
    required this.topic,
  });
  final Topic topic;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: topic.img,
      child: Card(
        // Clip.antiAlias is used to prevent the image from overflowing the card
        // Rounds the corners of the image
        clipBehavior: Clip.antiAlias,

        // Card is not tapable by default, so we use an InkWell to make it tapable
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => TopicScreen(topic: topic),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 3,
                child: SizedBox(
                  child: Image.asset(
                    'assets/covers/${topic.img}',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: Text(
                    topic.title,
                    style: const TextStyle(
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TopicScreen extends StatelessWidget {
  const TopicScreen({super.key, required this.topic});
  final Topic topic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(topic.title),
      ),
      body: ListView(
        children: [
          Hero(
            tag: topic.img,
            child: Image.asset(
              'assets/covers/${topic.img}',
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Text(
            topic.title,
            style: const TextStyle(
              height: 1.5,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.fade,
            softWrap: false,
          ),
          QuizList(topic: topic),
        ],
      ),
    );
  }
}
