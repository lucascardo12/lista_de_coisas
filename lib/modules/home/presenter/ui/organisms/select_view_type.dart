import 'package:flutter/material.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/modules/home/domain/models/list_view_type_enum.dart';

class SelectViewType extends StatelessWidget {
  final List<ListViewType> items;
  final Global gb;

  const SelectViewType({super.key, required this.items, required this.gb});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Wrap(
          children: items.map(
            (e) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Radio<ListViewType>(
                    value: e,
                    activeColor: gb.getPrimary(),
                    groupValue: gb.listViewType,
                    onChanged: (ListViewType? valor) {
                      gb.listViewType = valor ?? ListViewType.list;
                      gb.box.put('listViewType', gb.listViewType.name);
                      Navigator.pop(context);
                    },
                  ),
                  Text(e.title)
                ],
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
