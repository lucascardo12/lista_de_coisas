import 'package:flutter/material.dart';
import 'package:listadecoisa/modules/listas/presenter/controllers/listas_controller.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/modules/home/presenter/ui/atoms/borda_padrao.dart';

class ListaTexto extends StatelessWidget {
  final Global gb;
  final ListasController ct;

  const ListaTexto({
    super.key,
    required this.ct,
    required this.gb,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(10),
      shrinkWrap: true,
      children: [
        TextFormField(
          readOnly: ct.isComp!,
          validator: (value) {
            if (value!.isEmpty) return 'Conteudo não pode ser vazio';
            return null;
          },
          focusNode: ct.nodeText1,
          autofocus: ct.coisas!.descricao.isEmpty ? true : false,
          maxLines: 300,
          initialValue: ct.coisas!.descricao,
          onChanged: (value) => ct.coisas!.descricao = value,
          minLines: 20,
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: BordaPadrao.build(),
            enabledBorder: BordaPadrao.build(),
            focusedBorder: BordaPadrao.build(),
            hintStyle: const TextStyle(color: Colors.white),
            alignLabelWithHint: true,
            labelText: 'Conteudo da lista',
            labelStyle: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        )
      ],
    );
  }
}
