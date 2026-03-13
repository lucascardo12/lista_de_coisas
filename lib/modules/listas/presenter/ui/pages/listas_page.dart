import 'package:flutter/material.dart';
import 'package:listadecoisa/main.dart';
import 'package:listadecoisa/core/services/theme/theme_service.dart';
import 'package:listadecoisa/core/design_system/loading_page.dart';
import 'package:listadecoisa/core/design_system/list_system_field.dart';
import 'package:listadecoisa/modules/listas/domain/enums/status_page.dart';
import 'package:listadecoisa/modules/listas/domain/enums/type_list.dart';
import 'package:listadecoisa/modules/listas/presenter/controllers/listas_controller.dart';
import 'package:listadecoisa/modules/listas/presenter/ui/organisms/lista_check.dart';
import 'package:listadecoisa/modules/listas/presenter/ui/organisms/lista_compras.dart';
import 'package:listadecoisa/modules/listas/presenter/ui/organisms/lista_texto.dart';

class ListasPage extends StatefulWidget {
  static const route = '/Listas';

  const ListasPage({super.key});

  @override
  State<ListasPage> createState() => _ListasPageState();
}

class _ListasPageState extends State<ListasPage> {
  final ct = di.get<ListasController>();

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
    ct.node = FocusScope.of(context);
    return ValueListenableBuilder(
      valueListenable: ct.statusPage,
      builder: (context, value, child) {
        if (ct.statusPage.value == StatusPage.loading) {
          return const LoadingPage();
        }
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [ThemeService.of.primary, ThemeService.of.secondary],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  if (ct.bottonVoltar(context)) {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  }
                },
              ),
              actions: const [SizedBox(width: 32)],
              centerTitle: true,
              title: ListSystemField(
                hintText: 'Digite um Titulo',
                initialValue: ct.coisas.nome,
                textAlign: TextAlign.center,
                showBorder: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Titulo não pode ser vazio';
                  }
                  return null;
                },
                onChanged: (value) => ct.coisas.nome = value,
              ),
            ),
            body: SafeArea(
              child: PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) {
                  if (ct.bottonVoltar(context)) {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  }
                },
                child: Form(
                  key: ct.formKey,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 8,
                        child: AnimatedBuilder(
                          animation: ct,
                          builder: (context, child) => switch (ct.coisas.tipo) {
                            TypeList.text => ListaTexto(ct: ct, gb: ct.gb),
                            TypeList.check => ListaCheck(ct: ct, gb: ct.gb),
                            TypeList.checkout => ListaCompras(
                              ct: ct,
                              gb: ct.gb,
                            ),
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                if (ct.formKey.currentState!.validate()) {
                  await ct.criaCoisa(coisa: ct.coisas);
                  if (mounted && context.mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              backgroundColor: ThemeService.of.backgroundColor,
              icon: const Icon(Icons.check),
              label: const Text('Salvar'),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        );
      },
    );
  }
}
