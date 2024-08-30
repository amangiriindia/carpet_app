import 'package:flutter/material.dart';

import '../const.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  const GradientButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppStyles.primaryColorStart, AppStyles.primaryColorEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          backgroundColor: Colors.transparent, // Make button background transparent
          shadowColor: Colors.transparent, // Remove button shadow
        ),
        child: Text(
          buttonText,
          style: AppStyles.secondaryBodyTextStyle.copyWith(
            color: Colors.white, // Overwrite the color with white
          ),
        ),
      ),
    );
  }
}
