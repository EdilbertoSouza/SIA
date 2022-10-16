********************************************************************************
/* Programa.: MG_CADA1.PRG
   Funá∆o...: M¢dulo de Cadastros Gerais
   Data.....: 05/06/02
   Autor....: Antonio J.M. Costa e Edilberto L. Souza */
********************************************************************************
#include "SIG.CH"
#include "SETCURS.CH"
#include "DBSTRUCT.CH"
********************************************************************************
// ### ROTINAS DE CADASTRO DE CLIENTES
********************************************************************************
/* Programa.: VM_CLIEN.PRG
   Sistema..: Controle de Vendas e Comissîes
   Autor....: Antonio J.M Costa
   Data.....: 28/08/1994
   Funá∆o...: Cadastro dos Clientes.                   */
********************************************************************************
PROCEDURE ConsCli()
// Consultas e Pesquisas aos Registros do Arquivo de Dados
********************************************************************************
LOCAL vdado[22],vmask[22],vcabe[22],vedit[22]
// Vari†veis para verificaá∆o de senha.
PRIVATE pv1:=pv2:=pv3:=pv4:=pv5:=.T.
// Carrega matrizes
muf     :=GeraMatriz((dirvm+"VM_CONFI.DBF"),"estados","ESTADOS")
mFormapg:=GeraMatriz((dirvm+"VM_CONFI.DBF"),"formapag","FORMAPAG")
mRotas  :=GeraMatriz((dirvm+"VM_CONFI.DBF"),"rotas","ROTAS")
mTipoIPI:=GeraMatriz((dirvm+"VM_CONFI.DBF"),"tipoipi","TIPOIPI")
// Abertura dos arquivos de dados
marqs:={;
{(dirvm+"VM_VEDOR.DBF"),"Ved","Vendedores",2},;
{(dirvm+"VM_DESCO.DBF"),"Desc","Descontos",1},;
{(dirvm+"VM_CLIEN.DBF"),"Cli","Clientes",5}}
IF !AbreArqs(marqs,.F.)
   RETURN
ENDIF
SELECT Cli
// vdado: vetor dos nomes dos campos
vdado[01]:="codcli"
vdado[02]:="nome"
vdado[03]:="cic"
vdado[04]:="fanta"
vdado[05]:="insc"
vdado[06]:="ende"
vdado[07]:="bair"
vdado[08]:="muni"
vdado[09]:="cep"
vdado[10]:="esta"
vdado[11]:="cont"
vdado[12]:="ddd"
vdado[13]:="tel"
vdado[14]:="tel2"
vdado[15]:="tel3"
vdado[16]:="fax"
vdado[17]:="data"
vdado[18]:="bloq"
vdado[19]:="tab"
vdado[20]:="codv"
vdado[21]:="obs1"
vdado[22]:="obs2"
//vdado[23]:="obs3"
// vcabe: vetor dos t°tulos para o cabeáalho das colunas.
vcabe[01]:="C¢digo"
vcabe[02]:="Raz∆o Social"
vcabe[03]:="CGC/CPF"
vcabe[04]:="Nome de Fantasia"
vcabe[05]:="Incriá∆o"
vcabe[06]:="Endereáo"
vcabe[07]:="Bairro"
vcabe[08]:="Munic°pio"
vcabe[09]:="CEP"
vcabe[10]:="Estado"
vcabe[11]:="Nome para Contato"
vcabe[12]:="DDD"
vcabe[13]:="Tel Trab"
vcabe[14]:="Tel Res"
vcabe[15]:="Tel Cont"
vcabe[16]:="Fax"
vcabe[17]:="Data"
vcabe[18]:="Bloq"
vcabe[19]:="Tab"
vcabe[20]:="Vend"
vcabe[21]:="Observaá‰es"
vcabe[22]:="-"
//vcabe[23]:="-"
// vmask: vetor das m†scaras de apresentaá∆o dos dados.
vmask[01]:="99999"
vmask[02]:="@!"
vmask[03]:="@X"
vmask[04]:="@!"
vmask[05]:="@X"
vmask[06]:="@!"
vmask[07]:="@!"
vmask[08]:="@!"
vmask[09]:="@R 99.999-999"
vmask[10]:="!!"
vmask[11]:="@!"
vmask[12]:="9999"
vmask[13]:="@R XX99-9999"
vmask[14]:="@R XX99-9999"
vmask[15]:="@R XX99-9999"
vmask[16]:="@R XX99-9999"
vmask[17]:="99/99/9999"
vmask[18]:="!"
vmask[19]:="9"
vmask[20]:="999"
vmask[21]:="@!"
vmask[22]:="@!"
//vmask[23]:="@!"
// vedit: vetor que determina os dados a serem editados.
AFILL(vedit,.F.)
// Informaá‰es para ajuda ao usu†rio.
mAjuda:={;
"Enter - Vis∆o do Cliente em Tela Cheia",;
"F3    - Pesquisa pelo C¢digo do Cliente",;
"F4    - Pesquisa pelo CNPJ/CPF do Cliente",;
"F5    - Pesquisa pela Raz∆o Social",;
"F6    - Pesquisa pelo Nome de Fantasia" }
// Construá∆o da Tela de Apresentaá∆o.
Sinal("CLIENTES","CONSULTA")
Abrejan(2)
@ 04,01 SAY REPLICATE("ƒ",78)
// Barra de Tarefas.
SETCOLOR(vcr)
@ 22,00 SAY PADC("Enter=Consulta  Esc=Encerra",80)
@ 23,00 SAY PADC("F1=Ajuda  F2=C¢digo  F3=CNPJ/CPF  F4=Raz∆o  F5=Fantasia",80)
SETCOLOR(vcn)
// Chamada do procedimento de consulta desenvolvido com TBrowse.
ConsBrowse("Cli",05,01,21,78,vdado,vmask,vcabe,vedit,1,{|| OpsCli()},;
           "codcli",1,"99999"         ,5  ,"C¢digo",;
           "cic"   ,2,"99999999999999",14 ,"CNPJ/CPF",;
           "nome"  ,3,"@!"            ,40 ,"Raz∆o",;
           "fanta" ,4,"@!"            ,20 ,"Fantasia")
CLOSE DATABASE
RETURN

********************************************************************************
FUNCTION OpsCli()
// Opá‰es da consulta de Clientes.
********************************************************************************
LOCAL vtela
// Destaque do browse
@ 03,03 CLEAR TO 03,77
@ 03,03 SAY "Cliente:"
SETCOLOR(vcd)
@ 03,11 SAY Cli->codcli+"-"+Cli->nome
SETCOLOR(vcn)
// Teclas de opá‰es da consulta
IF LASTKEY()=K_ENTER
   // Enter - Consulta em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   VisaoCli()
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ENDIF
RETURN .F.

********************************************************************************
PROCEDURE VisaoCli()
// Visualiza o Cliente em tela cheia.
*************************************
mAjuda2:={;
"PgUp  - Avanáa para o Pr¢ximo Registro",;
"PgDn  - Retorna para o Registro Anterior",;
"Esc   - Retorna a Tela Anterior"}
// Visualiza o registro
vcodcli:=SPACE(5)
vbloq  :=SPACE(1)
vrota  :=SPACE(02)
vnome  :=SPACE(40)
vtab   :=1
vfanta :=SPACE(20)
vcic   :=SPACE(14)
vende  :=SPACE(40)
vbair  :=SPACE(15)
vmuni  :=SPACE(20)
vesta  :=SPACE(02)
vcep   :=SPACE(08)
vddd   :=SPACE(04)
vlimite:=0
vdebito:=0
vfecha :=0
vtel   :=SPACE(08)
vtel2  :=SPACE(08)
vtel3  :=SPACE(08)
vfax   :=SPACE(08)
vemail :=SPACE(35)
vcont  :=SPACE(40)
vinsc  :=SPACE(12)
vdata  :=CTOD(SPACE(08))
vcodv  :=SPACE(03)
vobs1  :=SPACE(60)
vobs2  :=SPACE(60)
//vobs3  :=SPACE(60)
vtexto :=SPACE(10)
vtipoipi:=SPACE(01)
vformapg:=SPACE(30)
vtela :=SAVESCREEN(01,00,24,79)
Abrejan(2)
DO WHILE .T.
   SETCOLOR(vcn)
   TitulosCli(4)
   TransfCli()
   MostraCli()
   SETCOLOR(vcr)
   @ 23,00 SAY PADC("PgUp=Pr¢xReg  PgDown=RegAnt  Esc=Fim",80)
   SETCOLOR(vcn)
   INKEY(0)
   IF LASTKEY()=K_PGUP
      SKIP
   ELSEIF LASTKEY()=K_PGDN
      SKIP -1
   ELSEIF LASTKEY()=K_F1
      Ajuda2(mAjuda2)
   ELSEIF LASTKEY()=K_F3   // consulta campo memo
       vtitulo:=" FOLHA DE ALTERAÄÂES DE CLIENTE - CONSULTA "
       EditaTexto(vtexto,vtitulo,4)
   ELSEIF LASTKEY()=K_ESC
      EXIT
   ENDIF
ENDDO
RESTSCREEN(01,00,24,79,vtela)
RETURN

