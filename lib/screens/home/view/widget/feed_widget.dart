import 'package:flutter/material.dart';

import '../../../../core/util/app_color.dart';
import '../../../../core/util/common_widgets.dart';
import '../../../../core/util/sized_box.dart';
import 'video_card_widget.dart';

class FeedWidget extends StatelessWidget {
  const FeedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizeBoxH(20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            children: [
              image(
                url: 'https://picsum.photos/300/200',
                height: 47.16,
                width: 47.16,
                borderRadius: BorderRadius.circular(100),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text(
                      text: 'Anagha Krishna',
                      size: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColor.white,
                      maxLines: 2,
                      overFlow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 7),
                    text(
                      text: '5 days ago',
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
        const VideoCard(imageUrl: 'https://picsum.photos/300/200', playIconPath: 'assets/image/playPng.png'),
        SizeBoxH(11),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: text(
            text:
                'Lorem ipsum dolor sit amet consectetur. Leo ac lorem faucli bus facilisis tellus. At vitae dis commodo nunc sollicitudin elementum suspendisse...',
            size: 12,
            fontWeight: FontWeight.w300,
            color: const Color(0xffD5D5D5),
            textAlign: TextAlign.justify,
          ),
        ),
        SizeBoxH(20),
      ],
    );
  }
}
