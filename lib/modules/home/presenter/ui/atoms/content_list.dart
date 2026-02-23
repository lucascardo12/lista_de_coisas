import 'package:flutter/material.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/modules/home/presenter/controllers/home_controller.dart';
import 'package:listadecoisa/modules/home/presenter/ui/atoms/option_item.dart';
import 'package:intl/intl.dart';

class ContentList extends StatelessWidget {
  final Global gb;
  final HomeController ct;
  final int index;

  const ContentList({
    super.key,
    required this.gb,
    required this.ct,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final coisa = ct.lisCoisa.value[index];
    final tipoIcon = _getTipoIcon(coisa.tipo);
    final tipoCor = _getTipoColor(coisa.tipo);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: gb.getSurfaceColor(),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Navigator.pushNamed(
            context,
            '/Listas',
            arguments: [coisa, false],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: tipoCor.withOpacity(0.1),
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
                          color: gb.getTextColor(),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getTipoDescription(coisa.tipo),
                        style: TextStyle(
                          fontSize: 14,
                          color: gb.getSecondaryTextColor(),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Atualizado ${_formatDate(coisa.updatAp)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: gb.getSecondaryTextColor(),
                        ),
                      ),
                    ],
                  ),
                ),
                OptionItem(ct: ct, gb: gb, index: index),
              ],
            ),
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
        return 'Texto Simples';
      case 2:
        return 'Check-List';
      case 3:
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