********************************************************************************
PROCEDURE TitulosCli(modo)
// Apresenta os t°tulos do arquivo na tela.
********************************************************************************
/*
          10        20        30        40        50        60        70
   234567890123456789012345678901234567890123456789012345678901234567890123456
03 C¢digo:XXXXX   Data do Cadastro:XX/XX/XXXX     Bloqueado:Xxx
04 Prazo para Fechamento de Contas:XX dias        Tabela:X XXXXXXXXXX
05 CPF/CNPJ:XXXXXXXXXXXXXX                        Rota:XX-XXXXXXXXXXXXXXX
06 Inscriá∆o Estadual:XXXXXXXXXXXXXX              Cep:XX.XXX-XXX
07 Nome de Fantasia:XXXXXXXXXXXXXXXXXXXX          Estado:XX  Ddd:XXXX
08 Raz∆o Social:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
09 Endereáo:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
10 Bairro:XXXXXXXXXXXXXXX                     Munic°pio:XXXXXXXXXXXXXXXXXXXX
11 Telefone do Serviáo:XXXX-XXXX              Telefone Residencial:XXXX-XXXX
12 Correio Eletrìnico:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX           Fax:XXXX-XXXX
13 Pessoa de Contato:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
14 Telefone do Contato:XXXX-XXXX
15 Vendedor Repons†vel:XXX XXXXXXXXXXXXXXXXXXXX
16 Limite de CrÇdito:XXX.XXX.XX               Saldo de CrÇdito:XXX.XXX.XX
17 Forma de Pagto dos DÇbitos:XXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
18 Forma de Pagamento do IPI:2 PARCIAL
19 Observaá‰es:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
20             XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
21 Folha de Alteraá‰es: Pressione <F4>
*/

SETCOLOR(vcn)
//                 10        20        30        40        50        60        70
//           234567890123456789012345678901234567890123456789012345678901234567890123456
@ 03,02 SAY "C¢digo:        Data do Cadastro:               Bloqueado:"
@ 04,02 SAY "Prazo para Fechamento de Contas:   dias        Tabela:"
@ 05,02 SAY "CPF/CNPJ:                                      Rota:"
@ 06,02 SAY "Inscriá∆o Estadual:                            Cep:"
@ 07,02 SAY "Nome de Fantasia:                              Estado:    Ddd:"
@ 08,02 SAY "Raz∆o Social:"
@ 09,02 SAY "Endereáo:"
@ 10,02 SAY "Bairro:                                   Munic°pio:"
@ 11,02 SAY "Telefone do Serviáo:                      Telefone Residencial:"
@ 12,02 SAY "Correio Eletrìnico:"
@ 13,02 SAY "Pessoa de Contato:"
@ 14,02 SAY "Telefone do Contato:                      Fax do Cliente:"
@ 15,02 SAY "Vendedor Repons†vel:"
@ 16,02 SAY "Limite de CrÇdito:                        Saldo de CrÇdito:"
@ 17,02 SAY "Forma de Pagto dos DÇbitos:"
@ 18,02 SAY "Forma de Pagamento do IPI:"
@ 19,02 SAY "Observaá‰es:"
@ 21,02 SAY "Folha de Alteraá‰es:"
SETCOLOR("GR/N")
IF modo=4
   @ 21,22 SAY "<F3=Mostra>"
ENDIF
SETCOLOR(vcn)
RETURN

********************************************************************************
PROCEDURE MostraCli()
// Mostra os dados do arquivo na tela.
********************************************************************************
SETCOLOR(vcd)
@ 03,09 SAY vcodcli PICTURE "99999"
@ 03,34 SAY vdata   PICTURE "99/99/9999"
@ 03,59 SAY IIF(vbloq="S","Sim","N∆o")
//
@ 04,34 SAY vfecha  PICTURE "99"
@ 04,56 SAY vtab    PICTURE "9"
Sayd(04,57,"-"+Tabela(vtab),"@!",15)
//
Sayd(05,11,vcic,MaskCIC(vcic),18)
//
@ 05,54 SAY vrota+"-"
Sayd(05,57,Rota(vrota),"@!",15)

@ 06,21 SAY vinsc   PICTURE "@!"
@ 06,53 SAY vcep    PICTURE "@R 99.999-999"

@ 07,19 SAY vfanta  PICTURE "@!"
@ 07,56 SAY vesta   PICTURE "@!"
@ 07,64 SAY vddd    PICTURE "9999"

@ 08,15 SAY vnome   PICTURE "@!"
@ 09,11 SAY vende   PICTURE "@!"

@ 10,09 SAY vbair   PICTURE "@!"
@ 10,54 SAY vmuni   PICTURE "@!"

Sayd(11,22,vtel,"@R XX99-9999",10)
Sayd(11,65,vtel2,"@R XX99-9999",10)

@ 12,21 SAY vemail  PICTURE "@X"
Sayd(14,59,vfax,"@R XX99-9999",10)

@ 13,20 SAY vcont   PICTURE "@!"
Sayd(14,22,vtel3,"@R XX99-9999",10)
@ 15,22 SAY vcodv+"-"
Sayd(15,26,Procura("Ved",1,vcodv,"ngv"),"@!",25)
Sayd(16,20,vlimite,"@E 999,999.99",12)

vdebito:=0
IF !EMPTY(vcodcli)
   vdebito:=PesqFinanc(vcodcli)
ENDIF
SETCOLOR(vcd)
Sayd(16,61,vlimite-vdebito,"@E 999,999.99",12)

@ 17,29 SAY vformapg+"-"
Sayd(17,35,FormaPg(vformapg),"@!",35)
@ 18,28 SAY vtipoipi+"-"
Sayd(18,30,TipoIPI(vtipoipi),"@!",15)

@ 19,14 SAY vobs1   PICTURE "@!"
@ 20,14 SAY vobs2   PICTURE "@!"
//@ 21,14 SAY vobs3   PICTURE "@!"
SETCOLOR(vcn)
RETURN

********************************************************************************
PROCEDURE EditaCli(modo)
// Edita os dados do arquivo atravÇs das vari†veis auxiliares.
********************************************************************************
SETCURSOR(IF(READINSERT(),SC_INSERT,SC_NORMAL))
//
SETCOLOR(vcd)
//
orota:=GetNew()
orota:row:=05;orota:col:=54
orota:name:="vrota";orota:picture:="99"
orota:block:={|valor| IF(PCOUNT()>0,vrota:=valor,vrota)}
orota:postBlock:={|valor| MenuRotas(vrota,05,57)}
//
obloq:=GetNew()
obloq:row:=03;obloq:col:=59
obloq:name:="vbloq";obloq:picture:="!"
obloq:block:={|valor| IF(PCOUNT()>0,vbloq:=valor,vbloq)}
obloq:postBlock:={|valor| Bloqueia() }
//
ocic:=GetNew()
ocic:row:=05;ocic:col:=11
ocic:name:="vcic";ocic:picture:="99999999999999"
ocic:block:={|valor| IF(PCOUNT()>0,vcic:=valor,vcic)}
ocic:postBlock:={|valor| PesqCIC(vesta,vcic,modo)}
//
ofecha:=GetNew()
ofecha:row:=04;ofecha:col:=34
ofecha:name:="vfecha";ofecha:picture:="99"
ofecha:block:={|valor| IF(PCOUNT()>0,vfecha:=valor,vfecha)}
ofecha:postBlock:={|valor| !EMPTY(vfecha)}
//
ofanta:=GetNew()
ofanta:row:=07;ofanta:col:=19
ofanta:name:="vfanta";ofanta:picture:="@!"
ofanta:block:={|valor| IF(PCOUNT()>0,vfanta:=valor,vfanta)}
//
otab:=GetNew()
otab:row:=04;otab:col:=56
otab:name:="vtab";otab:picture:="9"
otab:block:={|valor| IF(PCOUNT()>0,vtab:=valor,vtab)}
otab:postBlock:={|valor| PesqTab("vtab",4,58)}
//
onome:=GetNew()
onome:row:=08;onome:col:=15
onome:name:="vnome";onome:picture:="@!"
onome:block:={|valor| IF(PCOUNT()>0,vnome:=valor,vnome)}
//
oende:=GetNew()
oende:row:=09;oende:col:=11
oende:name:="vende";oende:picture:="@!"
oende:block:={|valor| IF(PCOUNT()>0,vende:=valor,vende)}
//
obair:=GetNew()
obair:row:=10;obair:col:=09
obair:name:="vbair";obair:picture:="@!"
obair:block:={|valor| IF(PCOUNT()>0,vbair:=valor,vbair)}
//
ocep:=GetNew()
ocep:row:=06;ocep:col:=53
ocep:name:="vcep";ocep:picture:="@R 99.999-999"
ocep:block:={|valor| IF(PCOUNT()>0,vcep:=valor,vcep)}
//
omuni:=GetNew()
omuni:row:=10;omuni:col:=54
omuni:name:="vmuni";omuni:picture:="@!"
omuni:block:={|valor| IF(PCOUNT()>0,vmuni:=valor,vmuni)}
//
oesta:=GetNew()
oesta:row:=07;oesta:col:=56
oesta:name:="vesta";oesta:picture:="!!"
oesta:block:={|valor| IF(PCOUNT()>0,vesta:=valor,vesta)}
oesta:postBlock:={|valor| ASCAN(mEstados,vesta)>0}
//
oddd:=GetNew()
oddd:row:=07;oddd:col:=64
oddd:name:="vddd";oddd:picture:="X999"
oddd:block:={|valor| IF(PCOUNT()>0,vddd:=valor,vddd)}
//
olimite:=GetNew()
olimite:row:=16;olimite:col:=20
olimite:name:="vlimite";olimite:picture:="@E 999,999.99"
olimite:block:={|valor| IF(PCOUNT()>0,vlimite:=valor,vlimite)}
olimite:postBlock:={|valor| vlimite>=0}
//
ocont:=GetNew()
ocont:row:=13;ocont:col:=20
ocont:name:="vcont";ocont:picture:="@!"
ocont:block:={|valor| IF(PCOUNT()>0,vcont:=valor,vcont)}
//
ofax:=GetNew()
ofax:row:=14;ofax:col:=59
ofax:name:="vfax";ofax:picture:="@R XX99-9999"
ofax:block:={|valor| IF(PCOUNT()>0,vfax:=valor,vfax)}
//
oemail:=GetNew()
oemail:row:=12;oemail:col:=21
oemail:name:="vemail";oemail:picture:="@X"
oemail:block:={|valor| IF(PCOUNT()>0,vemail:=valor,vemail)}
//
otel:=GetNew()
otel:row:=11;otel:col:=22
otel:name:="vtel";otel:picture:="@R XX99-9999"
otel:block:={|valor| IF(PCOUNT()>0,vtel:=valor,vtel)}
//
otel2:=GetNew()
otel2:row:=11;otel2:col:=65
otel2:name:="vtel2";otel2:picture:="@R XX99-9999"
otel2:block:={|valor| IF(PCOUNT()>0,vtel2:=valor,vtel2)}
//
otel3:=GetNew()
otel3:row:=14;otel3:col:=22
otel3:name:="vtel3";otel3:picture:="@R XX99-9999"
otel3:block:={|valor| IF(PCOUNT()>0,vtel3:=valor,vtel3)}
//
odata:=GetNew()
odata:row:=03;odata:col:=34
odata:name:="vdata";odata:picture:="99/99/9999"
odata:block:={|valor| IF(PCOUNT()>0,vdata:=valor,vdata)}
//
oinsc:=GetNew()
oinsc:row:=06;oinsc:col:=21
oinsc:name:="vinsc";oinsc:picture:="@!"
oinsc:block:={|valor| IF(PCOUNT()>0,vinsc:=valor,vinsc)}
//
ocodv:=GetNew()
ocodv:row:=15;ocodv:col:=22
ocodv:name:="vcodv";ocodv:picture:="999"
ocodv:block:={|valor| IF(PCOUNT()>0,vcodv:=valor,vcodv)}
//
oformapg:=GetNew()
oformapg:row:=17;oformapg:col:=29
oformapg:name:="vformapg";oformapg:picture:="99999"
oformapg:block:={|valor| IF(PCOUNT()>0,vformapg:=valor,vformapg)}
oformapg:postBlock:={|valor| ValFormaPg(1,"vformapg") }
//
otipoIPI:=GetNew()
otipoIPI:row:=18;otipoIPI:col:=28
otipoIPI:name:="vtipoIPI";otipoIPI:picture:="9"
otipoIPI:block:={|valor| IF(PCOUNT()>0,vtipoipi:=valor,vtipoipi)}
otipoIPI:postBlock:={|valor| MenuTipIPI(vtipoipi) }
//
oobs1:=GetNew()
oobs1:row:=19;oobs1:col:=14
oobs1:name:="vobs1";oobs1:picture:="@!"
oobs1:block:={|valor| IF(PCOUNT()>0,vobs1:=valor,vobs1)}
//
oobs2:=GetNew()
oobs2:row:=20;oobs2:col:=14
oobs2:name:="vobs2";oobs2:picture:="@!"
oobs2:block:={|valor| IF(PCOUNT()>0,vobs2:=valor,vobs2)}
//
//oobs3:=GetNew()
//oobs3:row:=21;oobs3:col:=14
//oobs3:name:="vobs3";oobs3:picture:="@!"
//oobs3:block:={|valor| IF(PCOUNT()>0,vobs3:=valor,vobs3)}
//
SETCOLOR(vcd)
@ 03,09 SAY vcodcli PICTURE "99999"
SETCOLOR(vcn)
READMODAL({odata,obloq,ofecha,otab,ocic,orota,oinsc,ofanta,onome,oende,;
           obair,omuni,ocep,otel,otel2,oesta,oddd,oemail,ocont,;
           otel3,ofax,ocodv,olimite,oformapg,otipoIPI,oobs1,oobs2})
