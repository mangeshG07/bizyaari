import 'dart:collection';

class PopupManager {
  static final PopupManager _instance = PopupManager._internal();
  factory PopupManager() => _instance;
  PopupManager._internal();

  bool _isShowing = false;
  final Queue<Future<void> Function()> _queue = Queue();

  void add(Future<void> Function() popup) {
    _queue.add(popup);
    _processQueue();
  }

  void _processQueue() async {
    if (_isShowing || _queue.isEmpty) return;

    _isShowing = true;

    final popup = _queue.removeFirst();
    await popup();

    _isShowing = false;

    _processQueue();
  }

  /// Optional (pro use)
  Future<void> waitUntilDone() async {
    while (_isShowing || _queue.isNotEmpty) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }
}
