********************************************************************************
/* Programa.: MG_CADA2.PRG
   Funá∆o...: M¢dulo de Cadastros Gerais
   Data.....: 05/06/02
   Autor....: Edilberto L. Souza */
********************************************************************************

#include "SIG.CH"
#include "SETCURS.CH"
#include "DBSTRUCT.CH"

********************************************************************************
// ### ROTINAS DE CADASTRO DE PRODUTOS
********************************************************************************
PROCEDURE ConsPrc()
// Consulta ao arquivo de dados de produtos do FC
********************************************************************************
// Declara as var†veis do browse
LOCAL vdado[26],vpict[26],vcabe[26],vedit[26]
// Vari†veis para verificaá∆o de senha.
PRIVATE pv1:=pv2:=pv3:=pv4:=pv5:=.T.
// Abertura dos arquivos de dados
marqs:={;
{(dircad+"FC_PRODU.DBF"),"Prc","Produtos do FC",3},;
{(dircad+"FC_GRUPO.DBF"),"Gru","Grupo de Produtos",2},;
{(dircad+"FC_FORNE.DBF"),"For","Fornecedores",1},;
{(dirmov+"FC_INVEN.DBF"),"Inv","Invent†rio",2},;
{(dirmov+"FC_SALDO.DBF"),"Sdo","Saldo de Estoque",1},;
{(dirmov+"FC_SALGE.DBF"),"Sdg","Saldo de Estoque",1}}
IF !AbreArqs(marqs,.F.)
   RETURN
ENDIF
AFILL(vedit,.T.)
// vdado: vetor dos nomes dos campos
vdado[01]:="codgru"
vdado[02]:="codpro"
vdado[03]:="codaux"
vdado[04]:="prod"
vdado[05]:="unid"
vdado[06]:="cfi"
vdado[07]:="taxaipi"
vdado[08]:="ticms"
vdado[09]:="preco1"
vdado[10]:="preco2"
vdado[11]:="preco3"
vdado[12]:="preven"
vdado[13]:="precus"
vdado[14]:="premed"
vdado[15]:="datcad"
vdado[16]:="estmin"
vdado[17]:="resupr"
vdado[18]:="estmax"
vdado[19]:="conmed"
vdado[20]:="sugped"
vdado[21]:="temres"
vdado[22]:="datcmp"
vdado[23]:="precmp"
vdado[24]:="codfor"
vdado[25]:="ultent"
vdado[26]:="datmod"
// vpict: vetor das m†scaras de apresentaá∆o dos dados.
vpict[01]:="@R 99.99"
vpict[02]:="9999999"
vpict[03]:="9999999"
vpict[04]:="@!"
vpict[05]:="@!"
vpict[06]:="!"
vpict[07]:="@E 99.99"
vpict[08]:="@E 99.99"
vpict[09]:="@E 9,999.99"
vpict[10]:="@E 9,999.99"
vpict[11]:="@E 9,999.99"
vpict[12]:="@E 9,999.99"
vpict[13]:="@E 9,999.99"
vpict[14]:="@E 9,999.99"
vpict[15]:="99/99/99"
vpict[16]:="@E 9,999.99"
vpict[17]:="@E 9,999.99"
vpict[18]:="@E 9,999.99"
vpict[19]:="@E 9,999.99"
vpict[20]:="@E 9,999.99"
vpict[21]:="99"
vpict[22]:="99/99/99"
vpict[23]:="@E 9,999.99"
vpict[24]:="99999"
vpict[25]:="@E 9,999.99"
vpict[26]:="99/99/99"
// vcabe: vetor dos t°tulos para o cabeáalho das colunas.
vcabe[01]:="Grupo"
vcabe[02]:="C¢d.Prod"
vcabe[03]:="C¢d.Aux"
vcabe[04]:="Nome do Produto"
vcabe[05]:="Unid"
vcabe[06]:="CF"
vcabe[07]:="IPI"
vcabe[08]:="ICMS"
vcabe[09]:=vctab1
vcabe[10]:=vctab2
vcabe[11]:=vctab3
vcabe[12]:="   Venda"
vcabe[13]:="   Custo"
vcabe[14]:="   MÇdio"
vcabe[15]:="Cadastro"
vcabe[16]:="Est.M°nimo"
vcabe[17]:="Resuprimento"
vcabe[18]:="Est.M†ximo"
vcabe[19]:="Cons.MÇdio"
vcabe[20]:="Sug.Pedido"
vcabe[21]:="Tempo"
vcabe[22]:="Compra"
vcabe[23]:="Preáo"
vcabe[24]:="Fornecedor"
vcabe[25]:="Èltima Entrada"
vcabe[26]:="Atualizaá∆o"
// Informaá‰es para ajuda ao usu†rio.
majuda:={;
"Ins        - Inclui um novo Produto no Sistema",;
"Ctrl+Enter - Altera o Produto sob Cursor",;
"Del        - Exclui o Produto sob Cursor",;
"Enter      - Consulta o Produto em Tela Cheia",;
"F2         - Pesquisa pelo C¢digo do Produto",;
"F3         - Pesquisa pelo Nome do Produto",;
"F4         - Pesquisa pela C¢digo Auxiliar",;
"F9         - Relat¢rio dos Produtos"}
// Construá∆o da Tela de Apresentaá∆o.
Sinal("PRODUTOS","CONSULTA")
Abrejan(2)
@ 04,01 SAY REPLICATE("ƒ",78)
// Barra de Tarefas.
SETCOLOR(vcr)
@ 22,00 SAY PADC("Ins=Inclui Ctrl+Enter=Altera Del=Exclui Enter=Consulta Esc=Encerra",80)
@ 23,00 SAY PADC("F1=Ajuda F2=CodigoProduto F3=NomeProduto F4=C¢digoAuxliar F9=Rel",80)
SETCOLOR(vcn)
// Chamada do procedimento de consulta desenvolvido com TBrowse.
ConsBrowse("Prc",05,01,21,78,vdado,vpict,vcabe,vedit,0,{|| OpsPrc()},;
           "codpro",1,"9999999",7,"C¢digo Produto",;
           "prod",2,"@!",30,"Nome do Produto",;
           "codaux",3,"9999999",7,"C¢digo Auxiliar")
CLOSE DATABASE
RETURN

********************************************************************************
FUNCTION OpsPrc()
// Opá‰es da consulta de Produtos.
********************************************************************************
LOCAL vtela
// Destaque do browse
@ 03,03 CLEAR TO 03,77
@ 03,03 SAY "Produto:"
SETCOLOR(vcd)
@ 03,12 SAY Prc->codpro+"-"+Prc->prod
SETCOLOR(vcn)
// Teclas de opá‰es da consulta
IF LASTKEY()=K_INS
   // Ins - Inclus∆o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatPrc(1)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_CTRL_ENTER
   // Ctrl+Enter - Alteraá∆o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatPrc(2)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_DEL
   // Del - Exclus∆o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatPrc(3)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_ENTER
   // Enter - Consulta em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatPrc(4)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_F9
   // F9 - Relat¢rio.
   vtela:=SAVESCREEN(01,00,24,79)
   Relprc()
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ENDIF
RETURN .F.

*************************************************************************
PROCEDURE Matprc(modo)
/* Manutená∆o de PRODUTOS
   Parametros: modo - operaá∆o a ser realizada: 1 - Inclus∆o
                                                2 - Alteraáao
                                                3 - Exclus∆o */
********************************************************************************
IF modo=1                       // se for Inclus∆o
   IF pv1                       // se precisa verificar
      IF !Senha("A1")           // se n∆o for credenciado
         RETURN                 // retorna para o browse
      ENDIF                     // se for credenciado
      pv1:=.F.                  // n∆o precisa verificar da pr¢xima vez
   ENDIF
   Sinal("PRODUTOS","INCLUS«O") // atualiza status na tela
ELSEIF modo=2
   IF pv2
      IF !Senha("A2")
         RETURN
      ENDIF
      pv2:=.F.
   ENDIF
   Sinal("PRODUTOS","ALTERAÄ«O")
ELSEIF modo=3
   IF pv3
      IF !Senha("A3")
         RETURN
      ENDIF
      pv3:=.F.
   ENDIF
   Sinal("PRODUTOS","EXCLUS«O")
ENDIF
Abrejan(2)
DO WHILE .T.
   // Inicializaá∆o das vari†veis auxiliares.
   vcodgru:=SPACE(04)
   vcodpro:=SPACE(07)
   vprod  :=SPACE(40)
   vunid  :=SPACE(02)
   vcfi   :=SPACE(01)
   vtaxaipi:=0
   vticms :=0
   vpreco1:=0
   vpreco2:=0
   vpreco3:=0
   vpreven:=0
   vprecus:=0
   vpremed:=0
   vdatcad:=CTOD(SPACE(08))
   vestmin:=0
   vresupr:=0
   vestmax:=0
   vconmed:=0
   vsugped:=0
   vtemres:=0
   vdatcmp:=CTOD(SPACE(08))
   vprecmp:=0
   vcodfor:=SPACE(05)
   vultent:=0
   vende  :=SPACE(03)
   vqtdatu:=0
   vqtdat2:=0
   vqtdat3:=0
   vdatmod:=CTOD(SPACE(08))
   // Apresenta os t°tulos na tela
   Titprc()
   IF modo=1
      SET ORDER TO 1
      SEEK "95"
      SKIP -1
      vcodpro:=STRZERO(VAL(Prc->codpro)+1,7)
   ELSE // Se n∆o for Inclus∆o
      // Transfere os dados do registro para as vari†veis auxiliares.
      Transfprc()
   ENDIF
   // Mostra os dados com as variaveis auxiliares
   Mostraprc()
   // Exclus∆o
   IF modo=3
      SELECT Sdo
      GO TOP
      SEEK vcodpro
      IF FOUND()
         Mensagem("Produto com Saldo em Estoque !",3,1)
         SELECT Prc
         EXIT
      ENDIF
      SELECT Sdg
      GO TOP
      SEEK vcodpro
      IF FOUND()
         Mensagem("Produto com Saldo em Estoque !",3,1)
         SELECT Prc
         EXIT
      ENDIF
      SELECT Inv
      SET ORDER TO 2
      GO TOP
      SEEK vcodpro
      IF FOUND()
         Mensagem("Produto com Saldo em Invent†rio !",3,1)
         SELECT Prc
         EXIT
      ENDIF
      SELECT Prc
      IF Exclui() // Deleta o registro do arquivo.
         IF Bloqreg(10)
            DELETE
            UNLOCK
         ELSE
            Mensagem("O Registro N∆o Est† Dispon°vel !",3,1)
         ENDIF
      ENDIF
      EXIT
   ENDIF
   // Consulta
   IF modo=4
      SETCOLOR(vcr)
      @ 23,00 SAY PADC("F2=EstoqueVM  PageUp=Pr¢x.Reg.  PageDown=Reg.Ant.  Esc=Retorna",80)
      SETCOLOR(vcn)
      INKEY(0)
      IF LASTKEY()=K_PGUP
         SKIP
         LOOP
      ELSEIF LASTKEY()=K_PGDN
         SKIP -1
         LOOP
      ELSEIF LASTKEY()=K_F2
         EstoqueVM(vcodpro)
         LOOP
      ELSEIF LASTKEY()=K_ESC
         EXIT
      ELSE
         mAjuda2:={;
         "F2          - Exibe Estoque do VM",;
         "PgUp        - Exibe o Pr¢ximo Registro",;
         "PgDn        - Exibe o Registro Anterior",;
         "Esc         - Volta Ö Tela de Consulta"}
         Ajuda2(mAjuda2)
         LOOP
      ENDIF
   ENDIF
   // Edita os Dados do Registro
   Editaprc(modo)
   IF LASTKEY()=K_ESC
      EXIT
   ENDIF
   IF !Confirme()
      LOOP
   ENDIF
   IF modo=1 // Inclus∆o
      // Inclui um novo registro no arquivo.
      IF Adireg(10)
         UNLOCK
      ELSE
         Mensagem("Erro de Rede, Inclus∆o N∆o Efetuada!",3,1)
      ENDIF
   ENDIF
   // Atualiza o conte£do dos campos do registro com as vari†veis auxiliares.
   IF Bloqreg(10)
      Atualprc()
      COMMIT
      UNLOCK
   ELSE
      Mensagem("O Registro N∆o Est† Dispon°vel !",3,1)
   ENDIF
   IF modo=1
      LOOP
   ENDIF
   EXIT
ENDDO
RETURN

******************************************************************************
PROCEDURE Titprc()
// Apresenta os t°tulos do arquivo na tela.
*******************************************
SETCOLOR(vcn)
        //          10        20        30        40        50        60        70
        // 01234567890123456789012345678901234567890123456789012345678901234567890123456789
@ 03,02 SAY "Grupo:"
@ 04,02 SAY "Produto:"
@ 04,63 SAY "Unid:"
@ 05,02 SAY "Endereáo:     Classificaá∆o Fiscal:   IPI:        ICMS:     "
//
@ 07,02 SAY "Preáo da Tabela 1....:         ("+vctab1+")"
@ 08,02 SAY "Preáo da Tabela 2....:         ("+vctab2+")"
@ 09,02 SAY "Preáo da Tabela 3....:         ("+vctab3+")"
@ 10,02 SAY "Menor Preáo de Venda.:"
@ 11,02 SAY "Preáo de Custo.......:"
@ 12,02 SAY "Preáo MÇdio..........:"
//
@ 14,02 SAY "Èltima Entrada.......:              Preáo:             Data:"
@ 15,02 SAY "Fornecedor:"
@ 16,02 SAY "                                    Em Estoque-1:"
@ 17,02 SAY "Tempo de Resuprimento:              Em Estoque-2:"
@ 18,02 SAY "Consumo MÇdio p/màs..:              Em Corte....:"
@ 19,02 SAY "Estoque M°nimo.......:              Em Produá∆o.:"
@ 20,02 SAY "Resuprimento.........:              Em Expediá∆o:"
@ 21,02 SAY "Estoque M†ximo.......:              Almoxarifado:"
@ 22,02 SAY "Sugest∆o de Pedido...:              Cadastrado:         Atualizado:"
RETURN
********************************************************************************
PROCEDURE Mostraprc()
// Mostra os dados do arquivo na tela.
********************************************************************************
SETCOLOR(vcd)
@ 03,08 SAY vcodgru PICTURE "@R 99.99"
Sayd(03,14,Procura("Gru",1,vcodgru,"nome"),"@!",40)
@ 04,10 SAY vcodpro PICTURE "@R 99.9.99.99"
Sayd(04,21,vprod,"@!",40)
Sayd(04,68,vunid,"@!",2)
Sayd(05,11,vende,"@!",3)
@ 05,37 SAY vcfi PICTURE "!"
Sayd(05,44,vtaxaipi,"@E 99.99",6,"%")
Sayd(05,57,vticms,"@E 99.99",6,"%")
Sayd(07,24,vpreco1,"@E 9,999.99",9)
Sayd(08,24,vpreco2,"@E 9,999.99",9)
Sayd(09,24,vpreco3,"@E 9,999.99",9)
Sayd(10,24,vpreven,"@E 9,999.99",9)
Sayd(11,24,vprecus,"@E 9,999.99",9)
Sayd(12,24,vpremed,"@E 9,999.99",9)
//
Sayd(14,24,vultent,"@E 99,999.99",12," "+LOWER(vunid))
Sayd(14,44,vprecmp,"@E 99,999.99",9)
@ 14,62 SAY vdatcmp PICTURE "99/99/99"
@ 15,13 SAY vcodfor PICTURE "99999"
Sayd(15,18,"-"+Procura("For",1,vcodfor,"nome"),"@!",41)
//
Sayd(16,51,Saldo(vcodpro,"001"),"@E 99,999.99",12," "+LOWER(vunid)) // Estoque-1
Sayd(16,66,Saldg(vcodpro,"001"),"@E 99,999.99",12," "+LOWER(vunid))

Sayd(17,24,vtemres,"99",8," dias")
Sayd(17,51,Saldo(vcodpro,"051"),"@E 99,999.99",12," "+LOWER(vunid)) // Estoque-2
Sayd(17,66,Saldg(vcodpro,"051"),"@E 99,999.99",12," "+LOWER(vunid))

Sayd(18,24,vconmed,"@E 99,999.99",12," "+LOWER(vunid))
Sayd(18,51,Saldo(vcodpro,"002"),"@E 99,999.99",12," "+LOWER(vunid)) // Corte
Sayd(18,66,Saldg(vcodpro,"002"),"@E 99,999.99",12," "+LOWER(vunid))

Sayd(19,24,vestmin,"@E 99,999.99",12," "+LOWER(vunid))
Sayd(19,51,Saldo(vcodpro,"003"),"@E 99,999.99",12," "+LOWER(vunid)) // Produá∆o
Sayd(19,66,Saldg(vcodpro,"003"),"@E 99,999.99",12," "+LOWER(vunid))

Sayd(20,24,vresupr,"@E 99,999.99",12," "+LOWER(vunid))
Sayd(20,51,Saldo(vcodpro,"004"),"@E 99,999.99",12," "+LOWER(vunid)) // Expediá∆o
Sayd(20,66,Saldg(vcodpro,"004"),"@E 99,999.99",12," "+LOWER(vunid))

Sayd(21,24,vestmax,"@E 99,999.99",12," "+LOWER(vunid))
Sayd(21,51,Saldo(vcodpro,"301"),"@E 99,999.99",12," "+LOWER(vunid)) // Almoxarifado
Sayd(21,66,Saldg(vcodpro,"301"),"@E 99,999.99",12," "+LOWER(vunid))
Sayd(22,24,vsugped,"@E 99,999.99",12," "+LOWER(vunid))
//
@ 22,49 SAY vdatcad PICTURE "99/99/99"
@ 22,69 SAY vdatmod PICTURE "99/99/99"
SETCOLOR(vcn)
RETURN

