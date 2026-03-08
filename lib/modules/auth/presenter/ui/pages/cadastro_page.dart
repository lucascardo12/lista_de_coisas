import 'package:flutter/material.dart';
import 'package:listadecoisa/core/services/theme/theme_service.dart';
import 'package:listadecoisa/modules/auth/presenter/controllers/cadastro_controller.dart';
import 'package:listadecoisa/main.dart';
import 'package:listadecoisa/core/design_system/export_list_system.dart';

class CadastroPage extends StatefulWidget {
  static const route = '/Cadastro';
  const CadastroPage({super.key});
  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
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
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [ThemeService.of.primary, ThemeService.of.secondary],
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
                ),
              ),
              ListSystemField(
                hintText: 'E-mail',
                controller: ct.loginControler,
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder(
                valueListenable: ct.lObescure,
                builder: (context, value, child) {
                  return ListSystemField(
                    hintText: 'Senha',
                    lObescure: ct.lObescure.value,
                    suffixIcon: IconButton(
                      color: Colors.white,
                      icon: Icon(
                        ct.lObescure.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () => ct.lObescure.value = !ct.lObescure.value,
                    ),
                    controller: ct.senhaControler,
                  );
                },
              ),
              const SizedBox(height: 10),
              ListSystemField(hintText: 'Nome', controller: ct.nomeControler),
              const SizedBox(height: 20),
              ListSystemButton(
                label: 'Cadastro',
                color: ThemeService.of.whiteOrBlack,
                textColor: ThemeService.of.primary,
                onPressed: () => ct.createUserWithEmailAndPassword(context),
              ),
              ListSystemButton(
                label: 'Voltar',
                textColor: Colors.white,
                color: Colors.transparent,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
