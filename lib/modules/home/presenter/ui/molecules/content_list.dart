import 'package:flutter/material.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/core/services/theme/theme_service.dart';
import 'package:listadecoisa/modules/home/presenter/controllers/home_controller.dart';
import 'package:listadecoisa/modules/home/presenter/ui/atoms/option_item.dart';
import 'package:intl/intl.dart';
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
      color: ThemeService.instance.getSurfaceColor(),
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
                      color: ThemeService.instance.getTextColor(),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getTipoDescription(coisa.tipo),
                    style: TextStyle(
                      fontSize: 14,
                      color: ThemeService.instance.getSecondaryTextColor(),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Atualizado ${_formatDate(coisa.updatAp)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: ThemeService.instance.getSecondaryTextColor(),
                    ),
                  ),
                ],
              ),
            ),
            OptionItem(ct: ct, gb: gb, coisa: coisa),
          ],
        ),
      ),
    );
  }

  IconData _getTipoIcon(int tipo) {
    switch (tipo) {
      case 0:
        return Icons.note_alt_outlined;
      case 1:
        return Icons.checklist_outlined;
      case 2:
        return Icons.shopping_cart_outlined;
      default:
        return Icons.list_alt;
    }
  }

  Color _getTipoColor(int tipo) {
    switch (tipo) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getTipoDescription(int tipo) {
    switch (tipo) {
      case 0:
        return 'Texto Simples';
      case 1:
        return 'Check-List';
      case 2:
        return 'Lista de Compras';
      default:
        return 'Tipo desconhecido';
    }
  }

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
