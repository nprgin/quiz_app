import 'package:shared_preferences/shared_preferences.dart';

int maxHearts = 3; // Number of hearts
int initialSecondsRemaining = 15;
int secondsRemaining = 15; // Time for each question
int numberOfQuestions = 10; // Number of questions
String difficulty = '';
int selectedCategory = 0;
List categories = [];

Future<void> loadSettingsFromSharedPreferences() async {
  print('Loading..');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  maxHearts = await prefs.getInt('maxHearts') ?? 3;
  initialSecondsRemaining = prefs.getInt('initialSecondsRemaining') ?? 15;
  secondsRemaining = prefs.getInt('secondsRemaining') ?? 15;
  numberOfQuestions = prefs.getInt('numberOfQuestions') ?? 10;
  difficulty = prefs.getString('difficulty') ?? '';
  selectedCategory = prefs.getInt('selectedCategory') ?? 0;
}

Future<void> saveSettingsToSharedPreferences() async {
  print('Saving...');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('maxHearts', maxHearts);
  prefs.setInt('initialSecondsRemaining', initialSecondsRemaining);
  prefs.setInt('secondsRemaining', secondsRemaining);
  prefs.setInt('numberOfQuestions', numberOfQuestions);
  prefs.setString('difficulty', difficulty);
  prefs.setInt('selectedCategory', selectedCategory);
}
