import 'package:flutter/material.dart';
import 'package:listadecoisa/modules/home/presenter/controllers/home_controller.dart';
import 'package:listadecoisa/modules/listas/presenter/ui/pages/listas_page.dart';

class ListCompartilhadaPage extends StatelessWidget {
  final HomeController ct;
  const ListCompartilhadaPage({super.key, required this.ct});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ct.lisCoisaComp,
      builder: (context, value, child) {
        return ListView.builder(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
          ),
          shrinkWrap: true,
          itemCount: ct.lisCoisaComp.value.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => Navigator.pushNamed(
                context,
                ListasPage.route,
                arguments: [
                  ct.lisCoisaComp.value[index],
                  false,
                ],
              ),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(ct.lisCoisaComp.value[index].nome),
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
