import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../components/gradient_button.dart';
import '../../components/home_app_bar.dart';
import '../../const.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/profile_drawer.dart';
import '../notification_screen.dart';

class CustomerSupportScreen extends StatefulWidget {


  const CustomerSupportScreen({Key? key}) : super(key: key);

  @override
  _CustomerSupportScreenState createState() => _CustomerSupportScreenState();
}

class _CustomerSupportScreenState extends State<CustomerSupportScreen> {
  late String _userId ='';
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
  }

  final TextEditingController headingController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  bool isLoading = false;

  Future<void> _submitForm() async {
    CommonFunction.showLoadingDialog(context);

    final url = Uri.parse('https://oac.onrender.com/api/v1/contact/create-contact');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': _userId,
        'subject': headingController.text,
        'description': detailsController.text,
      }),
    );

    final responseData = json.decode(response.body);

    if ( responseData['success'] == true) {
     CommonFunction.hideLoadingDialog(context);
      // Navigate or show success UI
      CommonFunction.showToast(context, 'Your message has been received. Our team will reach out soon.');
    } else {
      // Handle error response
       CommonFunction.hideLoadingDialog(context);
            print('Failed to create contact: ${responseData['message']}');
    }


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomNormalAppBar(),
      endDrawer: const NotificationScreen(),
      drawer: const ProfileDrawer(),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: Row(
              children: [
                const SizedBox(width: 12),
                IconButton(
                  icon: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(3.14),
                    child: const Icon(Icons.login_outlined, color: AppStyles.secondaryTextColor),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 80),
                const Icon(Icons.support_agent, color: AppStyles.primaryTextColor),
                const SizedBox(width: 4),
                const Text(
                  'Support Center',
                  style: AppStyles.headingTextStyle,
                ),
              ],
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: headingController,
                          decoration: const InputDecoration(
                            labelText: 'Heading',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: detailsController,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            labelText: 'Details',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 24),
                        isLoading
                            ? CommonFunction.showLoadingIndicator()
                            :
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(16.0),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              width: double.infinity,
                              child: GradientButton(
                                onPressed: _submitForm,
                                buttonText: 'Submit',
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
    );
  }
}