********************************************************************************
PROCEDURE Editaprc(pmodo)
// Edita os dados do arquivo atravÇs das vari†veis auxiliares.
********************************************************************************
SETCURSOR(IF(READINSERT(),SC_INSERT,SC_NORMAL))
//
ocodgru:=GetNew()
ocodgru:colorSpec:=vcd
ocodgru:row:=03;ocodgru:col:=08
ocodgru:name:="vcodgru";ocodgru:picture:="@R 99.99"
ocodgru:block:={|valor| IF(PCOUNT()>0,vcodgru:=valor,vcodgru)}
ocodgru:postBlock:={|valor| CodGru(03,08)}
//
ocodpro:=GetNew()
ocodpro:colorSpec:=vcd
ocodpro:row:=04;ocodpro:col:=10
ocodpro:name:="vcodpro";ocodpro:picture:="@R 99.9.99.99"
ocodpro:block:={|valor| IF(PCOUNT()>0,vcodpro:=valor,vcodpro)}
ocodpro:postBlock:={|valor| CodPro(pmodo)}
//
oprod:=GetNew()
oprod:colorSpec:=vcd
oprod:row:=04;oprod:col:=21
oprod:name:="vprod";oprod:picture:="@!"
oprod:block:={|valor| IF(PCOUNT()>0,vprod:=valor,vprod)}
oprod:postBlock:={|valor| !EMPTY(vprod)}
//
ounid:=GetNew()
ounid:colorSpec:=vcd
ounid:row:=04;ounid:col:=68
ounid:name:="vunid";ounid:picture:="@!"
ounid:block:={|valor| IF(PCOUNT()>0,vunid:=valor,vunid)}
ounid:postBlock:={|valor| !EMPTY(vunid)}
//
oende:=GetNew()
oende:colorSpec:=vcd
oende:row:=05;oende:col:=11
oende:name:="vende";oende:picture:="@!"
oende:block:={|valor| IF(PCOUNT()>0,vende:=valor,vende)}
//oende:postBlock:={|valor| !EMPTY(vende)}
//
ocfi:=GetNew()
ocfi:colorSpec:=vcd
ocfi:row:=05;ocfi:col:=37
ocfi:name:="vcfi";ocfi:picture:="@!"
ocfi:block:={|valor| IF(PCOUNT()>0,vcfi:=valor,vcfi)}
//
otaxaipi:=GetNew()
otaxaipi:colorSpec:=vcd
otaxaipi:row:=05;otaxaipi:col:=44
otaxaipi:name:="vtaxaipi";otaxaipi:picture:="@E 99.99"
otaxaipi:block:={|valor| IF(PCOUNT()>0,vtaxaipi:=valor,vtaxaipi)}
//
oticms:=GetNew()
oticms:colorSpec:=vcd
oticms:row:=05;oticms:col:=57
oticms:name:="vticms";oticms:picture:="@E 99.99"
oticms:block:={|valor| IF(PCOUNT()>0,vticms:=valor,vticms)}
//
opreco1:=GetNew()
opreco1:colorSpec:=vcd
opreco1:row:=07;opreco1:col:=24
opreco1:name:="vpreco1";opreco1:picture:="@E 9,999.99"
opreco1:block:={|valor| IF(PCOUNT()>0,vpreco1:=valor,vpreco1)}
//
opreco2:=GetNew()
opreco2:colorSpec:=vcd
opreco2:row:=08;opreco2:col:=24
opreco2:name:="vpreco2";opreco2:picture:="@E 9,999.99"
opreco2:block:={|valor| IF(PCOUNT()>0,vpreco2:=valor,vpreco2)}
//
opreco3:=GetNew()
opreco3:colorSpec:=vcd
opreco3:row:=09;opreco3:col:=24
opreco3:name:="vpreco3";opreco3:picture:="@E 9,999.99"
opreco3:block:={|valor| IF(PCOUNT()>0,vpreco3:=valor,vpreco3)}
//
opreven:=GetNew()
opreven:colorSpec:=vcd
opreven:row:=10;opreven:col:=24
opreven:name:="vpreven";opreven:picture:="@E 9,999.99"
opreven:block:={|valor| IF(PCOUNT()>0,vpreven:=valor,vpreven)}
//
otemres:=GetNew()
otemres:colorSpec:=vcd
otemres:row:=17;otemres:col:=24
otemres:name:="vtemres";otemres:picture:="99"
otemres:block:={|valor| IF(PCOUNT()>0,vtemres:=valor,vtemres)}
otemres:postBlock:={|| vtemres>0}
//
oconmed:=GetNew()
oconmed:colorSpec:=vcd
oconmed:row:=18;oconmed:col:=24
oconmed:name:="vconmed";oconmed:picture:="@E 9,999.99"
oconmed:block:={|valor| IF(PCOUNT()>0,vconmed:=valor,vconmed)}
oconmed:postBlock:={|| CalculaVar()}
/*
oestmin:=GetNew()
oestmin:colorSpec:=vcd
oestmin:row:=19;oestmin:col:=24
oestmin:name:="vestmin";oestmin:picture:="@E 9,999.99"
oestmin:block:={|valor| IF(PCOUNT()>0,vestmin:=valor,vestmin)}
//
oresupr:=GetNew()
oresupr:colorSpec:=vcd
oresupr:row:=20;oresupr:col:=24
oresupr:name:="vresupr";oresupr:picture:="@E 9,999.99"
oresupr:block:={|valor| IF(PCOUNT()>0,vresupr:=valor,vresupr)}
//
oestmax:=GetNew()
oestmax:colorSpec:=vcd
oestmax:row:=21;oestmax:col:=24
oestmax:name:="vestmax";oestmax:picture:="@E 9,999.99"
oestmax:block:={|valor| IF(PCOUNT()>0,vestmax:=valor,vestmax)}
//
osugped:=GetNew()
osugped:colorSpec:=vcd
osugped:row:=22;osugped:col:=24
osugped:name:="vsugped";osugped:picture:="@E 9,999.99"
osugped:block:={|valor| IF(PCOUNT()>0,vsugped:=valor,vsugped)}
*/
odatcad:=GetNew()
odatcad:colorSpec:=vcd
odatcad:row:=22;odatcad:col:=49
odatcad:name:="vdatcad";odatcad:picture:="99/99/99"
odatcad:block:={|valor| IF(PCOUNT()>0,vdatcad:=valor,vdatcad)}
//
SETCURSOR(2)
IF pmodo=1
   READMODAL({ocodgru,ocodpro,oprod,ounid,oende,ocfi,otaxaipi,oticms,;
   opreco1,opreco2,opreco3,opreven,otemres,oconmed,odatcad})
ELSE
   READMODAL({oprod,ounid,oende,ocfi,otaxaipi,oticms,;
   opreco1,opreco2,opreco3,opreven,otemres,oconmed,odatcad})
ENDIF
SETCURSOR(0)
vdatmod:=DATE()
Mostraprc()
RETURN

********************************************************************************
STATIC FUNCTION CodPro(modo)
********************************************************************************
IF EMPTY(vcodpro) .OR. LASTKEY()==K_ESC
   RETURN .F.
ENDIF
IF modo=1 // inclus∆o
   SEEK vcodpro
   IF FOUND()
      Mensagem("Produto J† Cadastrado !",3,1)
      RETURN .F.
   ENDIF
ENDIF
RETURN .T.

********************************************************************************
STATIC FUNCTION CalculaVar()
********************************************************************************
vestmin:=INT((vconmed/30)*vtemres*1.1)+1
vresupr:=INT(vestmin+(vconmed/4))+1
vestmax:=INT(vestmin+vconmed)
vsaldg :=Saldg(vcodpro,"301")
vsugped:=IF(vresupr-vsaldg>0,vresupr-vsaldg,0)
RETURN .T.

********************************************************************************
PROCEDURE Transfprc()
********************
vcodgru :=Prc->codgru
vcodpro :=Prc->codpro
vprod   :=Prc->prod
vunid   :=Prc->unid
vcfi    :=Prc->cfi
vtaxaipi:=Prc->taxaipi
vticms  :=Prc->ticms
vpreco1 :=Prc->preco1
vpreco2 :=Prc->preco2
vpreco3 :=Prc->preco3
vpreven :=Prc->preven
vprecus :=Prc->precus
vpremed :=Prc->premed
vdatcad :=Prc->datcad
vestmin :=Prc->estmin
vresupr :=Prc->resupr
vestmax :=Prc->estmax
vconmed :=Prc->conmed
vsugped :=Prc->sugped
vtemres :=Prc->temres
vdatcmp :=Prc->datcmp
vprecmp :=Prc->precmp
vcodfor :=Prc->codfor
vultent :=Prc->ultent
vende   :=Prc->ende
vqtdatu :=Prc->qtdatu
vqtdat2 :=Prc->qtdat2
vqtdat3 :=Prc->qtdat3
vdatmod :=Prc->datmod
RETURN

********************************************************************************
PROCEDURE Atualprc()
*******************
Prc->codgru :=vcodgru
Prc->codpro :=vcodpro
Prc->prod   :=vprod
Prc->unid   :=vunid
Prc->cfi    :=vcfi
Prc->taxaipi:=vtaxaipi
Prc->ticms  :=vticms
Prc->preco1 :=vpreco1
Prc->preco2 :=vpreco2
Prc->preco3 :=vpreco3
Prc->preven :=vpreven
Prc->precus :=vprecus
Prc->premed :=vpremed
Prc->datcad :=vdatcad
Prc->estmin :=vestmin
Prc->resupr :=vresupr
Prc->estmax :=vestmax
Prc->conmed :=vconmed
Prc->sugped :=vsugped
Prc->temres :=vtemres
Prc->datcmp :=vdatcmp
Prc->precmp :=vprecmp
Prc->codfor :=vcodfor
Prc->ultent :=vultent
Prc->ende   :=vende
Prc->qtdatu :=vqtdatu
Prc->qtdat2 :=vqtdat2
Prc->qtdat3 :=vqtdat3
Prc->datmod :=vdatmod
RETURN

********************************************************************************
PROCEDURE RelPrc()
// Relat¢rio de Produtos do FC
********************************************************************************
// Declara vari†veis
PRIVATE mDados,vopcodpro,mopcodpro
// Atualiza a linha de status.
Sinal("RELAT‡RIO","PRODUTOS")
// In°cio da rotina
DO WHILE .T.
   Abrejan(2)
   SETCOLOR(vcr)
   @ 04,02 SAY PADC("OPÄÂES PARA EMISS«O DO RELAT‡RIO",76)
   SETCOLOR(vcn)
   // T°tulos
   //@ 08,10 SAY "Local...:"
   @ 10,10 SAY "Grupos..:"
   @ 13,10 SAY "Opá∆o...:"
   @ 14,10 SAY "Produtos:"
   // Inicializa vari†veis
   mDados:={}
   //vcodloc:=SPACE(03)
   vgrui:=vgruf:=SPACE(04)
   vopcod:=SPACE(01)
   mopcod:={{"1","C¢digo Produto "},{"2","C¢digo Auxiliar"}}
   vproi:=vprof:=SPACE(07)
   // Ediá∆o das vari†veis
   SETCOLOR(vcd)
   //@ 08,20 GET vcodloc PICTURE "999" VALID CodLoc(08,20)
   @ 10,20 GET vgrui  PICTURE "@R 99.99" VALID Codgruif(10,20,"vgrui")
   @ 11,20 GET vgruf  PICTURE "@R 99.99" VALID Codgruif(11,20,"vgruf")
   @ 13,20 GET vopcod PICTURE "9"        VALID Opcod(13,20)
   @ 14,20 GET vproi  PICTURE "9999999"  VALID Produif(14,20,"vproi",vopcod)
   @ 15,20 GET vprof  PICTURE "9999999"  VALID Produif(15,20,"vprof",vopcod)
   SETCOLOR(vcn)
   Le()
   IF LASTKEY()=K_ESC
      EXIT
   ENDIF
   //vnloc:=Tlo->nome
   vgrui:=IF(EMPTY(vgrui),"0000",vgrui)
   vgruf:=IF(EMPTY(vgruf),"9999",vgruf)
   vproi:=IF(EMPTY(vproi),"0000000",vproi)
   vprof:=IF(EMPTY(vprof),"9999999",vprof)
   // Confirmaá∆o
   IF !Confirme()
      LOOP
   ENDIF
   // Seleá∆o dos dados
   Abrejan(2)
   SETCOLOR(vcp)
   Aviso(18,"Selecionando Registros. Aguarde...")
   SETCOLOR(vcn)
   i:=1
   k:=0
   SELECT Prc
   IF vopcod="1"
      SET ORDER TO 1 // codpro
      GO TOP
      SET SOFTSEEK ON
      SEEK vproi
      SET SOFTSEEK OFF
      DO WHILE VAL(Prc->codpro) <= VAL(vprof) .AND. !EOF()
         IF VAL(Prc->codgru) >= VAL(vgrui) .AND. VAL(Prc->codgru) <= VAL(vgruf)
            AADD(mDados,{;
            Prc->codgru,;              // grupo
            Prc->codpro,;              // c¢digo do produto
            Prc->prod,;                // nome do produto
            Prc->unid,;                // unidade do produto
            Prc->estmin,;              // estoque m°nimo
            Prc->estmax,;              // estoque m†ximo
            Prc->conmed,;              // consumo mÇdio
            Prc->temres})              // tempo de ressuprimento
            @ 21,10 SAY SPACE(60)
            @ 21,10 SAY "Produto: "+TRANSFORM(Prc->codpro,"@R 9999999")
         ENDIF
         SKIP
      ENDDO
   ELSE
      SET ORDER TO 3 // codaux
      GO TOP
      SET SOFTSEEK ON
      SEEK vproi
      SET SOFTSEEK OFF
      DO WHILE VAL(Prc->codaux) <= VAL(vprof) .AND. !EOF()
         IF VAL(Prc->codgru) >= VAL(vgrui) .AND. VAL(Prc->codgru) <= VAL(vgruf)
            AADD(mDados,{;
            Prc->codgru,;              // grupo
            Prc->codaux,;             // c¢digo auxiliar
            Prc->prod,;                // nome do produto
            Prc->unid,;                // unidade do produto
            Prc->estmin,;              // estoque m°nimo
            Prc->estmax,;              // estoque m†ximo
            Prc->conmed,;              // consumo mÇdio
            Prc->temres})              // tempo de ressuprimento
            @ 21,10 SAY SPACE(60)
            @ 21,10 SAY "Produto: "+TRANSFORM(Prc->codaux,"@R 9999999")
         ENDIF
         SKIP
      ENDDO
   ENDIF
   @ 18,02 CLEAR TO 21,78
   // Apresentaá∆o em browse
   vtit:="RELAT‡RIO DE PRODUTOS"
   IF EMPTY(mDados)
      Mensagem("N∆o Existem Registros Para a Opá∆o Selecionada",5,1)
      LOOP
   ELSE
      ASORT(mDados,,,{ |x,y| x[1]+x[2] < y[1]+y[2] })
      @ 19,01 SAY REPLICATE("ƒ",78)
      @ 20,02 SAY PADC(vtit,76) COLOR(vcd)
      @ 21,02 SAY "Total de Itens: "+TRANSFORM(LEN(mDados),"9999")
      vcabe:={"Grupo","C¢digo","Produto","Unid","Est.M°nimo",;
      "Est.M†ximo","Cons.MÇdio","Tempo"}
      SayMatriz(mDados,02,01,18,78,vcabe,"Imprime","ImprRelPrc()")
   ENDIF
ENDDO
RETURN

********************************************************************************
PROCEDURE ImprRelPrc()
// Objetivo : Imprime Relat¢rio de Produtos
********************************************************************************
IF !Imprime2(vtit)
   RETURN
ENDIF
SET DEVICE TO PRINTER
SET PRINTER TO &vcimpres
DO WHILE vcop > 0
   pg:=0
   i:=1
   DO WHILE i <= LEN(mDados)
      //Cabe(vcnomeemp,vsist,vtit,"Localizaá∆o: "+vcodloc+"-"+vnloc,80,vcia15)
      Cabe(vcnomeemp,vsist,vtit,"",80,vcia15)
      //                         10        20        30        40        50        60        70        80        90       100       110       120       130
      //                 12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
      @ PROW()+1,01 SAY "GRUPO  PRODUTO                                            UN  EST.M÷NIMO  EST.MµXIMO  CONS.MêDIO      TEMPO"
      //                 XX.XX  XXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XX  XXX.XXX,XX  XXX.XXX,XX  XXX.XXX,XX    XX dias
      //
      @ PROW()+1,01 SAY REPLICATE("-",127)
      DO WHILE PROW() < 55 .AND. i <= LEN(mDados)
         IF Escprint(80)
            RETURN
         ENDIF
         @ PROW()+1,01 SAY TRANSFORM(mDados[i,1],"@R 99.99")
         @ PROW()  ,08 SAY TRANSFORM(mDados[i,2],"9999999")
         @ PROW()  ,17 SAY TRANSFORM(mDados[i,3],"@!")
         @ PROW()  ,59 SAY TRANSFORM(mDados[i,4],"!!")
         @ PROW()  ,63 SAY TRANSFORM(mDados[i,5],"@E 999,999.99")
         @ PROW()  ,75 SAY TRANSFORM(mDados[i,6],"@E 999,999.99")
         @ PROW()  ,87 SAY TRANSFORM(mDados[i,7],"@E 999,999.99")
         @ PROW()  ,101 SAY IF(mDados[i,8]>0,TRANSFORM(mDados[i,8],"99")+" dias","")
         i++
      ENDDO
   ENDDO
   @ PROW()+2,00 SAY vcid10+vcia10+PADC(" Fim do Relat¢rio ",80,"=")
   EJECT
   --vcop
ENDDO
SET PRINTER TO
SET DEVICE TO SCREEN
IF vcporta="2" // tela
   Imprtela(vcimpres,120)
ENDIF
RETURN

********************************************************************************
PROCEDURE Relprc2(ordem)
/* Objetivo  : emite os relat¢rios basicos dos produtos.
   ParÉmetros: ordem: 1 -> c¢digo
                      2 -> nome      */
********************************************************************************
Sinal("PRODUTOS","RELAT‡RIO")
// Abertura dos arquivos de dados
marqs:={{(dircad+"FC_PRODU.DBF"),"Prc","Produtos do FC",3}}
IF !AbreArqs(marqs,.F.)
   RETURN
ENDIF
//
IF ordem=1
   vcodi:=vcodf:=SPACE(7)
   SET ORDER TO 1
   // Pesquisa a faixa de codigos cujas registros devem ser impressos.
   Pesqint(7,"9999999","C¢digos de Produtos")
   bcond:={|vcod,vnome| vcod<=vcodf}
   vtit:="Ordem de Codigo"
ELSEIF ordem=2
   vcodi:=vcodf:=SPACE(30)
   SET ORDER TO 2
   // Pesquisa a faixa de codigos cujas registros devem ser impressos.
   Pesqint(30,"@!","Nomes de Produtos")
   bcond:={|vcod,vnome| vnome<=vcodf}
   vtit:="Ordem de Nome"
ENDIF
//
IF !Imprime2("Relat¢rio dos Produtos")
   CLOSE DATABASE
   RETURN
ENDIF
//
SET DEVICE TO PRINTER
SET PRINTER TO &vcimpres
DO WHILE vcop > 0
   pg:=0
   GO TOP
   SET SOFTSEEK ON
   SEEK vcodi
   SET SOFTSEEK OFF
   DO WHILE !EOF() .AND. EVAL(bcond,codpro,prod)
      Cabe(vcnomeemp,vsist,"RELAT‡RIO DE PRODUTOS",vtit,80,vcia20)
      //                            10        20        30         40        50        60        70
      //                  0123345678901234567890123456789012334567890123456789012345678901234567890123456789
      @ PROW()+1, 03 SAY "C‡DIGO"
      @ PROW(),   11 SAY "NOME DO PRODUTO"
      @ PROW(),   43 SAY "UNID"
      @ PROW(),   49 SAY "CF"
      @ PROW(),   55 SAY "IPI"
      @ PROW(),   60 SAY PADL(ALLTRIM(vctab1),10)
      @ PROW(),   72 SAY PADL(ALLTRIM(vctab2),10)
      @ PROW(),   84 SAY PADL(ALLTRIM(vctab3),10)
      @ PROW()+1, 00 SAY REPLICATE("-",135)
      DO WHILE PROW()<58 .AND. !EOF() .AND. EVAL(bcond,codpro,prod)
            IF Escprint(80)
               CLOSE DATABASE
               RETURN
            ENDIF
            @ PROW()+1,03 SAY Prc->codpro PICTURE "9999999"
            @ PROW(),  11 SAY Prc->prod
            @ PROW(),  43 SAY Prc->unid
            @ PROW(),  49 SAY Prc->cfi
            @ PROW(),  53 SAY Prc->taxaipi
            @ PROW(),  60 SAY IF(!EMPTY(vctab1),TRANSFORM(Prc->preco1,"@E 999,999.99"),"")
            @ PROW(),  72 SAY IF(!EMPTY(vctab2),TRANSFORM(Prc->preco2,"@E 999,999.99"),"")
            @ PROW(),  84 SAY IF(!EMPTY(vctab3),TRANSFORM(Prc->preco3,"@E 999,999.99"),"")
            SKIP
      ENDDO
      ?? vcid10
   ENDDO
   @ PROW()+2,0 SAY vcid10+vcia10+PADC(" Fim do Relat¢rio ",80,"=")
   EJECT
   --vcop
ENDDO
//Descarga()
SET PRINTER TO
SET DEVICE TO SCREEN
IF vcporta="2" // tela
   Imprtela(vcimpres,120)
ENDIF
CLOSE DATABASE
RETURN

**************************************************************************
PROCEDURE Saldo(pcodpro,pcodloc)
// Pesquisa Saldo em Estoque.
*****************************************************
LOCAL vret:=0
LOCAL vareatrab:=SELECT()
SELECT Sdo
GO TOP
SEEK pcodpro+pcodloc
IF FOUND()
   vret:=Sdo->saldo
ENDIF
SELECT(vareatrab)
RETURN(vret)

