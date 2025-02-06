import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/template/cubit/template_cubit.dart';
import 'package:paint_car/ui/shared/error_state_widget.dart';
import 'package:paint_car/ui/shared/loading.dart';
import 'package:paint_car/ui/shared/no_internet.dart';

class StateHandler extends StatefulWidget {
  const StateHandler(
      {super.key, required this.onSuccess, required this.onRetry,});
  final Widget Function(BuildContext context, BaseState state) onSuccess;
  final VoidCallback onRetry;

  @override
  State<StateHandler> createState() => _StateHandlerState();
}

class _StateHandlerState extends State<StateHandler> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TemplateCubit, BaseState>(
      builder: (context, state) {
        return switch (state) {
          BaseInitialState() => const Loading(),
          BaseLoadingState() => const Loading(),
          BaseSuccessState() => widget.onSuccess(context, state),
          BaseErrorState() => ErrorStateWidget(
              message: state.message ?? ApiConstant.unknownError,
              onRetry: widget.onRetry,),
          BaseNoInternetState() => NoInternet(
              onRetry: widget.onRetry,
            )
        };
      },
    );
  }
}
