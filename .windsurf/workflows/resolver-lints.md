---
description: Workflow dinâmico para resolver lints do projeto Flutter em ordem de prioridade
---

# Workflow Dinâmico para Resolver Lints do Projeto

## Passo 1: Análise inicial e classificação automática
// turbo
```bash
flutter analyze --verbose > lint_analysis.txt 2>&1
```

Este comando vai:
- Executar análise completa
- Salvar resultado em `lint_analysis.txt`
- Permitir processamento automático dos erros

## Passo 2: Processamento automático dos resultados
// turbo
```bash
# Extrair erros críticos (error) que impedem compilação
grep "error -" lint_analysis.txt > critical_errors.txt

# Extrair warnings
grep "warning -" lint_analysis.txt > warnings.txt

# Extrair infos
grep "info -" lint_analysis.txt > infos.txt

# Contar quantos problemas de cada tipo
echo "=== RESUMO DOS PROBLEMAS ==="
echo "Erros críticos: $(wc -l < critical_errors.txt)"
echo "Warnings: $(wc -l < warnings.txt)"
echo "Infos: $(wc -l < infos.txt)"
```

## Passo 3: Correção automática dos erros críticos (Priority 1)
Estes erros impedem a compilação e devem ser corrigidos primeiro:

### 3.1 Corrigir undefined_identifier e undefined_getter
// turbo
```bash
# Encontrar arquivos com undefined_identifier
grep -n "undefined_identifier\|undefined_getter" critical_errors.txt | cut -d'-' -f3 | sort | uniq
```

**Padrões comuns e correções:**
- `undefined_identifier 'user'` → Verificar importação ou declaração da variável
- `undefined_getter 'email'` → Verificar se a variável é do tipo correto (User vs String)

### 3.2 Corrigir missing_required_argument
// turbo
```bash
# Encontrar parâmetros obrigatórios faltando
grep -n "missing_required_argument" critical_errors.txt
```

**Correção padrão:**
- Adicionar parâmetros `e: exception` onde necessário
- Verificar assinatura dos métodos

### 3.3 Corrigir undefined_named_parameter
// turbo
```bash
# Encontrar parâmetros não definidos
grep -n "undefined_named_parameter" critical_errors.txt
```

### 3.4 Corrigir argument_type_not_assignable
// turbo
```bash
# Encontrar incompatibilidade de tipos
grep -n "argument_type_not_assignable" critical_errors.txt
```

## Passo 4: Validação pós-correção crítica
// turbo
```bash
echo "Verificando se erros críticos foram resolvidos..."
flutter analyze | grep "error -" || echo "✅ Todos os erros críticos resolvidos!"
```

## Passo 5: Correção dos warnings (Priority 2)
// turbo
```bash
# Analisar warnings restantes
if [ -s warnings.txt ]; then
    echo "Corrigindo warnings..."
    grep -n "warning -" warnings.txt
else
    echo "✅ Nenhum warning encontrado"
fi
```

## Passo 6: Correção dos infos (Priority 3)
// turbo
```bash
# Analisar infos
if [ -s infos.txt ]; then
    echo "Corrigindo infos..."
    echo "Principais tipos de infos encontrados:"
    grep "info -" infos.txt | cut -d'-' -f3 | sort | uniq -c | sort -nr
else
    echo "✅ Nenhum info encontrado"
fi
```

## Passo 7: Correções específicas comuns

### 7.1 use_super_parameters
// turbo
```bash
# Encontrar construtores que podem usar super.key
grep -n "use_super_parameters" infos.txt | cut -d'-' -f3
```

### 7.2 strict_top_level_inference
// turbo
```bash
# Encontrar variáveis sem tipo explícito
grep -n "strict_top_level_inference" infos.txt | cut -d'-' -f3
```

### 7.3 use_build_context_synchronously
// turbo
```bash
# Encontrar usos incorretos de context após async
grep -n "use_build_context_synchronously" infos.txt | cut -d'-' -f3
```

### 7.4 deprecated_member_use
// turbo
```bash
# Encontrar métodos deprecated
grep -n "deprecated_member_use" infos.txt | cut -d'-' -f3 | sort | uniq -c | sort -nr
```

## Passo 8: Validação final
// turbo
```bash
echo "=== VALIDAÇÃO FINAL ==="
flutter analyze

# Verificar se projeto compila
echo "Testando compilação..."
flutter build apk --debug --no-pub && echo "✅ Projeto compila com sucesso!" || echo "❌ Erros na compilação"
```

## Passo 9: Limpeza
// turbo
```bash
# Remover arquivos temporários
rm -f lint_analysis.txt critical_errors.txt warnings.txt infos.txt
```

## Comandos de execução rápida

### Executar workflow completo:
```bash
# Copiar e colar este bloco inteiro no terminal
echo "Iniciando workflow de correção de lints..."
flutter analyze --verbose > lint_analysis.txt 2>&1
grep "error -" lint_analysis.txt > critical_errors.txt
grep "warning -" lint_analysis.txt > warnings.txt
grep "info -" lint_analysis.txt > infos.txt
echo "Erros críticos: $(wc -l < critical_errors.txt), Warnings: $(wc -l < warnings.txt), Infos: $(wc -l < infos.txt)"
```

### Verificar progresso:
```bash
flutter analyze | tail -1
```

### Formatar código após correções:
```bash
dart format .
```
