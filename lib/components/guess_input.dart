import 'package:flutter/material.dart';

class GuessInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(int) onSubmitted;
  final int min;
  final int max;

  const GuessInput({
    super.key,
    required this.controller,
    required this.onSubmitted,
    required this.min,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          labelText: 'Ingrese un número',
          labelStyle: Theme.of(context).textTheme.bodyMedium,
        ),
        style: Theme.of(context).textTheme.bodyMedium,
        keyboardType: TextInputType.number,
        onSubmitted: (value) {
          int guessNumber = int.tryParse(value) ?? -1;
          if (min <= guessNumber && guessNumber <= max) {
            onSubmitted(guessNumber);
          }
        },
      ),
    );
  }
}