**************************************************************************
PROCEDURE Saldg(pcodpro,pcodloc)
// Pesquisa Saldo em Estoque. (Gerencial)
*****************************************************
LOCAL vret:=0
LOCAL vareatrab:=SELECT()
SELECT Sdg
GO TOP
SEEK pcodpro+pcodloc
IF FOUND()
   vret:=Sdg->saldo
ENDIF
SELECT(vareatrab)
RETURN(vret)

**************************************************************************
FUNCTION Chapa(pcodpro)
// Verifica se o produto Ç chapa.
// Obs.: Retorna verdadeiro se for.
*****************************************************
IF VAL(LEFT(pcodpro,2)) < 10 .AND. RIGHT(pcodpro,1)=="0"
   RETURN(.T.)
ENDIF
RETURN(.F.)

**************************************************************************
FUNCTION ExisteDim(pcodpro,palt,plar)
// Verifica se existe as dimens‰es cadastradas no VM_ITSTQ.
// Obs: Retorna verdadeiro se existir a dimens∆o.
*****************************************************
LOCAL vret:=.F.
LOCAL vareatrab:=SELECT()
SELECT Sti
GO TOP
SEEK pcodpro+STRZERO(palt)+STRZERO(plar)
IF FOUND()
   vret:=.T.
ELSE
   GO TOP
   SEEK pcodpro+STRZERO(plar)+STRZERO(palt)
   IF FOUND()
      vret:=.T.
   ENDIF
ENDIF
SELECT(vareatrab)
RETURN(vret)

**************************************************************************
FUNCTION BoxPadrao(pcodpro,palt,plar)
// Verifica se Ç Box Padr∆o.
// Obs: Retorna verdadeiro se for.
*****************************************************
LOCAL mLargura:={350,400,450,500,550,600,650,700,750,800,850}
LOCAL mAltura:={1835,1800}
IF LEFT(pcodpro,2)#"43" // N∆o Ç box
   RETURN(.F.)
ENDIF
IF ASCAN(mLargura,plar)=0 // N∆o achou
   IF ASCAN(mLargura,palt)=0 // N∆o achou
      RETURN(.F.)
   ENDIF
ENDIF
IF ASCAN(mAltura,palt)=0 // N∆o achou
   IF ASCAN(mAltura,plar)=0 // N∆o achou
      RETURN(.F.)
   ENDIF
ENDIF
RETURN(.T.)

**************************************************************************
FUNCTION Modulado(pcodpro,palt,plar)
// Verifica se Ç Modulado.
// Obs: Retorna verdadeiro se for.
*****************************************************
// Verifica somente se o c¢digo Ç de modulado
IF palt=NIL
   IF LEFT(pcodpro,2)="41" // ê c¢digo de modulado
      RETURN(.T.)
   ENDIF
ENDIF
// Verifica, alÇm do c¢digo, a dimens∆o
IF LEFT(pcodpro,2)#"41" // N∆o Ç modulado
   RETURN(.F.)
ENDIF
IF palt=100 .AND. plar=200
   RETURN(.T.)
ELSEIF palt=100 .AND. plar=300
   RETURN(.T.)
ELSEIF palt=100 .AND. plar=400
   RETURN(.T.)
ELSEIF palt=100 .AND. plar=500
   RETURN(.T.)
ELSEIF palt=100 .AND. plar=600
   RETURN(.T.)
ELSEIF palt=200 .AND. plar=200
   RETURN(.T.)
ELSEIF palt=200 .AND. plar=300
   RETURN(.T.)
ELSEIF palt=200 .AND. plar=400
   RETURN(.T.)
ELSEIF palt=200 .AND. plar=500
   RETURN(.T.)
ELSEIF palt=200 .AND. plar=600
   RETURN(.T.)
ELSEIF palt=200 .AND. plar=1200
   RETURN(.T.)
ELSEIF palt=300 .AND. plar=300
   RETURN(.T.)
ELSEIF palt=300 .AND. plar=400
   RETURN(.T.)
ELSEIF palt=300 .AND. plar=500
   RETURN(.T.)
ELSEIF palt=300 .AND. plar=600
   RETURN(.T.)
ELSEIF palt=300 .AND. plar=800
   RETURN(.T.)
ELSEIF palt=300 .AND. plar=1000
   RETURN(.T.)
ELSEIF palt=300 .AND. plar=1200
   RETURN(.T.)
ELSEIF palt=400 .AND. plar=400
   RETURN(.T.)
ELSEIF palt=400 .AND. plar=500
   RETURN(.T.)
ELSEIF palt=400 .AND. plar=600
   RETURN(.T.)
ELSEIF palt=500 .AND. plar=500
   RETURN(.T.)
ELSEIF palt=500 .AND. plar=600
   RETURN(.T.)
ELSEIF palt=600 .AND. plar=600
   RETURN(.T.)
ELSEIF palt=400 .AND. plar=300
   RETURN(.T.)
ENDIF
RETURN(.F.)

*******************************************************************************
PROCEDURE DimModula()
**********************
LOCAL mModula:={;
{"    10x20       ","4110401",100,200},;
{"    10x30       ","4110403",100,300},;
{"    10x40       ","4110405",100,400},;
{"    10x50       ","4110407",100,500},;
{"    10x60       ","4110409",100,600},;
{"    20x20       ","4110412",200,200},;
{"    20x30       ","4110414",200,300},;
{"    20x40       ","4110416",200,400},;
{"    20x50       ","4110418",200,500},;
{"    20x60       ","4110421",200,600},;
{"    20x120      ","4110427",200,1200},;
{"    30x30       ","4110429",300,300},;
{"    30x40       ","4110435",300,400},;
{"    30x50       ","4110437",300,500},;
{"    30x60       ","4110439",300,600},;
{"    30x80       ","4110442",300,800},;
{"    30x100      ","4110448",300,1000},;
{"    30x120      ","4110451",300,1200},;
{"    40x40       ","4110453",400,400},;
{"    40x50       ","4110455",400,500},;
{"    40x60       ","4110457",400,600},;
{"    50x50       ","4110461",500,500},;
{"    50x60       ","4110463",500,600},;
{"    60x60       ","4110465",600,600},;
{"   RAIO 20      ","4110471",200,200},;
{"   RAIO 30      ","4110473",300,300},;
{"   RAIO 40      ","4110475",400,400},;
{" TRAP 20x30x20  ","4110481",300,300},;
{" TRAP 30x30x20  ","4110483",300,300},;
{" TRAP 20x30x20  ","4110484",300,300},;
{" TRAP 30x40x30  ","4110485",400,300},;
{" TRAP 40x40x30  ","4110487",400,400},;
{"ARCO 30x30x20x20","4110491",300,300},;
{"ARCO 40x40x20x20","4110493",400,400},;
{"ARCO 40x40x30x30","4110495",400,400}}
LOCAL vtelant:=SAVESCREEN(01,00,24,79)
LOCAL i:=1
PRIVATE vli2:=12,li2:=1,vt2:=0,lf2:=9,tampa2:=CHR(179)
PRIVATE menulin:=11,menucol:=55
//
IF LEN(mModula)<lf2
   lf2:=LEN(mModula)
ENDIF
Caixa(menulin,menucol,vli2+lf2+1,74,frame[1])
// Apresenta a linha de orientaá∆o ao usu†rio.
SETCOLOR(vcr)
@ menulin+1,menucol+1 SAY PADC("DIMENSÂES",18)
@ 23,00 SAY PADC("Enter=Seleciona",80)
MostraModula(mModula,li2,lf2,vcn)
DO WHILE .T.
   SETCOLOR(vcp)
   @ vli2+li2,menucol SAY CHR(177)
   // Mostra o item selecionado.
   MostraModula(mModula,li2,li2,vca)
   // Aguarda o pressionamento de uma tecla de controle.
   tk:=INKEY(0)
   IF tk=K_ENTER
      vcodvm:=mModula[li2+vt2,2]
      valt:=mModula[li2+vt2,3]
      vlar:=mModula[li2+vt2,4]
      EXIT
   ELSEIF tk=K_UP
      // Seta para Cima: desloca para o item anterior.
      SETCOLOR(vcn)
      @ vli2+li2,menucol SAY tampa2
      // Mostra o item.
      MostraModula(mModula,li2,li2,vcn)
      // Decrementa a linha dos itens.
      IF li2>1
         --li2
      ELSE
         // Realiza o rolamento da tela.
         IF vt2>0
            --vt2
            SCROLL(vli2+1,menucol+1,vli2+lf2,73,-1)
            // Mostra o item.
            MostraModula(mModula,li2,li2,vcn)
         ENDIF
      ENDIF
   ELSEIF tk=K_DOWN
      // Seta para Baixo: desloca para o item seguinte.
      SETCOLOR(vcn)
      @ vli2+li2,menucol SAY tampa2
      // Mostra o item.
      MostraModula(mModula,li2,li2,vcn)
      // Incrementa a linha dos itens.
      IF li2<lf2
         ++li2
      ELSE
         // Realiza o rolamento da tela.
         IF vt2<(LEN(mModula)-lf2) .AND. !EMPTY(mModula[li2+vt2])
            ++vt2
            SCROLL(vli2+1,menucol+1,vli2+lf2,73,1)
            // Mostra o item.
            MostraModula(mModula,li2,li2,vcn)
         ENDIF
      ENDIF
   ENDIF
ENDDO
RESTSCREEN(01,00,24,79,vtelant)
RETURN

********************************************************************************
PROCEDURE MostraModula(mat,ni,nf,vcor)
/* Apresenta os itens de credenciamento.
   mat:  matriz de dados
   ni:   n£mero do item inicial.
   nf:   n£mero do item final.
   vcor: padr∆o de cor para apresentaá∆o dos itens.*/
******************************************************
LOCAL i
SETCOLOR(vcor)
FOR i=ni TO IIF(nf<22-vli2,nf,21-vli2)
    @ vli2+i,menucol+1 SAY mat[i+vt2,1]
NEXT
SETCOLOR(vcn)
RETURN

****************************************************************************
PROCEDURE MenuTampo()
// Seleciona os tipos de tampos
********************************
LOCAL telaMenu1:=SAVESCREEN(01,00,24,79)
LOCAL mForma :={"RETO","REDONDO","OVAL","MEDITERR∂NEO","ONDULADO","TOPµZIO","SERENATA"}
LOCAL vForma :="00"
LOCAL vArte  :="0"
LOCAL vBizote:="0"
LOCAL vLapid :="00"
LOCAL vCanto :="00"
LOCAL i      :=1
PRIVATE opTampo2:=opTampo3:=opTampo4:=opTampo5:=1
DO WHILE .T.
   SETCOLOR(vcf)
   Caixa(09,03,18,20,frame[6])
   @ 10,04 SAY PADC("Formato",16)
   SETCOLOR(vcn)
   i:=1
   DO WHILE i <= LEN(mForma)
      @ i+10,04 PROMPT " "+mForma[i]+SPACE(15-LEN(mForma[i]))
      i++
   ENDDO
   MENU TO opTampo1
   IF EMPTY(opTampo1).OR.LASTKEY()==K_ESC
      RESTSCREEN(01,00,24,79,telaMenu1)
      RETURN
   ENDIF
   vForma:=STRZERO(opTampo1,2)
   varte :=Arte()
   IF LASTKEY()==K_ESC
      RESTSCREEN(01,00,24,79,telaMenu1)
      LOOP
   ENDIF
   IF opTampo1=1
      vBizote:=Bizote()
      IF LASTKEY()==K_ESC
         RESTSCREEN(01,00,24,79,telaMenu1)
         LOOP
      ENDIF
      IF opTampo3=1
         vLapid:=Lapidacao()
         IF LASTKEY()==K_ESC
            RESTSCREEN(01,00,24,79,telaMenu1)
            LOOP
         ENDIF
         vCanto:=TipoCanto()
         IF LASTKEY()==K_ESC
            RESTSCREEN(01,00,24,79,telaMenu1)
            LOOP
         ENDIF
      ELSE
         vCanto:=TipoCanto()
         IF LASTKEY()==K_ESC
            RESTSCREEN(01,00,24,79,telaMenu1)
            LOOP
         ENDIF
      ENDIF
   ELSEIF opTampo1=2 .OR. opTampo1=3
      vigual:=.F.
      IF opTampo1=2
         vigual:=.T.
      ENDIF
      vBizote:=Bizote()
      IF LASTKEY()==K_ESC
         RESTSCREEN(01,00,24,79,telaMenu1)
         LOOP
      ENDIF
      IF opTampo3=1
         vLapid:=Lapidacao()
         IF LASTKEY()==K_ESC
            RESTSCREEN(01,00,24,79,telaMenu1)
            LOOP
         ENDIF
      ENDIF
   ENDIF
   EXIT
ENDDO
RESTSCREEN(01,00,24,79,telaMenu1)
RETURN vForma+vArte+vBizote+vLapid+vCanto

*****************************************************************************
PROCEDURE Arte()
******************
LOCAL telaMenu2:=SAVESCREEN(01,00,24,79)
DO WHILE .T.
   SETCOLOR(vcf)
   Caixa(09,22,13,31,frame[6])
   @ 10,23 SAY PADC("Com Arte",8)
   SETCOLOR(vcn)
   @ 11,23 PROMPT " 1-N«O  "
   @ 12,23 PROMPT " 2-SIM  "
   MENU TO opTampo2
   IF EMPTY(opTampo2).OR.LASTKEY()==K_ESC
      RESTSCREEN(01,00,24,79,telaMenu2)
      RETURN
   ENDIF
   EXIT
ENDDO
RETURN STR(opTampo2-1,1)
*****************************************************************************
PROCEDURE Bizote()
******************
LOCAL telaMenu3:=SAVESCREEN(01,00,24,79)
DO WHILE .T.
   SETCOLOR(vcf)
   Caixa(14,22,18,31,frame[6])
   @ 15,23 SAY PADC("Bizotado",8)
   SETCOLOR(vcn)
   @ 16,23 PROMPT " 1-N«O  "
   @ 17,23 PROMPT " 2-SIM  "
   MENU TO opTampo3
   IF EMPTY(opTampo3).OR.LASTKEY()==K_ESC
      RESTSCREEN(01,00,24,79,telaMenu3)
      RETURN "0"
   ENDIF
   EXIT
ENDDO
RETURN STR(opTampo3-1,1)
*****************************************************************************
PROCEDURE Lapidacao()
********************
LOCAL i:=1
LOCAL telaMenu4:=SAVESCREEN(01,00,24,79)
LOCAL mLapid[12,2]
mLapid[01,1]:="COMUM"
mLapid[01,2]:="Lapidaá∆o Comum em Borda Reta ou Curva"
mLapid[02,1]:="OG-FORMA"
mLapid[02,2]:="Lapidaá∆o Produzida em Borda Curva"
mLapid[03,1]:="2G-FORMA"
mLapid[03,2]:="Lapidaá∆o Produzida em Borda Curva"
mLapid[04,1]:="3G-FORMA"
mLapid[04,2]:="Lapidaá∆o Produzida em Borda Curva"
mLapid[05,1]:="BOLEADO-FORMA"
mLapid[05,2]:="Lapidaá∆o Produzida em Borda Curva"
mLapid[06,1]:="B.µGUIA-FORMA"
mLapid[06,2]:="Lapidaá∆o Produzida em Borda Curva"
mLapid[07,1]:="OG-RETO"
mLapid[07,2]:="Lapidaá∆o Produzida em Borda Reta"
mLapid[08,1]:="2G-RETO"
mLapid[08,2]:="Lapidaá∆o Produzida em Borda Reta"
mLapid[09,1]:="3G-RETO"
mLapid[09,2]:="Lapidaá∆o Produzida em Borda Reta"
mLapid[10,1]:="BOLEADO-RETO"
mLapid[10,2]:="Lapidaá∆o Produzida em Borda Reta"
mLapid[11,1]:="B.µGUIA-RETO"
mLapid[11,2]:="Lapidaá∆o Produzida em Borda Reta"
mLapid[12,1]:="CRAQUELADO"
mLapid[12,2]:="Lapidaá∆o Produzida em Borda Curva ou Reta"
DO WHILE .T.
   SETCOLOR(vcf)
   Caixa(09,33,11+LEN(mLapid),48,frame[6])
   @ 10,34 SAY PADC("Lapidaá∆o",10)
   SETCOLOR(vcn)
   SET MESSAGE TO 24
   i:=1
   DO WHILE i <= LEN(mLapid)
      @ i+10,34 PROMPT " "+mLapid[i,1]+SPACE(13-LEN(mLapid[i,1])) MESSAGE mLapid[i,2]
      i++
   ENDDO
   MENU TO opTampo4
   IF LASTKEY()==K_ESC
      RESTSCREEN(01,00,24,79,telaMenu4)
      RETURN "00"
   ENDIF
   IF EMPTY(opTampo4)
      LOOP
   ENDIF
   EXIT
ENDDO
RETURN STRZERO(opTampo4,2)

******************************************************************************
FUNCTION TipoCanto()
********************
LOCAL telaMenu5:=SAVESCREEN(01,00,24,79)
DO WHILE .T.
   SETCOLOR(vcf)
   Caixa(09,50,19,77,frame[6])
   @ 10,51 SAY PADC("Tipo de Canto",24)
   SETCOLOR(vcn)
   @ 11,51 PROMPT " 1-NORMAL    "
   @ 12,51 PROMPT " 2-MOEDA     "
   @ 13,51 PROMPT " 3-MOED«O    "
   @ 14,51 PROMPT " 4-GARRAFA   "
   @ 15,51 PROMPT " 5-CHANFRADO "
   @ 16,51 PROMPT " 6-ARABESCO  "
   @ 17,51 PROMPT " 7-HêLICE    "
   @ 18,51 PROMPT " 8-TARTARUGA "
   @ 11,64 PROMPT " 9-MAIS      "
   @ 12,64 PROMPT " A-EME       "
   @ 13,64 PROMPT " B-CAVADO    "
   @ 14,64 PROMPT " C-CHIN“S    "
   @ 15,64 PROMPT " D-SINUOSO   "
   @ 16,64 PROMPT " E-MEIA-LUA  "
   @ 17,64 PROMPT " F-VERONA    "
   @ 18,64 PROMPT " G-INCLINADO "
   MENU TO opTampo5
   IF opTampo5=6 .AND. (opTampo4>1 .AND. opTampo4<13) // lapidaá‰es especiais
      Mensagem("Canto Incompat°vel com o tipo de Lapidaá∆o!",3,1)
      LOOP
   ENDIF
   IF opTampo5>5 .AND. (opTampo4>6 .AND. opTampo4<12) // exclui lapidaá‰es retas
      Mensagem("Canto Incompat°vel com o tipo de Lapidaá∆o!",3,1)
      LOOP
   ENDIF
   IF EMPTY(opTampo5).OR.LASTKEY()==K_ESC
      RESTSCREEN(01,00,24,79,telaMenu5)
      RETURN "00"
   ENDIF
   EXIT
ENDDO
RETURN STRZERO(opTampo5,2)

*****************************************************************************
PROCEDURE SayTampo(pprod,pcodaux,plin,pcol)
// Tela auxiliar para mostrar o nome completo do tampo.
*******************************************************
LOCAL vtela:=SAVESCREEN(01,00,24,79)
LOCAL vcor:=SETCOLOR()
LOCAL vcompr:=LEN(ALLTRIM(pprod))
SETCOLOR(vcr)
@ plin,pcol SAY ALLTRIM(SUBSTR(ALLTRIM(pprod),1,vcompr-8))+" "+NomeTampo(pcodaux)
SETCOLOR(vcor)
INKEY(0)
RESTSCREEN(01,00,24,79,vtela)
RETURN

