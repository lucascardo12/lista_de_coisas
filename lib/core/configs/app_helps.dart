import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class AppHelps {
  static final translator = GoogleTranslator();
  static Future<bool> defaultDialog({
    required BuildContext context,
    String? content,
    String? title,
    Widget? child,
    Color? barrierColor,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            if (child != null) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                elevation: barrierColor != null ? 0 : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                title: title != null ? Text(title) : null,
                content: SafeArea(child: child),
              );
            }
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              title: Text(title ?? ''),
              content: SingleChildScrollView(
                child: SafeArea(
                  child: ListBody(children: [Text(content ?? '')]),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, right: 8),
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, right: 8),
                  child: TextButton(
                    child: const Text('Ok'),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  static void showErrorDialog(BuildContext context, Object error) async {
    String errorMessage = error.toString();
    if (error is FirebaseAuthException && error.message != null) {
      errorMessage = error.message!;
      try {
        final auxi = await translator.translate(
          errorMessage,
          from: 'en',
          to: 'pt',
        );
        errorMessage = auxi.text;
      } catch (e) {
        log('Erro ao traduzir mensagem de erro: $e');
      }
    }
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    }
  }
}
