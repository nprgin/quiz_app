import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html_unescape/html_unescape.dart';
import 'dart:async';
import 'package:quizz_app/components/variables.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  List<dynamic> questions = [];
  int currentQuestionIndex = 0;
  String selectedAnswer = '';
  int livesRemaining = maxHearts; // Number of lives
  late Timer timer;
  String url = 'https://opentdb.com/api.php?amount=$numberOfQuestions$difficulty${selectedCategory != 0 ? "&category=$selectedCategory" : 0}';
  final unescape = HtmlUnescape();
  bool answerSelected = false; // Flag to track if an answer has been selected

  @override
  void initState() {
    super.initState();
    timer = Timer(Duration.zero, () {});
    fetchQuestions();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> fetchQuestions() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        questions = data['results'];
        for (var question in questions) {
          question['question'] = unescape.convert(question['question']);
          List<String> options = List<String>.from(question['incorrect_answers']);
          options.add(question['correct_answer']);
          options = options.map((option) => unescape.convert(option)).toList();
          options.shuffle();
          question['options'] = options;
        }
        startTimer();
      });
    } else {
      throw Exception('Failed to load questions');
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (secondsRemaining > 0) {
          secondsRemaining--;
        } else {
          livesRemaining = livesRemaining - 1;
          timer.cancel();
          nextQuestion();
        }
      });
    });
  }

  void resetTimer() {
    setState(() {
      secondsRemaining = initialSecondsRemaining;
    });
  }

  void nextQuestion() {
    resetTimer();
    setState(() {
      currentQuestionIndex++;
      selectedAnswer = '';
      answerSelected = false; // Reset the answerSelected flag for the next question
    });
    if (currentQuestionIndex < questions.length) {
      startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        backgroundColor: Colors.grey,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text('${(currentQuestionIndex + 1) >= questions.length ? questions.length : currentQuestionIndex + 1} / ${questions.length}'),
          ),
        ],
      ),
      backgroundColor: Colors.grey[300],
      body: questions.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                LinearProgressIndicator(
                  value: secondsRemaining / initialSecondsRemaining,
                  backgroundColor: Colors.grey[400],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                const SizedBox(height: 10),
                buildLives(),
                const SizedBox(height: 10),
                Expanded(child: buildQuestion()),
              ],
            ),
    );
  }

  Widget buildQuestion() {
    if (currentQuestionIndex >= questions.length || livesRemaining == -1) {
      return const Center(
        child: Text(
          'Quiz Complete!',
          style: TextStyle(fontSize: 20),
        ),
      );
    }

    final question = questions[currentQuestionIndex];
    final List<String> options = List<String>.from(question['options']);

  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          question['question'],
          style: const TextStyle(fontSize: 20, color: Colors.black),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ...options.map((option) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0), // Add padding here
            child: ElevatedButton(
              onPressed: answerSelected ? null : () {
                selectAnswer(option, question['correct_answer']);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (selectedAnswer.isNotEmpty) {
                      if (option == selectedAnswer) {
                        return option == question['correct_answer']
                            ? Colors.green
                            : Colors.red;
                      } else if (option == question['correct_answer']) {
                        return Colors.green;
                      }
                    }
                    return Colors.white;
                  },
                ),
              ),
              child: Text(option),
            ),
          );
        }),
      ],
    ),
  );

  }

  void selectAnswer(String option, String correctAnswer) {
    timer.cancel();
    if (option != correctAnswer) {
      setState(() {
        livesRemaining--;
      });
      if (livesRemaining < 0) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('You Failed'),
            content: const Text('You have run out of lives.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
    setState(() {
      selectedAnswer = option;
      answerSelected = true; // Set the answerSelected flag to true
    });
    Future.delayed(const Duration(seconds: 1), () {
      nextQuestion();
    });
  }

  Widget buildLives() {
    int remainingHearts = livesRemaining.clamp(0, maxHearts);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        remainingHearts,
        (index) => const Icon(
          Icons.favorite,
          color: Colors.red,
        ),
      ) +
      List.generate(
        maxHearts - remainingHearts,
        (index) => const Icon(
          Icons.favorite_border,
          color: Colors.grey,
        ),
      ),
    );
  }
}
