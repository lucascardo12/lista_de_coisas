import 'package:get/get.dart';
import 'package:listadecoisa/model/coisas.dart';
import 'package:listadecoisa/model/user.dart';
import 'package:listadecoisa/services/banco.dart';
import 'package:listadecoisa/services/global.dart';

class CompartilhaController extends GetxController {
  final gb = Get.find<Global>();
  final banco = Get.find<BancoFire>();
  late Coisas lista;
  late UserP user;
  @override
  void onInit() {
    gb.isLoading = true;
    getLista();
    super.onInit();
  }

  getLista() async {
    await banco.getCoisa(idLista: gb.codigoList!, idUser: gb.codigoUser!).then((value) {
      gb.isLoading = false;
      lista = Coisas.fromSnapshot(value);
    });
    await banco.getUser(idUser: gb.codigoUser!).then((value) {
      gb.isLoading = false;
      user = UserP.fromSnapshot(value);
    });
  }
}
