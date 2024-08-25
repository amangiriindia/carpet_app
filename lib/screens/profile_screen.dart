import 'dart:convert';
import 'package:OACrugs/const.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../widgets/custom_app_bar.dart';
import '../widgets/profile_drawer.dart';
import 'notification_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
} 

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _addressController;
  late String _userId;
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneNumberFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _addressController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _userId = prefs.getString('userId') ?? '66c4aa81c3e37d9ff6c4be6c';
      _firstNameController.text = prefs.getString('firstName') ?? '';
      _lastNameController.text = prefs.getString('lastName') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
      _phoneNumberController.text = prefs.getString('mobileNumber') ?? '';
      _addressController.text = prefs.getString('address') ?? '';
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    _phoneNumberFocus.dispose();
    _addressFocus.dispose();
    super.dispose();
  }

  Future<void> _saveProfileChanges() async {
    if (!_formKey.currentState!.validate()) return;

    CommonFunction.showLoadingDialog(context);

    final url = 'https://oac.onrender.com/api/v1/user/update-user/$_userId';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'email': _emailController.text.trim(),
          'mobileNumber': _phoneNumberController.text.trim(),
          'address': _addressController.text.trim(),
        }),
      );

      CommonFunction.hideLoadingDialog(context);

      final responseBody = json.decode(response.body);
      final user = responseBody['updatedUser'];
      if (response.statusCode == 200 && responseBody['success']) {
        CommonFunction.showToast(context, '${user['firstName']} ${user['lastName']}, Profile changes saved successfully!');

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('firstName', user['firstName']);
        await prefs.setString('lastName', user['lastName']);
        await prefs.setString('email', user['email']);
        await prefs.setString('mobileNumber', user['mobileNumber']);
        await prefs.setString('address', user['address']);

        // Optionally, you can refresh the user profile or navigate away
      } else {
        print('Failed to save changes: ${responseBody['message']}');
      }
    } catch (e) {
      print('Error: $e');
      CommonFunction.hideLoadingDialog(context);

    }
  }

  @override
  Widget build(BuildContext context) {

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppStyles.backgroundPrimary, // Set the background color here
        appBar: const CustomAppBar(), // Add an AppBar if it's missing
        drawer: const NotificationScreen(),
        endDrawer: const ProfileDrawer(),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppStyles.backgroundPrimary, // Set the background color here
        appBar: const CustomAppBar(), // Add an AppBar if it's missing
        drawer: const NotificationScreen(),
        endDrawer: const ProfileDrawer(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal:5),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(3.14),
                        child: IconButton(
                          icon: const Icon(Icons.login_outlined,color:AppStyles.secondaryTextColor),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.mode_edit_outline_outlined,  color:AppStyles.primaryTextColor),
                      const SizedBox(width: 4),
                      const Text(
                        'Edit Profile',
                         style: AppStyles.headingTextStyle,
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                  const SizedBox(height: 40),
                  _buildProfileIcon(),
                  const SizedBox(height: 20),
                  _buildField('First Name', _firstNameController, _firstNameFocus),
                  _buildField('Last Name', _lastNameController, _lastNameFocus),
                  _buildField('Email', _emailController, _emailFocus),
                  _buildField('Phone No.', _phoneNumberController, _phoneNumberFocus),
                  const SizedBox(height: 40),
                  Center(
                    child: Container(
                      width: 181,
                      height: 25.24,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF000000), Color(0xFF666666)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(2.74),
                      ),
                      child: ElevatedButton(
                        onPressed: _saveProfileChanges,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.74),
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        child: const Center(
                          child: Text(
                            'Save Changes',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 8.78,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.14,
                              height: 1.5,
                            ),
                          ),
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
    );
  }

  Widget _buildProfileIcon() {
    String name = _firstNameController.text.trim();
    String initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return CircleAvatar(
      radius: 40,
      backgroundColor: const Color(0xFF666666),
      child: Text(
        initial,
        style: const TextStyle(
          fontSize: 40,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, FocusNode focusNode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: focusNode.hasFocus ? Theme.of(context).primaryColor : Colors.grey,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                controller: controller,
                focusNode: focusNode,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  color: Colors.black38,
                ),
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14.66,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                ),
              ),
            ),
            Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: Color(0xFF1D1D1D),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.mode_edit_outlined, size: 10, color: Colors.white),
                  onPressed: () => FocusScope.of(context).requestFocus(focusNode),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
