import 'package:flutter/material.dart';

class PlacementGuideItem extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const PlacementGuideItem({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Stack(
        children: [
          // Black background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          // Image at top right corner with opacity
          Positioned(
            top: 0,
            right: 0,
            child: Opacity(
              opacity: 0.95,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8.0),
                ),
                child: Image.asset(
                  imagePath,
                  width: 100.0,
                  height: 100.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Text overlay
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(top: 120, left: 24, right: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFFFFFFFF),
                        Color(0xFFEBEBEB),
                        Color(0xFF999999)
                      ],
                      stops: [0.164, 0.4408, 0.15751],
                      transform: GradientRotation(125.46 * (3.14159265359 / 180)),
                    ).createShader(bounds),
                    child: Text(
                      title,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20.49,
                        fontWeight: FontWeight.bold,
                        height: 18.74 / 12.49,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Tips:\n',
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 12.0,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 9.0 / 6.0,
                              ),
                            ),
                            TextSpan(
                              text: '• Full Coverage: The carpet should extend beyond the dining table by at least 24 inches on all sides to allow chairs to move in and out easily.\n\n',
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 10.0,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 12.0 / 8.0,
                              ),
                            ),
                            TextSpan(
                              text: '• Durability: Choose a durable, easy-to-clean material to handle spills and heavy foot traffic.\n\n',
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 10.0,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 9.0 / 6.0,
                              ),
                            ),
                            TextSpan(
                              text: '• Shape Harmony: Match the carpet shape to your table shape (rectangular for long tables, round for circular tables).\n\n',
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 10.0,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 9.0 / 6.0,
                              ),
                            ),
                            TextSpan(
                              text: '• Full Coverage: The carpet should extend beyond the dining table by at least 24 inches on all sides to allow chairs to move in and out easily.\n\n',
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 10.0,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 12.0 / 8.0,
                              ),
                            ),
                            TextSpan(
                              text: '• Full Coverage: The carpet should extend beyond the dining table by at least 24 inches on all sides to allow chairs to move in and out easily.\n\n',
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 10.0,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 12.0 / 8.0,
                              ),
                            ),
                          ],
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

class PlacementGuideList extends StatefulWidget {
  const PlacementGuideList({super.key});

  @override
  _PlacementGuideListState createState() => _PlacementGuideListState();
}

class _PlacementGuideListState extends State<PlacementGuideList> {
  final ScrollController _scrollController = ScrollController();

  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 200.0, // Adjust this value as needed
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 200.0, // Adjust this value as needed
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = const [
      PlacementGuideItem(
        title: 'Living Room',
        description: 'A cozy and stylish living room with modern amenities.',
        imagePath: 'assets/guide/clock.png',
      ),
      PlacementGuideItem(
        title: 'Dining Room',
        description: 'An elegant dining room perfect for family meals.',
        imagePath: 'assets/guide/dinner.png',
      ),
      PlacementGuideItem(
        title: 'Bedroom',
        description: 'A serene bedroom designed for relaxation.',
        imagePath: 'assets/guide/bed.png',
      ),
    ];

    return Stack(
      children: [
        Container(
          height: 550.0,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 16.0 : 0.0,
                  right: index == items.length - 1 ? 16.0 : 0.0,
                ),
                child: items[index],
              );
            },
          ),
        ),
        Positioned(
          left: 2,
          top: 275.0, // Adjust this value to place the button in the middle vertically
          child: GestureDetector(
            onTap: _scrollLeft,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient( // Apply the gradient to the border
                  colors: [Color(0xFF991F35), Color(0xFF330A12)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.5),
                child: ShaderMask(  // Use ShaderMask to apply the gradient to the icon
                  shaderCallback: (bounds) => LinearGradient(
                    colors: const [Color(0xFF991F35), Color(0xFF330A12)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).createShader(bounds),
                  child: const Icon(Icons.arrow_back),
                ),
              ),
            ),
          ),

        ),
        Positioned(
          right: 2,
          top: 275.0, // Adjust this value to place the button in the middle vertically
            child: GestureDetector(
              onTap: _scrollRight,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient( // Apply the gradient to the border
                    colors: [Color(0xFF991F35), Color(0xFF330A12)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.5),
                  child: ShaderMask(  // Use ShaderMask to apply the gradient to the icon
                    shaderCallback: (bounds) => LinearGradient(
                      colors: const [Color(0xFF991F35), Color(0xFF330A12)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds),
                    child: const Icon(Icons.arrow_forward),
                  ),
                ),
              ),
            ),

        ),
      ],
    );
  }
}
