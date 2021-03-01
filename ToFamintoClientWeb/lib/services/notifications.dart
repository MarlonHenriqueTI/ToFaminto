import 'dart:async';
import 'package:firebase/firebase.dart' as firebase;

class Messaging {
  Messaging._();
  static Messaging _instance = Messaging._();
  static Messaging get instance => _instance;
  firebase.Messaging _mc;
  bool _initialized = false;

  final _streamController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get stream => _streamController.stream;

  void close() {
    _streamController?.close();
  }

  Future<void> init() async {
    if (!_initialized) {
      _mc = firebase.messaging();
      _mc.usePublicVapidKey(
          'BCsNlzcTRqCRxQw-m_dVnjOD4jRxtt6IxOwStkfYx8wqKKBwhWVinQAd6k-syLsGb5IDntC4Q_tMsNNhKMKIntU');
      _mc.onMessage.listen((event) {
        _streamController.add(event?.data);
      });
      _initialized = true;
    }
  }

  Future requestPermission() {
    return _mc.requestPermission();
  }

  Future<String> getToken() async {
    return await _mc.getToken();
  }
}
