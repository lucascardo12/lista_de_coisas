import 'package:flutter/material.dart';
import 'package:listadecoisa/main.dart';
import 'package:listadecoisa/modules/auth/presenter/ui/organisms/loading_padrao.dart';
import 'package:listadecoisa/modules/listas/domain/enums/status_page.dart';
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
        if (ct.statusPage.value == StatusPage.loading) return LoadPadrao();
        return Scaffold(
          body: SafeArea(
            child: WillPopScope(
              onWillPop: () => ct.bottonVoltar(context),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [ct.gb.getPrimary(), ct.gb.getSecondary()],
                  ),
                ),
                child: Form(
                  key: ct.formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      Expanded(
                        child: TextFormField(
                          readOnly: ct.isComp ?? false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Titulo não pode ser vazio';
                            }
                            return null;
                          },
                          onChanged: (value) => ct.coisas!.nome = value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          initialValue: ct.coisas?.nome,
                          textAlign: TextAlign.center,
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: ct.coisas!.nome.isEmpty
                                ? '    Digite um Titulo'
                                : null,
                            alignLabelWithHint: true,
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: AnimatedBuilder(
                          animation: ct,
                          builder: (context, child) {
                            switch (ct.coisas?.tipo ?? 0) {
                              case 0:
                                return ListaTexto(ct: ct, gb: ct.gb);
                              case 1:
                                return ListaCheck(ct: ct, gb: ct.gb);
                              case 2:
                                return ListaCompras(ct: ct, gb: ct.gb);
                              default:
                                return const Text('Erro');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(left: 20, right: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButton(color: Colors.white),
                !ct.isComp!
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 15),
                          IconButton(
                            icon: const Icon(Icons.done, color: Colors.white),
                            onPressed: () async {
                              if (ct.formKey.currentState!.validate()) {
                                await ct.criaCoisa(coisa: ct.coisas!);
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      )
                    : const SizedBox(width: 15),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        );
      },
    );
  }
}
