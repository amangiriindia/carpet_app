// import 'package:flutter/material.dart';
// import 'package:image/image.dart' as img;
// import 'dart:typed_data';
// import 'package:flutter/services.dart' show rootBundle;
//
// class ColorExtractorScreen extends StatefulWidget {
//   @override
//   _ColorExtractorScreenState createState() => _ColorExtractorScreenState();
// }
//
// class _ColorExtractorScreenState extends State<ColorExtractorScreen> {
//   List<Color> colors = [];
//   List<String> colorNames = [];
//   img.Image? image;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadImage();
//   }
//
//   Future<void> _loadImage() async {
//     try {
//       // Load image from assets
//       final ByteData data = await rootBundle.load('assets/login/welcome.png');
//       final Uint8List bytes = data.buffer.asUint8List();
//       final img.Image? decodedImage = img.decodeImage(bytes);
//
//       if (decodedImage != null) {
//         setState(() {
//           image = decodedImage;
//           _extractColors();
//         });
//       } else {
//         print('Failed to decode image');
//       }
//     } catch (e) {
//       print('Error loading image: $e');
//     }
//   }
//
//   void _extractColors() {
//     if (image == null) return;
//
//     final colorSet = <Color>{};
//     for (int y = 0; y < image!.height; y++) {
//       for (int x = 0; x < image!.width; x++) {
//         final int pixelValue = image!.getPixel(x, y); // Get pixel as an int
//         final int alpha = (pixelValue >> 24) & 0xFF;
//         final int red = (pixelValue >> 16) & 0xFF;
//         final int green = (pixelValue >> 8) & 0xFF;
//         final int blue = pixelValue & 0xFF;
//         final color = Color.fromARGB(alpha, red, green, blue);
//         colorSet.add(color);
//       }
//     }
//     setState(() {
//       colors = colorSet.toList();
//       colorNames = colors.map((color) => _getColorName(color)).toList();
//     });
//   }
//
//   String _getColorName(Color color) {
//     final hexColor = '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
//     final colorMap = {
//       '#FFFFFFFF': 'White',
//       '#FFFF0000': 'Red',
//       '#FF00FF00': 'Green',
//       '#FF0000FF': 'Blue',
//       '#FFFFFF00': 'Yellow',
//       '#FF000000': 'Black',
//       '#FFFFA500': 'Orange',
//       '#FF800080': 'Purple',
//       // Add more color mappings here
//     };
//     return colorMap[hexColor] ?? 'Unknown';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Color Extractor'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Center(
//               child: image == null
//                   ? CircularProgressIndicator()
//                   : Image.memory(Uint8List.fromList(img.encodePng(image!))),
//             ),
//           ),
//           SizedBox(height: 20),
//           Expanded(
//             child: colors.isEmpty
//                 ? Center(child: Text('No colors extracted'))
//                 : GridView.builder(
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 4,
//                 mainAxisSpacing: 4,
//               ),
//               itemCount: colors.length,
//               itemBuilder: (context, index) {
//                 final color = colors[index];
//                 final colorName = colorNames[index];
//                 return Container(
//                   color: color,
//                   child: Center(
//                     child: Text(
//                       colorName,
//                       style: TextStyle(color: Colors.black),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   margin: EdgeInsets.all(2),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
