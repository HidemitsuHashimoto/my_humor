# Análise da spec para desenvolvimento

## Visão geral

App **my_humor**: registro diário de humor do usuário e relatório mensal (gráfico + filtro + exportação).

---

## Regras de negócio (index.md)

- **Home**: exibida quando o usuário **não** registrou humor **no dia atual**.
- **Relatorio**: exibida quando o usuário **já** registrou humor **no dia atual**.
- Relatórios baseados no mês atual ou no mês escolhido no filtro.
- Protótipos: `home.png` e `relatorio.png` (ilustrativos; aplicar boas práticas UX/UI).

---

## Testes essenciais (tests.md) – checklist

### Navegação (N01–N05)

| ID   | Regra |
|------|--------|
| N01  | Sem registro hoje → exibir **Home** |
| N02  | Com registro hoje → exibir **Relatorio** |
| N03  | Rotas **nomeadas** (acessíveis por qualquer Widget) |
| N04  | Ao trocar de rota, a rota anterior é **destruída** |
| N05  | **Sem** navegação manual; transição automática conforme N01/N02 |

### Banco de dados (B01–B02)

| ID   | Regra |
|------|--------|
| B01  | Dados armazenados **localmente** no dispositivo |
| B02  | Registro: **Humor**, **Observação**, **Dia/Mês/Ano** |

### Página Home (PH01–PH06)

| ID   | Regra |
|------|--------|
| PH01 | 5 botões de humor, **ordem**: Horrível, Mal, Mais ou Menos, Bem, Ótimo |
| PH02 | Apenas **1** opção de humor por seleção |
| PH03 | Apenas **1** humor **por dia** |
| PH04 | **1** observação por registro |
| PH05 | **1** botão para salvar o humor |
| PH06 | Persistência local conforme B01/B02 |

### Página Relatorio (PR01–PR06)

| ID   | Regra |
|------|--------|
| PR01 | Gráfico de **linhas** com registros do mês atual (eixo Y: Humores; eixo X: Dias) |
| PR02 | Botão de **filtro** (ano e mês) |
| PR03 | Botão para **exportar** relatório em **PDF** |
| PR04 | Botão para **print** da tela e salvar como **imagem** |
| PR05 | Ordem dos botões: **Filtrar**, **Exportar**, **Imprimir** |
| PR06 | Botões alinhados **horizontalmente ao centro** |

---

## Stack sugerida (alinhada às regras do projeto)

- **Estado**: Riverpod  
- **Rotas**: AutoRoute (rotas nomeadas, replace para “destruir” anterior)  
- **Injeção**: get_it  
- **Estado de UI**: freezed  
- **Persistência local**: sqflite ou drift (SQLite) ou hive  
- **Gráfico**: fl_chart ou similar (linhas)  
- **PDF**: pdf + printing  
- **Print/Imagem**: screenshot ou printing  

---

## Estrutura de pastas sugerida (clean architecture)

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── database/          # contrato + implementação local
│   ├── routes/             # AutoRoute
│   └── theme/
├── features/
│   ├── home/
│   │   ├── controllers/
│   │   ├── pages/
│   │   └── widgets/
│   ├── relatorio/
│   │   ├── controllers/
│   │   ├── pages/
│   │   └── widgets/
│   └── mood_registration/  # entidade + repositório (Humor, Observação, Data)
│       ├── entities/
│       ├── repositories/
│       └── models/
└── shared/
    └── widgets/
```

---

## Ordem de implementação sugerida

1. **Entidade + repositório**: modelo de registro (Humor, Observação, Data) e persistência local.
2. **Rotas**: duas rotas nomeadas (Home, Relatorio) e lógica de rota inicial (registrou hoje? → Relatorio, senão → Home).
3. **Página Home**: 5 botões de humor, campo observação, botão salvar, 1 humor/dia.
4. **Página Relatorio**: gráfico de linhas do mês, filtro ano/mês, botões Filtrar / Exportar PDF / Imprimir (ordem e alinhamento conforme PR05/PR06).

---

## Observações

- Protótipos `home.png` e `relatorio.png` não estão na pasta `spec/`; usar descrições da spec e boas práticas de UX/UI.
- N04: usar `replace` (ou equivalente no AutoRoute) ao ir para Home/Relatorio para que a tela anterior seja descartada.
- PH03: na Home, desabilitar ou ocultar se já existir registro para a data atual; na navegação inicial, isso já direciona para Relatorio (N02).
