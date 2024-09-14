import 'package:flutter/material.dart';

class GradientIconButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final List<Color> gradientColors;

  const GradientIconButton({
    Key? key,
    required this.onPressed,
    required this.child,
    required this.gradientColors,
  }) : super(key: key);

  @override
  _GradientIconButtonState createState() => _GradientIconButtonState();
}

class _GradientIconButtonState extends State<GradientIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
      }
    });
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * 3.14159).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.gradientColors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: ElevatedButton(
        onPressed: () {
          widget.onPressed();
          _animationController.forward(from: 0);
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        child: RotationTransition( // Corrected the missing closing parenthesis here
          turns: _rotationAnimation,
          child: IconTheme(
            data: const IconThemeData(color: Colors.white),
            child: widget.child,
          ),
        ), // Closing parenthesis for RotationTransition
      ), // Closing parenthesis for ElevatedButton
    ); // Closing parenthesis for Container
  }
}