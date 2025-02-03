import 'package:flutter/material.dart';
import 'components/difficulty_slider.dart';
import 'components/status_labels.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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

class NumberGuess {
  final int number;
  final bool isCorrect;

  NumberGuess(this.number, this.isCorrect);
}

List<String> _difficulties = ['Fácil', 'Medio', 'Difícil', 'Extremo'];

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  int _min = 1;
  int _max = 10;
  String _difficulty = _difficulties[0];
  double _difficultyLevel = 0;
  int _numberToGuess = 0;
  int _guessNumber = 0;
  List<int> _lowNumbers = [];
  List<int> _highNumbers = [];
  int _numberTries = 5;
  final List<NumberGuess> _guesses = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _decrementCounter() {
    setState(() {
      _numberTries--;
    });
  }

  void _generateNumber() {
    _numberToGuess = _min + (DateTime.now().millisecond % (_max - _min + 1));
  }

  void _resetGame() {
    _generateNumber();
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
  }

  void _setDifficulty(String difficulty) {
    _difficulty = difficulty;
    _resetGame();
  }

  void _setDifficultyFromSlider(double value) {
    setState(() {
      _difficultyLevel = value;
      int level = value.toInt();
      if (0 <= level && level < _difficulties.length) {
        _setDifficulty(_difficulties[level]);
      }
    });
  }

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
      _guesses.add(NumberGuess(number, false));
      _decrementCounter();
      if (_numberTries == 0) {
        _resetGame();
        _guesses.add(NumberGuess(_numberToGuess, false));
      }
    }
  }

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StatusLabels(
              guessNumber: _guessNumber,
              numberTries: _numberTries,
              lastGuess: _lastGuess,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Ingrese un número',
                ),
                keyboardType: TextInputType.number,
                onSubmitted: (value) {
                  setState(() {
                    _guessNumber = int.tryParse(value) ?? -1;
                    if (_min <= _guessNumber && _guessNumber <= _max) {
                      _checkNumber(_guessNumber);
                    }
                  });
                },
              ),
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
    );
  }
}
