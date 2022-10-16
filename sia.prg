********************************************************************************
/* Programa: SIA.PRG
   Funá∆o..: M¢dulo principal do sistema - Menu de Opá‰es
   Sistema.: Sistema de Informaá‰es Academicas
   Autor...: Edilberto L. Souza e Grazielly Moura
*/
********************************************************************************
// Definiáao dos arquivos-cabeáalho, pseudo-funá‰es e das constantes utilizadas.
#include "SIA.CH"
#include "SET.CH"
// Comando especial para o rel¢gio
#xcommand DEFAULT <v1> ON <t1> TO <x1> [, <vn> ON <tn> TO <xn> ] => ;
          IF !( ValType( <v1> ) $ <t1> ) ; <v1> := <x1> ; END                 ;
          [; IF ! ValType( <vn> ) $ <tn> ; <vn> := <xn> ; END ]
// vari†vel do rel¢gio
STATIC aH_Timers:={}

********************************************************************************
EXIT PROCEDURE SaidaSistema
********************************************************************************
CLOSE DATABASE
RETURN

********************************************************************************
PROCEDURE Main(par1)
// Procedimento principal
********************************************************************************
IF par1 <> NIL
   IF UPPER(ALLTRIM(par1))="/VERSAO"
      CLEAR
      ? cSgSist
      ? VERSION()
      ? HB_Compiler()
      ? OS()
      RETURN
   ENDIF
ENDIF
// Declaraáao das variaveis P£blicas.
// Vari†veis para impress∆o
PUBLIC vcia05,vcid05,vcia10,vcid10,vcia12,vcia20,vcia15,vcia17,vciaip
// Configuraá∆o para impressoras Epson LX-810 e LX-300
vcia05:=CHR(14)          // ativa a expans∆o em uma linha
vcid05:=CHR(20)          // desativa a expans∆o
vcia10:=CHR(27)+"P"      // impress∆o a 10 cpp
vcid10:=CHR(18)          // desativa a condensaá∆o de caracteres
vcia12:=CHR(27)+"M"      // impress∆o a 12 cpp
vcia20:=CHR(15)          // ativa condensaá∆o de caracteres
vcia15:=CHR(15)          // ativa condensaá∆o a 15 cpp
vcia17:=CHR(15)          // ativa a impress∆o para 163 caractere
vciaip:=CHR(27)+"P"      // ativa a impress∆o
// Vari†veis para cores na tela
PUBLIC vcn, vci, vca, vcp, vcr, vcm, vcf, vcia, tk, hlp:=0
// Padr∆o Azul
vcn:="W/N,N/W,,,W+/B"
vci:="W+/B,W/N,,,B/W+"
vca:="W+/N,N/W,,,B/W+"
vcp:="W+/N,N/W,,,B/W+"
vcr:="W+/B,N/W,,,B/W+"
vcm:="W/N,W+/B,,,W+/B"
vcf:="W+/BG,GR+/B,,,W+/B"
PUBLIC vcd:="G/N,N/W,,,G/N"
PUBLIC vcorGet:="G/N,N/W"
//
PUBLIC vcPrnPadrao, mPrinters
PUBLIC vcporta:="1",vcimpres:="LPT1"
PUBLIC vcabpg:=.T.,pg:=0,ncol:=80,vcop:=1
PUBLIC frame[8], mp := 1
PUBLIC vcodi,vcodf,vclin:=4,vccol:=50
PUBLIC dirbase
// Definiá‰es globais de ambiente de trabalho.
SET EPOCH TO 1960        // Seleciona sÇculo.
SET DATE BRITISH         // Coloca vari†veis data no formato dd/mm/aa.
SETCURSOR(0)             // Desliga a apresentaáao do cursor.
SET CONSOLE OFF          // Desliga a apresentaáao de sa°das de comandos.
SET DELETED ON           // Ignora os registros deletados no processamento.
SET KEY K_F10 TO Calc()
SET KEY K_CTRL_P TO MudaPrnPadrao()

