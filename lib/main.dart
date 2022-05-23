import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listadecoisa/services/admob.dart';
import 'package:listadecoisa/services/banco.dart';
import 'package:listadecoisa/services/global.dart';
import 'package:listadecoisa/view/cadastro_page.dart';
import 'package:listadecoisa/view/compartilha_page.dart';
import 'package:listadecoisa/view/home_page.dart';
import 'package:listadecoisa/view/listas_page.dart';
import 'package:listadecoisa/view/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => AdMob().inicia());
  await Get.putAsync(() => Global().inicia());
  await Get.putAsync(() => BancoFire().inicia());
  runApp(MyApp());
}

class MyApp extends GetView {
  final gb = Get.find<Global>();

  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
      getPages: [
        GetPage(
          name: '/',
          page: () => gb.usuario != null ? HomePage() : Login(),
        ),
        GetPage(
          name: '/comp',
          page: () => CompartilhaPage(),
        ),
        GetPage(
          name: '/cadastro',
          page: () => Cadastro(),
        ),
        GetPage(
          name: '/listas',
          page: () => ListasPage(),
        ),
        GetPage(
          name: '/home',
          page: () => HomePage(),
        ),
        GetPage(
          name: '/login',
          page: () => Login(),
        )
      ],
    );
  }
}
