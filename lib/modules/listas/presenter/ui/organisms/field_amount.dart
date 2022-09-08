import 'package:flutter/material.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/modules/listas/domain/models/ckeck_compras.dart';
import 'package:listadecoisa/modules/listas/presenter/controllers/listas_controller.dart';
import 'package:listadecoisa/modules/listas/presenter/ui/atoms/field_list.dart';

class FieldAmount extends StatefulWidget {
  final ListasController ct;
  final Global global;
  final CheckCompras check;
  const FieldAmount({super.key, required this.global, required this.ct, required this.check});

  @override
  State<FieldAmount> createState() => _FieldAmountState();
}

class _FieldAmountState extends State<FieldAmount> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 12, right: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                widget.check.quant++;
                widget.ct.quant.text = widget.check.quant.toString();
                widget.ct.calculaValorTotal();
              });
            },
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.add,
                color: widget.global.getPrimary(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: 50,
              child: FieldList(
                readOnly: widget.ct.isComp!,
                keyboardType: TextInputType.number,
                controller: TextEditingController(
                  text: widget.check.quant.toString(),
                ),
                onEditingComplete: () => widget.ct.node.nextFocus(),
                onChanged: (v) {
                  widget.check.quant = int.tryParse(v) ?? 0;
                  widget.ct.calculaValorTotal();
                },
                autofocus: widget.check.quant == 0.0 ? true : false,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              widget.check.quant;
              if (widget.check.quant > 0) {
                setState(() {
                  widget.check.quant--;
                  widget.ct.quant.text = widget.check.quant.toString();
                  widget.ct.calculaValorTotal();
                });
              }
            },
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.remove,
                color: widget.global.getPrimary(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
