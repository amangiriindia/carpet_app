import 'package:flutter/material.dart';

class BannerSection extends StatefulWidget {
  final List<String> bannerImages;

  const BannerSection({required this.bannerImages});

  @override
  _BannerSectionState createState() => _BannerSectionState();
}

class _BannerSectionState extends State<BannerSection> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  late int _numPages; // Number of banners

  @override
  void initState() {
    super.initState();
    _numPages = widget.bannerImages.length;
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
      height: 230.0,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            children: widget.bannerImages
                .map((imageUrl) => BannerImage(imageUrl))
                .toList(),
          ),
          Positioned(
            bottom: 15.0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8, // Adjusted width based on screen size
              height: 2.0, // Height of the slider
              decoration: BoxDecoration(
                color: Colors.grey[300], // Greyish color
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                children: List.generate(
                  _numPages,
                      (index) => Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: _currentPage == index ? Colors.black : Colors.transparent, // White slider when active
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

class BannerImage extends StatelessWidget {
  final String imageUrl;

  const BannerImage(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          imageUrl,
          fit: BoxFit.cover, // Adjusted to cover the container
          width: MediaQuery.of(context).size.width * 0.8, // Adjusted width based on screen size
          height: 230.0, // Adjusted height to match BannerSection height
        ),
      ),
    );
  }
}