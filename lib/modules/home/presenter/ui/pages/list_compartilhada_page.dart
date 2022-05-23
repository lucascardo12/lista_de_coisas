import 'package:flutter/material.dart';
import 'package:listadecoisa/modules/listas/presenter/ui/pages/listas_page.dart';
import 'package:listadecoisa/core/services/global.dart';

class ListCompartilhadaPage extends StatelessWidget {
  final Global gb;

  const ListCompartilhadaPage({super.key, required this.gb});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: gb.lisCoisaComp,
      builder: (context, value, child) {
        return ListView.builder(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
          ),
          shrinkWrap: true,
          itemCount: gb.lisCoisaComp.value.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => Navigator.pushNamed(
                context,
                ListasPage.route,
                arguments: [
                  gb.lisCoisaComp.value[index],
                  false,
                ],
              ),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(gb.lisCoisaComp.value[index].nome ?? ''),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
