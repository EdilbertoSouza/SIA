********************************************************************************
/* Programa: SIA_FUNCOES.PRG
   Funá∆o..: Biblioteca de funá‰es do sistema.
   Sistema.: Sistema de Informaá‰es Academicas
   Autor...: Edilberto L. Souza e Grazielly Moura
*/
********************************************************************************
// Definiáao dos arquivos-cabeáalho e das constantes utilizadas.
STATIC vlin                      // Variavel estatica
#include "SIA.CH"
#include "SETCURS.CH"            // Formato do cursor
#include "COMMON.CH"

******************************************************************************
FUNCTION Calc()
// Calculadora volante
******************************************************************************
LOCAL vtela,vdado,lin:=vclin,col:=vccol,vcor,vcur,vnum:=0,vope
vtela:=SAVESCREEN(lin,col,lin+16,col+27)
vcor:=SETCOLOR(vcn)
vcur:=SETCURSOR(0)
vdado:=vope:=""
Caixa(lin,col,lin+15,col+25,frame[1])
@ lin+1,col+2,lin+3, col+23 BOX frame[3]
SETCOLOR(vci)
@ lin+05,col+04 SAY " 7 "
@ lin+05,col+09 SAY " 8 "
@ lin+05,col+14 SAY " 9 "
@ lin+05,col+19 SAY " R "
@ lin+07,col+04 SAY " 4 "
@ lin+07,col+09 SAY " 5 "
@ lin+07,col+14 SAY " 6 "
@ lin+07,col+19 SAY " * "
@ lin+09,col+04 SAY " 1 "
@ lin+09,col+09 SAY " 2 "
@ lin+09,col+14 SAY " 3 "
@ lin+09,col+19 SAY " / "
@ lin+11,col+04 SAY " 0 "
@ lin+11,col+09 SAY " . "
@ lin+11,col+14 SAY " + "
@ lin+11,col+19 SAY " - "
@ lin+13,col+04 SAY " C "
@ lin+13,col+09 SAY " Ò "
@ lin+13,col+14 SAY " =Enter "
SETCOLOR(vcn)
@ lin+8 ,col+25 SAY CHR(24)
@ lin+8 ,col    SAY CHR(25)
@ lin   ,col+23 SAY CHR(26)
@ lin   ,col+2  SAY CHR(27)
SETCOLOR(vca)
@ lin+02,col+3 SAY VAL(vdado) PICTURE "@E 9,999,999,999,999.99"
SETCOLOR(vcn)
tcalc:=SAVESCREEN(lin,col,lin+15,col+25)
SETCOLOR(vca)
DO WHILE .T.
   vdado:=""
   FOR i=1 TO 20
       tk:=INKEY(0)
       IF tk=45 .AND. EMPTY(vdado)
          vdado:="-"
          @ lin+02,col+3 SAY PADL(vdado,20)
              ELSEIF tk>=48 .AND. tk<=57
          IF EMPTY(vdado)
             @ lin+02,col+3 SAY SPACE(20)
          ENDIF
          vdado:=ALLTRIM(vdado)+CHR(tk)
          @ lin+02,col+23-LEN(vdado) SAY vdado
       ELSEIF tk=46
          IF !"."$vdado
             vdado:=ALLTRIM(vdado)+CHR(tk)
             @ lin+02,col+23-LEN(vdado) SAY vdado
          ENDIF
       ELSEIF tk=99
          vnum:=0
          vdado:=vope:=""
          EXIT
       ELSEIF tk=43
          vdado:=ALLTRIM(STR(vnum+VAL(vdado)))
          vope:="+"
          EXIT
       ELSEIF tk=45
          vdado:=ALLTRIM(STR(IF(vnum#0,vnum-VAL(vdado),VAL(vdado))))
          vope:="-"
          EXIT
       ELSEIF tk=42
          vdado:=ALLTRIM(STR(IF(vnum#0,vnum*VAL(vdado),VAL(vdado))))
          vope:="*"
          EXIT
       ELSEIF tk=47
          vdado:=ALLTRIM(STR(IF(vnum#0 .AND. VAL(vdado)#0,vnum/VAL(vdado),VAL(vdado))))
          vope:="/"
          EXIT
       ELSEIF tk=114
          vdado:=ALLTRIM(STR(SQRT(VAL(vdado))))
          EXIT
       ELSEIF tk=K_ENTER
          IF vope="+"
             vdado:=ALLTRIM(STR(vnum+VAL(vdado)))
          ELSEIF vope="-"
             vdado:=ALLTRIM(STR(vnum-VAL(vdado)))
          ELSEIF vope="*"
             vdado:=ALLTRIM(STR(vnum*VAL(vdado)))
          ELSEIF vope="/" .AND. VAL(vdado)#0
             vdado:=ALLTRIM(STR(vnum/VAL(vdado)))
          ENDIF
          EXIT
       ELSEIF tk=K_RIGHT .OR. tk=K_LEFT .OR. tk=K_UP .OR. tk=K_DOWN
          RESTSCREEN(lin,col,lin+16,col+27,vtela)
          IF tk=K_RIGHT
             IF col<53
                ++col
             ENDIF
          ELSEIF tk=K_LEFT
             IF col>0
                --col
             ENDIF
          ELSEIF tk=K_DOWN
             IF lin<9
                ++lin
             ENDIF
          ELSEIF tk=K_UP
             IF lin>1
                --lin
             ENDIF
          ENDIF
          vtela:=SAVESCREEN(lin,col,lin+16,col+27)
          SETCOLOR(vcn)
          Caixa(lin,col,lin+15,col+25,frame[1])
          RESTSCREEN(lin,col,lin+15,col+25,tcalc)
          EXIT
       ELSEIF tk=K_ESC
          SETCOLOR(vcor)
          SETCURSOR(vcur)
          RESTSCREEN(lin,col,lin+16,col+27,vtela)
          vclin:=lin;vccol:=col
          RETURN(VAL(vdado))
       ENDIF
   NEXT
   SETCOLOR(vca)
   @ lin+02,col+3 SAY VAL(vdado) PICTURE "@E 9,999,999,999,999.99"
   vnum:=IF(VAL(vdado)#0,VAL(vdado),vnum)
ENDDO

*******************************************************************************
FUNCTION Zeracod(cod)
// Objetivo: coloca zeros a esquerda dos c¢digos.
RETURN PADL(ALLTRIM(cod),LEN(cod),"0")

*******************************************************************************
PROCEDURE Le()
/*
 Sintaxe...: Le()
 Objetivo..: Ligar o cursor e ler dados de objetos GET pendentes
 Parametros: Nenhum
*/
*******************************************************************************
LOCAL vcursor
vcursor:=SETCURSOR(2)  // Liga o cursor
READ
SETCURSOR(vcursor)     // Volta o cursor ao formato anterior
@ 24,00 CLEAR
RETURN

*******************************************************************************
PROCEDURE Beep(som)
/*
 Sintaxe...: Beep()
 Objetivo..: Soa um sinal para chamar a atencao do usuario
 Parametros: 1 ou 2, indicando o tipo de som a ser emitido
 Fornece...: O som
*/
*******************************************************************************
SET CONSOLE ON
IF som=1
   // Som para operaá∆o malsucedida
   TONE(87.3,2)
   TONE(40,7)
ELSEIF som=2
   // Som para operaá∆o bem-sucedida
   TONE(261.7,2)
   TONE(392,7)
ELSEIF som=3
   // Som para finalizaá∆o
   TONE(300,4)
   TONE(300,4)
   TONE(300,4)
   TONE(300,7)
ENDIF
SET CONSOLE OFF
RETURN

*******************************************************************************
PROCEDURE Sinal(s1,s2)
/*
 Sintaxe...: Sinal(exp.caractere 1, exp.caractere 2)
 Objetivo..: Apresenta sinais nos quadrinhos de orientacao Ö direita no
             topo da tela, indicando para o usuario o modulo  do  sistema
	          que esta sendo utilizado.
 Parametros: s1: primeiro sinal e s2: segundo sinal
*/
*******************************************************************************
// Centralizar o sinal dentro dos 12 espacos disponiveis no quadrinho
SETCOLOR(vci)
@ 01,00 SAY PADC(s1,12)    // Sinal 1
@ 01,13 SAY PADC(s2,12)    // Sinal 2
//ShowTime()
//ShowTime(01,56,.F.,"W+/G",.F.,.T.)
//@ 01,56 SAY TIME()         // Hora em processamento.
SETCOLOR(vcn)
RETURN

*******************************************************************************
PROCEDURE Abrejan(l)
/*
 Sintaxe___: Abrejan(express∆o numÇrica)
 Objetivo__: Abre uma na janela da tela, formada pelo retangulo com as
             seguintes coordenadas: canto superior esquerdo linha 6 coluna
             0 e canto inferior direito linha 23 coluna 79
 ParÉmetros: express∆o numÇrica indicando o n£mero da moldura a ser utilizada
             de acordo com o vetor frame[]
*/
*******************************************************************************
LOCAL i:=j:=k:=w:=x:=0

i:=13;j:=40;k:=11;w:=39
DO WHILE i>=2
   x+=3
   INKEY(.02)
   IF i=2
     @ 02,00,23,79 BOX frame[l]
     EXIT
   ELSE
     @ --i,j-x,++k,w+x BOX frame[l]
   ENDIF
ENDDO

@ 02,00,23,79 BOX frame[l]
@ 02,00 SAY SPACE(80)
@ 02,00 SAY CHR(186)
@ 02,79 SAY CHR(186)
SETCOLOR(vcr)
@ 23,00  SAY PADC("<F1>=Ajuda  <F10>=Calc  <Ctrl+P>=Muda Impressora",80)
SETCOLOR(vcn)
RETURN

*******************************************************************************
PROCEDURE Caixa(ls,cs,li,ci,moldura)
/*
 Objetivo..: Desenha uma caixa com sombra nas coordenadas e com a
	     moldura especificada
 ParÉmetros:
   ls, cs  -> coordenadas do cando superior direito
   li, ci  -> coordenadas do canto inferior esquerdo
   moldura -> cadeia de caracteres a ser utilizada pelo comando BOX para desenhar
	      uma moldura na caixa
*/
*******************************************************************************
LOCAL vtela
vtela:=SAVESCREEN(ls+1,cs+2,li+1,ci+2)
IF LEN(vtela)>2048
   vtela:=TRANSFORM(SUBSTR(vtela,1,2048),REPLICATE("X"+CHR(8),1000))+;
	  TRANSFORM(SUBSTR(vtela,2049),REPLICATE("X"+CHR(8),1000))
ELSE       // O caractere CHR(8) e o responsavel pela sombra
   vtela:=TRANSFORM(vtela,REPLICATE("X"+CHR(8),LEN(vtela)/2))
ENDIF
RESTSCREEN(ls+1,cs+2,li+1,ci+2,vtela)
@ ls,cs,li,ci BOX moldura
RETURN

*****************************************************************************
PROCEDURE Moldura(lse,cse,lid,cid,tipo)
// Desenha um retÉngulo
************************
LOCAL vcor:=SETCOLOR(),i
//
i:=lse
SETCOLOR("N/N")
DO WHILE i <= lid
   SETCOLOR("N/N")
   @ i,cse CLEAR
   i++
ENDDO
//
IF tipo==NIL .OR. tipo<1 .OR. tipo>2
   tipo=1
ENDIF
//
SETCOLOR("W/N")
i:=lse
IF tipo=1
   DO WHILE i <= lid
      @ i,cse SAY "≥"
      @ i,cid SAY "≥"
      i++
   ENDDO
ENDIF
//
IF tipo=2
   DO WHILE i <= lid
      @ i,cse SAY "∫"
      @ i,cid SAY "∫"
      i++
   ENDDO
ENDIF
//
//
SETCOLOR(vcor)
RETURN

*******************************************************************************
PROCEDURE Mensagem(texto,tempo,som)
/*
 Objetivo..: Apresenta, por um determinado tempo, uma mensagem de alerta
	     (piscante e em video reverso) na linha 24 da tela.
 Parametros: O texto da mensagem, o tempo que a mesma devera' ser apresen-
	     tada na tela e o sinal sonoro a emitir.
*/
*******************************************************************************
LOCAL vcor:=SETCOLOR()
IF VALTYPE(som)#"N"
   som:=2
ENDIF
SETCOLOR(vcn)
@ 24,00 CLEAR
Beep(som)             // Emite um determinado som
// Apresenta a mensagem
SETCOLOR("W+*/R")
@ 24,00 SAY PADC(TRIM(texto),80)
SETCOLOR(vcor)
// Aguarda um tempo.
INKEY(tempo)
@ 24,00 CLEAR
RETURN

*******************************************************************************
PROCEDURE Aviso(linha,texto)
/*
 Objetivo..: Apresenta um aviso centralizado em uma linha da tela.
 Parametros: O texto do aviso e a linha onde dever† ser apresentado.
*/
*******************************************************************************
LOCAL coluna:=INT((78-LEN(texto))/2)
// Centraliza o texto do aviso na tela.
@ linha,coluna SAY texto
RETURN

*******************************************************************************
FUNCTION Confirme()
// Objetivo: Solicitar confirmacao do usuario.
*******************************************************************************
LOCAL vcor:=SETCOLOR(), vconf:=SPACE(1)
@ 24,60 CLEAR
SETCOLOR("W+*/R")
@ 24,62 SAY " Confirme (S/N) ?"
SETCOLOR("N/N,N/N")
TONE(1100,3)   // Emite um beep
@ 24,79 GET vconf PICTURE "!" VALID(vconf$"SN")
READ
IF vconf="S"
   SETCOLOR("W+*/G")
   @ 24,62 SAY "   Confirmado !   "
   INKEY(1)
   SETCOLOR(vcor)
   @ 24,00 CLEAR
   RETURN(.T.)
ELSE
   SETCOLOR("W+*/R")
   @ 24,62 SAY " N∆o Confirmado ! "
   INKEY(1)
   SETCOLOR(vcor)
   @ 24,00 CLEAR
   RETURN(.F.)
ENDIF

*******************************************************************************
FUNCTION Exclui()
/* Objetivo: Solicitar confirmacao para a exclusao de registros no canto
	     inferior direito da tela.
*/
*******************************************************************************
LOCAL vcor:=SETCOLOR(), ex:=SPACE(1)
@ 24,60 CLEAR
SETCOLOR("W+*/R")
@ 24,62 SAY "  Exclui (S/N) ?  "
SETCOLOR("N/N,N/N")
TONE(1100,3)  // Emite um beep
@ 24,79 GET ex PICTURE "!" VALID(ex$"SN")
READ
IF ex="S"
   SETCOLOR("W+*/R")
   @ 24,62 SAY "   Exclu°do   !   "
   INKEY(1)
   SETCOLOR(vcor)
   @ 24,00 CLEAR
   RETURN(.T.)
ELSE
   SETCOLOR("W+*/G")
   @ 24,62 SAY "    Mantido   !   "
   INKEY(1)
   SETCOLOR(vcor)
   @ 24,62 CLEAR
   RETURN(.F.)
ENDIF

*******************************************************************************
PROCEDURE Cabe(emp,sist,tit1,tit2,ncol,cimp)
/*
 Objetivo: Formatar o cabeáalho padronizado dos relatorios do sistema.
 Parametros: emp:  nome da empresa
	     sist: nome do sistema
	     tit1: titulo do relatorio
	     tit2: sub-titulo do relatorio
*/
*******************************************************************************
SET CONSOLE OFF
// Centraliza os titulos no formulario
emp  := PADC(emp,ncol*66/80)
sist := PADC(sist,ncol*66/80)
tit1 := PADC(TRIM(tit1),ncol*66/80)
tit2 := PADC(TRIM(tit2),ncol*66/80)
// Retorna a impressao ao padrao do relatorio
SET PRINTER ON
?? vcia10
SET PRINTER OFF
@ 01,01 SAY "Emiss∆o:"
@ 01,09 SAY TRANSFORM(DATE(),"99/99/99")+"  "+TRANSFORM(TIME(),"99:99")
@ 01,(ncol-14) SAY "P†gina nß "+ALLTRIM(STR(++pg,3))
// pg, variavel que armazena o numero das paginas do relatorio
IF vcabpg .OR. pg=1
   @ PROW()+1, 00  SAY REPLICATE("=",ncol)
   // vcia05 - variavel que ativa a impressao a 5 cpp
   // vcia20 - variavel que ativa a impressao a 20 cpp
   IF vcia05=CHR(27)+"[9w"
      @ PROW()+1, 01 SAY vcia05 + emp
      //@ PROW()+1, 01 SAY vcia05 + sist
      @ PROW()+1, 01 SAY vcia05 + tit1
      @ PROW()+1, 01 SAY vcia05 + tit2+vcid10
   ELSE
      @ PROW()+1, 01 SAY vcia20+vcia05 + emp
      //@ PROW()+1, 01 SAY vcia05 + sist
      @ PROW()+1, 01 SAY vcia05 + tit1
      @ PROW()+1, 01 SAY vcia05 + tit2+vcid10
   ENDIF
ENDIF
@ PROW()+1, 00 SAY REPLICATE("=",ncol)
// Retorna a impressao ao padrao do relatorio
SET PRINTER ON
?? cimp
SET PRINTER OFF
RETURN

*******************************************************************************
FUNCTION EscPrint(ncol)
/*
Objetivo.: Permite interromper a impressao dos relatorios atraves da te-
	   cla [Esc].
ParÉmetro: Numero de colunas do relatorio.
Fornece..: Verdadeiro (.T.) se a impressao foi cancelada.
	   Falso (.F.) em caso contrario.
*/
*******************************************************************************
LOCAL tk:=1
SET DEVICE TO SCREEN
DO WHILE tk#0 .AND. tk#27
   // Executa um "loop" para limpar o buffer do teclado.
   tk:=INKEY()
ENDDO
SET DEVICE TO PRINTER
IF tk=27
   SET DEVICE TO SCREEN
   Beep(2)
   SETCOLOR(vca)
   Aviso(24,"Deseja Interromper a Impress∆o ?")
   SETCOLOR(vcn)
   /* Apresenta a mensagem solicitando confirmacao para a interrupcao da
      impressao.*/
   IF !Confirme()
      /* Se a interrupáao nao for confirmada, retorna para a impressao do
	 relatorio */
      SET DEVICE TO PRINTER
      SET PRINTER TO &vcimpres
      RETURN(.F.)
   ENDIF
   @ 24,00 CLEAR
   SET DEVICE TO PRINTER
   SET PRINTER TO &vcimpres
   // Se foi confirmada a interrupá∆o, retorna a impressora ao normal
   SET PRINTER ON
   ?? vcia10
   SET PRINTER OFF
   /* Imprime uma mensagem no relatorio, indicando a interrupá∆o da
      impress∆o, de acordo com o numero de colunas do formulario. */
   @ PROW()+2,00 SAY REPLICATE("-",ncol)
   IF ncol >= 132
      @ PROW()+2,25 SAY vcia05 + "* * * IMPRESS«O INTERROMPIDA * * *"
   ELSE
      @ PROW()+2,04 SAY vcia05 + "* * * IMPRESS«O INTERROMPIDA * * *"
   ENDIF
   @ PROW()+2,00 SAY REPLICATE("-",ncol)
   EJECT
   @ PROW(),PCOL() SAY CHR(27)+"@"
   // Retorna a impressora ao seu padrao normal de impressao
   //Descarga()
   SET DEVICE TO SCREEN
   Mensagem("Impress∆o Interrompida !",3,2)
   // Apresenta na tela a mensagem de interrupcao
   RETURN(.T.)
ENDIF
RETURN(.F.)

*******************************************************************************
FUNCTION Edita(b,vdad,vpic)
/*
Sintaxe...: Edita( objeto )
Objetivo..: Edita dados de um objeto TBrowse onde esta posicionado o cursor,
	    atraves de um objeto GET.
Parametros: b:    nome do objeto TBrowse.
	    vdad: vetor dos dados apresentados.
	    vpic: vetor das mascaras de apresentacao. */
******************************************************************************
LOCAL InsSalva, ScoreSalva, Exitsalva, vedita, vmasca, tk
DO WHILE ( !b:stabilize() ) ; ENDDO
ScoreSalva := SET(_SET_SCOREBOARD, .F.)
ExitSalva  := SET(_SET_EXIT, .T.)
InsSalva   := SETKEY(K_INS)
SETKEY( K_INS, {|| SETCURSOR( IF(READINSERT(!READINSERT()), SC_NORMAL, SC_INSERT))} )
SETCURSOR( IF(READINSERT(), SC_INSERT, SC_NORMAL) )
vedita:=vdad[b:colPos]
vmasca:=vpic[b:colPos]
@ ROW(),COL() GET &vedita PICTURE vmasca
READ
SETCURSOR(0)
SET(_SET_SCOREBOARD, ScoreSalva)
SET(_SET_EXIT, ExitSalva)
SETKEY(K_INS, InsSalva)
b:refreshCurrent()
tk := LASTKEY()
IF ( tk == K_UP .OR. tk == K_DOWN .OR. tk == K_PGUP .OR. tk == K_PGDN )
   KEYBOARD( CHR(tk) )
ENDIF
RETURN (NIL)

**************************************************************************
FUNCTION Mascan(pvet,pdim,pdad)
//  Procura um dado em uma matriz bi-dimensional.
*************************************************
LOCAL i:=1
DO WHILE i<=LEN(pvet)
   IF pvet[i,pdim]==pdad
      RETURN i
   ENDIF
   i++
ENDDO
RETURN 0

*******************************************************************************
PROCEDURE DataOito(pdata)
// Retorna a data no formato reduzido XX/XX/XX
**********************************************
RETURN SUBSTR(DTOC(pdata),1,6)+SUBSTR(DTOC(pdata),9,2)

******************************************************************************
FUNCTION ImpTela(arqprn,tamlin)
*********************************
@ 24,00 CLEAR
SETCOLOR(vcp)
Aviso(24,"Aguarde Processamento...")
SELECT 100
ARQPRN1:=arqprn+"."+SUBS(STR(tempo+1000,4),2)
ARQPRN2:=arqprn+"."+SUBS(STR(tempo+1100,4),2)
CREATE ESTRUT
IF Adireg(10)
   REPLACE FIELD_NAME WITH "linha", FIELD_TYPE WITH "C"
   REPLACE FIELD_LEN  WITH tamlin+1,FIELD_DEC WITH 0
   UNLOCK
ELSE
   Mensagem("Erro de Rede, Inclus∆o N∆o Efetuada!",3,1)
ENDIF
CREATE (ARQPRN2) FROM ESTRUT
ERASE ESTRUT.DBF
APPEND FROM (ARQPRN1) SDF
GOTO TOP
IF tamlin<78
   PRIVATE editar[1]
   editar[1]:="SUBSTR(linha)"
ELSE
   IF tamlin%39=0
      numcol:=tamlin/39
   ELSE
      numcol:=INT(tamlin/39)+1
   ENDIF
   PRIVATE editar[numcol]
   x:=1
   DO WHILE x < numcol
      nummat:=(x*39)-38
      editar[x]="SUBSTR(linha,"+STR(nummat,3)+",39)"
      x++
   ENDDO
   nummat:=39*x-38
   editar[x]="SUBSTR(linha,"+STR(nummat,3)+")+SPACE("+STR((numcol*39)-tamlin,2)+")"
ENDIF
Abrejan(2)
// Linha de orientaáÑo ao usu†rio.
@ 24,00 CLEAR
SETCOLOR(vcr)
@ 23,00 SAY PADC("F1=Ajuda   Esc=Encerra",80)
SETCOLOR(vcn)
// Executa a funá∆o DBEDIT().
DBEDIT(03,01,22,78,editar,"FxTela","","","","")
CLOSE DATABASE
ERASE (ARQPRN1)
ERASE (ARQPRN2)
RETURN

********************************************************************************
FUNCTION FxTela(modo)
**********************
IF modo=4
   IF LASTKEY()=K_ESC
      // Pressionada a tecla <Esc>: finaliza a consulta.
      RETURN(0)
   ELSE
      /* Apresenta mensagens de aux°lio ao usu†rio se uma tecla impr¢pria for
	 pressionada.*/
      vtela:=SAVESCREEN(01,00,24,79)  // Salva a tela.
      Abrejan(2)
      SETCOLOR(vcr)
      Aviso(5,"  HELP - Aux°lio ao Usu†rio  ")
      SETCOLOR(vca)
      @ 10,12 SAY " Tecla                Funá∆o"
      SETCOLOR(vcn)
      @ 12,12 SAY "PgUp  - Retorna para a janela anterior"
      @ 13,12 SAY "PgDn  - Avanáa para a pr¢xima janela"
      @ 14,12 SAY "Home  - Retorna para o in°cio do arquivo"
      @ 15,12 SAY "End   - Avanáa para o fim do arquivo"
      @ 16,12 SAY "Es]   - Finaliza a Consulta"
      SETCOLOR(vca)
      Aviso(24,"Pressione qualquer tecla para retornar")
      SETCOLOR(vcn)
      INKEY(0)
      RESTSCREEN(01,00,24,79,vtela)
      RETURN(1)
   ENDIF
ELSEIF modo=1
   Mensagem("In°cio do Arquivo !",5)
   RETURN(1)
ELSEIF modo=2
   Mensagem("Fim do Arquivo !",5)
   RETURN(1)
ELSEIF modo=3
   Mensagem("NÑo H† Dados Cadastrados no Arquivo !",8,1)
   RETURN(0)
ENDIF
RETURN(1)

**************************************************************************
//   Rotinas de rede
//   Assume SET EXCLUSIVE OFF
***************************************************************************
/* Funá‰es para:
   Comandos                  Prop¢sito
   ------------------------------------------------------
   1. USE <arq> [EXCLUSIVE] [SHARED]  Compartilha/Bloqueia o Arquivo
   2. FLOCK()                         Trava o arquivo corrente
   3. RLOCK()/LOCK()                  Trava o registro corrente
   4. APPEND BLANK                    Trava o novo registro        */
***************************************************************************
FUNCTION Abrearq(arq,ape,modo,vezes)
**************************************************************************
/* Objetivo..: Tenta abrir um arquivo exclusivo ou compartilhado.
	       Define os indices se bem sucedida.
   Parametros:
   1. Caracter - nome do Arquivo .DBF a ser aberto
   2. Caracter - nome da area de trabalho
   3. Logico   - modo de abertura (exclusivo/compartilhado)
   4. Numerico - segundos de espera (0 = para sempre)       */
***************************************************************************
LOCAL sempre, vtela
sempre:=(vezes = 0)
vtela :=SAVESCREEN(24,00,24,79)
SETCOLOR("W+*")
Aviso(24,"Aguarde... Tentando Acesso aos Arquivos")
SETCOLOR("W")
IF FILE(arq)
   DO WHILE (sempre .OR. vezes > 0) .AND. INKEY()<>27
      IF modo                // exclusivo
         USE (arq) ALIAS (ape) EXCLUSIVE NEW
      ELSE
         USE (arq) ALIAS (ape) SHARED NEW      && compartilhado
      ENDIF
      IF !NETERR()           // USE bem sucedido
         RESTSCREEN(24,00,24,79,vtela)
         @  24,00 CLEAR
         RETURN (.T.)
      ENDIF
      INKEY(1)               // espera 1 segundo
      vezes--
   ENDDO
ENDIF
@ 24,00 CLEAR
RESTSCREEN(24,00,24,79,vtela)
RETURN (.F.)                 // USE mal sucedido

**************************************************************************
FUNCTION Bloqreg(vezes)
***************************************************************************
// Objetivo..: Tenta travar o registro atual
// ParÉmetros: 1. NumÇrico - tempo de espera em segundos (0 = sempre)
***************************************************************************
LOCAL sempre,vtela
IF RLOCK()
   RETURN (.T.)              // bloqueado
ENDIF
vtela:=SAVESCREEN(24,00,24,79)
SETCOLOR("W+*")
Aviso(24,"Aguarde... Tentando Acesso ao Registro")
SETCOLOR("W")
sempre:=(tempo = 0)
DO WHILE (sempre .OR. vezes > 0) .AND. INKEY()<>27
   IF RLOCK()
      @  24,00 CLEAR
      RESTSCREEN(24,00,24,79,vtela)
      RETURN (.T.)           // bloqueado
   ENDIF
   INKEY(1)                 // espera 1 segundo
   vezes--
ENDDO
@  24,00 CLEAR
RESTSCREEN(24,00,24,79,vtela)
RETURN (.F.)                 // nao bloqueado

**************************************************************************
FUNCTION Adireg(vezes)
***************************************************************************
// Objetivo..: Retorna verdadeiro se o registro foi "Apendado"
//             O novo registro passa a ser o registro atual e bloqueado.
// ParÉmetros: 1. Numerico - tempo de espera em segundos (0 = sempre)
***************************************************************************
LOCAL sempre, vtela
APPEND BLANK
IF .NOT. NETERR()
   RETURN (.T.)
ENDIF
vtela:=SAVESCREEN(24,00,24,79)
SETCOLOR("W+*")
Aviso(24,"Aguarde... Tentando Acesso ao Registro")
SETCOLOR("W")
sempre:=(tempo = 0)
DO WHILE (sempre .OR. vezes > 0) .AND. INKEY()<>27
   APPEND BLANK
   IF .NOT. NETERR()
      @  24,00 CLEAR
      RESTSCREEN(24,00,24,79,vtela)
      RETURN .T.
   ENDIF
   INKEY(1)                 // espera 1 segundo
   vezes--
ENDDO
@  24,00 CLEAR
RESTSCREEN(24,00,24,79,vtela)
RETURN (.F.)                 // nao bloqueado

**************************************************************************
FUNCTION Procura(parq,pord,pchav,pcamp)
***************************************
LOCAL area:=SELECT(),vord,vnome:=SPACE(15)
SELECT (parq)
// Armazena a ordem original de acesso na vari†vel vord.
vord:=INDEXORD()
SET ORDER TO pord
IF VALTYPE(&pcamp)=="N"
    vnome:=0
ELSEIF VALTYPE(&pcamp)=="C"
    vnome:=vnome
ELSEIF VALTYPE(&pcamp)=="D"
    vnome:=CTOD(SPACE(08))
ENDIF
SEEK pchav
IF FOUND()
   vnome:=&pcamp
ENDIF
// Seleciona a †rea de trabalho original.
DBSETORDER(vord)
SELECT (area)
RETURN vnome

********************************************************************************
FUNCTION MudaPrnPadrao()
// Muda de impressora padr∆o
*****************************
LOCAL vtela:=SAVESCREEN(01,00,24,79)
LOCAL i:=1
PRIVATE vli:=5,li:=1,vt:=0,lf:=16,tampa:=CHR(179),menulin:=3,menucol:=4
@ 24,00 CLEAR
SETCOLOR(vcp)
Aviso(24,"Procurando Impressoras. Aguarde...")
SETCOLOR(vcn)
mPrinters:=GetPrinters(.T.)
IF EMPTY(mPrinters)
   Mensagem("N∆o Existe Impressoras Instaladas",3,1)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN
ENDIF
@ 24,00 CLEAR
IF LEN(mPrinters)<lf
   lf:=LEN(mPrinters)
ENDIF
Caixa(menulin,menucol,lf+7,73,frame[1])
// Apresenta a linha de orientaá∆o ao usu†rio.
SETCOLOR(vcr)
@ menulin+1,menucol+1 SAY PADC("Impressora Padr∆o: "+vcPrnPadrao,72-menucol)
SETCOLOR("W+/RB")
@ menulin+2,menucol+1 SAY PADC("IMPRESSORAS DISPON÷VEIS",72-menucol)
SETCOLOR("W+/RB")
@ lf+6,menucol+1 SAY PADC("<Enter>=Seleciona  <Esc>=Sai",72-menucol)
MostraPrn(mPrinters,li,lf,vcn)
DO WHILE .T.
   SETCOLOR(vcp)
   @ vli+li,menucol SAY CHR(177)
   // Mostra o item selecionado.
   MostraPrn(mPrinters,li,li,vca)
   // Aguarda o pressionamento de uma tecla de controle.
   tk:=INKEY(0)
   IF tk=K_ENTER
      vcPrnPadrao:=mPrinters[li+vt,1]
      EXIT
   ELSEIF tk=K_UP
      // Seta para Cima: desloca para o item anterior.
      SETCOLOR(vcn)
      @ vli+li,menucol SAY tampa
      // Mostra o item.
      MostraPrn(mPrinters,li,li,vcn)
      // Decrementa a linha dos itens.
      IF li>1
         --li
      ELSE
         // Realiza o rolamento da tela.
         IF vt>0
            --vt
            SCROLL(vli+1,menucol+1,lf+5,72,-1)
            // Mostra o item.
            MostraPrn(mPrinters,li,li,vcn)
         ENDIF
      ENDIF
   ELSEIF tk=K_DOWN
      // Seta para Baixo: desloca para o item seguinte.
      SETCOLOR(vcn)
      @ vli+li,menucol SAY tampa
      // Mostra o item.
      MostraPrn(mPrinters,li,li,vcn)
      // Incrementa a linha dos itens.
      IF li<lf
         ++li
      ELSE
         // Realiza o rolamento da tela.
         IF vt<(LEN(mPrinters)-(lf+5-vli)) .AND. !EMPTY(mPrinters[li+vt])
            ++vt
            SCROLL(vli+1,menucol+1,lf+5,72,1)
            // Mostra o item.
            MostraPrn(mPrinters,li,li,vcn)
         ENDIF
      ENDIF
   ELSEIF tk=K_ESC
      EXIT
   ENDIF
ENDDO
RESTSCREEN(01,00,24,79,vtela)
RETURN

********************************************************************************
PROCEDURE MostraPrn(mat,ni,nf,vcor)
/* Apresenta as impressoras instaladas.
   mat:  matriz de dados
   ni:   n£mero do item inicial.
   nf:   n£mero do item final.
   vcor: padr∆o de cor para apresentaá∆o dos itens.*/
******************************************************
LOCAL i
SETCOLOR(vcor)
FOR i=ni TO IIF(nf<22-vli,nf,21-vli)
    @ vli+i,menucol+2  SAY LEFT(mat[i+vt,1],32)
    @ vli+i,menucol+35 SAY LEFT("Porta: "+mat[i+vt,2],32)
NEXT
SETCOLOR(vcn)
RETURN

//   Conjunto de Procedimentos e Funcoes para a Visualizaá∆o e Ediá∆o
//   de Dados atraves de objetos Get, TBrowse e TBColumn.

********************************************************************************
PROCEDURE Acha2()
PARAMETERS vcodig,arq,ord1,ord2,chav,sign,pic1,pic2,lse,cse,lid,cid,tit1,tit2,matproc
/*
 Objetivo: apresenta uma tabela para consulta de uma chave ou codigo a ser
           digitado pelo usu†rio.
 ParÉmetros:
   vcodig : caractere, chave a ser pesquisada
   arq    : caractere, alias do arquivo a ser utilizado
   ord1   : numÇrico, ordem do °ndice do c¢digo
   ord2   : numÇrico, ordem do °ndice do nome
   chav   : caractere, campo que possue o c¢digo-chave para pesquisa (codigo)
   sign   : caractere, campo que explica o c¢digo-chave da pesquisa  (nome)
   pic1, pic2: caractere, respectivamente as mascaras do c¢digo e do nome
   lse, cse, lid, cid: numÇricas, coordenadas da janela a ser apresentada
   tit1: t°tulo para o c¢digo de pesquisa
   tit2: t°tulo para o nome de pesquisa
 Retorno: O c¢digo da chave pesquisada ou branco se n∆o encontrada.
*/
*******************************************************************************
LOCAL areatu:=SELECT(),ordatu
LOCAL vcor:=SETCOLOR(),vtela  // Acrescentado por Edilberto
PRIVATE mAjuda:={}
SELECT (arq)
// Armazena a ordem original de acesso na vari†vel ordatu.
ordatu:=INDEXORD()
SET ORDER TO ord1
SET SOFTSEEK ON
SEEK vcodig
SET SOFTSEEK OFF
IF !FOUND()
   vtela:=SAVESCREEN(02,00,24,79)   // Salva a regiao da tela
   PRIVATE v1[2], v2[2], v3[2]      // Declara os vetores
   v1[1]:=chav
   v1[2]:=sign
   v2[1]:=pic1
   v2[2]:=pic2
   IF tit1#NIL
      v3[1]:=tit1
   ELSE
      v3[1]:="C¢digo"
   ENDIF
   IF tit2#NIL
      v3[2]:=tit2
   ELSE
      v3[2]:=" Denominaá∆o"
   ENDIF
   SETCOLOR(vca)
   Caixa(lse-1, cse, lid-1, cid, frame[6])  // Apresenta a moldura
   // Constr¢i a linha de funáoes.
   SETCOLOR(vcr)
   @ lse-1, cse+(cid-cse)/2-10 SAY " TABELA DE CONSULTA "
   IF matproc=NIL
      @ lid-1,cse+2 SAY PADC("F5=C¢digo F6=Nome <PgUp> <PgDn> <Enter> <Esc>", cid-cse-3)
   ELSE
      @ lid-1,cse+2 SAY PADC("F5=C¢digo F6=Nome <Ins> <Ctrl+Enter> <Del> <Enter> <Esc>", cid-cse-3)
   ENDIF
   SETCOLOR(vcf)
   // Define a Ajuda dispon°vel
   IF matproc=NIL
      mAjuda:={;
      "F5          - Pesquisa por C¢digo",;
      "F6          - Pesquisa por Nome",;
      "Setas       - Movimentam o Cursor conforme Desejado",;
      "PgUp e PgDn - Movimentam o Cursor p/Pr¢xima Janela",;
      "Home e End  - Movimentam o Cursor p/In°cio e Fim do Arquivo",;
      "Enter       - Retorna a Opá∆o Escolhida"}
   ELSE
      mAjuda:={;
      "F5          - Pesquisa por C¢digo",;
      "F6          - Pesquisa por Nome",;
      "Setas       - Movimentam o Cursor conforme Desejado",;
      "PgUp e PgDn - Movimentam o Cursor p/Pr¢xima Janela",;
      "Home e End  - Movimentam o Cursor p/In°cio e Fim do Arquivo",;
      "Ins         - Inclui um novo Registro no Arquivo",;
      "Ctrl+Enter  - Altera o Registro sob Cursor",;
      "Del         - Exclui o Registro sob Cursor",;
      "Enter       - Retorna a Opá∆o Escolhida"}
   ENDIF
   // Executa a funáao VisualAcha() para apresentaáao da tabela.
   VisualAcha(arq,lse,cse+1,lid-2,cid-1,v1,v2,v3)
   RESTSCREEN(02,00,24,79,vtela)   // Restaura a regiao da tela
   // Restaura a ordem de acesso original.
   SET ORDER TO ordatu
ENDIF
SETCOLOR(vcn)
@ 24,00 CLEAR
SETCOLOR(vcor) // Acrescentado por Edilberto
SELECT(areatu) // Seleciona a †rea de trabalho original.
RETURN(vcodig)

*******************************************************************************
PROCEDURE VisualAcha(area,lse,cse,lid,cid,vdad,vpic,vcab)
*******************************************************************************
LOCAL b, coluna, tipo, n, cores, cursor, mais, tk, vtela
PRIVATE vcolu,pv1:=pv2:=pv3:=.T.
//
IF VALTYPE(area) # "U"
   SELECT (area)
ENDIF
lse:=IF(lse<5,lse=5,lse)
lid:=IF(lid>21,21,lid)
@ lse,cse CLEAR TO lid,cid
//
SET ORDER TO ord1
b := TBrowseDB(lse, cse, lid, cid)
b:headSep := LI_SEPH
b:colSep  := LI_SEPV
b:colorSpec := vcf //"W/N, N/W, R/N, R/W, W+/N"
FOR n = 1 TO LEN(vdad)
    IF vpic[n]#NIL
       vcolu:="{ || TRANSFORM("+vdad[n]+",'"+vpic[n]+"') }"
    ELSE
       vcolu:="{ || "+vdad[n]+"}"
    ENDIF
    coluna := TBColumnNew( vcab[n], &vcolu )
    tipo := VALTYPE(vdad[n])
    IF ( tipo == "N" )
       coluna:defColor   := {1, 2}
       coluna:colorBlock := {|x| IF( x < 0, {3, 4}, {1, 2} )}
    ELSE
       coluna:defColor := {1, 2}
    ENDIF
    // Adiciona a nova coluna no objeto TBrowse.
    b:addColumn(coluna)
NEXT
b:freeze := 0
cursor := SETCURSOR(0)
DO WHILE .T.
   IF ( b:colPos <= b:freeze )
      b:colPos := b:freeze + 1
   ENDIF
   DO WHILE ( !b:stabilize() )
      tk := INKEY()
      IF ( tk # 0 )
         EXIT   // Cancela se uma tecla for digitada
      ENDIF
   ENDDO
   IF ( b:stable )
      IF ( b:hitTop .OR. b:hitBottom )
         TONE(125, 0)
         CLEAR TYPEAHEAD
      ENDIF
      tk := INKEY(0)
   ENDIF
   IF (tk == K_F1 )
      IF LEN(mAjuda)=0
         Mensagem("N∆o Existe Ajuda Dispon°vel!",5,1)
         LOOP
      ENDIF
      Ajuda2(mAjuda)
   ELSEIF (tk == K_F5 )
      // Pressionada a tecla <F5> - pesquisa pelo c¢digo.
      SET ORDER TO ord1
      vrec:=RECNO()
      SETCURSOR(2)
      vcodig:=SPACE(LEN(&chav))
      SETCOLOR(vcn)
      @ 24,00 CLEAR
      @ 24,30 SAY "C¢digo Desejado: " GET vcodig PICTURE pic1
      READ
      @ 24,00 CLEAR
      SETCURSOR(0)
      IF EMPTY(vcodig)
         SETCOLOR(vcf)
         LOOP
      ENDIF
      IF pic1=REPLICATE("9",LEN(pic1))
         vcodig:=Zeracod(vcodig)
      ENDIF
      GO TOP
      SET SOFTSEEK ON
      SEEK vcodig
      SET SOFTSEEK OFF
      IF EOF()
         Mensagem("Desculpe, C¢digo n∆o Encontrado !",5,1)
         GO vrec
         SETCOLOR(vcf)
         LOOP
      ENDIF
      // Estabiliza e atualiza a tela.
      DO WHILE ( !b:stabilize() ) ; ENDDO
      b:refreshAll()
   ELSEIF (tk == K_F6 )
      // Pressionada a tecla <F6> - pesquisa pelo nome.
      SET ORDER TO ord2
      vrec:=RECNO()
      SETCURSOR(2)
      vnom:=SPACE(LEN(&sign))
      SETCOLOR(vcn)
      @ 24,00 CLEAR
      @ 24,10 SAY "Nome Desejado: " GET vnom PICTURE pic2
      READ
      @ 24,00 CLEAR
      SETCURSOR(0)
      IF EMPTY(vnom)
         SETCOLOR(vcf)
         LOOP
      ENDIF
      IF pic2=REPLICATE("9",LEN(pic2))
         vnom:=Zeracod(vnom)
      ENDIF
      GO TOP
      SET SOFTSEEK ON
      SEEK vnom
      SET SOFTSEEK OFF
      IF EOF()
         Mensagem("Desculpe, Nome n∆o Encontrado !",5,1)
         GO vrec
         SETCOLOR(vcf)
         LOOP
      ENDIF
      // Estabiliza e atualiza a tela.
      DO WHILE ( !b:stabilize() ) ; ENDDO
      b:refreshAll()
   ELSEIF ( tk == K_DOWN )
      b:down()
   ELSEIF ( tk == K_UP )
      b:up()
   ELSEIF ( tk == K_PGDN )
      b:pageDown()
   ELSEIF ( tk == K_PGUP )
      b:pageUp()
   ELSEIF ( tk == K_CTRL_PGUP )
      b:goTop()
   ELSEIF ( tk == K_CTRL_PGDN )
      b:goBottom()
   ELSEIF ( tk == K_RIGHT )
      b:right()
   ELSEIF ( tk == K_LEFT )
      b:left()
   ELSEIF ( tk == K_HOME )
      b:home()
   ELSEIF ( tk == K_END )
      b:end()
   ELSEIF ( tk == K_CTRL_LEFT )
      b:panLeft()
   ELSEIF ( tk == K_CTRL_RIGHT )
      b:panRight()
   ELSEIF ( tk == K_CTRL_HOME )
      b:panHome()
   ELSEIF ( tk == K_CTRL_END )
      b:panEnd()
   ELSEIF ( tk == K_INS )
      // Tecla <Ins> - Inclus∆o em tela cheia
      IF matproc=NIL
         LOOP
      ENDIF
      vtela:=SAVESCREEN(01,00,24,79)
      pmodo:=1
      IF(matproc#NIL,&(matproc),"")
      SELECT(area)
      RESTSCREEN(01,00,24,79,vtela)
      // Estabiliza e atualiza a tela.
      DO WHILE ( !b:stabilize() ) ; ENDDO
      b:refreshAll()
   ELSEIF ( tk == K_CTRL_ENTER )
      // Tecla <Ctrl+Enter> - Alteraá∆o em tela cheia.
      IF matproc=NIL
         LOOP
      ENDIF
      vtela:=SAVESCREEN(01,00,24,79)
      SELECT(area)
      pmodo:=2
      IF(matproc#NIL,&(matproc),"")
      SELECT(area)
      RESTSCREEN(01,00,24,79,vtela)
      // Estabiliza e atualiza a tela.
      DO WHILE ( !b:stabilize() ) ; ENDDO
      b:refreshAll()
   ELSEIF ( tk == K_DEL )
      // Tecla <Del> - Exclus∆o em tela cheia.
      IF matproc=NIL
         LOOP
      ENDIF
      vtela:=SAVESCREEN(01,00,24,79)
      SELECT(area)
      pmodo:=3
      IF(matproc#NIL,&(matproc),"")
      SELECT(area)
      RESTSCREEN(01,00,24,79,vtela)
      // Estabiliza e atualiza a tela.
      DO WHILE ( !b:stabilize() ) ; ENDDO
      b:refreshAll()
   ELSEIF ( tk == K_ENTER )
      // Tecla <Enter> - realiza a escolha.
      vcodig:=&chav
      EXIT
   ELSEIF ( tk == K_ESC )
      // Tecla <Esc> finaliza.
      EXIT
      vcodig:=SPACE(LEN(&chav))
   ENDIF
ENDDO
SETCURSOR(cursor)
//SETCOLOR(vcn)
RETURN

*******************************************************************************
PROCEDURE ConsBrowse(area,lse,cse,lid,cid,vdad,vpic,vcab,vedt,gelo,fusu,;
                     chave1, chaord1, chapic1, chacom1, chatit1,;
                     chave2, chaord2, chapic2, chacom2, chatit2,;
                     chave3, chaord3, chapic3, chacom3, chatit3,;
                     chave4, chaord4, chapic4, chacom4, chatit4,;
                     chave5, chaord5, chapic5, chacom5, chatit5,;
                     chave6, chaord6, chapic6, chacom6, chatit6,;
                     chave7, chaord7, chapic7, chacom7, chatit7)
/*
Criada por Edilberto
Objetivo..: Visualizar e editar registros de arquivos de dados atravÇs de um
            objeto TBrowse com opá‰es para chamada de outros procedimentos de
            consulta e manutená∆o.
ParÉmetros:
   area    = area de trabalho na qual esta o arquivo de dados a ser visualizado.
   lse,cse = coordenadas do canto superior esquerdo da janela de visualizacao.
   lid,cid = coordenadas do canto inferior direito da janela de visualizacao.
   vdad    = vetor que contem os campos a serem visualizados nas colunas.
   vpic    = vetor que contem as mascaras (PICTURE's) de visualizacao.
   vcab    = vetor que contem os cabecalhos das colunas a serem visualizadas.
   gelo    = numero de colunas a serem congeladas `a esquerda.
   fusu    = funá∆o de usu†rio para definiá∆o das opá‰es da consulta.
   chave1  = primeira chave de pesquisa.
   chaord1 = ordem do indice de pesquisa.
   chapic1 = mascara de pesquisa.
   chacom1 = comprimento da chave de pesquisa.
   chatit1 = titulo de pesquisa.
*/
*******************************************************************************
LOCAL b, coluna, tipo, n, cores, cursor, mais, tk, vtela
PRIVATE vcolu
// Adiá∆o de informaá‰es gerais de Ajuda.
AADD(mAjuda,REPLICATE("-",67))
AADD(mAjuda,"Setas      - Movimentam o cursor conforme Desejado")
AADD(mAjuda,"PgUp       - Retorna para a janela anterior")
AADD(mAjuda,"PgDn       - Avanáa para a pr¢xima janela")
AADD(mAjuda,"Ctrl+PgUp  - Movimenta o cursor p/in°cio do arquivo")
AADD(mAjuda,"Ctrl+PgDn  - Movimenta o cursor p/fim do arquivo")
AADD(mAjuda,"Home       - Retorna para o in°cio do arquivo")
AADD(mAjuda,"End        - Avanáa para o fim do arquivo")
AADD(mAjuda,"Esc        - Encerra a Consulta")
// Limpa a tela.
SETCOLOR(vcn)
@ lse,cse CLEAR TO lid,cid
// Seleá∆o da Area de Trabalho.
IF VALTYPE(area) # "U"
   SELECT (area)
ENDIF
// Quantidade de Registros
SETCOLOR(vcn)
@ 24,01 SAY "Regs:"+STRZERO(LASTREC(),6)
// Seleá∆o da chave prim†ria.
IF VALTYPE(chaord1) == "N"
   SET ORDER TO chaord1
ELSE
   SET ORDER TO 0
ENDIF
// Criaá∆o do Objeto Tbrowse.
b := TBrowseDB(lse, cse, lid, cid)
b:headSep := LI_SEPH
b:colSep  := LI_SEPV
b:colorSpec := "W/N, N/W, R/N, R/W, W+/N"
FOR n = 1 TO LEN(vdad)
    IF vpic[n]#NIL
       vcolu:="{ || TRANSFORM("+vdad[n]+",'"+vpic[n]+"') }"
    ELSE
       vcolu:="{ || "+vdad[n]+"}"
    ENDIF
    coluna := TBColumnNew( vcab[n], &vcolu )
    tipo := VALTYPE(vdad[n])
    IF ( tipo == "N" )
       coluna:defColor   := {1, 2}
       coluna:colorBlock := {|x| IF( x < 0, {3, 4}, {1, 2} )}
    ELSE
       IF n <= gelo
          coluna:defColor := {5, 2}
       ELSE
          coluna:defColor := {1, 2}
       ENDIF
    ENDIF
    // Adiciona a nova coluna no objeto TBrowse.
    b:addColumn(coluna)
NEXT
b:freeze := gelo
cursor := SETCURSOR(0)
DO WHILE .T.
   KEYBOARD CHR(0)
   IF ( b:colPos <= b:freeze )
      b:colPos := b:freeze + 1
   ENDIF
   DO WHILE ( !b:stabilize() )
      tk := INKEY()
      IF ( tk # 0 )
         EXIT   // Cancela se uma tecla for digitada
      ENDIF
   ENDDO
   // In°cio e Final de Arquivo
   IF ( b:stable )
      IF ( b:hitTop .OR. b:hitBottom )
         TONE(125, 0)
         CLEAR TYPEAHEAD
      ENDIF
      EVAL(fusu)
      tk := INKEY(0)
   ENDIF
   // Chamada da funá∆o de usu†rio para [re]definiá∆o das opá‰es da consulta.
   IF EVAL(fusu)
      // Seleciona a area principal de consulta.
      SELECT(area)
      // Estabiliza e atualiza a tela.
      DO WHILE ( !b:stabilize() ) ; ENDDO
      b:refreshAll()
      LOOP
   ENDIF
   // Teclas de funá∆o
   IF (tk == K_F1 )
      // F1 - Ajuda dispon°vel.
      IF EMPTY(mAjuda)
         Mensagem("N∆o Existe Ajuda Dispon°vel!",3,1)
         LOOP
      ENDIF
      Ajuda2(mAjuda)
   ELSEIF (tk == K_F2 )
      // F2 - Primeira chave de pesquisa.
      IF Pesquisa(chave1, chaord1, chapic1, chacom1, chatit1)
         // Estabiliza e atualiza a tela.
         DO WHILE ( !b:stabilize() ) ; ENDDO
         b:refreshAll()
      ENDIF
   ELSEIF (tk == K_F3 )
      // F3 - Segunda chave de pesquisa.
      IF Pesquisa(chave2, chaord2, chapic2, chacom2, chatit2)
         // Estabiliza e atualiza a tela.
         DO WHILE ( !b:stabilize() ) ; ENDDO
         b:refreshAll()
      ENDIF
   ELSEIF (tk == K_F4 )
      // F4 - Terceira chave de pesquisa.
      IF Pesquisa(chave3, chaord3, chapic3, chacom3, chatit3)
         // Estabiliza e atualiza a tela.
         DO WHILE ( !b:stabilize() ) ; ENDDO
         b:refreshAll()
      ENDIF
   ELSEIF (tk == K_F5 )
      // F5 - Quarta chave de pesquisa.
      IF Pesquisa(chave4, chaord4, chapic4, chacom4, chatit4)
         // Estabiliza e atualiza a tela.
         DO WHILE ( !b:stabilize() ) ; ENDDO
         b:refreshAll()
      ENDIF
   ELSEIF (tk == K_F6 )
      // F6 - Quinta chave de pesquisa.
      IF Pesquisa(chave5, chaord5, chapic5, chacom5, chatit5)
         // Estabiliza e atualiza a tela.
         DO WHILE ( !b:stabilize() ) ; ENDDO
         b:refreshAll()
      ENDIF
   ELSEIF (tk == K_F7 )
      // F7 - Sexta chave de pesquisa.
      IF Pesquisa(chave6, chaord6, chapic6, chacom6, chatit6)
         // Estabiliza e atualiza a tela.
         DO WHILE ( !b:stabilize() ) ; ENDDO
         b:refreshAll()
      ENDIF
   ELSEIF (tk == K_F8 )
      // F8 - SÇtima chave de pesquisa.
      IF Pesquisa(chave7, chaord7, chapic7, chacom7, chatit7)
         // Estabiliza e atualiza a tela.
         DO WHILE ( !b:stabilize() ) ; ENDDO
         b:refreshAll()
      ENDIF
   // Teclas padr‰es do browse
   ELSEIF ( tk == K_DOWN )
      b:down()
   ELSEIF ( tk == K_UP )
      b:up()
   ELSEIF ( tk == K_PGDN )
      b:pageDown()
   ELSEIF ( tk == K_PGUP )
      b:pageUp()
   ELSEIF ( tk == K_CTRL_PGUP )
      b:goTop()
   ELSEIF ( tk == K_CTRL_PGDN )
      b:goBottom()
   ELSEIF ( tk == K_RIGHT )
      b:right()
   ELSEIF ( tk == K_LEFT )
      b:left()
   ELSEIF ( tk == K_HOME )
      b:home()
   ELSEIF ( tk == K_END )
      b:end()
   ELSEIF ( tk == K_CTRL_LEFT )
      b:panLeft()
   ELSEIF ( tk == K_CTRL_RIGHT )
      b:panRight()
   ELSEIF ( tk == K_CTRL_HOME )
      b:panHome()
   ELSEIF ( tk == K_CTRL_END )
      b:panEnd()
   ELSEIF ( tk == K_ESC )
      // Esc - Finaliza.
      EXIT
   ELSEIF ( tk == K_CTRL_INS )
      // Ctrl+Ins - Edita na tela do browse.
      IF !vedt[b:colPos]
         Mensagem("Campo N∆o Liberado para Ediá∆o !",3,1)
         LOOP
      ENDIF
      SELECT(area)
      IF Bloqreg(10)
         Edita(b,vdad,vpic)
         COMMIT
         UNLOCK
      ELSE
         Mensagem("O Registro N∆o Est† Dispon°vel !",3,1)
      ENDIF
      // Estabiliza e atualiza a tela.
      DO WHILE ( !b:stabilize() ) ; ENDDO
      b:refreshAll()
   ELSEIF ( tk == K_CTRL_F3 ) .OR. ( tk == K_CTRL_DEL )
      // Ctrl+F3 - Exclus∆o na tela do browse.
      SELECT(area)
      IF Confirme()
         IF Bloqreg(10)
            DELETE
            UNLOCK
         ELSE
            Mensagem("O Registro N∆o Est† Dispon°vel !",3,1)
         ENDIF
      ENDIF
      // Estabiliza e atualiza a tela.
      DO WHILE ( !b:stabilize() ) ; ENDDO
      b:refreshAll()
   ENDIF
ENDDO
SETCURSOR(cursor)
SETCOLOR(vcn)
RETURN

*******************************************************************************
PROCEDURE ImprTela(arqprn,tamlin)
// Objetivo: Apresenta a impress∆o dos relat¢rios na tela.
*******************************************************************************
LOCAL arqdbf, mcampo
// Cria o arquivo .DBF
arqdbf:=LEFT(arqprn,LEN(arqprn)-4)+".DBF"
mcampo:={{"linha","C",tamlin+1,0}}
DBCREATE(arqdbf,mcampo)
// Acrescenta as linhas existentes no arquivo .PRN no arquivo .DBF
IF Abrearq(arqdbf,"Rel",.T.,10) // em modo exclusivo
   APPEND FROM (arqprn) SDF
ELSE
   Mensagem("O Arquivo Auxiliar do Relat¢rio N∆o Est† Dispon°vel !",3,1)
   RETURN
ENDIF
// Verifica o tamanho da linha
GO TOP
IF tamlin<78
   PRIVATE editar[1]
   editar[1]="SUBSTR(linha)"
ELSE
   IF tamlin%39=0
      numcol:=tamlin/39
   ELSE
      numcol:=INT(tamlin/39)+1
   ENDIF
   PRIVATE editar[numcol]
   x:=1
   DO WHILE x < numcol
      nummat:=(x*39)-38
      editar[x]="SUBSTR(linha,"+STR(nummat,3)+",39)"
      x++
   ENDDO
   nummat:=39*x-38
   editar[x]="SUBSTR(linha,"+STR(nummat,3)+")+SPACE("+STR((numcol*39)-tamlin,2)+")"
ENDIF
// Visualiza o relat¢rio com procedimento que utiliza objeto TBrowse.
Abrejan(2)
VisualTela("Rel",02,01,22,78,editar)
CLOSE Rel
// Elimina o arquivo .DBF e o arquivo .PRN
IF FERASE(arqdbf)=-1 .OR. FERASE(arqprn)=-1
   Mensagem("O Arquivo Auxiliar do Relat¢rio N∆o Foi Eliminado !",3,1)
ENDIF
RETURN

*******************************************************************************
PROCEDURE VisualTela(area, lse, cse, lid, cid, vdad)
/*
Objetivo..: Visualizar relat¢rio impresso em arquivo .PRN e importado
            para arquivo .DBF na tela atravÇs de um objeto TBrowse.
ParÉmetros:
   area    = area de trabalho na qual esta o arquivo de dados a ser visualizado.
   lse,cse = coordenadas do canto superior esquerdo da janela de visualizacao.
   lid,cid = coordenadas do canto inferior direito da janela de visualizacao.
   vdad    = vetor que contem os campos a serem visualizados nas colunas.
*/
*******************************************************************************
LOCAL b, coluna, tipo, n, cores, cursor, mais, tk
PRIVATE vcolu,pv:=.T.
IF VALTYPE(area) # "U"
   SELECT (area)
ENDIF
SETCOLOR(vcn)
@ lse,cse CLEAR TO lid,cid
// Linha de funá‰es.
SETCOLOR(vcr)
@ 23,00 SAY PADC("F1=Ajuda   F2=Linha   F3=Imprime   Esc=Encerra",80)
SETCOLOR(vcn)
SET ORDER TO 0
b := TBrowseDB(lse, cse, lid, cid)
b:headSep := ""
b:colSep  := ""
b:colorSpec := "W/N, N/W, R/N, R/W, W+/N"
FOR n = 1 TO LEN(vdad)
    vcolu:="{ || "+vdad[n]+"}"
    coluna := TBColumnNew( "", &vcolu )
    coluna:defColor := {1, 2}
    // Adiciona a nova coluna no objeto TBrowse.
    b:addColumn(coluna)
NEXT
b:freeze := 0
cursor := SETCURSOR(0)
DO WHILE .T.
   IF ( b:colPos <= b:freeze )
      b:colPos := b:freeze + 1
   ENDIF
   DO WHILE ( !b:stabilize() )
      tk := INKEY()
      IF ( tk # 0 )
         EXIT   // Cancela se uma tecla for digitada
      ENDIF
   ENDDO
   @ 24,01 SAY "Linha:"+STRZERO(RECNO(),5)+" de "+STRZERO(LASTREC(),5)
   //
   IF ( b:stable )
      IF ( b:hitTop .OR. b:hitBottom )
         TONE(125, 0)
         CLEAR TYPEAHEAD
      ENDIF
      tk := INKEY(0)
   ENDIF
   IF (tk == K_F1 )
      mAjuda:={;
      "Setas       - Movimentam o Cursor conforme Desejado",;
      "PgUp e PgDn - Movimentam o Cursor p/Pr¢xima Janela",;
      "Ctrl+PgUp   - Movimenta o Cursor p/In°cio do Arquivo",;
      "Ctrl+PgDn   - Movimenta o Cursor p/Fim do Arquivo",;
      "Home e End  - Movimentam o Cursor p/In°cio e Fim do Registro",;
      "F2          - Movimentam o Cursor p/Linha Desejada",;
      "F3          - Imprime o Relat¢rio na Impressora Padr∆o",;
      "Esc         - Encerra a Consulta"}
      Ajuda2(mAjuda)
   ELSEIF ( tk == K_F2 )
      vlinha:=0
      @ 24,40 SAY "Ir para a Linha:" GET vlinha PICTURE "99999"
      Le()
      GO vlinha
      // Estabiliza e atualiza a tela.
      DO WHILE ( !b:stabilize() ) ; ENDDO
      b:refreshAll()
   ELSEIF ( tk == K_F3 )
      vlinha:=vfinal:=0
      vtela:=SAVESCREEN(00,00,24,79)
      Abrejan(2)
      Aviso(4,"Relat¢rio do "+cNmSist)
      Aviso(16,"Impressora Padr∆o: "+vcPrnPadrao)
      Aviso(18,"Pressione <Ctrl+P> para Mudar a Impressora Padr∆o")
      @ 08,16 SAY "Imprimir a Partir da Linha:" GET vlinha PICTURE "99999"
      @ 10,16 SAY "Imprimir AtÇ a Linha......:" GET vfinal PICTURE "99999"
      Le()
      IF vfinal=0
         vfinal:=LASTREC()
      ENDIF
      Aviso(16,"Impressora Padr∆o: "+vcPrnPadrao)
      vcimpres:=vcPrnPadrao
      //vcimpres:="TESTE.PRN"
      @ 18,01 CLEAR TO 18,78
      SETCOLOR("GR+/N")
      Aviso(18,"Ajuste a Impressora")
      Aviso(19,"Tecle <Enter> quando PRONTO ou <Esc> para CANCELAR !")
      SETCOLOR(vcn)
      DO WHILE .T.
         IF INKEY(0)#(K_RETURN)
            Mensagem("Impress∆o Cancelada !",6)
            EXIT
         ENDIF
         IF !ISPRINTER()
            Mensagem("A Impressora N∆o Est† Ativa, Verifique por favor !",6,1)
            LOOP
         ENDIF
         @ 18,01 CLEAR TO 19,78
         SETCOLOR(vcp)
         Aviso(18,"Aguarde...")
         SETCOLOR(vcn)
         Aviso(20,"Tecle <Esc> durante a impress∆o caso queira interrompe-la")
         SELECT Rel
         GO TOP
         SET DEVICE TO PRINTER
         SET PRINTER TO &vcimpres
         SET PRINTER ON
         ??  LEFT(Rel->linha,1)
         SET PRINTER OFF
         //SETPRC(-1,0)
         GO vlinha
         DO WHILE RECNO() <= vfinal
            @ PROW()+1,00 SAY RTRIM(Rel->linha)
            SKIP
         ENDDO
         SET PRINTER TO
         SET DEVICE TO SCREEN
         EXIT
      ENDDO
      @ 00,00 CLEAR TO 24,79
      RESTSCREEN(00,00,24,79,vtela)
      GO TOP
      // Estabiliza e atualiza a tela.
      DO WHILE ( !b:stabilize() ) ; ENDDO
      b:refreshAll()
   ELSEIF ( tk == K_DOWN )
      b:down()
   ELSEIF ( tk == K_UP )
      b:up()
   ELSEIF ( tk == K_PGDN )
      b:pageDown()
   ELSEIF ( tk == K_PGUP )
      b:pageUp()
   ELSEIF ( tk == K_CTRL_PGUP )
      b:goTop()
   ELSEIF ( tk == K_CTRL_PGDN )
      b:goBottom()
   ELSEIF ( tk == K_RIGHT )
      b:right()
   ELSEIF ( tk == K_LEFT )
      b:left()
   ELSEIF ( tk == K_HOME )
      b:home()
   ELSEIF ( tk == K_END )
      b:end()
   ELSEIF ( tk == K_CTRL_LEFT )
      b:panLeft()
   ELSEIF ( tk == K_CTRL_RIGHT )
      b:panRight()
   ELSEIF ( tk == K_CTRL_HOME )
      b:panHome()
   ELSEIF ( tk == K_CTRL_END )
      b:panEnd()
   ELSEIF ( tk == K_ESC )
      // Tecla <Esc> finaliza.
      EXIT
   ENDIF
ENDDO
SETCURSOR(cursor)
SETCOLOR(vcn)
RETURN

********************************************************************************
FUNCTION Pesquisa(chave, chaord, chapic, chacom, chatit)
/* Objetivo: Pesquisar num arquivo de dados de acordo com a chave
//           passada como parÉmetro
ParÉmetros:
   chave   = chave de pesquisa.
   chaord  = ordem do indice de pesquisa.
   chapic  = mascara de pesquisa.
   chacom  = comprimento da chave de pesquisa.
   chatit  = titulo de pesquisa. */
********************************************************************************
IF EMPTY(chave)
   RETURN .F.
ENDIF
SET ORDER TO chaord
@ 24,00 CLEAR
IF VALTYPE(&chave)="N"
   vcod:=0
ELSEIF VALTYPE(&chave)="C"
   vcod:=SPACE(chacom)
ELSEIF VALTYPE(&chave)="D"
   vcod:=CTOD(SPACE(8))
ENDIF
vrec:=RECNO()
SETCURSOR(2)
@ 24,(40-(LEN(chatit)+chacom)/2) SAY chatit+":" GET vcod PICTURE chapic
READ
@ 24,00 CLEAR
SETCURSOR(0)
IF chapic=REPLICATE("9",LEN(chapic))
   vcod:=Zeracod(vcod)
ENDIF
GO TOP
SET SOFTSEEK ON
SEEK vcod
SET SOFTSEEK OFF
IF EOF()
   GO vrec
   RETURN .F.
ENDIF
RETURN .T.

// Fim dos Procedimentos e Funá‰es para a Visualizaá∆o, Ediá∆o e Pesquisa
// de Dados atravÇs de objetos Get, TBrowse e TBColumn.

********************************************************************************
PROCEDURE BrowseMenu(plin1,pcol1,plin2,pcol2,pMenu,ptit)
// Objetivo: Apresentar um browse para marcar as opá‰es escolhidas
********************************************************************************
LOCAL vtela:=SAVESCREEN(01,00,24,79)
PRIVATE vli:=plin1,li:=1,lf:=plin2-plin1,vt:=0,tampa:=CHR(179)
PRIVATE mMenu:=pMenu,vtam1:=LEN(pMenu[1,2]),pcol:=pcol1
//
IF LEN(mMenu)<lf
   lf:=LEN(mMenu)
ENDIF
//
SETCOLOR(vcn)
Aviso(24,"Marque a(s) Opá∆o(‰es) Escolhida(s) e Tecle <Esc> Para Finalizar")
Caixa(plin1-1,pcol1,plin2+1,pcol2,frame[1])
SETCOLOR(vcr)
@ plin1,pcol1+1 SAY PADC(ptit,pcol2-pcol1-1)
@ 23,00 SAY PADC("Ins=Marca/Desmarca  F2=Marca/Desmarca Todos  <Setas>  Esc=Sai",80)
SayMenu(li,lf,vcn)
DO WHILE .T.
   SETCOLOR(vcp)
   @ vli+li,pcol1 SAY CHR(177)
   // Mostra o item selecionado.
   SayMenu(li,li,vca)
   tk:=INKEY(0)
   IF tk=K_INS
      // Marca/desmarca o item
      IF EMPTY(mMenu[li+vt,1])
         mMenu[li+vt,1]:="*"
      ELSE
         mMenu[li+vt,1]:=" "
      ENDIF
      SayMenu(li,li,vca)
   ELSEIF tk=K_UP
      // Seta para Cima: desloca para o item anterior.
      SETCOLOR(vcn)
      @ vli+li,pcol1 SAY tampa
      SayMenu(li,li,vcn)
      // Decrementa a linha dos itens.
      IF li>1
         --li
      ELSE
         // Realiza o rolamento da tela.
         IF vt>0
            --vt
            SCROLL(vli+1,pcol1+1,plin2,pcol2-1,-1)
            SayMenu(li,li,vcn)
         ENDIF
      ENDIF
   ELSEIF tk=K_DOWN
      // Seta para Baixo: desloca para o item seguinte.
      SETCOLOR(vcn)
      @ vli+li,pcol1 SAY tampa
      SayMenu(li,li,vcn)
      // Incrementa a linha dos itens.
      IF li<lf
         ++li
      ELSE
         // Realiza o rolamento da tela.
         IF vt<(LEN(mMenu)-(plin2-vli)) .AND. !EMPTY(mMenu[li+vt])
            ++vt
            SCROLL(vli+1,pcol1+1,plin2,pcol2-1,1)
            SayMenu(li,li,vcn)
         ENDIF
      ENDIF
   ELSEIF tk=K_F2
      // <F2>: marca todos
      k:=1
      DO WHILE k <= LEN(mMenu)
         IF mMenu[k,1]=" "
            mMenu[k,1]:="*"
         ELSE
            mMenu[k,1]:=" "
         ENDIF
         SayMenu(li,LEN(mMenu),vcn)
         k++
      ENDDO
   ELSEIF tk=K_ENTER
      // <Enter>: finaliza se houver opá∆o marcada
      IF Mascan(mMenu,1,"*") > 0
         EXIT
      ENDIF
   ELSEIF tk=K_ESC
      // <Esc>: finaliza
      EXIT
   ENDIF
ENDDO
RESTSCREEN(01,00,24,79,vtela)
RETURN(mMenu)

********************************************************************************
PROCEDURE SayMenu(ni,nf,pcor)
// Criada por Edilberto - auxilia a funá∆o BrowseMenu()
/* Apresenta os itens de credenciamento.
   ni:   n£mero do item inicial.
   nf:   n£mero do item final.
   vcor: padr∆o de cor para apresentaá∆o dos itens.*/
******************************************************
LOCAL i
SETCOLOR(pcor)
FOR i=ni TO IF(nf<22-vli,nf,21-vli)
    @ vli+i,pcol+2       SAY mMenu[i+vt,1]
    @ vli+i,pcol+4       SAY mMenu[i+vt,2]
    @ vli+i,pcol+4+vtam1 SAY "-"+mMenu[i+vt,3]
NEXT
SETCOLOR(vcn)
RETURN

*******************************************************************************
FUNCTION Imprime2(tit)
/*
 Objetivo..: Apresenta mensagens padronizadas para iniciar a impressao dos
	     relatorios, verificando se a impressora esta em linha.
 Parametros: O titulo do relatorio a ser impresso.
 Retorno...: Verdadeiro (.T.) se a impressao foi confirmada
	     Falso (.F.) se a impressao foi cancelada
*/
*******************************************************************************
LOCAL vcbpg:="S", vnumprn
vcop:=1
Abrejan(2)
Aviso(4,"Relat¢rio do "+cNmSist)
Aviso(6,tit)
Aviso(16,"Impressora Padr∆o: "+vcPrnPadrao)
Aviso(18,"Pressione <Ctrl+P> para Mudar a Impressora Padr∆o")
// Solicita o n£mero de c¢pias a serem impressas.
@ 08,19 SAY "Informe o N£mero de C¢pias Desejadas:" GET vcop PICTURE "99" RANGE 0,99
@ 10,16 SAY "Imprimir Cabeáalho em Todas as P†ginas (S/N):" GET vcbpg PICTURE "!" VALID vcbpg$"SN"
@ 12,22 SAY "Direcionar a Saida de Impress∆o:" GET vcporta PICTURE "9" VALID vcporta$"123"
@ 12,58 SAY "1-Impressora Padr∆o"
@ 13,58 SAY "2-Tela"
@ 14,58 SAY "3-Arquivo"
Le()
Aviso(16,"Impressora Padr∆o: "+vcPrnPadrao)
IF vcporta="1"      // Impressora Padr∆o
   vcimpres:=vcPrnPadrao
ELSEIF vcporta="2"  // Tela
   vcop:=1
   marqprn:=DIRECTORY("RELATO*.PRN")
   IF EMPTY(marqprn)
      varqprn:="RELATO01.PRN"
   ELSE
      vnumprn:=VAL(SUBSTR(marqprn[LEN(marqprn),1],7,2))
      //IF vnumprn = 99
      //   varqprn:="RELATO01.PRN"
      //ELSE
         varqprn:="RELATO"+STRZERO(vnumprn+1,2)+".PRN"
      //ENDIF
   ENDIF
   vcimpres:=varqprn
ELSEIF vcporta="3"  // Arquivo
   vcop:=1
   vcimpres:="ARQUIVO.PRN"
ENDIF
//
@ 18,01 CLEAR TO 18,78
vcabpg:=IF(vcbpg="S",.T.,.F.)
SETCOLOR("GR+/N")
Aviso(18,"Ajuste a Impressora")
Aviso(19,"Tecle <Enter> quando PRONTO ou <Esc> para CANCELAR !")
SETCOLOR(vcn)
DO WHILE .T.
   IF INKEY(0)#(K_RETURN)
      Mensagem("Impress∆o Cancelada !",6)
      RETURN(.F.)
   ENDIF
   IF vcporta="1"  // Impressora Padr∆o
      IF !ISPRINTER()
         // Verifica se a impressora est† em linha e pronta para imprimir.
         Mensagem("A Impressora N∆o Est† Ativa, Verifique por favor !",6,1)
         LOOP
      ENDIF
   ENDIF
   EXIT
ENDDO
@ 18,01 CLEAR TO 19,78
SETCOLOR(vcp)
Aviso(18,"Aguarde...")
SETCOLOR(vcn)
Aviso(20,"Tecle <Esc> durante a impress∆o caso queira interrompe-la")
RETURN(.T.)

*******************************************************************************
PROCEDURE Ajuda2(pMat)
******************************************************
LOCAL vtelajuda:=SAVESCREEN(01,00,24,79)
LOCAL vcursor:=SETCURSOR(0)
//Caixa(02,05,LEN(pMat)+5,75,frame[1],)
SETCOLOR("W+/RB") //SETCOLOR(vcr)
@ 03,05 SAY PADC("Aux°lio ao Usu†rio ",69)
SETCOLOR(vcf)     //SETCOLOR("GR/N")
FOR i=1 TO LEN(pMat)
   @ ROW()+1,05 SAY PADR(" "+pMat[i],69)
NEXT
SETCOLOR("W+/RB") //SETCOLOR(vca)
@ ROW(),05 SAY PADC("Pressione qualquer tecla para retornar",69)
SETCOLOR(vcn)
INKEY(0)
RESTSCREEN(01,00,24,79,vtelajuda)
SETCURSOR(vcursor)
RETURN

#pragma BEGINDUMP

#include "windows.h"
#include "hbapi.h"

// BOOL SetConsoleTitle ( LPCTSTR lpConsoleTitle );
// http://msdn.microsoft.com/library/default.asp?url=/library/en-us/dllproc/base/setconsoletitle.asp
HB_FUNC ( SETCONSOLETITLE )
{
   SetConsoleTitle( (LPCTSTR) hb_parc(1) );
}

// DWORD GetConsoleTitle( LPTSTR lpConsoleTitle, DWORD nSize );
// http://msdn.microsoft.com/library/default.asp?url=/library/en-us/dllproc/base/getconsoletitle.asp
HB_FUNC ( GETCONSOLETITLE )
{
   TCHAR Title[255];
   DWORD dwRet;
   dwRet = GetConsoleTitle( Title, sizeof(Title));
   hb_retc(Title);
}

#pragma ENDDUMP

*******************************************************************************
//                                   F i m
*******************************************************************************

