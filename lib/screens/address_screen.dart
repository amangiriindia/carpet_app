import 'dart:convert';
import 'package:OACrugs/screens/pageutill/add_address.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import '../components/home_app_bar.dart';
import '../const.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/profile_drawer.dart';
import 'notification_screen.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedAddressId;
  List<dynamic> _addresses = [];
  late String _userId;

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
    _fetchAddresses();
  }

  Future<void> _fetchAddresses() async {
    CommonFunction.showLoadingDialog(context);
    final url = '${APIConstants.API_URL}/api/v1/address/user-address';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': _userId}),
      );
      CommonFunction.hideLoadingDialog(context);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          setState(() {
            _addresses = data['addresses'];
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to fetch addresses: ${data['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch addresses. Please try again later.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }
  }

  Future<void> _deleteAddress(String addressId) async {
    CommonFunction.showLoadingDialog(context);
    final url = '${APIConstants.API_URL}/api/v1/address/delete-address/$addressId';
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      CommonFunction.hideLoadingDialog(context);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          setState(() {
            _addresses.removeWhere((address) => address['_id'] == addressId);
          });
          Fluttertoast.showToast(
            msg: data['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete address: ${data['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete address. Please try again later.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }
  }

  void _confirmDelete(BuildContext context, String addressId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Address"),
          content: Text("Are you sure you want to delete this address?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAddress(addressId);
              },
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppStyles.backgroundPrimary,
        appBar: const CustomNormalAppBar(),
        endDrawer: const NotificationScreen(),
        drawer: const ProfileDrawer(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
                            icon: const Icon(Icons.login_outlined, color:AppStyles.secondaryTextColor),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        const SizedBox(width: 80),
                        const Icon(Icons.location_on_outlined, color:AppStyles.primaryTextColor),
                        const SizedBox(width: 4),
                        const Text(
                          'Address',
                          style: AppStyles.headingTextStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ..._addresses.map((address) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: _buildAddressCard(address),
                      );
                    }).toList(),
                    const SizedBox(height: 40),
                    
                    Center(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppStyles.primaryColorStart, AppStyles.primaryColorEnd],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AddAddressPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent, // Make button background transparent
                            shadowColor: Colors.transparent, // Remove button shadow
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(
                            Icons.add_location_alt_outlined,
                            color: Colors.white, // Set icon color to white
                            size: 16,
                          ),
                          label: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 22),
                            child: Text(
                              'Add Address',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
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
      ),
    );
  }

  Widget _buildAddressCard(Map<String, dynamic> address) {
    String _id = address['_id'];
    String name = address['name'] ?? '';
    String street = address['street'] ?? '';
    String city = address['city'] ?? '';
    String state = address['state'] ?? '';
    String postalCode = address['postalCode'] ?? '';
    String country = address['country'] ?? '';
    String phoneNumber = address['number'] ?? '';

    return Card(
      elevation: 2,
      color: AppStyles.backgroundSecondry, // Set the background color to white
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: AppStyles.primaryBodyTextStyle),
                      const SizedBox(height: 8),
                      Text(street, style: AppStyles.secondaryBodyTextStyle),
                      const SizedBox(height: 4),
                      Text('$city, $state ', style: AppStyles.secondaryBodyTextStyle),
                      const SizedBox(height: 4),
                      Text('$country  - $postalCode', style: AppStyles.secondaryBodyTextStyle),
                      const SizedBox(height: 4),
                      Text('Phone: $phoneNumber', style: AppStyles.secondaryBodyTextStyle),
                    ],
                  ),
                ),
                Radio<String>(
                  value: _id,
                  groupValue: _selectedAddressId,
                  onChanged: (value) async {
                    setState(() {
                      _selectedAddressId = value;
                    });
                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString('CurrentSelectedAddress', _id);

                    if (prefs.get('checkCarpetFlag') != null) {
                      await prefs.setBool('CurrentSelectedAddressFlag', true);
                      Navigator.of(context).pop();  // Pops the current page
                    }
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.black54),
              onPressed: () {
                _confirmDelete(context, _id);
              },
            ),
          ),
        ],
      ),
    );
  }
}