//
@ 24,00 CLEAR
Aviso(24,"Deseja Editar a Folha de Alteraá‰es?")
IF Confirme()
   vtexto:=EditaTexto(vtexto,vtitulo,modo,03,02,22,77)
   IF LASTKEY()==K_ESC
      KEYBOARD(CHR(13))
      INKEY(0)
   ENDIF
ENDIF
//SETCURSOR(SC_NONE)
SETCURSOR(0)
SETCOLOR(vcn)
RETURN

**************************************************************************
FUNCTION MenuFormPg(pmatriz,pformapg,plin,pcol)
***********************************************
LOCAL vtela:=SAVESCREEN(01,00,24,79)
LOCAL vcursor:=SETCURSOR(0)
LOCAL i:=1
PRIVATE vli:=4,li:=1,vt:=0,lf:=17,tampa:=CHR(179),menulin:=03,menucol:=34
IF pformapg#NIL
   IF Mascan(pmatriz,1,pformapg) > 0
      vformapg:=pformapg
      SETCOLOR(vcn)
      @ plin,pcol SAY SPACE(32)
      SETCOLOR(vcd)
      @ plin,pcol SAY FormaPg(vformapg)
      SETCOLOR(vcn)
      SETCURSOR(vcursor)
      RETURN .T.
   ENDIF
ENDIF
IF LEN(pmatriz)<lf
   lf:=LEN(pmatriz)
ENDIF
Caixa(menulin,menucol,lf+5,73,frame[1])
// Apresenta a linha de orientaá∆o ao usu†rio.
SETCOLOR(vcr)
@ menulin+1,menucol+1 SAY PADC("OPÄÂES DE PAGAMENTO",38)
SETCOLOR(vcr)
@ 23,00 SAY PADC("Enter=Seleciona",80)
MostraPag(pmatriz,li,lf,vcn)
DO WHILE .T.
   SETCOLOR(vcp)
   @ vli+li,menucol SAY CHR(177)
   // Mostra o item selecionado.
   MostraPag(pmatriz,li,li,vca)
   // Aguarda o pressionamento de uma tecla de controle.
   tk:=INKEY(0)
   IF tk=K_ENTER
      vformapg:=pmatriz[li+vt,1]
      EXIT
   ELSEIF tk=K_UP
      // Seta para Cima: desloca para o item anterior.
      SETCOLOR(vcn)
      @ vli+li,menucol SAY tampa
      // Mostra o item.
      MostraPag(pmatriz,li,li,vcn)
      // Decrementa a linha dos itens.
      IF li>1
         --li
      ELSE
         // Realiza o rolamento da tela.
         IF vt>0
            --vt
            SCROLL(vli+1,menucol+1,lf+4,72,-1)
            // Mostra o item.
            MostraPag(pmatriz,li,li,vcn)
         ENDIF
      ENDIF
   ELSEIF tk=K_DOWN
      // Seta para Baixo: desloca para o item seguinte.
      SETCOLOR(vcn)
      @ vli+li,menucol SAY tampa
      // Mostra o item.
      MostraPag(pmatriz,li,li,vcn)
      // Incrementa a linha dos itens.
      IF li<lf
         ++li
      ELSE
         // Realiza o rolamento da tela.
         IF vt<(LEN(pmatriz)-(lf+4-vli)) .AND. !EMPTY(pmatriz[li+vt])
            ++vt
            SCROLL(vli+1,menucol+1,lf+4,72,1)
            // Mostra o item.
            MostraPag(pmatriz,li,li,vcn)
         ENDIF
      ENDIF
   ENDIF
ENDDO
RESTSCREEN(01,00,24,79,vtela)
SETCURSOR(vcursor)
IF plin#NIL
   SETCOLOR(vcn)
   @ plin,pcol SAY SPACE(32)
   SETCOLOR(vcd)
   @ plin,pcol SAY FormaPg(vformapg)
   SETCOLOR(vcn)
ENDIF
RETURN .T.

********************************************************************************
FUNCTION BrowFormPg(pmatriz,pformapg,chave,plin,pcol)
// Criada em 10/07/2000
**************************
LOCAL vtela:=SAVESCREEN(01,00,24,79)
LOCAL i:=1
PRIVATE vli:=4,li:=1,vt:=0,lf:=17,tampa:=CHR(179),menulin:=03,menucol:=34
IF pformapg#NIL
   IF Mascan(pmatriz,1,pformapg) > 0
      RETURN .T.
   ENDIF
ENDIF
IF LEN(pmatriz)<lf
   lf:=LEN(pmatriz)
ENDIF
Caixa(menulin,menucol,lf+5,74,frame[1])
// Apresenta a linha de orientaá∆o ao usu†rio.
SETCOLOR(vcr)
@ menulin+1,menucol+1 SAY PADC("OPÄÂES DE PAGAMENTO",35)
SETCOLOR(vcr)
@ 23,00 SAY PADC("Enter=Seleciona",80)
MostraPag(pmatriz,li,lf,vcn)
DO WHILE .T.
   SETCOLOR(vcp)
   @ vli+li,menucol SAY CHR(177)
   // Mostra o item selecionado.
   MostraPag(pmatriz,li,li,vca)
   // Aguarda o pressionamento de uma tecla de controle.
   tk:=INKEY(0)
   IF tk=K_ENTER
      &chave:=pmatriz[li+vt,1]
      EXIT
   ELSEIF tk=K_UP
      // Seta para Cima: desloca para o item anterior.
      SETCOLOR(vcn)
      @ vli+li,menucol SAY tampa
      // Mostra o item.
      MostraPag(pmatriz,li,li,vcn)
      // Decrementa a linha dos itens.
      IF li>1
         --li
      ELSE
         // Realiza o rolamento da tela.
         IF vt>0
            --vt
            SCROLL(vli+1,menucol+1,lf+4,73,-1) &&69
            // Mostra o item.
            MostraPag(pmatriz,li,li,vcn)
         ENDIF
      ENDIF
   ELSEIF tk=K_DOWN
      // Seta para Baixo: desloca para o item seguinte.
      SETCOLOR(vcn)
      @ vli+li,menucol SAY tampa
      // Mostra o item.
      MostraPag(pmatriz,li,li,vcn)
      // Incrementa a linha dos itens.
      IF li<lf
         ++li
      ELSE
         // Realiza o rolamento da tela.
         IF vt<(LEN(pmatriz)-(lf+4-vli)) .AND. !EMPTY(pmatriz[li+vt])
            ++vt
            SCROLL(vli+1,menucol+1,lf+4,73,1) &&69
            // Mostra o item.
            MostraPag(pmatriz,li,li,vcn)
         ENDIF
      ENDIF
   ENDIF
