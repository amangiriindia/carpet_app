import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/profile_drawer.dart';
import '../address_screen.dart';
import '../notification_screen.dart';
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
    print(widget.hexCodes);
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
      _onContinuePressed();
    }
    _onContinuePressed();

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
      _showToast('Please select size, shape, and address.');
      return;
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
      appBar: const CustomAppBar(),
      drawer: const NotificationScreen(),
      endDrawer: const ProfileDrawer(),
      body: Column(
        children: [
          // Fixed top row for color choice
          Container(
            padding: const EdgeInsets.all(12.0),
            color: Colors.white,
            child: Row(
              children: [
                const SizedBox(width: 12),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(3.14),
                  child: IconButton(
                    icon: const Icon(Icons.login_outlined, color: Colors.black54),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 80),
                const Icon(Icons.list_alt_outlined, color: Colors.black54),
                const SizedBox(width: 4),
                const Text(
                  'Customize Carpet',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
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
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    widget.carpetName,
                    style: const TextStyle(
                      fontSize: 18,
                        color: Colors.black
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Displaying dimensions
                  const Text(
                    'Select Size (cm)',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black
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
                      fontSize: 16,
                      color: Colors.black,
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

                  // Quantity
                  const Text(
                    'Quantity',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter quantity',
                      filled: true,
                      fillColor: Colors.black12,
                    ),
                    onTap: () {
                      setState(() {
                        // Change color to black when tapped
                        _quantityController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: _quantityController.text.length,
                        );
                      });
                    },
                  ),

                  const SizedBox(height: 20.0),

                  // Expected Delivery Date
                  const Text(
                    'Expected Delivery Date',
                    style: TextStyle(
                      fontSize: 16,
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
                      filled: true,
                      fillColor: Colors.black12,
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Any Query
                  const Text(
                    'Any Query',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  TextField(
                    controller: _queryController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your query here',
                      filled: true,
                      fillColor: Colors.black12,
                    ),
                    maxLines: 3,
                  ),

                  const SizedBox(height: 30.0),

                  // Button to select address
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6, // Adjust the multiplier (0.8) as needed
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('checkCarpetFlag', true);
                          // Navigate to the AddressScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AddressScreen()),
                          );
                        },
                        icon: const Icon(Icons.location_on, color: Colors.white),
                        label: const Text('Select Address', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          minimumSize: const Size.fromHeight(50),
                          textStyle: const TextStyle(fontSize: 14),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0), // Reduced spacing between buttons

                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _getIdFormAddressScreen,
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
            ),
          ),
        ],
      ),
    );
  }


}
