import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/util/storage.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> loginFn(String countryCode, String phone) async {
    _setLoading(true);
    try {
      final response = await ServerClient.post(
        Urls.login,
        data: {"country_code": countryCode, "phone": phone},
        useForm: true,
        includeToken: false,
      );

      final statusCode = response[0];
      final responseBody = response[1];
      log('response $statusCode  body ${responseBody['status']}');

      if (responseBody == null) {
        debugPrint('Login failed: Response body is null');
        return false;
      }

      final tokenData = responseBody['token'];
      if (statusCode == 202 && responseBody['status'] == true && tokenData != null) {
        Store.userToken = tokenData['access'];
        return true;
      } else {
        debugPrint('Login failed: ${responseBody['message'] ?? 'Unknown error'}');
        return false;
      }
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
