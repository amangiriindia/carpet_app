import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../address_screen.dart';
import 'enquire_page.dart'; // Import the EnquirePage

class CarpetShapeSizePage extends StatefulWidget {
  final String carpetId;
  final String patternId;
  final String carpetName;
  final Uint8List patternImage;
  final List<String> hexCodes;

  const CarpetShapeSizePage({
    required this.carpetId,
    required this.patternId,
    required this.carpetName,
    required this.patternImage,
    required this.hexCodes,
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
  String? _selectedAddressId;
  final TextEditingController _queryController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  DateTime? _expectedDeliveryDate;

  @override
  void initState() {
    super.initState();
    _fetchCarpetDetails();
    _getIdFormAddressScreen();
  }

  void _getIdFormAddressScreen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (await prefs.getBool('CurrentSelectedAddressFlag') ?? false) {
      _selectedAddressId = await prefs.getString('CurrentSelectedAddress');
      await prefs.setBool('checkCarpetFlag', false);
      await prefs.setBool('CurrentSelectedAddressFlag', false);
      Fluttertoast.showToast(
        msg: "Selected Address ID: $_selectedAddressId",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
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

  void _onContinuePressed() {
    _getIdFormAddressScreen();
    if (_selectedShapeId != null && _selectedDimensionId != null && _selectedAddressId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EnquiryScreen(
            carpetId: widget.carpetId,
            patternId: widget.patternId,
            carpetName: widget.carpetName,
            patternImage: widget.patternImage,
            hexCodes: widget.hexCodes,
            shapeId: _selectedShapeId!,
            dimensionId: _selectedDimensionId!,
            addressId: _selectedAddressId!,
            quantity: _quantityController.text,
            expectedDeliveryDate: _expectedDeliveryDate,
            query: _queryController.text,
          ),
        ),
      );
    } else {
      _getIdFormAddressScreen();
      _showToast('Please select size, shape, and address.');
    }
  }


  Future<void> _selectExpectedDeliveryDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _expectedDeliveryDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _expectedDeliveryDate) {
      setState(() {
        _expectedDeliveryDate = picked;
      });
    }
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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

            // Displaying shapes
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

            const Text(
              'Quantity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter quantity',
                // keyboardType: TextInputType.number,
              ),
            ),

            const SizedBox(height: 20.0),

            const Text(
              'Expected Delivery Date',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              readOnly: true,
              onTap: _selectExpectedDeliveryDate,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: _expectedDeliveryDate != null
                    ? '${_expectedDeliveryDate!.toLocal()}'.split(' ')[0]
                    : 'Select date',
              ),
            ),
            const SizedBox(height: 20.0),

            // Input Fields
            const Text(
              'Any Query',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _queryController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your query here',
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 30.0),

            // Button to select address
            ElevatedButton.icon(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('checkCarpetFlag', true);
                // Navigate to the AddressScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddressScreen()),
                );
              },
              icon: const Icon(Icons.location_on, color: Colors.white), // Set icon color to white
              label: const Text('Select Address', style: TextStyle(color: Colors.white)), // Set text color to white
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size.fromHeight(50), // Set a minimum height for the button (adjust as needed)
                textStyle: const TextStyle(fontSize: 18),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Adjust padding as needed
              ),
            ),
            const SizedBox(height: 15.0), // Reduced spacing between buttons

            SizedBox( // Wrap the "Continue" button in a SizedBox for full width
              width: double.infinity, // Occupy full width
              child: ElevatedButton(
                onPressed: _onContinuePressed,
                child: const Text('Continue', style: TextStyle(color: Colors.white)), // Explicitly set text color to white
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  textStyle: const TextStyle(fontSize: 18), // You can remove color here since it's already set in the Text widget
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
