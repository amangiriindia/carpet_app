import 'package:OACrugs/constant/const.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../components/gradient_button.dart';
import '../../components/gradient_icon_button.dart';
import '../../components/home_app_bar.dart';
import '../base/profile_drawer.dart';
import '../base/notification_screen.dart';
import 'carpet_shape_size_choose.dart';

class CarpetPatternColorFillerPage extends StatefulWidget {
  final String carpetId;
  final String patternId;
  final String carpetName;
  final Uint8List patternImage;
  final Uint8List patternLayoutImage;
  final int patternNumber;

  const CarpetPatternColorFillerPage({
    required this.carpetId,
    required this.patternId,
    required this.carpetName,
    required this.patternImage,
    required this.patternNumber,
    required this.patternLayoutImage,
  });

  @override
  _CarpetPatternColorFillerPageState createState() =>
      _CarpetPatternColorFillerPageState();
}

class _CarpetPatternColorFillerPageState
    extends State<CarpetPatternColorFillerPage> {
  List<String> _colors = [];
  List<String> _colorHexCodes = [];
  List<String> _colorsid = [];
  bool _isLoadingColors = true;
  String _colorErrorMessage = '';
  Map<String, String?> _selectedColors = {};
  Map<String, String?> _selectedColorsTargetTemp = {};
  List<Map<String, String>> _selectionOrder = [];
  List<String> afterResetFillColorsInBox = [];
  late Uint8List screenShowImage =widget.patternImage;
  String targetColor = ''; // To store the target color on which user drops the color
  Uint8List? modifiedImage;
  bool _isResetFlag =false;
  Map<String,String>color_map ={};


  @override
  void initState() {
    super.initState();
    _fetchColors();
    fetchColorsFromAPI();
    _initializeSelectedColors();
    print(widget.patternId);
    print(widget.patternNumber);
  }

  Future<void> _fetchColors() async {
    final url = '${APIConstants.API_URL}api/v1/color/all-color';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final colors = data['allColor'] as List;

        setState(() {
          _colors = colors.map((color) => color['name'] as String).toList();
          _colorHexCodes = colors.map((color) => color['name'] as String).toList();
          _colorsid = colors.map((color) => color['_id'] as String).toList();
          _isLoadingColors = false;
        });
      } else {
        setState(() {
          _colorErrorMessage = 'Failed to load colors';
          _isLoadingColors = false;
        });
      }
    } catch (e) {
      setState(() {
        _colorErrorMessage = 'Error: $e';
        _isLoadingColors = false;
      });
    }
  }

  void _initializeSelectedColors() {
    final boxLabels = _getBoxLabels();
    setState(() {
      _selectedColors = {for (var label in boxLabels) label: null};
      _selectedColorsTargetTemp =  {for (var label in boxLabels) label: null};
    });
  }

  List<String> _getBoxLabels() {
    final labels = <String>[];
    for (int i = 0; i < widget.patternNumber; i++) {
      labels.add(String.fromCharCode('A'.codeUnitAt(0) + i));
    }
    return labels;
  }

  Future<void> _onResetPressed() async {
    CommonFunction.showLoadingDialog(context);
    print("Reset icon clicked");
    _isResetFlag =true;
    // Get the box labels and number of boxes
    final boxLabels = _getBoxLabels();
    final numBoxes = boxLabels.length;

    // Ensure the number of colors matches the number of boxes
    assert(afterResetFillColorsInBox.length == numBoxes, "The number of colors should match the number of boxes");
    await Future.delayed(Duration(seconds: 1)); // Adding 1-second delay
    setState(() {
      _selectedColors.clear(); // Clear previous selections

      // Loop through and assign colors to each box from the afterResetFillColorsInBox list
      for (int i = 0; i < numBoxes; i++) {
        _selectedColors[boxLabels[i]] = "#ffffff";
        _selectedColorsTargetTemp[boxLabels[i]] = afterResetFillColorsInBox[i];
        print(afterResetFillColorsInBox[i]);
      }

      // Update the selection order (optional)
      _selectionOrder = _selectedColors.entries.map((entry) {
        final colorIndex = _colors.indexOf(entry.value ?? '');
        return {
          'label': entry.key,
          'colorId': colorIndex != -1 ? _colorsid[colorIndex] : '',
        };
      }).toList();


      // Update the screenShowImage
      screenShowImage = widget.patternImage;
    });

    print("Unique colors after reset: $afterResetFillColorsInBox");
    CommonFunction.hideLoadingDialog(context);
  }




  Future<void> replaceColorAPI(String targetColor, String replacementColor) async {

     CommonFunction.showLoadingDialog(context);
    print("Call replace color api");
    try {

      if (_isResetFlag) {
        // Reset all values in the color_map to '#ffffff'
        color_map.forEach((key, value) {
          color_map[key] = '#ffffff';
        });

        // Set the flag to false after resetting
        _isResetFlag = false;
      }

      // Create a multipart request for the replace-color API
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${APIConstants.LOCALHOST}replace-color'),
      );

      // Add the modified image and color details
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        widget.patternLayoutImage,
        filename: 'modifiedImage.png', // Dynamically send modified image
      ));
      color_map[targetColor] = replacementColor;

      print(color_map);
      // Convert the color map to a JSON string
      String colorMapJson = jsonEncode(color_map);

      // Add the color map JSON as a field in the request
      request.fields['color_map'] = colorMapJson;

      // Send the request and capture the response
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        CommonFunction.hideLoadingDialog(context);
        final data = json.decode(response.body);

        // Check if 'modified_image' key exists and is not null
        if (data.containsKey('modified_image') && data['modified_image'] != null) {
          String base64Image = data['modified_image'];

          // Decode the base64 image and store it as the new modified image
          setState(() {
            modifiedImage = base64Decode(base64Image); // Store the updated image
            screenShowImage =modifiedImage!;
          });
        } else {
          print('API Error: Missing or null "modified_image" key');
        }
      } else {
        CommonFunction.hideLoadingDialog(context);
        print('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }


  Future<void> fetchColorsFromAPI() async {
    try {
      // Load the image from assets initially
      print("Call color list API");
      final Uint8List imageBytes = widget.patternLayoutImage;

      // Create a multipart request to fetch unique colors
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${APIConstants.LOCALHOST}get-unique-colors'),
      );

      // Add the image as a file field named 'image'
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'patternLayoutImage.png',
      ));

      // Send the request and capture the response
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print(response.statusCode);
      print(response.body);

      // Check the status code and decode the body if successful
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Create a map with unique colors from the API as keys and white hex code as values
        setState(() {
          afterResetFillColorsInBox = List<String>.from(data['unique_colors']);
          color_map = {
            for (var color in afterResetFillColorsInBox) color: '#ffffff'
          };
          _onResetPressed();
        });

        print('Color Map: $color_map'); // For debugging purposes

      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }


  void _onContinuePressed() {
    if (_selectedColors.values.any((color) => color == null)) {
      CommonFunction.showToast(context, "Please choose a color for all boxes");
      return;
    } else {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CarpetShapeSizePage(
          carpetId: widget.carpetId,
          patternId: widget.patternId,
          carpetName: widget.carpetName,
          patternImage: screenShowImage,
          hexCodes: _selectionOrder.map((selection) => selection['colorId']!).toList(),
        ),
      ));
    }
  }



  @override
  Widget build(BuildContext context) {
    final boxLabels = _getBoxLabels();

    return Scaffold(
      backgroundColor: AppStyles.backgroundPrimary,
      appBar: const CustomNormalAppBar(),
      endDrawer: const NotificationScreen(),
      drawer: const ProfileDrawer(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(3.14),
                  child: IconButton(
                    icon: const Icon(Icons.login_outlined,  color:AppStyles.secondaryTextColor),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 80),
                const Icon(Icons.color_lens, color: AppStyles.primaryTextColor),
                const SizedBox(width: 4),
                const Text(
                  'Choose Color',
                  style: AppStyles.headingTextStyle,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 270,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                              image: MemoryImage(screenShowImage),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text(
                                widget.carpetName,
                                style: AppStyles.headingTextStyle,
                              ),
                            ),
                            GradientIconButton(
                              onPressed: _onResetPressed,
                              child: const Icon(Icons.refresh),
                              gradientColors: [AppStyles.primaryColorStart, AppStyles.primaryColorEnd],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: boxLabels.map((box) {
                            return DragTarget<String>(
                              onAccept: (replacementColor) {
                                setState(() {
                                  final targetColor =  _selectedColorsTargetTemp[box]; // The current color in the box before replacement
                                  print(box) ;
                                  print(_selectedColors);
                                  print(_selectedColorsTargetTemp);
                                  if (targetColor != null && targetColor != replacementColor) {
                                    // Call the replaceColorAPI to update the image based on the target and replacement colors
                                    replaceColorAPI(targetColor, replacementColor);
                                  }

                                  // Update the box with the new selected color
                                  _selectedColors[box] = replacementColor;

                                  // Add to the selection order for tracking
                                  _selectionOrder.add({
                                    'label': box,
                                    'colorId': replacementColor,
                                  });
                                });
                              },
                              builder: (context, candidateData, rejectedData) {
                                final hexColor = _selectedColors[box];
                                final color = hexColor != null
                                    ? Color(int.parse(hexColor.replaceFirst('#', '0xFF')))
                                    : Colors.white;

                                return Container(
                                  width: (MediaQuery.of(context).size.width - 80) / 4,
                                  height: (MediaQuery.of(context).size.width - 80) / 4,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppStyles.primaryTextColor, width: 1.0),
                                    color: color,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      box,
                                      style: AppStyles.primaryBodyTextStyle,
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),



                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                  _isLoadingColors
                      ? CommonFunction.showLoadingIndicator()
                      : _colorErrorMessage.isNotEmpty
                      ? Center(child: Text(_colorErrorMessage))
                      : SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: _colors.length,
                      itemBuilder: (context, index) {
                        final colorHex = _colorHexCodes[index];
                        final colorId = _colorsid[index];
                        return  Draggable<String>(
                          data: colorHex, // Drag the hex color string
                          feedback: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(int.parse(colorHex.replaceFirst('#', '0xFF'))), // Parse hex to color
                              shape: BoxShape.circle,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(int.parse(colorHex.replaceFirst('#', '0xFF'))),
                              shape: BoxShape.circle,
                            ),
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
                          onPressed: _onContinuePressed,
                          buttonText: 'Continue',
                        ),
                      ),
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
