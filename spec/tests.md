# Testes essenciais

## Navegação

- N01: Caso o usuário não tenha registrado o humor na data atual a página Home deve ser exibida;
- N02: Caso o usuário já tenha registrado o humor na data atual a página Relatorio deve ser exibida;
- N03: As rotas devem ser nomeadas para poderem ser acessadas por qualquer Widget;
- N04: Ao transitar entre rotas a rota anterior deve ser destruída;
- N05: O usuário não pode navegar manualmente, a transição sempre será automaticamente conforme as regras N01 e N02;

## Banco de dados

- B01: Os registros deverão ser armazenados localmente no aparelho celular;
- B02: O registro deve ser: Humor, Observação, Dia/Mês/Ano;

## Página Home

- PH01: Deve mostrar 5 botões de humor exatamente na ordem: Horrível, Mal, Mais ou Menos, Bem, Ótimo;
- PH02: É possível escolher somente 1 opção de Humor;
- PH03: É possível escolher apenas 1 Humor por dia;
- PH04: É possível escrever 1 observação por registro;
- PH05: Deve ter 1 botão para salvar o Humor;
- PH06: O registro deve persistir localmente conforme as regras de Banco de dados;

## Página Relatorio

- PR01: Deve mostrar os registros de humor do mês atual em forma de gráfico de linhas;
-- PR01.1: A coluna deve ser de Humores;
-- PR01.2: A linha deve ser de Dias;
- PR02: Deve mostrar o botão de filtro para escolher o ano e mês;
- PR03: Deve mostrar o botão para exportar o relatório em formato PDF;
- PR04: Deve mostrar o botão para tirar print da tela e salvar como imagem;
- PR05: Os botões devem ser exatamente na ordem: Filtrar, Exportar, Imprimir;
- PR06: Os botões devem estar alinhados horizontalmente no centro da tela;