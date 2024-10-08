import 'dart:convert';
import 'package:OACrugs/constant/const.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../components/gradient_button.dart';
import '../components/home_app_bar.dart';
import '../components/custom_app_bar.dart';
import 'base/profile_drawer.dart';
import 'base/notification_screen.dart';

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
    super.dispose();
  }

  Future<void> _saveProfileChanges() async {
    if (!_formKey.currentState!.validate()) return;

    CommonFunction.showLoadingDialog(context);

    final url = '${APIConstants.API_URL}api/v1/user/update-user/$_userId';

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
        }),
      );

      CommonFunction.hideLoadingDialog(context);
      print(response.body);
      print(response.statusCode);
      final responseBody = json.decode(response.body);
      final user = responseBody['updatedUser'];
      if (response.statusCode == 200 && responseBody['success']) {
        CommonFunction.showToast(context,
            '${user['firstName']} ${user['lastName']}, Profile changes saved successfully!');

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('firstName', user['firstName']);
        await prefs.setString('lastName', user['lastName']);
        await prefs.setString('email', user['email']);
        await prefs.setString('mobileNumber', user['mobileNumber']);

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
        backgroundColor: AppStyles.backgroundPrimary,
        // Set the background color here
        appBar: const CustomNormalAppBar(),
        // Add an AppBar if it's missing
        endDrawer: const NotificationScreen(),
        drawer: const ProfileDrawer(),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppStyles.backgroundPrimary,
        // Set the background color here
        appBar: const CustomNormalAppBar(),
        // Add an AppBar if it's missing
        endDrawer: const NotificationScreen(),
        drawer: const ProfileDrawer(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
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
                          icon: const Icon(Icons.login_outlined,
                              color: AppStyles.secondaryTextColor),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.mode_edit_outline_outlined,
                          color: AppStyles.primaryTextColor),
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
                  _buildField(
                      'First Name', _firstNameController, _firstNameFocus),
                  _buildField('Last Name', _lastNameController, _lastNameFocus),
                  _buildField('Email', _emailController, _emailFocus),
                  _buildField(
                      'Phone No.', _phoneNumberController, _phoneNumberFocus),
                  const SizedBox(height: 40),
                  Center(
                    child:


                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: double.infinity,
                          child: GradientButton(
                            onPressed: _saveProfileChanges,
                            buttonText: 'Continue',
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
      backgroundColor: AppStyles.primaryColorStart,
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

  Widget _buildField(String label, TextEditingController controller,
      FocusNode focusNode) {
    bool isEmailField = label == 'Email';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: focusNode.hasFocus ? Theme
                  .of(context)
                  .primaryColor : Colors.grey,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (isEmailField) {
                    CommonFunction.showToast(
                        context, 'You cannot change your email!');
                    FocusScope.of(context).requestFocus(
                        FocusNode()); // Unfocus email field
                  } else {
                    FocusScope.of(context).requestFocus(
                        focusNode); // Allow focus on other fields
                  }
                },
                child: AbsorbPointer(
                  absorbing: isEmailField, // Make the email field non-editable
                  child: TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    style: AppStyles.secondaryBodyTextStyle,
                    decoration: InputDecoration(
                      labelText: label,
                      labelStyle: AppStyles.headingTextStyle,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                    ),
                  ),
                ),
              ),
            ),
            if (!isEmailField) // Show the edit icon only for non-email fields
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppStyles.primaryColorEnd,
                      AppStyles.primaryColorStart
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: IconButton(
                    icon: const Icon(Icons.mode_edit_outlined, size: 10,
                        color: Colors.white),
                    onPressed: () =>
                        FocusScope.of(context).requestFocus(focusNode),
                    padding: EdgeInsets.zero,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}




