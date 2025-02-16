import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paint_car/data/models/enums/financial_status.dart';
import 'package:paint_car/data/models/transactions.dart';
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
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () => _handleTap(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Baris atas: Payment Status (dengan warna) dan Tanggal Transaksi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildPaymentStatusWidget(transactions.paymentStatus),
                  MainText(
                    text: _formatDate(transactions.createdAt),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              MainText(
                text: 'Invoice: ${transactions.invoiceId}',
              ),
              const SizedBox(height: 8),
              // Baris: Metode Pembayaran dan Total Harga
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MainText(
                    text: 'Method: ${transactions.paymentMethod?.name ?? "-"}',
                  ),
                  MainText(
                    text: 'Total: ${transactions.totalPrice}',
                  ),
                ],
              ),
              const Divider(height: 20, thickness: 1),
              // Ringkasan order jika ada
              if (transactions.order != null && transactions.order!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MainText(
                      text: 'Order Details:',
                    ),
                    // if (transactions.order!.first!.note != null &&
                    //     transactions.order!.first!.note!.isNotEmpty)
                    //   MainText(
                    //     text: 'Note: ${transactions.order!.first!.note}',
                    //   ),
                  ],
                ),
            ],
          ),
        ),
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
      child: Text(
        status.name,
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.bold,
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
          onProgress: (int progress) {
            // Update loading bar jika diperlukan
          },
          onPageStarted: (String url) {
            // Logika ketika halaman mulai dimuat
          },
          onPageFinished: (String url) {
            // Logika ketika halaman selesai dimuat
          },
          onNavigationRequest: (NavigationRequest request) {
            // Contoh: mencegah navigasi ke URL tertentu
            // if (request.url.startsWith('https://www.youtube.com/')) {
            //   return NavigationDecision.prevent;
            // }
            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            // Tangani error di sini jika diperlukan
          },
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