ENDDO
RESTSCREEN(01,00,24,79,vtela)
RETURN .T.

********************************************************************************
PROCEDURE MostraPag(mat,ni,nf,vcor)
/* Apresenta os itens de credenciamento.
   mat:  matriz de dados
   ni:   n£mero do item inicial.
   nf:   n£mero do item final.
   vcor: padr∆o de cor para apresentaá∆o dos itens.*/
******************************************************
LOCAL i
SETCOLOR(vcor)
FOR i=ni TO IIF(nf<22-vli,nf,21-vli)
    @ vli+i,menucol+1 SAY mat[i+vt,1]
    @ vli+i,menucol+7 SAY mat[i+vt,2]
NEXT
SETCOLOR(vcn)
RETURN

*****************************************************************************
FUNCTION Bloqueia()
*********************
IF !vbloq$"sSnN"
   RETURN .F.
ENDIF
vbloq:=UPPER(vbloq)
SETCOLOR(vcd)
Sayd(03,59,IF(vbloq$"sS","Sim","N∆o"),"@X",4)
SETCOLOR(vcn)
RETURN .T.

*****************************************************************************
PROCEDURE MenuTipIPI(pcod)
***************************
//mTipoIPI:={"TOTAL","PARCIAL","ISENTO"}
LOCAL op:=1,i:=1,linha:=7
LOCAL vtela:=SAVESCREEN(01,00,24,79)
IF !EMPTY(pcod)
   IF VAL(pcod) > 0 .AND. VAL(pcod) <= LEN(mTipoIPI)
      vtipoipi:=pcod
      SETCOLOR(vcd)
      Sayd(18,30,TipoIPI(vtipoipi),"@!",10)
      SETCOLOR(vcn)
      RETURN .T.
   ENDIF
ENDIF
DO WHILE .T.
   SETCOLOR(vcn)
   Caixa(05,33,LEN(mTipoIPI)+7,45,frame[6])
   @ 06,34 SAY PADC("Tipo IPI",10)
   SETCOLOR(vcn)
   i:=1
   DO WHILE i <= LEN(mTipoIPI)
      @ linha,34 PROMPT " "+mTipoIPI[i]+SPACE(10-LEN(mTipoIPI[i]))
      linha++
      i++
   ENDDO
   MENU TO op
   IF EMPTY(op) .OR. LASTKEY()==K_ESC
      RESTSCREEN(01,00,24,79,vtela)
      RETURN .F.
   ELSE
      EXIT
   ENDIF
ENDDO
RESTSCREEN(01,00,24,79,vtela)
vtipoipi:=STR(op,1)
SETCOLOR(vcd)
Sayd(19,30,TipoIPI(vtipoipi),"@!",10)
SETCOLOR(vcn)
RETURN .T.

******************************************************************************
PROCEDURE TipoIPI(pcod)
***********************
IF pcod="1"
   RETURN "TOTAL"
ELSEIF pcod="2"
   RETURN "PARCIAL"
ELSEIF pcod="3"
   RETURN "ISENTO"
ELSE
   RETURN SPACE(10)
ENDIF

*****************************************************************************
PROCEDURE FormaPg(pcod)
***********************
IF Mascan(mFormaPg,1,pcod) > 0
   RETURN mFormaPg[Mascan(mFormaPg,1,pcod),2]
ELSE
   RETURN SPACE(30)
ENDIF

******************************************************************************
FUNCTION ValFormaPg(pformapg)
// Valida vformapg
*****************************
LOCAL lFormaPg:=Procura("Cli",1,vcodcli,"formapg")
DO WHILE .T.
   MenuFormPg(mFormaPg,pformapg,09,25)
   IF vformapg==lFormaPg .OR. vformapg=="AV100"
      EXIT
   ELSE
      Mensagem("C¢digo v†lido: AV100, "+lFormaPg,3,1)
      LOOP
   ENDIF
ENDDO
RETURN .T.

**************************************************************************
STATIC FUNCTION CodVago()
*************************
LOCAL vcodigo:=SPACE(05)
@ 24,00 clear
SETCOLOR(vcp)
Aviso(24,"Pesquisando o Arquivo. Aguarde...")
SETCOLOR(vcn)
SELECT Cli
GO TOP
DO WHILE .T.
   vcodigo:=Cli->codcli
   SKIP
   IF EOF()
      GO BOTTOM
      vcodigo:=Cli->codcli
      EXIT
   ELSE
      IF VAL(Cli->codcli)<>VAL(vcodigo)+1
	 EXIT
      ENDIF
   ENDIF
ENDDO
@ 24,00 CLEAR
RETURN STRZERO(VAL(vcodigo)+1,5)

****************************************************************************
FUNCTION PesqTab(ptab,plin,pcol)
*******************************
LOCAL op:=1
LOCAL vtela:=SAVESCREEN(01,00,24,79)
IF EMPTY(&ptab)
   SETCOLOR(vcn)
   Caixa(09,43,14,54,frame[6])
   @ 10,44 SAY PADC("Tabelas",10)
   SETCOLOR(vcn)
   @ 11,44 PROMPT vctab1
   @ 12,44 PROMPT vctab2
   @ 13,44 PROMPT vctab3
   MENU TO op
   IF EMPTY(op)
      op:=1
   ENDIF
   &ptab:=op
   RESTSCREEN(01,00,24,79,vtela)
ENDIF
SETCOLOR(vcd)
Sayd(plin,pcol,Tabela(&ptab),"@!",10)
SETCOLOR(vcn)
RETURN .T.
********************************************************************************
PROCEDURE TransfCli()
// Transfere os dados do arquivo para as vari†veis auxiliares.
**************************************************************
vcodcli :=Cli->codcli
vrota   :=Cli->rota
vbloq   :=Cli->bloq
vnome   :=Cli->nome
vtab    :=Cli->tab
vfanta  :=Cli->fanta
vcic    :=Cli->cic
vende   :=Cli->ende
vbair   :=Cli->bair
vmuni   :=Cli->muni
vesta   :=Cli->esta
vcep    :=Cli->cep
vddd    :=Cli->ddd
vlimite :=Cli->limite
vfecha  :=Cli->fecha
vtel    :=Cli->tel
vtel2   :=Cli->tel2
vtel3   :=Cli->tel3
vfax    :=Cli->fax
vemail  :=Cli->email
vcont   :=Cli->cont
vinsc   :=Cli->insc
vdata   :=Cli->data
vcodv   :=Cli->codv
vtipoipi:=Cli->tipoipi
vformapg:=Cli->formapg
vobs1   :=Cli->obs1
vobs2   :=Cli->obs2
//vobs3   :=Cli->obs3
RETURN
********************************************************************************
PROCEDURE AtualCli()
// Atualiza os dados dos campos do arquivo com as variaveis auxiliares.
********************************************************************************
Cli->nome   :=vnome
Cli->bloq   :=vbloq
Cli->cic    :=vcic
Cli->rota   :=vrota
Cli->fanta  :=vfanta
Cli->tab    :=vtab
Cli->ende   :=vende
Cli->bair   :=vbair
Cli->muni   :=vmuni
Cli->esta   :=vesta
Cli->cep    :=vcep
Cli->ddd    :=vddd
Cli->limite :=vlimite
Cli->fecha  :=vfecha
Cli->tel    :=vtel
Cli->tel2   :=vtel2
Cli->tel3   :=vtel3
Cli->fax    :=vfax
Cli->email  :=vemail
Cli->cont   :=vcont
Cli->insc   :=vinsc
Cli->data   :=vdata
Cli->codv   :=vcodv
Cli->tipoipi:=vtipoipi
Cli->formapg:=vformapg
Cli->obs1   :=vobs1
Cli->obs2   :=vobs2
//Cli->obs3 :=vobs3
RETURN

**************************************************************************
FUNCTION MenuTab(ptab)
************************
LOCAL op:=1
LOCAL vtela:=SAVESCREEN(01,00,24,79)
IF ptab<>0
   RETURN ptab
ENDIF
SETCOLOR(vcf)
Caixa(09,43,14,54,frame[6])
@ 10,44 SAY PADC("Tabelas",10)
SETCOLOR(vcn)
@ 11,44 PROMPT vctab1
@ 12,44 PROMPT vctab2
@ 13,44 PROMPT vctab3
MENU TO op
IF op<1 .AND. op>3
   op:=1
ENDIF
RESTSCREEN(01,00,24,79,vtela)
RETURN op

******************************************************************************
FUNCTION Tabela(ptab)
***********************
LOCAL pntab
IF ptab=1
   pntab:=vctab1
ELSEIF ptab=2
   pntab:=vctab2
ELSEIF ptab=3
   pntab:=vctab3
ELSE
   pntab:=vctab1
   vtab :=1
ENDIF
RETURN pntab+SPACE(10-LEN(pntab))

******************************************************************************
FUNCTION MenuRotas(prota,plin,pcol)
**********************************
LOCAL op:=1,i:=1,linha:=7
LOCAL vtela:=SAVESCREEN(01,00,24,79)
IF prota#NIL
   IF VAL(prota) > 0 .AND. VAL(prota) <= LEN(mrotas)
      IF plin#NIL
         SETCOLOR(vcd)
         Sayd(plin,pcol,Rota(vrota),"@!",15)
         SETCOLOR(vcn)
      ENDIF
      RETURN .T.
   ENDIF
