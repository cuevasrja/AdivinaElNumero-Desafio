import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adivina el número',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Adivina el número'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
  List<NumberGuess> _guesses = [];

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

  String _lastGuess(int number) {
    if (number == -1){
      return 'No ingresó un número válido';
    } else if (number == 0){
      return 'No ha ingresado un número';
    } else {
      return number.toString();
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
            Text(
              'Último número ingresado: ${_lastGuess(_guessNumber)}',
              style: Theme.of(context).textTheme.headlineMedium,
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
                    _guessNumber = int.tryParse(value) ?? 0;
                    if (_min <= _guessNumber && _guessNumber <= _max) {
                      _checkNumber(_guessNumber);
                    } else {
                      _guessNumber = -1;
                    }
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Seleccione el nivel de dificultad:'),
                  Text('Dificultad: $_difficulty'),
                  Slider(
                    value: _difficultyLevel,
                    min: 0,
                    max: 3,
                    divisions: 3,
                    label: _difficultyLevel == 0
                        ? 'easy'
                        : _difficultyLevel == 1
                            ? 'medium'
                            : _difficultyLevel == 2
                                ? 'hard'
                                : 'extreme',
                    onChanged: _setDifficultyFromSlider,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
