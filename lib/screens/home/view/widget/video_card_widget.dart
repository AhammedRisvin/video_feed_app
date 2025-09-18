// enhanced_video_player_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/util/app_color.dart';
import '../../view_model/home_provider.dart';

class EnhancedVideoPlayer extends StatelessWidget {
  final int feedIndex;
  final String thumbnailUrl;
  final bool isCurrentlyPlaying;

  const EnhancedVideoPlayer({
    super.key,
    required this.feedIndex,
    required this.thumbnailUrl,
    required this.isCurrentlyPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        final isThisVideoPlaying = provider.currentPlayingIndex == feedIndex;

        return GestureDetector(
          onTap: () {
            if (!isThisVideoPlaying) {
              provider.playVideo(feedIndex);
            }
          },
          child: Container(
            width: double.infinity,
            height: 450,
            color: Colors.black,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isThisVideoPlaying && provider.isVideoInitialized)
                  _buildVideoPlayer(provider)
                else
                  _buildThumbnail(),

                if (isThisVideoPlaying && provider.isVideoLoading)
                  const CircularProgressIndicator(color: Color(0xffC70000)),

                if (!isThisVideoPlaying || (isThisVideoPlaying && !provider.isVideoPlaying && !provider.isVideoLoading))
                  _buildPlayButton(),

                if (isThisVideoPlaying && provider.isVideoInitialized) _buildVideoControls(context, provider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideoPlayer(HomeProvider provider) {
    return AspectRatio(
      aspectRatio: provider.currentVideoController!.value.aspectRatio,
      child: VideoPlayer(provider.currentVideoController!),
    );
  }

  Widget _buildThumbnail() {
    return Image.network(
      thumbnailUrl,
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
    );
  }

  Widget _buildPlayButton() {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Icon(Icons.play_arrow, color: Colors.white, size: 30),
    );
  }

  Widget _buildVideoControls(BuildContext context, HomeProvider provider) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => provider.togglePlayPause(),
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
                child: Column(
                  children: [
                    _buildProgressBar(provider, context),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => provider.togglePlayPause(),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(25)),
                            child: Icon(
                              provider.isVideoPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () => provider.stopCurrentVideo(),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(25)),
                            child: const Icon(Icons.close, color: Colors.white, size: 24),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(HomeProvider provider, BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_formatDuration(provider.videoPosition), style: const TextStyle(color: Colors.white, fontSize: 12)),
            Text(_formatDuration(provider.videoDuration), style: const TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xffC70000),
            inactiveTrackColor: Colors.white.withOpacity(0.3),
            thumbColor: const Color(0xffC70000),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
            trackHeight: 3,
          ),
          child: Slider(
            value: provider.videoDuration.inMilliseconds > 0
                ? provider.videoPosition.inMilliseconds / provider.videoDuration.inMilliseconds
                : 0.0,
            onChanged: (value) {
              final position = Duration(milliseconds: (provider.videoDuration.inMilliseconds * value).round());
              provider.seekTo(position);
            },
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
