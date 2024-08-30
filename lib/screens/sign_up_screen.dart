import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../components/gradient_button.dart';
import '../const.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController firstNameController,
      lastNameController,
      emailController,
      mobileController,
      passwordController,
      rePasswordController;
  late FocusNode firstNameFocusNode,
      lastNameFocusNode,
      emailFocusNode,
      mobileFocusNode,
      passwordFocusNode,
      rePasswordFocusNode;
  String? _rePasswordErrorText;
  bool _isTermsAccepted = false;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    mobileController = TextEditingController();
    passwordController = TextEditingController();
    rePasswordController = TextEditingController();
    firstNameFocusNode = FocusNode();
    lastNameFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    mobileFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    rePasswordFocusNode = FocusNode();

    // Real-time validation
    rePasswordController.addListener(() {
      setState(() {
        if (rePasswordController.text != passwordController.text) {
          _rePasswordErrorText = 'Passwords do not match';
        } else {
          _rePasswordErrorText = null;
        }
      });
    });
  }

  void _handleTapOutside() => FocusScope.of(context).unfocus();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    emailFocusNode.dispose();
    mobileFocusNode.dispose();
    passwordFocusNode.dispose();
    rePasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_isTermsAccepted) {
      if (passwordController.text == rePasswordController.text) {
        CommonFunction.showLoadingDialog(context);

        final response = await http.post(
          Uri.parse('${APIConstants.API_URL}/api/v1/user/register'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'firstName': firstNameController.text,
            'lastName': lastNameController.text,
            'email': emailController.text,
            'mobileNumber': mobileController.text,
            'password': passwordController.text,
            'confirmPassword': rePasswordController.text,
          }),
        );

        // Hide the loading dialog
        CommonFunction.hideLoadingDialog(context);

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        final data = jsonDecode(response.body);

        if (response.statusCode == 201) {
          if (data['success'] == true) {
            CommonFunction.showToast(context,data['message'] ?? 'Registration successful!');
            await _saveUserInfo();
            // Show the loading dialog before navigating
            CommonFunction.showLoadingDialog(context);
            // Add a 2-second delay before navigating
            Future.delayed(Duration(seconds: 2), () {
              CommonFunction.hideLoadingDialog(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            });
          } else {
            CommonFunction.showToast (context,data['message'] ?? 'An error occurred');
          }
        } else if (response.statusCode == 400) {
          CommonFunction.showToast(context,data['message'] ?? 'Bad request. Please check your input.');
        } else {
          CommonFunction.showToast(context,'Failed to sign up. Please try again.');
        }
      } else {
        setState(() {
          _rePasswordErrorText = 'Passwords do not match';
        });
      }
    } else {
      CommonFunction.showToast(context,'You must accept the terms and conditions to sign up.');
    }
  }




  Future<void> _saveUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('first_name', firstNameController.text);
    await prefs.setString('last_name', lastNameController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('mobile', mobileController.text);
    await prefs.setString('password', passwordController.text);
  }

  void _showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Terms and Conditions'),
          content: SingleChildScrollView(
            child: Text(
              'Here are the terms and conditions...',
              // Add your terms and conditions text here
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required String hintText,
    required TextEditingController controller,
    required FocusNode focusNode,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    List<TextInputFormatter>? inputFormatters,
    double height = 48,
    double width = double.infinity,
  }) {
    return Container(
      width: width,
      height: height,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
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
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        ),
      ),
    );
  }

  Widget _buildEmailForm() {
    return Column(
      children: [
        _buildTextField(
          hintText: 'First Name',
          controller: firstNameController,
          focusNode: firstNameFocusNode,
        ),
        SizedBox(height: 20),
        _buildTextField(
          hintText: 'Last Name',
          controller: lastNameController,
          focusNode: lastNameFocusNode,
        ),
        SizedBox(height: 20),
        _buildTextField(
          hintText: 'Email ID',
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          focusNode: emailFocusNode,
        ),
        SizedBox(height: 20),
        _buildTextField(
          hintText: 'Mobile Number',
          controller: mobileController,
          keyboardType: TextInputType.phone,
          focusNode: mobileFocusNode,
        ),
        SizedBox(height: 20),
        _buildTextField(
          hintText: 'Password',
          controller: passwordController,
          obscureText: true,
          focusNode: passwordFocusNode,
        ),
        SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
              hintText: 'Confirm Password',
              controller: rePasswordController,
              obscureText: true,
              focusNode: rePasswordFocusNode,
              height: 48,
              width: double.infinity,
            ),
            if (_rePasswordErrorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _rePasswordErrorText!,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Checkbox(
              value: _isTermsAccepted,
              onChanged: (bool? value) {
                setState(() {
                  _isTermsAccepted = value ?? false;
                });
              },
            ),
            GestureDetector(
              onTap: _showTermsAndConditions,
              child: Text(
                'I accept all terms and conditions',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTapOutside,
      child: Scaffold(
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
                          Text(
                            'SIGN UP',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(16.0),
                            child: _buildEmailForm(),
                          ),







                          Container(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                width: double.infinity,
                                child: GradientButton(
                                  onPressed: _signUp,
                                  buttonText: 'Sign Up',
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Text('OR', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        // Show loading dialog before the delay (optional)
                        CommonFunction.showLoadingDialog(context);

                        // Add a 2-second delay before navigation
                        Future.delayed(Duration(seconds: 2), () {
                          // Hide the loading dialog (optional)
                          CommonFunction.hideLoadingDialog(context);

                          // Navigate to the LoginScreen after the delay
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        });
                      },
                      child: Text(
                        'LOGIN',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
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
