import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../model/category_model.dart';
import '../model/feed_modeld.dart';

class HomeProvider extends ChangeNotifier {
  int _selectedCategoryIndex = 0;

  int get selectedCategoryIndex => _selectedCategoryIndex;

  void selectCategory(int index) {
    if (_selectedCategoryIndex != index) {
      _selectedCategoryIndex = index;
      notifyListeners();
    }
  }

  // Category API state
  bool _categoryHasError = false;
  bool _isCategoryLoading = false;
  CategoryModel? _categoryModel;

  bool get categoryHasError => _categoryHasError;
  bool get isCategoryLoading => _isCategoryLoading;
  CategoryModel? get categoryModel => _categoryModel;
  List<Category> get categories => _categoryModel?.categories ?? [];

  Future<void> getCategoryData() async {
    _categoryHasError = false;
    _isCategoryLoading = true;
    notifyListeners();

    try {
      final response = await ServerClient.get(Urls.categoryList);
      log('Category API - Status: ${response.first}, Response: ${response.last}');

      if (response.first >= 200 && response.first < 300) {
        try {
          _categoryModel = CategoryModel.fromJson(response.last);
          log('Categories parsed successfully: ${_categoryModel?.categories?.length} items');
        } catch (e) {
          log('Category parsing error: $e');
          _categoryHasError = true;
        }
      } else {
        _categoryHasError = true;
        log('Category API error: ${response.first}');
      }
    } catch (e) {
      log('Category network error: $e');
      _categoryHasError = true;
    }

    _isCategoryLoading = false;
    notifyListeners();
  }

  // Home/Feed API state
  bool _hasError = false;
  bool _isLoading = false;
  FeedModel? _feedModel;

  bool get hasError => _hasError;
  bool get isLoading => _isLoading;
  FeedModel? get feedModel => _feedModel;
  List<Feed> get feeds => _feedModel?.results ?? [];
  FeedModelUser? get user => _feedModel?.user;
  List<dynamic> get banners => _feedModel?.banners ?? [];
  List<CategoryDict> get categoryDict => _feedModel?.categoryDict ?? [];

  // Video management properties
  VideoPlayerController? _currentVideoController;
  int? _currentPlayingIndex;
  bool _isVideoPlaying = false;
  bool _isVideoLoading = false;
  Duration _videoDuration = Duration.zero;
  Duration _videoPosition = Duration.zero;

  // Video getters
  VideoPlayerController? get currentVideoController => _currentVideoController;
  int? get currentPlayingIndex => _currentPlayingIndex;
  bool get isVideoPlaying => _isVideoPlaying;
  bool get isVideoLoading => _isVideoLoading;
  Duration get videoDuration => _videoDuration;
  Duration get videoPosition => _videoPosition;
  bool get isVideoInitialized => _currentVideoController?.value.isInitialized ?? false;

  Future<void> getHomeData() async {
    _hasError = false;
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ServerClient.get(Urls.home);
      log('Home API - Status: ${response.first}, Response: ${response.last}');

      if (response.first >= 200 && response.first < 300) {
        try {
          _feedModel = FeedModel.fromJson(response.last);
          log('Feed parsed successfully: ${_feedModel?.results?.length} items');
        } catch (e) {
          log('Feed parsing error: $e');
          _hasError = true;
        }
      } else {
        _hasError = true;
        log('Home API error: ${response.first}');
      }
    } catch (e) {
      log('Home network error: $e');
      _hasError = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Method to get user greeting
  String getUserGreeting() {
    if (user?.name != null && user!.name.toString().trim().isNotEmpty) {
      return 'Hello ${user!.name}';
    }
    return 'Hello User';
  }

  // Method to check if data is empty
  bool get isEmpty => feeds.isEmpty && !isLoading && !hasError;

  // Method to refresh all data
  Future<void> refreshData() async {
    // Stop any playing video before refresh
    await stopCurrentVideo();
    await Future.wait([getHomeData(), getCategoryData()]);
  }

  // Video management methods
  Future<void> playVideo(int feedIndex) async {
    if (feedIndex >= feeds.length) return;

    final feed = feeds[feedIndex];
    final videoUrl = feed.video;

    if (videoUrl == null || videoUrl.isEmpty) {
      log('No video URL available for feed $feedIndex');
      return;
    }

    // If same video is already playing, just toggle play/pause
    if (_currentPlayingIndex == feedIndex && _currentVideoController != null) {
      if (_isVideoPlaying) {
        await pauseVideo();
      } else {
        await resumeVideo();
      }
      return;
    }

    // Stop current video if playing
    await stopCurrentVideo();

    try {
      _isVideoLoading = true;
      _currentPlayingIndex = feedIndex;
      notifyListeners();

      _currentVideoController = VideoPlayerController.network(videoUrl);
      await _currentVideoController!.initialize();

      // Set up video listeners
      _currentVideoController!.addListener(_videoListener);

      // Update duration and start playing
      _videoDuration = _currentVideoController!.value.duration;
      _isVideoPlaying = true;
      _isVideoLoading = false;

      // Auto play the video
      await _currentVideoController!.play();

      log('Video started playing for feed $feedIndex');
      notifyListeners();
    } catch (e) {
      log('Error playing video: $e');
      _isVideoLoading = false;
      await stopCurrentVideo();
    }
  }

  void _videoListener() {
    if (_currentVideoController != null && _currentVideoController!.value.isInitialized) {
      _videoPosition = _currentVideoController!.value.position;

      // Check if video ended
      if (!_currentVideoController!.value.isPlaying &&
          _currentVideoController!.value.position == _currentVideoController!.value.duration &&
          _currentVideoController!.value.duration > Duration.zero) {
        _isVideoPlaying = false;
        log('Video playback completed');
      } else {
        _isVideoPlaying = _currentVideoController!.value.isPlaying;
      }

      notifyListeners();
    }
  }

  Future<void> pauseVideo() async {
    if (_currentVideoController != null && _isVideoPlaying) {
      await _currentVideoController!.pause();
      _isVideoPlaying = false;
      log('Video paused');
      notifyListeners();
    }
  }

  Future<void> resumeVideo() async {
    if (_currentVideoController != null && !_isVideoPlaying) {
      await _currentVideoController!.play();
      _isVideoPlaying = true;
      log('Video resumed');
      notifyListeners();
    }
  }

  Future<void> stopCurrentVideo() async {
    if (_currentVideoController != null) {
      _currentVideoController!.removeListener(_videoListener);
      await _currentVideoController!.pause();
      await _currentVideoController!.dispose();
      _currentVideoController = null;
      _currentPlayingIndex = null;
      _isVideoPlaying = false;
      _isVideoLoading = false;
      _videoDuration = Duration.zero;
      _videoPosition = Duration.zero;
      log('Video stopped and disposed');
      notifyListeners();
    }
  }

  void seekTo(Duration position) {
    if (_currentVideoController != null && _currentVideoController!.value.isInitialized) {
      _currentVideoController!.seekTo(position);
      _videoPosition = position;
      notifyListeners();
    }
  }

  // Toggle play/pause for current video
  Future<void> togglePlayPause() async {
    if (_isVideoPlaying) {
      await pauseVideo();
    } else {
      await resumeVideo();
    }
  }

  @override
  void dispose() {
    stopCurrentVideo();
    super.dispose();
  }
}
