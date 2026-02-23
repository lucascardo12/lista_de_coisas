import 'package:flutter/material.dart';
import 'package:listadecoisa/core/configs/app_helps.dart';
import 'package:listadecoisa/modules/auth/presenter/ui/pages/login_page.dart';
import 'package:listadecoisa/modules/home/domain/models/list_view_type_enum.dart';
import 'package:listadecoisa/modules/home/presenter/controllers/home_controller.dart';
import 'package:listadecoisa/main.dart';
import 'package:listadecoisa/modules/home/presenter/ui/organisms/select_theme.dart';
import 'package:listadecoisa/modules/home/presenter/ui/organisms/select_view_type.dart';
import 'package:listadecoisa/modules/home/presenter/ui/pages/list_text_page.dart';
import 'package:listadecoisa/core/services/global.dart';

class HomePage extends StatefulWidget {
  static const route = '/Home';
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final gb = di.get<Global>();
  final ct = di.get<HomeController>();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => ct.init(context));
    super.initState();
  }

  @override
  void dispose() {
    ct.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => ct.showExit(context: context),
      child: Scaffold(
        backgroundColor: gb.getBackgroundColor(),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
          scrolledUnderElevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [gb.getPrimary(), gb.getSecondary()],
              ),
            ),
          ),
          title: _isSearching
              ? Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Buscar listas...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                )
              : const Text(
                  'Minhas Listas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
          centerTitle: !_isSearching,
          actions: [
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              color: Colors.white,
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchController.clear();
                    _searchFocusNode.unfocus();
                  }
                });
              },
            ),
            if (!_isSearching) ...[
              IconButton(
                icon: const Icon(Icons.add_circle_outline, size: 28),
                color: Colors.white,
                onPressed: () => ct.showCria(context: context),
              ),
            ],
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                gb.getPrimary().withOpacity(0.05),
                gb.getBackgroundColor(),
              ],
            ),
          ),
          child: ListTextoPage(
            ct: ct,
            gb: gb,
            searchQuery: _searchController.text,
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => ct.showCria(context: context),
          backgroundColor: gb.getPrimary(),
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: const Text('Nova Lista'),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        drawer: SafeArea(
          child: Drawer(
            elevation: 8,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [gb.getPrimary(), gb.getSecondary()],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  gb.usuario?.login ?? 'Visitante',
                                  style: TextStyle(
                                    color: gb.getWhiteOrBlack(),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Versão ${gb.packageInfo.version}',
                                  style: TextStyle(
                                    color: gb.getTextColor(),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.logout,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                        title: const Text(
                          'Sair',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        onTap: () => Navigator.pushNamedAndRemoveUntil(
                          context,
                          LoginPage.route,
                          (route) => false,
                        ),
                      ),
                      Visibility(
                        visible: !ct.isAnonimo,
                        child: ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.lock_reset,
                              color: Colors.blue,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            'Redefinir Senha',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: gb.getTextColor(),
                            ),
                          ),
                          onTap: () => ct.showAlertRedefinir(context: context),
                        ),
                      ),
                      const Divider(height: 32),
                      ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: gb.getPrimary().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.palette,
                            color: gb.getPrimary(),
                            size: 20,
                          ),
                        ),
                        title: Text(
                          'Temas',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: gb.getTextColor(),
                          ),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: gb.getPrimary().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            gb.tema.value,
                            style: TextStyle(
                              color: gb.getPrimary(),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        onTap: () => AppHelps.defaultDialog(
                          context: context,
                          child: SelectTheme(
                            gb: gb,
                            items: const ['Original', 'Dark', 'Azul', 'Roxo'],
                          ),
                          barrierColor: Colors.transparent,
                        ),
                      ),
                      ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            getIconViewType(gb.listViewType),
                            color: Colors.green,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          'Visualização',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: gb.getTextColor(),
                          ),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            gb.listViewType.title,
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        onTap: () =>
                            AppHelps.defaultDialog(
                              context: context,
                              child: SelectViewType(
                                gb: gb,
                                items: ListViewType.values,
                              ),
                              barrierColor: Colors.transparent,
                            ).then((value) {
                              setState(() {});
                            }),
                      ),
                    ],
                  ),
                ),
              ],
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
