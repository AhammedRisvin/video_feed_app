import 'package:flutter/material.dart';

import '../../../../core/util/app_color.dart';

class VideoCard extends StatelessWidget {
  final String imageUrl;
  final String playIconPath;

  const VideoCard({super.key, required this.imageUrl, required this.playIconPath});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.network(imageUrl, width: double.infinity, height: 450, fit: BoxFit.cover),
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.white, width: 1.72),
            color: AppColor.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(100),
          ),
          padding: const EdgeInsets.all(10),
          child: Image.asset(playIconPath),
        ),
      ],
    );
  }
}
