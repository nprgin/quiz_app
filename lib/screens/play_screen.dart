import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html_unescape/html_unescape.dart';
import 'dart:async';
import 'package:quizz_app/components/app_bar.dart';
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
  // int secondsRemaining = 10;
  // int maxHearts =20;
  int livesRemaining = maxHearts; // Number of lives
  late Timer timer; // Make timer non-nullable
  String url = 'https://opentdb.com/api.php?amount=$numberOfQuestions$difficulty${selectedCategory != 0 ? "&category=$selectedCategory" : 0}';

  final unescape = HtmlUnescape();

  @override
  void initState() {
    super.initState();
    timer = Timer(Duration.zero, () {}); // Initialize with an inactive timer
    fetchQuestions();
  }

  @override
  void dispose() {
    timer.cancel(); // Cancel the timer when disposing the screen
    super.dispose();
  }

  Future<void> fetchQuestions() async {
    final response =
        await http.get(Uri.parse(url));
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
          timer.cancel();
          nextQuestion();
        }
      });
    });
  }

  void resetTimer() {
    setState(() {
      secondsRemaining = 10;
    });
  }

  void nextQuestion() {
    resetTimer();
    setState(() {
      currentQuestionIndex++;
      selectedAnswer = '';
    });
    if (currentQuestionIndex < questions.length) {
      startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("Quiz"),
      backgroundColor: Colors.grey[300],
      body: questions.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                LinearProgressIndicator(
                  value: secondsRemaining / 10, // Calculate progress
                  backgroundColor: Colors.grey[400],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                const SizedBox(height: 10),
                buildLives(), // Display lives
                const SizedBox(height: 10),
                Expanded(child: buildQuestion()),
              ],
            ),
    );
  }

  Widget buildQuestion() {
    if (currentQuestionIndex >= questions.length || livesRemaining == -1) {
      // Quiz has reached the end or player ran out of lives
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
            return ElevatedButton(
              onPressed: () {
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
            );
          }),
        ],
      ),
    );
  }

  void selectAnswer(String option, String correctAnswer) {
    timer.cancel(); // Cancel the timer when an answer is selected
    if (option != correctAnswer) {
      setState(() {
        livesRemaining--; // Decrease lives on wrong answer
      });
      if (livesRemaining < 0) {
        // End the quiz if no lives left
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('You Failed'),
            content: const Text('You have run out of lives.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pop(context); // Exit the quiz screen
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
    });
    Future.delayed(const Duration(seconds: 1), () {
      nextQuestion();
    });
  }

  Widget buildLives() {
    int remainingHearts = livesRemaining.clamp(0, maxHearts); // Ensure livesRemaining is within range [0, maxHearts]

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
        maxHearts - remainingHearts, // Fill remaining spaces with empty hearts
        (index) => const Icon(
          Icons.favorite_border,
          color: Colors.grey,
        ),
      ),
    );
}


}