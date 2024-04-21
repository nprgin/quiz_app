import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '/screens/home_screen.dart';
import '/components/variables.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()), // Switch to home screen
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Display a loading indicator
      ),
    );
  }
}
