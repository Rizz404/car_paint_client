import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:paint_car/features/(user)/paint/widgets/full_screen_video_player.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/common/extent.dart';

class ApplicationGuidancePage extends StatefulWidget {
  const ApplicationGuidancePage({super.key});
  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const ApplicationGuidancePage(),
    );
  }

  @override
  State<ApplicationGuidancePage> createState() =>
      _ApplicationGuidancePageState();
}

class _ApplicationGuidancePageState extends State<ApplicationGuidancePage> {
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
        height: 200,
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
        height: 200,
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
                  // Fullscreen button
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: _enterFullScreen,
                        icon: const Icon(
                          Icons.fullscreen,
                          color: Colors.white,
                          size: 24,
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
                              size: 64,
                            ),
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
                  const SizedBox(height: 12),
                  // Fixed overflow issue with responsive layout
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
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _videoController.seekTo(Duration.zero);
                                  },
                                  icon: const Icon(Icons.replay),
                                ),
                                IconButton(
                                  onPressed: _enterFullScreen,
                                  icon: const Icon(Icons.fullscreen),
                                  tooltip: 'Fullscreen',
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            MainText(
                              text:
                                  '${_formatDuration(_videoController.value.position)} / ${_formatDuration(_videoController.value.duration)}',
                              extent: const Small(),
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
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _videoController.seekTo(Duration.zero);
                              },
                              icon: const Icon(Icons.replay),
                            ),
                            const Spacer(),
                            // Flexible widget to prevent overflow
                            Flexible(
                              child: MainText(
                                text:
                                    '${_formatDuration(_videoController.value.position)} / ${_formatDuration(_videoController.value.duration)}',
                                extent: const Small(),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: _enterFullScreen,
                              icon: const Icon(Icons.fullscreen),
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

  Widget _buildGuidanceSteps() {
    final steps = [
      {
        'title': 'Langkah 1: Registrasi',
        'description':
            'Daftarkan akun Anda dengan mengisi informasi yang diperlukan',
        'icon': Icons.person_add,
      },
      {
        'title': 'Langkah 2: Pilih Layanan',
        'description':
            'Pilih layanan cat mobil yang sesuai dengan kebutuhan Anda',
        'icon': Icons.build,
      },
      {
        'title': 'Langkah 3: Pilih Bengkel',
        'description': 'Temukan bengkel terdekat dengan lokasi Anda',
        'icon': Icons.location_on,
      },
      {
        'title': 'Langkah 4: Booking',
        'description': 'Lakukan booking dan konfirmasi jadwal pengecatan',
        'icon': Icons.calendar_today,
      },
      {
        'title': 'Langkah 5: Pembayaran',
        'description': 'Pilih metode pembayaran yang tersedia',
        'icon': Icons.payment,
      },
      {
        'title': 'Langkah 6: Tracking',
        'description': 'Pantau progress pengecatan mobil Anda secara real-time',
        'icon': Icons.track_changes,
      },
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MainText(
          text: 'Langkah-Langkah Penggunaan Aplikasi',
          extent: Medium(),
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        ...steps.map((step) => _buildStepCard(
              title: step['title'] as String,
              description: step['description'] as String,
              icon: step['icon'] as IconData,
            )),
      ],
    );
  }

  Widget _buildStepCard({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MainText(
                    text: title,
                    customTextStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  MainText(
                    text: description,
                    customTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipsSection() {
    final tips = [
      'Pastikan koneksi internet stabil untuk pengalaman terbaik',
      'Lengkapi profil Anda untuk mempercepat proses booking',
      'Simpan nomor customer service untuk bantuan lebih lanjut',
      'Periksa notifikasi secara berkala untuk update terbaru',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MainText(
          text: 'Tips Penggunaan',
          extent: Medium(),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: tips
                  .map((tip) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 4, right: 12),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Expanded(
                              child: MainText(
                                text: tip,
                                extent: const Small(),
                                maxLines: 5,
                                customTextStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MainText(
          text: 'Panduan Aplikasi',
          customTextStyle: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.help_outline,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    const MainText(
                      text: 'Selamat Datang di Panduan Aplikasi',
                      extent: Medium(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 8),
                    MainText(
                      text:
                          'Tonton video dan ikuti langkah-langkah di bawah untuk memahami cara menggunakan aplikasi dengan mudah',
                      extent: const Small(),
                      textAlign: TextAlign.center,
                      customTextStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const MainText(
              text: 'Video Panduan',
              extent: Medium(),
            ),
            const SizedBox(height: 16),
            _buildVideoPlayer(),
            const SizedBox(height: 32),
            _buildGuidanceSteps(),
            const SizedBox(height: 32),
            _buildTipsSection(),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.support_agent,
                      size: 32,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    const MainText(
                      text: 'Butuh Bantuan Lebih Lanjut?',
                      customTextStyle: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    MainText(
                      text: 'Tim customer service kami siap membantu Anda',
                      extent: const Small(),
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      customTextStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Fitur hubungi customer service akan segera tersedia'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.phone),
                        label: const Text('Hubungi Customer Service'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
