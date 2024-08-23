import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding
import 'dart:typed_data'; // Import for Uint8List
import '../../widgets/color_picker.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_navigation_bar.dart';
import '../../widgets/profile_drawer.dart';
import '../home_screen.dart';
import '../notification_screen.dart';
import '../search_screen.dart';
import 'package:OACrugs/screens/wishlist_screen.dart';

import '../thanks_screen.dart'; // Correct import statement

class EnquiryScreen extends StatefulWidget {
  final String carpetId;
  final String patternId;
  final String carpetName;
  final Uint8List patternImage;
  final List<String> hexCodes;
  final String shapeId;
  final String dimensionId;
  final String addressId;
  final String quantity;
  final DateTime? expectedDeliveryDate;
  final String query;

  const EnquiryScreen({
    super.key,
    required this.carpetId,
    required this.patternId,
    required this.carpetName,
    required this.patternImage,
    required this.hexCodes,
    required this.shapeId,
    required this.dimensionId,
    required this.addressId,
    required this.quantity,
    this.expectedDeliveryDate,
    required this.query,
  });

  @override
  _EnquiryScreenState createState() => _EnquiryScreenState();
}

class _EnquiryScreenState extends State<EnquiryScreen> {
  final _quantityController = TextEditingController();
  final _queryController = TextEditingController();
  DateTime? _expectedDeliveryDate;
  var _userId;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with passed data
    _quantityController.text = widget.quantity;
    _queryController.text = widget.query;
    _expectedDeliveryDate = widget.expectedDeliveryDate;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId') ?? '66c4aa81c3e37d9ff6c4be6c';
    });

  }

  Future<void> _submitEnquiry() async {
    final String apiUrl = 'https://oac.onrender.com/api/v1/enquiry/create-enquiry';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..fields['user'] = _userId
        ..fields['address'] = widget.addressId
        ..fields['product'] = widget.carpetId
        ..fields['quantity'] = _quantityController.text
        ..fields['productSize'] = widget.dimensionId
        ..fields['shape'] = widget.shapeId
        ..fields['productColor'] = jsonEncode(widget.hexCodes) // Encode as JSON array
        ..fields['query'] = _queryController.text
        ..fields['status'] = 'false'
        ..fields['expectedDelivery'] = _expectedDeliveryDate?.toIso8601String() ?? ''
        ..fields['patternId'] = widget.patternId;
      // Check if the image is available and add it to the request
      if (widget.patternImage.isNotEmpty) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'photo',
            widget.patternImage,
            filename: 'pattern_image.jpg',

          ),
        );
        print('Added file to request');
      } else {
        print('Pattern image is null or empty, skipping image upload.');
      }

      // Send the request
      final response = await request.send();

      // Convert the streamed response into a full Response object
      final responseBody = await http.Response.fromStream(response);
      final responseJson = json.decode(responseBody.body);

      // Debugging: Print request details and response
      print('Request fields: ${request.fields}');
      print('Response status code: ${response.statusCode}');
      print('Response body: ${responseBody.body}');

      Fluttertoast.showToast(
        msg: 'Response body: ${responseBody.body}',
        toastLength: Toast.LENGTH_LONG, // Use Toast.LENGTH_LONG for a longer duration
        gravity: ToastGravity.BOTTOM,
      );


      if (response.statusCode == 201) {
        // Success case
        print('Enquiry submitted successfully');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ThankYouScreen(),
          ),
        );
      } else {
        // Handle error cases, including 400, 401, 500, and others
        String errorMessage = responseJson['message'] ?? 'Unknown error';
        print('Failed to submit enquiry: $errorMessage');

        // You can show an error message to the user here
        // For example, using a SnackBar:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $errorMessage')),
        );
      }
    } catch (error) {
      // Catch and print any errors during the process
      print('Error submitting enquiry: $error');

      // Show a generic error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while submitting the enquiry.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorPickerProvider = Provider.of<ColorPickerProvider>(context, listen: false);

    // Load image and extract colors after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ImageProvider imageProvider = MemoryImage(widget.patternImage); // Use the pattern image from previous page
      await colorPickerProvider.extractColorsFromImage(imageProvider);
    });

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const NotificationScreen(),
      endDrawer: const ProfileDrawer(),
      body: Consumer<ColorPickerProvider>(
        builder: (context, colorPickerProvider, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(widget.carpetName, style: TextStyle(fontSize: 20)),
              ),
              Image.memory(
                widget.patternImage,
                height: 250,
                width: 200,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 8),
              const Divider(indent: 20, endIndent: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExpansionTile(
                        title: Text('Product Details'),
                        children: [
                          ListTile(
                            title: Text('Dimension'),
                            subtitle: Text(widget.dimensionId), // Show selected dimension
                          ),
                          ListTile(
                            title: Text('Quality'),
                            subtitle: Text('Hand-knotted'), // Example data
                          ),
                          ListTile(
                            title: Text('Material'),
                            subtitle: Text('Wool & silk on silk base'), // Example data
                          ),
                        ],
                      ),
                      ExpansionTile(
                        title: Text('Care & Maintenance'),
                        children: [
                          ListTile(
                            title: Text('Details'),
                            subtitle: Text('Some details about care and maintenance'),
                          ),
                        ],
                      ),
                      ExpansionTile(
                        title: Text('Disclaimer'),
                        children: [
                          ListTile(
                            title: Text('Details'),
                            subtitle: Text('Some disclaimer details'),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Quantity'),
                            TextField(
                              controller: _quantityController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter quantity',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: 16),
                            Text('Expected Delivery Date'),
                            TextField(
                              controller: TextEditingController(text: _expectedDeliveryDate?.toLocal().toString() ?? ''),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter delivery date',
                              ),
                              onTap: () async {
                                FocusScope.of(context).requestFocus(FocusNode());
                                DateTime? selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: _expectedDeliveryDate ?? DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                );
                                if (selectedDate != null && selectedDate != _expectedDeliveryDate) {
                                  setState(() {
                                    _expectedDeliveryDate = selectedDate;
                                  });
                                }
                              },
                            ),
                            SizedBox(height: 16),
                            Text('Query'),
                            TextField(
                              controller: _queryController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter your query',
                              ),
                              maxLines: 4,
                            ),
                            SizedBox(height: 16),
                            Center(
                              child: ElevatedButton(
                                onPressed: _submitEnquiry, // Trigger the API call
                                child: Text('Submit Enquiry'),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.black,
                                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2, // Set the appropriate index for the Enquiry form screen
        onTap: (index) {
          // Handle navigation based on index
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const HomeScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const SearchScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const WishListScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const ProfileDrawer(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }
        },
      ),
    );
  }
}
