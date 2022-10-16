********************************************************************************
/* Programa.: MG_BIBLI.PRG
   Autor....: Edilberto L. Souza
   Data.....: 2002/2003
   Funá∆o...: Rotinas de biblioteca para os sistemas.        */
********************************************************************************
// Definiáao dos arquivos-cabeáalho e das constantes utilizadas.
STATIC vlin                      // Variavel estatica
#include "SIG.CH"
#include "SETCURS.CH"            // Formato do cursor
#include "COMMON.CH"
****************************************************************************
FUNCTION AbreArqs(matriz,pmodo)
/* Objetivo..: Tenta abrir uma lista de arquivos definidos numa matriz
               em modo exclusivo ou compartilhado com a funá∆o Abrearq()
   Parametros:
   1. Matriz - nome da matriz com a lista de Arquivos .DBF a serem abertos
   2. Logico - modo de abertura (exclusivo/compartilhado)
   Obs: Matriz={{Arq,Ape,Desc,Qte Indices}}
   Criado por Edilberto */
****************************************************************************
LOCAL ind01,ind02,ind03,ind04,ind05,ind06,ind07,ind08,ind09
LOCAL ind10,ind11,ind12,ind13,ind14,vtam,vtam2,i
i:=1
DO WHILE i <= LEN(matriz)
   IF !FILE(matriz[i,1]) // verifica a existància do arquivo
      Mensagem("O Arquivo de "+matriz[i,3]+" N∆o Foi Encontrado !",5,1)
      CLOSE DATABASE
      RETURN (.F.)
   ENDIF
   IF SELECT(matriz[i,2]) > 0
      Mensagem("O Arquivo de "+matriz[i,3]+" J† Est† Aberto !",5,1)
      i++
      LOOP
   ENDIF
   IF Abrearq(matriz[i,1],matriz[i,2],pmodo,10)
      IF matriz[i,4] # 0
         vtam :=LEN(matriz[i,1])-5
         vtam2:=LEN(matriz[i,1])-6
         ind01:=LEFT(matriz[i,1],vtam)+"1.CDX"
         ind02:=LEFT(matriz[i,1],vtam)+"2.CDX"
         ind03:=LEFT(matriz[i,1],vtam)+"3.CDX"
         ind04:=LEFT(matriz[i,1],vtam)+"4.CDX"
         ind05:=LEFT(matriz[i,1],vtam)+"5.CDX"
         ind06:=LEFT(matriz[i,1],vtam)+"6.CDX"
         ind07:=LEFT(matriz[i,1],vtam)+"7.CDX"
         ind08:=LEFT(matriz[i,1],vtam)+"8.CDX"
         ind09:=LEFT(matriz[i,1],vtam)+"9.CDX"
         ind10:=LEFT(matriz[i,1],vtam2)+"10.CDX"
         ind11:=LEFT(matriz[i,1],vtam2)+"11.CDX"
         ind12:=LEFT(matriz[i,1],vtam2)+"12.CDX"
         ind13:=LEFT(matriz[i,1],vtam2)+"13.CDX"
         ind14:=LEFT(matriz[i,1],vtam2)+"14.CDX"
         IF matriz[i,4]=1
            SET INDEX TO (ind01)
         ELSEIF matriz[i,4]=2
            SET INDEX TO (ind01), (ind02)
         ELSEIF matriz[i,4]=3
            SET INDEX TO (ind01), (ind02), (ind03)
         ELSEIF matriz[i,4]=4
            SET INDEX TO (ind01), (ind02), (ind03), (ind04)
         ELSEIF matriz[i,4]=5
            SET INDEX TO (ind01), (ind02), (ind03), (ind04), (ind05)
         ELSEIF matriz[i,4]=6
            SET INDEX TO (ind01), (ind02), (ind03), (ind04), (ind05), (ind06)
         ELSEIF matriz[i,4]=7
            SET INDEX TO (ind01), (ind02), (ind03), (ind04), (ind05), (ind06), (ind07)
         ELSEIF matriz[i,4]=8
            SET INDEX TO (ind01), (ind02), (ind03), (ind04), (ind05), (ind06), (ind07), (ind08)
         ELSEIF matriz[i,4]=9
            SET INDEX TO (ind01), (ind02), (ind03), (ind04), (ind05), (ind06), (ind07), (ind08), (ind09)
         ELSEIF matriz[i,4]=10
            SET INDEX TO (ind01), (ind02), (ind03), (ind04), (ind05), (ind06), (ind07), (ind08), (ind09), (ind10)
         ELSEIF matriz[i,4]=11
            SET INDEX TO (ind01), (ind02), (ind03), (ind04), (ind05), (ind06), (ind07), (ind08), (ind09), (ind10), (ind11)
         ELSEIF matriz[i,4]=12
            SET INDEX TO (ind01), (ind02), (ind03), (ind04), (ind05), (ind06), (ind07), (ind08), (ind09), (ind10), (ind11), (ind12)
         ELSEIF matriz[i,4]=13
            SET INDEX TO (ind01), (ind02), (ind03), (ind04), (ind05), (ind06), (ind07), (ind08), (ind09), (ind10), (ind11), (ind12), (ind13)
         ELSEIF matriz[i,4]=14
            SET INDEX TO (ind01), (ind02), (ind03), (ind04), (ind05), (ind06), (ind07), (ind08), (ind09), (ind10), (ind11), (ind12), (ind13), (ind14)
         ENDIF
         SET ORDER TO 1
      ENDIF
   ELSE
      Mensagem("O Arquivo de "+matriz[i,3]+" N∆o Est† Dispon°vel !",5,1)
      CLOSE DATABASE
      RETURN (.F.)
   ENDIF
   i++
ENDDO
RETURN (.T.)

*******************************************************************************
FUNCTION AdiCampo(parq,mcampos)
// Objetivo: Adicionar campos em Arquivos .DBF
// Sintaxe.: AdiCampo( <parq>, <mcampos> )
// Obs.....: mcampos Ç uma matriz bi-dimensional com a seguinte
//           estrutura {{<NomeCampo>,<Tipo>,<Tamanho>,<Decimais>}}
*******************************************************************************
LOCAL mStru
IF RIGHT(parq,4)=".DBF"
   parq:=STRTRAN(parq,".DBF","")
ENDIF
pbkp:=LEFT(parq,LEN(parq)-1)+"1"
IF !Abrearq(parq+".DBF","Arq",.T.,10)
   Mensagem("O Arquivo "+parq+" N∆o Est† Dispon°vel!",3,1)
   RETURN .F.
ENDIF
SELECT Arq
mStru:=DBSTRUCT()           // carregando estrutura
FOR i:=1 TO LEN(mcampos)
   IF Mascan(mStru,1,mcampos[i,1])=0
      AADD(mStru,mcampos[i])       // adicionando o campo na matriz
   ELSE
      Mensagem("Campo "+mcampos[i,1]+" J† Existente!",3,1)
      CLOSE Arq
      RETURN .F.
   ENDIF
NEXT
CLOSE Arq
COPY FILE (parq)+".DBF" TO (pbkp)+".DBF" // criando backup dos dados
IF FILE((parq)+".DBT")
   COPY FILE (parq)+".DBT" TO (pbkp)+".DBT"
