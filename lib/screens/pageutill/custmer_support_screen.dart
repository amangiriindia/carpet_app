import 'package:flutter/material.dart';

import '../../const.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/profile_drawer.dart';
import '../notification_screen.dart';

class CustomerSupportScreen extends StatelessWidget {
  const CustomerSupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headingController = TextEditingController();
    final detailsController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white, // White background
      appBar: const CustomAppBar(),
      drawer: const NotificationScreen(),
      endDrawer: const ProfileDrawer(),

      body: Stack(
        children: [
          // Background Image (Optional - adjust opacity as needed)
          Container(
            color: Colors.white,
            child: Row(
              children: [
                const SizedBox(width: 12),
                IconButton(
                  icon: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(3.14),
                    child: const Icon(Icons.login_outlined, color:AppStyles.secondaryTextColor),
                  ),
                  onPressed: () => Navigator.of(context).pop(), // Handle back press
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
          // Centered Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Card-like Container
                  Container(
                    padding: const EdgeInsets.all(24.0), // Increased padding for spacious feel
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12), // Modern rounded corners
                      // Removed boxShadow here to eliminate the shadow
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Heading
                        const SizedBox(height: 24),

                        // Heading Input
                        TextFormField(
                          controller: headingController,
                          decoration: const InputDecoration(
                            labelText: 'Heading',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Details Input (Larger)
                        TextFormField(
                          controller: detailsController,
                          maxLines: 5, // Allow multiple lines for details
                          decoration: const InputDecoration(
                            labelText: 'Details',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Submit Button (Black)
                        ElevatedButton(
                          onPressed: () {
                            // Handle submission logic here
                            // You can access the input values using headingController.text and detailsController.text
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(fontSize: 18),
                          ),
                          child: const Text('Submit'),
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
