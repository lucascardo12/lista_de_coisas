import 'package:listadecoisa/core/interfaces/model_inter.dart';

class Compartilha implements IModel {
  String idUser;
  String idLista;
  bool isRead;

  @override
  String? idFire;

  @override
  DateTime creatAp;

  @override
  DateTime updatAp;

  Compartilha({
    this.idFire,
    required this.idUser,
    required this.idLista,
    required this.isRead,
    required this.creatAp,
    required this.updatAp,
  });

  Compartilha.fromJson(Map<String, dynamic> xjson)
      : idUser = xjson['idUser'],
        idLista = xjson['idLista'],
        isRead = xjson['isRead'],
        creatAp = xjson['creatAp'],
        updatAp = xjson['updatAp'],
        idFire = xjson['idFire'];

  @override
  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'idLista': idLista,
        'isRead': isRead,
        'idFire': idFire,
        'updatAp': updatAp,
        'creatAp': creatAp,
      };
}
