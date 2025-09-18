import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

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
      } else {
        thumbnailMultipart = multipart;
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
}