*****************************************************************************
PROCEDURE NomeTampo(pcodaux)
// Retorna a descriá∆o complementar do tampo a partir do c¢digo auxiliar.
*************************************************************************
LOCAL pcod1,pcod2,pcod3,pcod4,pcod5
LOCAL mforma :={"","REDONDO","OVAL","MEDITERR∂NEO","ONDULADO","TOPµZIO","SERENATA"}
LOCAL mlapid :={"","OG","2G","3G","CRAQUELADO","BOLEADO","B.µGUIA"}
LOCAL mcanto :={"","CANTO MOEDA","CANTO MOED«O","CANTO GARRAFA","CHANFRADO",;
                "ARABESCO","HêLICE","TARTARUGA","CANTO MAIS","CANTO EME",;
                "CANTO CAVADO","CANTO CHIN“S","CANTO SINUOSO","CANTO MEIA-LUA",;
                "CANTO VERONA","CANTO INCLINADO"}

// Formato do c¢digo auxiliar XX.Y.Z.WW.KK

pcod1:=VAL(SUBSTR(pcodaux,1,2))   // formato
pcod2:=VAL(SUBSTR(pcodaux,3,1))   // arte
pcod3:=VAL(SUBSTR(pcodaux,4,1))   // bizote
pcod4:=VAL(SUBSTR(pcodaux,5,2))   // lapidaá∆o
pcod5:=VAL(SUBSTR(pcodaux,7,2))   // canto
//
RETURN IIF(pcod1>0,mforma[pcod1]+" ","")+IIF(pcod2>0,"C/ARTE ","")+;
       IIF(pcod3>0,"BIZOTADO ","")+IIF(pcod4>0,mlapid[pcod4]+" ","")+;
       IIF(pcod5>0,mcanto[pcod5],"")

*****************************************************************************
PROCEDURE PrecoTampo(pcodaux,pcodvidro,vtab,palt,plar,ppre)
// Calcula o preáo unit†rio do tampo: pcodaux   = c¢digo auxiliar do tampo
//                                    pcodvidro = c¢digo do tampo
//                                    vtab      = tabela
//                                    palt      = altura do tampo
//                                    plar      = largura do tampo
//                                    ppre      = preáo por m2 do vidro
*****************************************************************************
LOCAL valorForma:=0
LOCAL valorArte:=0
LOCAL valorBizote:=0
LOCAL valorLapid:=0
LOCAL valorCanto:=0
LOCAL valorTampo:=0
LOCAL x2,x3,x4,x5,x6,y,vperim,varea
//
x1:=VAL(SUBSTR(pcodaux,1,2))   // formato
x2:=VAL(SUBSTR(pcodaux,3,1))   // arte
x3:=VAL(SUBSTR(pcodaux,4,1))   // bizote
x4:=VAL(SUBSTR(pcodaux,5,2))   // lapidaá∆o
x5:=VAL(SUBSTR(pcodaux,7,2))   // canto
//
IF SUBSTR(pcodvidro,4,2)=="08"       // tampo de 8mm
   y:=1
ELSEIF SUBSTR(pcodvidro,4,2)=="10"   // tampo de 10 mm
   y:=2
ELSEIF SUBSTR(pcodvidro,4,2)=="12"   // tampo de 12 mm
   y:=3
ELSEIF SUBSTR(pcodvidro,4,2)=="15"   // tampo de 15 mm
   y:=4
ELSEIF SUBSTR(pcodvidro,4,2)=="19"   // tampo de 19 mm
   y:=5
ENDIF
//
vperim:=(2*palt+2*plar)/1000            // per°metro do tampo reto
vperimRed:=(3.1416*palt)/1000           // per°metro do tampo redondo
varea :=Arred(pcodvidro,IIF(x1=2,palt+100,palt),IIF(x1=2,plar+100,plar))    // †rea do tampo reto
valorTampo:=ppre*varea                 // valor do tampo sem serviáos
//
IF x1 > 0         // formato
   IF x1 < 4      // reto, redondo, oval
      valorForma:=0
   ELSEIF x1 > 3  // mediterraneo, ondulado, topazio, serenata
      valorForma:=0.3*valorTampo
   ENDIF
ELSE
   valorForma:=0
ENDIF
//
IF x2 > 0    // arte
   valorArte:=0.1*valorTampo
ELSE
   valorArte:=0
ENDIF
//
IF x3 > 0      // bizote
   IF x1=1 .OR. x1=3    // reto e oval
      IF y < 4      // 8, 10 e 12mm
         valorBizote:=Procura("Pro",1,"9500220","FIELDGET(vtab)")*;
         NovoPreco(vcodcli+"9500220")*vperim
      ELSEIF y>3 .AND. y < 6  // 15 e 19mm
         valorBizote:=Procura("Pro",1,"9500230","FIELDGET(vtab)")*;
         NovoPreco(vcodcli+"9500230")*vperim
      ENDIF
   ELSEIF x1 = 2   // redondo
      IF y < 4      // 8,10 e 12mm
         valorBizote:=Procura("Pro",1,"9500320","FIELDGET(vtab)")*;
         NovoPreco(vcodcli+"9500320")*IIF(x1=2,vperimred,vperim)
      ELSEIF y>3 .AND. y<6  // 15 e 19mm
         valorBizote:=Procura("Pro",1,"9500330","FIELDGET(vtab)")*;
         NovoPreco(vcodcli+"9500330")*IIF(x1=2,vperimRed,vperim)
      ENDIF
   ENDIF
ELSE
   valorBizote:=0
ENDIF
//valorTampo:=valorTampo+valorBizote
//
IF x4 > 0      // lapidaá∆o
   IF x4=1     // comum
      valorLapid:=Procura("Pro",1,"9511010","FIELDGET(vtab)")*;
      NovoPreco(vcodcli+"9511011")*vperim
   ELSEIF (x4>1.AND.x4<7).OR.x4=12   // og,2g,3g,boleado e b.†guia - forma e craquelados
      IF y=3       // 12mm
         valorLapid:=Procura("Pro",1,"9512011","FIELDGET(vtab)")*;
         NovoPreco(vcodcli+"9512011")*vperim
      ELSEIF y=4   // 15mm
         valorLapid:=Procura("Pro",1,"9513011","FIELDGET(vtab)")*;
         NovoPreco(vcodcli+"9513011")*vperim
      ELSEIF y=5   // 19mm
         valorLapid:=Procura("Pro",1,"9514011","FIELDGET(vtab)")*;
         NovoPreco(vcodcli+"9514011")*vperim
      ENDIF
   ELSEIF x4 > 6 .and. x4 < 12  // og,2g,3g,boleado e b.†guia - retos
      IF y=3       // 12mm
         valorLapid:=Procura("Pro",1,"9512012","FIELDGET(vtab)")*;
         NovoPreco(vcodcli+"9512012")*vperim
      ELSEIF y=4   // 15mm
         valorLapid:=Procura("Pro",1,"9513012","FIELDGET(vtab)")*;
         NovoPreco(vcodcli+"9513012")*vperim
      ELSEIF y=5   // 19mm
         valorLapid:=Procura("Pro",1,"9513062","FIELDGET(vtab)")*;
         NovoPreco(vcodcli+"9513062")*vperim
      ENDIF
   ENDIF
ELSE
   valorLapid:=0
ENDIF
//
IF x5 > 0     // canto
   IF x5 < 4  // normal,moeda e moed∆o
      valorCanto:=0
   ELSEIF x5 > 3
      valorCanto:=0.2*valorTampo
   ENDIF
ELSE
   valorCanto:=0
ENDIF
//
RETURN (valorTampo+valorForma+valorArte+valorBizote+valorLapid+valorCanto)/varea

******************************************************************************
FUNCTION NovoPreco(pclipro)
// Pesquisa no arquivo de desconto o produto cadastrado
*******************************************************
LOCAL desconto:=1
LOCAL area:=SELECT()
LOCAL vord:=INDEXORD()
SELECT Desc
GO TOP
SEEK pclipro    // codcli+codpro
IF FOUND()
   desconto:=(100-Desc->itdesc)/100
ENDIF
DBSETORDER(vord)
SELECT (area)
RETURN desconto

**************************************************************************
PROCEDURE EstoqueVM(pcodpro)
// Pesquisa Estoque do VM.
*****************************************************
LOCAL vtelant:=SAVESCREEN(01,00,24,79) // Salva a tela anterior
LOCAL vareant:=SELECT() // Salva a area anterior
//
PRIVATE mStoq:={}
PRIVATE vitprod,vquant,vquant2,vtransito,varea1,varea2,varea3,vareatotal
PRIVATE vite,vqtd:=0,vqtd2:=0,vtran:=0,vcheg:=CTOD(SPACE(8)),valt:=0,vlar:=0,vunid,vkt,n,k,vmodo,j
PRIVATE vli,li,vt,tampa:=CHR(186),pv:=.T.
vli:=8
vmodo:=2
//
DO WHILE .T.
   IF Abrearq((dirvm+"VM_ESTOQ.DBF"),"Stq",.F.,10)
      SET INDEX TO (dirvm+"VM_ESTO1"),(dirvm+"VM_ESTO2")
   ELSE
      Mensagem("O Arquivo de Estoque N∆o Est† Dispon°vel!",3,1)
      EXIT
   ENDIF
   IF Abrearq((dirvm+"VM_ITSTQ.DBF"),"Sti",.F.,10)
      SET INDEX TO (dirvm+"VM_ITST1")
   ELSE
      Mensagem("O Arquivo de Itens de Estoque Est† Dispon°vel!",3,1)
      EXIT
   ENDIF
   IF Chapa(pcodpro)
      SELECT Stq
      GO TOP
      SEEK pcodpro
      IF !FOUND()
         EXIT
      ENDIF
      vquant   :=Stq->quant
      vquant2  :=Stq->quant2
      vtransito:=Stq->transito
      vunid    :=Stq->unid
      vli:=8;li:=1;vt:=0
      @ 24,00 CLEAR
      Abrejan(2)
      SETCOLOR(vcp)
      Aviso(24,"Aguarde....")
      SETCOLOR(vcn)
      SELECT Sti
      GO TOP
      SEEK pcodpro
      IF FOUND()
         DO WHILE Sti->codpro==pcodpro .AND. !EOF()
            AADD(mStoq,{Sti->prod,Sti->quant,Sti->quant2,Sti->transito,Sti->datacheg,Sti->alt,Sti->lar})
            SKIP
         ENDDO
      ENDIF
      AADD(mStoq,{SPACE(45),0,0,0,CTOD(SPACE(8)),0,0})
      @ 24,00 CLEAR
      varea1:=varea2:=varea3:=vareatotal:=0
      j:=1
      DO WHILE j<=LEN(mStoq)
         varea1+=(mStoq[j,2]*Arred(pcodpro,mStoq[j,6],mStoq[j,7]))
         varea2+=(mStoq[j,3]*Arred(pcodpro,mStoq[j,6],mStoq[j,7]))
         varea3+=(mStoq[j,4]*Arred(pcodpro,mStoq[j,6],mStoq[j,7]))
         vareatotal:=varea1+varea2+varea3
         j++
      ENDDO
      TelaStq()
      SayItStq(1,LEN(mStoq),vcn)
      EditaItStq()
   ELSEIF Modulado(pcodpro)
      SELECT Stq
      GO TOP
      SEEK LEFT(pcodpro,5)
      IF !FOUND()
         EXIT
      ENDIF
      vli:=8;li:=1;vt:=0
      @ 24,00 CLEAR
      Abrejan(2)
      SETCOLOR(vcp)
      Aviso(24,"Aguarde....")
      SETCOLOR(vcn)
      vunid:=Stq->unid
      DO WHILE LEFT(Stq->codpro,5)==LEFT(pcodpro,5) .AND. !EOF()
         AADD(mStoq,{Stq->prod,Stq->quant,Stq->quant2,Stq->transito,CTOD(SPACE(8)),Stq->alt,Stq->lar})
         SKIP
      ENDDO
      AADD(mStoq,{SPACE(45),0,0,0,CTOD(SPACE(8)),0,0})
      @ 24,00 CLEAR
      varea1:=varea2:=varea3:=vareatotal:=0
      vquant   :=0
      vquant2  :=0
      vtransito:=0
      j:=1
      DO WHILE j<=LEN(mStoq)
         varea1+=(mStoq[j,2]*Arred(pcodpro,mStoq[j,6],mStoq[j,7]))
         varea2+=(mStoq[j,3]*Arred(pcodpro,mStoq[j,6],mStoq[j,7]))
         varea3+=(mStoq[j,4]*Arred(pcodpro,mStoq[j,6],mStoq[j,7]))
         vareatotal:=varea1+varea2+varea3
         vquant+=mStoq[j,2]
         vquant2+=mStoq[j,3]
         vtransito+=mStoq[j,4]
         j++
      ENDDO
      TelaStq()
      SayItStq(1,LEN(mStoq),vcn)
      EditaItStq()
   ELSEIF LEFT(pcodpro,2)=="43" // Box
      SELECT Stq
      GO TOP
      SEEK LEFT(pcodpro,6)
      IF !FOUND()
         EXIT
      ENDIF
      vquant   :=Stq->quant
      vquant2  :=Stq->quant2
      vtransito:=Stq->transito
      vunid    :=Stq->unid
      SKIP
      vquant   +=Stq->quant
      vquant2  +=Stq->quant2
      vtransito+=Stq->transito
      vli:=8;li:=1;vt:=0
      @ 24,00 CLEAR
      Abrejan(2)
      SETCOLOR(vcp)
      Aviso(24,"Aguarde....")
      SETCOLOR(vcn)
      SELECT Sti
      GO TOP
      SEEK LEFT(pcodpro,6)
      IF FOUND()
         DO WHILE LEFT(Sti->codpro,6)==LEFT(pcodpro,6) .AND. !EOF()
            AADD(mStoq,{Sti->prod,Sti->quant,Sti->quant2,Sti->transito,CTOD(SPACE(8)),Sti->alt,Sti->lar})
            SKIP
         ENDDO
      ENDIF
      AADD(mStoq,{SPACE(45),0,0,0,CTOD(SPACE(8)),0,0})
      @ 24,00 CLEAR
      varea1:=varea2:=varea3:=vareatotal:=0
      j:=1
      DO WHILE j<=LEN(mStoq)
         varea1+=(mStoq[j,2]*Arred(pcodpro,mStoq[j,6],mStoq[j,7]))
         varea2+=(mStoq[j,3]*Arred(pcodpro,mStoq[j,6],mStoq[j,7]))
         varea3+=(mStoq[j,4]*Arred(pcodpro,mStoq[j,6],mStoq[j,7]))
         vareatotal:=varea1+varea2+varea3
         j++
      ENDDO
      TelaStq()
      SayItStq(1,LEN(mStoq),vcn)
      EditaItStq()
   ELSE
      @ 24,00 CLEAR
      Aviso(24,"Produto Base Sem Itens")
   ENDIF
   EXIT
ENDDO
//
CLOSE Stq
CLOSE Sti
RESTSCREEN(01,00,24,79,vtelant) // Restaura a tela anterior
SELECT(vareant) // Retorna a area anterior
RETURN

********************************************************************************
STATIC PROCEDURE TelaStq()
*******************
SETCOLOR(vcn)
@ 03,03 SAY "Produto Base:"
@ 04,03 SAY "Quantidade em Estoque-1:"
@ 05,03 SAY "Quantidade em Estoque-2:"
@ 06,03 SAY "Quantidade em TrÉnsito:"
IF VAL(LEFT(vcodpro,2)) < 70
   @ 04,40 SAY "µrea em Estoque-1:"
   @ 05,40 SAY "µrea em Estoque-2:"
   @ 06,40 SAY "µrea em TrÉnsito:"
   @ 07,40 SAY "µrea Total do Produto:"
ENDIF
/*
        10        20        30        40        50        60        70
  345678901234567890123456789012345678901234567890123456789012345678901234567
  Produto Base:XXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  Quantidade em Estoque-1:XXXX         µrea em Estoque-1:
  Quantidade em Estoque-2:XXXX         µrea em Estoque-2:
  Quantidade em TrÉnsito:XXXX          µrea em TrÉnsito:
                                       µrea Total do Produto:XX.XXX,XX m˝
*/
SETCOLOR(vcd)
@ 03,16 SAY vcodpro   PICTURE "9999999"
@ 03,24 SAY vprod     PICTURE "@!"
Sayd(04,27,vquant,"@E 99,999",6)
Sayd(05,27,vquant2,"@E 99,999",6)
Sayd(06,26,vtransito,"@E 99,999",6)
IF VAL(LEFT(vcodpro,2)) < 70
   Sayd(04,58,varea1,"@E 99,999.99",12," m˝")
   Sayd(05,58,varea2,"@E 99,999.99",12," m˝")
   Sayd(06,57,varea3,"@E 99,999.99",12," m˝")
   Sayd(07,62,vareatotal,"@E 99,999.99",12," m˝")
ENDIF
SETCOLOR(vcr)
//                    10        20        30        40        50        60        70       79
//            1234567890123456789012345678901234567890123456789012345678901234567890123456789
@ 08,01 SAY  "ITEM ≥        DESCRIÄ«O DO PRODUTO       ≥EST-1≥EST-2≥TRANS≥ CHEGADA≥ALT ≥LAR "
//             XXX ≥XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX≥X.XXX≥X.XXX≥X.XXX≥XX/XX/XX≥XXXX≥XXXX
SETCOLOR(vcn)
RETURN

******************************************************************************
STATIC PROCEDURE SayItStq(ni,nf,vcor)
*******************************
LOCAL i
SETCOLOR(vcor)
FOR i=ni TO IF(nf<23-vli,nf,22-vli)
   IF !EMPTY(mStoq[i+vt,1])
      @ vli+i,02 SAY STRZERO(i+vt,3)
      @ vli+i,07 SAY mStoq[i+vt,1]
      @ vli+i,43 SAY mStoq[i+vt,2]  PICTURE "@E 9,999"
      @ vli+i,49 SAY mStoq[i+vt,3]  PICTURE "@E 9,999"
      @ vli+i,55 SAY mStoq[i+vt,4]  PICTURE "@E 9,999"
      @ vli+i,61 SAY mStoq[i+vt,5]  PICTURE "99/99/99"
      //IF ALLTRIM(vunid)=="M2"
         @ vli+i,70 SAY mStoq[i+vt,6] PICTURE "9999"
         @ vli+i,75 SAY mStoq[i+vt,7] PICTURE "9999"
      //ELSE
      //   @ vli+i,72 SAY " -  "
      //   @ vli+i,77 SAY " -  "
      //ENDIF
      @ vli+i,06 SAY "≥"
      @ vli+i,42 SAY "≥"
      @ vli+i,48 SAY "≥"
      @ vli+i,54 SAY "≥"
      @ vli+i,60 SAY "≥"
      @ vli+i,69 SAY "≥"
      @ vli+i,74 SAY "≥"
   ELSE
      @ vli+i,01 SAY SPACE(78)
   ENDIF
NEXT
SETCOLOR(vcn)
RETURN