ENDIF
DO WHILE .T.
   SETCOLOR(vcn)
   Caixa(05,43,LEN(mrotas)+7,63,frame[6])
   @ 06,44 SAY PADC("Rotas",18)
   SETCOLOR(vcn)
   i:=1
   DO WHILE i <= LEN(mRotas)
      @ linha,44 PROMPT " "+STRZERO(i,2)+"-"+mRotas[i]+SPACE(15-LEN(mRotas[i]))
      linha++
      i++
   ENDDO
   MENU TO op
   IF EMPTY(op) .OR. LASTKEY()==K_ESC
      RESTSCREEN(01,00,24,79,vtela)
      RETURN .F.
   ELSE
      EXIT
   ENDIF
ENDDO
RESTSCREEN(01,00,24,79,vtela)
vrota:=STRZERO(op,2)
IF plin#NIL
   SETCOLOR(vcd)
   Sayd(plin,pcol,Rota(vrota),"@!",15)
   SETCOLOR(vcn)
ENDIF
RETURN .T.

******************************************************************************
FUNCTION Rota(prota)
*********************
IF EMPTY(prota)
   RETURN SPACE(15)
ENDIF
RETURN mrotas[VAL(prota)]

******************************************************************************
FUNCTION PesqFinanc(pcod)
// Pesquisa o saldo devedor do cliente: pcod - c¢digo do cliente
*********************************************************************
LOCAL valor:=0
LOCAL vtela:=SAVESCREEN(01,00,24,79)
LOCAL area:=SELECT()
//
SETCOLOR(vcp)
@ 20,01 SAY SPACE(78)
@ 21,01 SAY SPACE(78)
@ 22,01 SAY SPACE(78)
Aviso(21,"Pesquisando DÇbitos do Cliente. Aguarde...")
SETCOLOR(vcn)
//
// Arquivo de Pedidos
IF Abrearq((dirvm+"VM_PEDID.DBF"),"Ped",.F.,10)
   SET INDEX TO (dirvm+"VM_PEDI2")  // codcli
   SELECT Ped
   SEEK pcod
   IF FOUND()
      DO WHILE Ped->codcli=pcod .AND. !EOF()
         IF EMPTY(Ped->datapg) .AND. (LEFT(Ped->nupd,1)=vcloja .OR. LEFT(Ped->nupd,2)="M0")
            valor+=Ped->valor*(1-Ped->txd)+Ped->valipi
         ENDIF
         SKIP
      ENDDO
   ENDIF
   CLOSE Ped
ELSE
   Mensagem("O Arquivo de Pedidos N∆o Est† Dispon°vel!",4,1)
ENDIF
//
// Arquivo de Contas a Receber
IF Abrearq((dirmov+"WM_CTREC.DBF"),"Cr",.F.,10)
   SET INDEX TO (dirmov+"WM_CTRE9")  // codcli+DTOS(venc)
   SELECT Cr
   SEEK pcod
   IF FOUND()
      DO WHILE Cr->codcli=pcod .AND. !EOF()
         valor+=Cr->valor
         SKIP
      ENDDO
   ENDIF
   CLOSE Cr
ELSE
   Mensagem("O Arquivo de Contas a Receber N∆o Est† Dispon°vel!",4,1)
ENDIF
//
// Arquivo de dep¢sitos de clientes
IF Abrearq((dirvm+"VM_DEPOS.DBF"),"Depo",.F.,10)
   SET INDEX TO (dirvm+"VM_DEPO2")  // codcli
   SELECT Depo
   SEEK pcod
   IF FOUND()
      DO WHILE Depo->codcli=pcod .AND. !EOF()
         IF Depo->valor-Depo->descto > 0
            valor-=(Depo->valor-Depo->descto)
         ENDIF
         SKIP
      ENDDO
   ENDIF
   CLOSE Depo
ELSE
   Mensagem("O Arquivo de Dep¢sitos N∆o Est† Dispon°vel!",4,1)
ENDIF
//
@ 24,00 CLEAR
RESTSCREEN(01,00,24,79,vtela)
SELECT (area)
RETURN valor

******************************************************************************
PROCEDURE PosFinanc1()
// Imprime a posiá∆o financeira do cliente.
**********************************************
LOCAL mcli:={},j,i,sai,lin,col,vcodcli
Sinal("CLIENTES","RELAT‡RIO")
//
IF Abrearq((dirvm+"VM_CLIEN.DBF"),"Cli",.F.,10)
   SET INDEX TO (dirvm+"VM_CLIE1"),(dirvm+"VM_CLIE3")
ELSE
   Mensagem("O Arquivo de Clientes N∆o Est† Dispon°vel!",3,1)
   RETURN
ENDIF
//
IF Abrearq((dirvm+"VM_PEDID.DBF"),"Ped",.F.,10)
   SET INDEX TO (dirvm+"VM_PEDI2")  // codcli
ELSE
   Mensagem("O Arquivo de Pedidos N∆o Est† Dispon°vel!",3,1)
   CLOSE DATABASE
   RETURN
ENDIF
//
// Contas a Receber
IF Abrearq((dirmov+"WM_CTREC.DBF"),"Cr",.F.,10)
   SET INDEX TO (dirmov+"WM_CTRE9")  // codcli+DTOS(venc)
ELSE
   Mensagem("O Arquivo de Contas a Receber N∆o Est† Dispon°vel!",4,1)
   CLOSE DATABASE
   RETURN
ENDIF
//
IF Abrearq((dirvm+"VM_DEPOS.DBF"),"Depo",.F.,10)
   SET INDEX TO (dirvm+"VM_DEPO2")  // codcli
ELSE
   Mensagem("O Arquivo de Dep¢sitos N∆o Est† Dispon°vel!",4,1)
   CLOSE DATABASE
   RETURN
ENDIF
//
Abrejan(2)
SETCOLOR(vcn)
@ 14,10 SAY "Clientes: "
SELECT Cli
DO WHILE .T.
   @ 24,00 CLEAR
   i:=1
   lin:=15
   col:=10
   DO WHILE i<=40
      j:=1
      DO WHILE j<=10
         vcodcli:=SPACE(5)
         sai:=.F.
         Aviso(24,"Tecle <Esc> Para Sair")
         @ lin,col GET vcodcli PICTURE "99999"
         Le()
         vcodcli:=Zeracod(vcodcli)
         IF LASTKEY()=K_ESC
            sai:=.T.
            EXIT
         ENDIF
         vcodcli:=Acha2(vcodcli,"Cli",1,2,"codcli","fanta","99999","@!",15,15,22,60,"C¢digo","Nome de Fantasia")
         //
         IF EMPTY(vcodcli)
            LOOP
         ENDIF
         //
         IF Mascan(mcli,1,vcodcli)>0
            Mensagem("Cliente J† Foi Selecionado !",3,1)
            LOOP
         ENDIF
         //
         AADD(mcli,{;
              vcodcli,;
              Cli->nome,;
              Cli->limite,;
              Cli->fecha,;
              0,0,0,0,Cli->bloq})
         //
         SETCOLOR(vcr)
         @ lin, col SAY vcodcli PICTURE "99999"
         SETCOLOR(vcn)
         col+=6
         j++
         i++
      ENDDO
      IF sai
         sai:=.F.
         EXIT
      ENDIF
      lin+=2
      col:=10
   ENDDO
   IF Confirme()
      EXIT
   ENDIF
ENDDO
ASORT(mcli,,,{|x,y| x[1] < y[1]})
@ 24,00 CLEAR
SETCOLOR(vcp)
Aviso(24,"Pesquisando Dados. Aguarde...")
SETCOLOR(vcn)
//
/* CR da Fluxus
SELECT Crf
i:=1
DO WHILE i<=LEN(mcli)
   SEEK mcli[i,1]
   IF FOUND()
      DO WHILE Crf->codcli_cr=mcli[i,1] .AND. !EOF()
         IF DATE()-Crf->datven_cr > 2    // atrasada
            mcli[i,7]+=Crf->valnom_cr
         ELSE
            mcli[i,8]+=Crf->valnom_cr    // andamento
         ENDIF
         SKIP
      ENDDO
   ENDIF
   i++
ENDDO
*/
// Arquivo de Contas a Receber
SELECT Cr
i:=1
DO WHILE i<=LEN(mcli)
   SEEK mcli[i,1]
   IF FOUND()
      DO WHILE Cr->codcli=mcli[i,1] .AND. !EOF()
         IF DATE()-Cr->venc > 2    // atrasada
            mcli[i,7]+=Cr->valor
         ELSE
            mcli[i,8]+=Cr->valor   // andamento
         ENDIF
         SKIP
      ENDDO
   ENDIF
   i++
ENDDO
//
// Pedidos
SELECT Ped
i:=1
DO WHILE i<=LEN(mcli)
   SEEK mcli[i,1]
   IF FOUND()
      DO WHILE Ped->codcli=mcli[i,1] .AND. !EOF()
         IF EMPTY(Ped->datapg) .AND. (LEFT(Ped->nupd,1)=vcloja .OR. LEFT(Ped->nupd,2)="M0")
            IF !EMPTY(Ped->dataret)
               IF DATE()-Ped->dataret > mcli[i,4]    // atrasado
                  mcli[i,5]+=(Ped->valor*(1-Ped->txd)+Ped->valipi)
               ELSE                                  // andamento
                  mcli[i,6]+=(Ped->valor*(1-Ped->txd)+Ped->valipi)
               ENDIF
            ELSE                                     // andamento
               mcli[i,6]+=(Ped->valor*(1-Ped->txd)+Ped->valipi)
            ENDIF
         ENDIF
         SKIP
      ENDDO
   ENDIF
   i++
