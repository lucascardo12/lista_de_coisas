import 'package:flutter/material.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/modules/home/presenter/controllers/home_controller.dart';
import 'package:listadecoisa/modules/home/presenter/ui/atoms/option_item.dart';

class ContentGrid extends StatelessWidget {
  final Global gb;
  final HomeController ct;
  final int index;

  const ContentGrid({
    super.key,
    required this.gb,
    required this.ct,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OptionItem(ct: ct, gb: gb, index: index),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Center(
            child: Text(ct.lisCoisa.value[index].nome),
          ),
        ),
      ],
    );
  }
}
