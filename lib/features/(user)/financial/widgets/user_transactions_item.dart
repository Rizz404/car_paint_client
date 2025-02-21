import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paint_car/data/models/enums/financial_status.dart';
import 'package:paint_car/data/models/transactions.dart';
import 'package:paint_car/features/shared/utils/currency_formatter.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/extension/padding.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

  void _handleTap(BuildContext context) {
    if (transactions.paymentStatus.name.toUpperCase() == "PENDING") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentWebViewPage(
            paymentUrl: transactions.paymentInvoiceUrl,
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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 1,
      color: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () => _handleTap(context),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MainText(
                  text: _formatDate(transactions.createdAt),
                  extent: const Medium(),
                  customTextStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                  color: Theme.of(context).colorScheme.primary,
                ),
                buildPaymentStatusWidget(transactions.paymentStatus),
              ],
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Theme.of(context).colorScheme.surfaceDim,
            ),
            MainText(
              text: 'Invoice: ${transactions.invoiceId}',
            ),
            MainText(
              text: 'Method: ${transactions.paymentMethod?.name ?? "-"}',
            ),
            const SizedBox(
              height: 4,
            ),
            Divider(
              thickness: 1,
              height: 1,
              color: Theme.of(context).colorScheme.surfaceDim,
            ),
            Row(
              children: [
                const Expanded(
                  child: MainText(
                    text: 'Total:',
                    extent: Medium(),
                  ),
                ),
                Expanded(
                  child: MainText(
                    text: CurrencyFormatter.toRupiah(
                      int.parse(
                        transactions.totalPrice,
                      ),
                    ),
                    textAlign: TextAlign.end,
                    extent: const Medium(),
                    customTextStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            // const Divider(height: 20, thickness: 1),
            // if (transactions.order != null ||
            //     transactions.order?.first!.note!.isNotEmpty == true)
            //   Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       MainText(
            //         text: "Note: ${transactions.order?.first?.note}",
            //       ),
            //     ],
            //   ),
          ],
        ).paddingSymmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Color getPaymentStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.SUCCESS:
        return Colors.green;
      case PaymentStatus.PENDING:
        return Colors.amber;
      case PaymentStatus.FAILED:
        return Colors.red;
      case PaymentStatus.EXPIRED:
        return Colors.grey;
      case PaymentStatus.REFUNDED:
        return Colors.blue;
    }
  }

  Widget buildPaymentStatusWidget(PaymentStatus status) {
    final Color statusColor = getPaymentStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withValues(
          alpha: 0.2,
        ),
        border: Border.all(color: statusColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: MainText(
        text: status.name,
        customTextStyle: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class PaymentWebViewPage extends StatefulWidget {
  final String paymentUrl;
  const PaymentWebViewPage({Key? key, required this.paymentUrl})
      : super(key: key);

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, true),
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
