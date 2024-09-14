import 'package:flutter/material.dart';

Future<String> customSizeInput(BuildContext context) async {
  String height = '';
  String width = '';
  String unit = 'cm'; // Default unit

  final result = await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder( // Wrap with StatefulBuilder
        builder: (context, setState) {
          return AlertDialog(
              title: const Text('Custom Size'),
              contentPadding: const EdgeInsets.all(16.0),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Row(
                  children: [
                    _buildInputBox('Height', (value) => height = value),
                    const SizedBox(width: 12),
                    _buildInputBox('Width', (value) => width = value),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      value: unit,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() { // Update state to trigger rebuild
                            unit = newValue;
                          });
                        }
                      },
                      items: <String>['cm', 'foot']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
              TextButton(
              onPressed: () => Navigator.pop(context,
              null),
          child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
          onPressed:
          () {
          if (height.isNotEmpty && width.isNotEmpty) {
          Navigator.pop(context, '$height*$width $unit');
          } else {
          // Handle invalid input
          }
          },
          child: const Text('OK', style: TextStyle(color: Colors.black)),
          ),
          ],
          );
        },
      );
    },
  );

  return result ?? '';
}

Widget _buildInputBox(String label, ValueChanged<String> onChanged) {
  return Expanded(
    child: SizedBox(
      height: 60, // Slightly reduce height
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 4),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                color: Colors.black, // Highlight text
              ),
              decoration: InputDecoration(
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}