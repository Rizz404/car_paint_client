import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paint_car/core/constants/custom_colors.dart';
import 'package:paint_car/data/models/enums/financial_status.dart';
import 'package:paint_car/data/models/transactions.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/shared/utils/currency_formatter.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';

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

    if (transactions.paymentStatus.name.toUpperCase() == "PENDING") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentWebViewPage(
            paymentUrl: url,
          ),
        ),
      ).then((value) {
        if (value == true && onReturnFromWebView != null) {
          onReturnFromWebView!();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    LogService.i("TRANSACTIONS ITEM: ${transactions.paymentdetail.toString()}");
    final hasVirtualAccount =
        transactions.paymentdetail?.virtualAccountNumber != null;
    final isPending =
        transactions.paymentStatus.name.toUpperCase() == "PENDING";
    final hasNote = transactions.order != null &&
        transactions.order!.isNotEmpty &&
        transactions.order!.first?.note != null &&
        transactions.order!.first!.note!.isNotEmpty;

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
        onTap: isPending && !hasVirtualAccount
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
                      const Icon(
                        Icons.receipt_long_rounded,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      MainText(
                        text: _formatDate(transactions.createdAt),
                        extent: const Medium(),
                        customTextStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
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
                        color:
                            Theme.of(context).colorScheme.onSurface.withValues(
                                  alpha: 0.7,
                                ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: MainText(
                          text: 'Metode Pembayaran: ${_getPaymentMethodName()}',
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
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: MainText(
                            text:
                                'Virtual Account: ${transactions.paymentdetail?.virtualAccountNumber}',
                          ),
                        ),
                        if (transactions.paymentdetail?.virtualAccountNumber !=
                            null)
                          IconButton(
                            icon: Icon(
                              Icons.copy_rounded,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary,
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
                                    const SnackBar(
                                      content:
                                          Text('Virtual Account number copied'),
                                      duration: Duration(seconds: 2),
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
                            text: "Catatan: ${transactions.order?.first?.note}",
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
                        const MainText(
                          text: 'Total:',
                          customTextStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                        MainText(
                          text: CurrencyFormatter.toRupiah(
                            double.parse(
                              transactions.totalPrice,
                            ),
                          ),
                          extent: const Medium(),
                          customTextStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isPending && !hasVirtualAccount)
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

class PaymentWebViewPage extends StatefulWidget {
  final String paymentUrl;

  const PaymentWebViewPage({Key? key, required this.paymentUrl})
      : super(key: key);

  @override
  State createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

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
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
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
