import 'package:flutter/material.dart';
import 'package:listadecoisa/modules/auth/presenter/controllers/login_controller.dart';
import 'package:listadecoisa/main.dart';
import 'package:listadecoisa/modules/auth/presenter/ui/pages/cadastro_page.dart';
import 'package:listadecoisa/services/global.dart';
import 'package:listadecoisa/modules/auth/presenter/ui/atoms/button_text_padrao.dart';
import 'package:listadecoisa/modules/home/presenter/ui/atoms/compo_padrao.dart';

class LoginPage extends StatefulWidget {
  static const route = '/Login';
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final gb = di.get<Global>();
  final ct = di.get<LoginController>();

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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              gb.getPrimary(),
              gb.getSecondary(),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Padding(
                padding: EdgeInsets.only(top: 50, bottom: 50),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Lista de coisas',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                )),
            CampoPadrao(
              hintText: 'E-mail',
              controller: ct.loginControler,
              gb: gb,
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder(
              valueListenable: ct.lObescure,
              builder: (context, value, child) {
                return CampoPadrao(
                  gb: gb,
                  lObescure: ct.lObescure.value,
                  suffixIcon: IconButton(
                    color: Colors.white,
                    icon: Icon(ct.lObescure.value ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => ct.lObescure.value = !ct.lObescure.value,
                  ),
                  hintText: 'Senha',
                  controller: ct.senhaControler,
                );
              },
            ),
            ButtonTextPadrao(
              label: 'Esqueceu sua senha?',
              color: Colors.transparent,
              onPressed: () => ct.showAlertRedefinir(context: context),
            ),
            ButtonTextPadrao(
              label: 'Login',
              color: gb.getWhiteOrBlack(),
              textColor: gb.getPrimary(),
              onPressed: () => ct.logar(mounted, context),
            ),
            ButtonTextPadrao(
              color: gb.getWhiteOrBlack(),
              label: 'Modo anônimo',
              textColor: gb.getPrimary(),
              onPressed: () => ct.loginAnonimo(mounted, context),
            ),
            ButtonTextPadrao(
              color: gb.getWhiteOrBlack(),
              label: 'Google',
              textColor: gb.getPrimary(),
              onPressed: () => ct.loginGoogle(mounted, context),
            ),
            ButtonTextPadrao(
              label: 'Cadastrar-se',
              onPressed: () => Navigator.pushNamed(context, CadastroPage.route),
              color: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
