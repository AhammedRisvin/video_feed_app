import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/util/app_color.dart';
import '../../../../core/util/common_widgets.dart';
import '../../../../core/util/sized_box.dart';
import '../../model/feed_modeld.dart';
import 'video_card_widget.dart';

class FeedWidget extends StatelessWidget {
  final Feed? feed;

  const FeedWidget({super.key, this.feed});

  @override
  Widget build(BuildContext context) {
    // Default values for skeleton loading
    final String userName = feed?.user?.name ?? 'Loading User';
    final String userImage = feed?.user?.image?.toString() ?? 'https://picsum.photos/300/200';
    final String description = feed?.description ?? 'Loading description...';
    final String timeAgo = _getTimeAgo();
    final String mediaUrl = _getMediaUrl();
    final String? videoUrl = feed?.video;

    return Column(
      children: [
        SizeBoxH(20),
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
            ],
          ),
        ),
        SizeBoxH(15),
        VideoCard(
          imageUrl: mediaUrl,
          playIconPath: 'assets/image/playPng.png',
          onTap: () {
            if (videoUrl != null && videoUrl.isNotEmpty) {
              print('Video URL: $videoUrl');
              // TODO: Implement video player
            } else {
              print('No video URL available');
            }
          },
        ),
        SizeBoxH(11),
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
  }

  String _getTimeAgo() {
    if (feed?.createdAt != null) {
      return timeago.format(feed!.createdAt!);
    }
    return '5 days ago';
  }

  String _getMediaUrl() {
    // Prefer video thumbnail or image, fallback to placeholder
    if (feed?.image != null && feed!.image!.isNotEmpty) {
      return feed!.image!;
    } else if (feed?.video != null && feed!.video!.isNotEmpty) {
      // For video, we might need a thumbnail - using placeholder for now
      return 'https://picsum.photos/300/200';
    }
    return 'https://picsum.photos/300/200';
  }
}
