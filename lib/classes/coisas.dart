import 'package:cloud_firestore/cloud_firestore.dart';

class Coisas {
  String nome;
  String descricao;
  String idFire;

  Coisas({String nome, String descricao, String idFire}) {
    this.nome = nome;
    this.descricao = descricao;
    this.idFire = idFire;
  }
  Coisas.fromJson(Map<String, dynamic> xjson) {
    nome = xjson['nome'];
    descricao = xjson['descricao'];
    idFire = xjson['idFire'];
  }

  Coisas.toMap(Map<String, dynamic> map) {
    map["nome"] = nome;
    map["descricao"] = descricao;
    map['idFire'] = idFire;
  }

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'descricao': descricao,
        'idFire': idFire,
      };

  Coisas.fromSnapshot(DocumentSnapshot snapshot) {
    nome = snapshot.data()['nome'];
    descricao = snapshot.data()["descricao"];
    idFire = snapshot.id;
  }
}