*************************************************************************
PROCEDURE EditaItStq()
****************************
vgrava:=.F.
DO WHILE .T.
   // Apresenta a linha de orientaá∆o ao usu†rio.
   SETCOLOR("W+/RB")
   //                   10        20        30        40        50        60        70
   //           123456789012345678901234567890123456789012345678901234567890123456789012345678
   @ 23,00 SAY PADC(CHR(24)+" "+CHR(25)+"  <Ins>  <Del>  F3=EditaQtde  Esc=Fim",80)
   IF LEN(mStoq)=0
      AADD(mStoq,{SPACE(45),0,0,0,CTOD(SPACE(8)),0,0})  // vprod,vqtd,vqtd2,vtran,vcheg,valt,vlar
   ENDIF
   SETCOLOR(vcp)
   @ vli+li,0 SAY CHR(177) // Cursor vertical
   // Mostra o item selecionado.
   SayItStq(li,li,vca)
   // Aguarda o pressionamento de uma tecla de controle pelo usu†rio.
   tk:=INKEY(0)
   IF tk=K_INS
      IF pv
         IF Senha("17")
            pv:=.F.
            SELECT Stq
         ELSE
            SELECT Stq
            EXIT
         ENDIF
      ENDIF
      vigual:=.F.
      vitprod:=SPACE(0)
      IF EMPTY(mStoq[li+vt,1])
         vqtd :=0                  // quantidade-1.
         vqtd2:=0                  // quantidade-2.
         vtran:=0                  // quant. em trÉnsito
         vcheg:=CTOD(SPACE(8))     // data de chegada
         valt :=0                  // altura do vidro
         vlar :=0                  // largura do vidro
         AADD(mStoq,{SPACE(45),0,0,0,CTOD(SPACE(8)),0,0})
      ELSE
         //vprod:=mStoq[li+vt,1]
         vqtd :=mStoq[li+vt,2]
         vqtd2:=mStoq[li+vt,3]
         vtran:=mStoq[li+vt,4]
         vcheg:=mStoq[li+vt,5]
         valt :=mStoq[li+vt,6]
         vlar :=mStoq[li+vt,7]
      ENDIF
      vitprod:=ALLTRIM(vprod)
      IF LEFT(vcodpro,2)=="19"
         vitprod:=vitprod+" "+MenuTampo()
      ENDIF
      @ 24,00 CLEAR
      SETCOLOR(vcn)
      @ vli+li,07 SAY vitprod
      IF ALLTRIM(vunid)=="M2"
         @ vli+li,43 GET vqtd  PICTURE "@E 9,999" //VALID(vqtd>0)
         @ vli+li,49 GET vqtd2 PICTURE "@E 9,999" //VALID(vqtd>0)
         @ vli+li,55 GET vtran PICTURE "@E 9,999"
         @ vli+li,61 GET vcheg PICTURE "99/99/99" //VALID vtran > 0
         @ vli+li,70 GET valt  PICTURE "9999" VALID(valt>0)
         @ vli+li,75 GET vlar  PICTURE "9999" VALID(vlar>0)
         Le()
         //IF vigual
         //   vlar:=valt
         //ENDIF
         //IF !vigual
         //   @ vli+li,75 GET vlar  PICTURE "9999" VALID(vlar>0)
         //   Le()
         //ENDIF
         @ vli+li,43 SAY vqtd  PICTURE "@E 9,999"
         @ vli+li,49 SAY vqtd2 PICTURE "@E 9,999"
         @ vli+li,55 SAY vtran PICTURE "@E 9,999"
         @ vli+li,61 SAY vcheg PICTURE "99/99/99"
         @ vli+li,70 SAY valt  PICTURE "9999"
         @ vli+li,75 SAY vlar  PICTURE "9999"
      ELSE
         @ vli+li,43 GET vqtd PICTURE "@E 9,999"  //VALID(vqtd>0)
         Le()
         valt:=vlar:=1000
      ENDIF
      vitprod:=ALLTRIM(vitprod)+SPACE(43-LEN(ALLTRIM(vitprod)))
      i:=1
      sai:=.F.
      DO WHILE i<=LEN(mStoq)
         IF mStoq[i,1]+STR(mStoq[i,6],4)+STR(mStoq[i,7],4)==vitprod+STR(valt,4)+STR(vlar,4)
            sai:=.T.
            EXIT
         ENDIF
         i++
      ENDDO
      IF sai
         Mensagem("Produto Cadastrado !",3,1)
         LOOP
      ENDIF
      SETCOLOR(vcn)
      vquant   +=vqtd-mStoq[li+vt,2]
      vquant2  +=vqtd2-mStoq[li+vt,3]
      vtransito+=vtran-mStoq[li+vt,4]
      // Atualiza o vetor dos itens do pedido.
      mStoq[li+vt,1]:=vitprod
      mStoq[li+vt,2]:=vqtd
      mStoq[li+vt,3]:=vqtd2
      mStoq[li+vt,4]:=vtran
      mStoq[li+vt,5]:=vcheg
      mStoq[li+vt,6]:=valt
      mStoq[li+vt,7]:=vlar
      varea:=0
      j:=1
      DO WHILE j<=LEN(mStoq)
         varea+=(mStoq[j,2]+mStoq[j,3]+mStoq[j,4])*Arred(vcodpro,mStoq[j,6],mStoq[j,7])
         j++
      ENDDO
      // Reapresenta o item.
      TelaStq()
      SETCOLOR(vcn)
      @ vli+li,0 SAY tampa
      @ vli+li,6 SAY SPACE(43)
      SayItStq(li,li,vcn)
      // Incrementa uma linha de ediá∆o.
      IF li<(22-vli)
         ++li
      ELSE
         // Realiza o rolamento da tela.
         ++vt
         SCROLL(vli+1,1,22,78,1)
         SayItStq(li,li,vcn)
      ENDIF
      vgrava:=.T.
   ELSEIF tk=K_F3
      IF pv
         IF Senha("17")
            pv:=.F.
            SELECT Stq
         ELSE
            SELECT Stq
            EXIT
         ENDIF
      ENDIF
      IF !EMPTY(mStoq[li+vt,1])
         vqtd :=mStoq[li+vt,2]
         vqtd2:=mStoq[li+vt,3]
         vtran:=mStoq[li+vt,4]
         vcheg:=mStoq[li+vt,5]
         @ vli+li,43 GET vqtd  PICTURE "@E 9,999"
         @ vli+li,49 GET vqtd2 PICTURE "@E 9,999"
         @ vli+li,55 GET vtran PICTURE "@E 9,999"
         @ vli+li,61 GET vcheg PICTURE "99/99/99" VALID vtran > 0
         Le()
         vquant   +=vqtd-mStoq[li+vt,2]
         vquant2  +=vqtd2-mStoq[li+vt,3]
         vtransito+=vtran-mStoq[li+vt,4]
         mStoq[li+vt,2]:=vqtd
         mStoq[li+vt,3]:=vqtd2
         mStoq[li+vt,4]:=vtran
         mStoq[li+vt,5]:=vcheg
         varea:=0
         j:=1
         DO WHILE j<=LEN(mStoq)
            varea+=(mStoq[j,2]+mStoq[j,3]+mStoq[j,4])*Arred(vcodpro,mStoq[j,6],mStoq[j,7])
            j++
         ENDDO
         TelaStq()
         SETCOLOR(vcn)
         @ vli+li,0 SAY tampa
         vgrava:=.T.
      ENDIF
   ELSEIF tk=K_UP
      // Foi pressionada a Seta para Cima: desloca para o item anterior.
      SETCOLOR(vcn)
      @ vli+li, 0 SAY tampa
      SayItStq(li,li,vcn)
      // Decrementa a linha dos itens.
      IF li>1
         --li
      ELSE
         // Realiza o rolamento da tela.
         IF vt>0
            --vt
            SCROLL(vli+1,1,22,78,-1)
            // Mostra o item.
            SayItStq(li,li,vcn)
         ENDIF
      ENDIF
   ELSEIF tk=K_DOWN
      // Foi pressionada a Seta para Baixo: desloca para o item seguinte.
      SETCOLOR(vcn)
      @ vli+li, 0 SAY tampa
      // Mostra o item.
      SayItStq(li,li,vcn)
      // Incrementa a linha dos itens.
      IF li < LEN(mStoq) .AND. li < 22-vli
         ++li
      ELSE
         // Realiza o rolamento da tela.
         IF !EMPTY(mStoq[li+vt,1])
            ++vt
            SCROLL(vli+1,1,22,78,1)
            SayItStq(li,li,vcn)
         ENDIF
      ENDIF
   ELSEIF tk=K_DEL
      IF pv
         IF Senha("17")
            pv:=.F.
            SELECT Stq
         ELSE
            SELECT Stq
            EXIT
         ENDIF
      ENDIF
      IF !EMPTY(mStoq[li+vt,1])
         // Atualiza o vetor dos itens, eliminando o elemento deletado.
         vquant   :=vquant-mStoq[li+vt,2]
         vquant2  :=vquant2-mStoq[li+vt,3]
         vtransito:=vtransito-mStoq[li+vt,4]
         ADEL(mStoq,li+vt)
         @ vli+li, 0 SAY tampa
         // Atualiza as linhas de controle de ediá∆o na tela.
         IF vt>0
            --vt
         ELSE
            IF li>1
               --li
            ENDIF
         ENDIF
         SETCOLOR(vcn)
         ASIZE(mStoq,LEN(mStoq)-1)
         // Reapresenta os itens, eliminando o que foi deletado.
         SayItStq(1,LEN(mStoq),vcn)
         varea:=0
         j:=1
         DO WHILE j<=LEN(mStoq)
            varea+=(mStoq[j,2]+mStoq[j,3]+mStoq[j,4])*Arred(vcodpro,mStoq[j,6],mStoq[j,7])
            j++
         ENDDO
         TelaStq()
         vgrava:=.T.
      ENDIF
   ELSEIF tk=K_ESC
      // Foi pressionada a tecla <Esc>: finaliza a ediá∆o dos itens.
      /*
      IF vgrava
         @ 24,00 CLEAR
         Aviso(24,"Deseja Gravar o Produto")
         IF Confirme()
            IF EMPTY(mStoq[1])
               Mensagem("Produto Sem Itens. Gravaá∆o Abortada!",3,1)
               EXIT
            ENDIF
            SETCOLOR(vcn)
            @ vli+li,0 SAY tampa
            SETCOLOR(vcp)
            @ 24,00 CLEAR
            Aviso(24,"Atualizando Registros. Aguarde...")
            SETCOLOR(vcn)
            CriaStq(vmodo)
            @ 24,00 CLEAR
         ENDIF
      ENDIF
      */
      EXIT
   ENDIF
ENDDO
RETURN

********************************************************************************
PROCEDURE AtualStq()
*********************
Stq->codpro  :=vcodpro
Stq->prod    :=vprod
Stq->unid    :=vunid
Stq->quant   :=vquant
Stq->quant2  :=vquant2
Stq->transito:=vtransito
RETURN

******************************************************************************
PROCEDURE TransfStq()
*********************
vcodpro  :=Stq->codpro
vprod    :=Stq->prod
vunid    :=Stq->unid
vquant   :=Stq->quant
vquant2  :=Stq->quant2
vtransito:=Stq->transito
RETURN

********************************************************************************
PROCEDURE CriaStq(pmodo)
// Cria registros nos arquivos de estoqes.
*****************************************
LOCAL i:=j:=1
@ 24,00 CLEAR
SETCOLOR(vcp)
Aviso(24,"Atualizando Registros. Aguarde..")
SETCOLOR(vcn)
SELECT Stq
IF pmodo=1
   IF Adireg(10)
      AtualStq()
      UNLOCK
   ELSE
      Mensagem("Erro de Rede, Inclus∆o N∆o Efetuada!",3,1)
   ENDIF
ELSEIF pmodo=2 .OR. pmodo=3
   IF Bloqreg(10)
      AtualStq()
      UNLOCK
   ELSE
      Mensagem("Registro N∆o Dispon°vel!",3,1)
   ENDIF
ENDIF
// Inclui itens
SELECT Sti
GO TOP
SEEK vcodpro
IF FOUND()
   DO WHILE Sti->codpro=vcodpro .AND. !EOF()
      IF Bloqreg(10)
         DELETE
         UNLOCK
      ELSE
         Mensagem("Erro de Rede. N∆o Foi Poss°vel Excluir o Registro!",3,1)
      ENDIF
      SKIP
   ENDDO
ENDIF
//
DO WHILE LEN(mStoq) >= i
   IF !EMPTY(mStoq[i,1])
      IF Adireg(10)
         Sti->codpro  :=vcodpro
         Sti->prod    :=mStoq[i,1]
         Sti->unid    :=vunid
         Sti->quant   :=mStoq[i,2]
         Sti->quant2  :=mStoq[i,3]
         Sti->transito:=mStoq[i,4]
         Sti->datacheg:=mStoq[i,5]
         Sti->alt     :=mStoq[i,6]
         Sti->lar     :=mStoq[i,7]
         UNLOCK
      ELSE
         Mensagem("Erro de Rede. Inclus∆o N∆o Efetuada !",3,1)
      ENDIF
   ENDIF
   i++
ENDDO
RETURN

********************************************************************************
// ## ROTINAS DE CADASTRO DE COMPOSIÄ«O DE PRODUTOS
********************************************************************************
PROCEDURE ConsCom()
********************************************************************************
LOCAL vdado[5],vpict[5],vcabe[5],vedit[5]
// Vari†veis para verificaá∆o de senha.
PRIVATE pv1:=pv2:=pv3:=pv4:=pv5:=.T.
// Abertura dos arquivos de dados
marqs:={;
{(dircad+"FC_PRODU.DBF"),"Prc","Produtos do FC",3},;
{(dircad+"FC_COMPO.DBF"),"Com","Composiá∆o de Produtos",1}}
IF !AbreArqs(marqs,.F.)
   RETURN
ENDIF
RELEASE marqs
// vedit: vetor com definiá∆o dos campos que podem ser editados.
AFILL(vedit,.T.)
vedit[1]:=.F.
// vdado: vetor dos nomes dos campos
vdado[1]:='codpro+"-"+Procura("Prc",1,codpro,"prod")'
vdado[2]:='codcom+"-"+Procura("Prc",1,codcom,"prod")'
vdado[3]:="quant"
vdado[4]:="unid"
vdado[5]:="flag"
// vpict: vetor das m†scaras de apresentaá∆o dos dados.
vpict[1]:="@R 9999999!!!!!!!!!!!!!!!!!!!!"
vpict[2]:="@R 9999999!!!!!!!!!!!!!!!!!!!!!!!!!!!"
vpict[3]:="@R 999.99"
vpict[4]:="!!"
vpict[5]:="!"
// vcabe: vetor dos t°tulos para o cabeáalho das colunas.
vcabe[1]:="Produto"
vcabe[2]:="Composiá∆o"
vcabe[3]:="Quant"
vcabe[4]:="Un"
vcabe[5]:="Flag"
// Informaá‰es para ajuda ao usu†rio.
majuda:={;
"Enter      - Consulta a Composiá∆o de Produto em Tela Cheia",;
"F2         - Pesquisa pelo C¢digo do Produto"}
// Construá∆o da Tela de Apresentaá∆o.
Sinal("PRODUTOS","COMPOSIÄ«O")
Abrejan(2)
@ 04,01 SAY REPLICATE("ƒ",78)
// Barra de Tarefas.
SETCOLOR(vcr)
@ 23,00 SAY PADC("F1=Ajuda  F2=C¢digoProduto  Enter=Consulta  Esc=Encerra",80)
SETCOLOR(vcn)
// Chamada do procedimento de consulta desenvolvido com TBrowse.
ConsBrowse("Com",03,01,22,78,vdado,vpict,vcabe,vedit,0,{|| OpsCom()},;
           "codpro",1,"9999999",7,"Produto")
CLOSE DATABASE
RETURN

********************************************************************************
FUNCTION OpsCom()
// Opá‰es da consulta de Composiá∆o de Produtos.
********************************************************************************
LOCAL vtela
// Teclas de opá‰es da consulta
IF LASTKEY()=K_ENTER
   // Enter - Consulta em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   VisaoCom()
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ENDIF
IF LASTKEY()=K_F9
   // F9 - Relat¢rio.
   vtela:=SAVESCREEN(01,00,24,79)
   RelatCom()
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ENDIF
RETURN .F.

********************************************************************************
PROCEDURE VisaoCom()
// Consulta as composiá‰es de produtos
**************************************
PRIVATE vcodpro,vprod,valtera:=.F.,pv:=.T.
PRIVATE mCompo:={}
PRIVATE vli,li,lf,vt,vord,tampa2:=CHR(186)
//
vtelav:=SAVESCREEN(01,00,24,79)
vrecatu:=RECNO()
DO WHILE .T.
   Abrejan(2)
   vcodpro:=Com->codpro
   vprod  :=Procura("Prc",1,vcodpro,"prod")
   vunid  :=Procura("Prc",1,vcodpro,"unid")
   TelaCom()
   SETCOLOR(vcp)
   Aviso(24,"Selecionando Registros. Aguarde...")
   SETCOLOR(vcn)
   // Carrega a matriz de Componentes
   GO TOP
   SEEK vcodpro
   IF FOUND()
      ASIZE(mCompo,0)
      DO WHILE vcodpro==Com->codpro
         AADD(mCompo,{Com->codcom,;
         Procura("Prc",1,Com->codcom,"prod"),;
         Com->quant,Com->unid })
         SKIP
      ENDDO
      @ 24,00 CLEAR
   ELSE
      @ 24,00 CLEAR
      Mensagem("Produto Sem Composiá∆o !",3,1)
      EXIT
   ENDIF
   // Inicializa as vari†veis de controle da tela.
   li:=lf:=1;vt:=0
   // Edita os itens da composiá∆o
   EditaItCom()
   IF LASTKEY()=K_ESC
      EXIT
   ENDIF
   @ 24,00 CLEAR
ENDDO
SELECT Com
GO vrecatu
RESTSCREEN(01,00,24,79,vtelav)
RETURN

********************************************************************************
PROCEDURE TelaCom()
// Apresenta os dados dos descontos na tela.
******************************************
SETCOLOR(vcn)
@ 03,03 SAY "Produto:"
@ 03,61 SAY "Unid:"
//        10        20        30        40       50         60        70
//  345678901234567890123456789012345678901234567890123456789012345678901234567
//  Produto:XXXXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  Unid:XX
SETCOLOR(vcd)
@ 03,11 SAY vcodpro   PICTURE "9999999"
@ 03,18 SAY "-"+vprod PICTURE "@!"
@ 03,66 SAY vunid
SETCOLOR(vcr)
//                    10        20        30        40        50        60        70        80
//           01234567890123456789012345678901234567890123456789012345678901234567890123456789
@ 05,01 SAY  " IT ≥ C‡DIGO  ≥         COMPOSIÄ«O                       ≥    QUANT ≥ UNID    "
//             XX ≥ XXXXXXX ≥ XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ≥ X.XXX.XX ≥ XX
SETCOLOR(vcn)
RETURN

********************************************************************************
PROCEDURE MostraItCom(ni,nf,vcor)
// Apresenta os itens na tela.
// ni:   n£mero do item inicial.
// nf:   n£mero do item final.
// vcor: padr∆o de cor para apresentaá∆o dos itens.
******************************************************
LOCAL i
SETCOLOR(vcor)
FOR i=ni TO IF(nf<23-vli,nf,22-vli)
   IF !EMPTY(mCompo[i+vt,01])
      @ vli+i,02 SAY STRZERO(i+vt,2)
      @ vli+i,07 SAY mCompo[i+vt,1] PICTURE "9999999"
      @ vli+i,17 SAY mCompo[i+vt,2] PICTURE "@!"
      @ vli+i,60 SAY mCompo[i+vt,3] PICTURE "@E 9,999.99"
      @ vli+i,71 SAY mCompo[i+vt,4] PICTURE "!!"
      SETCOLOR(vcor)
      @ vli+i,05 SAY "≥"
      @ vli+i,15 SAY "≥"
      @ vli+i,58 SAY "≥"
      @ vli+i,69 SAY "≥"
   ENDIF
NEXT
SETCOLOR(vcn)
RETURN

*******************************************************************************
PROCEDURE EditaItCom()
// Ediá∆o dos itens de composiá∆o
************************************************************
LOCAL vcodcom,vcomp,vquant,vunid
/*
PRIVATE vli,li,lf,vt,vord,tampa:=CHR(186)
   vli:  linha inicial para ediá∆o dos itens.
   li:   linha atual.
   lf:   linha final.
   vt:   linha adicional quando houver rolamento da tela.
   vord: n£mero de itens da nf.
// Inicializa a linha inicial para ediá∆o dos itens.
vli:=09
*/
vli:=5
li :=1
lf :=19
vt :=0
valtera:=.F.
IF LEN(mCompo)<lf
   lf:=LEN(mCompo)
