import 'package:flutter/material.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/core/services/theme/theme_service.dart';
import 'package:listadecoisa/modules/home/presenter/controllers/home_controller.dart';
import 'package:listadecoisa/modules/home/presenter/ui/atoms/delete_list_button.dart';
import 'package:intl/intl.dart';
import 'package:listadecoisa/modules/listas/domain/enums/type_list.dart';
import 'package:listadecoisa/modules/listas/domain/models/coisas.dart';

class ContentList extends StatelessWidget {
  final Global gb;
  final HomeController ct;
  final Coisas coisa;

  const ContentList({
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
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: ThemeService.of.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: tipoCor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(tipoIcon, color: tipoCor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coisa.nome.isEmpty ? 'Sem título' : coisa.nome,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: ThemeService.of.textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    coisa.tipo.title,
                    style: TextStyle(
                      fontSize: 14,
                      color: ThemeService.of.secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Atualizado ${_formatDate(coisa.updatAp)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: ThemeService.of.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            DeleteListButton(
              onPressed: () async {
                await ct.showAlertDialog2(coisas: coisa, context: context);
              },
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
    TypeList.text => ThemeService.of.infoColor,
    TypeList.check => ThemeService.of.successColor,
    TypeList.checkout => ThemeService.of.warningColor,
  };

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'hoje';
    } else if (difference.inDays == 1) {
      return 'ontem';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} dias atrás';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }
}
