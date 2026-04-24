import 'dart:async';

enum AuthEventType { sessionExpired }

class AuthEventBus {
  static final AuthEventBus _instance = AuthEventBus._internal();
  factory AuthEventBus() => _instance;
  AuthEventBus._internal();

  final _controller = StreamController<AuthEventType>.broadcast();
  Stream<AuthEventType> get stream => _controller.stream;

  void emit(AuthEventType event) {
    _controller.add(event);
  }
}
