import 'package:flutter/material.dart';
import 'package:listadecoisa/core/services/theme/theme_service.dart';
import 'package:listadecoisa/main.dart';
import 'package:listadecoisa/core/services/global.dart';

class LoadPadrao extends StatelessWidget {
  final gb = di.get<Global>();

  LoadPadrao({super.key});
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          direction: Axis.vertical,
          children: [
            const CircularProgressIndicator.adaptive(),
            const SizedBox(height: 20),
            Text(
              'carregando as coisas ⏳',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: ThemeService.instance.getSecondary(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
