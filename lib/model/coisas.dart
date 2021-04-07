import 'package:cloud_firestore/cloud_firestore.dart';

class Coisas {
  String nome;
  String descricao;
  String idFire;
  int tipo;
  List<dynamic> checklist;
  List<dynamic> checkCompras;

  Coisas({this.nome, this.descricao, this.idFire, this.checkCompras, this.checklist, this.tipo});

  Coisas.fromJson(Map<String, dynamic> xjson) {
    nome = xjson['nome'];
    descricao = xjson['descricao'];
    idFire = xjson['idFire'];
    checklist = xjson['checklist'];
    checkCompras = xjson['checkCompras'];
    tipo = xjson['tipo'];
  }

  Coisas.toMap(Map<String, dynamic> map) {
    map["nome"] = nome;
    map["descricao"] = descricao;
    map['idFire'] = idFire;
    map['checklist'] = checklist;
    map['tipo'] = tipo;
    map['checkCompras'] = checkCompras;
  }

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'descricao': descricao,
        'idFire': idFire,
        if (checklist != null) 'checklist': checklist.map((i) => i.toJson()).toList(),
        if (checkCompras != null) 'checkCompras': checkCompras.map((e) => e.toJson()).toList(),
        'tipo': tipo,
      };

  Coisas.fromSnapshot(DocumentSnapshot snapshot) {
    nome = snapshot.data()['nome'];
    descricao = snapshot.data()["descricao"];
    idFire = snapshot.id;
    if (snapshot.data()['checklist'] != null)
      checklist = snapshot.data()['checklist'].map((i) => new Checklist.fromJson(i)).toList();
    if (snapshot.data()['checkCompras'] != null)
      checkCompras = snapshot.data()['checkCompras'].map((i) => new CheckCompras.fromJson(i)).toList();
    tipo = snapshot.data()['tipo'];
  }
}

class Checklist {
  String item;
  bool feito;
  Checklist({this.item, this.feito});

  Checklist.fromJson(Map<String, dynamic> xjson) {
    item = xjson['descri'];
    feito = xjson['feito'];
  }

  Checklist.toMap(Map<String, dynamic> map) {
    map["descri"] = item;
    map["feito"] = feito;
  }

  Map<String, dynamic> toJson() => {'descri': item, 'feito': feito};
}

class CheckCompras {
  String item;
  bool feito;
  int quant;
  double valor;
  CheckCompras({this.item, this.feito, this.quant, this.valor});

  CheckCompras.fromJson(Map<String, dynamic> xjson) {
    item = xjson['descri'];
    feito = xjson['feito'];
    quant = xjson['quant'];
    valor = xjson['valor'];
  }

  CheckCompras.toMap(Map<String, dynamic> map) {
    map["descri"] = item;
    map["feito"] = feito;
    map['quant'] = quant;
    map['valor'] = valor;
  }

  Map<String, dynamic> toJson() => {'descri': item, 'feito': feito, 'quant': quant, 'valor': valor};
}
