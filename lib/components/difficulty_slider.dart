import 'package:flutter/material.dart';

class DifficultySlider extends StatelessWidget {
  final double difficultyLevel;
  final ValueChanged<double> onChanged;
  final List<String> difficulties;
  final String difficulty;

  const DifficultySlider({
    super.key,
    required this.difficultyLevel,
    required this.onChanged,
    required this.difficulties,
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('Seleccione el nivel de dificultad:'),
          Slider(
            value: difficultyLevel,
            min: 0,
            max: 3,
            divisions: 3,
            label: difficulty,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}