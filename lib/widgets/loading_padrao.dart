import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listadecoisa/services/global.dart';

class LoadPadrao extends GetView {
  final gb = Get.find<Global>();

  LoadPadrao({super.key});
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: Axis.vertical,
        children: [
          const CircularProgressIndicator.adaptive(),
          const SizedBox(height: 20),
          Text(
            'Aguarde, carregando as coisas ⏳',
            style: Get.textTheme.headline5!.copyWith(
              color: gb.getSecondary(),
            ),
          )
        ],
      ),
    );
  }
}
