import 'package:flutter/material.dart';
import '../classes/number_guess.dart';

class GuessColumns extends StatelessWidget {
  final List<int> lowNumbers;
  final List<int> highNumbers;
  final List<NumberGuess> guesses;

  const GuessColumns({
    super.key,
    required this.lowNumbers,
    required this.highNumbers,
    required this.guesses,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          _buildSeparator(),
          _buildColumn('Números Menores', lowNumbers),
          _buildSeparator(),
          _buildColumn('Números Mayores', highNumbers),
          _buildSeparator(),
          _buildGuessesColumn('Resultados', guesses),
          _buildSeparator(),
        ],
      ),
    );
  }

  Widget _buildColumn(String title, List<int> numbers) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
        ),
        child: Column(
          children: [
            Text(title, style: TextStyle(color: Colors.white, fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: numbers.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: ListTile(
                      title: Center(
                        child: Text(
                          numbers[index].toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuessesColumn(String title, List<NumberGuess> guesses) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
        ),
        child: Column(
          children: [
            Text(title, style: TextStyle(color: Colors.white, fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: guesses.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: ListTile(
                      title: Center(
                        child: Text(
                          guesses[index].number.toString(),
                          style: TextStyle(
                            color: guesses[index].isCorrect ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeparator() {
    return SizedBox(width: 16);
  }
}
