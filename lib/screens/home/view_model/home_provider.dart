import 'dart:developer';

import 'package:flutter/material.dart';

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
    await Future.wait([getHomeData(), getCategoryData()]);
  }
}
