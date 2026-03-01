import 'package:flutter/material.dart';
import 'package:listadecoisa/core/services/theme/theme_service.dart';
import 'package:listadecoisa/modules/home/presenter/ui/atoms/bottom_sheet_handle.dart';
import 'package:listadecoisa/modules/home/presenter/ui/molecules/bottom_sheet_actions.dart';
import 'package:listadecoisa/modules/home/presenter/ui/molecules/bottom_sheet_header.dart';
import 'package:listadecoisa/modules/home/presenter/ui/molecules/type_list_card.dart';
import 'package:listadecoisa/modules/listas/domain/enums/type_list.dart';
import 'package:listadecoisa/modules/listas/presenter/arguments/lists_argument.dart';
import 'package:listadecoisa/modules/listas/presenter/ui/pages/listas_page.dart';

class NewListBottomSheet extends StatefulWidget {
  final Function onUpdateList;
  const NewListBottomSheet({super.key, required this.onUpdateList});

  @override
  State<NewListBottomSheet> createState() => _NewListBottomSheetState();
}

class _NewListBottomSheetState extends State<NewListBottomSheet> {
  TypeList? selectedType;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeService.instance.getBackgroundColor(),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BottomSheetHandle(),
          BottomSheetHeader(
            title: 'Nova Lista',
            subtitle: 'Escolha o tipo de lista que deseja criar',
          ),
          _buildTypeOptions(),
          BottomSheetActions(
            onCancel: () => Navigator.pop(context),
            onContinue: _onContinue,
            canContinue: selectedType != null,
          ),
        ],
      ),
    );
  }

  Widget _buildTypeOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: TypeList.values
            .map(
              (type) => TypeListCard(
                type: type,
                isSelected: selectedType == type,
                onTap: () => setState(() => selectedType = type),
              ),
            )
            .toList(),
      ),
    );
  }

  void _onContinue() {
    Navigator.pop(context);
    Navigator.pushNamed(
      context,
      ListasPage.route,
      arguments: ListsArgument(),
    ).then((value) => widget.onUpdateList());
  }
}
