import 'package:OACrugs/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'forgot_password_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late TextEditingController emailController, passwordController;
  late TabController _tabController;
  late FocusNode emailFocusNode, passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    emailController = TextEditingController();
    passwordController = TextEditingController();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
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

  void _handleTapOutside() => FocusScope.of(context).unfocus();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _tabController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    _showLoadingDialog();
    final response = await http.post(
      Uri.parse('https://email-fp0n.onrender.com/api/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );
    _hideLoadingDialog();

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = data['user'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('userId', user['_id']);
      await prefs.setString('firstName', user['firstName']);
      await prefs.setString('lastName', user['lastName']);
      await prefs.setString('email', user['email']);
      await prefs.setString('mobileNumber', user['mobileNumber']);
      await prefs.setBool('isVerified', user['isVerified']);
      await prefs.setBool('isLoggedIn', true);


      // Add a 2-second delay before navigation
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
              (Route<dynamic> route) => false,
        );
      });
    } else if (response.statusCode == 400) {
      final data = jsonDecode(response.body);
      _showToast(data['message']);
    } else {
      _showToast('Unable to login. Please try again later.');
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required TextEditingController controller,
    required FocusNode focusNode,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    List<TextInputFormatter>? inputFormatters,
    String? errorText,
    double height = 48, // Customizable height parameter
  }) {
    return Container(
      height: height,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          errorText: errorText,
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

  Widget _buildEmailForm() {
    return Column(
      children: [
        _buildTextField(
          hintText: 'Email ID',
          controller: emailController,
          focusNode: emailFocusNode,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 20),
        _buildTextField(
          hintText: 'Password',
          controller: passwordController,
          focusNode: passwordFocusNode,
          obscureText: true,
        ),
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
                          Container(
                            width: 99.6,
                            height: 27.25,
                            alignment: Alignment.center,
                            child: Text(
                              'LOGIN',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(16.0),
                            child: _buildEmailForm(),
                          ),
                          SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {
                                _showLoadingDialog();

                                // Add a 2-second delay before navigation
                                Future.delayed(Duration(seconds: 2), () {
                                  // Hide the loading dialog (optional)
                                  _hideLoadingDialog();

                                  // Navigate to the ForgotPasswordScreen after the delay
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        ForgotPasswordScreen()),
                                  );
                                });
                              },
                              child: Text(
                                'Forgot Password? ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
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
                              onPressed: _login,
                              child: Text(
                                'Login',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Text('OR', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 2),
                    GestureDetector(
                      onTap: () {
                        _showLoadingDialog();

                        // Add a 2-second delay before navigation
                        Future.delayed(Duration(seconds: 2), () {
                          // Hide the loading dialog (optional)
                          _hideLoadingDialog();

                          // Navigate to the SignUpScreen after the delay
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUpScreen()),
                          );
                        });
                      },
                      child: Container(
                        width: 99.6,
                        height: 27.25,
                        alignment: Alignment.center,
                        child: Text(
                          'SIGN UP',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
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
