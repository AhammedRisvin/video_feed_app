import 'package:flutter/material.dart';
import 'package:video_feed_app/screens/home/view/widget/category_list_widget.dart' show CategoryList;

import '../../../core/util/app_color.dart';
import '../../../core/util/common_widgets.dart';
import 'widget/feed_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.black,
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            text(text: 'Hello Maria', size: 16, fontWeight: FontWeight.w600, color: AppColor.white),
            const SizedBox(height: 12),
            text(
              text: 'Welcome back to Section',
              size: 12,
              fontWeight: FontWeight.w400,
              color: const Color(0xffD5D5D5),
              letterSpacing: 1.3,
            ),
          ],
        ),
        actions: [
          image(
            url: 'https://picsum.photos/300/200',
            height: 47.16,
            width: 47.16,
            borderRadius: BorderRadius.circular(100),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CategoryList(),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6,
              separatorBuilder: (_, __) => Divider(color: AppColor.black, thickness: 3),
              itemBuilder: (context, index) {
                return FeedWidget();
              },
            ),
          ],
        ),
      ),
    );
  }
}
