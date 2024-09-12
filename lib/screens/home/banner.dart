import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/const.dart';

class BannerSection extends StatefulWidget {
  @override
  _BannerSectionState createState() => _BannerSectionState();
}

class _BannerSectionState extends State<BannerSection> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  List<String> bannerImages = [];
  bool isLoading = true;
  late int _numPages;

  @override
  void initState() {
    super.initState();
    fetchSliderImages();

    _pageController.addListener(() {
      int nextPage = _pageController.page?.round() ?? 0;
      if (_currentPage != nextPage) {
        setState(() {
          _currentPage = nextPage;
        });
      }
    });
  }

  Future<void> fetchSliderImages() async {
    final prefs = await SharedPreferences.getInstance();
    final String cacheKey = 'cached_slider_images';
    final String timestampKey = 'cache_timestamp';

    final cachedData = prefs.getString(cacheKey);
    final cachedTimestamp = prefs.getInt(timestampKey);

    final now = DateTime.now().millisecondsSinceEpoch;
    final cacheDuration = Duration(hours: 1); // Define cache duration

    // Check if cache is still valid
    if (cachedData != null &&
        cachedTimestamp != null &&
        now - cachedTimestamp < cacheDuration.inMilliseconds) {
      // Cache is valid
      final List<dynamic> allSliderImages = json.decode(cachedData);
      setState(() {
        bannerImages = List<String>.from(allSliderImages);
        _numPages = bannerImages.length;
        isLoading = false;
      });
    } else {
      // Cache is expired or not available, fetch from API
      final url = '${APIConstants.API_URL}/api/v1/slider/all-slider';
      try {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['success']) {
            final List<String> images = List<String>.from(data['allSliderImg'].map((item) => item['photo']));
            setState(() {
              bannerImages = images;
              _numPages = bannerImages.length;
              isLoading = false;
            });

            // Cache the new data and update the timestamp
            prefs.setString(cacheKey, json.encode(images));
            prefs.setInt(timestampKey, now);
          }
        } else {
          throw Exception('Failed to load images');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: SpinKitThreeBounce(
          color: AppStyles.primaryColorStart,
          size: 20.0,
        ),
      );
    }

    if (bannerImages.isEmpty) {
      return Container(
        height: 230.0,
        child: Center(child: Text('No images available')),
      );
    }

    return Container(
      height: 230.0,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            children: bannerImages
                .map((imageUrl) => BannerImage(imageUrl))
                .toList(),
          ),
          Positioned(
            bottom: 15.0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4, // Adjusted width based on screen size
              height: 1.0, // Height of the slider
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

class BannerImage extends StatelessWidget {
  final String imageUrl;

  const BannerImage(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7.0),
        child: Image.memory(
          base64Decode(imageUrl),
          fit: BoxFit.fitWidth
          , // Ensure the full image is displayed
          width: MediaQuery.of(context).size.width * 0.8,
          height: 230.0,
        ),
      ),
    );
  }
}
