algoritmo "MedControl"
// ============================================================
// MedControl - Sistema de Gerenciamento de Atendimentos de uma
// Clinica Medica (Desafio 1o Bimestre - Tema 2)
// ============================================================
// Conceitos usados:
//  - constantes ............ const
//  - registros ............. TPaciente, TMedico, TConsulta
//  - vetores de registros .. pacientes, medicos, consultas
//  - vetores ............... nomeEsp, nomeDia, nomeHora, ordem...
//  - matriz ................ agenda[medico, horario]
//  - ordenacao ............. bubble sort (pacientes e medicos)
//  - procedimentos/funcoes . varias sub-rotinas
//  - passagem de parametros  por valor e por referencia (var)
//  - variaveis locais/globais
//  - recursividade ......... buscaPacRec e somaFat
//  - validacao de dados .... lerInteiro, lerReal, lerTexto
// ============================================================

const
   MAX_PAC = 50
   MAX_MED = 10
   MAX_CON = 100
   DESC_IDOSO = 30
   DESC_CRIANCA = 20

tipo
   TPaciente = registro
      codigo: inteiro
      nome: caractere
      idade: inteiro
      telefone: caractere
   fimregistro

   TMedico = registro
      codigo: inteiro
      nome: caractere
      esp: inteiro
      valor: real
      realizadas: inteiro
   fimregistro

   TConsulta = registro
      codigo: inteiro
      codPac: inteiro
      codMed: inteiro
      dia: inteiro
      hora: inteiro
      status: inteiro   // 1=Agendada 2=Realizada 3=Cancelada
      valor: real
   fimregistro

var
   // ---------- VARIAVEIS GLOBAIS ----------
   // (VisuAlg exige numeros literais nos limites dos vetores:
   //  50 = MAX_PAC, 10 = MAX_MED, 100 = MAX_CON)
   pacientes: vetor[1..50] de TPaciente
   medicos: vetor[1..10] de TMedico
   consultas: vetor[1..100] de TConsulta
   agenda: vetor[1..10, 1..40] de inteiro   // matriz: medico x (5 dias * 8 horarios)
   ordemPac: vetor[1..50] de inteiro        // indices ordenados por nome
   ordemMed: vetor[1..10] de inteiro        // indices ordenados por consultas realizadas
   contEsp: vetor[1..5] de inteiro          // consultas realizadas por especialidade
   nomeEsp: vetor[1..5] de caractere
   nomeDia: vetor[1..5] de caractere
   nomeHora: vetor[1..8] de caractere
   qtdPac, qtdMed, qtdCon: inteiro
   opcao: inteiro

// ============================================================
// FUNCOES DE VALIDACAO E LEITURA
// ============================================================

// Le um inteiro e so aceita valores entre minimo e maximo
funcao lerInteiro(msg: caractere; minimo, maximo: inteiro): inteiro
var
   v: inteiro
inicio
   repita
      escreva(msg)
      leia(v)
      se (v < minimo) ou (v > maximo) entao
         escreval("  >> Valor invalido! Digite entre ", minimo, " e ", maximo, ".")
      fimse
   ate (v >= minimo) e (v <= maximo)
   retorne v
fimfuncao

// Le um real e so aceita valores entre minimo e maximo
funcao lerReal(msg: caractere; minimo, maximo: real): real
var
   v: real
inicio
   repita
      escreva(msg)
      leia(v)
      se (v < minimo) ou (v > maximo) entao
         escreval("  >> Valor invalido! Digite entre ", minimo:1:2, " e ", maximo:1:2, ".")
      fimse
   ate (v >= minimo) e (v <= maximo)
   retorne v
fimfuncao

// Le um texto com tamanho entre tamMin e tamMax
funcao lerTexto(msg: caractere; tamMin, tamMax: inteiro): caractere
var
   t: caractere
inicio
   repita
      escreva(msg)
      leia(t)
      se (compr(t) < tamMin) ou (compr(t) > tamMax) entao
         escreval("  >> Texto invalido! Use de ", tamMin, " a ", tamMax, " caracteres.")
      fimse
   ate (compr(t) >= tamMin) e (compr(t) <= tamMax)
   retorne t
fimfuncao

// ============================================================
// FUNCOES AUXILIARES
// ============================================================

// Converte (dia, hora) na coluna da matriz agenda (1..40)
funcao slotDe(d, h: inteiro): inteiro
inicio
   retorne (d - 1) * 8 + h
fimfuncao

// Texto do status da consulta (usa ESCOLHA)
funcao textoStatus(s: inteiro): caractere
var
   t: caractere