ENDIF
MostraItCom(1,LEN(mCompo),vcn)
DO WHILE .T.
   // Apresenta a linha de orientaá∆o ao usu†rio.
   SETCOLOR(vcr)
   @ 23,00 SAY PADC("<Setas> <PgUp> <PgDn> Ins=Inclui Enter=Altera Del=Elimina Esc=Fim",80)
   SETCOLOR(vcp)
   @ vli+li,0 SAY CHR(177) // Cursor vertical
   SETCOLOR(vcn)
   // Mostra o item selecionado.
   MostraItCom(li,li,vca)
   //
   tk:=INKEY(0)
   IF tk=K_F1
      mAjuda2:={;
      "Setas    - Desloca o cursor para a pr¢xima linha ",;
      "PageUp   - Desloca o cursor para uma p†gina acima",;
      "PageDown - Desloca o cursor para uma p†gina abaixo",;
      "Ctrl+PageUp   - Desloca o cursor para o in°cio do arquivo",;
      "Ctrl+PageDown - Desloca o cursor para o fim do arquivo",;
      "Insert   - Inclui novo item na composiá∆o",;
      "Enter    - Altera o item da composiá∆o sob cursor",;
      "Delete   - Elimina o item da composiá∆o sob cursor",;
      "Esc      - Encerra as operaá‰es com opá∆o para gravar"}
      Ajuda2(mAjuda2)
   ELSEIF tk=K_INS
      IF pv
         IF !Senha("A1")
            LOOP
         ENDIF
         pv:=.F.
      ENDIF
      vcodcom:=SPACE(07)
      vquant :=0
      SETCOLOR(vcn)
      Aviso(24,"Digite o C¢digo do Componente")
      @ 22,07 GET vcodcom PICTURE "9999999"
      Le()
      vcodcom:=Acha2(vcodcom,"Prc",1,2,"codpro","prod","9999999","@!",15,02,22,78,"C¢digo","Nome do Componente")
      vcomp:=Procura("Prc",1,vcodcom,"prod")
      vunid:=Procura("Prc",1,vcodcom,"unid")
      @ 22,07 SAY vcodcom PICTURE "9999999"
      @ 22,17 SAY vcomp   PICTURE "@!"
      @ 22,71 SAY vunid   PICTURE "!!"
      Aviso(24,"Digite o Quantidade")
      @ 22,60 GET vquant  PICTURE "@E 9,999.99"
      Le()
      AADD(mCompo,{vcodcom,vcomp,vquant,vunid })
      @ 24,00 CLEAR
      valtera:=.T.
      //vord++
      SETCOLOR(vcn)
      // Reapresenta o item
      @ vli+li,0 SAY tampa2
      MostraItCom(1,LEN(mCompo),vcn)
   ELSEIF tk=K_ENTER
      IF pv
         IF !Senha("A2")
            LOOP
         ENDIF
         pv:=.F.
      ENDIF
      vcodcom:=mCompo[li+vt,1]
      vquant :=mCompo[li+vt,3]
      SETCOLOR(vcn)
      Aviso(24,"Digite o C¢digo do Componente")
      @ vli+li,07 GET vcodcom PICTURE "9999999"
      Le()
      vcodcom:=Acha2(vcodcom,"Prc",1,2,"codpro","prod","9999999","@!",15,02,22,78,"C¢digo","Nome do Componente")
      vcomp:=Procura("Prc",1,vcodcom,"prod")
      vunid:=Procura("Prc",1,vcodcom,"unid")
      @ vli+li,07 SAY vcodcom PICTURE "9999999"
      @ vli+li,17 SAY vcomp   PICTURE "@!"
      @ vli+li,71 SAY vunid   PICTURE "!!"
      Aviso(24,"Digite a Quantidade")
      @ vli+li,60 GET vquant  PICTURE "@E 9,999.99"
      //@ vli+li,71 GET vunid   PICTURE "!!"
      Le()
      mCompo[li+vt,1]:=vcodcom
      mCompo[li+vt,2]:=vcomp
      mCompo[li+vt,3]:=vquant
      mCompo[li+vt,4]:=vunid
      @ 24,00 CLEAR
      valtera:=.T.
      SETCOLOR(vcn)
      // Reapresenta o item
      @ vli+li,0 SAY tampa2
      MostraItCom(1,LEN(mCompo),vcn)
   ELSEIF tk=K_CTRL_PGUP
      // Desloca o cursor para o in°cio do arquivo
      SETCOLOR(vcn)
      @ vli+li, 0 SAY tampa2
      MostraItCom(li,li,vcn)
      IF vt>lf
         vt:=0
      ENDIF
      MostraItCom(1,LEN(mCompo),vcn)
   ELSEIF tk=K_CTRL_PGDN
      // Desloca o cursor para o fim do arquivo
      SETCOLOR(vcn)
      @ vli+li, 0 SAY tampa2
      MostraItCom(li,li,vcn)
      @ 24,00 CLEAR
      IF LEN(mCompo)>vt+2*lf
         vt:=LEN(mCompo)-lf
      ENDIF
      MostraItCom(1,LEN(mCompo),vcn)
   ELSEIF tk=K_PGUP
      // Desloca o cursor uma p†gina acima
      SETCOLOR(vcn)
      @ vli+li, 0 SAY tampa2
      MostraItCom(li,li,vcn)
      IF vt>lf
         vt:=vt-lf
      ELSE
         vt:=0
      ENDIF
      MostraItCom(1,LEN(mCompo),vcn)
   ELSEIF tk=K_PGDN
      // Desloca o cursor uma p†gina abaixo
      SETCOLOR(vcn)
      @ vli+li, 0 SAY tampa2
      MostraItCom(li,li,vcn)
      @ 24,00 CLEAR
      IF LEN(mCompo)>vt+2*lf
         vt:=vt+lf
      ELSE
         vt:=LEN(mCompo)-lf
      ENDIF
      MostraItCom(1,LEN(mCompo),vcn)
   ELSEIF tk=K_UP
      // Seta para Cima: desloca o cursor para o item acima
      SETCOLOR(vcn)
      @ vli+li, 0 SAY tampa2
      // Mostra o item.
      MostraItCom(li,li,vcn)
      // Decrementa a linha dos itens.
      IF li>1
         --li
      ELSE
         // Realiza o rolamento da tela.
         IF vt>0
            --vt
            SCROLL(vli+1,1,22,78,-1)
            // Mostra o item.
            MostraItCom(li,li,vcn)
         ENDIF
      ENDIF
   ELSEIF tk=K_DOWN
      // Seta para Baixo: desloca o cursor para o item abaixo
      SETCOLOR(vcn)
      @ vli+li, 0 SAY tampa2
      MostraItCom(li,li,vcn)
      // Incrementa a linha dos itens.
      IF li<lf
         ++li
      ELSE
         // Realiza o rolamento da tela.
         IF vt<(LEN(mCompo)-(22-vli))
            ++vt
            SCROLL(vli+1,1,22,78,1)
            MostraItCom(li,li,vcn)
         ENDIF
      ENDIF
   ELSEIF tk=K_DEL
      // Diminui a quantidade de itens.
      IF pv
         IF !Senha("A3")
            LOOP
         ENDIF
         pv:=.F.
      ENDIF
      // Atualiza o vetor dos itens, eliminando o elemento deletado.
      ADEL(mCompo,li+vt)
      ASIZE(mCompo,LEN(mCompo)-1)
      AADD(mCompo,{SPACE(07),SPACE(40),0,SPACE(02)})
      valtera:=.T.
      // Atualiza as linhas de controle de ediá∆o na tela.
      IF vt>0
         --vt
      ELSE
         IF lf>1 .AND. lf<(22-vli)
            --lf
         ENDIF
      ENDIF
      // Reapresenta os itens da composiá∆o.
      MostraItCom(1,LEN(mCompo),vcn)
   ELSEIF tk=K_ESC
      IF valtera
         @ 24,00 CLEAR
         Aviso(24,"Grava o Arquivo com os itens alterados")
         IF Confirme()
            @ 24,00 CLEAR
            SETCOLOR(vcp)
            Aviso(24,"Atualizando o Arquivo de Composiá∆o. Aguarde...")
            SETCOLOR(vcn)
            // Apaga registros de composiá∆o
            SELECT Com
            GO TOP
            SEEK vcodpro
            IF FOUND()
               DO WHILE !EOF() .AND. vcodpro==Com->codpro
                  IF Bloqreg(10)
                     DELETE
                     UNLOCK
                  ELSE
                     Mensagem("O Registro N∆o Est† Dispon°vel !",3,1)
                  ENDIF
                  SKIP
               ENDDO
            ENDIF
            // Cria novos registros de composiá∆o
            FOR k:=1 TO LEN(mCompo)
               IF !EMPTY(mCompo[k,4])
                  IF Adireg(10)
                     Com->codpro:=vcodpro
                     Com->codcom:=mCompo[k,1]
                     Com->quant :=mCompo[k,3]
                     Com->unid  :=mCompo[k,4]
                     UNLOCK
                  ELSE
                     Mensagem("Erro de Rede, Inclus∆o N∆o Efetuada !",4,1)
                  ENDIF
               ENDIF
            NEXT
         ENDIF
      ENDIF
      @ 24,00 CLEAR
      EXIT
   ENDIF
ENDDO
RETURN

********************************************************************************
PROCEDURE RelatCom()
// Relat¢rio das composiá‰es de produtos
********************************************************************************
LOCAL vtelav, vrecatu, vcodpro, mDados:={}, vtit
vtelav:=SAVESCREEN(01,00,24,79)
vrecatu:=RECNO()
GO TOP
Abrejan(2)
SETCOLOR(vcp)
Aviso(10,"Selecionando Registros. Aguarde...")
SETCOLOR(vcn)
DO WHILE !EOF()
   // Recupera o produto acabado
   vcodpro:=Com->codpro
   AADD(mDados,{"P",Com->codpro,;
   Procura("Prc",1,vcodpro,"prod"),;
   1,Procura("Prc",1,vcodpro,"unid") })
   // Recupera os Componentes
   DO WHILE vcodpro==Com->codpro
      AADD(mDados,{"C",Com->codcom,;
      Procura("Prc",1,Com->codcom,"prod"),;
      Com->quant,Com->unid })
      SKIP
   ENDDO
ENDDO
vtit:="Composiá∆o de Produtos"
IF !Imprime2(vtit)
   RETURN
ENDIF
SET DEVICE TO PRINTER
SET PRINTER TO &vcimpres
DO WHILE vcop > 0
   i:=1                    // Contador de vetores
   pg:=0                   // Contador de p†ginas.
   //
   DO WHILE i<=LEN(mDados)
      IF Escprint(80)
         RETURN
      ENDIF
      Cabe(vcnomeemp,vsist,vtit,"LISTA GERAL",80,vcia12)
      //                          10        20        30        40        50        60        70        80        90       100       110       120       130
      //                 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
      @ PROW()+1,00 SAY "C‡DIGO  DESCRIÄ«O                                          QUANT UN"
      //                 XXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX      XXX.XXX,XX XX
      @ PROW()+1,00 SAY REPLICATE("-",80)
      //
      DO WHILE PROW()<58 .AND. i<=LEN(mDados)
         IF Escprint(80)
            RETURN
         ENDIF
         // Impress∆o dos dados.
         IF mDados[i,1]=="P"
            @ PROW()+1,00 SAY mDados[i,2]
            @ PROW(),  08 SAY mDados[i,3]
         ELSE
            @ PROW()+1,05 SAY mDados[i,2]
            @ PROW(),  13 SAY mDados[i,3]
         ENDIF
         @ PROW(),  54 SAY mDados[i,4] PICTURE "@E 999,999.99"
         @ PROW(),  65 SAY mDados[i,5]
         i++
      ENDDO
   ENDDO
   SET PRINTER ON
   ?? vcid10+vcia10
   SET PRINTER OFF
   @ PROW()+2,0 SAY PADC(" Fim  do  Relat¢rio ",80,"=")
   EJECT
   --vcop
ENDDO
SET PRINTER TO
SET DEVICE TO SCREEN
IF vcporta="2" // tela
   Imprtela(vcimpres,160)
ENDIF
//
SELECT Com
GO vrecatu
RESTSCREEN(01,00,24,79,vtelav)
RETURN

********************************************************************************
// ## ROTINAS DE ATUALIZAÄ«O DOS PRODUTOS DO VM PARA O FC
********************************************************************************
PROCEDURE ImportaPro()
// Objetivo: Importar Produtos do VM para o FC
********************************************************************************
Sinal("PRODUTOS","IMPORTAÄ«O")
Abrejan(2)
Aviso(10,"Esta Rotina Atualiza o Arquivo de Produtos do FC")
Aviso(11,"a partir do Arquivo de Produtos do VM")
Aviso(13,"Deseja Continuar a Operaá∆o ?")
IF !Confirme()
   RETURN
ENDIF
@ 10,01 CLEAR TO 13,78
// Abertura dos arquivos de dados
marqs:={;
{(dircad+"FC_PRODU.DBF"),"Prc","Produtos do FC",3},;
{(dirvm+"VM_PRODU.DBF"),"Pro","Produtos do VM",2}}
IF !AbreArqs(marqs,.F.)
   RETURN
ENDIF
//
SETCOLOR(vcp)
Aviso(11,"Atualizando Produtos. Aguarde")
SETCOLOR(vcn)
j:=i:=1
mPro:={}
SELECT Pro
GO TOP
DO WHILE !EOF()
   IF EMPTY(Pro->codfx)
      SKIP
      LOOP
   ENDIF
   vcodfx:=Pro->codfx
   SELECT Prc
   GO TOP
   SEEK vcodfx
   IF !FOUND()
      // Inclui um novo registro no arquivo de dados.
      IF Adireg(10)
         Prc->codgru:="0100"
         Prc->codpro :=vcodfx
         Prc->prod   :=Pro->prod
         Prc->unid   :=Pro->unid
         Prc->cfi    :=Pro->cfi
         Prc->taxaipi:=Pro->taxaipi
         Prc->ticms  :=17
         Prc->preco1 :=Pro->preco1
         Prc->preco2 :=Pro->preco2
         Prc->preco3 :=Pro->preco3
         Prc->datcad :=Pro->data
         Prc->datmod :=DATE()
         UNLOCK
      ELSE
         Mensagem("Erro de Rede, Inclus∆o N∆o Efetuada!",3,1)
      ENDIF
      // Guarda o c¢digo e o nome para gravar LOG.
      AADD(mPro,vcodfx+"-"+Pro->prod)
   ENDIF
   SELECT Pro
   SKIP
ENDDO
SET DEVICE TO PRINTER
SET PRINTER TO (dircad+"PRODUTOS.LOG")
@ 00,01 SAY "Produtos Importados do VM para o FC em:";
+DTOC(DATE())+" Ös "+TIME()
i:=1
DO WHILE i <= LEN(mPro)
   @ i,01 SAY mPro[i]
   i++
ENDDO
SET PRINTER TO
SET DEVICE TO SCREEN
CLOSE DATABASE
Aviso(11,"   Produtos Importados !    ")
INKEY(1)
@ 10,01 CLEAR TO 16,78
vtexto:=MEMOREAD(dircad+"PRODUTOS.LOG")
EditaTexto(vtexto,"Produtos Importados",4)
RETURN

********************************************************************************
// ### ROTINAS DE CADASTRO DE FORNECEDORES
********************************************************************************
PROCEDURE ConsFor()
// Consultas e Pesquisas aos Registros do Arquivo de Dados
********************************************************************************
// Declaraá∆o dos vetores do browse
LOCAL vdado[13],vmask[13],vcabe[13],vedit[13]
// Vari†veis para verificaá∆o de senha.
PRIVATE pv1:=pv2:=pv3:=pv4:=pv5:=.T.
// Carrega matriz
PRIVATE muf:=GeraMatriz((dirvm+"VM_CONFI.DBF"),"estados","ESTADOS")
// Abertura dos arquivos de dados
vano:=RIGHT(STR(YEAR(DATE()),4),2) // "04"
marqs:={{(dircad+"FC_FORNE.DBF"),"For","Fornecedores",3},;
{(dirmov+"EC_PC"+vano+"E.DBF"),"Plc","Plano de Contas",2}}
IF !AbreArqs(marqs,.F.)
   RETURN
ENDIF
SELECT For
// vdado: vetor dos nomes dos campos
vdado[01]:="codfor"
vdado[02]:="nome"
vdado[03]:="ende"
vdado[04]:="bair"
vdado[05]:="muni"
vdado[06]:="esta"
vdado[07]:="cic"
vdado[08]:="insc"
vdado[09]:="cep"
vdado[10]:="ddd+tel1"
vdado[11]:="cont"
vdado[12]:="contab"
vdado[13]:="data"
// vmask: vetor das m†scaras de apresentaá∆o dos dados.
vmask[01]:="99999"
vmask[02]:="@!"
vmask[03]:="@!"
vmask[04]:="@!"
vmask[05]:="@!"
vmask[06]:="!!"
vmask[07]:="99999999999999"
vmask[08]:="99999999999999"
vmask[09]:="@R 99999-999"
vmask[10]:="@R (X999)XX99-9999"
vmask[11]:="@!"
vmask[12]:="@R 9999.99.99.999-9"
vmask[13]:="99/99/99"
// vcabe: vetor dos t°tulos para o cabeáalho das colunas.
vcabe[01]:="C¢digo"
vcabe[02]:="Nome"
vcabe[03]:="Endereáo"
vcabe[04]:="Bairro"
vcabe[05]:="Munic°pio"
vcabe[06]:="UF"
vcabe[07]:="CIC"
vcabe[08]:="Inscriá∆o"
vcabe[09]:="Cep"
vcabe[10]:="Telefone"
vcabe[11]:="Contato"
vcabe[12]:="Contabilidade"
vcabe[13]:="Data"
// vedit: vetor com campos que podem ser editados
AFILL(vedit,.F.)
// Informaá‰es para ajuda ao usu†rio.
majuda:={;
"Ins        - Inclui um novo Fornecedor no Sistema",;
"Ctrl+Enter - Altera o Fornecedor sob Cursor",;
"Del        - Exclui o Fornecedor sob Cursor",;
"Enter      - Consulta o Fornecedor em Tela Cheia",;
"F2         - Pesquisa pelo C¢digo do Fornecedor",;
"F3         - Pesquisa pelo Nome do Fornecedor",;
"F4         - Pesquisa pelo CNPJ ou CPF do Fornecedor",;
"F9         - Emite Relat¢rio de Fornecedores"}
// Construá∆o da Tela de Apresentaá∆o.
Sinal("FORNEC.","CONSULTA")
Abrejan(2)
@ 04,01 SAY REPLICATE("ƒ",78)
// Barra de Tarefas.
SETCOLOR(vcr)
@ 22,00 SAY PADC("Ins=Inclui Ctrl+Enter=Altera Del=Exclui Enter=Consulta Esc=Encerra",80)
@ 23,00 SAY PADC("F1=Ajuda  F2=C¢digo  F3=Nome  F4=CNPJ/CPF  F9=Relat¢rio",80)
SETCOLOR(vcn)
// Chamada do procedimento de consulta desenvolvido com TBrowse.
ConsBrowse("For",05,01,21,78,vdado,vmask,vcabe,vedit,1,{|| OpsFor()},;
           "codfor",1,"99999",5 ,"C¢digo",;
           "nome"  ,2,"@!"   ,40,"Nome",;
           "cic"   ,3,"@!"   ,14,"CNPJ/CPF")
CLOSE DATABASE
RETURN

********************************************************************************
FUNCTION OpsFor()
// Opá‰es da consulta de Forncedores.
********************************************************************************
LOCAL vtela
// Destaque do browse
@ 03,03 CLEAR TO 03,77
@ 03,03 SAY "Fornecedor:"
SETCOLOR(vcd)
@ 03,15 SAY For->codfor+"-"+For->nome
SETCOLOR(vcn)
// Teclas de opá‰es da consulta
IF LASTKEY()=K_INS
   // Ins - Inclus∆o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatFor(1)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_CTRL_ENTER
   // Ctrl+Enter - Alteraá∆o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatFor(2)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_DEL
   // Del - Exclus∆o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatFor(3)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_ENTER
   // Enter - Consulta em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatFor(4)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_F9
   // F9 - Relat¢rio.
   vtela:=SAVESCREEN(01,00,24,79)
   RelFor()
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ENDIF
RETURN .F.

