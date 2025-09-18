// Updated feed_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/util/app_color.dart';
import '../../../../core/util/common_widgets.dart';
import '../../../../core/util/sized_box.dart';
import '../../model/feed_modeld.dart';
import '../../view_model/home_provider.dart';
import 'video_card_widget.dart';

class FeedWidget extends StatelessWidget {
  final Feed? feed;
  final int feedIndex;

  const FeedWidget({super.key, this.feed, required this.feedIndex});

  @override
  Widget build(BuildContext context) {
    // Default values for skeleton loading
    final String userName = feed?.user?.name ?? 'Loading User';
    final String userImage = feed?.user?.image?.toString() ?? 'https://picsum.photos/300/200';
    final String description = feed?.description ?? 'Loading description...';
    final String timeAgo = _getTimeAgo();
    final String thumbnailUrl = _getThumbnailUrl();
    final bool hasVideo = feed?.video != null && feed!.video!.isNotEmpty;

    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        final bool isCurrentlyPlaying = provider.currentPlayingIndex == feedIndex;

        return Column(
          children: [
            SizeBoxH(20),
            // User info section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                children: [
                  image(url: userImage, height: 47.16, width: 47.16, borderRadius: BorderRadius.circular(100)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text(
                          text: userName,
                          size: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColor.white,
                          maxLines: 2,
                          overFlow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 7),
                        text(
                          text: timeAgo,
                          size: 10,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xffD5D5D5),
                          letterSpacing: 1.3,
                        ),
                      ],
                    ),
                  ),
                  // Close video button (only show if this video is playing)
                  if (isCurrentlyPlaying)
                    IconButton(
                      onPressed: () => provider.stopCurrentVideo(),
                      icon: Icon(Icons.close, color: AppColor.white, size: 20),
                    ),
                ],
              ),
            ),
            SizeBoxH(15),

            // Video/Image section
            if (hasVideo)
              EnhancedVideoPlayer(
                feedIndex: feedIndex,
                thumbnailUrl: thumbnailUrl,
                isCurrentlyPlaying: isCurrentlyPlaying,
              )
            else
              // Static image for feeds without video
              _buildStaticImage(thumbnailUrl),

            SizeBoxH(11),
            // Description section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: text(
                  text: description,
                  size: 12,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xffD5D5D5),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            SizeBoxH(20),
          ],
        );
      },
    );
  }

  Widget _buildStaticImage(String imageUrl) {
    return SizedBox(
      width: double.infinity,
      height: 450,
      child: Image.network(
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
    );
  }

  String _getTimeAgo() {
    if (feed?.createdAt != null) {
      return timeago.format(feed!.createdAt!);
    }
    return '5 days ago';
  }

  String _getThumbnailUrl() {
    // Prefer image field for thumbnail, fallback to placeholder
    if (feed?.image != null && feed!.image!.isNotEmpty) {
      return feed!.image!;
    }
    return 'https://picsum.photos/300/200';
  }
}