inicio
   escolha s
      caso 1
         t <- "Agendada"
      caso 2
         t <- "Realizada"
      caso 3
         t <- "Cancelada"
      outrocaso
         t <- "Desconhecido"
   fimescolha
   retorne t
fimfuncao

// RECURSIVIDADE 1: busca paciente pelo codigo, do indice i ate qtdPac
// retorna a posicao no vetor ou 0 se nao achar
funcao buscaPacRec(cod, i: inteiro): inteiro
inicio
   se i > qtdPac entao
      retorne 0
   fimse
   se pacientes[i].codigo = cod entao
      retorne i
   fimse
   retorne buscaPacRec(cod, i + 1)
fimfuncao

// RECURSIVIDADE 2: soma o valor das consultas REALIZADAS de i ate qtdCon
funcao somaFat(i: inteiro): real
inicio
   se i > qtdCon entao
      retorne 0
   fimse
   se consultas[i].status = 2 entao
      retorne consultas[i].valor + somaFat(i + 1)
   fimse
   retorne somaFat(i + 1)
fimfuncao

// Conta quantos horarios livres o medico tem na semana
funcao horariosLivres(cm: inteiro): inteiro
var
   j, livres: inteiro
inicio
   livres <- 0
   para j de 1 ate 40 faca
      se agenda[cm, j] = 0 entao
         livres <- livres + 1
      fimse
   fimpara
   retorne livres
fimfuncao

// PASSAGEM POR REFERENCIA (var): devolve valor final e percentual de desconto
procedimento calcularValor(idade: inteiro; base: real; var valorFinal: real; var perc: inteiro)
inicio
   perc <- 0
   se idade >= 60 entao
      perc <- DESC_IDOSO
   senao
      se idade <= 12 entao
         perc <- DESC_CRIANCA
      fimse
   fimse
   valorFinal <- base - (base * perc / 100)
fimprocedimento

// ============================================================
// INICIALIZACAO
// ============================================================
procedimento inicializar
var
   i, j: inteiro
inicio
   qtdPac <- 0
   qtdMed <- 0
   qtdCon <- 0
   para i de 1 ate 10 faca
      para j de 1 ate 40 faca
         agenda[i, j] <- 0
      fimpara
   fimpara
   nomeEsp[1] <- "Clinica Geral"
   nomeEsp[2] <- "Cardiologia"
   nomeEsp[3] <- "Pediatria"
   nomeEsp[4] <- "Ortopedia"
   nomeEsp[5] <- "Dermatologia"
   nomeDia[1] <- "Segunda"
   nomeDia[2] <- "Terca"
   nomeDia[3] <- "Quarta"
   nomeDia[4] <- "Quinta"
   nomeDia[5] <- "Sexta"
   nomeHora[1] <- "08:00"
   nomeHora[2] <- "09:00"
   nomeHora[3] <- "10:00"
   nomeHora[4] <- "11:00"
   nomeHora[5] <- "14:00"
   nomeHora[6] <- "15:00"
   nomeHora[7] <- "16:00"
   nomeHora[8] <- "17:00"
   para i de 1 ate 5 faca
      contEsp[i] <- 0
   fimpara
fimprocedimento

// ============================================================
// CADASTROS
// ============================================================
procedimento cadastrarPaciente
var
   n: inteiro
inicio
   escreval("--- CADASTRO DE PACIENTE ---")
   se qtdPac >= MAX_PAC entao
      escreval("Limite de pacientes atingido!")
   senao
      qtdPac <- qtdPac + 1
      n <- qtdPac
      pacientes[n].codigo <- n
      pacientes[n].nome <- lerTexto("Nome (3 a 30 letras): ", 3, 30)
      pacientes[n].idade <- lerInteiro("Idade (0 a 120): ", 0, 120)
      pacientes[n].telefone <- lerTexto("Telefone (8 a 11 digitos): ", 8, 11)
      escreval("Paciente cadastrado com codigo ", n, ".")
   fimse
fimprocedimento

procedimento cadastrarMedico
var
   n, i: inteiro
inicio
   escreval("--- CADASTRO DE MEDICO ---")
   se qtdMed >= MAX_MED entao
      escreval("Limite de medicos atingido!")
   senao
      qtdMed <- qtdMed + 1
      n <- qtdMed
      medicos[n].codigo <- n
      medicos[n].nome <- lerTexto("Nome (3 a 30 letras): ", 3, 30)
      escreval("Especialidades:")
      para i de 1 ate 5 faca
         escreval("  ", i, " - ", nomeEsp[i])
      fimpara
      medicos[n].esp <- lerInteiro("Especialidade (1 a 5): ", 1, 5)
      medicos[n].valor <- lerReal("Valor da consulta (R$ 50 a 1000): ", 50, 1000)
      medicos[n].realizadas <- 0
      escreval("Medico cadastrado com codigo ", n, ".")
   fimse
