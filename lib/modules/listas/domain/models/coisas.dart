import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listadecoisa/core/interfaces/model_inter.dart';
import 'package:listadecoisa/modules/listas/domain/models/check_list.dart';
import 'package:listadecoisa/modules/listas/domain/models/ckeck_compras.dart';
import 'package:listadecoisa/modules/listas/domain/enums/type_list.dart';

class Coisas implements IModel {
  static String idCollection = 'coisas';
  String nome;
  String descricao;
  Map<String, dynamic>? conteudoRich;
  TypeList tipo;
  List<Checklist> checklist;
  List<CheckCompras> checkCompras;

  @override
  DateTime creatAp;

  @override
  DateTime updatAp;

  @override
  String? idFire;

  Coisas({
    this.idFire,
    required this.nome,
    required this.descricao,
    this.conteudoRich,
    required this.checkCompras,
    required this.checklist,
    required this.tipo,
    required this.creatAp,
    required this.updatAp,
  });

  Coisas.fromJson(Map<String, dynamic> xjson)
    : nome = xjson['nome'] ?? '',
      descricao = xjson['descricao'] ?? '',
      conteudoRich = xjson['conteudoRich'] as Map<String, dynamic>?,
      idFire = xjson['idFire'],
      checklist = (xjson['checklist'] ?? [])
          .map<Checklist>((i) => Checklist.fromJson(i))
          .toList(),
      checkCompras = (xjson['checkCompras'] ?? [])
          .map<CheckCompras>((i) => CheckCompras.fromJson(i))
          .toList(),
      creatAp = validationDate(xjson['creatAp']),
      updatAp = validationDate(xjson['updatAp']),
      tipo = TypeList.fromString(xjson['tipo']);

  @override
  Map<String, dynamic> toJson() => {
    'nome': nome,
    'descricao': descricao,
    'conteudoRich': conteudoRich,
    'idFire': idFire,
    'checklist': checklist.map((i) => i.toJson()).toList(),
    'checkCompras': checkCompras.map((e) => e.toJson()).toList(),
    'tipo': tipo.index,
    'creatAp': creatAp,
    'updatAp': updatAp,
  };

  static DateTime validationDate(dynamic date) {
    if (date is Timestamp) {
      return date.toDate();
    }
    if (date is String) {
      return DateTime.parse(date);
    }
    return date ?? DateTime.now();
  }

  Coisas copyWith() {
    return Coisas(
      checkCompras: checkCompras.map((e) => e.copy()).toList(),
      checklist: checklist.map((e) => e.copy()).toList(),
      creatAp: creatAp,
      updatAp: updatAp,
      nome: nome,
      descricao: descricao,
      conteudoRich: conteudoRich != null
          ? Map<String, dynamic>.from(conteudoRich!)
          : null,
      tipo: tipo,
      idFire: idFire,
    );
  }

  Coisas.empty()
    : this(
        nome: '',
        descricao: '',
        conteudoRich: null,
        checkCompras: [],
        checklist: [],
        tipo: TypeList.text,
        creatAp: DateTime.now(),
        updatAp: DateTime.now(),
      );
}
