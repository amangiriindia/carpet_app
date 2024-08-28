import 'package:flutter/material.dart';


class ButtonCustom extends StatelessWidget {
  final VoidCallback callback;
  final String title;
  final LinearGradient gradient;

  const ButtonCustom({
    super.key,
    required this.callback,
    required this.title,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: callback, // Callback for the button
      child: Ink(
        width: 100,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: gradient,
        ),
        child:  Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class GradientFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color startColor;
  final Color endColor;

  const GradientFloatingActionButton({
    required this.onPressed,
    required this.icon,
    required this.startColor,
    required this.endColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [startColor, endColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        shape: BoxShape.circle,
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        child: Icon(
          icon,
          color: Colors.white, // Set icon color to white
        ),
        backgroundColor: Colors.transparent, // Transparent to show gradient
        elevation: 0, // Remove shadow
      ),
    );
  }
}