fimprocedimento

// ============================================================
// ORDENACAO (Bubble Sort sobre vetores de indices)
// ============================================================
procedimento ordenarPacientes
var
   i, j, aux: inteiro
inicio
   para i de 1 ate qtdPac faca
      ordemPac[i] <- i
   fimpara
   para i de 1 ate qtdPac - 1 faca
      para j de 1 ate qtdPac - i faca
         se maiusc(pacientes[ordemPac[j]].nome) > maiusc(pacientes[ordemPac[j + 1]].nome) entao
            aux <- ordemPac[j]
            ordemPac[j] <- ordemPac[j + 1]
            ordemPac[j + 1] <- aux
         fimse
      fimpara
   fimpara
fimprocedimento

// Ordem decrescente por consultas realizadas
procedimento ordenarMedicos
var
   i, j, aux: inteiro
inicio
   para i de 1 ate qtdMed faca
      ordemMed[i] <- i
   fimpara
   para i de 1 ate qtdMed - 1 faca
      para j de 1 ate qtdMed - i faca
         se medicos[ordemMed[j]].realizadas < medicos[ordemMed[j + 1]].realizadas entao
            aux <- ordemMed[j]
            ordemMed[j] <- ordemMed[j + 1]
            ordemMed[j + 1] <- aux
         fimse
      fimpara
   fimpara
fimprocedimento

// ============================================================
// LISTAGENS
// ============================================================
procedimento listarPacientes
var
   i, p: inteiro
inicio
   escreval("--- PACIENTES (ordem alfabetica) ---")
   se qtdPac = 0 entao
      escreval("Nenhum paciente cadastrado.")
   senao
      ordenarPacientes
      para i de 1 ate qtdPac faca
         p <- ordemPac[i]
         escreval("Cod ", pacientes[p].codigo, " | ", pacientes[p].nome, " | ", pacientes[p].idade, " anos | Tel: ", pacientes[p].telefone)
      fimpara
   fimse
fimprocedimento

procedimento listarMedicos
var
   i: inteiro
inicio
   escreval("--- MEDICOS ---")
   se qtdMed = 0 entao
      escreval("Nenhum medico cadastrado.")
   senao
      para i de 1 ate qtdMed faca
         escreval("Cod ", medicos[i].codigo, " | ", medicos[i].nome, " | ", nomeEsp[medicos[i].esp], " | R$ ", medicos[i].valor:6:2)
      fimpara
   fimse
fimprocedimento

procedimento listarConsultas
var
   i: inteiro
inicio
   escreval("--- CONSULTAS ---")
   se qtdCon = 0 entao
      escreval("Nenhuma consulta registrada.")
   senao
      para i de 1 ate qtdCon faca
         escreval("#", consultas[i].codigo, " | Pac: ", pacientes[consultas[i].codPac].nome, " | Med: ", medicos[consultas[i].codMed].nome)
         escreval("     ", nomeDia[consultas[i].dia], " ", nomeHora[consultas[i].hora], " | R$ ", consultas[i].valor:6:2, " | ", textoStatus(consultas[i].status))
      fimpara
   fimse
fimprocedimento

// ============================================================
// AGENDA (MATRIZ)
// ============================================================
procedimento mostrarHorariosDia(cm, d: inteiro)
var
   h: inteiro
inicio
   escreval("Horarios de ", nomeDia[d], ":")
   para h de 1 ate 8 faca
      se agenda[cm, slotDe(d, h)] = 0 entao
         escreval("  ", h, " - ", nomeHora[h], " : LIVRE")
      senao
         escreval("  ", h, " - ", nomeHora[h], " : OCUPADO")
      fimse
   fimpara
fimprocedimento

procedimento verAgendaMedico
var
   cm, h, d, c: inteiro
