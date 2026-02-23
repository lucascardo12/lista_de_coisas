import 'package:flutter/material.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/modules/home/presenter/ui/molecules/search_bar.dart';

class AppHeader extends StatelessWidget {
  final Global global;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final bool isSearching;
  final VoidCallback onSearchToggle;
  final VoidCallback onCreateList;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchClose;

  const AppHeader({
    super.key,
    required this.global,
    required this.searchController,
    required this.searchFocusNode,
    required this.isSearching,
    required this.onSearchToggle,
    required this.onCreateList,
    required this.onSearchChanged,
    required this.onSearchClose,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0,
      scrolledUnderElevation: 0,
      floating: true,
      snap: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [global.getPrimary(), global.getSecondary()],
          ),
        ),
      ),
      title: CustomSearchBar(
        controller: searchController,
        focusNode: searchFocusNode,
        isVisible: isSearching,
        onChanged: onSearchChanged,
        onClose: onSearchClose,
      ),
      centerTitle: !isSearching,
      titleSpacing: isSearching ? 16 : 0,
      actions: [
        IconButton(
          icon: Icon(isSearching ? Icons.close : Icons.search),
          color: Colors.white,
          onPressed: onSearchToggle,
        ),
        if (!isSearching) ...[
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 28),
            color: Colors.white,
            onPressed: onCreateList,
          ),
        ],
      ],
    );
  }
}
