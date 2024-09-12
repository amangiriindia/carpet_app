import 'package:OACrugs/constant/const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

import '../../components/gradient_button.dart';
import '../../components/home_app_bar.dart';
import '../base/profile_drawer.dart';
import '../base/notification_screen.dart';
import 'carpet_pattern_color_filler.dart';

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
  List<Pattern> _patterns = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String? _selectedPatternId;

  @override
  void initState() {
    super.initState();
    _fetchPatterns();
  }

  Future<void> _fetchPatterns() async {
    final url = 'https://oac.onrender.com/api/v1/carpet/single-carpet/${widget.carpetId}';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final collections = data['getSingleCarpet']['collections'] as List;

        setState(() {
          _patterns = collections.map((item) {
            return Pattern(
              patternId: item['_id'].toString(),
              patternNumber: item['patternNumber'].toString(),
              image: Uint8List.fromList(List<int>.from(item['photo']['data']['data'] as List<dynamic>)),
            );
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load patterns';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  void _navigateToColorFillerPage() {
    if (_selectedPatternId == null) {
      CommonFunction.showToast(context, "Please select a pattern");
      return;
    }

    final selectedPattern = _patterns.firstWhere((pattern) => pattern.patternId == _selectedPatternId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarpetPatternColorFillerPage(
          carpetId: widget.carpetId,
          patternId: selectedPattern.patternId,
          carpetName: widget.carpetName,
          patternImage: selectedPattern.image,
          patternNumber: int.parse(selectedPattern.patternNumber),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundPrimary, // Set the background color here
      appBar: const CustomNormalAppBar(), // Add an AppBar if it's missing
      endDrawer: const NotificationScreen(),
      drawer: const ProfileDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
                  const Icon(Icons.grid_view, color:AppStyles.primaryTextColor),
                  const SizedBox(width: 4),
                  const Text(
                    'Choose Pattern',
                    style: AppStyles.headingTextStyle,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? CommonFunction.showLoadingIndicator()
                  : _errorMessage.isNotEmpty
                  ? Center(child: Text(_errorMessage))
                  : Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: _patterns.length,
                  itemBuilder: (context, index) {
                    final pattern = _patterns[index];
                    final isSelected = _selectedPatternId == pattern.patternId;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPatternId = pattern.patternId;
                        });
                      },
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                image: MemoryImage(pattern.image),
                                fit: BoxFit.contain,
                              ),
                              border: isSelected
                                  ? Border.all(color: AppStyles.primaryColorStart, width: 1.0)
                                  : null,
                            ),
                          ),
                          if (isSelected)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: AppStyles.secondaryTextColorAlt.withOpacity(0.5),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.check,
                                  color: AppStyles.primaryColorStart,
                                  size: 40,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    child: GradientButton(
                      onPressed: _navigateToColorFillerPage,
                      buttonText: 'Continue',
                    ),
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

class Pattern {
  final String patternId;
  final String patternNumber;
  final Uint8List image;

  Pattern({
    required this.patternId,
    required this.patternNumber,
    required this.image,
  });
}
