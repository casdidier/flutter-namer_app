import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:developer' as developer;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../pages/profile/profile.dart';
import '../pages/favorites/favorites.dart';
import '../pages/home/home.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: "dev.env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      // create: (context) => MyAppState(),
      value: MyAppState(), // Use ChangeNotifierProvider.value
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <WordPair>[];
  var history = <WordPair>[];
  var apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];

  var name = "John Doe";
  var phoneNumber = "1234567890";
  var email = "john.doe@example.com";
  var title = 'titre';
  var date = DateTime.now();

  void getNext() {
    current = WordPair.random();
    addToHistory(current);
    notifyListeners();
  }

  void addToHistory(WordPair pair) {
    history.insert(0, pair);
  }

  void toggleFavorite([WordPair? pair]) {
    pair = pair ?? current;
    if (favorites.contains(pair)) {
      favorites.remove(pair);
    } else {
      favorites.add(pair);
    }
    notifyListeners();
  }

  void onDelete(index) {
    favorites.removeAt(index);
    notifyListeners();
  }

  void changeName(String value) {
    developer.log(
      name,
    );
    name = value;
    developer.log(
      'log me again',
    );

    developer.log(apiKey ?? 'no key');
    notifyListeners();
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: AnimatedSize(
          duration: Duration(milliseconds: 200),
          child: Text(
            pair.asLowerCase,
            style: style,
            semanticsLabel: "${pair.first} ${pair.second}",
          ),
        ),
      ),
    );
  }
}
