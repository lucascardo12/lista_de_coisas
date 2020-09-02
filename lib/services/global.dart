library my_prj.globals;

import 'package:listadecoisa/classes/coisas.dart';
import 'package:listadecoisa/classes/user.dart';
import 'package:listadecoisa/services/banco.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isLoading = false;
String nome;
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
