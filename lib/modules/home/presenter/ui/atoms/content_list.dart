import 'package:flutter/material.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/modules/home/presenter/controllers/home_controller.dart';
import 'package:listadecoisa/modules/home/presenter/ui/atoms/option_item.dart';

class ContentList extends StatelessWidget {
  final Global gb;
  final HomeController ct;
  final int index;

  const ContentList({
    super.key,
    required this.gb,
    required this.ct,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(ct.lisCoisa.value[index].nome),
          OptionItem(ct: ct, gb: gb, index: index),
        ],
      ),
    );
  }
}
