import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listadecoisa/services/global.dart';
import 'package:listadecoisa/widgets/select_theme.dart';

class ButtonTema extends GetView {
  final gb = Get.find<Global>();

  ButtonTema({super.key});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Get.dialog(
          SelectTheme(
            items: const ['Original', 'Dark', 'Azul', 'Roxo'],
          ),
          barrierColor: Colors.transparent),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.only(left: 20, right: 20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: gb.getPrimary(),
            radius: 17,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            'Temas',
            style: Get.textTheme.subtitle1!.copyWith(
              color: gb.getPrimary(),
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: null,
            icon: Text(
              gb.tema ?? '',
              style: const TextStyle(color: Colors.black38, fontSize: 12),
            ),
            label: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black38,
            ),
          )
        ],
      ),
    );
  }
}
