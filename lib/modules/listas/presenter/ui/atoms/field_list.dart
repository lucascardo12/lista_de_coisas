import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listadecoisa/modules/home/presenter/ui/atoms/borda_padrao.dart';

class FieldList extends StatelessWidget {
  final TextEditingController? controller;
  final bool autofocus;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final String? initialValue;
  final bool readOnly;
  final TextInputType? keyboardType;
  final TextAlign textAlign;
  final String? Function(String?)? validator;
  final int? minLines;
  final int? maxLines;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final List<TextInputFormatter>? inputFormatters;
  const FieldList({
    super.key,
    this.autofocus = false,
    this.initialValue,
    this.keyboardType,
    this.onChanged,
    this.onEditingComplete,
    this.readOnly = false,
    this.controller,
    this.textAlign = TextAlign.center,
    this.validator,
    this.minLines,
    this.maxLines,
    this.maxLengthEnforcement,
    this.inputFormatters,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      initialValue: initialValue,
      controller: controller,
      keyboardType: keyboardType,
      onEditingComplete: onEditingComplete,
      onChanged: onChanged,
      autofocus: autofocus,
      validator: validator,
      minLines: minLines,
      maxLines: maxLines,
      maxLengthEnforcement: maxLengthEnforcement,
      cursorColor: Colors.white,
      inputFormatters: inputFormatters,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        border: BordaPadrao.check(),
        enabledBorder: BordaPadrao.check(),
        focusedBorder: BordaPadrao.check(),
        hintStyle: const TextStyle(color: Colors.white),
        alignLabelWithHint: true,
        labelStyle: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      textAlign: textAlign,
    );
  }
}
