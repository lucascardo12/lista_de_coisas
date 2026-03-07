---
trigger: always_on
---
# Regra: Sempre use as cores do ThemeService

## Import obrigatório
```dart
import 'package:listadecoisa/core/services/theme/theme_service.dart';
```

## **PROIBIDO - Usando cores hardcoded:**

```dart
// ❌ ERRADO - NUNCA faça isso
Container(
  color: Colors.blue,
  child: Text(
    'Título',
    style: TextStyle(color: Colors.white),
  ),
)

// ❌ ERRADO - NUNCA use Colors diretamente
IconButton(
  color: Colors.red,
  onPressed: () {},
  icon: Icon(Icons.add),
)
```

## **OBRIGATÓRIO - Use ThemeService:**

```dart
// ✅ CORRETO - SEMPRE use ThemeService
ThemeService get themeService => ThemeService.instance;

Container(
  color: themeService.getPrimary(),
  child: Text(
    'Título',
    style: TextStyle(color: themeService.getWhiteOrBlack()),
  ),
)
```

## **Métodos Disponíveis no ThemeService**

```dart
themeService.getPrimary()              // Cor principal do app
// Exemplo: Color.fromRGBO(255, 64, 111, 1) (original)

themeService.getSecondary()            // Cor secundária
// Exemplo: Color.fromRGBO(255, 128, 111, 1) (original)

themeService.getWhiteOrBlack()         // Branco ou preto baseado no tema
// Exemplo: Colors.white (original), Colors.white (dark)

themeService.getTextColor()            // Cor do texto principal
// Exemplo: Color(0xFF2C3E50)

themeService.getSecondaryTextColor()   // Cor do texto secundário
// Exemplo: Color(0xFF757575)

themeService.getBackgroundColor()      // Cor de fundo
// Exemplo: Color(0xFFFAFAFA)

themeService.getSurfaceColor()         // Cor de superfície/cards
// Exemplo: Colors.white

themeService.getSuccessColor()         // Cor de sucesso (verde)

themeService.getErrorColor()           // Cor de erro (vermelho)

themeService.getWarningColor()         // Cor de aviso (laranja)

themeService.getInfoColor()            // Cor de informação (azul)
```

## **Exemplo Completo**

### Antes (❌):
```dart
class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      onPressed: () {},
      child: Text('Clique aqui'),
    );
  }
}
```

### Depois (✅):
```dart
class MyButton extends StatelessWidget {
  ThemeService get themeService => ThemeService.instance;
  @override
  Widget build(BuildContext context) {
   
    
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: themeService.getPrimary(),
        foregroundColor: themeService.getWhiteOrBlack(),
      ),
      onPressed: () {},
      child: Text('Clique aqui'),
    );
  }
}
```

## **Benefícios**

- **Consistência**: Cores uniformes em toda a aplicação
- **Temas múltiplos**: Suporte automático para diferentes temas (original, dark, blue, purple)
- **Manutenibilidade**: Mudanças de cor em um único lugar
- **Personalização**: Fácil adicionar novos temas

## **Dicas**

- Sempre acesse `ThemeService.instance` para obter o serviço de tema
- Use os métodos específicos: `getPrimary()`, `getSecondary()`, etc.
- Nunca use `Colors.xxx` diretamente nos widgets
- Para transparência, use `themeService.getPrimary().withValues(alpha: 0.5)`
- Para acessar o tema atual como enum: `themeService.currentTheme.value`
