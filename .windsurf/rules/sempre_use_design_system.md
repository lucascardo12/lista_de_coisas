---
trigger: always_on
---
# Regra: Sempre use componentes do Design System

## **OBRIGATÓRIO - Use componentes do DS:**

```dart
// ✅ CORRETO - SEMPRE use componentes do DS
import 'package:listadecoisa/core/design_system/list_system_button.dart';
import 'package:listadecoisa/core/design_system/list_system_field.dart';
import 'package:listadecoisa/core/design_system/text/list_text.dart';

ListSystemButton(
  label: 'Salvar',
  onPressed: () => _save(),
)

ListSystemField(
  hintText: 'Digite seu nome',
  controller: _controller,
)

ListText(
  text: 'Título',
  typography: ListTypography.title,
)
```

## **Nomenclatura Obrigatória:**

### **TODOS componentes do DS devem começar com "List"**

```dart
// ✅ CORRETO - Nomenclatura padrão
class ListSystemButton extends StatelessWidget { ... }
class ListSystemField extends StatelessWidget { ... }
class ListText extends StatelessWidget { ... }
class ListCard extends StatelessWidget { ... }
class ListIcon extends StatelessWidget { ... }
class ListDialog extends StatelessWidget { ... }

// ❌ ERRADO - Nomenclatura não padrão
class CustomButton extends StatelessWidget { ... }
class MyTextField extends StatelessWidget { ... }
class AppCard extends StatelessWidget { ... }
```

### **Benefícios da Nomenclatura "List":**

- **Identidade visual**: Reforça o nome do app "Lista de Coisas"
- **Consistência**: Fácil identificar componentes do DS
- **Autocompletar**: Agrupa componentes no IDE
- **Documentação**: Autoexplicativo

## **PROIBIDO - Criar widgets repetitivos:**

```dart
// ❌ ERRADO - NÃO crie botões repetitivos
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: themeService.primary,
    foregroundColor: themeService.whiteOrBlack,
  ),
  onPressed: () {},
  child: Text('Botão 1'),
)

// ❌ ERRADO - NÃO crie campos repetitivos
TextFormField(
  decoration: InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
)
```

## **Quando criar/mover componentes para o DS:**

### 1. **Componente usado em 3+ telas diferentes**
Se um componente é utilizado em 3 ou mais telas, ele DEVE ser movido para o DS.

### 2. **Componente com complexidade repetida**
Botões, campos de texto, cards, etc. que são repetidamente recriados.

### 3. **Componente visual padrão**
Elementos que definem a identidade visual do app.

## **Estrutura do Design System:**

```
lib/core/design_system/
└── export_list_system.dart  # Export centralizado
```

## **Exemplo de Componente para o DS:**

### Botão customizado usado em múltiplas telas:
```dart
// lib/core/design_system/list_icon_button.dart
class ListIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  
  const ListIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    ThemeService get themeService => ThemeService.instance;
    
    return IconButton(
      icon: Icon(icon, color: color ?? themeService.primary),
      onPressed: onPressed,
    );
  }
}
```

## **Processo para adicionar componente ao DS:**

1. **Identificar** o componente repetitivo
2. **Analisar** se é usado em 3+ telas
3. **Criar** o arquivo na pasta `lib/core/design_system/`
4. **Parametrizar** propriedades variáveis
5. **Adicionar** ao `export_list_system.dart`
6. **Substituir** usos repetitivos pelo novo componente

## **Benefícios do DS:**

- **Consistência visual**: Interface padronizada
- **Manutenibilidade**: Mudanças em um único lugar
- **Productividade**: Reutilização acelerada
- **Testabilidade**: Componentes isolados
- **Escalabilidade**: Fácil expansão

## **Dicas do DS:**

- **Sempre verifique** se o componente já existe no DS antes de criar
- **Use nomes descritivos** para componentes
- **TODOS componentes devem começar com "List"** (ListButton, ListCard, etc.)
- **Parametrize** apenas o necessário
- **Mantenha componentes simples** e focados
- **Documente** componentes complexos
