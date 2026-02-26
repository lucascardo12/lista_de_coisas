---
trigger: always_on
---
# Regra: Nunca use print, use sempre log do dart:developer

## Import obrigatório
```dart
import 'dart:developer';
```

## Em vez de usar:
```dart
print('mensagem');
print('variavel: $variavel');
print('erro: $error');
```

## Use sempre:
```dart
log('mensagem');
log('variavel: $variavel');
log('erro: $error');
```

## Benefícios do log em relação ao print:
- Melhor performance em produção
- Logs categorizados e filtráveis
- Informações de timestamp automáticas
- Níveis de log (info, warning, error)
- Melhor integração com ferramentas de debugging

## Exemplo completo:
```dart
import 'dart:developer';

void minhaFuncao() {
  final resultado = calcularAlgo();
  log('Resultado calculado: $resultado');
  
  try {
    processoRisco();
  } catch (e, s) {
    log('Erro ao processar: $e', stackTrace: s);
  }
}
```