inicio
   se qtdMed = 0 entao
      escreval("Nenhum medico cadastrado.")
   senao
      listarMedicos
      cm <- lerInteiro("Codigo do medico: ", 1, qtdMed)
      escreval("--- AGENDA DE ", medicos[cm].nome, " ---")
      escreval("Horario | Seg   | Ter   | Qua   | Qui   | Sex")
      para h de 1 ate 8 faca
         escreva(nomeHora[h], "   |")
         para d de 1 ate 5 faca
            c <- agenda[cm, slotDe(d, h)]
            se c = 0 entao
               escreva(" ---   |")
            senao
               escreva(" #", c, "    |")
            fimse
         fimpara
         escreval("")
      fimpara
      escreval("Livres na semana: ", horariosLivres(cm), " de 40")
   fimse
fimprocedimento

// ============================================================
// ATENDIMENTOS
// ============================================================
procedimento agendarConsulta
var
   cm, cp, d, h, slot, perc: inteiro
   vf: real
   desistiu: logico
inicio
   escreval("--- AGENDAR CONSULTA ---")
   desistiu <- falso
   se (qtdPac = 0) ou (qtdMed = 0) entao
      escreval("Cadastre ao menos 1 paciente e 1 medico antes de agendar.")
   senao
      se qtdCon >= MAX_CON entao
         escreval("Limite de consultas atingido!")
      senao
         listarMedicos
         cm <- lerInteiro("Codigo do medico: ", 1, qtdMed)
         se horariosLivres(cm) = 0 entao
            escreval("Este medico nao possui horarios livres.")
         senao
            listarPacientes
            cp <- lerInteiro("Codigo do paciente: ", 1, qtdPac)
            repita
               escreval("Dias: 1-Seg 2-Ter 3-Qua 4-Qui 5-Sex")
               d <- lerInteiro("Dia (1 a 5): ", 1, 5)
               mostrarHorariosDia(cm, d)
               h <- lerInteiro("Horario (1 a 8, 0 para desistir): ", 0, 8)
               se h = 0 entao
                  desistiu <- verdadeiro
               senao
                  slot <- slotDe(d, h)
                  se agenda[cm, slot] <> 0 entao
                     escreval("  >> Horario ocupado! Escolha outro.")
                  fimse
               fimse
            ate desistiu ou (agenda[cm, slot] = 0)
            se nao desistiu entao
               calcularValor(pacientes[cp].idade, medicos[cm].valor, vf, perc)
               qtdCon <- qtdCon + 1
               consultas[qtdCon].codigo <- qtdCon
               consultas[qtdCon].codPac <- cp
               consultas[qtdCon].codMed <- cm
               consultas[qtdCon].dia <- d
               consultas[qtdCon].hora <- h
               consultas[qtdCon].status <- 1
               consultas[qtdCon].valor <- vf
               agenda[cm, slot] <- qtdCon
               escreval("Consulta #", qtdCon, " agendada para ", nomeDia[d], " as ", nomeHora[h], ".")
               se perc > 0 entao
                  escreval("Desconto de ", perc, "% aplicado.")
               fimse
               escreval("Valor a pagar: R$ ", vf:6:2)
            senao
               escreval("Agendamento cancelado pelo usuario.")
            fimse
         fimse
      fimse
   fimse
fimprocedimento

procedimento cancelarConsulta
var
   c, slot: inteiro
inicio
   escreval("--- CANCELAR CONSULTA ---")
   se qtdCon = 0 entao
      escreval("Nenhuma consulta registrada.")
   senao
      listarConsultas
      c <- lerInteiro("Numero da consulta: ", 1, qtdCon)
      se consultas[c].status <> 1 entao
         escreval("So e possivel cancelar consultas AGENDADAS. Status atual: ", textoStatus(consultas[c].status))
      senao
         slot <- slotDe(consultas[c].dia, consultas[c].hora)
         agenda[consultas[c].codMed, slot] <- 0
         consultas[c].status <- 3
         escreval("Consulta #", c, " cancelada. Horario liberado.")
      fimse
   fimse
fimprocedimento

procedimento realizarConsulta
var
   c, m: inteiro
inicio
   escreval("--- REGISTRAR CONSULTA REALIZADA ---")
   se qtdCon = 0 entao
      escreval("Nenhuma consulta registrada.")
   senao
      listarConsultas
      c <- lerInteiro("Numero da consulta: ", 1, qtdCon)
      se consultas[c].status <> 1 entao
         escreval("So e possivel realizar consultas AGENDADAS. Status atual: ", textoStatus(consultas[c].status))
      senao
         consultas[c].status <- 2
         m <- consultas[c].codMed
         medicos[m].realizadas <- medicos[m].realizadas + 1
         contEsp[medicos[m].esp] <- contEsp[medicos[m].esp] + 1
         escreval("Consulta #", c, " registrada como REALIZADA.")
      fimse
   fimse
