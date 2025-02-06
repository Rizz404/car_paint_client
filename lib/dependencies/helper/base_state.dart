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
  const BaseErrorState(String message) : super(message: message);
}

class BaseNoInternetState extends BaseState {
  const BaseNoInternetState(String message) : super(message: message);
}

class BaseSuccessState<T> extends BaseState {
  final T data;
  const BaseSuccessState(this.data, String message) : super(message: message);
}
