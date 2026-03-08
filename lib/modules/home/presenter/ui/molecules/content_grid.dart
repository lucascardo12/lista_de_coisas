import 'package:flutter/material.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/core/services/theme/theme_service.dart';
import 'package:listadecoisa/modules/home/presenter/controllers/home_controller.dart';
import 'package:listadecoisa/modules/home/presenter/ui/atoms/delete_list_button.dart';
import 'package:intl/intl.dart';
import 'package:listadecoisa/modules/listas/domain/enums/type_list.dart';
import 'package:listadecoisa/modules/listas/domain/models/coisas.dart';

class ContentGrid extends StatelessWidget {
  final Global gb;
  final HomeController ct;
  final Coisas coisa;

  const ContentGrid({
    super.key,
    required this.gb,
    required this.ct,
    required this.coisa,
  });

  @override
  Widget build(BuildContext context) {
    final tipoIcon = _getTipoIcon(coisa.tipo);
    final tipoCor = _getTipoColor(coisa.tipo);

    return Card(
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: ThemeService.of.backgroundColor,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: tipoCor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(tipoIcon, color: tipoCor, size: 20),
                ),
                DeleteListButton(
                  onPressed: () async {
                    await ct.showAlertDialog2(coisas: coisa, context: context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              coisa.nome.isEmpty ? 'Sem título' : coisa.nome,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: ThemeService.of.textColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                _formatDate(coisa.updatAp),
                style: TextStyle(
                  fontSize: 10,
                  color: ThemeService.of.secondaryTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTipoIcon(TypeList tipo) => switch (tipo) {
    TypeList.text => Icons.note_alt_outlined,
    TypeList.check => Icons.checklist_outlined,
    TypeList.checkout => Icons.shopping_cart_outlined,
  };

  Color _getTipoColor(TypeList tipo) => switch (tipo) {
    TypeList.text => Colors.blue,
    TypeList.check => Colors.green,
    TypeList.checkout => Colors.orange,
  };

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hoje';
    } else if (difference.inDays == 1) {
      return 'Ontem';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return DateFormat('dd/MM').format(date);
    }
  }
}