ENDDO
//
// Dep¢sitos de Clientes
SELECT Depo
i:=1
DO WHILE i<=LEN(mcli)
   SEEK mcli[i,1]
   IF FOUND()
      DO WHILE Depo->codcli=mcli[i,1] .AND. !EOF()
         IF Depo->valor-Depo->descto > 0
            mcli[i,3]+=(Depo->valor-Depo->descto)
         ENDIF
         SKIP
      ENDDO
   ENDIF
   i++
ENDDO
@ 24,00 CLEAR
//
CLOSE DATABASE
SETCOLOR(vcn)
IF !Imprime2("Posiá∆o Financeira de Clientes")
   RETURN
ENDIF
pg:=0
SET DEVICE TO PRINTER
SET PRINTER TO &vcimpres
i:=1
DO WHILE i<=LEN(mcli)
   Cabe(vcnomeemp,vsist,;
        "POSIÄ«O FINANCEIRA DE CLIENTES","Pesquisa no "+;
        "Arquivo de CR, Dep¢sitos e Pedidos",80,vcia15)

   //                          10        20        30        40        50        60        70        80        90       100       110       120       130
   //                 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345
   @ PROW()+1,00 SAY "CLIENTE                                 PED_ATRASADOS   PED_ANDAMENTO   CR_ATRASADAS   CR_ANDAMENTO  LIMITE_CRêDITO          SALDO  BLOQ"
   //                "XXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  X.XXX.XXX,XX    X.XXX.XXX,XX   X.XXX.XXX,XX   X.XXX.XXX,XX    X.XXX.XXX,XX   X.XXX.XXX,XX  Xxx

   DO WHILE PROW()<58 .AND. i<=LEN(mcli)
      IF !EMPTY(mcli[i,5]) .OR. !EMPTY(mcli[i,6]) .OR. !EMPTY(mcli[i,7]) .OR. !EMPTY(mcli[i,8])
         @ PROW()+1,00 SAY mcli[i,1]+"-"+LEFT(ALLTRIM(mcli[i,2]),33)
         @ PROW(),  41 SAY TRANSFORM(mcli[i,05],"@E 9,999,999.99")  // ped vm atrasados
         @ PROW(),  57 SAY TRANSFORM(mcli[i,06],"@E 9,999,999.99")  // ped vm andamento
         @ PROW(),  72 SAY TRANSFORM(mcli[i,07],"@E 9,999,999.99")  // cr atrasados
         @ PROW(),  87 SAY TRANSFORM(mcli[i,08],"@E 9,999,999.99")  // cr andamento
         @ PROW(), 103 SAY TRANSFORM(mcli[i,03],"@E 9,999,999.99")  // limite

         @ PROW(), 118 SAY TRANSFORM(mcli[i,03]-mcli[i,05]-mcli[i,06]-mcli[i,07]-mcli[i,8],"@E 9,999,999.99")  // saldo
         @ PROW(), 132 SAY IIF(mcli[i,9]=="S","Sim","")
      ENDIF
      i++
   ENDDO
   SET PRINT ON
   ?? vcid10
   SET PRINT OFF
ENDDO
//@ PROW()+1,00 SAY vcia15+REPLICATE("-",135)
@ PROW()+2,0 SAY vcid10+vcia10+PADC(" Fim do Relat¢rio ",80,"=")
EJECT
//Descarga()
SET PRINTER TO
SET DEVICE TO SCREEN
IF vcporta="2" // tela
   Imprtela(vcimpres,160)
ENDIF
RETURN

******************************************************************************
PROCEDURE PosFinanc2()
/* Imprime a posiá∆o financeira de clientes com
   mÇdia ponderada de atraso individual ordenado por vendedor. */
*****************************************************************
LOCAL mCli:={},j,i
Sinal("CLIENTES","RELAT‡RIO")
//
IF Abrearq((dirvm+"VM_CLIEN.DBF"),"Cli",.F.,10)
   SET INDEX TO (dirvm+"VM_CLIE1") // codcli
ELSE
   Mensagem("O Arquivo de Clientes N∆o Est† Dispon°vel!",3,1)
   RETURN
ENDIF
//
IF Abrearq((dirvm+"VM_PEDID.DBF"),"Ped",.F.,10)
   SET INDEX TO (dirvm+"VM_PEDI2")  // codcli
ELSE
   Mensagem("O Arquivo de Pedidos N∆o Est† Dispon°vel!",3,1)
   CLOSE DATABASE
   RETURN
ENDIF
//
// Contas a Receber
IF Abrearq((dirmov+"WM_CTREC.DBF"),"Cr",.F.,10)
   SET INDEX TO (dirmov+"WM_CTRE9")  // codcli+DTOS(venc)
ELSE
   Mensagem("O Arquivo de Contas a Receber N∆o Est† Dispon°vel!",4,1)
   CLOSE DATABASE
   RETURN
ENDIF
//
IF Abrearq((dirvm+"VM_VEDOR.DBF"),"Ved",.F.,10)
   SET INDEX TO (dirvm+"VM_VEDO1"),(dirvm+"VM_VEDO2")
ELSE
   Mensagem("O Arquivo de Vendedores N∆o Est† Dispon°vel !",3,1)
   RETURN
ENDIF
//
Abrejan(2)
SETCOLOR(vcp)
Aviso(24,"Selecionando Clientes. Aguarde...")
SETCOLOR(vcn)
//
SELECT Cli
//
DO WHILE !EOF()
   @ 10,05 SAY "Arquivo de Clientes: "+Cli->codcli
   //
   AADD(mcli,{;
   Cli->codcli,;
   Cli->nome,;
   Cli->limite,;
   Cli->fecha,;
   0,0,0,Cli->bloq,0,0,Cli->codv})
   SKIP
   @ 10,05 SAY "Arquivo de Cliente: "+SPACE(10)
ENDDO
ASORT(mcli,,,{|x,y| x[11] < y[11] } )
//
@ 24,00 CLEAR
SETCOLOR(vcp)
Aviso(24,"Selecionando Registros. Aguarde...")
SETCOLOR(vcn)
//
// CR da Fluxus
/*
SELECT Crf
i:=1
DO WHILE i<=LEN(mCli)
   GO TOP
   SEEK mCli[i,1]
   IF FOUND()
      DO WHILE Crf->codcli_cr=mCli[i,01] .AND. !EOF()
         @ 12,05 SAY "Arquivo da Fluxus: "+Crf->codcli_cr //+SPACE(10)
         //
         IF DATE()-Crf->datven_cr > 2    // atrasada
            mCli[i,06]+=Crf->valnom_cr
            mCli[i,09]+=Crf->valnom_cr*(DATE()-Crf->datven_cr+2)
            mCli[i,10]+=Crf->valnom_cr
         ELSE
            mCli[i,07]+=Crf->valnom_cr    // andamento
         ENDIF
         SKIP
         @ 12,05 SAY "Arquivo da Fluxus: "+SPACE(10)
      ENDDO
   ENDIF
   i++
ENDDO
*/
// Arquivo de Contas a Receber
//
SELECT Cr
i:=1
DO WHILE i<=LEN(mCli)
   GO TOP
   SEEK mCli[i,1]
   IF FOUND()
      DO WHILE Cr->codcli=mCli[i,01] .AND. !EOF()
         @ 12,05 SAY "Arquivo de Contas a Receber: "+Cr->codcli
         //
         IF DATE()-Cr->venc > 2    // atrasada
            mCli[i,06]+=Cr->valor
            mCli[i,09]+=Cr->valor*(DATE()-Cr->venc+2)
            mCli[i,10]+=Cr->valor
         ELSE
            mCli[i,07]+=Cr->valor  // andamento
         ENDIF
         SKIP
         @ 12,05 SAY "Arquivo de Contas a Receber: "+SPACE(10)
      ENDDO
   ENDIF
   i++
ENDDO
//
// Vidro comum
//
SELECT Ped
i:=1
DO WHILE i<=LEN(mCli)
   GO TOP
   SEEK mCli[i,1]
   IF FOUND()
      DO WHILE Ped->codcli=mCli[i,1] .AND. !EOF()
         @ 14,05 SAY "Arquivo de Pedidos: "+Ped->codcli //+SPACE(10)
         //
         IF EMPTY(Ped->datapg) .AND. (LEFT(Ped->nupd,1)=vcloja .OR. LEFT(Ped->nupd,2)="M0")
            IF !EMPTY(Ped->dataret)
               IF DATE()-Ped->dataret > mCli[i,04]    // atrasado
                  mCli[i,05]+=(Ped->valor*(1-Ped->txd)+Ped->valipi)
                  //
                  mCli[i,09]+=(Ped->valor*(1-Ped->txd)+Ped->valipi)*(DATE()-Ped->dataret+mCli[i,4])
                  mCli[i,10]+=(Ped->valor*(1-Ped->txd)+Ped->valipi)
               ELSE                                  // andamento
                  mCli[i,07]+=(Ped->valor*(1-Ped->txd)+Ped->valipi)
               ENDIF
            ELSE                                     // andamento
               mCli[i,07]+=(Ped->valor*(1-Ped->txd)+Ped->valipi)
            ENDIF
         ENDIF
         SKIP
         @ 14,05 SAY "Arquivo de Pedidos: "+SPACE(10)
      ENDDO
   ENDIF
   i++
ENDDO
@ 24,00 CLEAR
//CLOSE DATABASE
SETCOLOR(vcn)
IF !Imprime2("Posiá∆o Financeira de Clientes")
   RETURN
