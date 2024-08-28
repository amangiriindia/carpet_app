import 'package:OACrugs/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../components/button.dart';
import '../../const.dart';

class OnBoardingScreen extends StatefulWidget {
  final VoidCallback onDone;
  const OnBoardingScreen({super.key, required this.onDone});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  bool showGetStartedButton = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      // Check if the current page is the last one (index 5 for the 6th page)
      if (_controller.page?.round() == 5) {
        setState(() => showGetStartedButton = true);
      } else {
        setState(() => showGetStartedButton = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundPrimary,
      body: Stack(children: [
        PageView(
          controller: _controller,
          children: [
            _buildOnboardingPage(
              'Welcome to OACrugs!',
              'https://lottie.host/f08f17ff-369f-45d3-bae6-eb4710d6a775/tQn3wwJR03.json',
              'Your one-stop shop for premium carpets.',
            ),
            _buildOnboardingPage(
              'Your Dream Carpet Awaits',
              'https://lottie.host/ae885a7f-3902-4275-9f7d-e794f3c89f99/NCje6C18ig.json',
              'Browse, discover, and bring home the perfect rug.',
            ),
            _buildOnboardingPage(
              'Design Your Own',
              'https://lottie.host/9267ddea-0dd8-4fb3-9d72-9bd1931324d7/QYZZqFzVL7.json',
              'Unleash your creativity and personalize your carpet.',
            ),
            _buildOnboardingPage(
              'Tailored to Fit',
              'https://lottie.host/5ea3b320-0e85-442f-93dd-26054eb83848/YQtVFfhv4d.json',
              'Get the perfect size and shape for your space.',
            ),
            _buildOnboardingPage(
              'Checkout Made Easy',
              'https://lottie.host/1f6998e2-8458-4fdd-96ec-4862bdbe58d9/N6x3FGAJJP.json',
              'Safe, secure, and hassle-free payments.',
            ),
            _buildOnboardingPage(
              'Delivered to Your Door',
              'https://lottie.host/aaf74416-653b-4acb-84bd-c02f596ca913/AS73aqE3Mo.json',
              'Fast and reliable shipping right to your doorstep.',
            ),
          ],
        ),

        if (showGetStartedButton)
          Align(
            alignment: const Alignment(0, 0.75),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: AnimatedOpacity(
                opacity: showGetStartedButton ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: ButtonCustom(
                  callback: () {
                    widget.onDone();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                    );
                  },
                  title: "Get Started",
                  gradient: const LinearGradient(colors: [
                    AppStyles.primaryColorStart,
                    AppStyles.primaryColorEnd,
                  ]),
                ),
              ),
            ),
          ),

        // dot indicator
        Container(
          alignment: const Alignment(0, 0.9),
          child: SmoothPageIndicator(
            controller: _controller,
            count: 6,  // Update the count to 6
            effect: const JumpingDotEffect(activeDotColor: AppStyles.primaryColorStart),
          ),
        ),
      ]),
    );
  }

  Widget _buildOnboardingPage(String title, String imagePath, String description) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.network(imagePath, height: 400, width: 800, fit: BoxFit.contain),
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text(description, style: TextStyle(fontSize: 16, color: Colors.grey[700]), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
