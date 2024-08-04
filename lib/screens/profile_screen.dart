import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController(text: '');
  final TextEditingController _emailController = TextEditingController(text: '');
  final TextEditingController _phoneNumberController = TextEditingController(text: '+91 9999999999');
  final TextEditingController _addressController = TextEditingController(text: 'Xyz, Abc, 123456');

  final String _joinedSince = '12th June 2023';

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneNumberFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneNumberFocus.dispose();
    _addressFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 10),
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
                          icon: const Icon(Icons.login_outlined, color: Colors.black54),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.mode_edit_outline_outlined, color: Colors.black54),
                      const SizedBox(width: 4),
                      const Text(
                        'Edit Profile',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildField('Full Name', _nameController, _nameFocus),
                  _buildField('Email', _emailController, _emailFocus),
                  _buildField('Phone No.', _phoneNumberController, _phoneNumberFocus),
                  _buildField('Address', _addressController, _addressFocus),
                  _buildStaticField('Joined Since', _joinedSince),
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _saveProfileChanges();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 22),
                        child: Text(
                          'Save Changes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
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
                decoration: InputDecoration(
                  labelText: label,
                  border: const UnderlineInputBorder(),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.mode_edit_outline_outlined),
              onPressed: () => FocusScope.of(context).requestFocus(focusNode),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaticField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextFormField(
        initialValue: value,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: const UnderlineInputBorder(),
        ),
      ),
    );
  }

  Future<void> _saveProfileChanges() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save the updated profile information
    await prefs.setString('full_name', _nameController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('phone_number', _phoneNumberController.text);
    await prefs.setString('address', _addressController.text);

    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile changes saved successfully!')),
    );
  }
}
