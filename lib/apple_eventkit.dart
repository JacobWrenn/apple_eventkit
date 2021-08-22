import 'dart:async';

import 'package:flutter/services.dart';

class AppleEventkit {
  static const MethodChannel _channel = const MethodChannel('apple_eventkit');

  Future<bool> getAccess() async {
    final bool access = await _channel.invokeMethod('getAccess');
    return access;
  }
}
