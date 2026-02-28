import 'package:flutter/material.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/modules/home/domain/models/list_view_type_enum.dart';
import 'package:listadecoisa/modules/home/presenter/controllers/home_controller.dart';
import 'package:listadecoisa/modules/home/presenter/ui/molecules/content_grid.dart';
import 'package:listadecoisa/modules/home/presenter/ui/molecules/content_list.dart';
import 'package:listadecoisa/modules/listas/domain/models/coisas.dart';
import 'package:listadecoisa/modules/listas/presenter/arguments/lists_argument.dart';
import 'package:listadecoisa/modules/listas/presenter/ui/pages/listas_page.dart';

class CardList extends StatelessWidget {
  final Global gb;
  final HomeController ct;
  final Coisas coisa;

  const CardList({
    super.key,
    required this.ct,
    required this.gb,
    required this.coisa,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        ListasPage.route,
        arguments: ListsArgument(idDoc: coisa.idFire),
      ),
      child: Card(
        child: switch (gb.listViewType) {
          ListViewType.list => ContentList(gb: gb, ct: ct, coisa: coisa),
          ListViewType.grid => ContentGrid(gb: gb, ct: ct, coisa: coisa),
        },
      ),
    );
  }
}
