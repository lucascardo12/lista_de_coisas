import 'package:cloud_firestore/cloud_firestore.dart';
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
        creatAp = validationDate(xjson['creatAp']),
        updatAp = validationDate(xjson['updatAp']),
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
  static DateTime validationDate(date) {
    if (date is Timestamp) {
      return date.toDate();
    }
    if (date is String) {
      return DateTime.parse(date);
    }
    return date ?? DateTime.now();
  }
}
