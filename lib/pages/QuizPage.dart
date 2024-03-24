import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:vizsga_projekt/question_model.dart';

class QuizPage extends StatefulWidget {
  final String category;

  QuizPage({required this.category});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late Future<List<Question>> questionsFuture;
  int currentIndex = 0;
  int score = 0;
  Timer? timer;
  int timeLeft = 20;
  late List<Question> currentQuestions;

  @override
  void initState() {
    super.initState();
    questionsFuture = loadQuestions();
    questionsFuture.then((value) {
      setState(() {
        currentQuestions = value;
      });
      startTimer();
    });
  }

  Future<List<Question>> loadQuestions() async {
    final String filename = getCategoryFilename(widget.category);
    final String data = await rootBundle.loadString('assets/json/$filename');
    final List<dynamic> jsonResult = json.decode(data);
    return jsonResult.map((question) => Question.fromJson(question)).toList();
  }

  String getCategoryFilename(String categoryDisplayName) {
    switch (categoryDisplayName) {
      case 'Történelem':
        return 'history.json';
      case 'Matematika':
        return 'mathematics.json';
      case 'Tudomány':
        return 'science.json';
      case 'Irodalom':
        return 'literature.json';
      default:
        return 'general.json';
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        goToNextQuestion();
      }
    });
  }

  void goToNextQuestion() {
    timer?.cancel();
    if (currentIndex < currentQuestions.length - 1) {
      setState(() {
        currentIndex++;
        timeLeft = 20;
      });
      startTimer();
    } else {
      showResults();
    }
  }

  void answerQuestion(String answer) {
    if (currentQuestions[currentIndex].correctAnswer == answer) {
      score += 10;
    }
    goToNextQuestion();
  }

  void showResults() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Eredmények'),
              content: Text(
                  'Pontszámod: $score\nHelyes válaszok: ${score ~/ 10} a ${currentQuestions.length} kérdésből.'),
              actions: <Widget>[
                TextButton(
                  child: Text('Újrajátszás'),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      currentIndex = 0;
                      score = 0;
                      timeLeft = 20;
                    });
                    startTimer();
                  },
                ),
                TextButton(
                  child: Text('Főmenü'),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                ),
              ],
            ));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category}'),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(child: Text('Idő: $timeLeft')),
          )
        ],
      ),
      body: FutureBuilder<List<Question>>(
        future: questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hiba történt a betöltés során'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            currentQuestions = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Kérdés ${currentIndex + 1} / ${currentQuestions.length}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    currentQuestions[currentIndex].questionText,
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: currentQuestions[currentIndex].answers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Center(
                            child: Text(
                                currentQuestions[currentIndex].answers[index])),
                        onTap: () => answerQuestion(
                            currentQuestions[currentIndex].answers[index]),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('Nincsenek kérdések a kategóriában'));
          }
        },
      ),
    );
  }
}
