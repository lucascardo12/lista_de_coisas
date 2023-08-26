import 'package:flutter/material.dart';
import 'package:listadecoisa/modules/home/domain/models/list_view_type_enum.dart';
import 'package:listadecoisa/modules/home/presenter/controllers/home_controller.dart';
import 'package:listadecoisa/modules/home/presenter/ui/organisms/card_list.dart';
import 'package:listadecoisa/core/services/global.dart';

class ListTextoPage extends StatelessWidget {
  final Global gb;
  final HomeController ct;

  const ListTextoPage({super.key, required this.ct, required this.gb});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ct.lisCoisa,
      builder: (context, value, child) => switch (gb.listViewType) {
        ListViewType.grid => GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
            ),
            shrinkWrap: true,
            itemCount: ct.lisCoisa.value.length,
            itemBuilder: (context, index) {
              return CardList(
                ct: ct,
                gb: gb,
                index: index,
              );
            },
          ),
        ListViewType.list => ListView.builder(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
            ),
            shrinkWrap: true,
            itemCount: ct.lisCoisa.value.length,
            itemBuilder: (context, index) {
              return CardList(
                ct: ct,
                gb: gb,
                index: index,
              );
            },
          ),
      },
    );
  }
}
