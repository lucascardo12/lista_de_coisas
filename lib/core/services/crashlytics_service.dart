import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class CrashlyticsService {
  static final CrashlyticsService _instance = CrashlyticsService._internal();
  factory CrashlyticsService() => _instance;
  CrashlyticsService._internal();

  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  Future<void> initialize() async {
    if (kDebugMode) {
      await _crashlytics.setCrashlyticsCollectionEnabled(false);
    } else {
      await _crashlytics.setCrashlyticsCollectionEnabled(true);
    }
  }

  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    bool fatal = false,

    List<String>? information,
  }) async {
    if (!kDebugMode) {
      await _crashlytics.recordError(
        exception,
        stack,
        fatal: fatal,
        information: information ?? [],
      );
    } else {
      log('=== ERROR (Crashlytics) ===');
      log('Exception: $exception');
      log('Stack Trace: $stack');

      if (information != null) {
        log('Information: $information');
      }
      log('==========================');
    }
  }

  Future<void> setUserIdentifier(String? userId) async {
    if (!kDebugMode && userId != null) {
      await _crashlytics.setUserIdentifier(userId);
    } else {
      log('Crashlytics: User identifier set to $userId');
    }
  }

  Future<void> setCustomKey(String key, dynamic value) async {
    if (!kDebugMode) {
      await _crashlytics.setCustomKey(key, value);
    } else {
      log('Crashlytics: Custom key set - $key: $value');
    }
  }

  Future<void> safeRecordError(
    dynamic exception,
    StackTrace? stack, {
    bool fatal = false,
    List<String>? information,
  }) async {
    try {
      await recordError(
        exception,
        stack,
        fatal: fatal,
        information: information,
      );
    } catch (e, s) {
      log('Failed to record error in Crashlytics: $e', stackTrace: s);
    }
  }
}
