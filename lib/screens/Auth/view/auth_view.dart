import 'package:flutter/material.dart';
import 'package:video_feed_app/core/routes/routes.dart';
import 'package:video_feed_app/core/util/common_widgets.dart';
import 'package:video_feed_app/core/util/sized_box.dart';

import '../../../core/util/app_color.dart';
import '../view_model/auth_provider.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final _countryCodeController = TextEditingController(text: '+91');
  final _phoneController = TextEditingController(text: '8129466718');
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final countryCode = "+91";
    final phone = _phoneController.text.trim();

    final success = await AuthProvider().loginFn(countryCode, phone);

    setState(() => _isLoading = false);

    if (success) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login failed. Please check your credentials.')));
    }
  }

  @override
  void dispose() {
    _countryCodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.1),
              text(text: 'Enter Your \nMobile Number', size: 23, fontWeight: FontWeight.w600, color: AppColor.white),
              const SizedBox(height: 12),
              text(
                text: 'Please enter your mobile number to continue.',
                size: 12,
                fontWeight: FontWeight.w400,
                color: AppColor.subText,
                letterSpacing: 1.3,
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: buildCommonTextFormField(
                      hintText: '+91',
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      controller: _countryCodeController,
                      context: context,
                      hintTextColor: AppColor.white,
                      hintTextSize: 16,
                      readOnly: true,
                      suffixIcon: Icon(Icons.arrow_drop_down_rounded, color: AppColor.white),
                      validator: (value) {
                        if (value == null || value.isEmpty || !value.startsWith('+')) {
                          return 'Invalid code';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: buildCommonTextFormField(
                      hintText: 'Enter Mobile Number',
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      controller: _phoneController,
                      context: context,
                      hintTextSize: 13,
                      maxLength: 10,
                      color: const Color(0xffBDBDBD),
                      validator: (value) {
                        if (value == null || value.length != 10) {
                          return 'Enter valid number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizeBoxH(screenHeight * 0.4),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: _isLoading ? null : _handleLogin,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: AppColor.white.withOpacity(0.28)),
                      color: const Color(0xff1F1F1F),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        text(
                          text: _isLoading ? 'Logging in...' : 'Continue',
                          size: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColor.white,
                        ),
                        SizeBoxV(16),
                        CircleAvatar(
                          backgroundColor: const Color(0xffC70000),
                          radius: 18,
                          child: Icon(Icons.arrow_forward_ios_rounded, color: AppColor.white, size: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
