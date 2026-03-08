import 'package:flutter/material.dart';
import 'package:listadecoisa/core/services/theme/theme_service.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});
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
              'carregando ...',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: ThemeService.of.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
