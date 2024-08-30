import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../components/gradient_button.dart';
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


  Future<void> _changePassword() async {
    CommonFunction.showLoadingDialog(context);
    if (newPasswordController.text == confirmPasswordController.text) {
      final response = await http.post(
        Uri.parse('${APIConstants.API_URL}/api/v1/user/verify-otp'),
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

      // Debug print statements to check the response
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['success'] == true) {

          CommonFunction.showToast(context,'Your password has been changed successfully.');


            // Hide the loading dialog (optional)

            CommonFunction.hideLoadingDialog(context);
            // Navigate to the LoginScreen after the delay
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false,
            );


        } else {
          CommonFunction.hideLoadingDialog(context);
          CommonFunction.showToast(context,data['message'] ?? 'An error occurred');
        }
      } else if (response.statusCode == 400) {
        CommonFunction.hideLoadingDialog(context);
        CommonFunction.showToast(context,data['message'] ?? 'Invalid request. Please check your input.');
      } else {
        CommonFunction.hideLoadingDialog(context);
        CommonFunction.showToast(context,'Failed to change password. Please try again.');
      }
    } else {
      CommonFunction.hideLoadingDialog(context);
      setState(() {
        _rePasswordErrorText = 'Passwords do not match';
      });
    }
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
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 300.0, // Set your desired width here
                              child: GradientButton(
                                onPressed: _changePassword,
                                buttonText: 'Change Password',
                              ),
                            ),
                          ),
                          Container(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                width: double.infinity,
                                child: GradientButton(
                                  onPressed: _changePassword,
                                  buttonText: 'Change Password',
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
