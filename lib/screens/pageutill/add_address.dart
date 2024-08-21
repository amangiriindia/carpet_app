import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../const.dart';

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
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      height: 48,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: TextField(
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
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Address",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.black,
        ),
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
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.0),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildTextField(
                            hintText: 'Name',
                            controller: nameController,
                          ),
                          _buildTextField(
                            hintText: 'Phone Number',
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                          ),
                          _buildTextField(
                            hintText: 'Alternative Mobile Number',
                            controller: altPhoneController,
                            keyboardType: TextInputType.phone,
                          ),
                          _buildTextField(
                            hintText: 'Street Address',
                            controller: streetController,
                          ),
                          _buildTextField(
                            hintText: 'City',
                            controller: cityController,
                          ),
                          _buildTextField(
                            hintText: 'State',
                            controller: stateController,
                          ),
                          _buildTextField(
                            hintText: 'Country',
                            controller: countryController,
                          ),
                          _buildTextField(
                            hintText: 'Postal Code',
                            controller: postalCodeController,
                            keyboardType: TextInputType.number,
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
