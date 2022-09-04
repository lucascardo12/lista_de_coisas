import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listadecoisa/modules/listas/presenter/controllers/listas_controller.dart';
import 'package:listadecoisa/modules/listas/domain/models/ckeck_compras.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/modules/home/presenter/ui/atoms/borda_padrao.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class ListaCompras extends StatelessWidget {
  final Global gb;
  final ListasController ct;
  final bool isComp;

  const ListaCompras({
    super.key,
    required this.ct,
    required this.isComp,
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
                ct.coisas!.checklist.removeWhere((element) => element.item.isEmpty);
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
                              child: TextFormField(
                                readOnly: isComp,
                                onEditingComplete: () => ct.node.nextFocus(),
                                validator: (value) {
                                  ct.coisas!.checkCompras[i].item = value!;
                                  if (value.isEmpty) return "Conteudo não pode ser vazio";
                                  return null;
                                },
                                autofocus: ct.coisas!.checkCompras[i].item.isEmpty ? true : false,
                                initialValue: ct.coisas!.checkCompras[i].item,
                                cursorColor: Colors.white,
                                onChanged: (v) => ct.coisas!.checkCompras[i].item = v,
                                style: const TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                                minLines: 1,
                                maxLines: 2,
                                maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  border: BordaPadrao.check(),
                                  enabledBorder: BordaPadrao.check(),
                                  focusedBorder: BordaPadrao.check(),
                                  hintStyle: const TextStyle(color: Colors.white),
                                  alignLabelWithHint: true,
                                  hintText: "",
                                  labelStyle: const TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              )),
                          Expanded(
                              flex: 2,
                              child: TextFormField(
                                readOnly: isComp,
                                keyboardType: TextInputType.number,
                                onEditingComplete: () => ct.node.nextFocus(),
                                onChanged: (v) {
                                  var valor = v.replaceAll('.', '').replaceFirst(',', '.');
                                  ct.coisas!.checkCompras[i].valor = double.tryParse(valor) ?? 0.0;
                                  ct.update();
                                },
                                autofocus: ct.coisas!.checkCompras[i].valor == 0.0 ? true : false,
                                initialValue: ct.coisas!.checkCompras[i].valor == 0.0
                                    ? ''
                                    : ct.coisas!.checkCompras[i].valor.toString(),
                                cursorColor: Colors.white,
                                style: const TextStyle(color: Colors.white),
                                inputFormatters: [
                                  CurrencyTextInputFormatter(decimalDigits: 2, symbol: '', locale: 'pt-br'),
                                ],
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: "R\u0024",
                                  contentPadding: EdgeInsets.zero,
                                  border: BordaPadrao.check(),
                                  enabledBorder: BordaPadrao.check(),
                                  focusedBorder: BordaPadrao.check(),
                                  hintStyle: const TextStyle(color: Colors.white),
                                  alignLabelWithHint: true,
                                  labelStyle: const TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              )),
                          IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              ct.coisas!.checkCompras[i] = CheckCompras(
                                feito: false,
                                item: '',
                                quant: 0,
                                valor: 0.0,
                              );
                              ct.update();
                            },
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12, top: 12, right: 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                ct.coisas!.checkCompras[i].quant++;
                                ct.quant.text = ct.coisas!.checkCompras[i].quant.toString();
                                ct.update();
                              },
                              icon: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.add,
                                  color: gb.getPrimary(),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: SizedBox(
                                width: 50,
                                child: TextFormField(
                                  readOnly: isComp,
                                  keyboardType: TextInputType.number,
                                  onEditingComplete: () => ct.node.nextFocus(),
                                  controller: ct.quant,
                                  onChanged: (v) {
                                    ct.coisas!.checkCompras[i].quant = int.tryParse(v) ?? 0;
                                    ct.update();
                                  },
                                  autofocus: ct.coisas!.checkCompras[i].quant == 0.0 ? true : false,
                                  cursorColor: Colors.white,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: BordaPadrao.check(),
                                    enabledBorder: BordaPadrao.check(),
                                    focusedBorder: BordaPadrao.check(),
                                    hintStyle: const TextStyle(color: Colors.white),
                                    alignLabelWithHint: true,
                                    labelStyle: const TextStyle(color: Colors.white, fontSize: 18),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                ct.coisas!.checkCompras[i].quant;
                                if (ct.coisas!.checkCompras[i].quant > 0) {
                                  ct.coisas!.checkCompras[i].quant--;
                                  ct.quant.text = ct.coisas!.checkCompras[i].quant.toString();
                                  ct.update();
                                }
                              },
                              icon: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.remove,
                                  color: gb.getPrimary(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
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
        SizedBox(
          height: 40,
          child: Text(
            "Valor total da compra R\u0024: ${ct.retornaTotal(ct.coisas!.checkCompras)}",
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: Colors.white,
                ),
          ),
        )
      ],
    );
  }
}
