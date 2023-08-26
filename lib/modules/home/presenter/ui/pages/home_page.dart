import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:listadecoisa/core/configs/app_helps.dart';
import 'package:listadecoisa/modules/auth/presenter/ui/pages/login_page.dart';
import 'package:listadecoisa/modules/home/domain/models/list_view_type_enum.dart';
import 'package:listadecoisa/modules/home/presenter/controllers/home_controller.dart';
import 'package:listadecoisa/main.dart';
import 'package:listadecoisa/modules/auth/presenter/ui/atoms/button_text_padrao.dart';
import 'package:listadecoisa/modules/home/presenter/ui/atoms/drawer_button.dart';
import 'package:listadecoisa/modules/home/presenter/ui/organisms/select_theme.dart';
import 'package:listadecoisa/modules/home/presenter/ui/organisms/select_view_type.dart';
import 'package:listadecoisa/modules/home/presenter/ui/pages/list_compartilhada_page.dart';
import 'package:listadecoisa/modules/home/presenter/ui/pages/list_text_page.dart';
import 'package:listadecoisa/core/services/global.dart';

class HomePage extends StatefulWidget {
  static const route = '/Home';
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final gb = di.get<Global>();
  final ct = di.get<HomeController>();

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
                  ),
                ),
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
                ),
              )
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
                ListTextoPage(ct: ct, gb: gb),
                ListCompartilhadaPage(ct: ct),
              ],
            ),
          ),
          drawer: Drawer(
            elevation: 8,
            child: ListView(
              children: [
                Container(
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
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        gb.usuario?.login != null
                            ? Text(
                                gb.usuario!.login!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(height: 8),
                        Text(
                          gb.packageInfo.version,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.white,
                                  ),
                        )
                      ],
                    ),
                  ),
                ),
                ButtonTextPadrao(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    LoginPage.route,
                    (route) => false,
                  ),
                  label: 'Voltar',
                ),
                Visibility(
                  visible: !ct.isAnonimo,
                  child: ButtonTextPadrao(
                    label: 'Redefina Senha',
                    onPressed: () => ct.showAlertRedefinir(context: context),
                  ),
                ),
                DrawerButtonItem(
                  prefixo: CircleAvatar(
                    backgroundColor: gb.getPrimary(),
                    radius: 12,
                  ),
                  title: 'Temas',
                  onPressed: () => AppHelps.defaultDialog(
                    context: context,
                    child: SelectTheme(
                      gb: gb,
                      items: const ['Original', 'Dark', 'Azul', 'Roxo'],
                    ),
                    barrierColor: Colors.transparent,
                  ),
                  valueCurrent: gb.tema.value,
                ),
                DrawerButtonItem(
                  prefixo: Icon(getIconViewType(gb.listViewType)),
                  title: 'Visualização',
                  onPressed: () => AppHelps.defaultDialog(
                    context: context,
                    child: SelectViewType(
                      gb: gb,
                      items: ListViewType.values,
                    ),
                    barrierColor: Colors.transparent,
                  ).then((value) {
                    setState(() {});
                  }),
                  valueCurrent: gb.listViewType.title,
                ),
              ],
            ),
          ),
          bottomNavigationBar: SizedBox(
            height: 50,
            child: FutureBuilder<BannerAd>(
              future: ct.admob.loadBanner(adUnitId: ct.admob.bannerAdUnitId),
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
        ),
      ),
    );
  }

  IconData getIconViewType(ListViewType type) {
    switch (type) {
      case ListViewType.grid:
        return Icons.grid_on;
      case ListViewType.list:
        return Icons.list_alt;
    }
  }
}
