library my_prj.globals;

import 'package:listadecoisa/model/coisas.dart';
import 'package:listadecoisa/model/user.dart';
import 'package:listadecoisa/controller/banco.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isLoading = false;
SharedPreferences prefs;
String app = "Anote";
bool isSwitched;
bool isSwitched2;
bool isSwitched3;
List<Coisas> lisCoisa;
UserP usuario;
BancoFire banco = new BancoFire();
int hora;
int dia;
String tema;
String codigo;
