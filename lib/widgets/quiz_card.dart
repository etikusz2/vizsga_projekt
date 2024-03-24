import 'package:flutter/material.dart';
import 'package:vizsga_projekt/question_model.dart';

class QuizCard extends StatelessWidget {
  final Question question;
  final Function(String) onAnswerSelected;

  const QuizCard({
    super.key,
    required this.question,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              question.questionText,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20.0),
            ...question.answers
                .map((answer) => ElevatedButton(
                      onPressed: () => onAnswerSelected(answer),
                      child: Text(answer),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
