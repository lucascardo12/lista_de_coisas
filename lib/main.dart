import 'dart:convert';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listadecoisa/model/user.dart';
import 'package:listadecoisa/view/compartilha-page.dart';
import 'package:listadecoisa/view/homePage.dart';
import 'package:listadecoisa/view/loginPage.dart';
import 'package:listadecoisa/controller/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Admob.initialize();
  //global.banco.db.enablePersistence();
  global.banco.db.settings = Settings(persistenceEnabled: true);
  await SharedPreferences.getInstance().then((value) async {
    global.prefs = value;
  });
  global.tema = global.prefs.getString("tema") ?? "Original";
  var auxi = global.prefs.getString("user") ?? '';
  try {
    if (global.prefs.getBool('fezLogin') ?? false) {
      global.usuario = new UserP.fromJson(json.decode(auxi));
    }
  } catch (e) {
    print(e);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      title: 'Lista de Coisas',
      theme: ThemeData(
        accentColor: global.getSecondary(),
        primaryColor: global.getSecondary(),
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: global.getSecondary(),
              secondary: global.getSecondary(),
            ),
      ),
      routes: {
        //'/': (context) => LoginPage(),
        '/comp': (context) => CompartilhaPage(),
      },
      getPages: [
        GetPage(
            name: '/',
            page: () {
              return global.usuario != null ? HomePage() : Login();
            })
      ],
    );
  }
}