REQUEST DBFCDX           // Requisita RDD do FoxPro
RDDSETDEFAULT("DBFCDX")  // RDDSETDEFAULT("_DBFCDX")
DBSETDRIVER("DBFCDX")

// Definiáao das molduras a serem utilizadas no comando @...BOX.
frame[1]:=CHR(218)+CHR(196)+CHR(191)+CHR(179)+CHR(217)+CHR(196)+CHR(192)+CHR(179)+SPACE(1)
frame[2]:=CHR(201)+CHR(205)+CHR(187)+CHR(186)+CHR(188)+CHR(205)+CHR(200)+CHR(186)+SPACE(1)
frame[3]:=CHR(201)+CHR(205)+CHR(187)+CHR(186)+CHR(188)+CHR(205)+CHR(200)+CHR(186)+CHR(176)
frame[4]:=CHR(201)+CHR(205)+CHR(187)+CHR(186)+CHR(188)+CHR(205)+CHR(200)+CHR(186)+CHR(177)
frame[5]:=CHR(194)+CHR(196)+CHR(194)+CHR(179)+CHR(217)+CHR(196)+CHR(192)+CHR(179)+SPACE(1)
frame[6]:=CHR(218)+CHR(196)+CHR(191)+CHR(179)+CHR(217)+CHR(196)+CHR(192)+CHR(179)+SPACE(1)
frame[7]:=CHR(178)
// Exibiá∆o do nome do sistema
SetConsoleTitle(cNmSist)
// Montagem da Linha de status no topo da tela.
CLEAR
vcia:=vci
SETCOLOR(vci)
@ 01,00 SAY SPACE(12)+"∫"+SPACE(12)+"∫"+SPACE(32)+"∫"+SPACE(10)+"∫"+SPACE(10)
// Mostra o rel¢gio e data
HB_Event( "UdfClock1", .T., {|| Clock(01,60,"W+/B") },100)
@ 01,71 SAY DATE()
@ 01,26 SAY PADC(cSgSist,32)
SETCOLOR(vcn)
Sinal("ABERTURA","ACESSO")
// Montagem da tela de abertura do sistema.
@ 02,00,04,79 BOX frame[1]
SETCOLOR(vcr)
@ 03,02 SAY PADC(cNmSist,76)
SETCOLOR(vcn)
FOR i=6 TO 11
    @ i,i-6,29-i,79-(i-6) BOX frame[7]
NEXT
@ 11,06,18,73 BOX frame[4]
SETCOLOR(vca)
@ 13,13 SAY PADC(cNmSist,54)
SETCOLOR(vcn)
@ 14,13 SAY PADC("Copyright(C) Edilberto Lima de Souza",54)
@ 15,13 SAY PADC("             Grazielly Moura        ",54)
@ 16,13 SAY PADC("2012",54)
Aviso(24,"Acione Qualquer Tecla Para Continuar")
INKEY(0)
// Verifica se a base de dados foi criada
IF !FILE((cDirBase+"Turmas.DBF"))
   CriaBase()
ENDIF
// Verifica se existe os arquivos de °ndices
IF !FILE((cDirBase+"PROFESSORE1.CDX"))
   Indexa(.F.)
