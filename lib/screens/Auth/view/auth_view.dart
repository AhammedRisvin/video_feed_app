import 'package:flutter/material.dart';
import 'package:video_feed_app/core/util/common_widgets.dart';
import 'package:video_feed_app/core/util/sized_box.dart';

import '../../../core/util/app_color.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final _countryCodeController = TextEditingController(text: '+91');
  final _phoneController = TextEditingController();

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.1),
            text(text: 'Enter Your \nMobile Number', size: 23, fontWeight: FontWeight.w500, color: AppColor.white),
            const SizedBox(height: 12),
            text(
              text:
                  'Lorem ipsum dolor sit amet consectetur. Porta at id hac vitae. Et tortor at vehicula euismod mi viverra.',
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
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    controller: _countryCodeController,
                    context: context,
                    hintTextColor: AppColor.white,
                    hintTextSize: 16,
                    suffixIcon: Icon(Icons.arrow_drop_down_rounded, color: AppColor.white),
                  ),
                ),
                const SizedBox(width: 20), // ✅ fixed from SizeBoxV
                Expanded(
                  child: buildCommonTextFormField(
                    hintText: 'Enter Mobile Number',
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    controller: _phoneController,
                    context: context,
                    hintTextSize: 13,
                    color: const Color(0xffBDBDBD),
                  ),
                ),
              ],
            ),
            SizeBoxH(screenHeight * 0.4),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: AppColor.white.withOpacity(0.28)),
                    color: Color(0xff1F1F1F),
                  ),
                  padding: EdgeInsetsGeometry.only(left: 13, right: 7, top: 7, bottom: 7),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      text(text: 'Continue', size: 14, fontWeight: FontWeight.w400, color: AppColor.white),
                      SizeBoxV(16),
                      CircleAvatar(
                        backgroundColor: Color(0xffC70000),
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
    );
  }
}