ENDIF
SET DEVICE TO PRINTER
SET PRINTER TO &vcimpres
//
pg      :=0
i       :=1
vPedCli :=0
vCrCli  :=0
vTotPed :=0
vTotCr  :=0
codatual:=mCli[i,11]
//
DO WHILE i<=LEN(mCli)
   Cabe(vcnomeemp,vsist,;
        "POSIÄ«O FINANCEIRA DE CLIENTES","Pesquisa Realizada no "+;
        "Arquivo de CR e Pedidos",80,vcia15)

   //                          10        20        30        40        50        60        70        80        90       100       110       120       130
   //                 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345
   @ PROW()+1,00 SAY "CLIENTE                                        PED_ATRASADOS      CR_ATRASADAS     M_ATRASO   LIMITE_CRêDITO         SALDO   BLOQ"
   //                "XXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  X.XXX.XXX,XX      X.XXX.XXX,XX     X.XXX,XX     X.XXX.XXX,XX    XXX.XXX,XX   Xxx

   DO WHILE PROW()<58 .AND. i<=LEN(mCli)
      IF Escprint(80)
         CLOSE DATABASE
         RETURN
      ENDIF
      //
      IF !EMPTY(mCli[i,5]) .OR. !EMPTY(mCli[i,6])
         @ PROW()+1,00 SAY mCli[i,01]+"-"+mCli[i,02]
         @ PROW(),  48 SAY TRANSFORM(mCli[i,05],"@E 9,999,999.99")  // ped vm atrasados
         @ PROW(),  66 SAY TRANSFORM(mCli[i,06],"@E 9,999,999.99")  // cr atrasados
         @ PROW(),  83 SAY TRANSFORM(mCli[i,09]/mCli[i,10],"@E 9,999.99")  // m_atraso
         @ PROW(),  96 SAY TRANSFORM(mCli[i,03],"@E 9,999,999.99")  // limite
         @ PROW(), 110 SAY TRANSFORM(mCli[i,03]-mCli[i,05]-mCli[i,06]-mCli[i,07],"@E 9,999,999.99")  // saldo
         @ PROW(), 125 SAY IIF(mCli[i,8]=="S","Sim","")
         vPedCli+=mCli[i,05]
         vCrCli +=mCli[i,06]
         vTotPed+=mCli[i,05]
         vTotCr +=mCli[i,06]
      ENDIF
      //
      i++
      IF i <= LEN(mCli)
         IF !mCli[i,11]==codatual
            @ PROW()+1,00 SAY REPLICATE("-",135)
            @ PROW()+1,00 SAY PADR("Totais do Vendedor: "+mCli[i-1,11]+"-"+ALLTRIM(Procura("Ved",1,mCli[i-1,11],"Ved->ngv")),45 ,".")
            @ PROW(),  48 SAY TRANSFORM(vPedCli,"@E 9,999,999.99")  // ped vm atrasados
            @ PROW(),  66 SAY TRANSFORM(vCrCli,"@E 9,999,999.99")  // cr atrasados
            @ PROW()+1,00 SAY REPLICATE("-",135)
            codatual:=mCli[i,11]
            vPedCli:=0
            vCrCli :=0
         ENDIF
      ELSE
         @ PROW()+1,00 SAY REPLICATE("-",135)
         @ PROW()+1,00 SAY PADR("Totais do Vendedor: "+mCli[i-1,11]+"-"+ALLTRIM(Procura("Ved",1,mCli[i-1,11],"Ved->ngv")),45 ,".")
         @ PROW(),  48 SAY TRANSFORM(vPedCli,"@E 9,999,999.99")  // ped vm atrasados
         @ PROW(),  66 SAY TRANSFORM(vCrCli,"@E 9,999,999.99")  // cr atrasados
         @ PROW()+1,00 SAY REPLICATE("-",135)
      ENDIF
   ENDDO
   //
   SET PRINT ON
   ?? vcid10+vcia10
   SET PRINT OFF
ENDDO
SET PRINT ON
?? vcia15
SET PRINT OFF
@ PROW()+1,00 SAY REPLICATE("-",135)
@ PROW()+1,00 SAY PADR("TOTAL GERAL: ",45 ,".")
@ PROW(),  48 SAY TRANSFORM(vTotPed,"@E 9,999,999.99")  // ped vm atrasados
@ PROW(),  66 SAY TRANSFORM(vTotCr,"@E 9,999,999.99")   // cr atrasados
@ PROW()+1,00 SAY REPLICATE("-",135)
@ PROW()+2,0 SAY vcid10+vcia10+PADC(" Fim do Relat¢rio ",80,"=")
EJECT
//Descarga()
SET PRINTER TO
SET DEVICE TO SCREEN
IF vcporta="2" // tela
   Imprtela(vcimpres,160)
ENDIF
CLOSE DATABASE
RETURN

**************************************************************************
FUNCTION BloqDesCli()
// Pesquisa arquivo de CR e Pedidos e desbloqueia automaticamente o cliente.
****************************************************************************
LOCAL mCliBloq:={},cliAtual,muda,i,j
//
IF Abrearq((dirvm+"VM_CLIEN.DBF"),"Cli",.F.,10)
   SET INDEX TO (dirvm+"VM_CLIE1") // codcli
ELSE
   Mensagem("O Arquivo de Clientes N∆o Est† Dispon°vel!",3,1)
   RETURN
ENDIF
//
IF Abrearq((dirvm+"VM_PEDID.DBF"),"Pvm",.F.,10)
   SET INDEX TO (dirvm+"VM_PEDI2")  // codcli
ELSE
   Mensagem("O Arquivo de Pedidos de Vidro Comum N∆o Est† Dispon°vel!",3,1)
   CLOSE DATABASE
   RETURN
ENDIF
//
// Contas a Receber
IF Abrearq((dirmov+"WM_CTREC.DBF"),"Cr",.F.,10)
   SET INDEX TO (dirmov+"WM_CTRE9")  // codcli+DTOS(venc)
ELSE
   Mensagem("O Arquivo de Contas a Receber N∆o Est† Dispon°vel!",4,1)
   CLOSE DATABASE
   RETURN
ENDIF
//
@ 24,00 CLEAR
SETCOLOR(vcp)
Aviso(24,"Selecionando Clientes. Aguarde...")
//
SELECT Pvm   // vidro comum
cliAtual:=Pvm->codcli
vfecha:=Procura("Cli",1,cliAtual,"fecha")
muda:=.T.
DO WHILE !EOF()
    IF LEFT(Pvm->nupd,1)=vcloja .AND. EMPTY(Pvm->datapg) .AND. !EMPTY(Pvm->dataret) .AND. Pvm->codcli#"99999"
       IF muda
          vfecha:=Procura("Cli",1,cliAtual,"fecha")
          muda:=.F.
       ENDIF
       IF DATE()-Pvm->dataret > vfecha     // atrasado
          IF ASCAN(mCliBloq,cliAtual)=0
             AADD(mCliBloq,cliAtual)
          ENDIF
       ENDIF
    ENDIF
    SKIP
    IF Pvm->codcli#cliAtual
       cliAtual:=Pvm->codcli
       muda:=.T.
    ENDIF
ENDDO
/*
SELECT Crf   // contas a receber da Fluxus
DO WHILE !EOF()
   IF DATE()-Crf->datven_cr > 2 .AND. Crf->codcli_cr#"99999"
      IF ASCAN(mCliBloq,Crf->codcli_cr)=0
         AADD(mCliBloq,Crf->codcli_cr)
      ENDIF
   ENDIF
   SKIP
ENDDO
*/
SELECT Cr   // Contas a Receber
DO WHILE !EOF()
   IF DATE()-Cr->venc > 2 .AND. Cr->codcli#"99999"
      IF ASCAN(mCliBloq,Cr->codcli)=0
         AADD(mCliBloq,Cr->codcli)
      ENDIF
   ENDIF
   SKIP
ENDDO
//
@ 24,00 CLEAR
SETCOLOR(vcp)
Aviso(24,"Desbloqueando Clientes. Aguarde...")
//
SELECT Cli
GO TOP
j:=0  // clientes desbloqueados
z:=0  // clientes bloqueados
DO WHILE !EOF()
   IF ASCAN(mCliBloq,Cli->codcli) = 0  // para desbloquear
      IF Cli->bloq="S"
         IF Bloqreg(10)
            Cli->bloq:="N"
            j++
            UNLOCK
         ELSE
            Mensagem("O Registro N∆o est† Dispon°vel !",3,1)
         ENDIF
      ENDIF
   ELSE // para bloquear
      IF Cli->bloq="N"
         IF Bloqreg(10)
            Cli->bloq:="S"
            z++
            UNLOCK
         ELSE
            Mensagem("O Registro N∆o est† Dispon°vel !",3,1)
         ENDIF
      ENDIF
   ENDIF
   SKIP
ENDDO
CLOSE DATABASE
@ 24,00 CLEAR
SETCOLOR(vcn)
Aviso(24,"Clientes Desbloqueados "+ALLTRIM(STR(j))+" - Clientes Bloqueados "+ALLTRIM(STR(z)))
INKEY(0)
@ 24,00 CLEAR
RETURN

********************************************************************************
// ### ROTINAS DE CADASTRO DE VENDEDORES
********************************************************************************
/* Programa.: VM_VEDOR.PRG
   Sistema..: Controle de Vendas e Comiss‰es
   Autor....: Antonio J.M Costa
   Data.....: 13/05/97
   Funá∆o...: Cadastro de Vendedores                 */
********************************************************************************
PROCEDURE ConsVedor()
********************************************************************************
LOCAL vdado[5],vmask[5],vcabe[5],vedit[5]
// Vari†veis para verificaá∆o de senha.
PRIVATE pv1:=pv2:=pv3:=pv4:=pv5:=.T.
// Vari†veis para apresentaá∆o e ediá∆o dos dados.
PRIVATE vcodv,vloja,vngv,vnome,vende,vcep,vmuni,vddd,vtel,vuf,vsenha,vcred,vtxv
// Abertura do arquivo de dados.
IF Abrearq((dirvm+"VM_VEDOR.DBF"),"Ved",.F.,10)
   SET INDEX TO (dirvm+"VM_VEDO1"), (dirvm+"VM_VEDO2")