ENDIF
@ 24,00 CLEAR
Abrejan(4)
// Construáao da tela do menu principal.
@ 03,01 SAY SPACE(78)
@ 04,00 SAY "Ã"+REPLICATE(CHR(196),78)+"π"
// Opáoes do menu principal.
@ 03, 02 SAY " Cadastros   "
@ 03, 22 SAY " Utilit†rios "
@ 03, 42 SAY " Fim "
vt1:=SAVESCREEN(01,00,24,79)  // Salva tela para posterior uso.
SET MESSAGE TO 24 CENTER      // Mensagens dos @ PROMPT's centralizada na linha 24.
DO WHILE .T.
   IF vcia#vci
      // remonta a tela para o caso de mudanáa de cor
      SETCOLOR(vci)
      // Montagem da Linha de status no topo da tela.
      @ 01,00 SAY SPACE(12)+"∫"+SPACE(12)+"∫"+SPACE(32)
      @ 01,71 SAY DATE()
      @ 01,26 SAY PADC(cSgSist,32)
      SETCOLOR(vcn)
      vt1:=SAVESCREEN(01,00,24,79)  // Salva tela para posterior uso.
      vcia:=vci
   ENDIF
   // Apresenta o sinal na linha de status.
   Sinal("MENU","PRINCIPAL")
   m1:=1
   IF mp=1  // Primeira opáao do menu principal - Cadastro.
      SETCOLOR(vci)
      @ 03,02 SAY " Cadastros   "
      SETCOLOR(vcn)
      // Linha, coluna e n£mero de opáoes do menu de n°vel 1.
      lin1:=4;col1:=2;nop1:=4
      // Vetores das opáoes e mensagens do menu de n°vel 1.
      PRIVATE vop[nop1],vme[nop1]
      vop[1] :="Professores    "
      vop[2] :="Alunos         "
      vop[3] :="Disciplinas    "
      vop[4] :="Turmas         "
      vme[1] :="Consulta ao Cadastro de Professores"
      vme[2] :="Consulta ao Cadastro de Alunos"
      vme[3] :="Consulta ao Cadastro de Disciplinas"
      vme[4] :="Consulta ao Cadastro de Turmas"
      // Moldura do menu de n°vel 1.
      Caixa(lin1,col1,lin1+nop1+1,col1+16,frame[5])
      @ 24,00 CLEAR
      Aviso(24,vme[1])
      op:=m1
      SETCOLOR(vcm)
      // Executa o primeiro menu de n°vel 1.
      m1:=ACHOICE(lin1+1,col1+1,lin1+nop1,col1+15,vop,.T.,"Fch")
      SETCOLOR(vcn)
      IF m1#0
         // Ressalta a opáao escolhida pelo usu†rio.
         SETCOLOR(vci)
         @ lin1+m1,col1+1 SAY vop[m1]
         SETCOLOR(vcn)
      ENDIF
      IF m1=1
         // Menu de nivel 2: Professores
         Professores()
      ELSEIF m1=2
         // Menu de nivel 2: Alunos
         Alunos()
      ELSEIF m1=3
         // Menu de nivel 2: Disciplinas
         Disciplinas()
      ELSEIF m1=4
         // Menu de nivel 2: Turma
         Turmas()
      ENDIF
   ELSEIF mp=2
      // Segunda opáao do menu principal - Utilit†rios do sistema.
      SETCOLOR(vci)
      @ 03,22 SAY " Utilit†rios "
      SETCOLOR(vcn)
      // Linha, coluna e n£mero de opáoes do menu.
      lin1:=4;col1:=22;nop1:=5
      // Vetores de opáoes e mensagens.
      PRIVATE vop[nop1],vme[nop1]
      vop[1]:="Reorganizaá∆o  "
      vop[2]:="Back-Up        "
      vop[3]:="Recuperaá∆o    "
      vop[4]:="Sobre          "
      vop[5]:="Agradecimentos "
      vme[1]:="Indexaá∆o dos Arquivos do Sistema"
      vme[2]:="Gravaá∆o de C¢pias de Seguranáa em Disquetes"
      vme[3]:="Recuperaá∆o das C¢pias de Seguranáa dos Disquetes"
      vme[4]:="Informaá‰es sobre o Sistema"
      vme[5]:="Agradecimentos pela Criaá∆o do Sistema"
      Caixa(lin1,col1,lin1+nop1+1,col1+16,frame[5])
      @ 24,00 CLEAR
      Aviso(24,vme[1])
      op:=m1
      SETCOLOR(vcm)
      // Constr¢i e apresenta o menu.
      m1:=ACHOICE(lin1+1,col1+1,lin1+nop1,col1+15,vop,.T.,"Fch")
      SETCOLOR(vcn)
      IF m1#0
         // Ressalta a opáao escolhida.
         SETCOLOR(vci)
         @ lin1+m1,col1+1 SAY vop[m1]
         SETCOLOR(vcn)
      ENDIF
      IF m1=1
         // Indexaá∆o dos arquivos de dados
         Indexa(.T.)
      ELSEIF m1=2
         // Gravaá∆o de c¢pias de seguranáa em disquetes.
         //Backup()
         Mensagem("Rotina a implementar")
      ELSEIF m1=3
         // Recuperaá∆o das c¢pias para o disco r°gido.
         //Recuperacao()
         Mensagem("Rotina a implementar")
      ELSEIF m1=4
         // Informaá‰es sobre o Sistema
         Sobre()
      ELSEIF m1=5
         // Agradecimentos pela Criaá∆o do Sistema
         Agradecimentos()
      ENDIF
   ELSE //IF mp=3
      // Ultima opáao do menu principal.
      SETCOLOR(vci)
      @ 03,42 SAY " Fim "
      SETCOLOR(vcn)
      lin1:=4;col1:=42;nop1:=2
      PRIVATE vop[nop1],vme[nop1]
      vop[1]:="N∆o"
      vop[2]:="Sim"
      vme[1]:="N∆o Finaliza, Retorna ao Menu"
      vme[2]:="Finaliza, Retorna ao Sistema Operacional"
      Caixa(lin1,col1,lin1+nop1+1,col1+4,frame[5])
      @ 24,00 CLEAR
      Aviso(24,vme[m1])
      op:=m1
      SETCOLOR(vcm)
      m1:=ACHOICE(lin1+1,col1+1,lin1+nop1,col1+3,vop,.T.,"Fch")
      SETCOLOR(vcn)
      IF m1#0
         SETCOLOR(vci)
         @ lin1+m1,col1+1 SAY vop[m1]
         SETCOLOR(vcn)
      ENDIF
      IF m1=2
         EXIT
      ELSEIF m1=1
         mp:=1
         LOOP
      ENDIF
   ENDIF
   // Retorna ao in°cio do DO WHILE do menu principal para reapresent†-lo.
   RESTSCREEN(01,00,24,79,vt1)
