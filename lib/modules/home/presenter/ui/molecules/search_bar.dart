import 'package:flutter/material.dart';
import 'package:listadecoisa/core/design_system/list_system_field.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClose;
  final bool isVisible;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClose,
    this.isVisible = false,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 40,
      child: ListSystemField(
        hintText: 'Buscar listas...',
        controller: widget.controller,
        autofocus: true,
        onChanged: widget.onChanged,
        textAlign: TextAlign.left,
        showBorder: false,
      ),
    );
  }
}
