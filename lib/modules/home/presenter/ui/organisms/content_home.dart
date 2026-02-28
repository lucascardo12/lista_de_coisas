import 'package:flutter/material.dart';
import 'package:listadecoisa/modules/home/domain/models/list_view_type_enum.dart';
import 'package:listadecoisa/modules/home/presenter/controllers/home_controller.dart';
import 'package:listadecoisa/modules/home/presenter/ui/molecules/empty_state.dart';
import 'package:listadecoisa/modules/home/presenter/ui/organisms/card_list.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/modules/listas/domain/models/coisas.dart';

class ContentHome extends StatelessWidget {
  final Global gb;
  final HomeController ct;
  final String searchQuery;

  const ContentHome({
    super.key,
    required this.ct,
    required this.gb,
    this.searchQuery = '',
  });

  List<Coisas> get filteredLists {
    return searchQuery.isEmpty
        ? ct.lisCoisa.value
        : ct.lisCoisa.value.where((coisa) {
            return coisa.nome.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ) ||
                coisa.descricao.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                );
          }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ct.lisCoisa,
      builder: (context, value, child) {
        if (filteredLists.isEmpty) {
          return EmptyState(
            global: gb,
            title: searchQuery.isEmpty
                ? 'Nenhuma lista encontrada'
                : 'Nenhuma lista corresponde à busca',
            subtitle: searchQuery.isEmpty
                ? 'Crie sua primeira lista usando o botão abaixo'
                : null,
            icon: searchQuery.isEmpty ? Icons.list_alt : Icons.search_off,
          );
        }

        return switch (gb.listViewType) {
          ListViewType.grid => GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            padding: const EdgeInsets.all(16),
            itemCount: filteredLists.length,
            itemBuilder: (context, index) {
              final coisa = filteredLists[index];
              return CardList(ct: ct, gb: gb, coisa: coisa);
            },
          ),
          ListViewType.list => ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: filteredLists.length,
            itemBuilder: (context, index) {
              final coisa = filteredLists[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: CardList(ct: ct, gb: gb, coisa: coisa),
              );
            },
          ),
        };
      },
    );
  }
}
