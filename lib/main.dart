import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:listadecoisa/classes/coisas.dart';
import 'package:listadecoisa/classes/user.dart';
import 'package:listadecoisa/pages/homePage.dart';
import 'package:listadecoisa/pages/loginPage.dart';
import 'package:listadecoisa/services/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  global.banco.db.enablePersistence();
  await SharedPreferences.getInstance().then((value) async {
    global.prefs = value;
    var auxi = value.getString("user") ?? '';
    try {
      if (value.getBool('fezLogin')) {
        global.usuario = new UserP.fromJson(json.decode(auxi));
        List<dynamic> listCat =
            await global.banco.getCoisas(user: global.usuario);
        global.lisCoisa = listCat.map((i) => Coisas.fromSnapshot(i)).toList();
      }
    } catch (e) {
      print(e);
    }

    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Coisas',
      home: global.usuario != null
          ? MyHomePage(title: 'Lista de Coisas')
          : Login(),
    );
  }
}
