import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart' show Urls;

class AddFeedsProvider extends ChangeNotifier {
  File? videoFile;
  File? thumbnailFile;
  MultipartFile? videoMultipart;
  MultipartFile? thumbnailMultipart;
  bool isLoading = false;

  final List<int> _selectedCategories = [];
  List<int> get selectedCategories => _selectedCategories;

  String? description;

  void toggleCategory(int index) {
    if (_selectedCategories.contains(index)) {
      _selectedCategories.remove(index);
    } else {
      _selectedCategories.add(index);
    }
    notifyListeners();
  }

  Future<void> pickVideo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null && result.files.single.path != null) {
      videoFile = File(result.files.single.path!);
      await _createMultipart(videoFile!, isVideo: true);
    }
  }

  Future<void> pickThumbnail() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      thumbnailFile = File(result.files.single.path!);
      await _createMultipart(thumbnailFile!, isVideo: false);
    }
  }

  Future<void> _createMultipart(File file, {required bool isVideo}) async {
    isLoading = true;
    notifyListeners();
    try {
      final multipart = await MultipartFile.fromFile(file.path, filename: file.path.split('/').last);
      if (isVideo) {
        videoMultipart = multipart;
        log('videoMultipart $videoMultipart');
      } else {
        thumbnailMultipart = multipart;
        log('thumbnailMultipart $thumbnailMultipart');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool validateForm() {
    if (videoMultipart == null) return false;
    if (thumbnailMultipart == null) return false;
    if (description == null || description!.trim().isEmpty) return false;
    if (_selectedCategories.isEmpty) return false;
    return true;
  }

  bool _isSharePostLoading = false;
  bool get isSharePostLoading => _isSharePostLoading;

  void _setLoading(bool value) {
    _isSharePostLoading = value;
    notifyListeners();
  }

  Future<bool> addFeedFn() async {
    _setLoading(true);
    try {
      final response = await ServerClient.dioPost(
        Urls.myFeed,
        data: {
          "video": videoMultipart,
          "image": thumbnailMultipart,
          "desc": description?.trim(),
          "category": _selectedCategories,
        },
        useForm: true,
      );

      final statusCode = response[0];
      final responseBody = response[1];
      log('Add Feed Response - Status: $statusCode, Body: ${responseBody?.toString()}');

      if (responseBody != null &&
          (statusCode == 200 || statusCode == 201 || statusCode == 202) &&
          (responseBody['status'] == true || responseBody['success'] == true)) {
        return true;
      }

      debugPrint('Add Feed failed: ${responseBody?['message'] ?? 'Unknown error'}');
      return false;
    } catch (e) {
      debugPrint('Add Feed error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void clearFields() {
    videoFile = null;
    thumbnailFile = null;
    videoMultipart = null;
    thumbnailMultipart = null;
    description = null;
    _selectedCategories.clear();
    isLoading = false;
    _isSharePostLoading = false;
    notifyListeners();
  }
}
