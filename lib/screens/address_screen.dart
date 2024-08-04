import 'package:flutter/material.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController billingAddress = TextEditingController(text: 'John Doe resides at 123 Main Street, Apt 4B, Springfield, Illinois, 62701, United States. He can be reached at +1 555-123-4567');
  final TextEditingController shippingAddress = TextEditingController(text: 'Jane Doe\'s shipping address is 789 Elm Street, Suite 10, Springfield, Illinois, 62702, United States. She can be contacted at +1 555-987-6543');

  // Define FocusNodes for each TextFormField
  final FocusNode billingAddressFocus = FocusNode();
  final FocusNode shippingAddressFocus = FocusNode();

  @override
  void dispose() {
    billingAddress.dispose();
    shippingAddress.dispose();
    billingAddressFocus.dispose();
    shippingAddressFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside of text fields
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
                    _buildEditableField(
                      'Billing Address',
                      billingAddress,
                      billingAddressFocus,
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                    ),
                    const SizedBox(height: 20),
                    _buildEditableField(
                      'Shipping Address',
                      shippingAddress,
                      shippingAddressFocus,
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            // Save the updated profile information
                            // You can add your code to save the information
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // Set to 0 for square edges
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
      ),
    );
  }

  Widget _buildEditableField(
      String label,
      TextEditingController controller,
      FocusNode focusNode, {
        EdgeInsets padding = EdgeInsets.zero,
        double spacing = 1.0, // Smaller spacing parameter
      }) {
    return Padding(
      padding: padding,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: focusNode.hasFocus ? Theme.of(context).primaryColor : Colors.grey,
              width: 1.0,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: spacing), // Adjust spacing here
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      maxLines: null,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(fontSize: 14), // Adjust the font size here
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.mode_edit_outline_outlined),
                    onPressed: () {
                      FocusScope.of(context).requestFocus(focusNode);
                    },
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
