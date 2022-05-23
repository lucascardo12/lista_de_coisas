import 'package:flutter/material.dart';

class AppHelps {
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                elevation: barrierColor != null ? 0 : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                title: title != null ? Text(title) : null,
                content: child,
              );
            }
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
              title: Text(title ?? ''),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(content ?? ''),
                  ],
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
}
