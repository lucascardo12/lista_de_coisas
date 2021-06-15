import 'package:cloud_firestore/cloud_firestore.dart';

class Compartilha {
  String idFire;
  String idUser;
  String idLista;
  bool isRead;
  Compartilha({this.idUser, this.idLista, this.isRead, this.idFire});

  Compartilha.fromJson(Map<String, dynamic> xjson) {
    idUser = xjson['idUser'];
    idLista = xjson['idLista'];
    isRead = xjson['isRead'];
    idFire = xjson['idFire'];
  }

  Compartilha.toMap(Map<String, dynamic> map) {
    map['idUser'] = idUser;
    map['idLista'] = idLista;
    map['isRead'] = isRead;
    map['idFire'] = idFire;
  }
  Compartilha.fromSnapshot(DocumentSnapshot snapshot) {
    idUser = snapshot.get('idUser');
    idLista = snapshot.get('idLista');
    isRead = snapshot.get('isRead');
    idFire = snapshot.id;
  }

  Map<String, dynamic> toJson() => {'idUser': idUser, 'idLista': idLista, 'isRead': isRead, 'idFire': idFire};
}
