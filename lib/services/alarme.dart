import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:get/get.dart';
import 'package:listadecoisa/services/notificacao.dart';

class AlarmeLista extends GetxService {
  Future<AlarmeLista> inicia() async {
    await AndroidAlarmManager.initialize();

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

  Future<void> teste() async {
    try {
      await AndroidAlarmManager.periodic(Duration(minutes: 2), 2, notifica);
    } catch (e) {
      print(e.toString());
    }
  }

  static void notifica() async {
    var noti = await Get.putAsync(() => NotificacaoLista().inicia());
    noti.teste();
  }
}
