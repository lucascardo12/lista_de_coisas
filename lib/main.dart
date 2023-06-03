import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:listadecoisa/modules/auth/auth_module.dart';
import 'package:listadecoisa/modules/auth/presenter/ui/pages/cadastro_page.dart';
import 'package:listadecoisa/modules/auth/presenter/ui/pages/login_page.dart';
import 'package:listadecoisa/modules/home/home_module.dart';
import 'package:listadecoisa/modules/listas/listas_module.dart';
import 'package:listadecoisa/modules/splash/splash_module.dart';
import 'package:listadecoisa/modules/splash/ui/splash_page.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/modules/home/presenter/ui/pages/compartilha_page.dart';
import 'package:listadecoisa/modules/home/presenter/ui/pages/home_page.dart';
import 'package:listadecoisa/modules/listas/presenter/ui/pages/listas_page.dart';
import 'package:listadecoisa/core/services/service_module.dart';

GetIt di = GetIt.instance;

Future<void> main() async {
  ServiceModule().register();
  AuthModule().register();
  HomeModule().register();
  ListasModule().register();
  SplashModule().register();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final gb = di.get<Global>();

  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: gb.tema,
      builder: (context, value, child) {
        return MaterialApp(
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          title: 'Lista de Coisas',
          theme: ThemeData.light().copyWith(
            primaryColor: gb.getPrimary(),
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Colors.white,
            ),
            colorScheme: ThemeData.light()
                .colorScheme
                .copyWith(
                  primary: gb.getPrimary(),
                  secondary: gb.getSecondary(),
                )
                .copyWith(secondary: gb.getSecondary()),
          ),
          initialRoute: SplashPage.route,
          routes: {
            '/': (context) => const SplashPage(),
            SplashPage.route: (context) => const SplashPage(),
            CompartilhaPage.route: (context) => const CompartilhaPage(),
            CadastroPage.route: (context) => const CadastroPage(),
            ListasPage.route: (context) => const ListasPage(),
            HomePage.route: (context) => const HomePage(),
            LoginPage.route: (context) => const LoginPage(),
          },
        );
      },
    );
  }
}
