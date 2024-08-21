import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../address_screen.dart';

class CarpetShapeSizePage extends StatefulWidget {
  final String carpetId;
  final String patternId;
  final String carpetName;
  final Uint8List patternImage;
  final List<String> hexCodes;
  final String? selectedAddressId; // New parameter for selected address ID

  const CarpetShapeSizePage({
    required this.carpetId,
    required this.patternId,
    required this.carpetName,
    required this.patternImage,
    required this.hexCodes,
    this.selectedAddressId, // Initialize new parameter
  });

  @override
  _CarpetShapeSizePageState createState() => _CarpetShapeSizePageState();
}


class _CarpetShapeSizePageState extends State<CarpetShapeSizePage> {
  List<Map<String, dynamic>> _dimensions = [];
  List<Map<String, dynamic>> _shapes = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String? _selectedShapeId;
  String? _selectedDimensionId;

  @override
  void initState() {
    super.initState();
    _fetchCarpetDetails();
  }
  void _navigateToAddressScreen() async {
    final selectedAddressId = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddressScreen()),
    );

    if (selectedAddressId != null && selectedAddressId is String) {
      // Handle the selected address ID
      print('Selected Address ID: $selectedAddressId');
    }
  }

  Future<void> _fetchCarpetDetails() async {
    final url = 'https://oac.onrender.com/api/v1/carpet/single-carpet/${widget.carpetId}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final carpet = data['getSingleCarpet'];

        setState(() {
          _dimensions = List<Map<String, dynamic>>.from(carpet['dimension']);
          _shapes = List<Map<String, dynamic>>.from(carpet['shape']);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load carpet details';
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

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Widget _buildDimensionItem(Map<String, dynamic> dimension) {
    bool isSelected = dimension['_id'] == _selectedDimensionId;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDimensionId = dimension['_id'];
        });
        _showToast(dimension['_id']);
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Colors.black,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Text(
          dimension['size'],
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildShapeItem(Map<String, dynamic> shape) {
    double boxSize = 100.0; // Default size for the box

    switch (shape['shape']) {
      case 'Square':
        boxSize = 100.0;
        break;
      case 'Circle':
        boxSize = 100.0;
        break;
      case 'Elipse':
        boxSize = 120.0; // Adjust size as needed
        break;
    }

    bool isSelected = shape['_id'] == _selectedShapeId;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedShapeId = shape['_id'];
        });
        _showToast(shape['_id']);
      },
      child: Container(
        width: boxSize,
        height: boxSize,
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[100] : Colors.grey[200],
          borderRadius: shape['shape'] == 'Circle' ? BorderRadius.circular(boxSize / 2) : BorderRadius.circular(8.0),
          border: Border.all(
            color: Colors.black,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Center(
          child: Text(
            shape['shape'],
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Carpet Shape & Size'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Displaying the pattern image
                    Container(
                      height: 200, // Height for the image container
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
                    // Displaying dimensions
                    const Text(
                      'Select Size (cm)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : _errorMessage.isNotEmpty
                        ? Center(child: Text(_errorMessage))
                        : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _dimensions.map(_buildDimensionItem).toList(),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      'Select Shape',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _shapes.map(_buildShapeItem).toList(),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    // Button to select address
                    ElevatedButton.icon(
                      onPressed: () {
                        // Navigate to the AddressScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddressScreen()),
                        );
                      },

                      icon: const Icon(Icons.location_on),
                      label: const Text('Select Address'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50), // Make button full width and taller
                        padding: const EdgeInsets.symmetric(vertical: 16.0), // Add padding for height
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ),
          // Large Continue button
          Container(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Handle continue action
                _showToast('Continue button pressed');
              },
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 60), // Make button full width and taller
                padding: const EdgeInsets.symmetric(vertical: 16.0), // Add padding for height
              ),
            ),
          ),
        ],
      ),
    );
  }
}
