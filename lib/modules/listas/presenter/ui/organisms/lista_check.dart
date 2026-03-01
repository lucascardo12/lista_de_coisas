import 'package:flutter/material.dart';
import 'package:listadecoisa/modules/listas/presenter/controllers/listas_controller.dart';
import 'package:listadecoisa/modules/listas/domain/models/check_list.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/core/services/theme/theme_service.dart';
import 'package:listadecoisa/core/design_system/list_system_field.dart';

class ListaCheck extends StatelessWidget {
  final Global gb;
  final ListasController ct;

  const ListaCheck({super.key, required this.ct, required this.gb});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 8),
            Checkbox(
              fillColor: WidgetStateProperty.all(Colors.white),
              checkColor: ThemeService.instance.getPrimary(),
              onChanged: (bool? value) {
                ct.marcaTodos = !ct.marcaTodos;
                for (var element in ct.coisas.checklist) {
                  element.feito = ct.marcaTodos;
                }
                ct.update();
              },
              value: ct.marcaTodos,
            ),
            const Spacer(),
            CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(
                  Icons.add,
                  color: ThemeService.instance.getPrimary(),
                ),
                onPressed: () {
                  ct.coisas.checklist.add(Checklist(feito: false, item: ''));
                  ct.update();
                },
              ),
            ),
            const Spacer(),
            const SizedBox(width: 50),
          ],
        ),
        const SizedBox(height: 5),
        const Divider(color: Colors.white),
        Expanded(
          flex: 10,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Scrollbar(
              interactive: false,
              thickness: 5,
              thumbVisibility: true,
              child: ListView.builder(
                padding: const EdgeInsets.all(4),
                shrinkWrap: true,
                itemCount: ct.coisas.checklist.length,
                itemBuilder: (BuildContext context, int i) {
                  return Row(
                    children: [
                      Checkbox(
                        fillColor: WidgetStateProperty.all(Colors.white),
                        checkColor: ThemeService.instance.getPrimary(),
                        onChanged: (bool? value) {
                          ct.coisas.checklist[i].feito = value!;
                          ct.update();
                        },
                        value: ct.coisas.checklist[i].feito,
                      ),
                      Expanded(
                        child: ListSystemField(
                          hintText: '',
                          initialValue: ct.coisas.checklist[i].item,
                          autofocus: ct.coisas.checklist[i].item.isEmpty
                              ? true
                              : false,
                          minLines: 1,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          validator: (value) {
                            ct.coisas.checklist[i].item = value!;
                            if (value.isEmpty) {
                              return 'Conteudo não pode ser vazio';
                            }
                            return null;
                          },
                          onChanged: (v) => ct.coisas.checklist[i].item = v,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.red),
                        onPressed: () {
                          ct.coisas.checklist.removeAt(i);
                          ct.coisas.checklist = ct.coisas.checklist.toList();
                          ct.update();
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
