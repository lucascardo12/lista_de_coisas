import 'package:listadecoisa/core/interfaces/model_inter.dart';
import 'package:listadecoisa/modules/listas/domain/models/check_list.dart';
import 'package:listadecoisa/modules/listas/domain/models/ckeck_compras.dart';

class Coisas implements IModel {
  String nome;
  String descricao;
  int tipo;
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
    required this.checkCompras,
    required this.checklist,
    required this.tipo,
    required this.creatAp,
    required this.updatAp,
  });

  Coisas.fromJson(Map<String, dynamic> xjson)
      : nome = xjson['nome'],
        descricao = xjson['descricao'],
        idFire = xjson['idFire'],
        checklist = xjson['checklist'].map((i) => Checklist.fromJson(i)).toList(),
        checkCompras = xjson['checkCompras'].map((i) => CheckCompras.fromJson(i)).toList(),
        creatAp = xjson['creatAp'],
        updatAp = xjson['updatAp'],
        tipo = xjson['tipo'];

  @override
  Map<String, dynamic> toJson() => {
        'nome': nome,
        'descricao': descricao,
        'idFire': idFire,
        'checklist': checklist.map((i) => i.toJson()).toList(),
        'checkCompras': checkCompras.map((e) => e.toJson()).toList(),
        'tipo': tipo,
        'creatAp': creatAp,
        'updatAp': updatAp,
      };
}
