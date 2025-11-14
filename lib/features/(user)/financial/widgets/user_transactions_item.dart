// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:paint_car/core/constants/custom_colors.dart';
import 'package:paint_car/data/models/enums/financial_status.dart';
import 'package:paint_car/data/models/transactions.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/shared/utils/currency_formatter.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'dart:typed_data';

class UserTransactionsItem extends StatelessWidget {
  final Transactions transactions;
  final VoidCallback? onReturnFromWebView;

  const UserTransactionsItem({
    Key? key,
    required this.transactions,
    this.onReturnFromWebView,
  }) : super(key: key);

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }

  String _getPaymentMethodName() {
    final methodName = transactions.paymentMethod?.name ?? "-";
    return methodName
        .split('_')
        .map(
          (word) =>
              word.substring(0, 1).toUpperCase() +
              word.substring(1).toLowerCase(),
        )
        .join(' ');
  }

  void _handleTap(BuildContext context) {
    final paymentDetail = transactions.paymentdetail;
    final url = paymentDetail?.deeplinkUrl ??
        paymentDetail?.mobileUrl ??
        paymentDetail?.webUrl;

    if (url == null ||
        transactions.paymentdetail!.virtualAccountNumber != null) {
      return;
    }

    LogService.i("WebView navigating to: $paymentDetail");

    if (transactions.paymentStatus.name.toUpperCase() == "PENDING") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentWebViewPage(
            paymentUrl: url,
            // Kirim callback URL kamu ke WebViewPage
            callbackUrl:
                'https://familiar-tomasina-happiness-overload-148b3187.koyeb.app',
          ),
        ),
      ).then((value) {
        if (value == true && onReturnFromWebView != null) {
          onReturnFromWebView!();
        }
      });
    }
  }

  /// Download QR Code image dari URL dan simpan ke galeri
  Future<void> _downloadQrCode(BuildContext context, String qrCodeUrl) async {
    try {
      LogService.i("Downloading QR Code from: $qrCodeUrl");

      // Tampilkan loading indicator
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: context.adaptivePrimaryCard,
            content: const Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 16),
                MainText(text: 'Mengunduh QR Code...'),
              ],
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }

      // Download gambar
      final response = await http.get(Uri.parse(qrCodeUrl));

      if (response.statusCode == 200) {
        // Simpan ke galeri
        final Uint8List bytes = response.bodyBytes;
        final result = await ImageGallerySaverPlus.saveImage(
          bytes,
          quality: 100,
          name: "qris_${DateTime.now().millisecondsSinceEpoch}",
        );

        LogService.i("QR Code saved: $result");

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: context.adaptivePrimaryCard,
              content: const MainText(
                text: '✓ QR Code berhasil disimpan ke galeri',
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        throw Exception('Failed to download QR Code: ${response.statusCode}');
      }
    } catch (e) {
      LogService.e("Failed to download QR Code: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: MainText(
              text: 'Gagal mengunduh QR Code: ${e.toString()}',
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentDetail = transactions.paymentdetail;

    final hasVirtualAccount = paymentDetail?.virtualAccountNumber != null &&
        paymentDetail!.virtualAccountNumber!.isNotEmpty;
    final isPending =
        transactions.paymentStatus.name.toUpperCase() == "PENDING";
    final hasNote = transactions.order != null &&
        transactions.order!.isNotEmpty &&
        transactions.order!.first?.note != null &&
        transactions.order!.first!.note!.isNotEmpty;

    // == LOGIKA BARU UNTUK WEBVIEW & QR ==
    final webViewUrl = paymentDetail?.deeplinkUrl ??
        paymentDetail?.mobileUrl ??
        paymentDetail?.webUrl;
    final hasWebViewUrl = webViewUrl != null && webViewUrl.isNotEmpty;

    final qrCodeUrl = paymentDetail?.midtransQrCodeUrl;
    final hasQrCode = qrCodeUrl != null && qrCodeUrl.isNotEmpty;
    // =====================================

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      color: context.adaptiveCommonColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        // Logika diperbarui: Hanya bisa di-tap jika ada WebView URL
        onTap: isPending && hasWebViewUrl
            ? () {
                _handleTap(context);
              }
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.receipt_long_rounded,
                        size: 20,
                        color: context.adaptiveTextColor,
                      ),
                      const SizedBox(width: 8),
                      MainText(
                        text: _formatDate(transactions.createdAt),
                        extent: const Medium(),
                        customTextStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                        color: context.adaptiveTextColor,
                      ),
                    ],
                  ),
                  buildPaymentStatusWidget(transactions.paymentStatus),
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Theme.of(context)
                  .colorScheme
                  .surfaceDim
                  .withValues(alpha: 0.5),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.payment_rounded,
                        size: 16,
                        color: context.adaptiveTextColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: MainText(
                          text: _getPaymentMethodName(),
                          maxLines: 2,
                          color: context.adaptiveTextColor,
                        ),
                      ),
                    ],
                  ),
                  if (hasVirtualAccount) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.account_balance_rounded,
                          size: 16,
                          color: context.adaptiveTextColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: MainText(
                            text:
                                '${transactions.paymentdetail?.virtualAccountNumber}',
                            maxLines: 2,
                            color: context.adaptiveTextColor,
                          ),
                        ),
                        if (transactions.paymentdetail?.virtualAccountNumber !=
                            null)
                          IconButton(
                            icon: Icon(
                              Icons.copy_rounded,
                              size: 16,
                              color: context.adaptiveSecondaryTextColor,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 36,
                              minHeight: 36,
                            ),
                            onPressed: () async {
                              try {
                                await Clipboard.setData(
                                  ClipboardData(
                                    text: transactions
                                        .paymentdetail!.virtualAccountNumber!,
                                  ),
                                );

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor:
                                          context.adaptivePrimaryCard,
                                      content: const MainText(
                                          text:
                                              'Virtual Account number copied'),
                                      duration: const Duration(seconds: 4),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Failed to copy to clipboard'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                      ],
                    ),
                  ],

                  // == WIDGET BARU UNTUK QRIS ==
                  if (hasQrCode) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.qr_code_2_rounded,
                          size: 16,
                          color: context.adaptiveTextColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: MainText(
                            text: 'QRIS Code',
                            maxLines: 2,
                            color: context.adaptiveTextColor,
                          ),
                        ),
                        // Tombol "Lihat" QR
                        IconButton(
                          icon: Icon(
                            Icons.visibility_rounded,
                            size: 16,
                            color: context.adaptiveSecondaryTextColor,
                          ),
                          constraints:
                              const BoxConstraints(minWidth: 36, minHeight: 36),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: context.adaptiveCommonColor,
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    MainText(
                                      text: 'Pindai QRIS',
                                      color: context.adaptiveTextColor,
                                      extent: const Medium(),
                                      customTextStyle: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      width: 250,
                                      height: 250,
                                      child: Image.network(
                                        qrCodeUrl,
                                        fit: BoxFit.contain,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Center(
                                          child: Icon(
                                            Icons.error_outline_rounded,
                                            color: Colors.red,
                                            size: 48,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    child: const MainText(
                                      text: 'Tutup',
                                      customTextStyle: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () => Navigator.of(ctx).pop(),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        // Tombol "Download" QR
                        IconButton(
                          icon: Icon(
                            Icons.download_rounded,
                            size: 16,
                            color: context.adaptiveSecondaryTextColor,
                          ),
                          constraints:
                              const BoxConstraints(minWidth: 36, minHeight: 36),
                          onPressed: () => _downloadQrCode(context, qrCodeUrl),
                        ),
                      ],
                    ),
                  ],
                  // ============================

                  if (hasNote) ...[
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.note_rounded,
                          size: 16,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: MainText(
                            text: "${transactions.order?.first?.note}",
                            customTextStyle: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.8),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Theme.of(context)
                  .colorScheme
                  .surfaceDim
                  .withValues(alpha: 0.5),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MainText(
                              text: 'Total:',
                              extent: const Medium(),
                              customTextStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              color: context.adaptiveTextColor,
                            ),
                            MainText(
                              text: CurrencyFormatter.toRupiah(
                                double.parse(
                                  transactions.totalPrice,
                                ),
                              ),
                              extent: const Medium(),
                              customTextStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              color: context.adaptiveTextColor,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  // Logika diperbarui: Hanya tampilkan tombol jika ada WebView URL
                  if (isPending && hasWebViewUrl)
                    SizedBox(
                      height: 32,
                      child: TextButton(
                        onPressed: () => _handleTap(context),
                        style: TextButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.payment_outlined,
                              size: 14,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            const SizedBox(width: 4),
                            const MainText(
                              text: 'Bayar',
                              customTextStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getPaymentStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.SUCCESS:
        return Colors.green.shade600;
      case PaymentStatus.PENDING:
        return Colors.amber.shade700;
      case PaymentStatus.FAILED:
        return Colors.red.shade600;
      case PaymentStatus.EXPIRED:
        return Colors.grey.shade600;
      case PaymentStatus.REFUNDED:
        return Colors.blue.shade600;
    }
  }

  Widget buildPaymentStatusWidget(PaymentStatus status) {
    final Color statusColor = getPaymentStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(status),
            size: 14,
            color: statusColor,
          ),
          const SizedBox(width: 4),
          MainText(
            text: paymentStatusLabels[status] ?? 'Unknown',
            customTextStyle: TextStyle(
              color: statusColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.SUCCESS:
        return Icons.check_circle_outline_rounded;
      case PaymentStatus.PENDING:
        return Icons.pending_outlined;
      case PaymentStatus.FAILED:
        return Icons.error_outline_rounded;
      case PaymentStatus.EXPIRED:
        return Icons.timer_off_outlined;
      case PaymentStatus.REFUNDED:
        return Icons.replay_rounded;
    }
  }
}

// ==================================================================
//               BAGIAN INI YANG DIPERBAIKI
// ==================================================================

class PaymentWebViewPage extends StatefulWidget {
  final String paymentUrl;
  final String callbackUrl; // Tambahkan ini

  const PaymentWebViewPage({
    Key? key,
    required this.paymentUrl,
    required this.callbackUrl, // Tambahkan ini
  }) : super(key: key);

  @override
  State createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  /// Map deeplink scheme ke nama aplikasi yang user-friendly
  String _getAppNameFromScheme(String scheme) {
    switch (scheme.toLowerCase()) {
      case 'gojek':
        return 'Gojek';
      case 'shopeepay':
        return 'ShopeePay';
      case 'dana':
        return 'DANA';
      case 'kredivo':
        return 'Kredivo';
      case 'linkaja':
        return 'LinkAja';
      case 'ovo':
        return 'OVO';
      case 'akulaku':
        return 'Akulaku';
      default:
        return scheme.substring(0, 1).toUpperCase() + scheme.substring(1);
    }
  }

  /// Map deeplink scheme ke Android package name
  String _getPackageNameFromScheme(String scheme) {
    switch (scheme.toLowerCase()) {
      case 'gojek':
        return 'com.gojek.app';
      case 'shopeepay':
        return 'com.shopee.id';
      case 'dana':
        return 'id.dana';
      case 'kredivo':
        return 'com.kredivo.android';
      case 'linkaja':
        return 'com.telkom.mwallet';
      case 'ovo':
        return 'ovo.id';
      case 'akulaku':
        return 'com.akulaku.overseas';
      default:
        return 'com.unknown.app';
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          // =================== LOGIKA UTAMA ===================
          onNavigationRequest: (NavigationRequest request) async {
            LogService.i("WebView navigating to: ${request.url}");

            // 1. CEK JIKA INI DEEPLINK PAYMENT APP (GOJEK, SHOPEEPAY, DANA, KREDIVO, DLL)
            // Deteksi berbagai deeplink scheme payment
            final paymentDeeplinks = [
              'gojek://',
              'shopeepay://',
              'dana://',
              'kredivo://',
              'linkaja://',
              'ovo://',
              'akulaku://'
            ];
            final isPaymentDeeplink = paymentDeeplinks
                .any((scheme) => request.url.startsWith(scheme));

            if (isPaymentDeeplink) {
              LogService.i("Payment deeplink intercepted: ${request.url}");
              try {
                final Uri uri = Uri.parse(request.url);
                final appScheme =
                    uri.scheme; // e.g., "gojek", "shopeepay", "dana"
                final appName = _getAppNameFromScheme(appScheme);

                LogService.i("Parsed URI: $uri");
                LogService.i("URI scheme: $appScheme");
                LogService.i("App name: $appName");
                LogService.i("URI host: ${uri.host}");
                LogService.i("URI path: ${uri.path}");

                // Strategi 1: Coba launch dengan mode externalNonBrowserApplication
                bool launched = false;
                try {
                  LogService.i(
                      "[Strategy 1] Attempting launch $appName with externalNonBrowserApplication...");
                  launched = await launchUrl(
                    uri,
                    mode: LaunchMode.externalNonBrowserApplication,
                  );
                  LogService.i("[Strategy 1] Launch $appName: $launched");
                } catch (e) {
                  LogService.w("[Strategy 1] Failed for $appName: $e");
                }

                // Strategi 2: Jika gagal, coba dengan externalApplication
                if (!launched) {
                  try {
                    LogService.i(
                        "[Strategy 2] Attempting launch $appName with externalApplication...");
                    // Untuk MIUI, tambahkan delay kecil
                    await Future.delayed(const Duration(milliseconds: 300));
                    launched = await launchUrl(
                      uri,
                      mode: LaunchMode.externalApplication,
                    );
                    LogService.i("[Strategy 2] Launch $appName: $launched");
                  } catch (e) {
                    LogService.w("[Strategy 2] Failed for $appName: $e");
                  }
                }

                // Strategi 3: Jika masih gagal, coba dengan intent langsung untuk Android
                if (!launched) {
                  try {
                    LogService.i(
                        "[Strategy 3] Attempting launch $appName with Android intent...");
                    // Coba buka dengan package name langsung (Android)
                    final packageName = _getPackageNameFromScheme(appScheme);
                    final deepLinkPath = request.url.substring(
                        appScheme.length + 3); // Hilangkan "scheme://"
                    final intentUrl =
                        'intent://$deepLinkPath#Intent;scheme=$appScheme;package=$packageName;end';
                    LogService.i("Intent URL: $intentUrl");

                    final intentUri = Uri.parse(intentUrl);
                    launched = await launchUrl(
                      intentUri,
                      mode: LaunchMode.externalApplication,
                    );
                    LogService.i("[Strategy 3] Launch $appName: $launched");
                  } catch (e) {
                    LogService.w("[Strategy 3] Failed for $appName: $e");
                  }
                }

                // Strategi 4: Fallback manual untuk MIUI - coba langsung tanpa canLaunchUrl
                if (!launched) {
                  try {
                    LogService.i(
                        "[Strategy 4] Final attempt: Force launch $appName without checking...");
                    // Di beberapa perangkat MIUI, canLaunchUrl return false meskipun app ada
                    // Jadi kita coba launch langsung
                    await launchUrl(
                      uri,
                      mode: LaunchMode.platformDefault,
                    );
                    launched = true; // Assume sukses jika tidak throw error
                    LogService.i(
                        "[Strategy 4] Force launch $appName completed");
                  } catch (e) {
                    LogService.w("[Strategy 4] Failed for $appName: $e");
                  }
                }

                // Jika semua strategi gagal
                if (!launched && mounted) {
                  // Tampilkan dialog untuk membuka Play Store
                  final packageName = _getPackageNameFromScheme(appScheme);
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Aplikasi $appName Tidak Ditemukan'),
                      content: Text(
                        'Aplikasi $appName tidak dapat dibuka. Apakah Anda ingin menginstall atau memperbarui aplikasi dari Play Store?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(ctx);
                            try {
                              // Buka Play Store untuk download app
                              final playStoreUri =
                                  Uri.parse('market://details?id=$packageName');
                              if (await canLaunchUrl(playStoreUri)) {
                                await launchUrl(playStoreUri,
                                    mode: LaunchMode.externalApplication);
                              } else {
                                // Fallback ke browser jika Play Store tidak ada
                                final webUri = Uri.parse(
                                    'https://play.google.com/store/apps/details?id=$packageName');
                                await launchUrl(webUri,
                                    mode: LaunchMode.externalApplication);
                              }
                            } catch (e) {
                              LogService.e("Failed to open Play Store: $e");
                            }
                          },
                          child: const Text('Buka Play Store'),
                        ),
                      ],
                    ),
                  );
                }
              } catch (e) {
                LogService.e("Failed to launch deeplink: $e");
                if (mounted) {
                  final Uri uri = Uri.parse(request.url);
                  final appName = _getAppNameFromScheme(uri.scheme);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal membuka aplikasi $appName: $e'),
                    ),
                  );
                }
              }
              // Hentikan WebView agar tidak mencoba memuat payment deeplink
              return NavigationDecision.prevent;
            }

            // 2. CEK JIKA INI URL CALLBACK (TANDA PEMBAYARAN SELESAI)
            if (request.url.startsWith(widget.callbackUrl)) {
              LogService.i("Callback URL intercepted. Closing WebView.");
              // Pembayaran selesai (sukses/gagal), kembali ke halaman list
              // dan kirim 'true' agar list di-refresh
              if (mounted) {
                Navigator.pop(context, true);
              }
              // Hentikan WebView memuat halaman callback
              return NavigationDecision.prevent;
            }

            // 3. UNTUK URL LAINNYA (Misal: halaman GoPay https://)
            // Biarkan WebView melanjutkan navigasi
            return NavigationDecision.navigate;
          },
          // =================== AKHIR LOGIKA ===================
          onWebResourceError: (WebResourceError error) {
            LogService.e(
                "WebView Error: ${error.description} (Code: ${error.errorCode})");
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          // Kirim 'true' saat user menekan back
          // agar list transaksi bisa di-refresh
          onPressed: () => Navigator.pop(context, true),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
