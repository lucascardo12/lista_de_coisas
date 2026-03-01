import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listadecoisa/core/design_system/borda_padrao.dart';

class ListSystemField extends StatelessWidget {
  final Widget? suffixIcon;
  final bool? lObescure;
  final String hintText;
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
  const ListSystemField({
    super.key,
    required this.hintText,
    this.lObescure,
    this.suffixIcon,
    this.controller,
    this.autofocus = false,
    this.initialValue,
    this.keyboardType,
    this.onChanged,
    this.onEditingComplete,
    this.readOnly = false,
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
      obscureText: lObescure ?? false,
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
        hintText: hintText,
        contentPadding: EdgeInsets.zero,
        border: ListSystemBorder.check(),
        enabledBorder: ListSystemBorder.check(),
        focusedBorder: ListSystemBorder.check(),
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
        alignLabelWithHint: true,
        labelStyle: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      textAlign: textAlign,
    );
  }
}
