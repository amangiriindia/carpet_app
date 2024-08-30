import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../components/gradient_button.dart';
import '../../components/home_app_bar.dart';
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
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => AddressScreen()), // Replace AddressScreen with your actual screen
            );
          } else {
            print('Failed to create address');
          }
        }
        else {
         print( response.statusCode);
        }
      } catch (e) {
        print('Network error: $e');
      }
    }
  }

  bool validateForm() {
    CommonFunction.showLoadingDialog(context);
    if (nameController.text.isEmpty) {
      CommonFunction.showToast(context, 'Please enter your name');
      CommonFunction.hideLoadingDialog(context);
      return false;
    }
    if (phoneController.text.isEmpty) {
      CommonFunction.showToast(context,'Please enter your phone number');
      CommonFunction.hideLoadingDialog(context);
      return false;
    }
    if (phoneController.text.length < 10) {
      CommonFunction.showToast(context,'Phone number must be at least 10 digits');
      CommonFunction.hideLoadingDialog(context);
      return false;
    }
    if (altPhoneController.text.isNotEmpty && altPhoneController.text.length < 10) {
      CommonFunction.showToast(context,'Alternative phone number must be at least 10 digits');
      CommonFunction.hideLoadingDialog(context);
      return false;
    }
    if (streetController.text.isEmpty) {
      CommonFunction.showToast(context,'Please enter your street address');
      CommonFunction.hideLoadingDialog(context);
      return false;
    }
    if (cityController.text.isEmpty) {
      CommonFunction.showToast(context,'Please enter your city');
      CommonFunction.hideLoadingDialog(context);
      return false;
    }
    if (stateController.text.isEmpty) {
      CommonFunction.showToast(context,'Please enter your state');
      CommonFunction.hideLoadingDialog(context);
      return false;
    }
    if (countryController.text.isEmpty) {
      CommonFunction.showToast(context,'Please enter your country');
      CommonFunction.hideLoadingDialog(context);
      return false;
    }
    if (postalCodeController.text.isEmpty) {
      CommonFunction.showToast(context,'Please enter your postal code');
      CommonFunction.hideLoadingDialog(context);
      return false;
    }
    if (postalCodeController.text.length < 5) {
      CommonFunction.showToast(context,'Postal code must be at least 5 digits');
      CommonFunction.hideLoadingDialog(context);
      return false;
    }

    _addAddress();
    return true;
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
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppStyles.backgroundPrimary,
        appBar: const CustomNormalAppBar(),
        endDrawer: const NotificationScreen(),
        drawer: const ProfileDrawer(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(3.14),
                    child: IconButton(
                      icon: const Icon(Icons.login_outlined, color: AppStyles.secondaryTextColor),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 80),
                  const Icon(Icons.add_location_alt_outlined, color: AppStyles.primaryTextColor),
                  const SizedBox(width: 4),
                  const Text(
                    'Add Address',
                    style: AppStyles.headingTextStyle,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
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
                              color: Colors.white,
                              padding: const EdgeInsets.all(16.0),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: GradientButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        await  validateForm();
                                      }
                                    },
                                    buttonText: 'Add Address',
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
            ),
          ],
        ),
      ),
    );
  }
}