ENDDO
TelaFin()
RETURN

// Funá‰es do rel¢gio

*****************************************************************************
FUNCTION Clock(lin,col,cor)
*****************************************************************************
STATIC cTime:=""
DEFAULT lin  ON "N" TO 0
DEFAULT col  ON "N" TO 0
DEFAULT cor  ON "C" TO "GR+/B"
IF cTime <> TIME()
   @ lin,col SAY TIME() COLOR cor
   cTime:=TIME()
ENDIF
RETURN NIL

******************************************************************************
FUNCTION HB_Event(cIDName,lActiv,bCode,nTime)
*****************************************************************************
* Gerencia um Timer
* ParÉmetros: cIDName -> Nome do Timer
*             lActiv  -> Estado inicial
*             bCode   -> Block de c¢digo para executar
*             nTime   -> Intervalo de execuá∆o 100 = 1 seg
* Retorno: Nulo
* Dependàcias: HB_Eval_Event(), ProxExc()
******************************************************************
LOCAL nHD,nHPos
LOCAL nHandle,lHandle
IF VALTYPE(cIDName) == "U" .AND. VALTYPE(lActiv) == "U"
   RETURN lHandle
ENDIF
DEFAULT cIDName  ON "C" TO "*"
DEFAULT lActiv   ON "L" TO .T.
// lActiv:=IIF(cIDName=="*",.F.,lActiv)   // * desativa todos

IF cIDName <> "*"
   nHPos:=ASCAN(aH_Timers,{|nI| nI[1] == cIDName})
ELSE
   IF ! lActiv
      HB_IdleDel(nHandle)
      lHandle := .F.
    ELSE
      nHandle := HB_IdleAdd( {|| HB_Eval_Event( ) } )
      lHandle := .T.
   ENDIF
   RETURN lHandle
ENDIF
IF (nHPos==0 .AND. VALTYPE(lActiv) == "L")
   AADD(aH_Timers,{ cIDName,.T.,bCode,nTime,lActiv,ProxExc(1)})
   //                 nome,exec,Bloco,tempo,Ativo,proxima execucao
