import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listadecoisa/services/global.dart';
import 'package:listadecoisa/widgets/borda_padrao.dart';

class CampoPadrao extends StatelessWidget {
  final gb = Get.find<Global>();
  final Widget? suffixIcon;
  final bool? lObescure;
  final String hintText;
  final TextEditingController? controller;
  CampoPadrao({
    super.key,
    required this.hintText,
    this.lObescure,
    this.suffixIcon,
    this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: lObescure ?? false,
      style: const TextStyle(color: Colors.white),
      textAlign: TextAlign.left,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        border: BordaPadrao.build(),
        enabledBorder: BordaPadrao.build(),
        focusedBorder: BordaPadrao.build(),
        hintStyle: const TextStyle(color: Colors.white),
        hintText: hintText,
      ),
      controller: controller,
    );
  }
}
