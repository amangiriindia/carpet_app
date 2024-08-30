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
                      color: Colors.white,
                      padding: const EdgeInsets.all(20.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _saveProfileChanges,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 15.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text(
                              'Save Changes',
                              style: TextStyle(color: Colors.white),
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

  Widget _buildField(String label, TextEditingController controller, FocusNode focusNode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
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
                style: AppStyles.secondaryBodyTextStyle,
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: AppStyles.headingTextStyle,
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





class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isAppBarCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (scrollInfo is ScrollUpdateNotification) {
            setState(() {
              _isAppBarCollapsed =
                  scrollInfo.metrics.pixels > 200; // Adjust threshold as needed
            });
          }
          return true;
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 350, // Adjust as needed
              flexibleSpace: FlexibleSpaceBar(
                background: _TopPortion(),
                title: _isAppBarCollapsed
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 8),
                    const Text("My Profile"),
                  ],
                )
                    : null,
                centerTitle: false,
                collapseMode: CollapseMode.parallax,
              ),
              pinned: true,
              floating: true, // Allows the app bar to reappear on scroll up
              snap: true, // Makes the app bar snap into view
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        const Divider(),
                        _SectionHeader(text: 'Ads'),
                        _ProfileOptionItem(
                          icon: Icons.add_circle_outline,
                          text: 'Post Ad',
                          onTap: () {

                          },
                        ),
                        _ProfileOptionItem(
                          icon: Icons.shopping_bag,
                          text: 'My Ads',
                          onTap: () {

                          },
                        ),

                        const Divider(),
                        _SectionHeader(text: 'Subscription Plans'),
                        _ProfileOptionItem(
                          icon: Icons.new_releases,
                          text: 'New Plan',
                          onTap: () {

                          },
                        ),
                        _ProfileOptionItem(
                          icon: Icons.subscriptions,
                          text: 'My Subscription',
                          onTap: () {

                          },
                        ),
                        const Divider(),
                        _SectionHeader(text: 'Ads Reviews'),
                        _ProfileOptionItem(
                          icon: Icons.rate_review,
                          text: 'My Ads Reviews',
                          onTap: () {

                          },
                        ),
                        const Divider(),
                        _SectionHeader(text: 'Profile & Settings'),
                        _ProfileOptionItem(
                          icon: Icons.person,
                          text: 'Profile',
                          onTap: () {

                          },
                        ),
                        _ProfileOptionItem(
                          icon: Icons.settings,
                          text: 'Settings',
                          onTap: () {

                          },
                        ),
                        const Divider(),
                        _SectionHeader(text: 'My Chats'),
                        _ProfileOptionItem(
                          icon: Icons.request_page,
                          text: 'Rent Request',
                          onTap: () {

                          },
                        ),
                        _ProfileOptionItem(
                          icon: Icons.search,
                          text: 'Looking For',
                          onTap: () {

                          },
                        ),

                        const Divider(),
                        _ProfileOptionItem(
                          icon: Icons.logout,
                          text: 'Logout',
                          onTap: () {
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => SplashScreen(),
                          //     ),
                          //   );
                          },
                        ),

                        const SizedBox(
                            height: 100), // Add some padding at the bottom
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }
}



class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ProfileOptionItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _ProfileOptionItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

class _TopPortion extends StatelessWidget {
  const _TopPortion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppStyles.primaryColorStart,
            AppStyles.primaryColorStart,
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Center(
        child: SizedBox(
          width: 150,
          height: 150,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    'A', // Replace 'A' with dynamic text if needed
                    style: TextStyle(
                      fontSize: 80,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  child: IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => UpdateProfilePage(),
                      //   ),
                      // );
                      // Add your edit action here
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

