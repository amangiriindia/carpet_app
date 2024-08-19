import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _addressController;

  final String _joinedSince = '12th June 2023';

  late String _userId; // Variable to store userId

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneNumberFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _userId = prefs.getString('userId') ?? '';

      _nameController = TextEditingController(
          text: '${prefs.getString('firstName') ?? ''} ${prefs.getString('lastName') ?? ''}'
      );
      _emailController = TextEditingController(text: prefs.getString('email') ?? '');
      _phoneNumberController = TextEditingController(text: prefs.getString('mobileNumber') ?? '');
      _addressController = TextEditingController(text: prefs.getString('address') ?? '');
    });
  }

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
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            _saveProfileChanges();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero, // Remove default padding
                          elevation: 0, // Remove shadow
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.74),
                          ),
                          backgroundColor: Colors.transparent, // Make button background transparent
                        ),
                        child: Center(
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
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  color: const Color(0xFF3D3636),
                ),
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14.66,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF292929),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                ),
              ),
            ),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: const Color(0xFF1D1D1D),
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

    // Use the existing userId and update profile information
    await prefs.setString('userId', _userId); // Ensure the userId is saved
    await prefs.setString('full_name', _nameController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('phone_number', _phoneNumberController.text);
    await prefs.setString('address', _addressController.text);

    // Optionally: If you have an API or server to update this data, you could call it here.

    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile changes saved successfully!')),
    );
  }
}
