import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class CrashlyticsService {
  static final CrashlyticsService _instance = CrashlyticsService._internal();
  factory CrashlyticsService() => _instance;
  CrashlyticsService._internal();

  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  // Inicializa o Crashlytics com configurações adicionais
  Future<void> initialize() async {
    // Em modo debug, desativa o Crashlytics para não poluir os dados
    if (kDebugMode) {
      await _crashlytics.setCrashlyticsCollectionEnabled(false);
    } else {
      await _crashlytics.setCrashlyticsCollectionEnabled(true);
    }
  }

  // Registra um erro com contexto adicional
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
      // Em debug, apenas imprime no console
      if (kDebugMode) {
        print('=== ERROR (Crashlytics) ===');
        print('Exception: $exception');
        print('Stack Trace: $stack');

        if (information != null) {
          print('Information: $information');
        }
        print('==========================');
      }
    }
  }

  // Registra uma mensagem de log personalizada
  Future<void> log(String message) async {
    if (!kDebugMode) {
      await _crashlytics.log(message);
    } else {
      if (kDebugMode) {
        print('Crashlytics Log: $message');
      }
    }
  }

  // Define o identificador do usuário
  Future<void> setUserIdentifier(String? userId) async {
    if (!kDebugMode && userId != null) {
      await _crashlytics.setUserIdentifier(userId);
    } else {
      if (kDebugMode) {
        print('Crashlytics: User identifier set to $userId');
      }
    }
  }

  // Define atributos personalizados do usuário
  Future<void> setCustomKey(String key, dynamic value) async {
    if (!kDebugMode) {
      await _crashlytics.setCustomKey(key, value);
    } else {
      if (kDebugMode) {
        print('Crashlytics: Custom key set - $key: $value');
      }
    }
  }

  // Registra erro de forma segura com try-catch interno
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
    } catch (e) {
      // Se falhar ao registrar no Crashlytics, apenas loga no console
      if (kDebugMode) {
        print('Failed to record error in Crashlytics: $e');
      }
    }
  }
}
