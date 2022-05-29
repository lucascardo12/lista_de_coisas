import 'package:flutter/material.dart';
import 'package:listadecoisa/core/interfaces/controller_interface.dart';
import 'package:listadecoisa/modules/listas/domain/enums/status_page.dart';
import 'package:listadecoisa/modules/listas/domain/models/coisas.dart';
import 'package:listadecoisa/modules/auth/domain/models/user.dart';
import 'package:listadecoisa/core/services/banco.dart';
import 'package:listadecoisa/core/services/global.dart';

class CompartilhaController extends IController {
  final Global gb;
  final BancoFire banco;
  late Coisas lista;
  late UserP user;
  var statusPage = ValueNotifier(StatusPage.loading);
  CompartilhaController({required this.gb, required this.banco});

  @override
  void dispose() {}

  @override
  void init(BuildContext context) {
    getLista();
  }

  void getLista() async {
    var valuelist = await banco.getCoisa(
      idLista: gb.codigoList!,
      idUser: gb.codigoUser!,
    );
    lista = Coisas.fromSnapshot(valuelist);
    var valueUser = await banco.getUser(
      idUser: gb.codigoUser!,
    );
    user = UserP.fromSnapshot(valueUser);
    statusPage.value = StatusPage.done;
  }
}
