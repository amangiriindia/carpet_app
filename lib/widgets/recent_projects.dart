import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Import the spinkit package
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../const.dart';

class RecentProjectsSection extends StatefulWidget {
  @override
  _RecentProjectsSectionState createState() => _RecentProjectsSectionState();
}

class _RecentProjectsSectionState extends State<RecentProjectsSection> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  late Future<List<RecentProjectsitem>> _recentprojectitems;

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
    _recentprojectitems = fetchRecentProjects();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<List<RecentProjectsitem>> fetchRecentProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final String cacheKey = 'cached_recent_projects';
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
      final List<dynamic> allRecentImg = json.decode(cachedData);
      List<RecentProjectsitem> items = allRecentImg.map((recentproject) {
        List<int> imageData = List<int>.from(recentproject['photo']['data']['data']);
        return RecentProjectsitem(
          image: Uint8List.fromList(imageData),
          title: recentproject['title'],
          description: recentproject['description'] ?? 'No description available',
        );
      }).cast<RecentProjectsitem>().toList();

      return items;
    } else {
      // Cache is expired or not available, fetch from API
      final response = await http.get(
        Uri.parse('${APIConstants.API_URL}/api/v1/recent/all-recent'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        List<dynamic> allRecentImg = jsonResponse['allRecentImg'];
        List<RecentProjectsitem> items = allRecentImg.map((recentproject) {
          List<int> imageData = List<int>.from(recentproject['photo']['data']['data']);
          return RecentProjectsitem(
            image: Uint8List.fromList(imageData),
            title: recentproject['title'],
            description: recentproject['description'] ?? 'No description available',
          );
        }).cast<RecentProjectsitem>().toList();

        // Cache the new data and update the timestamp
        prefs.setString(cacheKey, json.encode(allRecentImg));
        prefs.setInt(timestampKey, now);

        return items;
      } else {
        throw Exception('Failed to load recent projects');
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RecentProjectsitem>>(
      future: _recentprojectitems,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CommonFunction.showLoadingIndicator();  // Use the custom loading indicator
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No projects available.'));
        } else {
          final projects = snapshot.data!;

          return Container(
            height: 200.0,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                PageView(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  children: projects.map((project) {
                    return RecentProjectItemWithImage(
                      image: project.image,
                      projectName: project.title,
                      projectDescription: project.description,
                    );
                  }).toList(),
                ),
                Positioned(
                  bottom: 15.0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 1.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: List.generate(
                        projects.length,
                            (index) => Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: _currentPage == index ? Colors.black : Colors.transparent,
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
      },
    );
  }
}

class RecentProjectItemWithImage extends StatelessWidget {
  final Uint8List image;
  final String projectName;
  final String projectDescription;

  const RecentProjectItemWithImage({
    required this.image,
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
            margin: EdgeInsets.only(bottom: 25.0, left: 10),
            height: 130.0,
            width: 220,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(120.0),
                bottomRight: Radius.circular(120.0),
              ),
              child: Image.memory(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Right part - Text content
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 10.0, left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [const Color(0xFF991F35), const Color(0xFF330A12)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds),
                    child: Text(
                      projectName,
                      textAlign: TextAlign.center,
                      style: AppStyles.secondaryBodyTextStyle
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    projectDescription,
                    textAlign: TextAlign.start,
                    style: AppStyles.tertiaryBodyTextStyle.copyWith(color: Colors.black),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecentProjectsitem {
  final Uint8List image;
  final String title;
  final String description;

  RecentProjectsitem({
    required this.image,
    required this.title,
    required this.description,
  });
}
