import 'package:cloud_firestore/cloud_firestore.dart';

class UserP {
  String id;
  String nome;
  String senha;
  String login;
  List<Compartilha> listaComp;
  UserP({this.id, this.nome, this.login, this.senha, this.listaComp});

  UserP.fromJson(Map<String, dynamic> xjson) {
    nome = xjson['nome'];
    id = xjson['id'];
    listaComp = xjson['listaComp'];
    login = xjson['login'];
  }

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'id': id,
        'login': login,
        if (listaComp != null) 'listaComp': listaComp.map((i) => i.toJson()).toList(),
      };
  UserP.toMap(Map<String, dynamic> map) {
    map["nome"] = nome;
    map["id"] = id;
    map['login'] = login;
    map['checklist'] = listaComp;
  }

  UserP.fromSnapshot(DocumentSnapshot snapshot) {
    nome = snapshot.data()['nome'];
    login = snapshot.data()["login"];
    id = snapshot.id;
    if (snapshot.data()['listaComp'] != null)
      listaComp = snapshot.data()['listaComp'].map((i) => new Compartilha.fromJson(i)).toList();
  }
}

class Compartilha {
  String idUser;
  String idLista;
  bool isRead;
  Compartilha({this.idUser, this.idLista, this.isRead});

  Compartilha.fromJson(Map<String, dynamic> xjson) {
    idUser = xjson['idUser'];
    idLista = xjson['idLista'];
    isRead = xjson['isRead'];
  }

  Compartilha.toMap(Map<String, dynamic> map) {
    map['idUser'] = idUser;
    map['idLista'] = idLista;
    map['isRead'] = isRead;
  }

  Map<String, dynamic> toJson() => {'idUser': idUser, 'idLista': idLista, 'isRead': isRead};
}
