import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../const.dart';
import 'login_screen.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Import fluttertoast

class ConfirmPasswordScreen extends StatefulWidget {
  final String email;

  ConfirmPasswordScreen({required this.email});

  @override
  _ConfirmPasswordScreenState createState() => _ConfirmPasswordScreenState();
}

class _ConfirmPasswordScreenState extends State<ConfirmPasswordScreen> {
  late TextEditingController otpController, newPasswordController, confirmPasswordController;
  late FocusNode otpFocusNode, newPasswordFocusNode, confirmPasswordFocusNode;
  String? _rePasswordErrorText;
  String? _otpErrorText;

  @override
  void initState() {
    super.initState();
    otpController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    otpFocusNode = FocusNode();
    newPasswordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();

    // Real-time validation
    confirmPasswordController.addListener(() {
      setState(() {
        if (confirmPasswordController.text != newPasswordController.text) {
          _rePasswordErrorText = 'Passwords do not match';
        } else {
          _rePasswordErrorText = null;
        }
      });
    });
  }

  @override
  void dispose() {
    otpController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    otpFocusNode.dispose();
    newPasswordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,  // Change gravity to top
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> _changePassword() async {
    _showLoadingDialog();
    if (newPasswordController.text == confirmPasswordController.text) {
      final response = await http.post(
        Uri.parse('${APIConstants.API_URL}/api/auth/verify-otp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },

        body: jsonEncode(<String, String>{
          'email': widget.email,
          'otp': otpController.text,
          'password': newPasswordController.text,
          'confirmPassword': confirmPasswordController.text,
        }),

      );
      _hideLoadingDialog();
      // Debug print statements to check the response
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['success'] == true) {

          _showToast('Your password has been changed successfully.');

          _showLoadingDialog();

          // Add a 2-second delay before navigation
          Future.delayed(Duration(seconds: 2), () {
            // Hide the loading dialog (optional)
            _hideLoadingDialog();

            // Navigate to the LoginScreen after the delay
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false,
            );
          });

        } else {
          _showToast(data['message'] ?? 'An error occurred');
        }
      } else if (response.statusCode == 400) {
        _showToast(data['message'] ?? 'Invalid request. Please check your input.');
      } else {
        _showToast('Failed to change password. Please try again.');
      }
    } else {
      setState(() {
        _rePasswordErrorText = 'Passwords do not match';
      });
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissal when tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Loading...'),
            ],
          ),
        );
      },
    );
  }

  void _hideLoadingDialog() {
    Navigator.of(context).pop(); // Close the dialog
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
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
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
                            'CHANGE PASSWORD',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          _buildTextField(
                            hintText: 'Enter OTP',
                            controller: otpController,
                            focusNode: otpFocusNode,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 20),
                          _buildTextField(
                            hintText: 'New Password',
                            controller: newPasswordController,
                            focusNode: newPasswordFocusNode,
                            obscureText: true,
                          ),
                          SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildTextField(
                                hintText: 'Confirm Password',
                                controller: confirmPasswordController,
                                focusNode: confirmPasswordFocusNode,
                                obscureText: true,
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
                          Container(
                            width: double.infinity,
                            height: 41.72,
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
                              onPressed: _changePassword,
                              child: Center(
                                child: Text(
                                  'Change Password',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      child: Text(
                        'Back to Login',
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