ENDIF
DBCREATE(parq+".DBF",mStru) // criando arquivo de dados com nova estrutura
IF !Abrearq(parq+".DBF","Arq",.T.,10)
   Mensagem("O Arquivo "+parq+" N∆o Est† Dispon°vel!",3,1)
   RETURN .F.
ENDIF
SELECT Arq
APPEND FROM (pbkp)+".DBF"  // recuperando os dados do arquivo de backup
CLOSE Arq
FERASE(pbkp)
RETURN .T.

*******************************************************************************
FUNCTION ModiCampo(parq,mcampos)
// Objetivo: Modificar campos em Arquivos .DBF
// Sintaxe.: ModiCampo( <parq>, <mcampos> )
// Obs.....: mcampos Ç uma matriz bi-dimensional com a seguinte
//           estrutura {{<NomeCampo>,<Tipo>,<Tamanho>,<Decimais>}}
*******************************************************************************
LOCAL mStru
IF RIGHT(parq,4)=".DBF"
   parq:=STRTRAN(parq,".DBF","")
ENDIF
pbkp:=LEFT(parq,LEN(parq)-1)+"1"
IF !Abrearq(parq+".DBF","Arq",.T.,10)
   Mensagem("O Arquivo "+parq+" N∆o Est† Dispon°vel!",3,1)
   RETURN .F.
ENDIF
SELECT Arq
mStru:=DBSTRUCT()           // carregando estrutura
FOR i:=1 TO LEN(mcampos)
   IF Mascan(mStru,1,mcampos[i,1])=0
      Mensagem("Campo "+mcampos[i,1]+" N∆o Existe!",3,1)
      CLOSE Arq
      RETURN .F.
   ELSE
      mStru[i]:=mcampos[i]  // modificando o campo na matriz
   ENDIF
NEXT
CLOSE Arq
COPY FILE (parq)+".DBF" TO (pbkp)+".DBF" // criando backup dos dados
IF FILE((parq)+".DBT")
   COPY FILE (parq)+".DBT" TO (pbkp)+".DBT"
ENDIF
DBCREATE(parq+".DBF",mStru) // criando arquivo de dados com nova estrutura
IF !Abrearq(parq+".DBF","Arq",.T.,10)
   Mensagem("O Arquivo "+parq+" N∆o Est† Dispon°vel!",3,1)
   RETURN .F.
ENDIF
SELECT Arq
APPEND FROM (pbkp)+".DBF"  // recuperando os dados do arquivo de backup
CLOSE Arq
FERASE(pbkp)
RETURN .T.

*******************************************************************************
PROCEDURE Procura2(parq,pord,pchav,pcamp)
*****************************************
LOCAL areatu:=SELECT(),ordatu,recatu,vnome:=SPACE(15)
SELECT (parq)
// Armazena a ordem original de acesso na vari†vel ordatu.
ordatu:=INDEXORD()
recatu:=RECNO() // acrescentado por Edilberto
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
SET ORDER TO ordatu
GO recatu // acrescentado por Edilberto
SELECT (areatu)
RETURN vnome

//   Conjunto de Procedimentos e Funcoes para a Visualizaá∆o e Ediá∆o
//   de Dados atraves de objetos Get, TBrowse e TBColumn.

*******************************************************************************
PROCEDURE VerMatriz2(matriz,lse,cse,lid,cid,vcab,edita,func3,rotina3)
/*
Objetivo: Apresenta uma matriz de duas dimensoes usando um objeto TBrowse
          e fornece o valor do elemento sobre o qual estiver o cursor.
 Sintaxe: VerMatriz2(<matriz>,<lse>,<cse>,<lid>,<cid>,<vcab>,<edita>,
                     [<func3>],[<rotina3>] ) --> valor
*/
*******************************************************************************
LOCAL n, vret, vcursor, vlinha, vtela
LOCAL o                        // Objeto TBrowse
LOCAL tk := 0                  // Tecla pressionada
// Desliga o cursor, preservando o seu modo anterior
vcursor := SETCURSOR( 0 )
vlin := 1
lse := IF( lse == NIL, 0, lse )
cse := IF( cse == NIL, 0, cse )
lid := IF( lid == NIL, MAXROW(), lid )
cid := IF( cid == NIL, MAXCOL(), cid )
@ lse,cse CLEAR TO lid,cid
@ lse,cse SAY REPLICATE("ƒ",79-cse)
@ lid,cse SAY REPLICATE("ƒ",79-cse)
o := TBROWSENEW( lse+1, cse, lid-1, cid )
o:headSep := LI_SEPH
o:colSep  := LI_SEPV
o:SkipBlock:={ |vpula| vpula:=Testapulo(matriz,vlin,vpula),vlin+=vpula,vpula }
o:GotopBlock:={ || vlin:=1 }
o:GobottomBlock:={ || vlin:=LEN(matriz) }
o:colorSpec := "W/N, N/W, R/N, R/W, W+/N"
FOR n=1 TO LEN(matriz[1])
    o:ADDCOLUMN( TBCOLUMNNEW(vcab[n], blocovermat(matriz,n)) )
