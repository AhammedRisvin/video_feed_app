import 'package:flutter/material.dart';

import '../../../../core/util/app_color.dart';

class VideoCard extends StatelessWidget {
  final String imageUrl;
  final String playIconPath;
  final VoidCallback? onTap;

  const VideoCard({super.key, required this.imageUrl, required this.playIconPath, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.network(
            imageUrl,
            width: double.infinity,
            height: 450,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: 450,
                color: Colors.grey[800],
                child: Icon(Icons.image_not_supported, color: AppColor.white.withOpacity(0.5), size: 50),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: double.infinity,
                height: 450,
                color: Colors.grey[800],
                child: Center(
                  child: CircularProgressIndicator(
                    color: const Color(0xffC70000),
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
          ),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.white, width: 1.72),
              color: AppColor.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(100),
            ),
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              playIconPath,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.play_arrow, color: AppColor.white, size: 20);
              },
            ),
          ),
        ],
      ),
    );
  }
}
