sealed class BaseState {
  final String? message;
  const BaseState({this.message});
}

class BaseInitialState extends BaseState {
  const BaseInitialState();
}

class BaseLoadingState extends BaseState {
  const BaseLoadingState();
}

class BaseErrorState extends BaseState {
  final dynamic errors;
  const BaseErrorState({
    super.message,
    this.errors,
  });
}

class BaseNoInternetState extends BaseState {
  const BaseNoInternetState(String? message) : super(message: message);
}

class BaseSuccessState<T> extends BaseState {
  final T data;
  const BaseSuccessState(this.data, String? message) : super(message: message);
}
