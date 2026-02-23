import 'package:flutter/material.dart';
import 'package:listadecoisa/modules/home/domain/models/list_view_type_enum.dart';
import 'package:listadecoisa/modules/home/presenter/controllers/home_controller.dart';
import 'package:listadecoisa/main.dart';
import 'package:listadecoisa/modules/home/presenter/ui/molecules/app_header.dart';
import 'package:listadecoisa/modules/home/presenter/ui/molecules/custom_drawer.dart';
import 'package:listadecoisa/modules/home/presenter/ui/organisms/content_home.dart';
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
        body: CustomScrollView(
          slivers: [
            AppHeader(
              global: gb,
              searchController: _searchController,
              searchFocusNode: _searchFocusNode,
              isSearching: _isSearching,
              onSearchToggle: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchController.clear();
                    _searchFocusNode.unfocus();
                  }
                });
              },
              onCreateList: () => ct.showCria(context: context),
              onSearchChanged: (value) {
                setState(() {});
              },
              onSearchClose: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                  _searchFocusNode.unfocus();
                });
              },
            ),
            SliverFillRemaining(
              child: Container(
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
                child: ContentHome(
                  ct: ct,
                  gb: gb,
                  searchQuery: _searchController.text,
                ),
              ),
            ),
          ],
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
        drawer: CustomDrawer(global: gb, controller: ct),
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
