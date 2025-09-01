import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/common/extent.dart';

class VideoGuidanceModal extends StatefulWidget {
  final VoidCallback onVideoCompleted;

  const VideoGuidanceModal({
    super.key,
    required this.onVideoCompleted,
  });

  @override
  State<VideoGuidanceModal> createState() => _VideoGuidanceModalState();
}

class _VideoGuidanceModalState extends State<VideoGuidanceModal> {
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;
  bool _hasError = false;
  bool _isVideoCompleted = false;
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

        _videoController.play();

        _videoController.addListener(_videoListener);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Gagal memuat video: ${e.toString()}';
        });
      }
    }
  }

  void _videoListener() {
    if (mounted) {
      setState(() {});

      if (_videoController.value.position >= _videoController.value.duration) {
        if (!_isVideoCompleted) {
          setState(() {
            _isVideoCompleted = true;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _videoController.removeListener(_videoListener);
    _videoController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  Widget _buildVideoPlayer() {
    if (_hasError) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            MainText(
              text: _errorMessage ?? 'Terjadi kesalahan',
              extent: const Small(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _hasError = false;
                  _errorMessage = null;
                });
                _initializeVideoPlayer();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (!_isVideoInitialized) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: _videoController.value.aspectRatio,
              child: Stack(
                children: [
                  VideoPlayer(_videoController),
                  if (!_videoController.value.isPlaying && !_isVideoCompleted)
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
                              size: 64,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (_isVideoCompleted)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 64,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.surface,
              child: Column(
                children: [
                  VideoProgressIndicator(
                    _videoController,
                    allowScrubbing: false,
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
                  const SizedBox(height: 12),
                  Row(
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
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _videoController.seekTo(Duration.zero);
                          setState(() {
                            _isVideoCompleted = false;
                          });
                        },
                        icon: const Icon(Icons.replay),
                      ),
                      const Spacer(),
                      MainText(
                        text:
                            '${_formatDuration(_videoController.value.position)} / ${_formatDuration(_videoController.value.duration)}',
                        extent: const Small(),
                        textAlign: TextAlign.end,
                      ),
                    ],
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
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight * 0.9;

    return WillPopScope(
      onWillPop: () async => _isVideoCompleted,
      child: Dialog(
        insetPadding: const EdgeInsets.all(16),
        backgroundColor: Colors.transparent,
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: maxHeight,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.play_circle_outline,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: MainText(
                        text: 'Panduan Penggunaan Aplikasi',
                        extent: Medium(),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const MainText(
                        text:
                            'Tonton video panduan berikut untuk memahami cara menggunakan aplikasi',
                        extent: Small(),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      _buildVideoPlayer(),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isVideoCompleted
                              ? widget.onVideoCompleted
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: _isVideoCompleted
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).disabledColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_isVideoCompleted)
                                const Icon(Icons.check_circle, size: 18)
                              else
                                const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: MainText(
                                  text: _isVideoCompleted
                                      ? 'Lanjutkan'
                                      : 'Menunggu video selesai...',
                                  customTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (!_isVideoCompleted)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: MainText(
                            text:
                                'Video harus ditonton sampai selesai untuk melanjutkan',
                            extent: const Small(),
                            textAlign: TextAlign.center,
                            customTextStyle: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 2,
                          ),
                        ),
                    ],
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
