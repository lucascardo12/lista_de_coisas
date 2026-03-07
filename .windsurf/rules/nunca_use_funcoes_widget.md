---
trigger: always_on
---
# Regra: Nunca use funções para retornar widgets, crie componentes separados

## **PROIBIDO - Usando funções privadas:**

```dart
// ❌ ERRADO - NUNCA faça isso
class MyWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildContent(),
        _buildActions(),
      ],
    );
  }

  Widget _buildHeader() { ... }
  Widget _buildContent() { ... }
  Widget _buildActions() { ... }
}
```

## **OBRIGATÓRIO - Crie arquivos separados:**

```dart
// ✅ CORRETO - SEMPRE faça isso

// my_widget.dart
class MyWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomHeader(title: 'Título'),
        CustomContent(data: data),
        CustomActions(
          onCancel: () => Navigator.pop(context),
          onConfirm: () => _handleConfirm(),
        ),
      ],
    );
  }
}

// molecules/custom_header.dart
class CustomHeader extends StatelessWidget { ... }

// molecules/custom_content.dart  
class CustomContent extends StatelessWidget { ... }

// molecules/custom_actions.dart
class CustomActions extends StatelessWidget { ... }
```

## **Estrutura de Pastas (Padrão Atômico)**

```
lib/modules/nome_modulo/presenter/ui/
├── atoms/ (Componentes simples e reutilizáveis)
│   ├── button_icon.dart
│   ├── text_field.dart
│   └── card_shadow.dart
├── molecules/ (Combinações de 2+ atoms)
│   ├── search_bar.dart
│   ├── list_item.dart
│   └── form_field.dart
├── organisms/ (Componentes complexos)
│   ├── app_header.dart
│   ├── content_grid.dart
│   └── editor_toolbar.dart
└── pages/ (Telas completas)
    └── minha_page.dart
```

## **Regras de Componentização**

1. **NUNCA** use funções privadas (`_buildAlgo()`) para separar componentes
2. **SEMPRE** crie arquivos separados para componentes reutilizáveis
3. **SEMPRE** siga a estrutura atômica (atoms → molecules → organisms → pages)
4. **Cada componente** deve ter responsabilidade única
5. **Nomes descritivos** para todos os componentes

## **Benefícios**

- **Reutilização**: Componentes podem ser usados em múltiplas telas
- **Manutenibilidade**: Cada componente tem responsabilidade única
- **Testabilidade**: Componentes isolados são mais fáceis de testar
- **Consistência**: Interface padronizada em toda a aplicação
- **Escalabilidade**: Fácil adicionar novas funcionalidades

## **Exemplo Real - Refatoração**

### Antes (❌):
```dart
class EditorPage extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildToolbar(),
        _buildEditor(),
      ],
    );
  }
  
  Widget _buildToolbar() { ... }
  Widget _buildEditor() { ... }
}
```

### Depois (✅):
```dart
// pages/editor_page.dart
class EditorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const EditorToolbar(),
        const Expanded(child: EditorContent()),
      ],
    );
  }
}

// organisms/editor_toolbar.dart
class EditorToolbar extends StatelessWidget { ... }

// organisms/editor_content.dart
class EditorContent extends StatefulWidget { ... }
```
