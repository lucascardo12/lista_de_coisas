import 'package:flutter/material.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/modules/home/domain/models/list_view_type_enum.dart';
import 'package:listadecoisa/modules/home/presenter/controllers/home_controller.dart';
import 'package:listadecoisa/modules/home/presenter/ui/atoms/content_grid.dart';
import 'package:listadecoisa/modules/home/presenter/ui/atoms/content_list.dart';
import 'package:listadecoisa/modules/listas/presenter/ui/pages/listas_page.dart';

class CardList extends StatelessWidget {
  final Global gb;
  final HomeController ct;
  final int index;

  const CardList({
    super.key,
    required this.ct,
    required this.gb,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        ListasPage.route,
        arguments: [
          ct.lisCoisa.value[index],
          false,
        ],
      ),
      child: Card(
        child: switch (gb.listViewType) {
          ListViewType.list => ContentList(
              gb: gb,
              ct: ct,
              index: index,
            ),
          ListViewType.grid => ContentGrid(
              gb: gb,
              ct: ct,
              index: index,
            ),
        },
      ),
    );
  }
}
