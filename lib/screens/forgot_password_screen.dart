import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../const.dart';
import 'forgot_confirm_password.dart';
import 'login_screen.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Import fluttertoast

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController emailController;
  late FocusNode emailFocusNode;
  String? _emailErrorText;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    emailFocusNode = FocusNode();
  }

  @override
  void dispose() {
    emailController.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,  // Change gravity to top
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> _sendOtp() async {
    _showLoadingDialog();
    final email = emailController.text;
    if (email.isEmpty) {
      setState(() {
        _emailErrorText = 'Please enter your email address';
      });
      return;
    }

    final response = await http.post(
      Uri.parse('${APIConstants.API_URL}/api/auth/forgot-password'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );
_hideLoadingDialog();
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data['success'] == true) {
        _showToast(data['message'] ?? 'OTP sent successfully!');
        // Show loading dialog before the delay (optional)
        _showLoadingDialog();

        // Add a 2-second delay before navigation
        Future.delayed(Duration(seconds: 2), () {
          // Hide the loading dialog (optional)
          _hideLoadingDialog();

          // Navigate to the LoginScreen after the delay
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ConfirmPasswordScreen(email: email)),
                (Route<dynamic> route) => false,
          );
        });




      } else {
        _showToast(data['message'] ?? 'An error occurred');
      }
    } else if (response.statusCode == 404) {
      _showToast(data['message'] ?? 'Invalid email!');
    } else {
      _showToast('Failed to send OTP. Please try again.');
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
                            'FORGOT PASSWORD',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          _buildTextField(
                            hintText: 'Email ID',
                            controller: emailController,
                            focusNode: emailFocusNode,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          if (_emailErrorText != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                _emailErrorText!,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
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
                              onPressed: _sendOtp,
                              child: Center(
                                child: Text(
                                  'Send OTP',
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
                        // Show loading dialog before the delay (optional)
                        _showLoadingDialog();

                        // Add a 2-second delay before navigation
                        Future.delayed(Duration(seconds: 2), () {
                          // Hide the loading dialog (optional)
                          _hideLoadingDialog();

                          // Navigate to the LoginScreen after the delay
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        });
                      },
                      child: Text(
                        'Back To Login',
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
