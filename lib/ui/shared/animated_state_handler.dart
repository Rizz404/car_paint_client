import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/ui/shared/state_handler.dart';

class AnimatedStateHandler<C extends Cubit<BaseState>, T>
    extends StatefulWidget {
  final Widget Function(BuildContext context, T data, String? message)
      onSuccess;
  final VoidCallback onRetry;
  final bool show;

  const AnimatedStateHandler({
    super.key,
    required this.onSuccess,
    required this.onRetry,
    required this.show,
  });

  @override
  State<AnimatedStateHandler<C, T>> createState() =>
      _AnimatedStateHandlerState<C, T>();
}

class _AnimatedStateHandlerState<C extends Cubit<BaseState>, T>
    extends State<AnimatedStateHandler<C, T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _hasRequested = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    if (widget.show) {
      _controller.forward();
      _performRequest();
    }
  }

  void _performRequest() {
    if (!_hasRequested && widget.show) {
      widget.onRetry();
      _hasRequested = true;
    }
  }

  @override
  void didUpdateWidget(AnimatedStateHandler<C, T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show != oldWidget.show) {
      if (widget.show) {
        _controller.forward();
        _hasRequested = false;
        _performRequest();
      } else {
        _controller.reverse();
        _hasRequested = false;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.show) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Visibility(
          visible: _animation.value > 0,
          child: Opacity(
            opacity: _animation.value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - _animation.value)),
              child: child,
            ),
          ),
        );
      },
      child: StateHandler<C, T>(
        onSuccess: widget.onSuccess,
        onRetry: widget.onRetry,
      ),
    );
  }
}
