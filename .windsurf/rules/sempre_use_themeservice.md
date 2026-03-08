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
  color: themeService.primary,
  child: Text(
    'Título',
    style: TextStyle(color: themeService.whiteOrBlack),
  ),
)
```

## **Métodos Disponíveis no ThemeService**

```dart
themeService.primary              // Cor principal do app
// Exemplo: Color.fromRGBO(255, 64, 111, 1) (original)

themeService.secondary            // Cor secundária
// Exemplo: Color.fromRGBO(255, 128, 111, 1) (original)

themeService.whiteOrBlack         // Branco ou preto baseado no tema
// Exemplo: Colors.white (original), Colors.white (dark)

themeService.textColor            // Cor do texto principal
// Exemplo: Color(0xFF2C3E50)

themeService.secondaryTextColor   // Cor do texto secundário
// Exemplo: Color(0xFF757575)

themeService.backgroundColor      // Cor de fundo
// Exemplo: Color(0xFFFAFAFA)

themeService.backgroundColor         // Cor de superfície/cards
// Exemplo: Colors.white

themeService.successColor         // Cor de sucesso (verde)

themeService.errorColor           // Cor de erro (vermelho)

themeService.warningColor         // Cor de aviso (laranja)

themeService.infoColor            // Cor de informação (azul)
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
        backgroundColor: themeService.primary,
        foregroundColor: themeService.whiteOrBlack,
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
- Use os métodos específicos: `primary`, `secondary`, etc.
- Nunca use `Colors.xxx` diretamente nos widgets
- Para transparência, use `themeService.primary.withValues(alpha: 0.5)`
- Para acessar o tema atual como enum: `themeService.currentTheme.value`
