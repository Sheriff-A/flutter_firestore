import 'package:fireship/services/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimatedProgressBar extends StatelessWidget {
  const AnimatedProgressBar({
    super.key,
    required this.value,
    this.height = 12,
  });

  // Percentage Value (0.0 - 1.0)
  final double value;
  final double height;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints box) {
        return Container(
          padding: const EdgeInsets.all(10.0),
          width: box.maxWidth,
          child: Stack(
            children: [
              // First Element, Progress Bar Base
              // Grey Background
              Container(
                height: height,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.all(
                    Radius.circular(height),
                  ),
                ),
              ),

              // Second Element, Progress Bar
              // Animated Progress Bar
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                height: height,
                width: box.maxWidth * _floor(value),
                decoration: BoxDecoration(
                  color: _colorGenerator(value),
                  borderRadius: BorderRadius.all(
                    Radius.circular(height),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // Always Round negative or NaN values to min value
  _floor(double value, [min = 0.0]) {
    return value.sign <= min ? min : value;
  }

  // Color Generator
  _colorGenerator(double value) {
    int rgb = (value * 255).toInt();
    return Colors.deepOrange.withGreen(rgb).withRed(255 - rgb);
  }
}

class TopicProgress extends StatelessWidget {
  const TopicProgress({super.key, required this.topic});

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    Report report = Provider.of<Report>(context);

    return Row(
      children: [
        _progressCount(report, topic),
        Expanded(
          child: AnimatedProgressBar(
            value: _calculateProgress(topic, report),
            height: 8,
          ),
        ),
      ],
    );
  }

  Widget _progressCount(Report report, Topic topic) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        '${report.topics[topic.id]?.length ?? 0} / ${topic.quizzes.length}',
        style: const TextStyle(fontSize: 10, color: Colors.grey),
      ),
    );
  }

  double _calculateProgress(Topic topic, Report report) {
    try {
      int totalQuizzes = topic.quizzes.length;
      int completedQuizzes = report.topics[topic.id]?.length ?? 0;
      return completedQuizzes / totalQuizzes;
    } catch (e) {
      return 0.0;
    }
  }
}
