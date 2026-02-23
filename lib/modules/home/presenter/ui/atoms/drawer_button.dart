import 'package:flutter/material.dart';
import 'package:listadecoisa/main.dart';
import 'package:listadecoisa/core/services/global.dart';

class DrawerButtonItem extends StatelessWidget {
  final gb = di.get<Global>();
  final void Function()? onPressed;
  final Widget? prefixo;
  final Widget? sufixo;
  final String valueCurrent;
  final String title;

  DrawerButtonItem({
    super.key,
    this.onPressed,
    this.prefixo,
    this.sufixo,
    required this.valueCurrent,
    required this.title,
  });
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.only(left: 20, right: 20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          prefixo ?? const SizedBox.shrink(),
          const SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: gb.getPrimary(),
                ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: onPressed,
            icon: Text(
              valueCurrent,
              style: const TextStyle(color: Colors.black38, fontSize: 12),
            ),
            label: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }
}
