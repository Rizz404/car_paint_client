import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/ui/shared/error_state_widget.dart';
import 'package:paint_car/ui/shared/loading.dart';
import 'package:paint_car/ui/shared/no_internet.dart';

class StateHandler<C extends Cubit<BaseState>, T> extends StatefulWidget {
  final Widget Function(BuildContext context, T data, String? message)
      onSuccess;
  final VoidCallback onRetry;

  const StateHandler({
    super.key,
    required this.onSuccess,
    required this.onRetry,
  });

  @override
  State<StateHandler<C, T>> createState() => _StateHandlerState<C, T>();
}

class _StateHandlerState<C extends Cubit<BaseState>, T>
    extends State<StateHandler<C, T>> {
  bool _isRetrying = false;

  void _handleRetry() async {
    if (_isRetrying) return;

    setState(() {
      _isRetrying = true;
    });

    try {
      widget.onRetry();
    } finally {
      if (mounted) {
        setState(() {
          _isRetrying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<C, BaseState>(
      builder: (context, state) {
        return switch (state) {
          BaseInitialState() => const Loading(),
          BaseLoadingState() => const Loading(),
          BaseSuccessState<T>(:final data, :final message) =>
            widget.onSuccess(context, data, message),
          BaseErrorState(:final message) => ErrorStateWidget(
              message: message ?? "Error",
              onRetry: _handleRetry,
              isRetrying: _isRetrying,
            ),
          BaseNoInternetState() => NoInternet(
              onRetry: _handleRetry,
              isRetrying: _isRetrying,
            ),
          BaseState() => const Loading(),
        };
      },
    );
  }
}
