import 'package:flutter/material.dart';

class RecentProjectsSection extends StatefulWidget {
  final List<RecentProjectItemWithImage> projects;

  const RecentProjectsSection({required this.projects});

  @override
  _RecentProjectsSectionState createState() => _RecentProjectsSectionState();
}

class _RecentProjectsSectionState extends State<RecentProjectsSection> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int nextPage = _pageController.page?.round() ?? 0;
      if (_currentPage != nextPage) {
        setState(() {
          _currentPage = nextPage;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0, // Adjust height as needed
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            children: widget.projects,
          ),
          Positioned(
            bottom: 15.0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8, // Adjusted width based on screen size
              height: 1.0, // Height of the slider
              decoration: BoxDecoration(
                color: Colors.grey[300], // Greyish color
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                children: List.generate(
                  widget.projects.length,
                      (index) => Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: _currentPage == index ? Colors.black : Colors.transparent, // Black slider when active
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecentProjectItemWithImage extends StatelessWidget {
  final String imagePath;
  final String projectName;
  final String projectDescription;

  const RecentProjectItemWithImage({
    required this.imagePath,
    required this.projectName,
    required this.projectDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left part - Flat image
          Container(
            margin: EdgeInsets.only(bottom: 25.0,left: 10), // Margin for the image
            height: 130.0,
            width: 150,// Height of the image container
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(120.0),
                bottomRight: Radius.circular(120.0),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Right part - Text content
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 10.0,left: 15), // Margin for the text content
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    projectName,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    projectDescription,
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