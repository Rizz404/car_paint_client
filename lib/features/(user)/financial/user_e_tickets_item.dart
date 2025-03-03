// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paint_car/data/models/e_ticket.dart';

class UserETicketsItem extends StatefulWidget {
  final ETicket ticket;
  const UserETicketsItem({
    super.key,
    required this.ticket,
  });

  @override
  State<UserETicketsItem> createState() => _UserETicketsItemState();
}

class _UserETicketsItemState extends State<UserETicketsItem> {
  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd MMM yyyy, HH:mm').addPattern("'UTC'").format(date);
  }

  String _truncateId(String id) {
    if (id.length < 15) return id;
    return '${id.substring(0, 10)}...${id.substring(id.length - 5)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: theme.colorScheme.primary,
              width: 4,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      "E-Ticket #${widget.ticket.ticketNumber}",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Divider
              Divider(
                color: theme.dividerColor.withValues(alpha: 0.2),
                height: 1,
              ),
              const SizedBox(height: 12),

              // Order Details
              widget.ticket.orderId != null
                  ? _buildDetailRow(
                      icon: Icons.receipt_long_outlined,
                      label: "Order ID:",
                      value: _truncateId(widget.ticket.orderId!),
                      theme: theme,
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 8),

              _buildDetailRow(
                icon: Icons.calendar_month_outlined,
                label: "Created:",
                value: _formatDate(widget.ticket.createdAt),
                theme: theme,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.primary.withValues(alpha: 0.8),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: "$label ",
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
