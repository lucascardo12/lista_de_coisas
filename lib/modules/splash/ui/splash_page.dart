import 'package:flutter/material.dart';
import 'package:listadecoisa/modules/splash/controllers/splash_controller.dart';
import 'package:listadecoisa/main.dart';
import 'package:listadecoisa/modules/auth/presenter/ui/organisms/loading_padrao.dart';

class SplashPage extends StatefulWidget {
  static const route = '/Splash';
  const SplashPage({Key? key}) : super(key: key);
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final ct = di.get<SplashController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => ct.init(context));
    super.initState();
  }

  @override
  void dispose() {
    ct.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadPadrao();
  }
}