fimprocedimento

// ============================================================
// RELATORIOS
// ============================================================
procedimento relatorios
var
   i, m, ag, re, ca: inteiro
   fat: real
inicio
   escreval("=========== RELATORIOS ===========")
   ag <- 0
   re <- 0
   ca <- 0
   para i de 1 ate qtdCon faca
      escolha consultas[i].status
         caso 1
            ag <- ag + 1
         caso 2
            re <- re + 1
         caso 3
            ca <- ca + 1
      fimescolha
   fimpara
   escreval("Total de consultas: ", qtdCon)
   escreval("  Agendadas : ", ag)
   escreval("  Realizadas: ", re)
   escreval("  Canceladas: ", ca)
   fat <- somaFat(1)
   escreval("Faturamento (realizadas): R$ ", fat:8:2)
   se re > 0 entao
      escreval("Ticket medio: R$ ", fat / re:6:2)
   fimse
   escreval("--- Realizadas por especialidade ---")
   para i de 1 ate 5 faca
      escreval("  ", nomeEsp[i], ": ", contEsp[i])
   fimpara
   escreval("--- Ranking de medicos ---")
   se qtdMed = 0 entao
      escreval("  Nenhum medico cadastrado.")
   senao
      ordenarMedicos
      para i de 1 ate qtdMed faca
         m <- ordemMed[i]
         escreval("  ", i, "o - ", medicos[m].nome, " (", medicos[m].realizadas, " consultas)")
      fimpara
   fimse
fimprocedimento

// ============================================================
// DADOS DE EXEMPLO (para testes e para o video)
// ============================================================
procedimento carregarExemplo
inicio
   se (qtdPac > 0) ou (qtdMed > 0) entao
      escreval("Dados de exemplo so podem ser carregados com o sistema vazio.")
   senao
      pacientes[1].codigo <- 1
      pacientes[1].nome <- "Carlos Silva"
      pacientes[1].idade <- 65
      pacientes[1].telefone <- "12988887777"
      pacientes[2].codigo <- 2
      pacientes[2].nome <- "Ana Souza"
      pacientes[2].idade <- 8
      pacientes[2].telefone <- "12977776666"
      pacientes[3].codigo <- 3
      pacientes[3].nome <- "Bruno Lima"
      pacientes[3].idade <- 30
      pacientes[3].telefone <- "12966665555"
      qtdPac <- 3
      medicos[1].codigo <- 1
      medicos[1].nome <- "Dra. Helena"
      medicos[1].esp <- 1
      medicos[1].valor <- 200
      medicos[1].realizadas <- 0
      medicos[2].codigo <- 2
      medicos[2].nome <- "Dr. Roberto"
      medicos[2].esp <- 2
      medicos[2].valor <- 350
      medicos[2].realizadas <- 0
      qtdMed <- 2
      escreval("Dados de exemplo carregados: 3 pacientes e 2 medicos.")
   fimse
fimprocedimento

procedimento mostrarMenu
inicio
   escreval("")
   escreval("==================================")
   escreval("   MEDCONTROL - CLINICA MEDICA")
   escreval("==================================")
   escreval(" 1 - Cadastrar paciente")
   escreval(" 2 - Cadastrar medico")
   escreval(" 3 - Agendar consulta")
   escreval(" 4 - Cancelar consulta")
   escreval(" 5 - Registrar consulta realizada")
   escreval(" 6 - Listar pacientes (A-Z)")
   escreval(" 7 - Listar medicos")
   escreval(" 8 - Listar consultas")
   escreval(" 9 - Ver agenda do medico")
   escreval("10 - Relatorios")
   escreval("11 - Carregar dados de exemplo")
   escreval(" 0 - Sair")
   escreval("==================================")
fimprocedimento

// ============================================================
// PROGRAMA PRINCIPAL
// ============================================================
inicio
   inicializar
   repita
      mostrarMenu
      opcao <- lerInteiro("Opcao: ", 0, 11)
      escolha opcao
         caso 1
            cadastrarPaciente
         caso 2
            cadastrarMedico
         caso 3
            agendarConsulta
         caso 4
            cancelarConsulta
         caso 5
            realizarConsulta
         caso 6
            listarPacientes
         caso 7
            listarMedicos
         caso 8
            listarConsultas
         caso 9
            verAgendaMedico
         caso 10
            relatorios
         caso 11
            carregarExemplo
         caso 0
            escreval("Encerrando o MedControl. Ate logo!")
      fimescolha
   ate opcao = 0
fimalgoritmo
