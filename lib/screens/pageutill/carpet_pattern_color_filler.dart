import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'carpet_shape_size_choose.dart';

class CarpetPatternColorFillerPage extends StatefulWidget {
  final String carpetId;
  final String patternId;
  final String carpetName;
  final Uint8List patternImage;

  const CarpetPatternColorFillerPage({
    required this.carpetId,
    required this.patternId,
    required this.carpetName,
    required this.patternImage,
  });

  @override
  _CarpetPatternColorFillerPageState createState() => _CarpetPatternColorFillerPageState();
}

class _CarpetPatternColorFillerPageState extends State<CarpetPatternColorFillerPage> {
  List<String> _colors = [];
  bool _isLoadingColors = true;
  String _colorErrorMessage = '';
  Map<String, String?> _selectedColors = {'A': null, 'B': null, 'C': null};

  @override
  void initState() {
    super.initState();
    _showToastMessages();
    _fetchColors();
  }

  void _showToastMessages() {
    Fluttertoast.showToast(
      msg: "Carpet ID: ${widget.carpetId}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    Fluttertoast.showToast(
      msg: "Pattern ID: ${widget.patternId}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> _fetchColors() async {
    final url = 'https://oac.onrender.com/api/v1/color/all-color';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final colors = data['allColor'] as List;

        setState(() {
          _colors = colors.map((color) => color['name'] as String).toList();
          _isLoadingColors = false;
        });
      } else {
        setState(() {
          _colorErrorMessage = 'Failed to load colors';
          _isLoadingColors = false;
        });
      }
    } catch (e) {
      setState(() {
        _colorErrorMessage = 'Error: $e';
        _isLoadingColors = false;
      });
    }
  }

  void _onContinuePressed() {
    // Check if all color boxes (A, B, C) are filled
    if (_selectedColors.values.any((color) => color == null)) {
      // Show a message if any box is unfilled
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please choose a color for all boxes'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // Redirect to CarpetShapeSizePage
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CarpetShapeSizePage(
          carpetId: widget.carpetId,
          patternId: widget.patternId,
          carpetName: widget.carpetName,
          patternImage: widget.patternImage,
          hexCodes: _selectedColors.values.whereType<String>().toList(),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Carpet Pattern Color Filler'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: MemoryImage(widget.patternImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(
                  widget.carpetName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Choose your color',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['A', 'B', 'C'].map((box) {
                    return DragTarget<String>(
                      onAccept: (color) {
                        setState(() {
                          _selectedColors[box] = color;
                        });
                      },
                      builder: (context, candidateData, rejectedData) {
                        return Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2.0),
                            color: _selectedColors[box] != null
                                ? Color(int.parse(_selectedColors[box]!.replaceFirst('#', '0xFF')))
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Text(
                              box,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: _selectedColors[box] != null ? Colors.black : Colors.grey,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
          Expanded(
            child: _isLoadingColors
                ? Center(child: CircularProgressIndicator())
                : _colorErrorMessage.isNotEmpty
                ? Center(child: Text(_colorErrorMessage))
                : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: _colors.length,
              itemBuilder: (context, index) {
                final colorHex = _colors[index];
                return Draggable<String>(
                  data: colorHex,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(int.parse(colorHex.replaceFirst('#', '0xFF'))),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  feedback: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(int.parse(colorHex.replaceFirst('#', '0xFF'))),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  childWhenDragging: Container(
                    color: Colors.grey.withOpacity(0.5),
                    width: 50,
                    height: 50,
                    child: Center(
                      child: Icon(Icons.color_lens, color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _onContinuePressed,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                minimumSize: Size(double.infinity, 50),
              ),
              child: const Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }
}
