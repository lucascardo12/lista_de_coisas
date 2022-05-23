import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:listadecoisa/controller/home_controller.dart';
import 'package:listadecoisa/services/global.dart';
import 'package:listadecoisa/widgets/button_text_padrao.dart';
import 'package:listadecoisa/widgets/button_theme.dart';

class HomePage extends GetView {
  final gb = Get.find<Global>();
  final ct = Get.put(HomeController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ct.initPlatformStateForStringUniLinks(context: context);
    return DefaultTabController(
        length: 2,
        child: WillPopScope(
          onWillPop: () => ct.showExit(context: context),
          child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                indicatorColor: gb.getWhiteOrBlack(),
                tabs: const [
                  Tab(
                    icon: Icon(
                      Icons.list_alt,
                      color: Colors.white,
                    ),
                  ),
                  Tab(
                      icon: Icon(
                    Icons.share_outlined,
                    color: Colors.white,
                  )),
                ],
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              actions: [
                Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: IconButton(
                      color: Colors.white,
                      icon: const Icon(
                        Icons.add_circle,
                        size: 32,
                      ),
                      onPressed: () => ct.showCria(context: context),
                    ))
              ],
              centerTitle: true,
              backgroundColor: gb.getPrimary(),
              title: const Text(
                'Listas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),
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
                child: TabBarView(
                  children: [
                    listasNormais(),
                    listasComp(),
                  ],
                )),
            drawer: Drawer(
              elevation: 8,
              child: ListView(
                children: [
                  DrawerHeader(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(0),
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
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            gb.usuario!.nome ?? '',
                            style: const TextStyle(color: Colors.white, fontSize: 22),
                          ),
                          Text(
                            gb.packageInfo.version,
                            style: Get.textTheme.subtitle1!.copyWith(
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  ButtonTextPadrao(
                    onPressed: () => Get.offAllNamed('/login'),
                    label: "Voltar",
                  ),
                  Visibility(
                      visible: !ct.isAnonimo,
                      child: ButtonTextPadrao(
                        label: "Redefina Senha",
                        onPressed: () => ct.showAlertRedefinir(context: context),
                      )),
                  ButtonTema(),
                ],
              ),
            ),
            bottomNavigationBar: SizedBox(
              height: 50,
              child: AdWidget(
                ad: ct.admob.banner,
              ),
            ),
          ),
        ));
  }

  Widget listasNormais() {
    return Obx(
      () => ListView.builder(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
        ),
        shrinkWrap: true,
        itemCount: gb.lisCoisa.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Get.toNamed(
              '/listas',
              arguments: [
                gb.lisCoisa[index],
                false,
              ],
            ),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(gb.lisCoisa[index].nome ?? ''),
                    PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                        PopupMenuItem(
                          value: 0,
                          child: ListTile(
                            leading: Icon(
                              Icons.qr_code_scanner_rounded,
                              color: gb.getPrimary(),
                            ),
                            title: const Text('Compartilhar'),
                          ),
                        ),
                        PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            leading: Icon(
                              Icons.delete,
                              color: gb.getPrimary(),
                            ),
                            title: const Text('Excluir'),
                          ),
                        ),
                      ],
                      onSelected: (value) async {
                        switch (value) {
                          case 0:
                            ct.showCompartilha(context: context, index: index);
                            break;
                          case 1:
                            await ct.showAlertDialog2(coisas: gb.lisCoisa[index], context: context);
                            break;
                          default:
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget listasComp() {
    return Obx(
      () => ListView.builder(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
        ),
        shrinkWrap: true,
        itemCount: gb.lisCoisaComp.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Get.toNamed(
              '/listas',
              arguments: [
                gb.lisCoisaComp[index],
                false,
              ],
            ),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(gb.lisCoisaComp[index].nome ?? ''),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
