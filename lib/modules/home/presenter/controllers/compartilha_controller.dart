import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:listadecoisa/core/interfaces/controller_interface.dart';
import 'package:listadecoisa/core/interfaces/remote_database_inter.dart';
import 'package:listadecoisa/modules/home/domain/models/compartilha.dart';
import 'package:listadecoisa/modules/home/domain/models/compartilha_params.dart';
import 'package:listadecoisa/modules/home/domain/repositories/compartilha_repository_inter.dart';
import 'package:listadecoisa/modules/listas/domain/enums/status_page.dart';
import 'package:listadecoisa/modules/listas/domain/models/coisas.dart';
import 'package:listadecoisa/modules/auth/domain/models/user.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/modules/listas/domain/repositories/coisas_repository_inter.dart';

class CompartilhaController extends IController {
  final Global gb;
  final ICompartilhaRepository compartilhaRepository;
  final ICoisasRepository coisasRepository;
  final IRemoteDataBase remoteDataBase;
  late Coisas lista;
  late UserP user;
  CompartilharParams? argumts;
  var statusPage = ValueNotifier(StatusPage.loading);

  CompartilhaController({
    required this.gb,
    required this.compartilhaRepository,
    required this.coisasRepository,
    required this.remoteDataBase,
  });

  @override
  void dispose() {
    statusPage.dispose();
  }

  @override
  void init(BuildContext context) {
    argumts = ModalRoute.of(context)!.settings.arguments as CompartilharParams;
    getLista();
  }

  void getLista() async {
    if (argumts != null) {
      var valuelist = await coisasRepository.get(
        idDoc: argumts!.codigoList,
        idUser: argumts!.codigoUser,
      );
      lista = valuelist!;
      var valueUser = await remoteDataBase.getUser(argumts!.codigoUser);
      user = valueUser!;
      statusPage.value = StatusPage.done;
    }
  }

  Future<void> salvarComp(BuildContext context) async {
    var comp = Compartilha(
      creatAp: DateTime.now(),
      updatAp: DateTime.now(),
      idLista: argumts!.codigoList,
      idUser: argumts!.codigoUser,
      isRead: argumts!.codigRead == 'true' ? true : false,
    );
    var ret = await compartilhaRepository.list(idUser: comp.idUser);
    if (ret.where((element) => element.idLista == comp.idLista && element.idUser == comp.idUser).isEmpty) {
      await compartilhaRepository.createUpdate(idUser: gb.usuario!.id!, object: comp);
    } else {
      await Fluttertoast.showToast(
          msg: "A lista já foi salva!!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 18.0);
    }
    Navigator.pop(context);
  }
}
