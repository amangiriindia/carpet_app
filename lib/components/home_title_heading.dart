import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 35.0),
            child: Image.asset(
              'assets/image/home_heading_icon.png',
              width: 10,
              height: 15,
            ),
          ),
          const SizedBox(width: 0.0),

          Stack(
            children: [
              // Left border
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 3.0, // Adjust the width of the left border
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0), // Add border radius
                    gradient: LinearGradient(
                      colors: [Color(0xFF991F35), Color(0xFF330A12)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              // Bottom border with adjusted width and border radius
              Positioned(
                bottom: 0, // Align to the bottom of the Text
                child: Container(
                  height: 3.0, // Decreased line height
                  width: MediaQuery.of(context).size.width / 4, // Make it cover 1/4th of the screen width
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0), // Add border radius
                    gradient: LinearGradient(
                      colors: [Color(0xFF991F35), Color(0xFF330A12)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 6.0, bottom: 4.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins', // Font family
                    fontSize: 18.37, // Font size
                    fontWeight: FontWeight.w900, // Font weight
                    height: 21.56 / 14.37, // Line height
                    color: Color(0xFF292929), // Text color
                  ),
                ),
              ),


            ],
          ),
        ],
      ),
    );
  }
}
