import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listadecoisa/services/banco.dart';
import 'package:listadecoisa/services/global.dart';
import 'package:listadecoisa/view/cadastroPage.dart';
import 'package:listadecoisa/view/compartilha-page.dart';
import 'package:listadecoisa/view/homePage.dart';
import 'package:listadecoisa/view/listasPage.dart';
import 'package:listadecoisa/view/loginPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize();
  await Get.putAsync(() => Global().inicia());
  await Get.putAsync(() => BancoFire().inicia());
  runApp(MyApp());
}

class MyApp extends GetView {
  final gb = Get.find<Global>();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      title: 'Lista de Coisas',
      theme: ThemeData.light().copyWith(
        accentColor: gb.getSecondary(),
        primaryColor: gb.getPrimary(),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.white,
        ),
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: gb.getPrimary(),
              secondary: gb.getSecondary(),
            ),
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
