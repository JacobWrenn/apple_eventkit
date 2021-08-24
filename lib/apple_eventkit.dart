import 'dart:async';

import 'package:apple_eventkit/models/calendar.dart';
import 'package:flutter/services.dart';

class AppleEventkit {
  static const MethodChannel _channel = const MethodChannel('apple_eventkit');

  Future<bool> getAccess() async {
    final bool access = await _channel.invokeMethod('getAccess');
    return access;
  }

  Future<List<Calendar>> getCalendars() async {
    List<Calendar> calendars = [];
    final List data = await _channel.invokeListMethod('getCalendars') ?? [];
    data.forEach((element) {
      final Map<String, dynamic> map = Map.from(element);
      calendars.add(Calendar.fromJson(map));
    });
    return calendars;
  }

  Future<bool> createEvent(
      title, start, end, calendar, interval, recurrenceEnd, location) async {
    return await _channel.invokeMethod('createEvent', {
      "title": title,
      "start": start,
      "end": end,
      "calendar": calendar,
      "interval": interval,
      "recurrenceEnd": recurrenceEnd,
      "location": location,
    });
  }
}