ELSE
   IF lActiv == .F.
      aH_Timers[nHpos][5]:=.F.
    ELSE
      aH_Timers[nHpos][5]:=.T.
   ENDIF
ENDIF
IF nHandle == NIL
   nHandle := HB_IdleAdd( {|| HB_Eval_Event( ) } )
   lHandle := .T.
ENDIF
RETURN lHandle

******************************************************************************
FUNCTION HB_Eval_Event( )
*****************************************************************************
LOCAL nI,nC:=COL(),nR:=ROW()
STATIC nCont:=0
nCont ++
FOR nI := 1 TO LEN(aH_Timers)
    aH_Timers[nI][2]:=.F.   // n∆o ser† rÇ-excutado durante a execuá∆o
    IF aH_Timers[nI][5] .AND. aH_Timers[nI][6] <= ProxExc() .AND. aH_Timers[nI][5]
       EVAL(aH_Timers[nI][3])
       aH_Timers[nI][6]:=ProxExc(aH_Timers[nI][4])
    ENDIF
    aH_Timers[nI][2]:=.T.
NEXT
DEVPOS(nR,nC)
RETURN NIL

******************************************************************************
FUNCTION ProxExc(nTempo)
*****************************************************************************
* Gera uma string para comparaá∆o futura de tempos de execuá∆o
* ParÉmetros: nSegundos
* Retorno: String no formato "dias_de_2000,segndos_de_0h"
* Dependàcias:Comando Default
***************************************************************
LOCAL cNext,nSec,cDias,dData:=DATE()
DEFAULT nTempo ON "N" TO 0
nSec:=Seconds()+(nTempo/100)
IF nSec > 86399    // segundos em um dia
   nSec:=86399-nSec
   dData ++
ENDIF
cDias:=LTRIM(STR(INT(dData-CTOD("01/01/2000"))))
cNext:=cDias+","+LTRIM(STR(INT(nSec)))
RETURN cNext

// Outras Funá‰es

********************************************************************************
PROCEDURE Fch(modo,lin)
/*
Objetivo__: faz parte da funáao ACHOICE() que constr¢i o primeiro n°vel de menus.
ParÉmetros: modo: estado da funáao ACHOICE()
lin_______: linha sobre a qual est† a barra seletora.
*/
********************************************************************************
IF modo=3
   IF LASTKEY()=13
      // Pressionada a tecla <Enter> - finaliza com uma escolha.
      RETURN(1)
   ELSEIF LASTKEY()=27
      // Pressionada a tecla <Esc> - finaliza sem escolher.
      RETURN(0)
   ELSEIF LASTKEY()=4
      // Pressionada a tecla para a direta - desloca o menu.
      IF mp<3
         mp++
      ELSE
         mp:=1
      ENDIF
      m:=1;op:=1
      // Finaliza.
      RETURN(0)
   ELSEIF LASTKEY()=19
      // Pressionada a tecla para a esquerda - desloca o menu.
      IF mp=1
         mp:=3
      ELSE
         mp--
      ENDIF
      m:=1;op:=1
      // Finaliza.
      RETURN(0)
   ELSE
      // Pressionada qualquer outra tecla - continua o menu.
      RETURN(3)
   ENDIF
ELSE
   // Em qualquer outro caso apresenta a mensagem de orientaáao na linha 24
   @ 24,00 CLEAR
   Aviso(24,vme[lin])
   RETURN(2)
ENDIF

******************************************************************************
FUNCTION TelaFin()
*****************************************************************************
// Fim das operaáoes.
Abrejan(4)
SETCOLOR(vcp)
Aviso(11,"  Atená∆o !  ")
SETCOLOR(vca)
Aviso(13," N∆o Esqueáa de Atualizar suas C¢pias de Seguranáa ! ")
SETCOLOR(vcn)
INKEY(2)
@ 02,00 CLEAR
Caixa(08,00,15,79,frame[4])
SETCOLOR(vcp)
Beep(2)
Aviso(11," Fim das Operaá‰es ! ")
SETCOLOR(vcn)
INKEY(3)
CLOSE DATABASE
CLEAR
SETCURSOR(1)
RETURN

