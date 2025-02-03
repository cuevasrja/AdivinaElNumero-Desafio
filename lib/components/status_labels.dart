import 'package:flutter/material.dart';

class StatusLabels extends StatelessWidget {
  final int guessNumber;
  final int numberTries;
  final String Function() lastGuess;

  const StatusLabels({
    Key? key,
    required this.guessNumber,
    required this.numberTries,
    required this.lastGuess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Último número ingresado: ${lastGuess()}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(
          'Intentos restantes: $numberTries',
        ),
      ],
    );
  }
}