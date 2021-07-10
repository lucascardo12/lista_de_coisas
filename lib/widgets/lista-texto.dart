import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listadecoisa/controller/listas-controller.dart';
import 'package:listadecoisa/model/coisas.dart';
import 'package:listadecoisa/services/global.dart';
import 'package:listadecoisa/widgets/borda-padrao.dart';

class ListaTexto extends GetView {
  final gb = Get.find<Global>();
  final ListasController ct;
  final bool isComp;

  ListaTexto({
    required this.ct,
    required this.isComp,
  });
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(10),
      shrinkWrap: true,
      children: [
        TextFormField(
          readOnly: isComp,
          validator: (value) {
            if (value!.isEmpty) return "Conteudo não pode ser vazio";
            return null;
          },
          focusNode: ct.nodeText1,
          autofocus: ct.coisas.descricao!.isEmpty ? true : false,
          maxLines: 300,
          initialValue: ct.coisas.descricao ?? '',
          onChanged: (value) => ct.coisas.descricao = value,
          minLines: 20,
          cursorColor: Colors.white,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: BordaPadrao.build(),
            enabledBorder: BordaPadrao.build(),
            focusedBorder: BordaPadrao.build(),
            hintStyle: TextStyle(color: Colors.white),
            alignLabelWithHint: true,
            labelText: 'Conteudo da lista',
            labelStyle: TextStyle(color: Colors.white, fontSize: 18),
          ),
        )
      ],
    );
  }
}