******************************************************************************
FUNCTION Sobre()
*****************************************************************************
LOCAL vtela:=SAVESCREEN(01,00,24,79)
LOCAL vcol:=3; vtam:=73
SETCOLOR("W+/RB")
@ 03,vcol SAY PADC(" Sobre ",vtam)
SETCOLOR(vcf)
@ ROW()+1,vcol SAY PADR(" ",vtam)
@ ROW()+1,vcol SAY PADC(cNmSist+" - "+cSgSist,vtam)
@ ROW()+1,vcol SAY PADR(" ",vtam)
@ ROW()+1,vcol SAY PADR(" Demonstraá∆o de utilizaá∆o da Linguagem Clipper",vtam)
@ ROW()+1,vcol SAY PADR(" Solicitado pelo Prof. Ciro Coelho",vtam)
@ ROW()+1,vcol SAY PADR(" ",vtam)
@ ROW()+1,vcol SAY PADR(" Autores:",vtam)
@ ROW()+1,vcol SAY PADR(" Edilberto Souza <edilberto.sss@gmail.com>",vtam)
@ ROW()+1,vcol SAY PADR(" Grazielly Moura <graziy.m@gmail.com>",vtam)
@ ROW()+1,vcol SAY PADR(" ",vtam)
@ ROW()+1,vcol SAY PADR(" Compilado com "+version(),vtam)
@ ROW()+1,vcol SAY PADR(" Linkeditado com "+hb_compiler(),vtam)
@ ROW()+1,vcol SAY PADR(" Sobre o "+STRTRAN(os(),"Windows  Windows Vista","Microsoft Windows"),vtam)
@ ROW()+1,vcol SAY PADR(" ",vtam)
SETCOLOR("W+/RB")
@ ROW()+1,vcol SAY PADC("Pressione qualquer tecla para retornar",vtam)
SETCOLOR(vcn)
INKEY(0)
RESTSCREEN(01,00,24,79,vtela)
RETURN

******************************************************************************
FUNCTION Agradecimentos()
*****************************************************************************
LOCAL vtela:=SAVESCREEN(01,00,24,79)
LOCAL vcol:=3; vtam:=73
SETCOLOR("W+/RB")
@ 03,vcol SAY PADC(" Agradecimentos ",vtam)
SETCOLOR(vcf)
@ ROW()+1,vcol SAY PADR(" ",vtam)
@ ROW()+1,vcol SAY PADR("        Agradeáemos primeiramente a Deus, supremo Criador!",vtam)
@ ROW()+1,vcol SAY PADR("        e a seu Filho Jesus Cristo, Salvador e Sustentador",vtam)
@ ROW()+1,vcol SAY PADR("        de toda a criaá∆o.",vtam)
@ ROW()+1,vcol SAY PADR(" ",vtam)
@ ROW()+1,vcol SAY PADR("        A nossa fam°lia, pela paciància e compreens∆o pelo",vtam)
@ ROW()+1,vcol SAY PADR("        tempo dedicado a esta obra.",vtam)
@ ROW()+1,vcol SAY PADR(" ",vtam)
@ ROW()+1,vcol SAY PADR("        E ao Prof. Ciro Coelho, que nos incentivou solicitando",vtam)
@ ROW()+1,vcol SAY PADR("        a criaá∆o deste sistema.",vtam)
@ ROW()+1,vcol SAY PADR(" ",vtam)
@ ROW()+1,vcol SAY PADR("        E finalmente, aos nossos colegas que deram atená∆o a",vtam)
@ ROW()+1,vcol SAY PADR("        apresentaá∆o deste trabalho.",vtam)
@ ROW()+1,vcol SAY PADR(" ",vtam)
SETCOLOR("W+/RB")
@ ROW()+1,vcol SAY PADC("Pressione qualquer tecla para retornar",vtam)
SETCOLOR(vcn)
INKEY(0)
RESTSCREEN(01,00,24,79,vtela)
RETURN

********************************************************************************
//                                   F  i  m
********************************************************************************

