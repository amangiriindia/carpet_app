import 'package:OACrugs/constant/const.dart';
import 'package:OACrugs/screens/pageutill/search_home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding
import 'dart:typed_data'; // Import for Uint8List
import '../../components/gradient_button.dart';
import '../../components/home_app_bar.dart';
import '../../components/color_picker.dart';
import '../../components/custom_app_bar.dart';
import '../base/custom_navigation_bar.dart';
import '../base/profile_drawer.dart';
import '../home_screen.dart';
import '../base/notification_screen.dart';
import '../search_screen.dart';
import 'package:OACrugs/screens/wishlist_screen.dart';

import 'thanks_screen.dart'; // Correct import statement

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
  late String description = 'Description not available';
  late String quality = 'Quality not specified';
  late String material = 'Material information not provided';
  late String disclaimer = 'Disclaimer not available';
  late String care = 'Care instructions not available';


  @override
  void initState() {
    super.initState();
    _fetchPatterns();
    // Initialize controllers with passed data
    _quantityController.text = widget.quantity;
    _queryController.text = widget.query;
    _expectedDeliveryDate = widget.expectedDeliveryDate;
    _loadUserData();
  }

  Future<void> _fetchPatterns() async {
    String _errorMessage = '';
    final url =
        'https://oac.onrender.com/api/v1/carpet/single-carpet/${widget.carpetId}';
    try {
      final response = await http.get(Uri.parse(url));
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        description = data['getSingleCarpet']['description'];
        quality = data['getSingleCarpet']['quality'];
        material = data['getSingleCarpet']['material'];
        disclaimer = data['getSingleCarpet']['disclaimer'];
        care = data['getSingleCarpet']['care'];
      } else {
        setState(() {
          _errorMessage = 'Failed to load patterns';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load patterns';
      });
    }
  }


  Future<void> _selectExpectedDeliveryDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.black, // Header background color (month/year)
            colorScheme: ColorScheme.light(
              primary: Colors.black, // Circle color for the selected date
              onSurface: Colors.black, // Text color (dates)
            ),
            dialogBackgroundColor: Colors.white, // Background color of the date picker
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, // OK/Cancel button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _expectedDeliveryDate) {
      setState(() {
        _expectedDeliveryDate = picked;
      });
    }



  }



  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId') ?? '66c4aa81c3e37d9ff6c4be6c';
    });
  }

  Future<void> _submitEnquiry() async {
    final String apiUrl =
        'https://oac.onrender.com/api/v1/enquiry/create-enquiry';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..fields['user'] = _userId
        ..fields['address'] = widget.addressId
        ..fields['product'] = widget.carpetId
        ..fields['quantity'] = _quantityController.text
        ..fields['productSize'] = widget.dimensionId
        ..fields['shape'] = widget.shapeId
        ..fields['productColor'] =
            jsonEncode(widget.hexCodes) // Encode as JSON array
        ..fields['query'] = _queryController.text
        ..fields['status'] = 'false'
        ..fields['expectedDelivery'] =
            _expectedDeliveryDate?.toIso8601String() ?? ''
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
        SnackBar(
            content: Text('An error occurred while submitting the enquiry.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorPickerProvider =
        Provider.of<ColorPickerProvider>(context, listen: false);

    // Load image and extract colors after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ImageProvider imageProvider = MemoryImage(
          widget.patternImage); // Use the pattern image from previous page
      await colorPickerProvider.extractColorsFromImage(imageProvider);
    });

    return Scaffold(
      backgroundColor: AppStyles.backgroundPrimary,
      appBar: const CustomNormalAppBar(),
      endDrawer: const NotificationScreen(),
      drawer: const ProfileDrawer(),
      body: Consumer<ColorPickerProvider>(
        builder: (context, colorPickerProvider, child) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(3.14),
                      child: IconButton(
                        icon: const Icon(Icons.login_outlined,
                            color: AppStyles.secondaryTextColor),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: 80),
                    const Icon(Icons.check_circle_outline,
                        color: AppStyles.primaryTextColor),
                    const SizedBox(width: 4),
                    const Text(
                      'Finalize Enquiry',
                      style: AppStyles.headingTextStyle,
                    ),
                  ],
                ),
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
                      Container(
                        child:Padding(
                          padding: const EdgeInsets.only(left: 16.0), // Adjust the padding value as needed
                          child: Text(
                            '${widget.carpetName}',
                            style: AppStyles.headingTextStyle,
                          ),
                        )

                      ),
                      ExpansionTile(
                        title: Text('Product Details',
                            style: AppStyles.primaryBodyTextStyle),
                        children: [
                          ListTile(
                            title: Text('Description',
                                style: AppStyles.secondaryBodyTextStyle),
                            subtitle: Text(
                              description,
                              style: AppStyles.tertiaryBodyTextStyle,
                            ), // Show selected dimension
                          ),
                          ListTile(
                            title: Text('Quality',
                                style: AppStyles.secondaryBodyTextStyle),
                            subtitle: Text(
                              quality,
                              style: AppStyles.tertiaryBodyTextStyle,
                            ), // Example data
                          ),
                          ListTile(
                            title: Text('Material',
                                style: AppStyles.secondaryBodyTextStyle),
                            subtitle: Text(material,
                                style: AppStyles
                                    .tertiaryBodyTextStyle), // Example data
                          ),
                        ],
                      ),
                      ExpansionTile(
                        title: Text('Care & Maintenance',
                            style: AppStyles.primaryBodyTextStyle),
                        children: [
                          ListTile(
                            title: Text('Details',
                                style: AppStyles.secondaryBodyTextStyle),
                            subtitle: Text(care,
                                style: AppStyles.tertiaryBodyTextStyle),
                          ),
                        ],
                      ),
                      ExpansionTile(
                        title: Text('Disclaimer',
                            style: AppStyles.primaryBodyTextStyle),
                        children: [
                          ListTile(
                            title: Text('Details',
                                style: AppStyles.secondaryBodyTextStyle),
                            subtitle: Text(disclaimer,
                                style: AppStyles.tertiaryBodyTextStyle),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Quantity',
                                style: AppStyles.primaryBodyTextStyle),
                            TextField(
                              controller: _quantityController,
                              keyboardType: TextInputType.number,
                              decoration: AppStyles.textFieldDecoration(
                                  'Enter quantity'),
                            ),
                            SizedBox(height: 16),

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

                            SizedBox(height: 16),
                            Text('Query',
                                style: AppStyles.primaryBodyTextStyle),
                            TextField(
                              controller: _queryController,
                              cursorColor: AppStyles.secondaryTextColor,
                              decoration: AppStyles.textFieldDecoration(
                                  'Enter your query here'),
                              maxLines: 3,
                            ),
                            SizedBox(height: 16),

                            Container(
                              color: Colors.white,
                              padding: const EdgeInsets.all(16.0),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: GradientButton(
                                    onPressed: _submitEnquiry,
                                    buttonText: 'Submit Enquiry',
                                  ),
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
        currentIndex:
            2, // Set the appropriate index for the Enquiry form screen
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
                pageBuilder: (_, __, ___) => const SearchHomePage(),
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
