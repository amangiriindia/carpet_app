import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

import 'carpet_pattern_color_filler.dart';

class CarpetPatternPage extends StatefulWidget {
  final String carpetId;
  final String carpetName;

  const CarpetPatternPage({
    required this.carpetId,
    required this.carpetName,
  });

  @override
  _CarpetPatternPageState createState() => _CarpetPatternPageState();
}

class _CarpetPatternPageState extends State<CarpetPatternPage> {
  Map<String, Uint8List> _patterns = {};
  bool _isLoading = true;
  String _errorMessage = '';
  String? _selectedPatternId;

  @override
  void initState() {
    super.initState();
    _fetchPatterns();
    Future.delayed(Duration.zero, () {
      Fluttertoast.showToast(
        msg: "Carpet ID: ${widget.carpetId}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
  }

  Future<void> _fetchPatterns() async {
    final url = 'https://oac.onrender.com/api/v1/carpet/single-carpet/${widget.carpetId}';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final collections = data['getSingleCarpet']['collections'] as List;

        setState(() {
          _patterns = {
            for (var item in collections)
              item['_id']: Uint8List.fromList(List<int>.from(item['photo']['data']['data'] as List<dynamic>))
          };
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load patterns';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }
  void _navigateToColorFillerPage() {
    if (_selectedPatternId == null) {
      Fluttertoast.showToast(
        msg: "Please select a pattern",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarpetPatternColorFillerPage(
          carpetId: widget.carpetId,
          patternId: _selectedPatternId!,
          carpetName: widget.carpetName,
          patternImage: _patterns[_selectedPatternId!]!, // Pass the selected image
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Select Your Pattern'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.carpetName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _errorMessage.isNotEmpty
                      ? Center(child: Text(_errorMessage))
                      : Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: _patterns.length,
                      itemBuilder: (context, index) {
                        final patternId = _patterns.keys.elementAt(index);
                        final isSelected = _selectedPatternId == patternId;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedPatternId = patternId;
                            });
                          },
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  image: DecorationImage(
                                    image: MemoryImage(_patterns[patternId]!),
                                    fit: BoxFit.cover,
                                  ),
                                  border: isSelected
                                      ? Border.all(color: Colors.black, width: 3.0)
                                      : null,
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _navigateToColorFillerPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

