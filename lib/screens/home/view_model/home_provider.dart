import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  int _selectedCategoryIndex = 0;

  int get selectedCategoryIndex => _selectedCategoryIndex;

  void selectCategory(int index) {
    if (_selectedCategoryIndex != index) {
      _selectedCategoryIndex = index;
      notifyListeners();
    }
  }
}
