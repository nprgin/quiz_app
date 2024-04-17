import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:quizz_app/components/app_bar.dart';
import 'package:quizz_app/components/variables.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<dynamic> categories = [];
  // selectedCategory = 0;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse('https://opentdb.com/api_category.php'));
    final body = json.decode(response.body);
    setState(() {
      categories = body['trivia_categories'];
      if (categories.isNotEmpty && selectedCategory != 0) {
        selectedCategory = selectedCategory;
      } else if (categories.isNotEmpty) {
        selectedCategory = categories[0]['id'];
      } else {
        selectedCategory = 0;
      }
      // selectedCategory = categories.isNotEmpty ? categories[0]['id'] : selectedCategory; // Set the first category as the initial selected category
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("Settings"),
      backgroundColor: Colors.grey[300],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Change number of hearts:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio<int>(
                value: 1,
                groupValue: maxHearts,
                onChanged: (value) {
                  setState(() {
                    maxHearts = value!;
                  });
                },
              ),
              const Text('1'),
              Radio<int>(
                value: 3,
                groupValue: maxHearts,
                onChanged: (value) {
                  setState(() {
                    maxHearts = value!;
                  });
                },
              ),
              const Text('3'),
              Radio<int>(
                value: 5,
                groupValue: maxHearts,
                onChanged: (value) {
                  setState(() {
                    maxHearts = value!;
                  });
                },
              ),
              const Text('5'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Change number of questions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio<int>(
                value: 10,
                groupValue: numberOfQuestions,
                onChanged: (value) {
                  setState(() {
                    numberOfQuestions = value!;
                  });
                },
              ),
              const Text('10'),
              Radio<int>(
                value: 20,
                groupValue: numberOfQuestions,
                onChanged: (value) {
                  setState(() {
                    numberOfQuestions = value!;
                  });
                },
              ),
              const Text('20'),
              Radio<int>(
                value: 30,
                groupValue: numberOfQuestions,
                onChanged: (value) {
                  setState(() {
                    numberOfQuestions = value!;
                  });
                },
              ),
              const Text('30'),
              Radio<int>(
                value: 40,
                groupValue: numberOfQuestions,
                onChanged: (value) {
                  setState(() {
                    numberOfQuestions = value!;
                  });
                },
              ),
              const Text('40'),
              Radio<int>(
                value: 50,
                groupValue: numberOfQuestions,
                onChanged: (value) {
                  setState(() {
                    numberOfQuestions = value!;
                  });
                },
              ),
              const Text('50'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Change difficulty level:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio<String>(
                value: '',
                groupValue: difficulty,
                onChanged: (value) {
                  setState(() {
                    difficulty = value!;
                  });
                },
              ),
              const Text('Mixed'),
              Radio<String>(
                value: '&difficulty=easy',
                groupValue: difficulty,
                onChanged: (value) {
                  setState(() {
                    difficulty = value!;
                  });
                },
              ),
              const Text('Easy'),
              Radio<String>(
                value: '&difficulty=medium',
                groupValue: difficulty,
                onChanged: (value) {
                  setState(() {
                    difficulty = value!;
                  });
                },
              ),
              const Text('Medium'),
              Radio<String>(
                value: '&difficulty=hard',
                groupValue: difficulty,
                onChanged: (value) {
                  setState(() {
                    difficulty = value!;
                  });
                },
              ),
              const Text('Hard'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Choose a category:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          DropdownButton<int>(
            value: selectedCategory,
            onChanged: (int? newValue) {
              setState(() {
                selectedCategory = newValue!;
              });
            },
            items: [
              for (var category in categories)
                DropdownMenuItem<int>(
                  value: category['id'],
                  child: Text(category['name']),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