********************************************************************************
PROCEDURE MatFor(modo)
/* Parametros: modo - operaá∆o a ser realizada: 1 - Inclus∆o
                                                2 - Alteraáao
                                                3 - Exclus∆o */
********************************************************************************
IF modo=1
   IF pv1
      IF !Senha("B1")
         RETURN
      ENDIF
      pv1:=.F.
   ENDIF
   Sinal("FORNEC.","INCLUS«O")
ELSEIF modo=2
   IF pv2
      IF !Senha("B2")
         RETURN
      ENDIF
      pv2:=.F.
   ENDIF
   Sinal("FORNEC.","ALTERAÄ«O")
ELSEIF modo=3
   IF pv3
      IF !Senha("B3")
         RETURN
      ENDIF
      pv3:=.F.
   ENDIF
   Sinal("FORNEC.","EXCLUS«O")
ENDIF
SELECT("For")
Abrejan(2)
DO WHILE .T.
   // Inicializaá∆o das vari†veis auxiliares.
   vcodfor :=SPACE(05)  //  C¢digo do Fornecedor
   vnome   :=SPACE(40)  //  Nome do Fornecedor
   vende   :=SPACE(40)  //  Endereáo do Fornecedor
   vbair   :=SPACE(20)  //  Bairro do Fornecedor
   vmuni   :=SPACE(20)  //  Munic°pio do Fornecedor
   vesta   :=SPACE(02)  //  Estado do Fornecedor
   vcont   :=SPACE(20)  //  Contato do Fornecedor
   vcic    :=SPACE(14)  //  Cadastro geral de contribuinte do Fornecedor
   vinsc   :=SPACE(14)  //  Inscriá∆o do Fornecedor
   vcep    :=SPACE(08)  //  Cep do Fornecedor
   vddd    :=SPACE(04)  //  DDD
   vtel1   :=SPACE(08)  //  Telefone do Fornecedor
   vtel2   :=SPACE(08)  //
   vfax    :=SPACE(08)  //
   vtippes :=SPACE(01)  //  Tipo de pessoa (F°sica ou Jur°dica)
   vcontab :=SPACE(12)  //  C¢digo contabil do plano de contas
   vdata   :=CTOD(SPACE(08)) // Data de cadastro
   IF modo=1 // Se for Inclus∆o
      SET ORDER TO 1
      GO BOTTOM
      vcodfor:=STRZERO(VAL(For->codfor)+1,5)
      vdata:=DATE()
   ENDIF
   // Apresenta os t°tulos na tela
   TelaFor()
   IF modo#1 // Se n∆o for Inclus∆o
      // Transfere os dados do registro para as vari†veis auxiliares.
      TransfFor()
   ENDIF
   // Mostra os dados com as variaveis auxiliares
   MostraFor()
   IF modo=3 // Se for Exclus∆o
      IF Exclui() // Deleta o registro do arquivo.
         IF Bloqreg(10)
            DELETE
            UNLOCK
         ELSE
            Mensagem("O Registro N∆o Est† Dispon°vel !",3,1)
         ENDIF
      ENDIF
      EXIT
   ENDIF
   IF modo=4 // Se for Consulta
      SETCOLOR(vcr)
      @ 23,00 SAY PADC("PageUp=Pr¢ximo Registro   PageDown=Registro Anterior   Esc=Retorna",80)
      SETCOLOR(vcn)
      INKEY(0)
      IF LASTKEY()=K_PGUP
         SKIP
         LOOP
      ELSEIF LASTKEY()=K_PGDN
         SKIP -1
         LOOP
      ELSEIF LASTKEY()=K_ESC
         EXIT
      ELSE
         mAjuda2:={;
         "PgUp        - Exibe o Pr¢ximo Registro",;
         "PgDn        - Exibe o Registro Anterior",;
         "Esc         - Volta Ö Tela de Consulta"}
         Ajuda2(mAjuda2)
         LOOP
      ENDIF
   ENDIF
   // Edita os Dados do Registro
   EditaFor(modo)
   IF LASTKEY()=K_ESC
      EXIT
   ENDIF
   IF !Confirme()
      LOOP
   ENDIF
   IF modo=1 // Inclus∆o
      GO TOP
      SEEK vcodfor
      IF FOUND()
         Mensagem("Desculpe, Fornecedor J† Cadastrado !",5,1)
         LOOP
      ENDIF
      // Inclui um novo registro no arquivo.
      IF Adireg(10)
         UNLOCK
      ELSE
         Mensagem("Erro de Rede, Inclus∆o N∆o Efetuada!",3,1)
      ENDIF
   ENDIF
   // Atualiza o conte£do dos campos do registro com as vari†veis auxiliares.
   IF Bloqreg(10)
      AtualFor()
      COMMIT
      UNLOCK
   ELSE
      Mensagem("O Registro N∆o Est† Dispon°vel !",3,1)
   ENDIF
   IF modo=1
      LOOP
   ENDIF
   EXIT
ENDDO
RETURN

********************************************************************************
PROCEDURE TelaFor()
// Apresenta os t°tulos do arquivo na tela.
********************************************************************************
SETCOLOR(vcn)
/*               10        20        30        40        50        60        70        80
        012345678901234567890123456789012345678901234567890123456789012345678901234567890
@ 04,05 SAY "C¢digo:XXXXX
@ 06,05 SAY "Nome:40XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  CEP:XXXXX-XXX
@ 08,05 SAY "Endereáo:40XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
@ 10,05 SAY "Bairro:20XXXXXXXXXXXXXXXXXX
@ 12,05 SAY "UF:XX  Munic°pio:20XXXXXXXXXXXXXXXXXX
@ 14,05 SAY "CPF/CNPJ:18.XXX.XXX/XXXX-XX  Inscriá∆o:18XXXXXXXXXXXXXXXX
@ 16,05 SAY "DDD:XXX  Telefone:XXXX-XXXX  Telefone 2:XXXX-XXXX  Fax:XXXX-XXXX
@ 17,05 SAY "Contato:"
@ 19,05 SAY "Contabilidade:"
@ 20,05 SAY "Data:"
*/
@ 04,05 SAY "C¢digo:"
@ 06,05 SAY "Nome:                                          CEP:"
@ 08,05 SAY "Endereáo:"
@ 10,05 SAY "Bairro:"
@ 12,05 SAY "UF:    Munic°pio:"
@ 14,05 SAY "CPF/CNPJ:                    Inscriá∆o:"
@ 16,05 SAY "DDD:     Telefone:           Telefone 2:           Fax:"
@ 17,05 SAY "Contato:"
@ 19,05 SAY "Contabilidade:"
@ 20,05 SAY "Data:"
RETURN

********************************************************************************
PROCEDURE MostraFor()
// Mostra os dados do arquivo na tela.
********************************************************************************
SETCOLOR(vcd)
@ 04,12 SAY vcodfor  PICTURE "99999"
@ 06,10 SAY vnome    PICTURE "@!"
Sayd(06,56,vcep,"@R 99999-999",9)
@ 08,14 SAY vende    PICTURE "@!"
@ 10,12 SAY vbair    PICTURE "@!"
@ 12,08 SAY vesta    PICTURE "!!"
@ 12,22 SAY vmuni    PICTURE "@!"
Sayd(14,14,vcic,MaskCIC(vcic),18)
Sayd(14,44,vinsc,MaskIE(vesta,vinsc),18)
Sayd(16,09,vddd,"@R X999",4)
Sayd(16,23,vtel1,"@R XX99-9999",9)
Sayd(16,45,vtel2,"@R XX99-9999",9)
Sayd(16,60,vfax ,"@R XX99-9999",9)
@ 17,13 SAY vcont    PICTURE "@!"
Sayd(19,20,vcontab,"@R 9999.99.99.999-9",16)
Sayd(19,37,Procura("Plc",1,vcontab,"titcta"),"@X",36)
Sayd(20,10,vdata,"99/99/99",8)
SETCOLOR(vcn)
RETURN

********************************************************************************
PROCEDURE EditaFor(modo)
// Edita os dados do arquivo atravÇs das vari†veis auxiliares.
********************************************************************************
@ 24,00 CLEAR
Limpa(14,14,18)
Limpa(14,44,18)
Aviso(24,"Digite os Dados do Fornecedor, ou <Esc> para Finalizar")
SETCOLOR(vcd)
@ 04,12 GET vcodfor  PICTURE "99999" WHEN modo=1
@ 06,10 GET vnome    PICTURE "@!"
@ 06,56 GET vcep     PICTURE "@R 99999-999"
@ 08,14 GET vende    PICTURE "@!"
@ 10,12 GET vbair    PICTURE "@!"
@ 12,22 GET vmuni    PICTURE "@!"
@ 12,08 GET vesta    PICTURE "!!" VALID ASCAN(muf,vesta)>0
@ 14,14 GET vcic     PICTURE "99999999999999" VALID PesqCIC(vesta,vcic,modo)
@ 14,44 GET vinsc    PICTURE "@!" VALID ValidaIE(vesta,vinsc,vcic)
@ 16,09 GET vddd     PICTURE "@R X999"    VALID Ddd(16,09)
@ 16,23 GET vtel1    PICTURE "@R XX99-9999" VALID Telefone(16,23,"vtel1")
@ 16,45 GET vtel2    PICTURE "@R XX99-9999" VALID Telefone(16,45,"vtel2")
@ 16,60 GET vfax     PICTURE "@R XX99-9999" VALID Telefone(16,60,"vfax")
@ 17,13 GET vcont    PICTURE "@!"
@ 19,20 GET vcontab  PICTURE "@R 9999.99.99.999-9" // VALID Contab(20,20)
@ 20,10 GET vdata    PICTURE "99/99/99"
SETCOLOR(vcn)
Le()
IF LASTKEY()=K_ESC
   RETURN
ENDIF
RETURN

********************************************************************************
PROCEDURE TransfFor()
// Transfere os dados dos campos do arquivo para respectivas as vari†veis
// auxiliares.
********************************************************************************
vcodfor :=For->codfor
vnome   :=For->nome
vende   :=For->ende
vbair   :=For->bair
vmuni   :=For->muni
vesta   :=For->esta
vcic    :=For->cic
vinsc   :=For->insc
vcep    :=For->cep
vddd    :=FormaDdd(For->ddd)
vtel1   :=FormaTel(For->tel1)
vtel2   :=FormaTel(For->tel2)
vfax    :=FormaTel(For->fax)
vcont   :=For->cont
vcontab :=For->contab
vdata   :=For->data
RETURN

********************************************************************************
PROCEDURE AtualFor()
// Atualiza os dados dos campos do arquivo com as variaveis auxiliares.
********************************************************************************
For->codfor :=vcodfor
For->nome   :=vnome
For->ende   :=vende
For->bair   :=vbair
For->muni   :=vmuni
For->esta   :=vesta
For->cic    :=vcic
For->insc   :=vinsc
For->cep    :=vcep
For->ddd    :=vddd
For->tel1   :=vtel1
For->tel2   :=vtel2
For->fax    :=vfax
For->cont   :=vcont
For->contab :=vcontab
For->data   :=vdata
RETURN

********************************************************************************
PROCEDURE RelFor(ordem)
********************************************************************************
LOCAL ordatu,recatu
ordatu:=INDEXORD()
recatu:=RECNO()
// Atualiza a linha de status.
Sinal("FORNEC.","RELAT‡RIO")
IF !Imprime2("Relat¢rio de Fornecedores")
   RETURN
ENDIF
SET DEVICE TO PRINTER
SET PRINTER TO &vcimpres
SET ORDER TO 1
DO WHILE vcop > 0
   pg:=0  // Contador de p†ginas.
   GO TOP
   DO WHILE !EOF()
      // Impressao do cabeáalho.
      Cabe(vcnomeemp,vsist,"RELAT‡RIO DE FORNECEDORES","Em Ordem de C¢digo",80,vcia10)
      // Impress∆o dos t°tulos
      @ PROW()+1, 00 SAY "C‡DIGO"
      @ PROW(),   10 SAY "NOME DO FORNECEDOR"
      @ PROW()+1, 00 SAY REPLICATE("-",80)
      // Impressao dos dados.
      DO WHILE PROW()<58 .AND. !EOF()
         IF Escprint(80)
            RETURN
         ENDIF
         // Imprime os dados do relat¢rio
         @ PROW()+1,00 SAY For->codfor PICTURE "99999"
         @ PROW(),  10 SAY For->nome
         SKIP
      ENDDO
   ENDDO  // Fim do DO WHILE principal.
   @ PROW()+2,0 SAY PADC(" Fim  do  Relat¢rio ",80,"=")
   EJECT
   --vcop
ENDDO
SET PRINTER TO
SET DEVICE TO SCREEN
IF vcporta="2" // tela
   Imprtela(vcimpres,80)
ENDIF
SELECT For
SET ORDER TO ordatu
GO recatu
RETURN

********************************************************************************
// ### ROTINAS DE CADASTRO DE CODIGOS FISCAIS - CFOP
********************************************************************************
PROCEDURE ConsCfop()
// Consultas e Pesquisas aos Registros do Arquivo de Dados
********************************************************************************
LOCAL vdado[3],vmask[3],vcabe[3],vedit[3]
// Vari†veis para verificaá∆o de senha.
PRIVATE pv1:=pv2:=pv3:=pv4:=pv5:=.T.
// Abertura do arquivo de dados.
IF Abrearq((dircad+"FC_NATUR.DBF"),"Nat",.F.,10)
   SET INDEX TO (dircad+"FC_NATU1"),(dircad+"FC_NATU2")
ELSE
   Mensagem("O Arquivo N∆o Est† Dispon°vel!",3,1)
   RETURN
ENDIF
// vdado: vetor dos nomes dos campos
vdado[01]:="cfop"
vdado[02]:="nome"
vdado[03]:="contab"
// vmask: vetor das m†scaras de apresentaá∆o dos dados.
vmask[01]:="@R 9.999"
vmask[02]:="@!"
vmask[03]:="@R 9999.99.99.999-9"
// vcabe: vetor dos t°tulos para o cabeáalho das colunas.
vcabe[01]:="C¢digo"
vcabe[02]:="Descriá∆o da Natureza da Operaá∆o"
vcabe[03]:="Contabilidade"
// vedit: vetor com definiá∆o dos campos que podem ser editados.
AFILL(vedit,.F.)
// Informaá‰es para ajuda ao usu†rio.
majuda:={;
"Ins        - Inclui um novo CFOP no Sistema",;
"Ctrl+Enter - Altera o CFOP sob Cursor",;
"Del        - Exclui o CFOP sob Cursor",;
"Enter      - Consulta o CFOP em Tela Cheia",;
"F2         - Pesquisa pelo CFOP",;
"F3         - Pesquisa pela Descriá∆o do CFOP",;
"F8         - Filtra os CFOPs de Resumo de Operaá‰es",;
"F9         - Emite Relat¢rio de CFOPs"}
// Construá∆o da Tela de Apresentaá∆o.
Sinal("CFOP","CONSULTA")
Abrejan(2)
@ 04,01 SAY REPLICATE("ƒ",78)
// Barra de Tarefas.
SETCOLOR(vcr)
@ 22,00 SAY PADC("Ins=Inclui Ctrl+Enter=Altera Del=Exclui Enter=Consulta Esc=Encerra",80)
@ 23,00 SAY PADC("F1=Ajuda  F2=CFOP  F3=Descriá∆o  F8=Filtro  F9=Relat¢rio",80)
SETCOLOR(vcn)
// Chamada do procedimento de consulta desenvolvido com TBrowse.
ConsBrowse("Nat",05,01,21,78,vdado,vmask,vcabe,vedit,1,{|| OpsCfop()},;
          "cfop",1,"@R 9.999",4 ,"CFOP",;
          "nome",2,"@!"      ,40,"Nome")
CLOSE DATABASE
RETURN

********************************************************************************
FUNCTION OpsCfop()
// Opá‰es da consulta de Cfops.
********************************************************************************
LOCAL tk,vtela
// Destaque do browse
@ 03,03 CLEAR TO 03,77
@ 03,03 SAY "CFOP:"
SETCOLOR(vcd)
@ 03,10 SAY Nat->cfop+"-"+Nat->nome
SETCOLOR(vcn)
// Teclas de opá‰es da consulta
IF LASTKEY()=K_INS
   // Ins - Inclus∆o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatCfop(1)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_CTRL_ENTER
   // Ctrl+Enter - Alteraá∆o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatCfop(2)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_DEL
   // Del - Exclus∆o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatCfop(3)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_ENTER
   // Enter - Consulta em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatCfop(4)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_F8
   // F8 - Filtro.
   SET FILTER TO (RIGHT(Nat->cfop,2)=="00".OR.RIGHT(Nat->cfop,2)=="50")
   RETURN .T.
ELSEIF LASTKEY()=K_F9
   // F9 - Relat¢rio.
   vtela:=SAVESCREEN(01,00,24,79)
   RelCfop()
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ENDIF
RETURN .F.

********************************************************************************
PROCEDURE MatCfop(modo)
/* Parametros: modo - operaá∆o a ser realizada: 1 - Inclus∆o
                                                2 - Alteraáao
                                                3 - Exclus∆o */
********************************************************************************
IF modo=1
   IF pv1
      IF !Senha("C1")
         RETURN
      ENDIF
      pv1:=.F.
   ENDIF
   Sinal("CFOP","INCLUS«O")
ELSEIF modo=2
   IF pv2
      IF !Senha("C2")
         RETURN
      ENDIF
      pv2:=.F.
   ENDIF
   Sinal("CFOP","ALTERAÄ«O")
ELSEIF modo=3
   IF pv3
      IF !Senha("C3")
         RETURN
      ENDIF
      pv3:=.F.
   ENDIF
   Sinal("CFOP","EXCLUS«O")
ENDIF
vmodo:=modo
DO WHILE .T.
   SELECT Nat
   Abrejan(2)
   // Inicializaá∆o das vari†veis auxiliares.
   vcfop:=SPACE(04)
   vnome:=SPACE(40)
   vcontab:=SPACE(12)
   // Apresenta os t°tulos na tela
   TelaCfop()
   IF modo#1 // Se n∆o for Inclus∆o
      // Transfere os dados do registro para as vari†veis auxiliares.
      TransfCfop()
   ENDIF
   // Mostra os dados com as variaveis auxiliares
   MostraCfop()
   //
   IF modo=3 // Exclus∆o
      IF Exclui() // Deleta o registro do arquivo.
         IF Bloqreg(10)
            DELETE
            UNLOCK
         ELSE
            Mensagem("O Registro N∆o Est† Dispon°vel !",3,1)
         ENDIF
      ENDIF
      EXIT
   ENDIF
   IF modo=4 // Consulta
      SETCOLOR(vcr)
      @ 23,00 SAY PADC("PageUp=Pr¢ximo Registro   PageDown=Registro Anterior   Esc=Retorna",80)
      SETCOLOR(vcn)
      INKEY(0)
      IF LASTKEY()=K_PGUP
         SKIP
         LOOP
      ELSEIF LASTKEY()=K_PGDN
         SKIP -1
         LOOP
      ELSEIF LASTKEY()=K_ESC
         EXIT
      ELSE
         mAjuda2:={;
         "PgUp        - Exibe o Pr¢ximo Registro",;
         "PgDn        - Exibe o Registro Anterior",;
         "Esc         - Volta Ö Tela de Consulta"}
         Ajuda2(mAjuda2)
         LOOP
      ENDIF
   ENDIF
   // Edita os Dados do Registro
   EditaCfop()
   IF LASTKEY()=K_ESC
      EXIT
   ENDIF
   IF !Confirme()
      LOOP
   ENDIF
   IF modo=1 // Inclus∆o
      SET ORDER TO 1
      GO TOP
      SEEK vcfop
      IF FOUND()
         Mensagem("Desculpe, CFOP J† Cadastrado !",5,1)
         LOOP
      ENDIF
      // Inclui um novo registro no arquivo.
      IF Adireg(10)
         UNLOCK
      ELSE
         Mensagem("Erro de Rede, Inclus∆o N∆o Efetuada!",3,1)
      ENDIF
   ENDIF
   // Atualiza o conte£do dos campos do registro com as vari†veis auxiliares.
   IF Bloqreg(10)
      AtualCfop()
      COMMIT
      UNLOCK
   ELSE
      Mensagem("O Registro N∆o Est† Dispon°vel !",3,1)
   ENDIF
   IF modo=1
      LOOP
   ENDIF
   EXIT
