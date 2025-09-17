import 'package:flutter/material.dart';

class AddFeedsProvider extends ChangeNotifier {
  final List<int> _selectedCategories = [];

  List<int> get selectedCategories => _selectedCategories;

  void toggleCategory(int index) {
    if (_selectedCategories.contains(index)) {
      _selectedCategories.remove(index);
    } else {
      _selectedCategories.add(index);
    }
    notifyListeners();
  }
}
