import 'package:flutter/material.dart';
import 'package:listadecoisa/core/configs/app_helps.dart';
import 'package:listadecoisa/core/extensions/empty_string_null.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/modules/auth/presenter/ui/pages/login_page.dart';
import 'package:listadecoisa/modules/home/domain/models/list_view_type_enum.dart';
import 'package:listadecoisa/modules/home/presenter/controllers/home_controller.dart';
import 'package:listadecoisa/modules/home/presenter/ui/molecules/drawer_header.dart';
import 'package:listadecoisa/modules/home/presenter/ui/molecules/drawer_menu_item.dart';
import 'package:listadecoisa/modules/home/presenter/ui/organisms/select_theme.dart';
import 'package:listadecoisa/modules/home/presenter/ui/organisms/select_view_type.dart';

class CustomDrawer extends StatelessWidget {
  final Global global;
  final HomeController controller;

  const CustomDrawer({
    super.key,
    required this.global,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
            CustomDrawerHeader(
              global: global,
              userName:
                  global.usuario?.displayName?.emptyOrNull ??
                  global.usuario?.email?.emptyOrNull ??
                  '',
              version: global.packageInfo.version,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  DrawerMenuItem(
                    icon: Icons.logout,
                    title: 'Sair',
                    iconColor: Colors.red,
                    onTap: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      LoginPage.route,
                      (route) => false,
                    ),
                  ),
                  Visibility(
                    visible: !controller.isAnonimo,
                    child: DrawerMenuItem(
                      icon: Icons.lock_reset,
                      title: 'Redefinir Senha',
                      iconColor: Colors.blue,
                      textColor: global.getTextColor(),
                      onTap: () =>
                          controller.showAlertRedefinir(context: context),
                    ),
                  ),
                  const Divider(height: 32),
                  DrawerMenuItem(
                    icon: Icons.palette,
                    title: 'Temas',
                    iconColor: global.getPrimary(),
                    textColor: global.getTextColor(),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: global.getPrimary().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        global.tema.value,
                        style: TextStyle(
                          color: global.getPrimary(),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    onTap: () => AppHelps.defaultDialog(
                      context: context,
                      child: SelectTheme(
                        gb: global,
                        items: const ['Original', 'Dark', 'Azul', 'Roxo'],
                      ),
                      barrierColor: Colors.transparent,
                    ),
                  ),
                  DrawerMenuItem(
                    icon: _getIconViewType(global.listViewType),
                    title: 'Visualização',
                    iconColor: Colors.green,
                    textColor: global.getTextColor(),
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
                        global.listViewType.title,
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    onTap: () => AppHelps.defaultDialog(
                      context: context,
                      child: SelectViewType(
                        gb: global,
                        items: ListViewType.values,
                      ),
                      barrierColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconViewType(ListViewType type) {
    switch (type) {
      case ListViewType.grid:
        return Icons.grid_on;
      case ListViewType.list:
        return Icons.list_alt;
    }
  }
}
