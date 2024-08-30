import 'package:OACrugs/const.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../components/gradient_button.dart';
import '../../components/home_app_bar.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/profile_drawer.dart';
import '../notification_screen.dart';
import 'carpet_shape_size_choose.dart';

class CarpetPatternColorFillerPage extends StatefulWidget {
  final String carpetId;
  final String patternId;
  final String carpetName;
  final Uint8List patternImage;
  final int patternNumber;

  const CarpetPatternColorFillerPage({
    required this.carpetId,
    required this.patternId,
    required this.carpetName,
    required this.patternImage,
    required this.patternNumber,
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
  List<Map<String, String>> _selectionOrder = [];

  @override
  void initState() {
    super.initState();
    _fetchColors();
    _initializeSelectedColors();
    print(widget.patternId);
    print(widget.patternNumber);
  }

  Future<void> _fetchColors() async {
    final url = 'https://oac.onrender.com/api/v1/color/all-color';
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
    });
  }

  List<String> _getBoxLabels() {
    final labels = <String>[];
    for (int i = 0; i < widget.patternNumber; i++) {
      labels.add(String.fromCharCode('A'.codeUnitAt(0) + i));
    }
    return labels;
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
          patternImage: widget.patternImage,
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
                              image: MemoryImage(widget.patternImage),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                            widget.carpetName,
                            style: AppStyles.headingTextStyle,
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: boxLabels.map((box) {
                            return DragTarget<String>(
                              onAccept: (colorId) {
                                setState(() {
                                  _selectedColors[box] = colorId;
                                  _selectionOrder.add({
                                    'label': box,
                                    'colorId': colorId,
                                  });
                                });
                              },
                              builder: (context, candidateData, rejectedData) {
                                return Container(
                                  width: (MediaQuery.of(context).size.width - 80) / 4,
                                  height: (MediaQuery.of(context).size.width - 80) / 4,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppStyles.primaryTextColor, width: 1.0),
                                    color: _selectedColors[box] != null
                                        ? Color(int.parse(
                                        _colorHexCodes[_colorsid.indexOf(_selectedColors[box]!)]
                                            .replaceFirst('#', '0xFF')))
                                        : Colors.white,
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
                        return Draggable<String>(
                          data: colorId,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(int.parse(colorHex
                                  .replaceFirst('#', '0xFF'))),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          feedback: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(int.parse(colorHex
                                  .replaceFirst('#', '0xFF'))),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          childWhenDragging: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8.0),
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