NEXT
//o:freeze:=1
SETCOLOR(vcr)
@ 23,00 SAY PADC(" F1=Ajuda "+IF(func3#NIL,"F3="+func3,"")+" Ins=Edita <Setas> Esc=Encerra",80)
SETCOLOR(vcn)
DO WHILE .T.
   tk:=0
   DO WHILE .NOT. o:Stabilize()
      tk:=INKEY()
      IF tk#0
         EXIT
      ENDIF
   ENDDO
   IF tk == 0
      tk:=INKEY(0)
   ENDIF
   IF o:Stable
      IF ( tk == K_CTRL_PGUP )
         o:goTop()
      ELSEIF ( tk == K_CTRL_PGDN )
         o:goBottom()
      ELSEIF ( tk == K_DOWN )
         o:Down()
      ELSEIF ( tk == K_UP )
         o:Up()
      ELSEIF ( tk == K_RIGHT )
         o:Right()
      ELSEIF ( tk == K_LEFT )
         o:Left()
      ELSEIF ( tk == K_PGDN )
         o:pageDown()
      ELSEIF ( tk == K_PGUP )
         o:pageUp()
      ELSEIF ( tk == K_HOME )
         o:home()
      ELSEIF ( tk == K_END )
         o:end()
      ELSEIF ( tk == K_F1 )
         mAjuda2:={;
         IF(func3#NIL,"F3          -"+func3,""),;
         "Ins         - Edita o Registro Sob Cursor se Permitido",;
         "Setas       - Movimentam o Cursor conforme Desejado",;
         "Esc         - Encerra a Consulta e Pergunta se Imprime"}
         Ajuda2(mAjuda2)
         LOOP
      ELSEIF ( tk == K_F3 )
         vtela:=SAVESCREEN(01,00,24,79)
         IF func3#NIL
            IF(rotina3#NIL,&(rotina3),"")
         ENDIF
         @ 24,00 CLEAR
         RESTSCREEN(01,00,24,79,vtela)
      ELSEIF ( tk == K_F10 )
         Calc()
         LOOP
      ELSEIF ( tk == K_INS )  // Tecla <Ins> - edita.
         IF !edita
            Mensagem("Ediá∆o N∆o Permitida!",3,1)
            LOOP
         ENDIF
         IF Bloqreg(10)
            DO WHILE ( !o:stabilize() ) ; ENDDO
            vedita:=matriz[o:rowPos,o:colPos]
            @ ROW(),COL() GET vedita PICTURE "@X!"
            Le()
            matriz[o:rowPos,o:colPos]:=vedita
            UNLOCK
            o:refreshCurrent()
         ELSE
            Mensagem("O Registro N∆o Est† Dispon°vel !",3,1)
         ENDIF
         LOOP
      ELSEIF ( tk == K_ENTER )
         vret:=vlin
         EXIT
      ELSEIF ( tk == K_ESC )
         EXIT
      ENDIF
   ENDIF
ENDDO
SETCURSOR(vcursor)
RETURN (vret)

*******************************************************************************
STATIC FUNCTION Blocovermat(vmat, x)
/* Sintaxe : blocovermat( <vmat>, <x> ) -> bloco
   Objetivo: Cria um bloco de codigo para visualizar cada coluna da matriz. */
*******************************************************************************
RETURN ( {|p| IF(PCOUNT() == 0, vmat[vlin, x], vmat[vlin, x] := p)} )

*******************************************************************************
STATIC FUNCTION Testapulo(vmat, vatual, vpula)
/* Sintaxe: Testapulo( <vmat>, <vatual>, <vpula> ) -> deslocamento
   Objetivo:Determina se Ç poss°vel realizar o deslocamento (pulo) solicitado
            na matriz visualizada e fornece o numero de linhas que poderao ser
            puladas.
 ParÉmetros:vmat   -> nome da matriz
            vatual -> linha atual
            vpula  -> quantidade de linhas a serem puladas */
*******************************************************************************
IF ( vatual + vpula < 1 )
   RETURN ( -vatual + 1 )
ELSEIF ( vatual + vpula > LEN(vmat) )
   RETURN ( LEN(vmat) - vatual )
ENDIF
RETURN(vpula)

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

********************************************************************************
PROCEDURE Acha3()
PARAMETERS vcodig,matriz,lse,cse,lid,cid,pic1,pic2,tit1,tit2
/*
 Objetivo..: apresenta uma tabela para consulta de uma chave ou codigo a ser
             digitado pelo usu†rio.
 ParÉmetros:
   vcodig : caractere, chave a ser pesquisada
   matriz : matriz a ser pesquisada
   lse, cse, lid, cid: numÇricas, coordenadas da janela a ser apresentada
   pic1, pic2: caractere, respectivamente as mascaras do c¢digo e do nome
   tit1: t°tulo para o c¢digo de pesquisa
   tit2: t°tulo para o nome de pesquisa
 Fornece...: O c¢digo da chave pesquisada ou branco se n∆o encontrada.
*/
*******************************************************************************
LOCAL vcor:=SETCOLOR() // Acrescentado por Edilberto
LOCAL vtela
PRIVATE mAjuda:={}
x:=Mascan(matriz,1,vcodig)
IF x=0 // N∆o achou
   vtela:=SAVESCREEN(02,00,24,79)   // Salva a regiao da tela
   PRIVATE v1[2], v2[2]             // Declara os vetores
   v1[1]:=pic1
   v1[2]:=pic2
   IF tit1#NIL
      v2[1]:=tit1
   ELSE
      v2[1]:="C¢digo"
   ENDIF
   IF tit2#NIL
      v2[2]:=tit2
   ELSE
      v2[2]:=" Denominaá∆o"
   ENDIF
   SETCOLOR(vca)
   Caixa(lse-1, cse, lid-1, cid, frame[6])  // Apresenta a moldura
   // Constr¢i a linha de funáoes.
   SETCOLOR(vcr)
   @ lse-1, cse+(cid-cse)/2-10 SAY " TABELA DE CONSULTA "
   @ lid-1,cse+2 SAY PADC("F5=C¢digo F6=Nome <PgUp> <PgDn> <Enter> <Esc>", cid-cse-3)
   SETCOLOR(vcf)
   // Define a Ajuda dispon°vel
   mAjuda:={;
   "F5          - Pesquisa por C¢digo",;
   "F6          - Pesquisa por Nome",;
   "Setas       - Movimentam o Cursor conforme Desejado",;
   "PgUp e PgDn - Movimentam o Cursor p/Pr¢xima Janela",;
   "Home e End  - Movimentam o Cursor p/In°cio e Fim do Arquivo",;
   "Enter       - Retorna a Opá∆o Escolhida"}
   // Executa a funáao VisualAM() para apresentaáao da tabela.
   VisualAM(matriz,lse,cse+1,lid-2,cid-1,v1,v2)
   RESTSCREEN(02,00,24,79,vtela)   // Restaura a regiao da tela
ENDIF
SETCOLOR(vcn)
@ 24,00 CLEAR
SETCOLOR(vcor) // Acrescentado por Edilberto
RETURN(vcodig)

*******************************************************************************
PROCEDURE VisualAM(matriz,lse,cse,lid,cid,vpic,vcab)
*******************************************************************************
LOCAL b, coluna, tipo, n, cores, cursor, mais, tk
lse:=IF(lse<5,lse=5,lse)
lid:=IF(lid>21,21,lid)
@ lse,cse CLEAR TO lid,cid
//
vlin := 1
b := TBROWSENEW( lse, cse, lid, cid )
b:headSep := LI_SEPH
b:colSep  := LI_SEPV
b:SkipBlock:={ |vpula| vpula:=Testapulo(matriz,vlin,vpula),vlin+=vpula,vpula }
b:GotopBlock:={ || vlin:=1 }
b:GobottomBlock:={ || vlin:=LEN(matriz) }
b:colorSpec := vcf
FOR n=1 TO LEN(matriz[1])
    b:ADDCOLUMN( TBCOLUMNNEW(vcab[n], blocovermat(matriz,n)) )
NEXT
//
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
      SETCURSOR(2)
      vcodig:=SPACE(LEN(matriz[vlin,1]))
      SETCOLOR(vcn)
      @ 24,00 CLEAR
      @ 24,30 SAY "C¢digo Desejado: " GET vcodig PICTURE pic1
      READ
      @ 24,00 CLEAR
      SETCURSOR(0)
      i:=1
      vreg:=0
      DO WHILE i <= LEN(matriz)
         IF matriz[i,1]==vcodig
            vreg:=i
            EXIT
         ENDIF
         i++
      ENDDO
      IF vreg = 0
         Mensagem("Desculpe, C¢digo N∆o Encontrado !",5,1)
         SETCOLOR(vcf)
         LOOP
      ELSE
         vlin:=vreg
      ENDIF
      // Estabiliza e atualiza a tela.
      DO WHILE ( !b:stabilize() ) ; ENDDO
      b:refreshAll()
   ELSEIF (tk == K_F6 )
      // Pressionada a tecla <F6> - pesquisa pelo nome.
      SETCURSOR(2)
      vnom:=SPACE(LEN(matriz[vlin,2]))
      SETCOLOR(vcn)
      @ 24,00 CLEAR
      @ 24,10 SAY "Nome Desejado: " GET vnom PICTURE pic2
      READ
      @ 24,00 CLEAR
      SETCURSOR(0)
      vnom:=UPPER(ALLTRIM(vnom))
      i:=1
      vreg:=0
      DO WHILE i <= LEN(matriz)
         IF UPPER(LEFT(matriz[i,2],LEN(vnom)))=vnom
            vreg:=i
            EXIT
         ENDIF
         i++
      ENDDO
      IF vreg = 0
         Mensagem("Desculpe, Nome N∆o Encontrado !",5,1)
         SETCOLOR(vcf)
         LOOP
      ELSE
         vlin:=vreg
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
   ELSEIF ( tk == K_ENTER )
      // Tecla <Enter> - realiza a escolha.
      vcodig:=matriz[vlin,1]
      EXIT
   ELSEIF ( tk == K_ESC )
      // Tecla <Esc> finaliza.
      EXIT
      vcodig:=SPACE(LEN(matriz[vlin,1]))
   ENDIF
ENDDO
SETCURSOR(cursor)
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
      IF pv4
         IF !Senha("00")
            LOOP
         ENDIF
         pv4:=.F.
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
      IF pv5
         IF !Senha("00")
            LOOP
         ENDIF
         pv5:=.F.
      ENDIF
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
PROCEDURE Imprtela(arqprn,tamlin)
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

********************************************************************************
FUNCTION PesqLojaData(chave, chaord, chapic, chacom, chatit)
/* Objetivo: Pesquisar num arquivo de dados de acordo com a chave
ParÉmetros:     chave   = chave de pesquisa.
   		chaord  = ordem do indice de pesquisa.
   		chapic  = mascara de pesquisa.
   		chacom  = comprimento da chave de pesquisa.
   		chatit  = titulo de pesquisa. */
********************************************************************************
LOCAL vcod,vrec
IF EMPTY(chave)
   RETURN .F.
ENDIF
SET ORDER TO chaord
@ 24,00 CLEAR
vcod:=SPACE(chacom)
vrec:=RECNO()
SETCURSOR(2)
@ 24,(40-(LEN(chatit)+chacom)/2) SAY chatit+":" GET vcod PICTURE chapic
READ
@ 24,00 CLEAR
SETCURSOR(0)
vcod:=LEFT(vcod,1)+DTOS(CTOD(RIGHT(vcod,8)))
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
      IF mp<6
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
         mp:=6
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

********************************************************************************
FUNCTION Fmenu2(lin,col,nop,vp)
/*
Objetivo__: apresenta um menu de n°vel inferior ao prim†rio.
ParÉmetros:   lin => linha inicial do menu
              col => coluna inicial do menu
              nop => numero de opá‰es
	      vp  => matriz de opá‰es
*/
********************************************************************************
LOCAL mx
@ 24,00 CLEAR
Caixa(lin,col,lin+nop+1,col+14,frame[6])
SETCOLOR(vcm)
// Monta as opáoes do menu.
FOR i=1 TO nop
    @ lin+i,col+1 PROMPT vp[i,1] MESSAGE vp[i,2]
NEXT
// Aguarda a escolha da opáao.
MENU TO mx
SETCOLOR(vcn)
@ 24,00 CLEAR
// Retorna a opáao escolhida.
RETURN(mx)

********************************************************************************
PROCEDURE Matmenu(lin,col)
/* Apresenta um Menu
   lin => linha inicial do menu
   col => coluna inicial do menu */
********************************************************************************
LOCAL mx
@ 24,00 CLEAR
Caixa(lin,col,lin+6,col+14,frame[6])
SETCOLOR(vcm)
@ lin+1,col+1 PROMPT "Inclus∆o     " MESSAGE "Inclus∆o de Novos Registros no Arquivo"
@ lin+2,col+1 PROMPT "Alteraá∆o    " MESSAGE "Alteraá∆o de Dados nos Registros Cadastrados"
@ lin+3,col+1 PROMPT "Exclus∆o     " MESSAGE "Exclus∆o de Registros Cadastrados"
@ lin+4,col+1 PROMPT "Consultas    " MESSAGE "Consultas aos Registros Cadastrados"
@ lin+5,col+1 PROMPT "Relat¢rios  " MESSAGE "Emiss∆o de Relat¢rios na Impressora"
MENU TO mx
SETCOLOR(vcn)
@ 24,00 CLEAR
RETURN(mx)

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

******************************************************************************
PROCEDURE EnviaEmail(ppara,passunto,panexo,ptexto)
/* Objetivo: Enviar email atravÇs da internet.
   ParÉmetros:
   ppara     - Destinat†rio do email
   passunto  - Assunto do email
   panexo    - Arquivo anexado a mensagem do email
   ptexto    - Arquivo texto contendo o corpo da mensagem do email */
******************************************************************************
LOCAL vde,vpara,vcc,vassunto,vanexo,vsvsmtp,vtexto
LOCAL mServidores:={},mEmails:={},x
IF !LinkConectado()
   Mensagem("Link de Internet Desconectado!",3,1)
   RETURN
ENDIF
Sinal("INTERNET","ENVIA E-MAIL")
Abrejan(2)
mServidores:=GeraMatriz("VM_CONFI.DBF","internet","SERVIDORES")
mEmails    :=GeraMatriz("VM_CONFI.DBF","internet","EMAILS")
@ 24,00 CLEAR
IF EMPTY(mEmails)
   Mensagem("Matriz de Configuraá∆o sem Dados !",3,1)
   RETURN
ENDIF
//
ode:=GetNew()
ode:colorSpec:=vcr
ode:row:=04;ode:col:=10
ode:name:="vde";ode:picture:="@X"
ode:block:={|valor| IF(PCOUNT()>0,vde:=valor,vde)}
ode:postBlock:={|valor| !EMPTY(vde)}
//
opara:=GetNew()
opara:colorSpec:=vcr
opara:row:=06;opara:col:=10
opara:name:="vpara";opara:picture:="@X"
opara:block:={|valor| IF(PCOUNT()>0,vpara:=valor,vpara)}
opara:postBlock:={|valor| !EMPTY(vpara)}
//
occ:=GetNew()
occ:colorSpec:=vcr
occ:row:=08;occ:col:=10
occ:name:="vcc";occ:picture:="@X"
occ:block:={|valor| IF(PCOUNT()>0,vcc:=valor,vcc)}
//
oassunto:=GetNew()
oassunto:colorSpec:=vcr
oassunto:row:=10;oassunto:col:=10
oassunto:name:="vassunto";oassunto:picture:="@X"
oassunto:block:={|valor| IF(PCOUNT()>0,vassunto:=valor,vassunto)}
oassunto:postBlock:={|valor| !EMPTY(vassunto)}
//
oanexo:=GetNew()
oanexo:colorSpec:=vcr
oanexo:row:=12;oanexo:col:=10
oanexo:name:="vanexo";oanexo:picture:="@X"
oanexo:block:={|valor| IF(PCOUNT()>0,vanexo:=valor,vanexo)}
oanexo:postBlock:={|valor| ValidaAnexo(vanexo)}
//
odomain:=GetNew()
odomain:colorSpec:=vcr
odomain:row:=14;odomain:col:=10
odomain:name:="vsvsmtp";odomain:picture:="@X"
odomain:block:={|valor| IF(PCOUNT()>0,vsvsmtp:=valor,vsvsmtp)}
odomain:postBlock:={|valor| !EMPTY(vsvsmtp)}
//
vcc:=SPACE(1)
DO WHILE .T.
   x:=Mascan(mServidores,1,vcloja)
   IF x > 0
      vsvsmtp:=mServidores[x,3]
   ENDIF
   x:=Mascan(mEmails,1,vcloja)
   IF x > 0
      vde  :=mEmails[x,3]
      vpara:=mEmails[x,4]
   ENDIF
   vpara   :=IF(ppara=NIL,vpara,ppara)
   vassunto:=IF(passunto=NIL,"",passunto)
   vanexo  :=IF(panexo=NIL,"",panexo)
   vtexto  :=IF(ptexto=NIL,"",MEMOREAD(ptexto))
   vde     :=PADR(vde,60)
   vpara   :=PADR(vpara,60)
   vcc     :=PADR(vcc,60)
   vassunto:=PADR(vassunto,60)
   vanexo  :=PADR(vanexo,60)
   vsvsmtp :=PADR(vsvsmtp,60)
   SETCOLOR(vcr)
   @ 23,00 SAY PADC("Digite os dados   <Esc>=Encerra",80)
   SETCOLOR(vcn)
   @ 03,10 SAY "Emitente:"
   @ 05,10 SAY "Destinat†rios (separados por v°rgula):"
   @ 07,10 SAY "Outros Destinat†rios (separados por v°gula): "
   @ 09,10 SAY "Assunto:"
   @ 11,10 SAY "Anexo:"
   @ 13,10 SAY "Servidor SMTP:"
   @ 15,10 SAY "Mensagem:"
   SETCOLOR(vcr)
   @ 04,10 SAY vde
   @ 06,10 SAY vpara
   @ 08,10 SAY vcc
   @ 10,10 SAY vassunto
   @ 12,10 SAY vanexo
   @ 14,10 SAY vsvsmtp
   // Ediá∆o dos dados do email
   SETCURSOR(IF(READINSERT(),2,1)) // 2-INSERT 1-NORMAL
   READMODAL({ode,opara,occ,oassunto,oanexo,odomain})
   SETCURSOR(0)
   IF LASTKEY()==27 // K_ESC
      EXIT
   ENDIF
   // Ediá∆o do texto do email
   SETCOLOR(vcr)
   @ 23,00 SAY PADC("Tecle <Ctrl+W> para encerrar o texto",80)
   SETCOLOR(vcn)
   @ 24,00 CLEAR
   @ 16,10 TO 21,69
   SETCOLOR("W+/N")
   SETCURSOR(1)
   vtexto:=MEMOEDIT(vtexto,17,11,20,68,.T.)
   vtexto:=HB_OEMTOANSI(vtexto)
   SETCURSOR(0)
   SETCOLOR(vcn)
   //IF !MEMOWRIT("EMAIL.HTM",vtexto)
   //   Mensagem("Erro ao Criar Arquivo Texto do Email",3,1)
   //   EXIT
   //ENDIF
   vde     :=ALLTRIM(vde)
   vpara   :=ALLTRIM(vpara)
   vcc     :=ALLTRIM(vcc)
   vassunto:=ALLTRIM(vassunto)
   vanexo  :=ALLTRIM(vanexo)
   vsvsmtp :=ALLTRIM(vsvsmtp)
   @ 24,00 CLEAR
   Aviso(24,"Deseja Realmente Enviar o Email")
   IF Confirme()
      @ 24,00 CLEAR
      Aviso(24,"Enviando Email. Aguarde ...")
      IF SendMail(vsvsmtp,,vde,vpara,vtexto,vassunto,vanexo,;
         [edilberto],[beto120],[pop.marglass.com.br],,,.T.)
         @ 24,00 CLEAR
         Aviso(24,"Email Enviado !")
         Beep(2)
         INKEY(0)
      ELSE
         Mensagem("Email N∆o Enviado !",3,1)
      ENDIF
   ENDIF
   @ 24,00 CLEAR
   EXIT
ENDDO
SETCOLOR(vcn)
CLEAR
RETURN

*******************************************************************************
FUNCTION ValidaAnexo(panexo)
*******************************************************************************
IF EMPTY(ALLTRIM(panexo))
   RETURN .T.
ELSE
   IF FILE(ALLTRIM(panexo))
      RETURN .T.
   ELSE
      Mensagem("Arquivo N∆o Encontrado !",3,1)
      RETURN .F.
   ENDIF
ENDIF

*******************************************************************************
FUNCTION SendMail(cServerIP,nPort,cFrom,aTo,cMsg,cSubject,aFiles,;
                  cUser,cPass,cPopServer,nPriority,lRead,lTrace,lPopAuth)
*******************************************************************************
/*Function SendMail()
  Parameters
  cServerIP  -> Required. Smtp server name or address
  nPort      -> Optional. Stmt port number
  cFrom      -> Required. Email Address of who is sending
  aTo        -> Required. an simple email Address, or an array containing multiples reciepts email address
  cMsg       -> Optional. Message Body For html emails, pass the varaible text
                          html filename as subject
  cSubject   -> Optional. Message subject
  aFiles     -> Optional. Array of files to attach to email
  cUser      -> Required. Pop3 user name
  cPass      -> Required. Pop user name password
  cPopServer -> Required. Pop3 server name or address
  nPriority  -> Optional. Email Prioryty. 1 high 3[default] normal 5 lower
  lRead      -> Optional. Flag to indicate is user need to confirm reciept . default .F.
  lTrace     -> Optional. Flag to indicate creation of log files (sendmail*.log) . default .F.
  lPopAuth   -> Optional. Flag to indicate to authenticate via pop3 server. Default .T. */
*******************************************************************************
LOCAL oInMail
LOCAL lSair      := .F.
LOCAL nStart
LOCAL nRetry     := 1
LOCAL oUrl
LOCAL oUrl1
LOCAL oMail
LOCAL cTo        := ""
LOCAL aThisFile
LOCAL cFile
LOCAL cData2
LOCAL cFname
LOCAL cFext
LOCAL cData
LOCAL cConnect   := ""
LOCAL CC         := ""
LOCAL lRet       := .T.
LOCAL oPop
LOCAL lSecure    := .F.
LOCAL lAuthLogin := .F.
LOCAL lAuthPlain := .F.
LOCAL lConnect   := .T.
LOCAL cMimeText  := ""
LOCAL lConnectPlain := .F.
//LOCAL cMsgTemp
DEFAULT cUser TO ""
DEFAULT cPass TO ""
DEFAULT nPort TO 25
DEFAULT aFiles TO {}
DEFAULT nPriority TO 3
DEFAULT lRead TO .F.
DEFAULT lTrace TO .F.
DEFAULT lPopAuth TO .T.
cLastError := ""
cUser      := STRTRAN( cUser, "@", "&at;" )
IF VALTYPE( aTo ) == "A"
   IF LEN( aTo ) > 1
      FOR EACH cTo IN aTo
         IF HB_EnumIndex() != 1
            cC += cTo + ","
         ENDIF
      NEXT
      cC := SUBSTR( cC, 1, LEN( cC ) - 1 )
   ENDIF
   cTo := aTo[ 1 ]
   IF LEN( cC ) > 0
      cTo += "," + cC
   ENDIF
ELSE
   cTo := ALLTRIM( aTo )
ENDIF
//TraceLog(cServerIP, nPort, cFrom, aTo, cMsg, cSubject, aFiles, cUser, cPass, cPopServer, nPriority, lRead, lTrace ,lPopAuth)
//tracelog(cUser)
// This is required. Many smtp server, requires that first user connect to popserver, to validade user, and the allow smtp access
IF cPopServer != NIL .AND. lPopAuth
   oUrl1 := tUrl():New( "pop://" + cUser + ":" + cPass + "@" + cPopServer + "/" )
   oUrl1:cUserid := STRTRAN( cUser, "&at;", "@" )
   oPop  := tIPClient():new( oUrl1,, lTrace )
   oPop:Open()
   oPop:Close()
ENDIF
cConnect     := "smtp://" + cUser + "@" + cServerIp + '/' + cTo
oUrl         := tUrl():New( cConnect )
cUser        := STRTRAN( cUser, "&at;", "@" )
oUrl:cUserid := cUser
oMail   := TipMail( ):new()
oAttach := Tipmail():new()
oAttach:setEncoder( "7-bit" )
//IF (".htm" IN LOWER( cMsg ) .OR. ".html" IN LOWER( cMsg ) ) .AND. FILE(cMsg)
//   cMimeText := "text/plain; charset=ISO-8859-1"
//   oAttach:hHeaders[ "Content-Type" ] := cMimeText
//   cMsgTemp := cMsg
//   cMsg := MEMOREAD( cMsgTemp )
//ENDIF
cMimeText := "text/plain; charset=ISO-8859-1"
oAttach:hHeaders[ "Content-Type" ] := cMimeText
//
oAttach:setbody( cmsg )
oMail:attach( oAttach )
oUrl:cFile                       := cTo
oMail:hHeaders[ "Content-Type" ] := "text/plain; charset=iso8851"
oMail:hHeaders[ "Date" ]         := Tip_Timestamp()
oMail:hHeaders[ "From" ] := cFrom
oInMail := tIPClient():new( oUrl,, lTrace )
IF oInMail:Opensecure()
   WHILE .T.
      oInMail:GetOk()
      IF oInMail:cReply == NIL
         EXIT
      ELSEIF "LOGIN" IN oInMail:cReply
         lAuthLogin := .T.
      ELSEIF "PLAIN" IN oInMail:cReply
         lAuthPlain := .T.
      ENDIF
   ENDDO
   IF lAuthLogin
      IF !oInMail:Auth( cUser, cPass )
         lConnect := .F.
         oInMail:Quit()
      ELSE
         lConnectPlain  := .t.
      ENDIF
   ENDIF
   IF lAuthPlain .AND. !lConnect
      IF !oInMail:AuthPlain( cUser, cPass )
         lConnect := .F.
         oInMail:Quit()
      ENDIF
   ELSE
      IF !lConnectPlain
         oInmail:Getok()
         lConnect := .F.
      ENDIF
   ENDIF
ELSE
   lConnect := .F.
ENDIF
IF !lConnect
   IF !oInMail:Open()
      lConnect := .F.
      RETURN .F.
   ENDIF
   WHILE .T.
      oInMail:GetOk()
      IF oInMail:cReply == NIL
         EXIT
      ENDIF
   ENDDO
ENDIF
oInMail:oUrl:cUserid := cFrom
oMail:hHeaders[ "To" ]      := cTo
oMail:hHeaders[ "Subject" ] := cSubject
FOR EACH aThisFile IN AFiles
   IF VALTYPE( aThisFile ) == "C"
      cFile := aThisFile
      cData := MEMOREAD( cFile )
   ELSEIF VALTYPE( aThisFile ) == "A" .AND. LEN( aThisFile ) >= 2
      cFile := aThisFile[ 1 ]
      cData := aThisFile[ 2 ]
   ELSE
      lRet := .F.
      EXIT
   ENDIF
   oAttach := TipMail():New()
   //TODO: mime type magic auto-finder
   HB_FNameSplit( cFile,, @cFname, @cFext )
   IF LOWER( cFile ) LIKE ".+\.(zip|jp|jpeg|png|jpg|pdf|bin|dms|lha|lzh|exe|class|so|dll|dmg)" .OR. EMPTY(cFExt)
      oAttach:SetEncoder( "base64" )
   ELSE
      oAttach:SetEncoder( "7-bit" )
   ENDIF
   cMimeText := SetMimeType( cFile, cFname, cFext )
   // Some EMAIL readers use Content-Type to check for filename
   IF ".html" in LOWER( cFext) .OR. ".htm" in LOWER( cFext)
      cMimeText += "; charset=ISO-8859-1"
   ENDIF
   oAttach:hHeaders[ "Content-Type" ] := cMimeText
   // But usually, original filename is set here
   oAttach:hHeaders[ "Content-Disposition" ] := "attachment; filename=" + cFname + cFext
   oAttach:SetBody( cData )
   oMail:Attach( oAttach )
NEXT
IF lRead
   oMail:hHeaders[ "Disposition-Notification-To" ] := cUser
ENDIF
IF nPriority != 3
   oMail:hHeaders[ "X-Priority" ] := STR( nPriority, 1 )
ENDIF
lRet := .T.
IF lRet
   cData2 := oMail:ToString()
   oInmail:Write( cData2 )
   oInMail:commit()
ENDIF
oInMail:quit()
IF lRet
   cLastError := ""
ENDIF
RETURN lRet

*******************************************************************************
FUNCTION SetMimeType( cFile, cFname, cFext )
*******************************************************************************
cFile := LOWER( cFile )
IF cFile LIKE ".+\.zip"
   RETURN "application/x-zip-compressed;filename=" + cFname + cFext
ELSEIF cFile LIKE ".+\.(jpeg|jpg|jp)"
   RETURN "image/jpeg;filename=" + cFname + cFext
ELSEIF cFile LIKE ".+\.(png|bmp)"
   RETURN "image/png;filename=" + cFname + cFext
ELSEIF cFile LIKE ".+\.(bmp)"
   RETURN "image/bitmap;filename=" + cFname + cFext
ELSEIF cFile LIKE ".+\.html?"
   RETURN "text/html;filename=" + cFname + cFext
ELSEIF cFile LIKE ".+\.pdf"
   RETURN "application/pdf;filename=" + cFname + cFext
ELSEIF cFile LIKE ".+\.txt"
   RETURN "test/plain;filename=" + cFname + cFext
ELSEIF cFile LIKE ".+\.(bin|dms|lha|lzh|exe|class|so|dll|dmg)" .OR. EMPTY(cFExt)
   RETURN "application/octet-stream;filename=" + cFname + cFext
ENDIF
RETURN  "text/plain;filename=" + cFname + cFext

******************************************************************************
//PROCEDURE EnviaFTP(pipdest,parquivo)
/* Objetivo: Enviar arquivos via FTP atravÇs da internet.
   ParÉmetros:
   pIpDest   - IP de Destino
   pArquivo  - Arquivo que ser† transmitido */
******************************************************************************
/*
LOCAL vipdest,varquivo
IF !LinkConectado()
   Mensagem("Link de Internet Desconectado!",3,1)
   RETURN
ENDIF
IF pipdest=NIL .OR. parquivo=NIL
   Sinal("INTERNET","ENVIA FTP")
   Abrejan(2)
   //
   oipdest:=GetNew()
   oipdest:colorSpec:=vcr
   oipdest:row:=08;oipdest:col:=10
   oipdest:name:="vipdest";oipdest:picture:="@X"
   oipdest:block:={|valor| IF(PCOUNT()>0,vipdest:=valor,vipdest)}
   oipdest:postBlock:={|valor| !EMPTY(vipdest)}
   //
   oarquivo:=GetNew()
   oarquivo:colorSpec:=vcr
   oarquivo:row:=10;oarquivo:col:=10
   oarquivo:name:="varquivo";oarquivo:picture:="@X"
   oarquivo:block:={|valor| IF(PCOUNT()>0,varquivo:=valor,varquivo)}
   oarquivo:postBlock:={|valor| ValidaAnexo(varquivo)}
ENDIF
//
DO WHILE .T.
   vipdest :="201.12.18.153" // servidor remoto
   vipdest :=IF(pipdest=NIL,vipdest,pipdest)
   varquivo:=IF(parquivo=NIL,"",parquivo)
   IF pipdest=NIL .OR. parquivo=NIL
      vipdest :=PADR(vipdest,60)
      varquivo:=PADR(varquivo,60)
      @ 07,10 SAY "Servidor Remoto:"
      @ 09,10 SAY "Arquivo a Ser Enviado:"
      SETCOLOR(vcr)
      @ 08,10 SAY vipdest
      @ 10,10 SAY varquivo
      SETCOLOR(vcn)
      // Ediá∆o dos dados do envio
      SETCURSOR(IF(READINSERT(),2,1)) // 2-INSERT 1-NORMAL
      READMODAL({oipdest,oarquivo})
      SETCURSOR(0)
      IF LASTKEY()==27 // K_ESC
         EXIT
      ENDIF
      vipdest :=ALLTRIM(vipdest)
      varquivo:=ALLTRIM(varquivo)
   ENDIF
   @ 24,00 CLEAR
   Aviso(24,"Deseja Realmente Enviar o Arquivo")
   IF Confirme()
      @ 24,00 CLEAR
      Aviso(24,"Enviando Arquivo. Aguarde ...")
      IF SendFTP(vipdest,varquivo,"costa","logix")
         @ 24,00 CLEAR
         Aviso(24,"Arquivo Enviado !")
         Beep(2)
         INKEY(0)
      ELSE
         Mensagem("Arquivo N∆o Enviado !",3,1)
      ENDIF
   ENDIF
   @ 24,00 CLEAR
   EXIT
ENDDO
SETCOLOR(vcn)
CLEAR
RETURN
*/

*******************************************************************************
//FUNCTION SendFTP(cServerIP,cFile,cUser,cPass)
/*Function SendFTP()
  Parameters:
  cServerIP  -> Required. FTP server name or address
  cFile      -> Required. File to send to ServerIP
  cUser      -> Required. FTP user name
  cPass      -> Required. FTP user name password */
*******************************************************************************
/*
LOCAL n
LOCAL cUrl
LOCAL cStr
LOCAL oUrl
LOCAL oFTP
LOCAL lRet := .F. // .T.
// FTP Protocol
// ftp://user:passwd@<ftpserver>/[<path>]
cUrl := "ftp://"+cUser+":"+cPass+"@"+cServerIP //+"/"+cPath
// Verificando os parÉmetros
IF cServerIP=NIL .OR. cFile=NIL .OR. cUser=NIL .OR. cPass=NIL
   RETURN lRet
ENDIF
IF EMPTY(cFile)
   RETURN lRet
ENDIF
// Criando os objetos da classe Tip
oUrl              := tUrl():New( cUrl )
oFTP              := tIPClient():New( oUrl,, .T. )
oFTP:nConnTimeout := 20000
oFTP:bUsePasv     := .T.
// Comprovando se o usuario contem uma @ para foráar o userid
IF AT( "@", cUser ) > 0
   oFTP:oUrl:cServer   := cServerIP
   oFTP:oUrl:cUserID   := cUser
   oFTP:oUrl:cPassword := cPass
ENDIF
// Abrindo a conex∆o
IF oFTP:Open( cUrl )
   // Enviando o arquivo cFile
   IF oFTP:UpLoadFile( cFile )
      lRet := .T.
   ELSE
      lRet := .F.
   ENDIF
   oFTP:Close()
ELSE
   // Verificando o erro da abertura da conex∆o
   cStr := "N∆o foi Poss°vel Conectar ao Servidor FTP "+oURL:cServer
   IF oFTP:SocketCon == NIL
      cStr += CHR(13)+CHR(10)+"Conex∆o n∆o inicializada"
   ELSEIF InetErrorCode( oFTP:SocketCon ) == 0
      cStr += CHR(13)+CHR(10)+"Resposta do servidor: "+oFTP:cReply
   ELSE
      cStr += CHR(13)+CHR(10)+"Erro na conex∆o: "+InetErrorDesc(oFTP:SocketCon)
   ENDIF
   ? cStr
   lRet := .F.
ENDIF
RETURN lRet
*/

**************************************************************************
FUNCTION EXT(pval)
// Objetivo: Retornar o extenso de um numero
****************************************************************
LOCAL unidades:={"UM","DOIS","TR“S","QUATRO","CINCO","SEIS","SETE","OITO","NOVE"}
LOCAL unidonze:={"ONZE","DOZE","TREZE","QUATORZE","QUINZE","DEZESSEIS",;
                 "DEZESSETE","DEZOITO","DEZENOVE"}
LOCAL decimais:={"","VINTE","TRINTA","QUARENTA","CINQUENTA","SESSENTA",;
                 "SETENTA","OITENTA","NOVENTA"}
LOCAL centos:={"CENTO","DUZENTOS","TREZENTOS","QUATROCENTOS","QUINHENTOS",;
               "SEISCENTOS","SETECENTOS","OITOCENTOS","NOVECENTOS"}
LOCAL texto:="", cnum:=LEFT(STR(pval,12,2),9), cents:=""
// Milh‰es
IF SUBSTR(cnum,1,1)>"0"
   texto:=centos[VAL(SUBSTR(cnum,1,1))]
ENDIF
IF texto > " "
   IF SUBSTR(cnum,2,2) <> "00"
      texto:=texto+" E "
   ENDIF
ENDIF
IF SUBSTR(cnum,2,1)>"1"
   texto=texto+decimais[VAL(SUBSTR(cnum,2,1))]
   IF texto > " "
      IF SUBSTR(cnum,3,1) <> "0"
         texto = texto + " E "
      ENDIF
   ENDIF
   IF SUBSTR(cnum,3,1)>"0"
      texto=texto+unidades[VAL(SUBSTR(cnum,3,1))]
   ENDIF
   texto=texto+" MILHÂES"
ELSEIF SUBSTR(cnum,2,1)="1"
   texto=texto+unidonze[VAL(SUBSTR(cnum,3,1))]+" MILHÂES"
ELSEIF SUBSTR(cnum,2,2)="00"
   texto=SUBSTR(texto,1,LEN(texto)) + " MILHÂES"
   IF SUBSTR(cnum,1,1)="1"
      texto = "CEM MILHÂES"
   ENDIF
ELSEIF SUBSTR(cnum,3,1)>" "
   texto=texto+unidades[VAL(SUBSTR(cnum,3,1))]+" MILHÂES"
ENDIF
IF texto = "UM MILHÂES"
   texto = "UM MILH«O"
ENDIF
IF SUBSTR(cnum,4,6) = "000000"
   texto:=texto+" DE"
ENDIF
// Centenas e Milhares
IF texto > " "
   IF SUBSTR(cnum,4,3) <> "000"
      texto = texto+", "
   ENDIF
ENDIF
IF SUBSTR(cnum,4,1)>" "
   IF SUBSTR(cnum,4,1)<>"0"
      texto=texto+centos[VAL(SUBSTR(cnum,4,1))]
   ENDIF
ENDIF
IF texto > " "
   IF SUBSTR(cnum,5,2) <> "00"
      IF RIGHT(texto,2) = ", "
         texto = SUBSTR(texto,1,LEN(texto)-2) + " E "
      ELSE
         texto = RTRIM(texto) + " E "
      ENDIF
   ENDIF
ENDIF
IF SUBSTR(cnum,5,1)>"1"
   texto=texto+decimais[VAL(SUBSTR(cnum,5,1))]
   IF texto > " "
      IF SUBSTR(cnum,6,1) <> "0"
         texto = texto + " E "
      ENDIF
   ENDIF
   IF SUBSTR(cnum,6,1)>"0"
      texto=texto+unidades[VAL(SUBSTR(cnum,6,1))]
   ENDIF
   texto=texto+" MIL"
ELSEIF SUBSTR(cnum,5,1)="1"
   IF SUBSTR(cnum,6,1)<>"0"
      texto=texto+unidonze[VAL(SUBSTR(cnum,6,1))]+" MIL"
   ELSE
      texto=texto+"DEZ MIL"
   ENDIF
ELSEIF SUBSTR(cnum,5,2)="00"
   IF RIGHT(texto,2) <> "DE"
      IF SUBSTR(cnum,4,3) <> "000"
         texto=SUBSTR(texto,1,LEN(texto)) + " MIL"
      ENDIF
      IF SUBSTR(cnum,4,1)="1"
         texto = LEFT(texto,LEN(texto)-9)+"CEM MIL"
      ENDIF
   ENDIF
ELSEIF SUBSTR(cnum,6,1)>" "
   texto=texto+unidades[VAL(SUBSTR(cnum,6,1))]+" MIL"
ENDIF
// Centenas
IF texto > " "
   IF SUBSTR(cnum,7,3) <> "000"
      texto = texto + ", "
   ENDIF
ENDIF
IF SUBSTR(cnum,7,1)>"0"
   texto=texto+centos[VAL(SUBSTR(cnum,7,1))]
ENDIF
IF SUBSTR(cnum,7,3) = "100"
   texto = SUBSTR(texto,1,LEN(texto)-5) + "CEM"
ENDIF
// dezenas e unidades
IF texto > " "
   IF SUBSTR(cnum,8,2) <> "00"
      IF RIGHT(texto,2)=", "
         texto = SUBSTR(texto,1,LEN(texto)-2) + " E "
      ELSE
         texto = RTRIM(texto) + " E "
      ENDIF
   ENDIF
ENDIF
IF SUBSTR(cnum,8,1)>"1"
   texto=texto+decimais[VAL(SUBSTR(cnum,8,1))]
   IF RIGHT(cnum,1)>"0"
      texto=texto+" E "+ unidades[VAL(RIGHT(cnum,1))]
   ENDIF
ELSEIF SUBSTR(cnum,8,1)="1"
   IF RIGHT(cnum,1)<>"0"
      texto=texto+unidonze[VAL(RIGHT(cnum,1))]
   ELSE
      texto=texto+"DEZ"
   ENDIF
ELSEIF RIGHT(cnum,2)=" 0"
   texto=" "
ELSE
   IF RIGHT(cnum,1)<>"0"
      texto=texto+unidades[VAL(RIGHT(cnum,1))]
   ENDIF
ENDIF
IF texto = "CEM E "
   texto = "CEM"
ENDIF
texto=RTRIM(texto)+" REAIS"
IF texto = "UM REAIS"
   texto = "UM REAL"
ENDIF
// Centavos
cents:=RIGHT(STR(pval,12,2),2)
IF LTRIM(texto)="REAIS"
   texto:=""
ENDIF
IF cents <> "00"
   IF texto > " "
      texto:=texto+" E "
   ENDIF
ENDIF
IF SUBSTR(cents,1,1)>"1"
   texto=texto+decimais[VAL(SUBSTR(cents,1,1))]
   IF RIGHT(cents,1)>"0"
      texto=texto+" E "+unidades[VAL(RIGHT(cents,1))]
   ENDIF
ELSEIF SUBSTR(cents,1,1)="1"
   IF RIGHT(cents,1)="0"
      texto=texto+"DEZ"
   ELSE
      texto=texto+unidonze[VAL(RIGHT(cents,1))]
   ENDIF
ELSE
   IF RIGHT(cents,1)<>"0"
      texto=texto+unidades[VAL(RIGHT(cents,1))]
   ENDIF
ENDIF
IF cents <> "00"
   texto=texto+" CENTAVOS"
ENDIF
IF cents = "01"
   texto=SUBSTR(texto,1,LEN(texto)-8) + "CENTAVO"
ENDIF
RETURN texto

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
//Moldura(02,00,23,79,2)
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
   marqprn:=DIRECTORY(".\TRANSF\RELATO*.PRN")
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
   vcimpres:=".\TRANSF\"+varqprn
ELSEIF vcporta="3"  // Arquivo
   vcop:=1
   vcimpres:=".\TRANSF\"+"ARQUIVO.PRN"
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
//Caixa2(02,05,LEN(pMat)+5,75,frame[1],)
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

******************************************************************************
PROCEDURE DataPrazo(pdata,pdias)
// Calcula a data final (data+prazo)
*********************************************************
LOCAL i:=0,vdata:=pdata
DO WHILE i < pdias
   i++
   vdata++
ENDDO
RETURN vdata

*******************************************************************************
PROCEDURE Trunc(num,dec)
/* Objetivo: Truncar um n£mero, utilizando somente a quantidade
             de casas decimais desejada.
 Parametros: O n£mero e as casas decimais a serem utilizadas
 Retorno...: O n£mero truncado. */
*******************************************************************************
RETURN VAL(SUBSTR(ALLTRIM(STR(num-INT(num))),3,dec))/10**dec+INT(num)

*******************************************************************************
PROCEDURE LojaVM(pemp,ploja)
// Objetivo: Retornar a loja do VM de acordo com a empresa e filial
*******************************************************************************
matriz:={;
{"00","0" ,"Matriz"  },;
{"01","1" ,"Aldeota" },;
{"02","2" ,"MCastelo"},;
{"03","3" ,"Natal"   },;
{"20","6" ,"Montese" },;
{"40","7" ,"Belem"   },;
{"50","8" ,"S∆o Luis"}}
x:=Mascan(matriz,1,pemp+ploja)
IF x > 0
   RETURN matriz[x,2]
ENDIF
RETURN SPACE(1)


/******************************************************************************
PROCEDURE Execute(cComando,nJanela,lAguarda)
// Executa outro aplicativo atravÇs do mÇtodo Run do Objeto Shell
// ParÉmetros:
// cComando..: Comando a ser executado (Pode ser .EXE, .BAT, .VBS, etc)
// nJanela...: N£mero da janela (0 -> Comando executado em uma janela oculta)
// lConclusao: Aguarda a execuá∆o ou continua em paralelo
//             True diz para aguardar atÇ que o Comando seja conclu°do
//             Falso diz para o programa continuar
******************************************************************************
LOCAL oShell, retorno
oShell:=CreateObject("WScript.Shell")
retorno:=oShell:Run("%comspec% /c "+cComando,nJanela,lAguarda)
oShell:=NIL
RETURN retorno
*/

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
