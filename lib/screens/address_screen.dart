import 'dart:convert';
import 'package:OACrugs/screens/pageutill/add_address.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();

  // Current selected address
  String? _selectedAddressId;

  // Address list from API
  List<dynamic> _addresses = [];

  late String _userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId') ?? '66c4aa81c3e37d9ff6c4be6c'; // Fallback user ID if not found
    });
    _fetchAddresses();
  }

  Future<void> _fetchAddresses() async {
    final url = 'https://oac.onrender.com/api/v1/address/user-address';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': _userId}),
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          setState(() {
            _addresses = data['addresses'];
          });
        } else if (data['addresses'].isEmpty) {
          // No addresses found
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No addresses found for this user.')),
          );
        } else {
          // Unexpected success state
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to fetch addresses: ${data['message']}')),
          );
        }
      } else if (response.statusCode == 404) {
        // No addresses found for this user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No addresses found for this user.')),
        );
      } else if (response.statusCode == 500) {
        // Server error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error. Please try again later.')),
        );
      } else {
        // Handle other response status codes
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch addresses. Please try again later.')),
        );
      }
    } catch (error) {
      // Handle any other errors such as network issues
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
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
                        const SizedBox(width: 80),
                        const Icon(Icons.location_on_outlined, color: Colors.black54),
                        const SizedBox(width: 4),
                        const Text(
                          'Address',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  AddAddressPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.add, color: Colors.white, size: 16),
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
                      Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(street, style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 4),
                      Text('$city, $state $postalCode', style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(country, style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 4),
                      Text('Phone: $phoneNumber', style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                Radio<String>(
                  value: _id,
                  groupValue: _selectedAddressId,
                  onChanged: (value) {
                    setState(() {
                      _selectedAddressId = value;
                    });
                    Fluttertoast.showToast(
                      msg: "Selected Address ID: $_id",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  },
                  activeColor: Colors.black,
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.black54),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  AddAddressPage()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.black54),
                  onPressed: () {
                    // Add your delete functionality here
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
