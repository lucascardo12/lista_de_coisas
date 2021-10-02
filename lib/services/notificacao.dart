import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificacaoLista extends GetxService {
  Future<NotificacaoLista> inicia() async {
    await inicializa();
    await verificaPermissao();
    return this;
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> inicializa() async {
    await AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      'resource://drawable/launcher_icon',
      [
        NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
    );
  }

  Future<void> verificaPermissao() async {
    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) async {
        if (!isAllowed) {
          // Insert here your friendly dialog box before call the request method
          // This is very important to not harm the user experience
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );
  }

  void teste() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: 'Simple Notification',
        body: 'Simple body',
      ),
    );
  }
}
