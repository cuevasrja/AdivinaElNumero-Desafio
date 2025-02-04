import 'package:flutter/material.dart';
import 'components/difficulty_slider.dart';
import 'components/status_labels.dart';
import 'components/guess_columns.dart';
import 'components/guess_input.dart';
import 'classes/number_guess.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adivina el número',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 174, 0)),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
          bodyMedium: TextStyle(color: Colors.white, fontSize: 18),
          headlineMedium: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      home: const MyHomePage(title: 'Adivina el número'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

List<String> _difficulties = ['Fácil', 'Medio', 'Difícil', 'Extremo'];

class _MyHomePageState extends State<MyHomePage> {
  // Define a controller for the text field
  final TextEditingController _controller = TextEditingController();
  // Define the range of numbers to guess
  int _min = 1;
  int _max = 10;
  // Set the initial difficulty level as the first element of the list
  String _difficulty = _difficulties[0];
  double _difficultyLevel = 0;
  // Generate a random number to guess
  int _numberToGuess = 1 + (DateTime.now().millisecond % (10));
  // Initialize the guess number, low and high numbers, and number of tries
  int _guessNumber = 0;
  List<int> _lowNumbers = [];
  List<int> _highNumbers = [];
  int _numberTries = 5;
  // Initialize the list of guesses
  final List<NumberGuess> _guesses = [];

  /// Initialize the controller
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Decrement the number of tries
  void _decrementCounter() {
    setState(() {
      _numberTries--;
    });
  }

  /// Generate a random number to guess
  void _generateNumber() {
    _numberToGuess = _min + (DateTime.now().millisecond % (_max - _min + 1));
  }

  /// Reset the game
  void _resetGame() {
    _lowNumbers = [];
    _highNumbers = [];
    _guessNumber = 0;
    switch (_difficultyLevel.toInt()) {
      case 0:
        _min = 1;
        _max = 10;
        _numberTries = 5;
        break;
      case 1:
        _min = 1;
        _max = 20;
        _numberTries = 8;
        break;
      case 2:
        _min = 1;
        _max = 100;
        _numberTries = 15;
        break;
      case 3:
        _min = 1;
        _max = 1000;
        _numberTries = 25;
        break;
    }
    _generateNumber();
  }

  /// Set the difficulty level
  /// - [difficulty] the difficulty level
  void _setDifficulty(String difficulty) {
    _difficulty = difficulty;
  }

  /// Set the difficulty level from the slider
  /// - [value] the value of the slider
  void _setDifficultyFromSlider(double value) {
    setState(() {
      _difficultyLevel = value;
      int level = value.toInt();
      if (0 <= level && level < _difficulties.length) {
        _setDifficulty(_difficulties[level]);
        _resetGame();
      }
    });
  }

  /// Check the number
  /// - [number] the number to check
  void _checkNumber(int number) {
    if (number == _numberToGuess) {
      _guesses.add(NumberGuess(number, true));
      _resetGame();
    } else {
      if (number < _numberToGuess) {
        _lowNumbers.add(number);
      } else {
        _highNumbers.add(number);
      }
      _decrementCounter();
      if (_numberTries == 0) {
        _resetGame();
        _guesses.add(NumberGuess(number, false));
      }
    }
  }

  /// Get the last guess
  String _lastGuess() {
    switch (_guessNumber) {
      case 0:
        return 'No ha ingresado un número';
      case -1:
        return 'Número no válido';
      default:
        return _guessNumber.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        color: const Color.fromARGB(255, 47, 96, 129),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StatusLabels(
                guessNumber: _guessNumber,
                numberTries: _numberTries,
                lastGuess: _lastGuess,
                minRange: _min,
                maxRange: _max,
              ),
              GuessInput(
                controller: _controller,
                onSubmitted: (guessNumber) {
                  setState(() {
                    _guessNumber = guessNumber;
                    _checkNumber(_guessNumber);
                  });
                },
                min: _min,
                max: _max,
              ),
              GuessColumns(
                lowNumbers: _lowNumbers,
                highNumbers: _highNumbers,
                guesses: _guesses,
              ),
              DifficultySlider(
                difficultyLevel: _difficultyLevel,
                onChanged: _setDifficultyFromSlider,
                difficulties: _difficulties,
                difficulty: _difficulty,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
