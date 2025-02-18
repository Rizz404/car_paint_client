class CancelToken {
  bool _isCancelled = false;
  bool get isCancelled => _isCancelled;
  void cancel() => _isCancelled = true;
}

mixin Cancelable {
  final CancelToken cancelToken = CancelToken();

  void cancelRequests() {
    cancelToken.cancel();
  }
}
