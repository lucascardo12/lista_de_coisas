import 'package:cloud_firestore/cloud_firestore.dart';

class Coisas {
  String nome;
  String descricao;
  String idFire;
  // List<dynamic> checklist;

  Coisas({this.nome, this.descricao, this.idFire});

  Coisas.fromJson(Map<String, dynamic> xjson) {
    nome = xjson['nome'];
    descricao = xjson['descricao'];
    idFire = xjson['idFire'];
    // checklist = xjson['checklist'];
  }

  Coisas.toMap(Map<String, dynamic> map) {
    map["nome"] = nome;
    map["descricao"] = descricao;
    map['idFire'] = idFire;
    // map['checklist'] = checklist;
  }

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'descricao': descricao,
        'idFire': idFire,
        // 'checklist': checklist.map((i) => i.toJson()).toList(),
      };

  Coisas.fromSnapshot(DocumentSnapshot snapshot) {
    nome = snapshot.data()['nome'];
    descricao = snapshot.data()["descricao"];
    idFire = snapshot.id;
    // checklist = snapshot.data()['checklist'];
  }
}

class Checklist {
  String descri;
  bool feito;
  Checklist({this.descri, this.feito});

  Checklist.fromJson(Map<String, dynamic> xjson) {
    descri = xjson['descri'];
    feito = xjson['feito'];
  }

  Checklist.toMap(Map<String, dynamic> map) {
    map["descri"] = descri;
    map["feito"] = feito;
  }

  Map<String, dynamic> toJson() => {'descri': descri, 'feito': feito};
}
