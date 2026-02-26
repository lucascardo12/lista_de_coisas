import 'package:flutter/material.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/core/services/theme/theme_service.dart';
import 'package:listadecoisa/modules/home/presenter/controllers/home_controller.dart';
import 'package:listadecoisa/modules/home/presenter/ui/atoms/option_item.dart';
import 'package:intl/intl.dart';
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
      color: ThemeService.instance.getSurfaceColor(),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () =>
            Navigator.pushNamed(context, '/Listas', arguments: [coisa, false]),
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
                  OptionItem(ct: ct, gb: gb, coisa: coisa),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                coisa.nome.isEmpty ? 'Sem título' : coisa.nome,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: ThemeService.instance.getTextColor(),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                _getTipoDescription(coisa.tipo),
                style: TextStyle(
                  fontSize: 12,
                  color: ThemeService.instance.getSecondaryTextColor(),
                ),
              ),
              const Spacer(),
              Text(
                _formatDate(coisa.updatAp),
                style: TextStyle(
                  fontSize: 10,
                  color: ThemeService.instance.getSecondaryTextColor(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTipoIcon(int tipo) {
    switch (tipo) {
      case 1:
        return Icons.note_alt_outlined;
      case 2:
        return Icons.checklist_outlined;
      case 3:
        return Icons.shopping_cart_outlined;
      default:
        return Icons.list_alt;
    }
  }

  Color _getTipoColor(int tipo) {
    switch (tipo) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getTipoDescription(int tipo) {
    switch (tipo) {
      case 1:
        return 'Texto';
      case 2:
        return 'Check-List';
      case 3:
        return 'Compras';
      default:
        return 'Lista';
    }
  }

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