ELSE
   Mensagem("O arquivo N∆o Est† Dispon°vel !",3,1)
   RETURN
ENDIF
// vdado: vetor dos nomes dos campos
vdado[01]:="codv"
vdado[02]:="ngv"
vdado[03]:="loja+'-'+Loja(loja)+' '"
vdado[04]:="txv"
vdado[05]:="IIF(!EMPTY(Ved->senha),REPLICATE('*',15),SPACE(15))"
// vmask: vetor das m†scaras de apresentaá∆o dos dados.
vmask[01]:="999"
vmask[02]:="@!"
vmask[03]:="@!"
vmask[04]:="999.99"
vmask[05]:="@!"
// vcabe: vetor dos t°tulos para o cabeáalho das colunas.
vcabe[01]:="C¢digo"
vcabe[02]:="Nome"
vcabe[03]:="Loja"
vcabe[04]:="Taxa"
vcabe[05]:="Senha"
// vedit: vetor que define os campos que podem ser editados.
AFILL(vedit,.F.)
// Informaá‰es para ajuda ao usu†rio.
mAjuda:={;
"Enter - Vis∆o do Vendedor em Tela Cheia",;
"F3    - Pesquisa pelo C¢digo do Vendedor",;
"F4    - Pesquisa pelo Nome de Guerra do Vendedor"}
// Construá∆o da Tela de Apresentaá∆o.
Sinal("VENDEDORES","CONSULTA")
Abrejan(2)
@ 04,01 SAY REPLICATE("ƒ",78)
// Barra de Tarefas.
SETCOLOR(vcr)
@ 23,00 SAY PADC("F1=Ajuda  F2=C¢digo  F3=Nome  Enter=Consulta  Esc=Encerra",80)
SETCOLOR(vcn)
// Chamada do procedimento de consulta desenvolvido com TBrowse.
ConsBrowse("Ved",05,01,22,78,vdado,vmask,vcabe,vedit,1,{|| OpsVed()},;
           "codv" ,1,"999" ,3  ,"C¢digo",;
           "ngv"  ,2,"@!"  ,20 ,"Nome")
CLOSE DATABASE
RETURN

********************************************************************************
FUNCTION OpsVed()
// Opá‰es da consulta de Vendedores.
********************************************************************************
LOCAL vtela
// Destaque do browse
@ 03,03 CLEAR TO 03,77
@ 03,03 SAY "Vendedor:"
SETCOLOR(vcd)
@ 03,12 SAY Ved->codv+"-"+Ved->ngv
SETCOLOR(vcn)
// Teclas de opá‰es da consulta
IF LASTKEY()=K_ENTER
   // Enter - Consulta em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   VisaoVed()
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ENDIF
RETURN .F.

********************************************************************************
PROCEDURE VisaoVed()
********************************************************************************
// Visualiza o registro
vtela:=SAVESCREEN(01,00,24,79)
Abrejan(2)
DO WHILE .T.
   InicVedor()
   TransVedor()
   TelaVedor()
   SETCOLOR(vcr)
   @ 23,00 SAY PADC(" Esc=Retorna",80)
   SETCOLOR(vcn)
   INKEY(0)
   IF LASTKEY()=K_ESC
      EXIT
   ENDIF
ENDDO
RESTSCREEN(01,00,24,79,vtela)
RETURN

******************************************************************************
PROCEDURE InicVedor()
***********************
vcodv :=SPACE(03)
vloja :=SPACE(01)
vngv  :=SPACE(15)
vnome :=SPACE(40)
vende :=SPACE(35)
vcep  :=SPACE(08)
vmuni :=SPACE(20)
vddd  :=SPACE(04)
vtel  :=SPACE(08)
vuf   :=SPACE(02)
vsenha:=SPACE(45)
vcred :=SPACE(40)
vtxv  :=0
RETURN

********************************************************************************
PROCEDURE TelaVedor()
**********************
//         10        20        30        40        50        60         70
//   34567890123456789012345678901234567890123456789012345678901234567890
//   C¢digo:XXX  Loja:X XXXXXXXXX   Nome de Guerra:XXXXXXXXXXXXXXX
//   Nome Completo:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
//   Endereáo:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   CEP:XX.XXX-XXX  UF:XX
//   Munic°pio:XXXXXXXXXXXXXXXXXXXX   DDD:XXXX  Telefone: XXXX-XXXX
//   Taxa de comiss∆o(%):XXX,XX
//   Senha:XXXXXXXXXXXXXXX
SETCOLOR(vcn)
@ 05,03 SAY "C¢digo:"
@ 05,15 SAY "Loja:"
@ 05,34 SAY "Nome de Guerra:"
@ 07,03 SAY "Nome Completo:"
@ 09,03 SAY "Endereáo:"
@ 09,50 SAY "CEP:"
@ 09,66 SAY "UF:"
@ 11,03 SAY "Munic°pio:"
@ 11,36 SAY "DDD:"
@ 11,45 SAY "Telefone:"
@ 13,03 SAY "Taxa de Comiss∆o(%):"
@ 15,03 SAY "Senha:"
SETCOLOR(vcd)
@ 05,10 SAY vcodv   PICTURE "999"
@ 05,21 SAY vloja   PICTURE "9"
@ 05,23 SAY Loja(vloja)   PICTURE "@!"
@ 05,49 SAY vngv    PICTURE "@!"
@ 07,17 SAY vnome   PICTURE "@!"
@ 09,12 SAY vende   PICTURE "@!"
@ 09,54 SAY vcep    PICTURE "@R 99.999-99"
@ 09,69 SAY vuf     PICTURE "!!"
@ 11,13 SAY vmuni   PICTURE "@!"
@ 11,40 SAY vddd    PICTURE "9999"
@ 11,55 SAY vtel    PICTURE "@R XX99-9999"
@ 13,23 SAY vtxv    PICTURE "@E 999.99"
@ 15,09 SAY IIF(!EMPTY(vsenha),"***************",SPACE(15))
SETCOLOR(vcn)
RETURN

********************************************************************************
PROCEDURE EditaVedor()
***********************
@ 05,10 GET vcodv   PICTURE "999"
@ 05,21 GET vloja   PICTURE "9"  //VALID vloja$"01234"
Le()
IF !vloja$"01234"
   vloja:=menuLoja(vloja)
ENDIF
TelaVedor()
@ 05,49 GET vngv    PICTURE "@!" VALID !EMPTY(vngv)
@ 07,17 GET vnome   PICTURE "@!"
@ 09,12 GET vende   PICTURE "@!"
@ 09,54 GET vcep    PICTURE "@R 99.999-99"
@ 09,69 GET vuf     PICTURE "!!"
@ 11,13 GET vmuni   PICTURE "@!"
@ 11,40 GET vddd    PICTURE "9999"
@ 11,55 GET vtel    PICTURE "@R XX99-9999"
@ 13,23 GET vtxv    PICTURE "@E 999.99" VALID vtxv <= 100
Le()
Aviso(24,"Deseja Cadastrar a Senha")
IF Confirme()
   @ 15,09 SAY SPACE(15)
   vsenha:=DigSenha(19,09,"Digite a Senha. M†ximo 15 caracteres")
ENDIF
IF !EMPTY(vsenha)
   CredItens(1)
ENDIF
@ 24,00 CLEAR
RETURN

********************************************************************************
PROCEDURE TransVedor()
**********************
vcodv :=Ved->codv
vloja :=Ved->loja
vngv  :=Ved->ngv
vnome :=Ved->nome
vende :=Ved->ende
vcep  :=Ved->cep
vuf   :=Ved->uf
vmuni :=Ved->muni
vddd  :=Ved->ddd
vtel  :=Ved->tel
vtxv  :=Ved->txv
vcred :=Ved->cred
vsenha:=Ved->senha
RETURN

********************************************************************************
PROCEDURE AtualVedor()
***********************
Ved->codv   :=vcodv
Ved->loja   :=vloja
Ved->ngv    :=vngv
Ved->nome   :=vnome
Ved->ende   :=vende
Ved->cep    :=vcep
Ved->uf     :=vuf
Ved->muni   :=vmuni
Ved->ddd    :=vddd
Ved->tel    :=vtel
Ved->txv    :=vtxv
Ved->cred   :=vcred
Ved->senha  :=vsenha
RETURN

********************************************************************************
PROCEDURE ColocaZero(pcod)
// Coloca zeros a direita de um c¢digo
**************************************
RETURN ALLTRIM(pcod)+REPLICATE("0",LEN(pcod)-LEN(ALLTRIM(pcod)))

******************************************************************************
// Fim de VM_VEDOR.PRG
******************************************************************************

******************************************************************************
PROCEDURE MenuLoja()
********************
LOCAL op:=1
LOCAL vtela:=SAVESCREEN(01,00,24,79)
LOCAL vcor:=SETCOLOR()
DO WHILE .T.
   SETCOLOR(vcm) //vcf
   @ 10,18 SAY PADC("Lojas",14)
   SETCOLOR(vcn)
   Caixa(09,17,17,32,frame[6])
   @ 11,18 PROMPT " 0-MATRIZ     "
   @ 12,18 PROMPT " 1-FILIAL I   "
   @ 13,18 PROMPT " 2-FILIAL II  "
   @ 14,18 PROMPT " 3-FILIAL III "
   @ 15,18 PROMPT " 4-FILIAL IV  "
   @ 16,18 PROMPT " 5-FILIAL V   "
   MENU TO op
   IF EMPTY(op).OR.LASTKEY()==K_ESC
      LOOP
   ENDIF
   RESTSCREEN(01,00,24,79,vtela)
   EXIT
ENDDO
SETCOLOR(vcor)
RETURN STR(op-1,1)


*******************************************************************************
//                                  F i m
*******************************************************************************


