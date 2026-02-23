import 'package:flutter/material.dart';
import 'package:listadecoisa/modules/home/domain/models/list_view_type_enum.dart';
import 'package:listadecoisa/modules/home/presenter/controllers/home_controller.dart';
import 'package:listadecoisa/modules/home/presenter/ui/organisms/card_list.dart';
import 'package:listadecoisa/core/services/global.dart';

class ListTextoPage extends StatelessWidget {
  final Global gb;
  final HomeController ct;
  final String searchQuery;

  const ListTextoPage({
    super.key,
    required this.ct,
    required this.gb,
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    final filteredLists = searchQuery.isEmpty
        ? ct.lisCoisa.value
        : ct.lisCoisa.value.where((coisa) {
            return coisa.nome.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ) ||
                coisa.descricao.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                );
          }).toList();

    return ValueListenableBuilder(
      valueListenable: ct.lisCoisa,
      builder: (context, value, child) {
        if (filteredLists.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  searchQuery.isEmpty ? Icons.list_alt : Icons.search_off,
                  size: 64,
                  color: gb.getSecondaryTextColor(),
                ),
                const SizedBox(height: 16),
                Text(
                  searchQuery.isEmpty
                      ? 'Nenhuma lista encontrada'
                      : 'Nenhuma lista corresponde à busca',
                  style: TextStyle(
                    fontSize: 18,
                    color: gb.getTextColor(),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (searchQuery.isEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Crie sua primeira lista usando o botão abaixo',
                    style: TextStyle(
                      fontSize: 14,
                      color: gb.getSecondaryTextColor(),
                    ),
                  ),
                ],
              ],
            ),
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
              final originalIndex = ct.lisCoisa.value.indexOf(
                filteredLists[index],
              );
              return CardList(ct: ct, gb: gb, index: originalIndex);
            },
          ),
          ListViewType.list => ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: filteredLists.length,
            itemBuilder: (context, index) {
              final originalIndex = ct.lisCoisa.value.indexOf(
                filteredLists[index],
              );
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: CardList(ct: ct, gb: gb, index: originalIndex),
              );
            },
          ),
        };
      },
    );
  }
}
