import 'package:flutter/material.dart';

/// Reusable widget untuk bagian expandable yang membungkus konten dengan efek expand/collapse.
class ExpandableCard extends StatefulWidget {
  /// Builder untuk header yang menerima parameter [isExpanded] agar bisa menyesuaikan tampilannya.
  final Widget Function(bool isExpanded) headerBuilder;

  /// Widget yang akan tampil ketika bagian expandable terbuka.
  final Widget expandedContent;

  /// Durasi animasi saat expand/collapse.
  final Duration duration;

  /// Status awal apakah sudah terbuka atau belum.
  final bool initiallyExpanded;

  const ExpandableCard({
    Key? key,
    required this.headerBuilder,
    required this.expandedContent,
    this.duration = const Duration(milliseconds: 300),
    this.initiallyExpanded = false,
  }) : super(key: key);

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  late bool isExpanded;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.initiallyExpanded;
  }

  void toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header yang bisa ditekan untuk toggle expand/collapse
          InkWell(
            onTap: toggleExpansion,
            child: widget.headerBuilder(isExpanded),
          ),
          // Konten yang akan tampil secara animated ketika di-expand
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: widget.expandedContent,
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: widget.duration,
          ),
        ],
      ),
    );
  }
}
