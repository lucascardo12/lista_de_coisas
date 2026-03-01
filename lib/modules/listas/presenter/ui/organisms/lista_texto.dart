import 'package:flutter/material.dart';
import 'package:listadecoisa/modules/listas/presenter/controllers/listas_controller.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/core/design_system/list_system_field.dart';

class ListaTexto extends StatelessWidget {
  final Global gb;
  final ListasController ct;

  const ListaTexto({super.key, required this.ct, required this.gb});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(10),
      shrinkWrap: true,
      children: [
        ListSystemField(
          hintText: 'Conteudo da lista',
          initialValue: ct.coisas!.descricao,
          autofocus: ct.coisas!.descricao.isEmpty ? true : false,
          maxLines: 300,
          minLines: 20,
          textAlign: TextAlign.center,
          validator: (value) {
            if (value!.isEmpty) return 'Conteudo não pode ser vazio';
            return null;
          },
          onChanged: (value) => ct.coisas!.descricao = value,
        ),
      ],
    );
  }
}
