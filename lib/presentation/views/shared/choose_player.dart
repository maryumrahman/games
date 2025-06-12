import 'package:flutter/material.dart';

Future<int?> showSelectPlayerDialog(BuildContext context) async {
  return await showDialog<int>(
    context: context,
    builder: (context) {
      String selectedPlayer = 'Player 1'; // default

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Select Player'),
            content: DropdownButton<String>(
              value: selectedPlayer,
              items: ['Player 1', 'Player 2'].map((player) {
                return DropdownMenuItem<String>(
                  value: player,
                  child: Text(player),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedPlayer = value;
                  });
                }
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(), // Return null
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  int result = selectedPlayer == 'Player 1' ? 1 : 2;
                  Navigator.of(context).pop(result); // Return 1 or 2
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    },
  );
}
