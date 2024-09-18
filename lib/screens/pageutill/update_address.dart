import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../components/home_app_bar.dart';
import '../../constant/const.dart';
import '../base/notification_screen.dart';
import '../base/profile_drawer.dart';


class UpdateAddressScreen extends StatefulWidget {
  final String addressId;

  const UpdateAddressScreen({super.key, required this.addressId});

  @override
  _UpdateAddressScreenState createState() => _UpdateAddressScreenState();
}

class _UpdateAddressScreenState extends State<UpdateAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _userId;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _optnumberController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId') ?? '66c4aa81c3e37d9ff6c4be6c';
    });
    _fetchAddressDetails();
  }

  Future<void> _fetchAddressDetails() async {
    CommonFunction.showLoadingDialog(context);
    final url = '${APIConstants.API_URL}api/v1/address/single-address/${widget.addressId}';

    try {
      final response = await http.get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
      CommonFunction.hideLoadingDialog(context);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(response.body);

        if (data['success']) {
          final address = data['getSingleAddress']; // Extract the address object
          setState(() {
            _nameController.text = address['name'] ?? "";
            _streetController.text = address['street'] ?? "";
            _cityController.text = address['city'] ?? "";
            _stateController.text = address['state'] ?? "";
            _postalCodeController.text = address['postalCode'] ?? "";
            _countryController.text = address['country'] ?? "";
            _numberController.text = address['number'] ?? "";
            _optnumberController.text = address['optionalNumber'] ?? "";
          });
        } else {
          print(data['message']);
        }
      } else {
        print("Failed to fetch address details.");
      }
    } catch (error) {
      CommonFunction.hideLoadingDialog(context); // Ensure hiding the loading dialog
      print("An error occurred: $error");
    }
  }


  Future<void> _updateAddress() async {
    if (_formKey.currentState!.validate()) {
      CommonFunction.showLoadingDialog(context);
      final url = 'https://oac.onrender.com/api/v1/address/update-address/${widget.addressId}';
      try {
        final response = await http.put(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "street": _streetController.text,
            "city": _cityController.text,
            "postalCode": _postalCodeController.text,
            "userId": _userId,
            "name": _nameController.text,
            "state": _stateController.text,
            "country": _countryController.text,
            "number": _numberController.text,
            "optionalNumber": _optnumberController.text,
          }),
        );
        CommonFunction.hideLoadingDialog(context);
        final data = jsonDecode(response.body);
        print(response.body);
        print(response.statusCode);
        if (response.statusCode == 201 && data['success']) {
          CommonFunction.showToast(context,"Address updated successfully");
          Navigator.pop(context); // Return to the previous screen
        } else {
          print(data['message']);
        }
      } catch (error) {
        print('An error occurred: $error');
      }
    }
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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
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
                        const Icon(Icons.location_on_outlined, color: AppStyles.primaryTextColor),
                        const SizedBox(width: 4),
                        const Text('Update Address', style: AppStyles.headingTextStyle),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildTextField('Name', _nameController),
                    const SizedBox(height: 10),
                    _buildTextField('Phone Number', _numberController),
                    const SizedBox(height: 10),
                    _buildTextField('Alternative Phone Number', _optnumberController),
                    const SizedBox(height: 10),
                    _buildTextField('Street', _streetController),
                    const SizedBox(height: 10),
                    _buildTextField('City', _cityController),
                    const SizedBox(height: 10),
                    _buildTextField('State', _stateController),
                    const SizedBox(height: 10),
                    _buildTextField('Postal Code', _postalCodeController),
                    const SizedBox(height: 10),
                    _buildTextField('Country', _countryController),
                    const SizedBox(height: 40),
                    Center(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppStyles.primaryColorStart, AppStyles.primaryColorEnd],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ElevatedButton.icon(
                          onPressed: _updateAddress,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: const Icon(Icons.update, color: Colors.white, size: 16),
                          label: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 22),
                            child: Text('Update Address', style: TextStyle(color: Colors.white, fontSize: 14)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      style: AppStyles.primaryBodyTextStyle,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppStyles.secondaryBodyTextStyle,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
