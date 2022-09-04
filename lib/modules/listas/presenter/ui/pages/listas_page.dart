import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
          body: WillPopScope(
            onWillPop: () => ct.bottonVoltar(context),
            child: RefreshIndicator(
              color: ct.gb.getPrimary(),
              backgroundColor: Colors.white,
              strokeWidth: 4.0,
              onRefresh: ct.atualizaCoisa,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      ct.gb.getPrimary(),
                      ct.gb.getSecondary(),
                    ],
                  ),
                ),
                child: Form(
                  key: ct.formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      Expanded(
                        child: TextFormField(
                          readOnly: ct.isComp ?? false,
                          validator: (value) {
                            if (value!.isEmpty) return "Titulo não pode ser vazio";
                            return null;
                          },
                          onChanged: (value) => ct.coisas!.nome = value,
                          style: const TextStyle(color: Colors.white, fontSize: 20),
                          initialValue: ct.coisas?.nome,
                          textAlign: TextAlign.center,
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: ct.coisas!.nome.isEmpty ? "    Digite um Titulo" : null,
                            alignLabelWithHint: true,
                            labelStyle: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: AnimatedBuilder(
                          animation: ct,
                          builder: (context, child) => [
                            ListaTexto(
                              isComp: ct.isComp!,
                              ct: ct,
                              gb: ct.gb,
                            ),
                            ListaCheck(
                              isComp: ct.isComp!,
                              ct: ct,
                              gb: ct.gb,
                            ),
                            ListaCompras(
                              isComp: ct.isComp!,
                              ct: ct,
                              gb: ct.gb,
                            ),
                          ].elementAt(ct.coisas?.tipo ?? 0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: SizedBox(
            height: 50,
            child: FutureBuilder<BannerAd>(
              future: ct.admob.loadBanner(adUnitId: ct.admob.bannerAdUnitId2),
              builder: (context, value) {
                if (value.hasError) {
                  return const Center(
                    child: Text('Erro na propaganda'),
                  );
                }
                if (value.hasData) {
                  return AdWidget(
                    ad: value.data!,
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(left: 20, right: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButton(
                  color: Colors.white,
                ),
                !ct.isComp!
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 15,
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.done,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              if (ct.formKey.currentState!.validate()) {
                                if (ct.verificaUltimaAds()) {
                                  await ct.admob.mostraTelaCheia();
                                  ct.gb.box.put('day', DateTime.now().millisecondsSinceEpoch);
                                }
                                await ct.criaCoisa(coisa: ct.coisas!);
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      )
                    : const SizedBox(
                        width: 15,
                      )
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        );
      },
    );
  }
}
