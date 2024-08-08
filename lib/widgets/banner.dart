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
              width: MediaQuery.of(context).size.width * 0.4,
              height: 2.0,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2), // Light grey background
                borderRadius: BorderRadius.circular(1.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_numPages, (index) {
                  final isActive = _currentPage == index;
                  return Expanded(
                    child: Container(
                      height: 2.0,
                      color: isActive ? Colors.white : Colors.transparent,
                      margin: const EdgeInsets.symmetric(horizontal: 2.0),
                    ),
                  );
                }),
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
        borderRadius: BorderRadius.circular(7.0),
        child: Image.asset(
          imageUrl,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width * 0.8,
          height: 230.0,
        ),
      ),
    );
  }
}
