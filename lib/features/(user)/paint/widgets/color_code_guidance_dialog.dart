import 'dart:async';
import 'package:flutter/material.dart';
import 'package:paint_car/core/constants/custom_colors.dart';
import 'package:paint_car/features/(user)/paint/widgets/full_screen_video_player.dart';
import 'package:video_player/video_player.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/common/extent.dart';

class ColorCodeGuidanceDialog extends StatefulWidget {
  const ColorCodeGuidanceDialog({super.key});

  @override
  State<ColorCodeGuidanceDialog> createState() =>
      _ColorCodeGuidanceDialogState();
}

class _ColorCodeGuidanceDialogState extends State<ColorCodeGuidanceDialog> {
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      _videoController = VideoPlayerController.asset(
        'assets/videos/application-guidance.mp4',
      );
      await _videoController.initialize();
      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
      }
      _videoController.addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Gagal memuat video: ${e.toString()}';
        });
      }
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  void _enterFullScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenVideoPlayer(
          controller: _videoController,
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (_hasError) {
      return Container(
        height: 180,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 24,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 4),
            const MainText(
              text: 'Gagal memuat video',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _hasError = false;
                  _errorMessage = null;
                });
                _initializeVideoPlayer();
              },
              icon: const Icon(Icons.refresh, size: 14),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (!_isVideoInitialized) {
      return Container(
        height: 180,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: Stack(
                  children: [
                    VideoPlayer(_videoController),
                    // Fullscreen button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: IconButton(
                          onPressed: _enterFullScreen,
                          icon: const Icon(
                            Icons.fullscreen,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    if (!_videoController.value.isPlaying)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(0.3),
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _videoController.play();
                                });
                              },
                              icon: const Icon(
                                Icons.play_circle_filled,
                                color: Colors.white,
                                size: 48,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              color: Theme.of(context).colorScheme.surface,
              child: Column(
                children: [
                  VideoProgressIndicator(
                    _videoController,
                    allowScrubbing: true,
                    colors: VideoProgressColors(
                      playedColor: Theme.of(context).colorScheme.primary,
                      bufferedColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.3),
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.3),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Fixed the overflow issue by restructuring the controls layout
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final screenWidth = constraints.maxWidth;
                      final isSmallScreen = screenWidth < 300;

                      if (isSmallScreen) {
                        // Stack controls vertically for very small screens
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (_videoController.value.isPlaying) {
                                        _videoController.pause();
                                      } else {
                                        _videoController.play();
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    _videoController.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    size: 22,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _videoController.seekTo(Duration.zero);
                                  },
                                  icon: const Icon(Icons.replay, size: 22),
                                ),
                                IconButton(
                                  onPressed: _enterFullScreen,
                                  icon: const Icon(Icons.fullscreen, size: 22),
                                  tooltip: 'Fullscreen',
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            MainText(
                              text:
                                  '${_formatDuration(_videoController.value.position)} / ${_formatDuration(_videoController.value.duration)}',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      } else {
                        // Horizontal layout for normal screens
                        return Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (_videoController.value.isPlaying) {
                                    _videoController.pause();
                                  } else {
                                    _videoController.play();
                                  }
                                });
                              },
                              icon: Icon(
                                _videoController.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                size: 22,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _videoController.seekTo(Duration.zero);
                              },
                              icon: const Icon(Icons.replay, size: 22),
                            ),
                            const Spacer(),
                            // Flexible widget to prevent overflow
                            Flexible(
                              child: MainText(
                                text:
                                    '${_formatDuration(_videoController.value.position)} / ${_formatDuration(_videoController.value.duration)}',
                                textAlign: TextAlign.end,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: _enterFullScreen,
                              icon: const Icon(Icons.fullscreen, size: 22),
                              tooltip: 'Fullscreen',
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: MainText(
        text: "Cara Menemukan Kode Warna Mobil",
        textAlign: TextAlign.center,
        extent: Large(),
        color: context.adaptiveTextColor,
        maxLines: 3,
      ),
      backgroundColor: context.adaptivePrimaryCard,
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.8,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MainText(
                text: "Video Panduan:",
                extent: Medium(),
                customTextStyle: TextStyle(fontWeight: FontWeight.w600),
                color: context.adaptiveTextColor,
              ),
              const SizedBox(height: 12),
              _buildVideoPlayer(),
              const SizedBox(height: 16),
              Divider(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
              const SizedBox(height: 12),
              MainText(
                text: "Lokasi Kode Warna:",
                extent: Medium(),
                customTextStyle: TextStyle(fontWeight: FontWeight.w600),
                color: context.adaptiveTextColor,
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  "assets/images/car/location_code_color_car_1.png",
                  fit: BoxFit.cover,
                  height: 180,
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  "assets/images/car/location_code_color_car_2.png",
                  fit: BoxFit.cover,
                  height: 180,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Tutup'),
        ),
      ],
    );
  }
}
