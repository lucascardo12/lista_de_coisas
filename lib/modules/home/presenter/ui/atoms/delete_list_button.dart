import 'package:flutter/material.dart';
import 'package:listadecoisa/core/services/theme/theme_service.dart';

class DeleteListButton extends StatelessWidget {
  final void Function()? onPressed;

  const DeleteListButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.delete_outline,
        color: ThemeService.of.errorColor,
        size: 20,
      ),
      onPressed: onPressed,
      tooltip: 'Excluir lista',
    );
  }
}
