import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:listadecoisa/modules/auth/presenter/ui/pages/login_page.dart';
import 'package:listadecoisa/modules/home/presenter/controllers/home_controller.dart';
import 'package:listadecoisa/main.dart';
import 'package:listadecoisa/modules/auth/presenter/ui/atoms/button_text_padrao.dart';
import 'package:listadecoisa/modules/home/presenter/ui/pages/list_compartilhada_page.dart';
import 'package:listadecoisa/modules/home/presenter/ui/pages/list_text_page.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/modules/home/presenter/ui/organisms/button_theme.dart';

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
                  ListTextoPage(ct: ct, gb: gb),
                  ListCompartilhadaPage(gb: gb),
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
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
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
}
