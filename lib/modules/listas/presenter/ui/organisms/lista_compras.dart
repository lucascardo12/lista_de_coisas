import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listadecoisa/modules/listas/presenter/controllers/listas_controller.dart';
import 'package:listadecoisa/modules/listas/domain/models/ckeck_compras.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/modules/listas/presenter/ui/atoms/field_list.dart';
import 'package:listadecoisa/modules/listas/presenter/ui/organisms/field_amount.dart';

class ListaCompras extends StatelessWidget {
  final Global gb;
  final ListasController ct;

  const ListaCompras({
    super.key,
    required this.ct,
    required this.gb,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 8),
            Checkbox(
              fillColor: MaterialStateProperty.all(Colors.white),
              checkColor: gb.getPrimary(),
              onChanged: (bool? value) {
                ct.marcaTodos = !ct.marcaTodos;
                for (var element in ct.coisas!.checkCompras) {
                  element.feito = ct.marcaTodos;
                }
                ct.coisas!.checklist
                    .removeWhere((element) => element.item.isEmpty);
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
                  color: gb.getPrimary(),
                ),
                onPressed: () {
                  ct.coisas!.checkCompras.add(
                    CheckCompras(
                      feito: false,
                      item: '',
                      valor: 0.0,
                      quant: 1,
                    ),
                  );
                  ct.update();
                },
              ),
            ),
            const Spacer(),
            const SizedBox(width: 50),
          ],
        ),
        const Divider(
          color: Colors.white,
        ),
        Expanded(
          flex: 10,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Scrollbar(
              interactive: false,
              thickness: 5,
              thumbVisibility: true,
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 15),
                shrinkWrap: true,
                itemCount: ct.coisas!.checkCompras.length,
                itemBuilder: (BuildContext context, int i) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            fillColor: MaterialStateProperty.all(Colors.white),
                            checkColor: gb.getPrimary(),
                            onChanged: (bool? value) {
                              ct.coisas!.checkCompras[i].feito = value!;
                              ct.update();
                            },
                            value: ct.coisas!.checkCompras[i].feito,
                          ),
                          Expanded(
                            flex: 5,
                            child: FieldList(
                              readOnly: ct.isComp!,
                              onEditingComplete: () => ct.node.nextFocus(),
                              validator: (value) {
                                ct.coisas!.checkCompras[i].item = value!;
                                if (value.isEmpty) {
                                  return 'Conteudo não pode ser vazio';
                                }
                                return null;
                              },
                              autofocus: ct.coisas!.checkCompras[i].item.isEmpty
                                  ? true
                                  : false,
                              initialValue: ct.coisas!.checkCompras[i].item,
                              onChanged: (v) =>
                                  ct.coisas!.checkCompras[i].item = v,
                              minLines: 1,
                              maxLines: 2,
                              maxLengthEnforcement: MaxLengthEnforcement
                                  .truncateAfterCompositionEnds,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: FieldList(
                              readOnly: ct.isComp!,
                              keyboardType: TextInputType.number,
                              onEditingComplete: () => ct.node.nextFocus(),
                              inputFormatters: [
                                CurrencyTextInputFormatter(
                                  decimalDigits: 2,
                                  symbol: '',
                                  locale: 'pt-br',
                                ),
                              ],
                              onChanged: (v) {
                                final valor = v
                                    .replaceAll('.', '')
                                    .replaceFirst(',', '.');
                                ct.coisas!.checkCompras[i].valor =
                                    double.tryParse(valor) ?? 0.0;
                                ct.calculaValorTotal();
                              },
                              autofocus: ct.coisas!.checkCompras[i].valor == 0.0
                                  ? true
                                  : false,
                              initialValue: ct.coisas!.checkCompras[i].valor ==
                                      0.0
                                  ? ''
                                  : ct.coisas!.checkCompras[i].valor.toString(),
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              ct.coisas!.checkCompras.removeAt(i);
                              ct.coisas!.checkCompras =
                                  ct.coisas!.checkCompras.toList();
                              ct.update();
                            },
                          ),
                        ],
                      ),
                      FieldAmount(
                        global: gb,
                        ct: ct,
                        check: ct.coisas!.checkCompras[i],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        const Divider(
          color: Colors.white,
        ),
        ValueListenableBuilder(
          valueListenable: ct.totalGeral,
          builder: (context, value, child) => SizedBox(
            height: 40,
            child: Text(
              'Valor total da compra: \$${value.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
