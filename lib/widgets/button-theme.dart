import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listadecoisa/services/global.dart';
import 'package:listadecoisa/widgets/selectTheme.dart';

class ButtonTema extends GetView {
  final gb = Get.find<Global>();
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => Get.dialog(
            SelectTheme(
              items: ['Original', 'Dark', 'Azul', 'Roxo'],
            ),
            barrierColor: Colors.transparent),
        style: TextButton.styleFrom(
          padding: EdgeInsets.only(left: 20, right: 20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: gb.getPrimary(),
              radius: 17,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Temas',
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: gb.getPrimary(),
                  ),
            ),
            Spacer(),
            TextButton.icon(
              onPressed: null,
              icon: Text(
                gb.tema ?? '',
                style: TextStyle(color: Colors.black38, fontSize: 12),
              ),
              label: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.black38,
              ),
            )
          ],
        ));
  }
}
