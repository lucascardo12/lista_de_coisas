import 'package:cloud_firestore/cloud_firestore.dart';

class UserP {
  String id;
  String nome;
  String senha;
  String login;
  UserP({this.id, this.nome, this.login, this.senha});

  UserP.fromJson(Map<String, dynamic> xjson) {
    nome = xjson['nome'];
    id = xjson['id'];
    login = xjson['login'];
  }

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'id': id,
        'login': login,
      };
  UserP.toMap(Map<String, dynamic> map) {
    map["nome"] = nome;
    map["id"] = id;
    map['login'] = login;
  }

  UserP.fromSnapshot(DocumentSnapshot snapshot) {
    nome = snapshot.get('nome');
    login = snapshot.get("login");
    id = snapshot.id;
  }
}
