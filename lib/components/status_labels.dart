import 'package:flutter/material.dart';

class StatusLabels extends StatelessWidget {
  final int guessNumber;
  final int numberTries;
  final String Function() lastGuess;
  final int minRange;
  final int maxRange;

  const StatusLabels({
    super.key,
    required this.guessNumber,
    required this.numberTries,
    required this.lastGuess,
    required this.minRange,
    required this.maxRange,
  });

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
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          'Rango de números: $minRange - $maxRange',
          style: Theme.of(context).textTheme.bodyLarge,
        )
      ],
    );
  }
}