import 'package:flutter/material.dart';
import 'package:listadecoisa/modules/auth/presenter/controllers/cadastro_controller.dart';
import 'package:listadecoisa/main.dart';
import 'package:listadecoisa/services/global.dart';
import 'package:listadecoisa/modules/auth/presenter/ui/atoms/button_text_padrao.dart';
import 'package:listadecoisa/modules/home/presenter/ui/atoms/compo_padrao.dart';

class CadastroPage extends StatefulWidget {
  static const route = '/Cadastro';
  const CadastroPage({Key? key}) : super(key: key);
  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final gb = di.get<Global>();
  final ct = di.get<CadastroController>();

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
                alignment: Alignment.center,
                child: Text(
                  'Cadastro',
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
            gb: gb,
            hintText: 'E-mail',
            controller: ct.loginControler,
          ),
          const SizedBox(height: 10),
          ValueListenableBuilder(
            valueListenable: ct.lObescure,
            builder: (context, value, child) {
              return CampoPadrao(
                hintText: 'Senha',
                gb: gb,
                lObescure: ct.lObescure.value,
                suffixIcon: IconButton(
                  color: Colors.white,
                  icon: Icon(ct.lObescure.value ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => ct.lObescure.value = !ct.lObescure.value,
                ),
                controller: ct.senhaControler,
              );
            },
          ),
          const SizedBox(height: 10),
          CampoPadrao(
            hintText: 'Nome',
            gb: gb,
            controller: ct.nomeControler,
          ),
          const SizedBox(height: 20),
          ButtonTextPadrao(
            label: 'Cadastro',
            color: gb.getWhiteOrBlack(),
            textColor: gb.getPrimary(),
            onPressed: () => ct.valida(mounted, context),
          ),
          ButtonTextPadrao(
            label: 'Voltar',
            textColor: Colors.white,
            color: Colors.transparent,
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    ));
  }
}
