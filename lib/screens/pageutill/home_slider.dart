import 'package:flutter/material.dart';

class SliderSection extends StatelessWidget {
  const SliderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Slider Frame
        Container(
          width: 341.0,
          height: 186.0,
          margin: const EdgeInsets.only(top: 112.0, left: 25.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4.0),
              topRight: Radius.circular(0.0),
              bottomLeft: Radius.circular(0.0),
              bottomRight: Radius.circular(0.0),
            ),
            color: Colors.transparent,
          ),
          child: PageView(
            children: [
              Image.asset(
                'assets/login/welcome.png', // Replace with actual image path
                fit: BoxFit.cover,
              ),
              Image.asset(
                'assets/login/welcome.png', // Replace with actual image path
                fit: BoxFit.cover,
              ),
              Image.asset(
                'assets/login/welcome.png', // Replace with actual image path
                fit: BoxFit.cover,
              ),
              // Add more images as needed
            ],
          ),
        ),
        // Scroll Icon
        Positioned(
          top: 177.0,
          left: 119.0,
          child: Container(
            width: 104.0,
            height: 2.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(29.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
