import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CarpetPatternPage extends StatefulWidget {
  final String carpetId;
  final String carpetName;

  const CarpetPatternPage({
    required this.carpetId,
    required this.carpetName,

  });

  @override
  _CarpetPatternPageState createState() => _CarpetPatternPageState();
}

class _CarpetPatternPageState extends State<CarpetPatternPage> {
  @override
  void initState() {
    super.initState();
    // Show a toast with the carpet ID when the page loads
    Future.delayed(Duration.zero, () {
      Fluttertoast.showToast(
        msg: "Carpet ID: ${widget.carpetId}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Select Your Pattern'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.carpetName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            // Add additional content for pattern selection here
            // For example, you can add a grid or list of patterns
            Expanded(
              child: Center(
                child: Text(
                  'Pattern Selection Area',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
