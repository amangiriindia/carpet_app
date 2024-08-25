import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../const.dart';
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
      CommonFunction.showToast(context, "Address has been Selected.");
      await prefs.setBool('checkCarpetFlag', false);
      await prefs.setBool('CurrentSelectedAddressFlag', false);
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



  Widget _buildDimensionItem(Map<String, dynamic> dimension) {
    double boxHeight = 50.0; // Default height for the box
    double boxWidth = 100.0;  // Default width for the box
    bool isSelected = dimension['_id'] == _selectedDimensionId;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDimensionId = dimension['_id'];
        });

      },
      child: Container(
        width: boxWidth,
        height: boxHeight,
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? AppStyles.backgroundSecondry : AppStyles.backgroundPrimary,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: isSelected ? AppStyles.primaryColorStart : AppStyles.secondaryTextColor,
            width: isSelected ? 1.0 : 1.0,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              dimension['size'],
              style: AppStyles.secondaryBodyTextStyle.copyWith(
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: AppStyles.primaryColorStart,
                size: 24.0,
              ),
          ],
        ),
      ),
    );
  }


  Widget _buildShapeItem(Map<String, dynamic> shape) {
    double boxHeight = 50.0; // Default height for the box
    double boxWidth = 100.0; // Default width for the box
    bool isSelected = shape['_id'] == _selectedShapeId;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedShapeId = shape['_id'];
        });

      },
      child: Container(
        width: boxWidth,
        height: boxHeight,
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? AppStyles.backgroundSecondry : AppStyles.backgroundPrimary,
          borderRadius: shape['shape'] == 'Circle'
              ? BorderRadius.circular(boxHeight / 2) // Adjusted for circular shapes
              : BorderRadius.circular(8.0), // Rectangular shape
          border: Border.all(
            color: isSelected ? AppStyles.primaryColorStart : AppStyles.secondaryTextColor,
            width: isSelected ? 1.0 : 1.0,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              shape['shape'],
              style: AppStyles.secondaryBodyTextStyle.copyWith(
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: AppStyles.primaryColorStart,
                size: 24.0,
              ),
          ],
        ),
      ),
    );
  }


  void _onContinuePressed() {
    if (_selectedShapeId == null) {
       CommonFunction.showToast(context,'Please select a size.');
      return;
    }

    if (_selectedDimensionId == null) {
      CommonFunction.showToast(context,'Please select a shape.');
      return;
    }


    if (_quantityController.text.isEmpty) {
      CommonFunction.showToast(context,'Please enter the quantity.');
      return;
    }

    if (_expectedDeliveryDate == null) {
      CommonFunction.showToast(context,'Please select the expected delivery date.');
      return;
    }

    if (_queryController.text.isEmpty) {
      CommonFunction.showToast(context,'Please enter your query.');
      return;
    }

    if (_selectedAddressId == null) {
      CommonFunction.showToast(context,'Please select an address.');
      return;
    }

    // If all fields are filled, navigate to the EnquiryScreen
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
      backgroundColor: AppStyles.backgroundPrimary,
      appBar: const CustomAppBar(),
      drawer: const NotificationScreen(),
      endDrawer: const ProfileDrawer(),
      body: Column(
        children: [
          // Fixed top row for color choice
          Container(
            padding: const EdgeInsets.all(12.0),
            child: Row(

              children: [
                const SizedBox(width: 12),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(3.14),
                  child: IconButton(
                    icon: const Icon(Icons.login_outlined, color: AppStyles.secondaryTextColor),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 80),
                const Icon(Icons.style_outlined ,color:AppStyles.primaryTextColor),
                const SizedBox(width: 4),
                const Text(
                  'Customize Carpet',
                    style: AppStyles.headingTextStyle,
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
                     style: AppStyles.headingTextStyle,
                  ),
                  const SizedBox(height: 20.0),

                  // Displaying dimensions
                  const Text(
                    'Select Size (cm)',
                    style: AppStyles.primaryBodyTextStyle,
                  ),
                  const SizedBox(height: 10.0),
                  _isLoading
                      ? CommonFunction.showLoadingIndicator()
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
                    style: AppStyles.primaryBodyTextStyle,
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
                    style: AppStyles.primaryBodyTextStyle,
                  ),
                TextField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  cursorColor: AppStyles.secondaryTextColor ,
                  decoration: AppStyles.textFieldDecoration('Enter quantity'),
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
                    style: AppStyles.primaryBodyTextStyle,
                  ),
                  TextField(
                    readOnly: true,
                    onTap: _selectExpectedDeliveryDate,
                    cursorColor: Colors.black, // Cursor color set to black
                    decoration: AppStyles.textFieldDecoration(
                      _expectedDeliveryDate != null
                          ? '${_expectedDeliveryDate!.toLocal()}'.split(' ')[0]
                          : 'Select date',
                    ),
                  ),

                  const SizedBox(height: 20.0),

                  // Any Query
                  const Text(
                    'Any Query',
                    style: AppStyles.primaryBodyTextStyle,
                  ),
                  TextField(
                    controller: _queryController,
                    cursorColor: AppStyles.secondaryTextColor ,
                    decoration: AppStyles.textFieldDecoration('Enter your query here'),
                    maxLines: 3,
                  ),

                  const SizedBox(height: 30.0),

                  // Button to select address

                  Center(
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.add_location_alt_outlined, color: AppStyles.backgroundPrimary, size: 16),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 22),
                        child: Text(
                          'Select Addres',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
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
