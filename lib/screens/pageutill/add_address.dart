import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../const.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/profile_drawer.dart';
import '../address_screen.dart';
import '../notification_screen.dart';

class AddAddressPage extends StatefulWidget {
  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  late TextEditingController nameController,
      phoneController,
      altPhoneController,
      streetController,
      cityController,
      stateController,
      countryController,
      postalCodeController;

  late String _userId;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    altPhoneController = TextEditingController();
    streetController = TextEditingController();
    cityController = TextEditingController();
    stateController = TextEditingController();
    countryController = TextEditingController();
    postalCodeController = TextEditingController();

    _loadUserData(); // Load user data on initialization
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _userId = prefs.getString('userId') ?? '66c4aa81c3e37d9ff6c4be6c'; // Fallback user ID if not found
      nameController.text = prefs.getString('firstName') ?? '';
      phoneController.text = prefs.getString('mobileNumber') ?? '';
    });
  }

  Future<void> _addAddress() async {
    if (_formKey.currentState!.validate()) {
      CommonFunction.showLoadingDialog(context);
      final String apiUrl = '${APIConstants.API_URL}/api/v1/address/create-address/';

      Map<String, dynamic> addressData = {
        "userId": _userId,
        "name": nameController.text,
        "number": phoneController.text,
        "altPhone": altPhoneController.text,
        "street": streetController.text,
        "city": cityController.text,
        "state": stateController.text,
        "country": countryController.text,
        "postalCode": postalCodeController.text,
      };

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(addressData),
        );
        CommonFunction.hideLoadingDialog(context);
        if (response.statusCode == 201) {
          final data = jsonDecode(response.body);
          if (data['success']) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(data['message'])),
            );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => AddressScreen()), // Replace AddressScreen with your actual screen
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to create address')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Server error: ${response.statusCode}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Network error: $e')),
        );
      }
    }
  }


  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    altPhoneController.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    postalCodeController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required String hintText,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      height: 60, // Increased height to ensure consistent size
      margin: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 15.0), // Adjusted padding
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(),
        drawer: const NotificationScreen(),
        endDrawer: const ProfileDrawer(),
        body: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.80,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/login/sign_up_page_image.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
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
                          'Add Address',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white, // Set the background color to white
                        borderRadius: BorderRadius.circular(8),
                        // Removed boxShadow
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildTextField(
                            hintText: 'Name',
                            controller: nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          _buildTextField(
                            hintText: 'Phone Number',
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              if (value.length < 10) {
                                return 'Phone number must be at least 10 digits';
                              }
                              return null;
                            },
                          ),
                          _buildTextField(
                            hintText: 'Alternative Mobile Number',
                            controller: altPhoneController,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value != null && value.isNotEmpty && value.length < 10) {
                                return 'Alternative phone number must be at least 10 digits';
                              }
                              return null;
                            },
                          ),
                          _buildTextField(
                            hintText: 'Street Address',
                            controller: streetController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your street address';
                              }
                              return null;
                            },
                          ),
                          _buildTextField(
                            hintText: 'City',
                            controller: cityController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your city';
                              }
                              return null;
                            },
                          ),
                          _buildTextField(
                            hintText: 'State',
                            controller: stateController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your state';
                              }
                              return null;
                            },
                          ),
                          _buildTextField(
                            hintText: 'Country',
                            controller: countryController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your country';
                              }
                              return null;
                            },
                          ),
                          _buildTextField(
                            hintText: 'Postal Code',
                            controller: postalCodeController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your postal code';
                              }
                              if (value.length < 5) {
                                return 'Postal code must be at least 5 digits';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            height: 48.0,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment(-0.67, -1.0),
                                end: Alignment(1.0, 1.91),
                                colors: [Color(0xFF000000), Color(0xFF666666)],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                await _addAddress();
                              },
                              child: Text(
                                'Add Address',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
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
        ),
      ),
    );
  }
}