ENDDO
RETURN

********************************************************************************
PROCEDURE TelaCfop()
// Apresenta os t°tulos do arquivo na tela.
********************************************************************************
SETCOLOR(vcn)
//                    20        30        40        50        60        70        80
//           01234567890123456789012345678901234567890123456789012345678901234567890
@ 07,10 SAY "C¢digo_________: "
@ 09,10 SAY "T°tulo_________: "
@ 11,10 SAY "Contabilidade__: "
RETURN

********************************************************************************
PROCEDURE MostraCfop()
// Mostra os dados do arquivo na tela.
********************************************************************************
SETCOLOR(vcd)
@ 07,27 SAY vcfop  PICTURE "@R 9.999"
@ 09,27 SAY vnome  PICTURE "@!"
@ 11,27 SAY vcontab  PICTURE "@R 9999.99.99.999-9"
SETCOLOR(vcn)
RETURN

********************************************************************************
PROCEDURE EditaCfop()
// Edita os dados do arquivo atravÇs das vari†veis auxiliares.
********************************************************************************
@ 24,00 CLEAR
Aviso(24,"Digite os Dados do CFOP, ou <Esc> para Finalizar")
SETCOLOR(vcd)
@ 07,27 GET vcfop PICTURE "@R 9.999" VALID CadCFOP()
@ 09,27 GET vnome PICTURE "@!"
@ 11,27 GET vcontab PICTURE "@R 9999.99.99.999-9"
SETCOLOR(vcn)
Le()
IF LASTKEY()=K_ESC
   RETURN
ENDIF
RETURN

********************************************************************************
STATIC FUNCTION CadCFOP()
********************************************************************************
PRIVATE GetList:={}
IF vmodo>1
   vcfop:=Acha2(vcfop,"Nat",1,2,"cfop","nome","@R 9.999","@!",15,10,22,65,"C¢digo","Nome")
ENDIF
IF EMPTY(vcfop) .OR. LASTKEY()=K_ESC
   RETURN .F.
ENDIF
RETURN .T.

********************************************************************************
PROCEDURE TransfCfop()
// Transfere os dados dos campos do arquivo para respectivas as vari†veis
// auxiliares.
********************************************************************************
vcfop  :=Nat->cfop
vnome  :=Nat->nome
vcontab:=Nat->contab
RETURN

********************************************************************************
PROCEDURE AtualCfop()
// Atualiza os dados dos campos do arquivo com as variaveis auxiliares.
********************************************************************************
Nat->cfop  :=vcfop
Nat->nome  :=vnome
Nat->contab:=vcontab
RETURN

********************************************************************************
PROCEDURE RelCfop()
********************************************************************************
LOCAL ordatu,recatu
ordatu:=INDEXORD()
recatu:=RECNO()
// Atualiza a linha de status.
Sinal("CFOP","RELAT‡RIO")
IF !Imprime2("Relat¢rio de CFOPs")
   RETURN
ENDIF
SET DEVICE TO PRINTER
SET PRINTER TO &vcimpres
SET ORDER TO 1
DO WHILE vcop > 0
   pg:=0                   // Contador de p†ginas.
   GO TOP
   DO WHILE !EOF()
      // Impressao do cabeáalho.
      Cabe(vcnomeemp,vsist,"RELAT‡RIO DE CFOPS","Em Ordem de C¢digo",80,vcia10)
      // Impress∆o dos t°tulos
      @ PROW()+1, 00 SAY "C‡DIGO"
      @ PROW(),   10 SAY "DESCRIÄ«O DA NATUREZA DA OPERAÄ«O"
      @ PROW()+1, 00 SAY REPLICATE("-",80)
      // Impressao dos dados.
      DO WHILE PROW()<58 .AND. !EOF()
         IF Escprint(80)
            RETURN
         ENDIF
         // Imprime os dados do relat¢rio
         @ PROW()+1,00 SAY Nat->cfop PICTURE "@R 9.999"
         @ PROW(),  10 SAY Nat->nome //PICTURE "@!"
         SKIP
      ENDDO
   ENDDO  // Fim do DO WHILE principal.
   @ PROW()+2,0 SAY PADC(" Fim  do  Relat¢rio ",80,"=")
   EJECT
   --vcop
ENDDO
SET PRINTER TO
SET DEVICE TO SCREEN
IF vcporta="2" // tela
   Imprtela(vcimpres,80)
ENDIF
SELECT Nat
SET ORDER TO ordatu
GO recatu
RETURN


********************************************************************************
// ### ROTINAS DE CADASTRO DE TRANSPORTADORES
********************************************************************************
PROCEDURE ConsTrp()
// Consultas e Pesquisas aos Registros do Arquivo de Dados
********************************************************************************
LOCAL vdado[8],vmask[8],vcabe[8],vedit[8]
// Vari†veis para verificaá∆o de senha.
PRIVATE pv1:=pv2:=pv3:=pv4:=pv5:=.T.
// Carrega matriz
PRIVATE muf:=GeraMatriz((dirvm+"VM_CONFI.DBF"),"estados","ESTADOS")
// Abertura dos arquivos de dados
marqs:={{(dircad+"FC_TRANS.DBF"),"Trp","Transportadores",3}}
IF !AbreArqs(marqs,.F.)
   RETURN
ENDIF
SELECT Trp
// vdado: vetor dos nomes dos campos
vdado[01]:="codtp"
vdado[02]:="nome"
vdado[03]:="ende"
vdado[04]:="muni"
vdado[05]:="uf"
vdado[06]:="cic"
vdado[07]:="frete"
vdado[08]:="ddd+tel"
// vmask: vetor das m†scaras de apresentaá∆o dos dados.
vmask[01]:="99"
vmask[02]:="@!"
vmask[03]:="@!"
vmask[04]:="@!"
vmask[05]:="@!"
vmask[06]:="99999999999999"
vmask[07]:="9"
vmask[08]:="@R (X999)XX99-9999"
// vcabe: vetor dos t°tulos para o cabeáalho das colunas.
vcabe[01]:="C¢digo"
vcabe[02]:="Nome"
vcabe[03]:="Endereáo"
vcabe[04]:="Munic°pio"
vcabe[05]:="UF"
vcabe[06]:="CIC"
vcabe[07]:="Frete"
vcabe[08]:="Telefone"
// vedit: vetor com definiá∆o dos campos que podem ser editados.
AFILL(vedit,.F.)
// Informaá‰es para ajuda ao usu†rio.
majuda:={;
"Ins        - Inclui uma nova Transportadora no Sistema",;
"Ctrl+Enter - Altera a Transportadora sob Cursor",;
"Del        - Exclui a Transportadora sob Cursor",;
"Enter      - Consulta a Transportadora em Tela Cheia",;
"F2         - Pesquisa pelo C¢digo da Transportadora",;
"F3         - Pesquisa pelo nome da Transportadora",;
"F9         - Emite Relat¢rio de Transportadoras"}
// Construá∆o da Tela de Apresentaá∆o.
Sinal("TRANSP.","CONSULTA")
Abrejan(2)
@ 04,01 SAY REPLICATE("ƒ",78)
// Barra de Tarefas.
SETCOLOR(vcr)
@ 22,00 SAY PADC("Ins=Inclui Ctrl+Enter=Altera Del=Exclui Enter=Consulta Esc=Encerra",80)
@ 23,00 SAY PADC("F1=Ajuda  F2=C¢digo  F3=Nome  F9=Relat¢rio",80)
SETCOLOR(vcn)
// Chamada do procedimento de consulta desenvolvido com TBrowse.
ConsBrowse("Trp",05,01,21,78,vdado,vmask,vcabe,vedit,1,{|| OpsTrp()},;
           "codtp",1,"99",2 ,"C¢digo",;
           "nome" ,2,"@!",40,"Nome")
CLOSE DATABASE
RETURN

********************************************************************************
FUNCTION OpsTrp()
// Opá‰es da consulta de Transportadoras.
********************************************************************************
LOCAL vtela
// Destaque do browse
@ 03,03 CLEAR TO 03,77
@ 03,03 SAY "Transportadora:"
SETCOLOR(vcd)
@ 03,18 SAY Trp->codtp+"-"+Trp->nome
SETCOLOR(vcn)
// Teclas de opá‰es da consulta
IF LASTKEY()=K_INS
   // Ins - Inclus∆o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatTrp(1)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_CTRL_ENTER
   // Ctrl+Enter - Alteraá∆o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatTrp(2)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_DEL
   // Del - Exclus∆o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatTrp(3)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_ENTER
   // Enter - Consulta em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatTrp(4)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_F9
   // F9 - Relat¢rio.
   vtela:=SAVESCREEN(01,00,24,79)
   RelTrp()
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ENDIF
RETURN .F.

********************************************************************************
PROCEDURE MatTrp(modo)
/* Parametros: modo - operaá∆o a ser realizada: 1 - Inclus∆o
                                                2 - Alteraá∆o
                                                3 - Exclus∆o */
********************************************************************************
IF modo=1
   IF pv1
      IF !Senha("D1")
         RETURN
      ENDIF
      pv1:=.F.
   ENDIF
   Sinal("TRANSP.","INCLUS«O")
ELSEIF modo=2
   IF pv2
      IF !Senha("D2")
         RETURN
      ENDIF
      pv2:=.F.
   ENDIF
   Sinal("TRANSP.","ALTERAÄ«O")
ELSEIF modo=3
   IF pv3
      IF !Senha("D3")
         RETURN
      ENDIF
      pv3:=.F.
   ENDIF
   Sinal("TRANSP.","EXCLUS«O")
ENDIF
SELECT Trp
Abrejan(2)
DO WHILE .T.
   // Inicializaá∆o das vari†veis auxiliares.
   vcodtp  :=SPACE(02)  //  C¢digo do Transportador
   vnome   :=SPACE(40)  //  Nome do Transportador
   vende   :=SPACE(40)  //  Endereáo do Transportador
   vbair   :=SPACE(20)  //  Bairro do Transportador
   vuf     :=SPACE(02)  //  Estado do Transportador
   vmuni   :=SPACE(20)  //  Munic°pio do Transportador
   vfrete  :=SPACE(01)  //  Tipo de Frete
   vcic    :=SPACE(14)  //  CNPJ do Transportador
   vinsc   :=SPACE(14)  //  Inscriá∆o Estadual do Transportador
   vddd    :=SPACE(04)  //  DDD do Transportador
   vtel    :=SPACE(08)  //  Telefone do Transportador
   // Apresenta os t°tulos na tela
   TelaTrp()
   //
   IF modo=1 // Inclus∆o
      SET ORDER TO 1
      GO BOTTOM
      vcodtp:=STRZERO(VAL(Trp->codtp)+1,2)
   ENDIF
   //
   IF modo#1 // Se n∆o for Inclus∆o
      // Transfere os dados do registro para as vari†veis auxiliares.
      TransfTrp()
   ENDIF
   // Mostra os dados com as variaveis auxiliares
   MostraTrp()
   //
   IF modo=3 // Exclus∆o
      IF Exclui() // Deleta o registro do arquivo.
         IF Bloqreg(10)
            DELETE
            UNLOCK
         ELSE
            Mensagem("O Registro N∆o Est† Dispon°vel !",3,1)
         ENDIF
      ENDIF
      EXIT
   ENDIF
   IF modo=4 // Consulta
      SETCOLOR(vcr)
      @ 23,00 SAY PADC("PageUp=Pr¢ximo Registro   PageDown=Registro Anterior   Esc=Retorna",80)
      SETCOLOR(vcn)
      INKEY(0)
      IF LASTKEY()=K_PGUP
         SKIP
         LOOP
      ELSEIF LASTKEY()=K_PGDN
         SKIP -1
         LOOP
      ELSEIF LASTKEY()=K_ESC
         EXIT
      ELSE
         mAjuda2:={;
         "PgUp        - Exibe o Pr¢ximo Registro",;
         "PgDn        - Exibe o Registro Anterior",;
         "Esc         - Volta Ö Tela de Consulta"}
         Ajuda2(mAjuda2)
         LOOP
      ENDIF
   ENDIF
   // Edita os Dados do Registro
   EditaTrp()
   IF LASTKEY()=K_ESC
      EXIT
   ENDIF
   IF !Confirme()
      LOOP
   ENDIF
   IF modo=1 // Inclus∆o
      GO TOP
      SEEK vcodtp
      IF FOUND()
         Mensagem("Desculpe, Transportadora J† Cadastrada !",5,1)
         LOOP
      ENDIF
      // Inclui um novo registro no arquivo.
      IF Adireg(10)
         UNLOCK
      ELSE
         Mensagem("Erro de Rede, Inclus∆o N∆o Efetuada!",3,1)
      ENDIF
   ENDIF
   // Atualiza o conte£do dos campos do registro com as vari†veis auxiliares.
   IF Bloqreg(10)
      AtualTrp()
      COMMIT
      UNLOCK
   ELSE
      Mensagem("O Registro N∆o Est† Dispon°vel !",3,1)
   ENDIF
   IF modo=1
      LOOP
   ENDIF
   EXIT
ENDDO
RETURN

********************************************************************************
PROCEDURE TelaTrp()
// Apresenta os t°tulos do arquivo na tela.
********************************************************************************
/*
                 10        20        30        40        50        60        70        80
        012345678901234567890123456789012345678901234567890123456789012345678901234567890
@ 04,05 SAY "C¢digo:XX
@ 06,05 SAY "Nome:40XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
@ 08,05 SAY "Endereáo:40XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
@ 10,05 SAY "Bairro:20XXXXXXXXXXXXXXXXXX
@ 12,05 SAY "UF:XX  Munic°pio:20XXXXXXXXXXXXXXXXXX
@ 14,05 SAY "CPF/CNPJ:18.XXX.XXX/XXXX-XX  Inscriá∆o:18XXXXXXXXXXXXXXXX
@ 16,05 SAY "DDD:XXX  Telefone:XXXX-XXXX
*/
SETCOLOR(vcn)
@ 04,05 SAY "C¢digo:"
@ 06,05 SAY "Nome:"
@ 08,05 SAY "Endereáo:"
@ 10,05 SAY "Bairro:"
@ 12,05 SAY "UF:    Munic°pio:"
@ 14,05 SAY "CPF/CNPJ:                    Inscriá∆o:"
@ 16,05 SAY "DDD:     Telefone:"
@ 18,05 SAY "Frete:   (Por Conta: 1-Emitente e 2-Destinat†rio)"
RETURN

********************************************************************************
PROCEDURE MostraTrp()
// Mostra os dados do arquivo na tela.
********************************************************************************
SETCOLOR(vcd)
@ 04,12 SAY vcodtp   PICTURE "99"
@ 06,10 SAY vnome    PICTURE "@!"
@ 08,14 SAY vende    PICTURE "@!"
@ 10,12 SAY vbair    PICTURE "@!"
@ 12,08 SAY vuf      PICTURE "!!"
@ 12,22 SAY vmuni    PICTURE "@!"
Sayd(14,14,vcic,MaskCIC(vcic),18)
Sayd(14,44,vinsc,MaskIE(vuf,vinsc),18)
Sayd(16,09,vddd,"@R X999",4)
Sayd(16,23,vtel,"@R XX99-9999",9)
@ 18,11 SAY vfrete PICTURE "9"
SETCOLOR(vcn)
RETURN

********************************************************************************
PROCEDURE EditaTrp()
// Edita os dados do arquivo atravÇs das vari†veis auxiliares.
********************************************************************************
@ 24,00 CLEAR
Limpa(14,14,18)
Limpa(14,44,18)
Aviso(24,"Digite os Dados da Transportadora, ou <Esc> para Finalizar")
SETCOLOR(vcd)
@ 04,12 GET vcodtp   PICTURE "99"
@ 06,10 GET vnome    PICTURE "@!"
@ 08,14 GET vende    PICTURE "@!"
@ 10,12 GET vbair    PICTURE "@!"
@ 12,22 GET vmuni    PICTURE "@!"
@ 12,08 GET vuf      PICTURE "@!" VALID ASCAN(muf,vuf)>0
@ 14,14 GET vcic     PICTURE "99999999999999" VALID ValidaCIC(vcic,vuf)
@ 14,44 GET vinsc    PICTURE "99999999999999" VALID ValidaIE(vuf,vinsc,vcic)
@ 16,09 GET vddd     PICTURE "@R X999"    VALID Ddd(16,09)
@ 16,23 GET vtel     PICTURE "@R XX99-9999" VALID Telefone(16,23,"vtel")
@ 18,11 GET vfrete   PICTURE "9" VALID vfrete="1" .OR. vfrete="2"
SETCOLOR(vcn)
Le()
IF LASTKEY()=K_ESC
   RETURN
ENDIF
RETURN

********************************************************************************
PROCEDURE TransfTrp()
// Transfere os dados dos campos do arquivo para respectivas as vari†veis
// auxiliares.
********************************************************************************
vcodtp  :=Trp->codtp
vnome   :=Trp->nome
vende   :=Trp->ende
vbair   :=Trp->bair
vmuni   :=Trp->muni
vuf     :=Trp->uf
vcic    :=Trp->cic
vinsc   :=Trp->insc
vddd    :=Trp->ddd
vtel    :=Trp->tel
vfrete  :=Trp->frete
RETURN

********************************************************************************
PROCEDURE AtualTrp()
// Atualiza os dados dos campos do arquivo com as variaveis auxiliares.
********************************************************************************
Trp->codtp  :=vcodtp
Trp->nome   :=vnome
Trp->ende   :=vende
Trp->bair   :=vbair
Trp->muni   :=vmuni
Trp->uf     :=vuf
Trp->cic    :=vcic
Trp->insc   :=vinsc
Trp->ddd    :=vddd
Trp->tel    :=vtel
Trp->frete  :=vfrete
RETURN

********************************************************************************
PROCEDURE RelTrp()
********************************************************************************
LOCAL ordatu,recatu
ordatu:=INDEXORD()
recatu:=RECNO()
// Atualiza a linha de status.
Sinal("TRANSPORT.","RELAT‡RIO")
IF !Imprime2("Relat¢rio de Transportadoras")
   RETURN
ENDIF
SET DEVICE TO PRINTER
SET PRINTER TO &vcimpres
SET ORDER TO 1
DO WHILE vcop > 0
   pg:=0                   // Contador de p†ginas.
   GO TOP
   DO WHILE !EOF()
      // Impressao do cabeáalho.
      Cabe(vcnomeemp,vsist,"RELAT‡RIO DE TRANSPORTADORAS","Em Ordem de C¢digo",80,vcia10)
      // Impress∆o dos t°tulos
      @ PROW()+1, 00 SAY "C‡DIGO"
      @ PROW(),   10 SAY "NOME DA TRANSPORTADORA"
      @ PROW()+1, 00 SAY REPLICATE("-",80)
      // Impressao dos dados.
      DO WHILE PROW()<58 .AND. !EOF()
         IF Escprint(80)
            RETURN
         ENDIF
         // Imprime os dados do relat¢rio
         @ PROW()+1,00 SAY Trp->codtp PICTURE "99"
         @ PROW(),  10 SAY Trp->Nome
         SKIP
      ENDDO
   ENDDO  // Fim do DO WHILE principal.
   @ PROW()+2,0 SAY PADC(" Fim  do  Relat¢rio ",80,"=")
   EJECT
   --vcop
ENDDO
SET PRINTER TO
SET DEVICE TO SCREEN
IF vcporta="2" // tela
   Imprtela(vcimpres,80)
ENDIF
SELECT Trp
SET ORDER TO ordatu
GO recatu
RETURN

*******************************************************************************
//                                  F i m
*******************************************************************************



