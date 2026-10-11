# MedControl — Sistema de Gerenciamento de Atendimentos de uma Clínica Médica

Projeto do **Desafio de Lógica de Programação – 1º Bimestre (Tema 2)**
Engenharia da Computação / Ciência da Computação — UNIVAP

Sistema em modo texto, desenvolvido em **VisuAlg**, para controlar pacientes, médicos, agendamentos e relatórios de uma clínica médica.

---

## Sumário

1. [Funcionalidades](#funcionalidades)
2. [Como executar](#como-executar)
3. [Menu do sistema](#menu-do-sistema)
4. [Regras de negócio](#regras-de-negócio)
5. [Estrutura de dados](#estrutura-de-dados)
6. [Sub-rotinas](#sub-rotinas)
7. [Conceitos da disciplina aplicados](#conceitos-da-disciplina-aplicados)
8. [Validações](#validações)
9. [Roteiro de testes](#roteiro-de-testes)
10. [Limitações conhecidas](#limitações-conhecidas)

---

## Funcionalidades

- Cadastro de pacientes (nome, idade, telefone)
- Cadastro de médicos (nome, especialidade, valor da consulta)
- Agendamento de consultas em agenda semanal por médico
- Cancelamento de consultas, com liberação do horário
- Registro de consultas realizadas
- Listagem de pacientes em **ordem alfabética**
- Listagem de médicos e de consultas
- Visualização da agenda semanal de um médico
- Relatórios: totais por status, faturamento, ticket médio, consultas por especialidade e ranking de médicos
- Carga de dados de exemplo para testes e demonstração

## Como executar

1. Baixe e abra o **VisuAlg** (versão com suporte a `registro` e `const`).
2. Abra o arquivo `MedControl.alg` (menu *Arquivo → Abrir*).
3. Pressione **F9** (ou clique em *Executar*).
4. Use o menu numérico exibido no console.

> Dica: use a opção **11** para carregar dados de exemplo antes de testar.

## Menu do sistema

| Opção | Ação |
|:---:|---|
| 1 | Cadastrar paciente |
| 2 | Cadastrar médico |
| 3 | Agendar consulta |
| 4 | Cancelar consulta |
| 5 | Registrar consulta realizada |
| 6 | Listar pacientes (A–Z) |
| 7 | Listar médicos |
| 8 | Listar consultas |
| 9 | Ver agenda do médico |
| 10 | Relatórios |
| 11 | Carregar dados de exemplo |
| 0 | Sair |

## Regras de negócio

- **Agenda:** cada médico atende de segunda a sexta, em 8 horários por dia (08h–11h e 14h–17h), totalizando 40 horários semanais.
- **Conflito de horário:** um horário ocupado não pode receber outra consulta.
- **Status da consulta:** `1 = Agendada`, `2 = Realizada`, `3 = Cancelada`.
- **Transições permitidas:** apenas consultas *agendadas* podem ser canceladas ou realizadas.
- **Descontos automáticos:**
  - Pacientes com **60 anos ou mais**: 30%
  - Pacientes com **12 anos ou menos**: 20%
- **Faturamento:** considera somente consultas com status *Realizada*.
- **Especialidades:** Clínica Geral, Cardiologia, Pediatria, Ortopedia e Dermatologia.

## Estrutura de dados

### Constantes

| Constante | Valor | Uso |
|---|:---:|---|
| `MAX_PAC` | 50 | Máximo de pacientes |
| `MAX_MED` | 10 | Máximo de médicos |
| `MAX_CON` | 100 | Máximo de consultas |
| `DESC_IDOSO` | 30 | Desconto (%) para idosos |
| `DESC_CRIANCA` | 20 | Desconto (%) para crianças |

### Registros

```
TPaciente:  codigo, nome, idade, telefone
TMedico:    codigo, nome, esp, valor, realizadas
TConsulta:  codigo, codPac, codMed, dia, hora, status, valor
```

### Vetores e matriz (variáveis globais)

| Variável | Tipo | Finalidade |
|---|---|---|
| `pacientes` | vetor de `TPaciente` | Cadastro de pacientes |
| `medicos` | vetor de `TMedico` | Cadastro de médicos |
| `consultas` | vetor de `TConsulta` | Histórico de consultas |
| `agenda[10, 40]` | **matriz** de inteiros | Médico × horário da semana (`0` = livre, senão guarda o nº da consulta) |
| `ordemPac` | vetor de inteiros | Índices dos pacientes ordenados por nome |
| `ordemMed` | vetor de inteiros | Índices dos médicos ordenados por consultas realizadas |
| `contEsp` | vetor de inteiros | Consultas realizadas por especialidade |
| `nomeEsp`, `nomeDia`, `nomeHora` | vetores de texto | Tabelas de apoio |

**Mapeamento da matriz:** a coluna de um horário é calculada por `(dia - 1) * 8 + hora` (função `slotDe`).

**Ordenação por índices:** o *bubble sort* reorganiza vetores auxiliares de índices (`ordemPac`, `ordemMed`) em vez de trocar registros inteiros. Assim os códigos originais permanecem intactos.

## Sub-rotinas

### Funções

| Função | Descrição |
|---|---|
| `lerInteiro` / `lerReal` / `lerTexto` | Leitura com validação de faixa ou tamanho |
| `slotDe` | Converte (dia, hora) na coluna da matriz |
| `textoStatus` | Converte o código do status em texto (`escolha/caso`) |
| `horariosLivres` | Conta horários livres de um médico |
| `buscaPacRec` | **Recursiva** — busca paciente pelo código |
| `somaFat` | **Recursiva** — soma o valor das consultas realizadas |

### Procedimentos

| Procedimento | Descrição |
|---|---|
| `inicializar` | Zera contadores e matriz, preenche tabelas de apoio |
| `cadastrarPaciente` / `cadastrarMedico` | Cadastros com validação |
| `agendarConsulta` / `cancelarConsulta` / `realizarConsulta` | Ciclo de vida da consulta |
| `calcularValor` | Calcula desconto (**passagem por referência** com `var`) |
| `ordenarPacientes` / `ordenarMedicos` | Ordenação (bubble sort) |
| `listarPacientes` / `listarMedicos` / `listarConsultas` | Listagens |
| `mostrarHorariosDia` / `verAgendaMedico` | Exibição da agenda |
| `relatorios` | Relatórios gerenciais |
| `carregarExemplo` | Dados de demonstração |
| `mostrarMenu` | Exibe o menu principal |

## Conceitos da disciplina aplicados

| Conceito | Onde aparece |
|---|---|
| Variáveis simples | `qtdPac`, `qtdMed`, `qtdCon`, `opcao` |
| Constantes | `MAX_*`, `DESC_*` |
| Vetores | `nomeEsp`, `contEsp`, `ordemPac`… |
| Matrizes | `agenda[medico, horário]` |
| Registros | `TPaciente`, `TMedico`, `TConsulta` |
| Vetores de registros | `pacientes`, `medicos`, `consultas` |
| Operadores aritméticos, relacionais e lógicos | Cálculo de desconto, comparações, `e`, `ou`, `nao` |
| Estruturas condicionais | `se / senao` em todo o sistema |
| Múltipla escolha | Menu principal, `textoStatus`, contagem por status |
| Estruturas de repetição | `para`, `repita ... ate` |
| Ordenação | Bubble sort em pacientes (A–Z) e médicos (ranking) |
| Procedimentos e funções | Ver seção [Sub-rotinas](#sub-rotinas) |
| Passagem de parâmetros | Por valor (maioria) e por referência (`calcularValor`) |
| Variáveis locais e globais | Dados globais; `i`, `j`, `aux`, `cm`, `cp` locais |
| Recursividade | `buscaPacRec`, `somaFat` |
| Validação e tratamento de dados | `lerInteiro`, `lerReal`, `lerTexto`, regras de status |

## Validações

| Entrada | Regra |
|---|---|
| Opção do menu | 0 a 11 |
| Nome | 3 a 30 caracteres |
| Idade | 0 a 120 |
| Telefone | 8 a 11 caracteres |
| Especialidade | 1 a 5 |
| Valor da consulta | R$ 50 a R$ 1000 |
| Código de médico/paciente | Dentro dos cadastrados |
| Dia / horário | 1 a 5 / 1 a 8 |
| Horário ocupado | Rejeitado, usuário escolhe outro (ou desiste com `0`) |
| Cancelar / realizar | Somente consultas *agendadas* |
| Limites de capacidade | Bloqueia cadastros além dos máximos |

Em todas as leituras, o sistema repete a pergunta até receber um valor válido.

## Roteiro de testes

1. **Carga inicial:** opção `11` → 3 pacientes e 2 médicos.
2. **Listagem:** opção `6` → pacientes em ordem alfabética (Ana, Bruno, Carlos).
3. **Agendamento com desconto:** agende para Carlos (65 anos) → desconto de 30%; para Ana (8 anos) → 20%.
4. **Conflito:** tente agendar o mesmo médico, dia e horário duas vezes → sistema recusa.
5. **Agenda:** opção `9` → matriz mostrando `#1`, `#2` nos horários ocupados.
6. **Cancelamento:** opção `4` → horário volta a ficar livre.
7. **Realização:** opção `5` → status muda para *Realizada*.
8. **Operação inválida:** tente cancelar uma consulta já realizada → mensagem de erro.
9. **Relatórios:** opção `10` → totais, faturamento, ticket médio, ranking.
10. **Entradas inválidas:** idade `200`, opção `99`, nome com 1 letra → sistema repete a pergunta.

## Limitações conhecidas

- Os limites dos vetores usam números literais, pois o VisuAlg não aceita constantes nas declarações. Ao alterar uma constante `MAX_*`, altere também o vetor correspondente.
- Não há exclusão de pacientes ou médicos (o código é igual à posição no vetor).
- Os dados não são persistidos: ao encerrar o programa, tudo é perdido.
- Os textos não têm acentos para evitar problemas de codificação no console do VisuAlg.

---

**Disciplina:** Lógica de Programação — Engenharia da Computação / Ciência da Computação — UNIVAP
**Linguagem:** VisuAlg
**Arquivo principal:** `MedControl.alg`
