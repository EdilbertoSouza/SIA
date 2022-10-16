*******************************************************************************
/* Programa: FC_REQUI.PRG
   Funá∆o..: Processamento de Requisiá‰es e Transferàncias de Estoque
   Sistema.: CONTROLE DE FATURAMENTO, COMPRAS E ESTOQUE
   Data....: 05/06/02
   Autor...: Edilberto L.Souza */
*******************************************************************************/
// Arquivos-cabeáalho
#include "SIG.CH"
#include "SETCURS.CH"
********************************************************************************
PROCEDURE MatReq(modo)
/* Manutená∆o das Requisiá‰es e Transferàncias de Estoque:
   Par∂metro:  modo   1-Inclus∆o       2-Alteraá∆o  3-Exclus∆o
                      4-Transferància  5-Devoluá∆o               */
********************************************************************************
PRIVATE mItem[27,10] // Matriz que ser† usada para ediá∆o dos itens
PRIVATE n,k,vmodo
PRIVATE vordem,vdocto,vstatus,vdata,ves,vcodlocd,vcodlocp
PRIVATE vmovger,vvalor
//
PRIVATE vite,vcod,vpro,vuni,vqtd,vkt,valt,vlar,vare,vpre
PRIVATE vcodvm,vnpecas
PRIVATE vli,li,lf,vt,vord,tampa:=CHR(186)
/* vli:  linha inicial para ediá∆o dos itens.
   li:   linha atual.
   lf:   linha final.
   vt:   linha adicional quando houver rolamento da tela.
   vord: n£mero de itens. */
// Inicializa a linha inicial para ediá∆o dos itens.
vli:=09
// Apresenta a operaá∆o escolhida.
IF modo=1
   Sinal("REQUISIÄ«O","INCLUS«O")
ELSEIF modo=2
   Sinal("REQUISIÄ«O","ALTERAÄ«O")
ELSEIF modo=3
   Sinal("REQUISIÄ«O","EXCLUS«O")
ELSEIF modo=4
   Sinal("REQUISIÄ«O","TRANSFER“NCIA")
ELSEIF modo=5
   Sinal("REQUISIÄ«O","DEVOLUÄ«O")
ENDIF
// Abertura dos arquivos de dados
//{(dirvm+"VM_ESTOQ.DBF"),"Stq","Estoque VM",2},;
//{(dirvm+"VM_ITSTQ.DBF"),"Sti","Itens de Estoque VM",1},;
marqs:={;
{(dircad+"FC_PRODU.DBF"),"Prc","Produtos do FC",3},;
{(dircad+"FC_LOCAL.DBF"),"Tlo","Locais de Estoque",2},;
{(dircad+"FC_COMPO.DBF"),"Com","Composiá∆o",1},;
{(dirmov+"FC_SALGE.DBF"),"Sdg","Saldo de Estoque",1},;
{(dirmov+"FC_SALDO.DBF"),"Sdo","Saldo de Estoque",1},;
{(dirmov+"FC_REQUI.DBF"),"Req","Requisiá‰es",5},;
{(dirmov+"FC_ITREQ.DBF"),"Rqi","Itens de Requisiá‰es",2}}
IF !AbreArqs(marqs,.F.)
   RETURN
ENDIF
//
DO WHILE .T.
   Abrejan(2)
   SELECT Req
   IniVarReq()  // Inicializa as vari†veis auxiliares
   vmodo:=modo
   IF vmodo=1
      SET ORDER TO 1
      GO BOTTOM
      vordem:=STRZERO(VAL(Req->ordem)+1,6)
      vdocto:=STRZERO(VAL(Req->docto)+1,8)
   ENDIF
   TelaReq()
   IniMatItReq(1,LEN(mItem))
   li:=lf:=1;vt:=0;vord:=0
   SETCOLOR(vcn)
   Aviso(24,"Digite os dados ou Tecle <Esc> Para Finalizar")
   SETCOLOR(vcd)
   @ 04,15 GET vdocto PICTURE "99999999" //VALID(!EMPTY(vdocto))
   Le()
   IF LASTKEY()=K_ESC
      EXIT
   ENDIF
   vdocto:=Zeracod(vdocto)
   @ 04,15 SAY vdocto PICTURE "99999999"
   IF vmodo#1 // Alteraá∆o ou Exclus∆o
      vdocto:=Acha2(vdocto,"Req",4,3,"docto","codloc","99999999","@!",15,05,22,76,"Documento","Local")
   ENDIF
   @ 04,15 SAY vdocto PICTURE "99999999"
   SELECT Req
   SET ORDER TO 4
   SET SOFTSEEK ON
   SEEK vdocto
   SET SOFTSEEK OFF
   IF vmodo=1  // Inclus∆o
      vmovger:="." // Gerencial
      EditaReq()
      IF LASTKEY()=K_ESC
         EXIT
      ENDIF
      EditaItReq(vmodo)
      LOOP
   ENDIF
   IF FOUND()
      TransfReq()
      TransVetReq()
      //UpDataReq()
      TelaReq()
      MostraItReq(1,vord,vcn)
      IF vmodo<5 .AND. vstatus="TR"
         Mensagem("Requisiá∆o Transferida !",3,1)
         LOOP
      ENDIF
      IF vmodo=5 .AND. vstatus#"TR"
         Mensagem("Requisiá∆o N∆o Transferida !",3,1)
         LOOP
      ENDIF
      IF vmodo=2 // Alteraá∆o
         EditaReq()
         IF LASTKEY()=K_ESC
            EXIT
         ENDIF
         EditaItReq(vmodo)
      ELSEIF vmodo=3 // Exclus∆o
         ExcluiReq()
      ELSEIF vmodo=4 // Transferància
         TransfeReq()
      ELSEIF vmodo=5 // Devoluá∆o
         DevolveReq()
      ENDIF
      LOOP
   ENDIF
ENDDO
SETCOLOR(vcn)
CLOSE DATABASES
RETURN

******************************************************************************
PROCEDURE IniVarReq()
// Inicializa vari†veis auxiliares
**********************************
vordem  :=SPACE(06)
vdocto  :=SPACE(08)
vstatus :=SPACE(02)
vdata   :=DATE()
ves     :=SPACE(01)
vcodlocd:=SPACE(03)
vcodlocp:=SPACE(03)
vmovger :=SPACE(01)
vvalor  :=0
RETURN

********************************************************************************
PROCEDURE TelaReq()
// Apresenta os dados na tela.
********************************************************************************
/*       10        20        30        40        50        60        70        80
01234567890123456789012345678901234567890123456789012345678901234567890123456789
4    Documento:XXXXXXXXx      Data:XX/XX/XX       Status:XX-XXXXXXXXXXX
5
6    De..:XXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
7    Para:XXX-40XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
8    Plano de Corte:XXXX                                 Valor Total:XXX.XXX,XX
*/
SETCOLOR(vcn)
@ 04,05 SAY "Documento:               Data:"
@ 06,05 SAY "De..:"
@ 07,05 SAY "Para:"
@ 08,57 SAY "Valor Total:"
SETCOLOR(vcd)
@ 04,15 SAY vdocto   PICTURE "99999999"
@ 04,23 SAY vmovger  PICTURE "!"
@ 04,35 SAY vdata    PICTURE "99/99/99"
@ 06,10 SAY vcodlocd PICTURE "999"
@ 06,13 SAY "-"+Procura("Tlo",1,vcodlocd,"nome")
@ 07,10 SAY vcodlocp PICTURE "999"
@ 07,13 SAY "-"+Procura("Tlo",1,vcodlocp,"nome")
@ 08,69 SAY vvalor   PICTURE "@E 999,999.99"
SETCOLOR(vcr)
// M†scara de ediá∆o dos itens.
//                   10        20        30        40        50        60        70        80
//          01234567890123456789012345678901234567890123456789012345678901234567890123456789
@ 09,01 SAY "IT≥C‡DIGO ≥PRODUTO                                 ≥UN≥  QUANT≥   UNIT≥  VALOR"
//           99 XXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX 9999.99 9999,99 9999,99
SETCOLOR(vcn)
RETURN

********************************************************************************
PROCEDURE EditaReq()
// Edita os dados na tela.
********************************************************************************
SETCURSOR(IF(READINSERT(),SC_INSERT,SC_NORMAL))
//
omovger:=GetNew()
omovger:colorSpec:=vcd
omovger:row:=04;omovger:col:=23
omovger:name:="vmovger";omovger:picture:="!"
omovger:block:={|valor| IF(PCOUNT()>0,vmovger:=valor,vmovger)}
//
odata:=GetNew()
odata:colorSpec:=vcd
odata:row:=04;odata:col:=35
odata:name:="vdata";odata:picture:="99/99/99"
odata:block:={|valor| IF(PCOUNT()>0,vdata:=valor,vdata)}
odata:postBlock:={|valor| !EMPTY(vdata)}
//
ocodlocd:=GetNew()
ocodlocd:colorSpec:=vcd
ocodlocd:row:=06;ocodlocd:col:=10
ocodlocd:name:="vcodlocd";ocodlocd:picture:="999"
ocodlocd:block:={|valor| IF(PCOUNT()>0,vcodlocd:=valor,vcodlocd)}
ocodlocd:postBlock:={|valor| CodLocd()}
//
ocodlocp:=GetNew()
ocodlocp:colorSpec:=vcd
ocodlocp:row:=07;ocodlocp:col:=10
ocodlocp:name:="vcodlocp";ocodlocp:picture:="999"
ocodlocp:block:={|valor| IF(PCOUNT()>0,vcodlocp:=valor,vcodlocp)}
ocodlocp:postBlock:={|valor| CodLocp()}
//
SETCOLOR(vcr) // Linha de Orientaá∆o ao usu†rio
@ 23,01 SAY PADC("F1=Ajuda   F10=Calculadora    Esc=Fim",80)
SETCOLOR(vcn)
Aviso(24,"Digite os dados ou tecle <Esc> para encerrar")
SETCURSOR(2)
READMODAL({omovger,odata,ocodlocd,ocodlocp})
SETCURSOR(0)
//SET KEY K_F9 TO
RETURN

********************************************************************************
PROCEDURE MostraItReq(ni,nf,vcor,pmodo)
/* Objetivo: Apresenta os itens das notas na tela.
   ParÉmetros: ni:   n£mero do item inicial.
               nf:   n£mero do item final.
               vcor: padr∆o de cor a serem apresentados os itens. */
********************************************************************************
SETCOLOR(vcor)
IF pmodo==NIL
   pmodo=1
ENDIF
FOR i=ni TO IF(nf<23-vli,nf,22-vli)
   IF !EMPTY(mItem[i+vt,02])
      @ vli+i,01 SAY STRZERO(i+vt,2) //mItem[i+vt,01] PICTURE "99"      // item
      @ vli+i,04 SAY mItem[i+vt,02] PICTURE "9999999" // codpro
      @ vli+i,12 SAY mItem[i+vt,03] PICTURE "@!"      // prod
      @ vli+i,53 SAY mItem[i+vt,04] PICTURE "@!"      // unid
      @ vli+i,56 SAY IF(!EMPTY(mItem[i+vt,05]),TRANSFORM(mItem[i+vt,05],"@E 9999.99"),"") // quant
      @ vli+i,64 SAY IF(!EMPTY(mItem[i+vt,05]),TRANSFORM(mItem[i+vt,08],"@E 9999.99"),"") // unit†rio
      @ vli+i,72 SAY IF(!EMPTY(mItem[i+vt,05]),TRANSFORM(mItem[i+vt,05]*mItem[i+vt,08],"@E 9999.99"),"") // valor
      @ vli+i,03 SAY "≥"
      @ vli+i,11 SAY "≥"
      @ vli+i,52 SAY "≥"
      @ vli+i,55 SAY "≥"
      @ vli+i,63 SAY "≥"
      @ vli+i,71 SAY "≥"
   ELSE
      @ vli+i,1 SAY SPACE(78)
   ENDIF
NEXT
SETCOLOR(vcn)
RETURN

********************************************************************************
PROCEDURE EditaItReq(pmodo)
// Edita os itens na tela.
********************************************************************************
vmodo:=pmodo
vret:=0
DO WHILE .T.
   // Apresenta a linha de orientaá∆o ao usu†rio.
   SETCOLOR(vcr)
   IF vmodo=5 // Consulta
      @ 23,00 SAY PADC(" F1=Ajuda   Setas=Movimenta Cursor   F3=Imprime   Esc=Retorna ",80)
   ELSE
      @ 23,00 SAY PADC(" F1=Ajuda   Ins=Inclui Item   Del=Exclui Item   F8=Edita   Esc=Encerra ",80)
   ENDIF
   // Apresenta a setinha indicando o item selecionado.
   SETCOLOR(vcp)
   @ vli+li,0 SAY CHR(178)
   SETCOLOR(vcn)
   // Mostra o item selecionado.
   MostraItReq(li,li,vca)
   // Aguarda o pressionamento de uma tecla de controle pelo usu†rio.
   tk:=INKEY(0)
   IF (li+vt) > LEN(mItem)
       Mensagem("N∆o Pode Cadastrar Mais de "+STR(LEN(mItem),2)+" Itens!",3,1)
       LOOP
   ENDIF
   IF tk=K_F1  // Pressionada a tecla <F1>:ajuda
      IF vmodo=5     // Consulta
         mAjuda2:={;
         "Setas    - Movimentam o Cursor",;
         "F3       - Imprime a Requisiá∆o de Material",;
         "Esc      - Retorna a Tela Anterior de Consulta"}
      ELSE
         mAjuda2:={;
         "Insert   - Insere novo Item ou Altera Item sob Cursor",;
         "Del      - Deleta o item sobre o cursor",;
         "F8       - Edita o Cabeáalho da Requisiá∆o",;
         "Esc      - Encerra a Ediá∆o da Requisiá∆o"}
      ENDIF
      Ajuda2(mAjuda2)
   ELSEIF tk=K_INS  // Pressionada a tecla <Ins>:inclus∆o ou alteraá∆o de um item.
      IF vmodo=5 // Se o modo for Consulta volta ao inicio
         LOOP
      ENDIF
      // Transfere para vari†veis os vetores da matriz de itens.
      vite    :=mItem[li+vt,01] //STRZERO(li+vt,2) // nr. do item
      vcod    :=mItem[li+vt,02]  // c¢digo do produto.
      vpro    :=mItem[li+vt,03]  // nome do produto
      vuni    :=mItem[li+vt,04]  // unidade do produto
      vqtd    :=mItem[li+vt,05]  // quantidade.
      valt    :=mItem[li+vt,06]  // altura.
      vlar    :=mItem[li+vt,07]  // largura.
      vpre    :=mItem[li+vt,08]  // preáo unit†rio.
      vcodvm  :=mItem[li+vt,09]  // codigo do produto no vm.
      vnpecas :=mItem[li+vt,10]  // n£mero de peáas
      SETCOLOR(vcn)
      @ vli+li,01 SAY vite  PICTURE "99"
      // Solicita o c¢digo do produto.
      @ vli+li,04 GET vcod PICTURE "9999999"
      Aviso(24,"Digite o C¢digo do Produto")
      Le()
      @ 24,00 CLEAR
      vcod:=Acha2(vcod,"Prc",1,2,"codpro","prod","9999999","@!",;
      15,05,22,76,"C¢digo","Nome do Produto")
      // Retorna se o c¢digo estiver em branco.
      IF EMPTY(vcod)
         @ vli+li,01 SAY SPACE(78)
         LOOP
      ENDIF
      SELECT Prc
      vpro:=Prc->prod
      vuni:=LEFT(ALLTRIM(Prc->unid),2)
      vpre:=Prc->precmp
      // Reapresenta os dados na tela.
      @ vli+li,04 SAY vcod  PICTURE "9999999"
      @ vli+li,12 SAY vpro  PICTURE "@!"
      SETCOLOR(vcn)
      // Verifica disponibilidade do material no local de estoque
      // (vcodlocd) local de onde sair† os produtos ou componentes
      mCompo:={}
      IF vcodlocp="003" .OR. vcodlocp="330" // Produá∆o Vidro ou Kit M2000
         mCompo:=Composicao(vcod)
      ENDIF
      IF EMPTY(mCompo) // Se n∆o tiver composiá∆o para esta movimentaá∆o
         IF EMPTY(vmovger) // Contabil
            vsaldo:=Saldo(vcod,vcodlocd)
         ELSE              // Gerencial
            vsaldo:=Saldg(vcod,vcodlocd)
         ENDIF
      ELSE             // Produto com composiá∆o cadastrada p/esta mov.
         i:=1
         msaldo:={}
         vsaldo:=0
         DO WHILE i <= LEN(mCompo)
            IF EMPTY(vmovger) // Contabil
               AADD(msaldo,Saldo(mCompo[i,2],vcodlocd)/mCompo[i,5])
            ELSE              // Gerencial
               AADD(msaldo,Saldg(mCompo[i,2],vcodlocd)/mCompo[i,5])
            ENDIF
            IF i = 1 // Se for a primeira iteraá∆o
               vsaldo:=msaldo[i]
            ELSE     // Se n∆o verifica se Ç o menor saldo
               vsaldo:=IF(msaldo[i]<vsaldo,msaldo[i],vsaldo)
            ENDIF
            i++
         ENDDO
      ENDIF
      Aviso(24,"Saldo Dispon°vel:"+STR(vsaldo))
      //
      //@ vli+li,12 GET vpro  PICTURE "@!"
      //Le()
      @ vli+li,12 SAY vpro  PICTURE "@!"
      @ vli+li,53 SAY vuni  PICTURE "@!"
      @ vli+li,56 SAY vqtd  PICTURE "@E 9999.99"
      @ vli+li,64 SAY vpre  PICTURE "@E 9999.99"
      @ vli+li,72 SAY vqtd*vpre PICTURE "@E 9999.99"
      //
      vkt:=0
      vkta:=0
      IF ALLTRIM(vuni)=="M2"
         IF Chapa(vcod)  // Se for chapa
            vqtd:=0      // Solicita dimens‰es
         ELSEIF Modulado(vcod)  // Se for modulado
            vqtd:=0
         ELSEIF LEFT(vcod,2)=="43" // Se for box
            vqtd:=0
         ELSE            // Se n∆o for nenhum dos produtos acima
            SETCOLOR(vcn)
            Aviso(24,"Digite Zero Para Incluir Medidas")
            @ vli+li,45 GET vqtd PICTURE "@E 99999.99"
            Le()
            @ 24,00 CLEAR
         ENDIF
         IF vqtd=0
            SETCOLOR(vcn)
            vtela:=SAVESCREEN(01,00,24,79)
            SETCOLOR(vcf)
            Caixa(06,55,10,74,frame[6])
            @ 07,57 SAY "Quant__: "
            @ 08,57 SAY "Altura_: "
            @ 09,57 SAY "Largura: "
            SETCOLOR(vcr)
            @ 07,65 SAY vqtd PICTURE "99999"
            @ 08,66 SAY valt PICTURE "9999"
            @ 09,66 SAY vlar PICTURE "9999"
            SETCOLOR(vcn)
            SET ESCAPE OFF
            IF Modulado(vcod)  // Se for modulado
               @ 07,65 GET vnpecas PICTURE "99999" VALID vnpecas>0 .AND. vnpecas%10=0
               Le()
               IF EMPTY(vcodvm)
                  DimModula() // Solicita uma das dimens‰es padr‰es
               ENDIF
               @ 08,66 SAY valt PICTURE "9999" COLOR(vcr)
               @ 09,66 SAY vlar PICTURE "9999" COLOR(vcr)
               INKEY(0)
               vqtd:=vnpecas*Quant(vuni,vcod,vlar,valt)
               vqtd:=ROUND(vqtd,2)
            ELSE
               @ 07,65 GET vnpecas PICTURE "99999" VALID vnpecas>0
               @ 08,66 GET valt PICTURE "9999" VALID (valt>0 .AND. valt<4000)
               @ 09,66 GET vlar PICTURE "9999" VALID (vlar>0 .AND. vlar<4000)
               Le()
               vqtd:=vnpecas*Quant(vuni,vcod,vlar,valt)
               vqtd:=ROUND(vqtd,2)
            ENDIF
            SET ESCAPE ON
            RESTSCREEN(01,00,24,79,vtela)
         ELSE
            vlar:=valt:=0
         ENDIF
      ELSE
         @ vli+li,45 GET vqtd PICTURE "@E 99999.99" VALID(vqtd>0)
         Le()
         vlar:=valt:=0
      ENDIF
      /*
      IF ALLTRIM(vuni)=="M2"
         IF !Chapa(vcod) // Se n∆o for chapa
            SETCOLOR(vcn)
            Aviso(24,"Digite Zero Para Incluir Medidas")
            @ vli+li,56 GET vqtd PICTURE "@E 9999.99"
            Le()
            @ 24,00 CLEAR
         ELSE            // Se for chapa
            vqtd:=0      // Solicita dimens‰es
         ENDIF
         IF vqtd=0
            SETCOLOR(vcn)
            vtela:=SAVESCREEN(01,00,24,79)
            SETCOLOR(vcf)
            Caixa(06,55,10,74,frame[6])
            @ 07,57 SAY "Quant__: "
            @ 08,57 SAY "Altura_: "
            @ 09,57 SAY "Largura: "
            SETCOLOR(vcr)
            @ 07,66 SAY vqtd PICTURE "9999"
            @ 08,66 SAY valt PICTURE "9999"
            @ 09,66 SAY vlar PICTURE "9999"
            SETCOLOR(vcn)
            @ 07,66 GET vqtd PICTURE "9999" VALID vqtd>0
            @ 08,66 GET valt PICTURE "9999" VALID (valt>0 .AND. valt<4000)
            @ 09,66 GET vlar PICTURE "9999" VALID (vlar>0 .AND. vlar<4000)
            Le()
            vqtd:=vqtd*Quant(vuni,vcod,vlar,valt)
            RESTSCREEN(01,00,24,79,vtela)
         ELSE
            vlar:=valt:=0
         ENDIF
      ELSE
         @ vli+li,56 GET vqtd PICTURE "@E 9999.99" VALID(vqtd>0)
         Le()
         vlar:=valt:=0
      ENDIF
      @ vli+li,12 SAY vpro  PICTURE "@!"
      @ vli+li,34 SAY vuni  PICTURE "@!"
      */
      @ vli+li,56 SAY vqtd  PICTURE "@E 9999.99"
      SETCOLOR(vcn)
      IF vsaldo < vqtd // Se o saldo for menor que a quantidade requesitada
         Mensagem("Saldo Insuficiente",3,1)
         Aviso(24,"Saldo Dispon°vel:"+STR(vsaldo))
         //LOOP
      ENDIF
      @ vli+li,64 GET vpre PICTURE "@E 9999.99" VALID vpre>0
      Le()
      IF vkt#0.OR.vkta#0
         vpre:=vpre*(vkt+vkta)
         vuni:="UN"
      ENDIF
      vpre:=ROUND(vpre,2)
      @ vli+li,64 SAY vpre PICTURE "@E 9999.99"
      @ vli+li,72 SAY vqtd*vpre PICTURE "@E 9999.99"
      SETCOLOR(vcn)
      IF EMPTY(mItem[li+vt,02])
         ++vord
      ENDIF
      // Atualiza a matriz dos itens.
      mItem[li+vt,01]:=STRZERO(li+vt,2)
      mItem[li+vt,02]:=vcod
      mItem[li+vt,03]:=vpro
      mItem[li+vt,04]:=vuni
      mItem[li+vt,05]:=vqtd
      mItem[li+vt,06]:=valt
      mItem[li+vt,07]:=vlar
      mItem[li+vt,08]:=vpre
      mItem[li+vt,09]:=vcodvm
      mItem[li+vt,10]:=vnpecas
      // Atualiza os valores.
      UpDataReq()
      // Reapresenta o item
      @ vli+li,0 SAY tampa
      MostraItReq(li,li,vcn)
      // Incrementa uma linha de ediá∆o.
      IF li<(22-vli)
         ++li
      ELSE
         // Realiza o rolamento da tela.
         IF vt<(LEN(mItem)-(22-vli))
            ++vt
            SCROLL(vli+1,1,22,78,1)
            MostraItReq(li,li,vcn)
         ENDIF
      ENDIF
      // Atualiza a linha final.
      IF lf<li
         lf:=li
      ENDIF
   ELSEIF tk=K_UP
      // Seta para Cima: desloca para o item anterior.
      SETCOLOR(vcn)
      @ vli+li,0 SAY tampa
      // Mostra o item.
      MostraItReq(li,li,vcn)
      // Decrementa a linha dos itens.
      IF li>1
         --li
      ELSE
         // Realiza o rolamento da tela.
         IF vt>0
            --vt
            SCROLL(vli+1,1,22,78,-1)
            // Mostra o item.
            MostraItReq(li,li,vcn)
         ENDIF
      ENDIF
   ELSEIF tk=K_DOWN
      // Foi pressionada a Seta para Baixo: desloca para o item seguinte.
      SETCOLOR(vcn)
      @ vli+li,0 SAY tampa
      // Mostra o item.
      MostraItReq(li,li,vcn)
      // Incrementa a linha dos itens.
      IF li<lf
         ++li
      ELSE
         // Realiza o rolamento da tela.
         IF vt<(LEN(mItem)-(22-vli)) .AND. !EMPTY(mItem[li+vt,02])
            ++vt
            SCROLL(vli+1,1,22,78,1)
            // Mostra o item.
            MostraItReq(li,li,vcn)
         ENDIF
      ENDIF
   ELSEIF tk=K_PGUP
      // Page Up: se for consulta carrega pr¢ximo registro.
      IF vmodo#5
         LOOP
      ELSE
         vret:=1
         EXIT
      ENDIF
   ELSEIF tk=K_PGDN
      // Page Up: se for consulta carrega registro anterior.
      IF vmodo#5
         LOOP
      ELSE
         vret:=-1
         EXIT
      ENDIF
   ELSEIF tk=K_DEL
      // Diminui a quantidade de itens.
      IF vmodo>2 // Se o modo for Exclus∆o e Consulta volta ao inicio
         LOOP
      ENDIF
      --vord
      // Atualiza o vetor dos itens, eliminando o elemento deletado.
      ADEL(mItem,li+vt)
      ASIZE(mItem,LEN(mItem)-1)
      AADD(mItem,{SPACE(02),SPACE(07),SPACE(40),SPACE(02),0,0,0,0,SPACE(7),0})
      // Atualiza os valores.
      UpDataReq()
      // Atualiza as linhas de controle de ediá∆o na tela.
      IF vt>0
         --vt
      ELSE
         IF lf>1 .AND. lf<(22-vli)
            --lf
         ENDIF
      ENDIF
      // Reapresenta os itens, eliminando o que foi deletado.
      MostraItReq(1,(22-vli),vcn)
   ELSEIF tk=K_F3  // Imprime
      IF vmodo#5 // Se o modo for diferente de Consulta volta ao inicio
         LOOP
      ENDIF
      vareatu:=SELECT()
      vrecatu:=RECNO()
      vtela1:=SAVESCREEN(01,00,23,79)
      ImprReq()
      SELECT(vareatu)
      GO vrecatu
      RESTSCREEN(01,00,23,79,vtela1)
      LOOP
   ELSEIF tk=K_F8
      IF vmodo>2 // Se o modo for Exclus∆o ou Consulta volta ao inicio
         LOOP
      ENDIF
      EditaReq()
   ELSEIF tk=K_ESC
      IF vmodo=5 // Se o modo for consulta volta ao browse
         EXIT
      ENDIF
      // Foi pressionada a tecla <Esc>: finaliza a ediá∆o dos itens.
      @ 24,00 CLEAR
      IF vmodo=4
         Aviso(24,"Transfere o Material desta Requisiá∆o")
      ELSE
         Aviso(24,"Grava a Requisiá∆o de Material")
      ENDIF
      IF Confirme()
         // Atualiza, gravando as vari†veis auxiares no registro do arquivo.
         GravaReq(vmodo)
      ELSE
         EXIT
      ENDIF
      @ 24,02 CLEAR TO 24,78
      Aviso(24,"Imprime a Requisiá∆o de Material")
      IF Confirme()
         ImprReq()
      ENDIF
      @ vli+li,0 SAY tampa
      EXIT
   ENDIF
ENDDO
// Limpa a tela.
@ 24,00 CLEAR
FOR i=22 TO vli+1 STEP -1
    @ i,01 SAY SPACE(78)
NEXT
RETURN

**************************************************************************
PROCEDURE ExcluiReq()
********************
IF !Exclui() // se n∆o exclui
   RETURN    // retorna
ENDIF
// ITENS
SELECT Rqi
SET ORDER TO 2
GO TOP
SEEK vdocto
DO WHILE Rqi->docto=vdocto .AND. !EOF()
   IF Bloqreg(10)
      DELETE // Deleta os itens.
      UNLOCK
   ELSE
      Mensagem("O Registro N∆o Est† Dispon°vel !",3,1)
      LOOP
   ENDIF
   SKIP
ENDDO
// CABEÄALHO
SELECT Req
SET ORDER TO 4
DO WHILE Req->docto+Req->status=vdocto+vstatus .AND. !EOF()
   IF Bloqreg(10)
      DELETE // Deleta os Cabeáalhos.
      UNLOCK
   ELSE
      Mensagem("O Registro N∆o Est† Dispon°vel !",3,1)
      LOOP
   ENDIF
   SKIP
ENDDO
RETURN

********************************************************************************
PROCEDURE TransfReq()
// Transfere os dados do arquivo para as vari†veis auxiliares.
********************************************************************************
LOCAL vrecatual:=RECNO()
LOCAL vordematual:=INDEXORD()
SET ORDER TO 4
SET SOFTSEEK ON
SEEK vdocto
SET SOFTSEEK OFF
vordem  :=Req->ordem
vdocto  :=Req->docto
vstatus :=Req->status
vdata   :=Req->data
ves     :=Req->es
vcodlocd:=Req->codloc
vmovger :=Req->movger
SKIP
vcodlocp:=Req->codloc
SET ORDER TO vordematual
GO vrecatual
RETURN

**************************************************************************
PROCEDURE TransVetReq()
// Transfere os itens do arquivo de dados para os vetores.
***********************************************************
LOCAL k:=1,areatrab:=SELECT()
LOCAL vordematual
SELECT Rqi
GO TOP
vordematual:=Req->ordem
SEEK vordematual
IF FOUND()
   DO WHILE Rqi->ordem=vordematual .AND. k<=LEN(mItem) .AND. !EOF()
      mItem[k,01]:=Rqi->ite      // item
      mItem[k,02]:=Rqi->codpro   // c¢digo do produto
      mItem[k,03]:=Rqi->prod     // nome do produto
      mItem[k,04]:=Rqi->unid     // unidade do produto
      mItem[k,05]:=Rqi->quant    // quantidade
      mItem[k,06]:=Rqi->alt      // altura do vidro
      mItem[k,07]:=Rqi->lar      // largura do vidro
      mItem[k,08]:=Rqi->preco    // preáo unitario do produto
      mItem[k,09]:=Rqi->codvm    // c¢digo de produto do vm
      mItem[k,10]:=Rqi->npecas   // n£mero de peáas
      SKIP
      ++k
   ENDDO
   // Define o n£mero total de itens
   vord:=k-1
ENDIF
// Define a £ltima linha de ediá∆o dos itens (lf).
IF vord >= (22-vli)
   lf:=(22-vli)
ELSE
   lf:=k
ENDIF
@ 24,00 CLEAR
SELECT(areatrab)
RETURN

********************************************************************************
PROCEDURE AtualReq(pes)
// Atualiza os dados do arquivo com as vari†veis auxiliares.
********************************************************************************
//Req->ordem :=vordem
//Req->docto :=vdocto
Req->status:=IF(vmodo=4,"TR","RE")
Req->data  :=vdata
Req->es    :=pes
Req->codloc:=IF(pes="S",vcodlocd,vcodlocp)
Req->movger:=vmovger
Req->datmod:=DATE()
Req->hormod:=TIME()
Req->codop :=vcodop
Req->nsenha:=vnsenha
RETURN

********************************************************************************
PROCEDURE GravaReq(pmodo)
// pmodo: 1-Inclus∆o, 2-Alteraá∆o
// Grava registros nos arquivos de Cabeáalho, Itens, e Saldo
******************************************************************
LOCAL i,j
@ 24,00 CLEAR
SETCOLOR(vcp)
Aviso(24,"Atualizando Registros. Aguarde..")
SETCOLOR(vcn)
//
// Saida (vcodlocd) (mcompo)
//
// CABEÄALHO
SELECT Req
IF pmodo=1  // Se for inclus∆o inclui novo registro
   GO BOTTOM
   vdocto:=STRZERO(VAL(Req->docto)+1,8)
   vordem:=STRZERO(VAL(Req->ordem)+1,6)
   IF Adireg(10)
      Req->ordem:=vordem
      Req->docto:=vdocto
      UNLOCK
   ELSE
      Mensagem("Erro de Rede, Inclus∆o N∆o Efetuada!",3,1)
   ENDIF
ENDIF
IF Bloqreg(10)
   AtualReq("S") // Atualiza o Cabeáaho da Requisiá∆o - Sa°da
   UNLOCK
ELSE
   Mensagem("Erro de Rede, Atualizaá∆o N∆o Efetuada!",3,1)
ENDIF
// ITENS
SELECT Rqi
SET ORDER TO 2 // docto
GO TOP
IF pmodo=2 // Se for Alteraá∆o
   SEEK vdocto
   IF FOUND()
      DO WHILE Rqi->docto=vdocto .AND. !EOF()
         IF Bloqreg(10)
            DELETE // Deleta os itens
            UNLOCK
         ELSE
            Mensagem("Erro de Rede. N∆o Foi Poss°vel Excluir o Registro!",3,1)
         ENDIF
         SKIP
      ENDDO
   ENDIF
ENDIF
SET ORDER TO 1
mCompo:={}
IF vcodlocp="003" .OR. vcodlocp="330" // Produá∆o Vidro ou Kit M2000
   mCompo:=Composicao(mItem)
ENDIF
IF EMPTY(mCompo)
   mCompo:=mItem
ENDIF
i:=1
j:=1
DO WHILE i <= LEN(mCompo)   // Inclui os itens
   IF !EMPTY(mCompo[i,02])
      IF Adireg(10)
         Rqi->ordem  :=vordem       // ordem
         Rqi->data   :=vdata        // data
         Rqi->docto  :=vdocto       // n£mero do documento
         Rqi->ite    :=STRZERO(j,2) // n£mero do item
         Rqi->codpro :=mCompo[i,02] // c¢digo do produto
         Rqi->prod   :=mCompo[i,03] // nome do produto
         Rqi->unid   :=mCompo[i,04] // unidade do produto
         Rqi->quant  :=mCompo[i,05] // quantidade
         Rqi->alt    :=mCompo[i,06] // altura
         Rqi->lar    :=mCompo[i,07] // largura
         Rqi->preco  :=mCompo[i,08] // preáo unit†rio
         Rqi->codvm  :=mCompo[i,09] // c¢digo de produto no vm.
         Rqi->npecas :=mCompo[i,10] // nr. peáas
         UNLOCK
         j++
      ELSE
         Mensagem("Erro de Rede. Inclus∆o N∆o Efetuada !",3,1)
      ENDIF
   ENDIF
   i++
ENDDO
//
// Entrada
//
// CABEÄALHO
SELECT Req
IF pmodo=1  // Se for inclus∆o inclui novo registro
   GO BOTTOM
   vordem:=STRZERO(VAL(Req->ordem)+1,6)
   IF Adireg(10)
      Req->ordem:=vordem
      Req->docto:=vdocto
      UNLOCK
   ELSE
      Mensagem("Erro de Rede, Inclus∆o N∆o Efetuada!",3,1)
   ENDIF
ENDIF
IF pmodo=2  // Se for alteraá∆o vai para o pr¢ximo registro
   SKIP
   vordem:=Req->ordem
ENDIF
IF Bloqreg(10)
   AtualReq("E") // Atualiza o Cabeáaho da Requisiá∆o - Entrada
   UNLOCK
ELSE
   Mensagem("Erro de Rede, Atualizaá∆o N∆o Efetuada!",3,1)
ENDIF
// ITENS
SELECT Rqi
i:=1
j:=1
DO WHILE i <= LEN(mItem)   // Inclui os itens
   IF !EMPTY(mItem[i,02])
      IF Adireg(10)
         Rqi->ordem  :=vordem      // Ordem
         Rqi->data   :=vdata       // Data.
         Rqi->docto  :=vdocto      // N£mero.
         Rqi->ite    :=STRZERO(j,2)// nr. do item
         Rqi->codpro :=mItem[i,02] // c¢digo do produto.
         Rqi->prod   :=mItem[i,03] // nome do produto
         Rqi->unid   :=mItem[i,04] // unidade do produto
         Rqi->quant  :=mItem[i,05] // quantidade.
         Rqi->alt    :=mItem[i,06] // altura.
         Rqi->lar    :=mItem[i,07] // largura.
         Rqi->preco  :=mItem[i,08] // preáo unit†rio.
         Rqi->codvm  :=mItem[i,09] // c¢digo de produto no vm.
         Rqi->npecas :=mItem[i,10] // nr. peáas
         UNLOCK
         j++
      ELSE
         Mensagem("Erro de Rede. Inclus∆o N∆o Efetuada !",3,1)
      ENDIF
   ENDIF
   i++
ENDDO
SELECT Req
RETURN

**************************************************************************
PROCEDURE Composicao(pproduto,pquant)
// Parametros: pproduto = C¢digo do produto ou
//                        Matriz de itens de produtos
// Retorna: mComposicao = Matriz de Componentes conforme arquivo de composiá∆o
***************************************************************
LOCAL x,y,k
LOCAL mComposicao:={} // matriz de itens provos¢ria que ser† retornada
LOCAL vareatrab:=SELECT()
pquant:=IF(pquant=NIL,1,pquant)
SELECT Com
//
IF VALTYPE(pproduto)="C" // foi passado um produto como parÉmetro
   GO TOP
   k:=1
   SEEK pproduto
   IF FOUND()
      DO WHILE Com->codpro=pproduto .AND. !EOF()
         x:=Mascan(mComposicao,2,Com->codcom)
         IF x > 0
            mComposicao[x,05]+=Com->quant*pquant    // quantidade
         ELSE
            AADD(mComposicao,{STRZERO(k,2),;        // 1 numero sequencial do item
            Com->codcom,;                           // 2 c¢digo do componente
            Procura("Prc",1,Com->codcom,"prod"),;   // 3 nome do componente
            Com->unid,;                             // 4 unidade
            Com->quant*pquant,;                     // 5 quantidade
            0,;                                     // 6 altura
            0,;                                     // 7 largura
            Procura("Prc",1,Com->codcom,"precmp"),; // 8 preáo unitario
            SPACE(7),0})                            // 9 e 10 codvm e npecas
            k++
         ENDIF
         SKIP
      ENDDO
   ENDIF
ELSEIF VALTYPE(pproduto)="A" // foi passado uma matriz de produtos como parÉmetro
   GO TOP
   y:=k:=1
   DO WHILE y <= LEN(pproduto)
      IF !EMPTY(pproduto[y,2])
         GO TOP
         SEEK pproduto[y,2]
         IF FOUND()
            DO WHILE Com->codpro=pproduto[y,2] .AND. !EOF()
               x:=Mascan(mComposicao,2,Com->codcom)
               IF x > 0
                  mComposicao[x,05]+=Com->quant*pproduto[y,5] // quantidade
               ELSE
                  AADD(mComposicao,{STRZERO(k,2),;        // numero sequencial do item
                  Com->codcom,;                           // c¢digo do componente
                  Procura("Prc",1,Com->codcom,"prod"),;   // nome do componente
                  Com->unid,;                             // unidade
                  Com->quant*pproduto[y,5],;              // quantidade
                  0,;                                     // altura
                  0,;                                     // largura
                  Procura("Prc",1,Com->codcom,"precmp"),; // preáo unitario
                  SPACE(7),0})                            // codvm e npecas
                  k++
               ENDIF
               SKIP
            ENDDO
         ENDIF
      ENDIF
      ++y
   ENDDO
ENDIF
//
SELECT(vareatrab)
RETURN(mComposicao)

********************************************************************************
PROCEDURE TransfeReq()
// Atualiza Saldos e Atualiza Status da Requisiá∆o
******************************************************************
// Verifica se h† disponibilidade de todo o material
// se faltar algum item n∆o realiza a tranferància
i:=1
DO WHILE i <= LEN(mItem)
   IF !EMPTY(mItem[i,2])
      IF EMPTY(vmovger) // Contabil
         vsaldo:=Saldo(mItem[i,2],vcodlocd)
         IF mItem[i,5] > vsaldo
            Mensagem("Falta material, Transferància N∆o Realizada !",5,1)
            RETURN
         ENDIF
      ELSE              // Gerencial
         vsaldo:=Saldg(mItem[i,2],vcodlocd)
         IF mItem[i,5] > vsaldo
            Mensagem("Falta material, Transferància N∆o Realizada !",5,1)
            RETURN
         ENDIF
      ENDIF
   ENDIF
   i++
ENDDO
IF !Confirme() // Se n∆o confirmar
   RETURN      // Retorna
ENDIF
// SALDO DE ESTOQUE
vordem2:=STRZERO(VAL(vordem)+1,6)
IF EMPTY(vmovger)   // Se for Cont†bil
   TrExped(vordem)  // Sa°da (vcodlocd)
   TrReceb(vordem2) // Entrada (vcodlocp)
ELSE                // Se for Gerencial
   TrExpeg(vordem)  // Sa°da (vcodlocd)
   TrReceg(vordem2) // Entrada (vcodlocp)
ENDIF
//
SELECT Req
DO WHILE Req->docto=vdocto
   IF Bloqreg(10)
      Req->status:="TR"
      Req->datmod:=DATE()
      Req->hormod:=TIME()
      Req->codop :=vcodop
      Req->nsenha:=vnsenha
      UNLOCK
   ELSE
      Mensagem("Erro de Rede, Atualizaá∆o N∆o Efetuada!",3,1)
   ENDIF
   SKIP
ENDDO
RETURN

********************************************************************************
PROCEDURE DevolveReq()
// Atualiza Saldos e Atualiza Status da Requisiá∆o
******************************************************************
// Verifica se h† disponibilidade de todo o material
// se faltar algum item n∆o realiza a tranferància
i:=1
DO WHILE i <= LEN(mItem)
   IF !EMPTY(mItem[i,2])
      IF EMPTY(vmovger) // Contabil
         vsaldo:=Saldo(mItem[i,2],vcodlocp)
         IF mItem[i,5] > vsaldo
            Mensagem("Falta material, Transferància N∆o Realizada !",5,1)
            RETURN
         ENDIF
      ELSE              // Gerencial
         vsaldo:=Saldg(mItem[i,2],vcodlocp)
         IF mItem[i,5] > vsaldo
            Mensagem("Falta material, Transferància N∆o Realizada !",5,1)
            RETURN
         ENDIF
      ENDIF
   ENDIF
   i++
ENDDO
IF !Confirme() // Se n∆o confirmar
   RETURN      // Retorna
ENDIF
// SALDO DE ESTOQUE
vde  :=vcodlocd
vpara:=vcodlocp
vcodlocd:=vpara
vcodlocp:=vde
vordem2:=STRZERO(VAL(vordem)+1,6)
IF EMPTY(vmovger)   // Se for Cont†bil
   TrExped(vordem)  // Sa°da (vcodlocp)
   TrReceb(vordem2) // Entrada (vcodlocd)
ELSE                // Se for Gerencial
   TrExpeg(vordem)  // Sa°da (vcodlocp)
   TrReceg(vordem2) // Entrada (vcodlocd)
ENDIF
//
SELECT Req
DO WHILE Req->docto=vdocto
   IF Bloqreg(10)
      Req->status:="RE"
      Req->datmod:=DATE()
      Req->hormod:=TIME()
      Req->codop :=vcodop
      Req->nsenha:=vnsenha
      UNLOCK
   ELSE
      Mensagem("Erro de Rede, Atualizaá∆o N∆o Efetuada!",3,1)
   ENDIF
   SKIP
ENDDO
RETURN

********************************************************************************
PROCEDURE TrExped(pordem)
// Objetivo: Transferir dando Saida do Local de Estoque.
// Sa°da (vcodlocd)
********************************************************************************
LOCAL vareatrab:=SELECT()
SETCOLOR(vcp)
Aviso(24,"Atualizando Estoque. Aguarde...")
SETCOLOR(vcn)
SELECT Rqi // Itens de Requisiá∆o
GO TOP
SET SOFTSEEK ON
SEEK pordem
SET SOFTSEEK OFF
IF FOUND()
   mSaida:={} // Matriz para Saida
   DO WHILE Rqi->ordem=pordem .AND. !EOF()
      IF VAL(LEFT(Rqi->codpro,2)) < 95 // Se for anterior a serviáos
         AADD(mSaida,{Rqi->codpro,Rqi->quant})
      ENDIF
      SKIP
   ENDDO
   IF !EMPTY(mSaida)
      i:=1
      DO WHILE i <= LEN(mSaida)
         TrExpit(mSaida[i])
         i++
      ENDDO
   ENDIF
ENDIF
SELECT(vareatrab)
@ 24,00 CLEAR
RETURN

********************************************************************************
PROCEDURE TrExpit(pitem)
// Objetivo: Transferir dando Saida por Item do Local de Estoque.
// Sa°da (vcodlocd)
********************************************************************************
SELECT Sdo // Saldo de Estoque
GO TOP
SEEK pitem[1]+vcodlocd
IF FOUND()
   IF Bloqreg(10)
      Sdo->saldo-=pitem[2]
      Sdo->trexp+=pitem[2]
      UNLOCK
   ELSE
      Mensagem("Erro de Rede. Atualizaá∆o N∆o Efetuada !",3,1)
   ENDIF
ELSE
   IF Adireg(10)
      Sdo->codpro:=pitem[1]
      Sdo->codloc:=vcodlocd
      Sdo->saldo -=pitem[2]
      Sdo->trexp :=pitem[2]
      UNLOCK
   ELSE
      Mensagem("Erro de Rede. Atualizaá∆o N∆o Efetuada !",3,1)
   ENDIF
ENDIF
RETURN

********************************************************************************
PROCEDURE TrReceb(pordem)
// Objetivo: Transferir dando Entrada para o Local de Estoque.
// Entrada (vcodlocp)
********************************************************************************
LOCAL vareatrab:=SELECT()
SETCOLOR(vcp)
Aviso(24,"Atualizando Estoque. Aguarde...")
SETCOLOR(vcn)
SELECT Rqi // Itens de Requisiá∆o
GO TOP
SET SOFTSEEK ON
SEEK pordem
SET SOFTSEEK OFF
IF FOUND()
   mEntra:={} // Matriz para Entrada
   DO WHILE Rqi->ordem=pordem .AND. !EOF()
      IF VAL(LEFT(Rqi->codpro,2)) < 95 // Se for anterior a serviáos
         AADD(mEntra,{Rqi->codpro,Rqi->quant})
      ENDIF
      SKIP
   ENDDO
   IF !EMPTY(mEntra)
      i:=1
      DO WHILE i <= LEN(mEntra)
         TrRecit(mEntra[i])
         i++
      ENDDO
   ENDIF
ENDIF
SELECT(vareatrab)
@ 24,00 CLEAR
RETURN

********************************************************************************
PROCEDURE TrRecit(pitem)
// Objetivo: Transferir dando Entrada por Item para o Local de Estoque.
// Entrada (vcodlocp)
********************************************************************************
SELECT Sdo // Saldo de Estoque
GO TOP
SEEK pitem[1]+vcodlocp
IF FOUND()
   IF Bloqreg(10)
      Sdo->saldo+=pitem[2]
      Sdo->trrec+=pitem[2]
      UNLOCK
   ELSE
      Mensagem("Erro de Rede. Atualizaá∆o N∆o Efetuada !",3,1)
   ENDIF
ELSE
   IF Adireg(10)
      Sdo->codpro:=pitem[1]
      Sdo->codloc:=vcodlocp
      Sdo->saldo :=pitem[2]
      Sdo->trrec :=pitem[2]
      UNLOCK
   ELSE
      Mensagem("Erro de Rede. Atualizaá∆o N∆o Efetuada !",3,1)
   ENDIF
ENDIF
RETURN

******************************************************************************
FUNCTION CodLocd()
*****************
DO WHILE .T.
   vcodlocd:=Zeracod(vcodlocd)
   vcodlocd:=Acha2(vcodlocd,"Tlo",1,2,"codi","nome","999","@!",;
             15,02,22,78,"C¢digo","Local")
   IF EMPTY(vcodlocd) .OR. LASTKEY()==K_ESC
      LOOP
   ENDIF
   TelaReq()
   RETURN .T.
ENDDO

******************************************************************************
FUNCTION CodLocp()
*****************
DO WHILE .T.
   vcodlocp:=Zeracod(vcodlocp)
   vcodlocp:=Acha2(vcodlocp,"Tlo",1,2,"codi","nome","999","@!",;
             15,02,22,78,"C¢digo","Local")
   IF EMPTY(vcodlocp) .OR. LASTKEY()==K_ESC
      LOOP
   ENDIF
   IF vcodlocp=vcodlocd
      Mensagem("Local Inv†lido !",3,1)
      vcodlocp:=SPACE(03)
      RETURN .F.
   ENDIF
   TelaReq()
   IF vcodlocp="003" // Produá∆o Vidro
      IncPlano()
   ENDIF
   IF vcodlocp="330" // Produá∆o Kit M2000
      IncKM2000()
   ENDIF
   RETURN .T.
ENDDO

******************************************************************************
PROCEDURE IniMatItReq(pi,pf)
// Inicializa a matriz de itens
// pi-elemento inicial    pf-elemento final
********************************************
DO WHILE pi <= pf
   mItem[pi,01]:=SPACE(02)    // item
   mItem[pi,02]:=SPACE(07)    // codpro
   mItem[pi,03]:=SPACE(30)    // prod
   mItem[pi,04]:=SPACE(02)    // unid
   mItem[pi,05]:=0            // quant
   mItem[pi,06]:=0            // alt
   mItem[pi,07]:=0            // lar
   mItem[pi,08]:=0            // preco
   mItem[pi,09]:=SPACE(07)    // codvm
   mItem[pi,10]:=0            // npecas
   pi++
ENDDO
RETURN

******************************************************************************
PROCEDURE UpDataReq()
// Atualiza as vari†veis de tela
*************************************
LOCAL i:=1
vvalor:=0
DO WHILE i <= LEN(mItem)
   IF !EMPTY(mItem[i,02])
      vvalor+=ROUND(mItem[i,05]*mItem[i,08],2)
   ENDIF
   i++
ENDDO
// Reapresenta os valores do Pedido.
SETCOLOR(vcd)
@ 08,69 SAY vvalor PICTURE "@E 999,999.99"
SETCOLOR(vcn)
RETURN

********************************************************************************
PROCEDURE IncPlano()
// Inclui plano de corte na Requisiá∆o
********************************************************************************
LOCAL mComum:={"01","02","03","04","06","07","08"}
LOCAL mLaminado:={"30","32","34","36","38"}
LOCAL mTemperado:={"40","41","43","44","45","46","48"} //,"72","73"}
LOCAL mCurvo:={"10","11","12","13"}
//
IF Abrearq((dirvm+"VM_CORTE.DBF"),"Cort",.F.,10)
   SET INDEX TO (dirvm+"VM_CORT1"),(dirvm+"VM_CORT2")
ELSE
   Mensagem("O Arquivo de Planos de Cortes N∆o Est† Dispon°vel!",3,1)
   RETURN
ENDIF
//
IF Abrearq((dirvm+"VM_ITCOR.DBF"),"Cri",.F.,10)
   SET INDEX TO (dirvm+"VM_ITCO1")
ELSE
   Mensagem("O Arquivo de Itens de Corte N∆o Est† Dispon°vel!",3,1)
   CLOSE Cort
   RETURN
ENDIF
//
IF Abrearq((dirvm+"VM_ITPED.DBF"),"Pdi",.F.,10)
   SET INDEX TO (dirvm+"VM_ITPE1")
ELSE
   Mensagem("O Arquivo de Itens de Pedido N∆o Est† Dispon°vel!",3,1)
   CLOSE Cort
   CLOSE Cri
   RETURN
ENDIF
//
IF Abrearq((dirvm+"VM_PRODU.DBF"),"Pro",.F.,10)
   SET INDEX TO (dirvm+"VM_PROD1")
ELSE
   Mensagem("O Arquivo de Produtos do VM N∆o Est† Dispon°vel!",3,1)
   CLOSE Cort
   CLOSE Cri
   CLOSE Pdi
   RETURN
ENDIF
//
DO WHILE .T.
   // PLANO DE CORTE
   SELECT Cort
   vnrel:=SPACE(04)
   @ 08,05 SAY "Plano de Corte:"
   SETCOLOR(vcd)
   @ 08,20 GET vnrel PICTURE "9999"
   Le()
   vnrel:=Zeracod(vnrel)
   vnrel:=Acha2(vnrel,"Cort",1,2,"nrel","data","9999","99/99/99",15,05,22,76,"Nr. do Plano","Data")
   @ 08,20 SAY vnrel PICTURE "9999"
   SETCOLOR(vcn)
   // ITENS DE PLANO DE CORTE - PEDIDOS
   SELECT Cri
   mPed:={}
   SEEK vnrel
   IF FOUND()
      DO WHILE Cri->nrel=vnrel .AND. !EOF()
         AADD(mPed,Cri->ped)
         SKIP
      ENDDO
   ENDIF
   IF EMPTY(mPed)
      EXIT
   ENDIF
   // ITENS DOS PEDIDOS
   SELECT Pdi
   k:=1
   y:=1
   DO WHILE y <= LEN(mPed)
      GO TOP
      SEEK mPed[y]
      IF FOUND()
         DO WHILE Pdi->nupd=mPed[y] .AND. !EOF()
            IF ALLTRIM(Pdi->codpro)#"*"
               vcodfx:=Procura("Pro",1,Pdi->codpro,"codfx")
               x:=Mascan(mItem,2,vcodfx)
               IF x > 0
                  mItem[x,05]+=Pdi->quant*Quant(Pdi->unid,Pdi->codpro,Pdi->alt,Pdi->lar)
               ELSE
                  mItem[k,01]:=STRZERO(k,2) // numero sequencial do item
                  mItem[k,02]:=vcodfx       // c¢digo dos produtos.
                  mItem[k,03]:=Procura("Prc",1,vcodfx,"prod") // nome do produto
                  mItem[k,04]:=Procura("Prc",1,vcodfx,"unid") // unidade do produto
                  mItem[k,05]:=Pdi->quant*Quant(Pdi->unid,Pdi->codpro,Pdi->alt,Pdi->lar)
                  mItem[k,06]:=0 // alt
                  mItem[k,07]:=0 // lar
                  mItem[k,08]:=ROUND(Pdi->preco,2)
                  k++
               ENDIF
            ENDIF
            SKIP
         ENDDO
      ENDIF
      ++y
   ENDDO
   // Define o n£mero total de itens
   vord:=k-1
   // Define a £ltima linha de ediá∆o dos itens (lf).
   IF vord>=(22-vli)
      lf:=(22-vli)
   ELSE
      lf:=vord+1
   ENDIF
   // Reapresenta os itens
   MostraItReq(1,vord,vcn)
   EXIT
ENDDO
// Fecha os arquivos auxiliares do VM.
CLOSE Cort
CLOSE Cri
CLOSE Pdi
CLOSE Pro
RETURN

********************************************************************************
PROCEDURE IncKM2000()
// Inclui plano de corte na Requisiá∆o
********************************************************************************
PRIVATE mSoma2000[47,4]
//
IF Abrearq((dirvm+"VM_M2000.DBF"),"Kit",.F.,10)
   SET INDEX TO (dirvm+"VM_M2001"),(dirvm+"VM_M2002")
ELSE
   Mensagem("O Arquivo de Planos N∆o Est† Dispon°vel!",3,1)
   RETURN
ENDIF
//
IF Abrearq((dirvm+"VM_I2000.DBF"),"Itk",.F.,10)
   SET INDEX TO (dirvm+"VM_I2001")
ELSE
   Mensagem("O Arquivo de Itens de Planos N∆o Est† Dispon°vel!",3,1)
   CLOSE Kit
   RETURN
ENDIF
//
IF Abrearq((dirvm+"VM_ITPED.DBF"),"Pdi",.F.,10)
   SET INDEX TO (dirvm+"VM_ITPE1")
ELSE
   Mensagem("O Arquivo de Itens de Pedido N∆o Est† Dispon°vel!",3,1)
   CLOSE Kit
   CLOSE Itk
   RETURN
ENDIF
//
IF Abrearq((dirvm+"VM_PRODU.DBF"),"Pro",.F.,10)
   SET INDEX TO (dirvm+"VM_PROD1")
ELSE
   Mensagem("O Arquivo de Produtos do VM N∆o Est† Dispon°vel!",3,1)
   CLOSE Kit
   CLOSE Itk
   CLOSE Pdi
   RETURN
ENDIF
//
DO WHILE .T.
   // PLANO DE CORTE
   SELECT Kit
   vcork:=SPACE(01)
   vnrel:=SPACE(04)
   @ 08,05 SAY "Plano de Corte:"
   SETCOLOR(vcd)
   @ 08,20 GET vnrel PICTURE "9999"
   Le()
   vnrel:=Zeracod(vnrel)
   vnrel:=Acha2(vnrel,"Kit",1,2,"nrel","data","9999","99/99/99",15,05,22,76,"Nr. do Plano","Data")
   @ 08,20 SAY vnrel PICTURE "9999"
   vcork:=Procura("Kit",1,vnrel,"cork") // 1-Natural, 2-Preto e 3-Bronze
   SETCOLOR(vcn)
   // ITENS DE PLANO DE CORTE - PEDIDOS
   SELECT Itk
   mPed:={}
   SEEK vnrel
   IF FOUND()
      DO WHILE Itk->nrel=vnrel .AND. !EOF()
         AADD(mPed,Itk->ped)
         SKIP
      ENDDO
   ENDIF
   IF EMPTY(mPed)
      EXIT
   ENDIF
   // ITENS DOS PEDIDOS
   SELECT Pdi
   //
   IniciaM2000()
   j:=1
   DO WHILE LEN(mSoma2000) >= j
      mSoma2000[j,2]:=0
      j++
   ENDDO
   //
   k:=1
   DO WHILE LEN(mPed) >= k
      SEEK mPed[k]
      IF FOUND()
         vped:=mPed[k]
         DO WHILE vped=Pdi->nupd
            IF LEFT(Pdi->codpro,2)=="73"
               j:=1
               DO WHILE j <= LEN(mSoma2000)
                  mSoma2000[j,2]+=Pdi->quant*CalcM2000(Pdi->codpro,j,;
                  Pdi->alt1,Pdi->lar1,;
                  Pdi->alt2,Pdi->lar2,;
                  Pdi->alt3,Pdi->lar3,;
                  Pdi->alt4,Pdi->lar4,;
                  Pdi->alt5,Pdi->lar5,;
                  Pdi->alt6,Pdi->lar6,;
                  Pdi->alt7,Pdi->lar7,;
                  Pdi->alt8,Pdi->lar8,Pdi->tran)
                  j++
               ENDDO
            ENDIF
            SKIP
         ENDDO
      ENDIF
      k++
   ENDDO
   //
   j:=1
   k:=1
   DO WHILE j <= LEN(mSoma2000)
      IF mSoma2000[j,2]=0
         j++
         LOOP
      ENDIF
      vcodpro:=ConverteM2000(j,VAL(vcork))
      IF EMPTY(vcodpro) // por causa que n∆o tem correspondente no cadastro de produtos
         j++
         LOOP
      ENDIF
      x:=Mascan(mItem,2,vcodpro)
      IF x > 0
         mItem[x,05]+=mSoma2000[j,2]
      ELSE
         mItem[k,01]:=STRZERO(k,2) // numero sequencial do item
         mItem[k,02]:=vcodpro      // c¢digo dos produtos.
         mItem[k,03]:=Procura2("Prc",1,vcodpro,"prod") // nome do produto
         mItem[k,04]:=Procura2("Prc",1,vcodpro,"unid") // unidade do produto
         mItem[k,05]:=mSoma2000[j,2]
         mItem[k,06]:=0 // alt
         mItem[k,07]:=0 // lar
         mItem[k,08]:=Procura2("Prc",1,vcodpro,"precmp") // preáo de compra
         k++
      ENDIF
      j++
   ENDDO
   // Define o n£mero total de itens
   vord:=k-1
   // Define a £ltima linha de ediá∆o dos itens (lf).
   IF vord>=(22-vli)
      lf:=(22-vli)
   ELSE
      lf:=vord+1
   ENDIF
   // Reapresenta os itens
   MostraItReq(1,vord,vcn)
   EXIT
ENDDO
// Fecha os arquivos auxiliares do VM.
CLOSE Kit
CLOSE Itk
CLOSE Pdi
CLOSE Pro
RETURN

******************************************************************************
PROCEDURE ConverteM2000(pitem,pcork)
*************************************
IF pitem=1 .OR. pitem=2        // Perfil trilho
   IF pcork=1
      RETURN "7410050"
   ELSEIF pcork=2
      RETURN "7430050"
   ELSEIF pcork=3
      RETURN "7440050"
   ENDIF
ELSEIF pitem=3 .OR. pitem=4    // Perfil capa
   IF pcork=1
      RETURN "7410051"
   ELSEIF pcork=2
      RETURN "7430051"
   ELSEIF pcork=3
      RETURN "7440051"
   ENDIF
ELSEIF pitem>4 .AND. pitem<15  // Perfil arremate
   IF pcork=1
      RETURN "7410043"
   ELSEIF pcork=2
      RETURN "7430043"
   ELSEIF pcork=3
      RETURN "7440043"
   ENDIF
ELSEIF pitem>14 .AND. pitem<21 // Perfil calha "E"
   IF pcork=1
      RETURN "7410052"
   ELSEIF pcork=2
      RETURN "7430052"
   ELSEIF pcork=3
      RETURN "7440052"
   ENDIF
ELSEIF pitem>20 .AND. pitem<25 // Perfil AL-46
   IF pcork=1
      RETURN "7410046"
   ELSEIF pcork=2
      RETURN "7430046"
   ELSEIF pcork=3
      RETURN "7440046"
   ENDIF
ELSEIF pitem=25 .AND. pitem=26 // Perfil calha "H"
   IF pcork=1
      RETURN "7410047"
   ELSEIF pcork=2
      RETURN "7430047"
   ELSEIF pcork=3
      RETURN "7440047"
   ENDIF
ELSEIF pitem=27                // Borracha
   RETURN "7520006"            // GUA 039 (6mm)
   //     "7520007"            // GUA 038 (8mm)
   //
ELSEIF pitem=28                // Fitilho 5/7
   IF pcork=1
      RETURN "7521001"
   ELSE
      RETURN "7523001"
   ENDIF
ELSEIF pitem=29                // Fitilho 7/6
   IF pcork=1
      RETURN "7521002"
   ELSE
      RETURN "7523002"
   ENDIF
ELSEIF pitem=30                // Roldana
   RETURN "7520004"
ELSEIF pitem=31                // Suporte de fixaá∆o
   RETURN "7520010"
ELSEIF pitem=32                // Cunha trava
   RETURN "7520011"
ELSEIF pitem=33                // Batedeira lim.superior
   RETURN "7520005"
ELSEIF pitem=34                // Parafuso fecho
   IF pcork=1
      RETURN "7521040"         // 6mm
   ELSE
      RETURN "7523040"
   ENDIF
   /*
   IF pcork=1
      RETURN "7521041"         // 8mm
   ELSE
      RETURN "7523041"
   ENDIF
   */
ELSEIF pitem=35                // Capa do parafuso fecho
   RETURN ""
ELSEIF pitem=36                // Porca
   RETURN ""
ELSEIF pitem=37                // Fecho central
   IF pcork=1
      RETURN "7521020"
   ELSEIF pcork=2
      RETURN "7523020"
   ELSEIF pcork=3
      RETURN "7524020"
   ENDIF
ELSEIF pitem=38                // Fecho lateral
   IF pcork=1
      RETURN "7521030"
   ELSEIF pcork=2
      RETURN "7523030"
   ELSEIF pcork=3
      RETURN "7524030"
   ENDIF
ELSEIF pitem=39                // Parafuso grande
   RETURN "7520009"
ELSEIF pitem=40                // Parafuso pequeno
   RETURN "7520008"
ELSEIF pitem=41                // Bucha
   RETURN "7520001"            // Nß 5
   //RETURN "7520002"          // Nß 6
   //
ELSEIF pitem=42                // Dobradiáa
   IF pcork=1
      RETURN "7521501"
   ELSEIF pcork=2
      RETURN "7523501"
   ELSEIF pcork=3
      RETURN "7524501"
   ENDIF
ELSEIF pitem=43                // Haste 200mm
   IF pcork=1
      RETURN "7521200"
   ELSEIF pcork=2
      RETURN "7523200"
   ELSEIF pcork=3
      RETURN "7524200"
   ENDIF
ELSEIF pitem=44                // Haste 250mm
   IF pcork=1
      RETURN "7521250"
   ELSEIF pcork=2
      RETURN "7523250"
   ELSEIF pcork=3
      RETURN "7524250"
   ENDIF
ELSEIF pitem=45                // Haste 300mm
   IF pcork=1
      RETURN "7521300"
   ELSEIF pcork=2
      RETURN "7523300"
   ELSEIF pcork=3
      RETURN "7524300"
   ENDIF
ELSEIF pitem=46                // Perfil tubo
   IF pcork=1
      RETURN "7410090"
   ELSEIF pcork=2
      RETURN "7430090"
   ELSEIF pcork=3
      RETURN "7440090"
   ENDIF
ELSEIF pitem=47                // Fechadura
   RETURN ""
ENDIF

******************************************************************************
PROCEDURE IniciaM2000()
***********************
mSoma2000[01,1]:="PERFIL TRILHO";       mSoma2000[01,3]:=" m"    ; mSoma2000[01,4]:="@E 99,999.99"
mSoma2000[02,1]:="PERFIL TRILHO";       mSoma2000[02,3]:=" m"    ; mSoma2000[02,4]:="@E 99,999.99"
mSoma2000[03,1]:="PERFIL CAPA";         mSoma2000[03,3]:=" m"    ; mSoma2000[03,4]:="@E 99,999.99"
mSoma2000[04,1]:="PERFIL CAPA";         mSoma2000[04,3]:=" m"    ; mSoma2000[04,4]:="@E 99,999.99"
mSoma2000[05,1]:="PERFIL ARREMATE";     mSoma2000[05,3]:=" m"    ; mSoma2000[05,4]:="@E 99,999.99"
mSoma2000[06,1]:="PERFIL ARREMATE";     mSoma2000[06,3]:=" m"    ; mSoma2000[06,4]:="@E 99,999.99"
mSoma2000[07,1]:="PERFIL ARREMATE";     mSoma2000[07,3]:=" m"    ; mSoma2000[07,4]:="@E 99,999.99"
mSoma2000[08,1]:="PERFIL ARREMATE";     mSoma2000[08,3]:=" m"    ; mSoma2000[08,4]:="@E 99,999.99"
mSoma2000[09,1]:="PERFIL ARREMATE";     mSoma2000[09,3]:=" m"    ; mSoma2000[09,4]:="@E 99,999.99"
mSoma2000[10,1]:="PERFIL ARREMATE";     mSoma2000[10,3]:=" m"    ; mSoma2000[10,4]:="@E 99,999.99"
mSoma2000[11,1]:="PERFIL ARREMATE";     mSoma2000[11,3]:=" m"    ; mSoma2000[11,4]:="@E 99,999.99"
mSoma2000[12,1]:="PERFIL ARREMATE";     mSoma2000[12,3]:=" m"    ; mSoma2000[12,4]:="@E 99,999.99"
mSoma2000[13,1]:="PERFIL ARREMATE";     mSoma2000[13,3]:=" m"    ; mSoma2000[13,4]:="@E 99,999.99"
mSoma2000[14,1]:="PERFIL ARREMATE";     mSoma2000[14,3]:=" m"    ; mSoma2000[14,4]:="@E 99,999.99"
mSoma2000[15,1]:="PERFIL GUIA DUPLO";   mSoma2000[15,3]:=" m"    ; mSoma2000[15,4]:="@E 99,999.99"
mSoma2000[16,1]:="PERFIL GUIA DUPLO";   mSoma2000[16,3]:=" m"    ; mSoma2000[16,4]:="@E 99,999.99"
mSoma2000[17,1]:="PERFIL GUIA DUPLO";   mSoma2000[17,3]:=" m"    ; mSoma2000[17,4]:="@E 99,999.99"
mSoma2000[18,1]:="PERFIL GUIA DUPLO";   mSoma2000[18,3]:=" m"    ; mSoma2000[18,4]:="@E 99,999.99"
mSoma2000[19,1]:="PERFIL GUIA DUPLO";   mSoma2000[19,3]:=" m"    ; mSoma2000[19,4]:="@E 99,999.99"
mSoma2000[20,1]:="PERFIL GUIA DUPLO";   mSoma2000[20,3]:=" m"    ; mSoma2000[20,4]:="@E 99,999.99"
mSoma2000[21,1]:="PERFIL AL-46";        mSoma2000[21,3]:=" m"    ; mSoma2000[21,4]:="@E 99,999.99"
mSoma2000[22,1]:="PERFIL AL-46";        mSoma2000[22,3]:=" m"    ; mSoma2000[22,4]:="@E 99,999.99"
mSoma2000[23,1]:="PERFIL AL-46";        mSoma2000[23,3]:=" m"    ; mSoma2000[23,4]:="@E 99,999.99"
mSoma2000[24,1]:="PERFIL AL-46";        mSoma2000[24,3]:=" m"    ; mSoma2000[24,4]:="@E 99,999.99"
mSoma2000[25,1]:='CALHA "H"';           mSoma2000[25,3]:=" m"    ; mSoma2000[25,4]:="@E 99,999.99"
mSoma2000[26,1]:='CALHA "H"';           mSoma2000[26,3]:=" m"    ; mSoma2000[26,4]:="@E 99,999.99"
mSoma2000[27,1]:="BORRACHA";            mSoma2000[27,3]:=" m"    ; mSoma2000[27,4]:="@E 99,999.99"
mSoma2000[28,1]:="ESCOVA VEDAÄ«O 5/7";  mSoma2000[28,3]:=" m"    ; mSoma2000[28,4]:="@E 99,999.99"
mSoma2000[29,1]:="ESCOVA VEDAÄ«O 7/6";  mSoma2000[29,3]:=" m"    ; mSoma2000[29,4]:="@E 99,999.99"
mSoma2000[30,1]:="ROLDANA";             mSoma2000[30,3]:=" unid" ; mSoma2000[30,4]:="99999"
mSoma2000[31,1]:="SUPORTE DE FIXAÄ«O";  mSoma2000[31,3]:=" unid" ; mSoma2000[31,4]:="99999"
mSoma2000[32,1]:="CUNHA TRAVA";         mSoma2000[32,3]:=" unid" ; mSoma2000[32,4]:="99999"
mSoma2000[33,1]:="BATEDEIRA LIM. SUP."; mSoma2000[33,3]:=" unid" ; mSoma2000[33,4]:="99999"
mSoma2000[34,1]:="PARAFUSO FECHO";      mSoma2000[34,3]:=" unid" ; mSoma2000[34,4]:="99999"
mSoma2000[35,1]:="CAPA PARAFUSO FECHO"; mSoma2000[35,3]:=" unid" ; mSoma2000[35,4]:="99999"
mSoma2000[36,1]:="PORCA";               mSoma2000[36,3]:=" unid" ; mSoma2000[36,4]:="99999"
mSoma2000[37,1]:="FECHO CENTRAL";       mSoma2000[37,3]:=" unid" ; mSoma2000[37,4]:="99999"
mSoma2000[38,1]:="FECHO LATERAL";       mSoma2000[38,3]:=" unid" ; mSoma2000[38,4]:="99999"
mSoma2000[39,1]:="PARAFUSO GRANDE";     mSoma2000[39,3]:=" unid" ; mSoma2000[39,4]:="99999"
mSoma2000[40,1]:="PARAFUSO PEQUENO";    mSoma2000[40,3]:=" unid" ; mSoma2000[40,4]:="99999"
mSoma2000[41,1]:="BUCHA DE NYLON";      mSoma2000[41,3]:=" unid" ; mSoma2000[41,4]:="99999"
mSoma2000[42,1]:="DOBRADIÄA";           mSoma2000[42,3]:=" unid" ; mSoma2000[42,4]:="99999"
mSoma2000[43,1]:="HASTE 200MM";         mSoma2000[43,3]:=" unid" ; mSoma2000[43,4]:="99999"
mSoma2000[44,1]:="HASTE 250MM";         mSoma2000[44,3]:=" unid" ; mSoma2000[44,4]:="99999"
mSoma2000[45,1]:="HASTE 300MM";         mSoma2000[45,3]:=" unid" ; mSoma2000[45,4]:="99999"
mSoma2000[46,1]:="PERFIL TUBO";         mSoma2000[46,3]:=" m"    ; mSoma2000[46,4]:="@E 99,999.99"
mSoma2000[47,1]:="FECHADURA";           mSoma2000[47,3]:=" unid" ; mSoma2000[47,4]:="99999"
RETURN

*******************************************************************************************************************************
PROCEDURE CalcM2000(pcod,pitem,palt1,plar1,palt2,plar2,palt3,plar3,;
          palt4,plar4,palt5,plar5,palt6,plar6,palt7,plar7,palt8,plar8,pfecho)
********************************************************************************************************************************
LOCAL valor
IF LEFT(pcod,2)=="73" .AND. RIGHT(pcod,4)=="4401"  // J1
   IF pitem=1      // trilho 1
      valor:=plar1+plar2
      RETURN valor/1000
   ELSEIF pitem=3  // perfil capa 1
      valor:=plar1+plar2
      RETURN valor/1000
   ELSEIF pitem=5  // perfil arremate 1
      valor:=palt1
      RETURN valor/1000
   ELSEIF pitem=6  // perfil arremate 2
      valor:=plar1
      RETURN valor/1000
   ELSEIF pitem=7  // perfil arremate 3
      valor:=plar1
      RETURN valor/1000
   ELSEIF pitem=15 // perfil guia duplo 1
      valor:=plar1+plar2
      RETURN valor/1000
   ELSEIF pitem=16 // perfil guia duplo 2
      valor:=palt1
      RETURN valor/1000
   ELSEIF pitem=17 // perfil guia duplo 3
      valor:=palt1
      RETURN valor/1000
   ELSEIF pitem=21 // perfil AL-46 1
      valor:=palt1+50
      RETURN valor/1000
   ELSEIF pitem=27 // borracha
      valor:=palt1+plar1
      RETURN valor/1000
   ELSEIF pitem=28 // fitilho 5/7
      valor:=4*palt1+4*plar1
      RETURN valor/1000
   ELSEIF pitem=29 // fitilho 7/6
      valor:=palt1+50
      RETURN valor/1000
   ELSEIF pitem=30 // roldana
      RETURN 2
   //ELSEIF pitem=31 // suporte de fixaá∆o
   //   RETURN 2
   //ELSEIF pitem=32 // cunha
   //   RETURN 2
   ELSEIF pitem=33 // batedor
      RETURN 2
   ELSEIF pitem=34 // parafuso fecho
      RETURN 2
   ELSEIF pitem=35 // capa do parafuso fecho
      RETURN 2
   ELSEIF pitem=36 // porca
      RETURN 2
   ELSEIF pitem=38 // fecho lateral
      RETURN 1
   ELSEIF pitem=39 // parafuso grande
      RETURN 4
   ELSEIF pitem=40 // parafuso pequeno
      RETURN 7
   ELSEIF pitem=41 // bucha
      RETURN 11
   ELSE
      RETURN 0
   ENDIF
ELSEIF LEFT(pcod,2)=="73" .AND. RIGHT(pcod,4)=="4402"  // J2
   IF pitem=1      // trilho 1
      valor:=plar3+50
      RETURN valor/1000
   ELSEIF pitem=3 // perfil capa 1
      valor:=plar3+50
      RETURN valor/1000
   ELSEIF pitem=5 // perfil arremate 1
      valor:=plar1
      RETURN valor/1000
   ELSEIF pitem=6 // perfil arremate 2
      valor:=plar1
      RETURN valor/1000
   ELSEIF pitem=7 // perfil arremate 3
      valor:=palt1
      RETURN valor/1000
   ELSEIF pitem=8 // perfil arremate 4
      valor:=plar3+50
      RETURN valor/1000
   ELSEIF pitem=9 // perfil arremate 5
      valor:=plar3+50
      RETURN valor/1000
   ELSEIF pitem=10 // perfil arremate 6
      valor:=palt3+50
      RETURN valor/1000
   ELSEIF pitem=11 // perfil arremate 7
      valor:=palt3+50
      RETURN valor/1000
   ELSEIF pitem=15 // perfil guia duplo 1
      valor:=plar3+50
      RETURN valor/1000
   ELSEIF pitem=16 // perfil guia duplo 2
      valor:=plar3+50
      RETURN valor/1000
   ELSEIF pitem=17 // perfil guia duplo 3
      valor:=plar3+50
      RETURN valor/1000
   ELSEIF pitem=18 // perfil guia duplo 4
      valor:=palt1+palt3
      RETURN valor/1000
   ELSEIF pitem=19 // perfil guia duplo 5
      valor:=palt1+palt3
      RETURN valor/1000
   ELSEIF pitem=21 // perfil AL-46 1
      valor:=palt1
      RETURN valor/1000
   ELSEIF pitem=27 // borracha
      valor:=palt1+plar2+2*plar3+2*palt3
      RETURN valor/1000
   ELSEIF pitem=28 // fitilho 5/7
      valor:=4*palt1+2*plar3+100
      RETURN valor/1000
   ELSEIF pitem=29 // fitilho 7/6
      valor:=palt1+100
      RETURN valor/1000
   ELSEIF pitem=30 // roldana
      RETURN 2
   //ELSEIF pitem=31 // suporte de fixaá∆o
   //   RETURN 2
   //ELSEIF pitem=32 // cunha
   //   RETURN 2
   ELSEIF pitem=33 // batedor
      RETURN 2
   ELSEIF pitem=34 // parafuso fecho
      RETURN 2
   ELSEIF pitem=35 // capa do parafuso fecho
      RETURN 2
   ELSEIF pitem=36 // porca
      RETURN 2
   ELSEIF pitem=38 // fecho lateral
      RETURN 1
   ELSEIF pitem=39 // parafuso grande
      RETURN 4
   ELSEIF pitem=40 // parafuso pequeno
      RETURN 14
   ELSEIF pitem=41 // bucha
      RETURN 18
   ELSE
      RETURN 0
   ENDIF
ELSEIF LEFT(pcod,2)=="73" .AND. RIGHT(pcod,4)=="4403"  // J3
   IF pitem=1      // trilho 1
      valor:=plar1+50
      RETURN valor/1000
   ELSEIF pitem=3 // perfil capa 1
      valor:=plar1+50
      RETURN valor/1000
   ELSEIF pitem=5 // perfil arremate 1
      valor:=palt1+50
      RETURN valor/1000
   ELSEIF pitem=6 // perfil arremate 2
      valor:=palt1+50
      RETURN valor/1000
   ELSEIF pitem=7 // perfil arremate 3
      valor:=plar1+50
      RETURN valor/1000
   ELSEIF pitem=8 // perfil arremate 4
      valor:=plar1+50
      RETURN valor/1000
   ELSEIF pitem=9 // perfil arremate 5
      valor:=plar2
      RETURN valor/1000
   ELSEIF pitem=10 // perfil arremate 6
      valor:=plar2
      RETURN valor/1000
   ELSEIF pitem=11 // perfil arremate 7
      valor:=palt2
      RETURN valor/1000
   ELSEIF pitem=15 // perfil guia duplo 1
      valor:=plar1+50
      RETURN valor/1000
   ELSEIF pitem=16 // perfil guia duplo 2
      valor:=plar1+50
      RETURN valor/1000
   ELSEIF pitem=17 // perfil guia duplo 3
      valor:=plar1+50
      RETURN valor/1000
   ELSEIF pitem=18 // perfil guia duplo 4
      valor:=palt2+palt1
      RETURN valor/1000
   ELSEIF pitem=19 // perfil guia duplo 5
      valor:=palt2+palt1
      RETURN valor/1000
   ELSEIF pitem=21 // perfil AL-46 1
      valor:=palt2
      RETURN valor/1000
   ELSEIF pitem=27 // borracha
      valor:=2*plar1+2*palt1+plar3+palt2
      RETURN valor/1000
   ELSEIF pitem=28 // fitilho 5/7
      valor:=4*palt2+2*plar1+100
      RETURN valor/1000
   ELSEIF pitem=29 // fitilho 7/6
      valor:=palt2+50
      RETURN valor/1000
   ELSEIF pitem=30 // roldana
      RETURN 2
   ELSEIF pitem=31 // suporte de fixaá∆o
      RETURN 2
   ELSEIF pitem=32 // cunha
      RETURN 2
   ELSEIF pitem=33 // batedor
      RETURN 2
   ELSEIF pitem=34 // parafuso fecho
      RETURN 2
   ELSEIF pitem=35 // capa do parafuso fecho
      RETURN 2
   ELSEIF pitem=36 // porca
      RETURN 2
   ELSEIF pitem=38 // fecho lateral
      RETURN 1
   ELSEIF pitem=39 // parafuso grande
      RETURN 4
   ELSEIF pitem=40 // parafuso pequeno
      RETURN 14
   ELSEIF pitem=41 // bucha
      RETURN 18
   ELSE
      RETURN 0
   ENDIF
ELSEIF LEFT(pcod,2)=="73" .AND. RIGHT(pcod,4)=="4404"  // J4
   IF pitem=1      // trilho 1
      valor:=plar5+50
      RETURN valor/1000
   ELSEIF pitem=2  // trilho 2
      valor:=plar5+50
      RETURN valor/1000
   ELSEIF pitem=3 // perfil capa 1
      valor:=plar5+50
      RETURN valor/1000
   ELSEIF pitem=4 // perfil capa 2
      valor:=plar5+50
      RETURN valor/1000
   ELSEIF pitem=5 // perfil arremate 1
      valor:=plar2
      RETURN valor/1000
   ELSEIF pitem=6 // perfil arremate 2
      valor:=plar2
      RETURN valor/1000
   ELSEIF pitem=7 // perfil arremate 3
      valor:=plar2
      RETURN valor/1000
   ELSEIF pitem=8 // perfil arremate 4
      valor:=plar2
      RETURN valor/1000
   ELSEIF pitem=9 // perfil arremate 5
      valor:=palt2
      RETURN valor/1000
   ELSEIF pitem=10 // perfil arremate 6
      valor:=palt4
      RETURN valor/1000
   ELSEIF pitem=11 // perfil arremate 7
      valor:=plar5+50
      RETURN valor/1000
   ELSEIF pitem=12 // perfil arremate 8
      valor:=plar5+50
      RETURN valor/1000
   ELSEIF pitem=13 // perfil arremate 9
      valor:=palt5+50
      RETURN valor/1000
   ELSEIF pitem=14 // perfil arremate 10
      valor:=palt5+50
      RETURN valor/1000
   ELSEIF pitem=15 // perfil guia duplo 1
      valor:=plar5+50
      RETURN valor/1000
   ELSEIF pitem=16 // perfil guia duplo 2
      valor:=plar5+50
      RETURN valor/1000
   ELSEIF pitem=17 // perfil guia duplo 3
      valor:=plar5+50
      RETURN valor/1000
   ELSEIF pitem=18 // perfil guia duplo 4
      valor:=plar5+50
      RETURN valor/1000
   ELSEIF pitem=19 // perfil guia duplo 5
      valor:=palt5+palt4+palt2
      RETURN valor/1000
   ELSEIF pitem=20 // perfil guia duplo 6
      valor:=palt5+palt4+palt2
      RETURN valor/1000
   ELSEIF pitem=21 // perfil AL-46 1
      valor:=palt2
      RETURN valor/1000
   ELSEIF pitem=22 // perfil AL-46 2
      valor:=palt4
      RETURN valor/1000
   ELSEIF pitem=27 // borracha
      valor:=2*plar1+2*plar5+palt2+palt4+2*palt5
      RETURN valor/1000
   ELSEIF pitem=28 // fitilho 5/7
      valor:=4*plar5+4*palt1+4*palt3+100
      RETURN valor/1000
   ELSEIF pitem=29 // fitilho 7/6
      valor:=palt1+palt3+100
      RETURN valor/1000
   ELSEIF pitem=30 // roldana
      RETURN 4
   ELSEIF pitem=31 // suporte de fixaá∆o
      RETURN 2
   ELSEIF pitem=32 // cunha
      RETURN 2
   ELSEIF pitem=33 // batedor
      RETURN 4
   ELSEIF pitem=34 // parafuso fecho
      RETURN 4
   ELSEIF pitem=35 // capa do parafuso fecho
      RETURN 4
   ELSEIF pitem=36 // porca
      RETURN 4
   ELSEIF pitem=38 // fecho lateral
      RETURN 2
   ELSEIF pitem=39 // parafuso grande
      RETURN 8
   ELSEIF pitem=40 // parafuso pequeno
      RETURN 15
   ELSEIF pitem=41 // bucha
      RETURN 23
   ELSE
      RETURN 0
   ENDIF
ELSEIF LEFT(pcod,2)=="73" .AND. RIGHT(pcod,4)=="4405"  // J5
   IF pitem=1      // trilho 1
      valor:=plar1+plar2
      RETURN valor/1000
   ELSEIF pitem=2      // trilho 2
      valor:=plar1+plar2
      RETURN valor/1000
   ELSEIF pitem=3 // perfil capa 1
      valor:=plar1+plar2
      RETURN valor/1000
   ELSEIF pitem=4 // perfil capa 2
      valor:=plar1+plar2
      RETURN valor/1000
   ELSEIF pitem=5 // perfil arremate 1
      valor:=plar2
      RETURN valor/1000
   ELSEIF pitem=6 // perfil arremate 2
      valor:=plar2
      RETURN valor/1000
   ELSEIF pitem=7 // perfil arremate 3
      valor:=palt2
      RETURN valor/1000
   ELSEIF pitem=8 // perfil arremate 4
      valor:=plar4
      RETURN valor/1000
   ELSEIF pitem=9 // perfil arremate 5
      valor:=plar4
      RETURN valor/1000
   ELSEIF pitem=10 // perfil arremate 6
      valor:=palt4
      RETURN valor/1000
   ELSEIF pitem=15 // perfil guia duplo 1
      valor:=plar1+plar2
      RETURN valor/1000
   ELSEIF pitem=16 // perfil guia duplo 2
      valor:=plar1+plar2
      RETURN valor/1000
   ELSEIF pitem=17 // perfil guia duplo 3
      valor:=palt2+palt4
      RETURN valor/1000
   ELSEIF pitem=18 // perfil guia duplo 4
      valor:=palt2+palt4
      RETURN valor/1000
   ELSEIF pitem=21 // perfil AL-46 1
      valor:=palt2
      RETURN valor/1000
   ELSEIF pitem=22 // perfil AL-46 2
      valor:=palt4
      RETURN valor/1000
   ELSEIF pitem=27 // borracha
      valor:=palt2+palt4+2*plar2
      RETURN valor/1000
   ELSEIF pitem=28 // fitilho 5/7
      valor:=4*palt1+4*palt3+8*plar2
      RETURN valor/1000
   ELSEIF pitem=29 // fitilho 7/6
      valor:=palt2+palt4
      RETURN valor/1000
   ELSEIF pitem=30 // roldana
      RETURN 4
   ELSEIF pitem=31 // suporte de fixaá∆o
      RETURN 2
   ELSEIF pitem=32 // cunha
      RETURN 2
   ELSEIF pitem=33 // batedor
      RETURN 4
   ELSEIF pitem=34 // parafuso fecho
      RETURN 4
   ELSEIF pitem=35 // capa do parafuso fecho
      RETURN 4
   ELSEIF pitem=36 // porca
      RETURN 4
   ELSEIF pitem=38 // fecho lateral
      RETURN 2
   ELSEIF pitem=39 // parafuso grande
      RETURN 8
   ELSEIF pitem=40 // parafuso pequeno
      RETURN 11
   ELSEIF pitem=41 // bucha
      RETURN 19
   ELSE
      RETURN 0
   ENDIF
ELSEIF LEFT(pcod,2)=="73" .AND. RIGHT(pcod,4)=="4406"  // J6
   IF pitem=1      // trilho 1
      valor:=plar1+plar2+plar3+plar4-50
      RETURN valor/1000
   ELSEIF pitem=3 // perfil capa 1
      valor:=plar1+plar2+plar3+plar4-50
      RETURN valor/1000
   ELSEIF pitem=5 // perfil arremate 1
      valor:=plar2+plar3
      RETURN valor/1000
   ELSEIF pitem=6 // perfil arremate 2
      valor:=plar2+plar3
      RETURN valor/1000
   ELSEIF pitem=15 // perfil guia duplo 1
      valor:=palt2
      RETURN valor/1000
   ELSEIF pitem=16 // perfil guia duplo 2
      valor:=palt2
      RETURN valor/1000
   ELSEIF pitem=17 // perfil guia duplo 3
      valor:=plar1+plar2+plar3+plar4-50
      RETURN valor/1000
   ELSEIF pitem=21 // perfil AL-46 1
      valor:=palt2
      RETURN valor/1000
   ELSEIF pitem=22 // perfil AL-46 2
      valor:=palt3
      RETURN valor/1000
   ELSEIF pitem=25 // calha "H" 1
      valor:=palt2
      RETURN valor/1000
   ELSEIF pitem=27 // borracha
      valor:=2*plar1+palt2
      RETURN valor/1000
   ELSEIF pitem=28 // fitilho 5/7
      valor:=4*palt2+4*plar1+4*plar4
      RETURN valor/1000
   ELSEIF pitem=29 // fitilho 7/6
      valor:=2*palt2+100
      RETURN valor/1000
   ELSEIF pitem=30 // roldana
      RETURN 4
   //ELSEIF pitem=31 // suporte de fixaá∆o
   //   RETURN 2
   //ELSEIF pitem=32 // cunha
   //   RETURN 2
   ELSEIF pitem=33 // batedor
      RETURN 4
   ELSEIF pitem=34 // parafuso fecho
      RETURN 4
   ELSEIF pitem=35 // capa do parafuso fecho
      RETURN 4
   ELSEIF pitem=36 // porca
      RETURN 4
   ELSEIF pitem=37 // fecho central
      RETURN 1
   ELSEIF pitem=39 // parafuso grande
      RETURN 4
   ELSEIF pitem=40 // parafuso pequeno
      RETURN 7
   ELSEIF pitem=41 // bucha
      RETURN 11
   ELSE
      RETURN 0
   ENDIF
ELSEIF LEFT(pcod,2)=="73" .AND. RIGHT(pcod,4)=="4407"  // J7
   IF pitem=1      // trilho 1
      valor:=plar1+plar2+plar3+plar4-50
      RETURN valor/1000
   ELSEIF pitem=2      // trilho 2
      valor:=plar1+plar2+plar3+plar4-50
      RETURN valor/1000
   ELSEIF pitem=3 // perfil capa 1
      valor:=plar1+plar2+plar3+plar4-50
      RETURN valor/1000
   ELSEIF pitem=4 // perfil capa 2
      valor:=plar1+plar2+plar3+plar4-50
      RETURN valor/1000
   ELSEIF pitem=5 // perfil arremate 1
      valor:=plar2+plar3
      RETURN valor/1000
   ELSEIF pitem=6 // perfil arremate 2
      valor:=plar2+plar3
      RETURN valor/1000
   ELSEIF pitem=7 // perfil arremate 3
      valor:=plar2+plar3
      RETURN valor/1000
   ELSEIF pitem=8 // perfil arremate 4
      valor:=plar2+plar3
      RETURN valor/1000
   ELSEIF pitem=15 // perfil guia duplo 1
      valor:=plar1+plar2+plar3+plar4-50
      RETURN valor/1000
   ELSEIF pitem=16 // perfil guia duplo 2
      valor:=plar1+plar2+plar3+plar4-50
      RETURN valor/1000
   ELSEIF pitem=17 // perfil guia duplo 3
      valor:=palt2+palt6
      RETURN valor/1000
   ELSEIF pitem=18 // perfil guia duplo 4
      valor:=palt3+palt7
      RETURN valor/1000
   ELSEIF pitem=21 // perfil AL-46 1
      valor:=palt2
      RETURN valor/1000
   ELSEIF pitem=22 // perfil AL-46 2
      valor:=palt2
      RETURN valor/1000
   ELSEIF pitem=23 // perfil AL-46 3
      valor:=palt6
      RETURN valor/1000
   ELSEIF pitem=24 // perfil AL-46 4
      valor:=palt7
      RETURN valor/1000
   ELSEIF pitem=25 // calha "H" 1
      valor:=palt2
      RETURN valor/1000
   ELSEIF pitem=26 // calha "H" 2
      valor:=palt6
      RETURN valor/1000
   ELSEIF pitem=27 // borracha
      valor:=2*palt2+2*palt6+2*plar1+2*plar5+200
      RETURN valor/1000
   ELSEIF pitem=28 // fitilho 5/7
      valor:=4*palt2+4*palt6+8*plar1+8*plar2
      RETURN valor/1000
   ELSEIF pitem=29 // fitilho 7/6
      valor:=3*palt2+3*palt6+200
      RETURN valor/1000
   ELSEIF pitem=30 // roldana
      RETURN 8
   ELSEIF pitem=31 // suporte de fixaá∆o
      RETURN 2
   ELSEIF pitem=32 // cunha
      RETURN 2
   ELSEIF pitem=33 // batedor
      RETURN 8
   ELSEIF pitem=34 // parafuso fecho
      RETURN 8
   ELSEIF pitem=35 // capa do parafuso fecho
      RETURN 8
   ELSEIF pitem=36 // porca
      RETURN 8
   ELSEIF pitem=37 // fecho central
      RETURN 2
   ELSEIF pitem=39 // parafuso grande
      RETURN 8
   ELSEIF pitem=40 // parafuso pequeno
      RETURN 11
   ELSEIF pitem=41 // bucha
      RETURN 19
   ELSE
      RETURN 0
   ENDIF
ELSEIF LEFT(pcod,2)=="73" .AND. RIGHT(pcod,4)=="4501"  // P1
   IF pitem=1      // trilho 1
      valor:=plar1+plar2
      RETURN valor/1000
   ELSEIF pitem=3 // perfil capa 1
      valor:=plar1+plar2
      RETURN valor/1000
   ELSEIF pitem=5 // perfil arremate 1
      valor:=plar2
      RETURN valor/1000
   ELSEIF pitem=6 // perfil arremate 2
      valor:=plar2
      RETURN valor/1000
   ELSEIF pitem=7 // perfil arremate 3
      valor:=palt2
      RETURN valor/1000
   ELSEIF pitem=15 // perfil guia duplo 1
      valor:=palt2
      RETURN valor/1000
   ELSEIF pitem=16 // perfil guia duplo 2
      valor:=palt2
      RETURN valor/1000
   ELSEIF pitem=17 // perfil guia duplo 3
      valor:=plar1+plar2
      RETURN valor/1000
   ELSEIF pitem=22 // perfil AL-46 1
      valor:=palt2
      RETURN valor/1000
   ELSEIF pitem=27 // borracha
      valor:=2*plar2+palt2
      RETURN valor/1000
   ELSEIF pitem=28 // fitilho 5/7
      valor:=4*palt2+2*plar1+2*plar2
      RETURN valor/1000
   ELSEIF pitem=29 // fitilho 7/6
      valor:=palt2
      RETURN valor/1000
   ELSEIF pitem=30 // roldana
      RETURN 2
   ELSEIF pitem=31 // suporte de fixaá∆o
      RETURN 2
   ELSEIF pitem=32 // cunha
      RETURN 2
   ELSEIF pitem=33 // batedor
      RETURN 2
   ELSEIF pitem=34 // parafuso fecho
      RETURN 2
   ELSEIF pitem=35 // capa do parafuso fecho
      RETURN 2
   ELSEIF pitem=36 // porca
      RETURN 2
   ELSEIF pitem=38 // fecho lateral
      IF pfecho=="1"
         RETURN 1
      ELSE
         RETURN 0
      ENDIF
   ELSEIF pitem=39 // parafuso grande
      RETURN 4
   ELSEIF pitem=40 // parafuso pequeno
      RETURN 9
   ELSEIF pitem=41 // bucha
      RETURN 13
   ELSEIF pitem=47 // fechadura
      IF pfecho=="2"
         RETURN 1
      ELSE
         RETURN 0
      ENDIF
   ELSE
      RETURN 0
   ENDIF
ELSEIF LEFT(pcod,2)=="73" .AND. RIGHT(pcod,4)=="4502"  // P2
   IF pitem=1      // trilho 1
      valor:=2*plar5+2*plar6
      RETURN valor/1000
   ELSEIF pitem=3 // perfil capa 1
      valor:=2*plar5+2*plar6
      RETURN valor/1000
   ELSEIF pitem=5 // perfil arremate 1 ou acabamento
      valor:=2*plar2+2*plar3+2*plar6+palt6
      RETURN valor/1000
   //ELSEIF pitem=6 // perfil arremate 2
   //   valor:=plar2
   //   RETURN valor/1000
   //ELSEIF pitem=7 // perfil arremate 3
   //   valor:=palt2
   //   RETURN valor/1000
   ELSEIF pitem=15 // perfil guia duplo 1 ou calha E
      valor:=2*plar1+2*plar2+2*palt1+2*palt6+plar5+plar6
      RETURN valor/1000
   //ELSEIF pitem=16 // perfil guia duplo 2
   //   valor:=palt2
   //   RETURN valor/1000
   //ELSEIF pitem=17 // perfil guia duplo 3
   //   valor:=plar1+plar2
      RETURN valor/1000
   ELSEIF pitem=21 // perfil AL-46 1
      valor:=2*palt2+palt6
      RETURN valor/1000
   ELSEIF pitem=25 // calha H
      valor:=palt2
      RETURN valor/1000
   ELSEIF pitem=27 // borracha
      valor:=2*plar2+2*palt2+palt5+plar5
      RETURN valor/1000
   ELSEIF pitem=28 // fitilho 5/7
      valor:=4*palt2+4*plar1+4*plar2+4*palt2+4*palt6+2*plar5+2*plar6
      RETURN valor/1000
   ELSEIF pitem=29 // fitilho 7/6
      valor:=3*palt2+palt6
      RETURN valor/1000
   ELSEIF pitem=30 // roldana
      RETURN 6
   ELSEIF pitem=31 // suporte de fixaá∆o
      RETURN 2
   ELSEIF pitem=32 // cunha
      RETURN 2
   ELSEIF pitem=33 // batedor
      RETURN 6
   ELSEIF pitem=34 // parafuso fecho
      RETURN 6
   ELSEIF pitem=35 // capa do parafuso fecho
      RETURN 6
   ELSEIF pitem=36 // porca
      RETURN 6
   ELSEIF pitem=37 // fecho central
      IF pfecho=="1"
         RETURN 1
      ELSE
         RETURN 0
      ENDIF
   ELSEIF pitem=38 // fecho lateral
      IF pfecho=="1"
         RETURN 1
      ELSE
         RETURN 0
      ENDIF
   ELSEIF pitem=39 // parafuso grande
      RETURN 8
   ELSEIF pitem=40 // parafuso pequeno
      RETURN 11
   ELSEIF pitem=41 // bucha
      RETURN 19
   ELSEIF pitem=47 // fechadura
      IF pfecho=="2"
         RETURN 1
      ELSE
         RETURN 0
      ENDIF
   ELSE
      RETURN 0
   ENDIF
ELSEIF LEFT(pcod,2)=="73" .AND. RIGHT(pcod,4)=="4503" //  P3
   IF pitem=1      // trilho 1
      valor:=plar1+50
      RETURN valor/1000
   ELSEIF pitem=3 // perfil capa 1
      valor:=plar1+50
      RETURN valor/1000
   ELSEIF pitem=5 // perfil arremate 1
      valor:=palt1+50
      RETURN valor/1000
   ELSEIF pitem=6 // perfil arremate 2
      valor:=palt1+50
      RETURN valor/1000
   ELSEIF pitem=7 // perfil arremate 3
      valor:=plar1+50
      RETURN valor/1000
   ELSEIF pitem=8 // perfil arremate 4
      valor:=plar1+50
      RETURN valor/1000
   ELSEIF pitem=9 // perfil arremate 5
      valor:=plar2
      RETURN valor/1000
   ELSEIF pitem=10 // perfil arremate 6
      valor:=plar2
      RETURN valor/1000
   ELSEIF pitem=11 // perfil arremate 7
      valor:=palt2
      RETURN valor/1000
   ELSEIF pitem=15 // perfil guia duplo 1
      valor:=plar1+50
      RETURN valor/1000
   ELSEIF pitem=16 // perfil guia duplo 2
      valor:=plar1+50
      RETURN valor/1000
   ELSEIF pitem=17 // perfil guia duplo 3
      valor:=plar1+50
      RETURN valor/1000
   ELSEIF pitem=18 // perfil guia duplo 4
      valor:=palt2+palt1
      RETURN valor/1000
   ELSEIF pitem=19 // perfil guia duplo 5
      valor:=palt2+palt1
      RETURN valor/1000
   ELSEIF pitem=21 // perfil AL-46 1
      valor:=palt2
      RETURN valor/1000
   ELSEIF pitem=27 // borracha
      valor:=2*plar1+2*palt1+plar3+palt2
      RETURN valor/1000
   ELSEIF pitem=28 // fitilho 5/7
      valor:=4*palt2+2*plar1+100
      RETURN valor/1000
   ELSEIF pitem=29 // fitilho 7/6
      valor:=palt2+50
      RETURN valor/1000
   ELSEIF pitem=30 // roldana
      RETURN 2
   ELSEIF pitem=31 // suporte de fixaá∆o
      RETURN 2
   ELSEIF pitem=32 // cunha
      RETURN 2
   ELSEIF pitem=33 // batedor
      RETURN 2
   ELSEIF pitem=34 // parafuso fecho
      RETURN 2
   ELSEIF pitem=35 // capa do parafuso fecho
      RETURN 2
   ELSEIF pitem=36 // porca
      RETURN 2
   ELSEIF pitem=38 // fecho lateral
      RETURN 1
   ELSEIF pitem=39 // parafuso grande
      RETURN 4
   ELSEIF pitem=40 // parafuso pequeno
      RETURN 14
   ELSEIF pitem=41 // bucha
      RETURN 18
   ELSEIF pitem=38 // fecho lateral
      IF pfecho=="1"
         RETURN 1
      ELSE
         RETURN 0
      ENDIF
   ELSEIF pitem=47 // fechadura
      IF pfecho=="2"
         RETURN 1
      ELSE
         RETURN 0
      ENDIF
   ELSE
      RETURN 0
   ENDIF
ELSEIF LEFT(pcod,2)=="73" .AND. RIGHT(pcod,4)=="4504"  // P4
   IF pitem=1      // trilho 1
      valor:=plar1+plar2
      RETURN valor/1000
   ELSEIF pitem=2      // trilho 2
      valor:=plar1+plar2
      RETURN valor/1000
   ELSEIF pitem=3 // perfil capa 1
      valor:=plar1+plar2
      RETURN valor/1000
   ELSEIF pitem=4 // perfil capa 2
      valor:=plar1+plar2
      RETURN valor/1000
   ELSEIF pitem=5 // perfil arremate 1
      valor:=plar2
      RETURN valor/1000
   ELSEIF pitem=6 // perfil arremate 2
      valor:=plar2
      RETURN valor/1000
   ELSEIF pitem=7 // perfil arremate 3
      valor:=palt2
      RETURN valor/1000
   ELSEIF pitem=8 // perfil arremate 4
      valor:=plar4
      RETURN valor/1000
   ELSEIF pitem=9 // perfil arremate 5
      valor:=plar4
      RETURN valor/1000
   ELSEIF pitem=10 // perfil arremate 6
      valor:=palt4
      RETURN valor/1000
   ELSEIF pitem=15 // perfil guia duplo 1
      valor:=plar1+plar2
      RETURN valor/1000
   ELSEIF pitem=16 // perfil guia duplo 2
      valor:=plar1+plar2
      RETURN valor/1000
   ELSEIF pitem=17 // perfil guia duplo 3
      valor:=palt2+palt4
      RETURN valor/1000
   ELSEIF pitem=18 // perfil guia duplo 4
      valor:=palt2+palt4
      RETURN valor/1000
   ELSEIF pitem=21 // perfil AL-46 1
      valor:=palt2
      RETURN valor/1000
   ELSEIF pitem=22 // perfil AL-46 2
      valor:=palt4
      RETURN valor/1000
   ELSEIF pitem=27 // borracha
      valor:=palt2+palt4+2*plar2
      RETURN valor/1000
   ELSEIF pitem=28 // fitilho 5/7
      valor:=4*palt1+4*palt3+8*plar2
      RETURN valor/1000
   ELSEIF pitem=29 // fitilho 7/6
      valor:=palt2+palt4
      RETURN valor/1000
   ELSEIF pitem=30 // roldana
      RETURN 4
   ELSEIF pitem=31 // suporte de fixaá∆o
      RETURN 2
   ELSEIF pitem=32 // cunha
      RETURN 2
   ELSEIF pitem=33 // batedor
      RETURN 4
   ELSEIF pitem=34 // parafuso fecho
      RETURN 4
   ELSEIF pitem=35 // capa do parafuso fecho
      RETURN 4
   ELSEIF pitem=36 // porca
      RETURN 4
   ELSEIF pitem=38 // fecho lateral
      IF pfecho=="1"
         RETURN 2
      ELSE
         RETURN 0
      ENDIF
   ELSEIF pitem=39 // parafuso grande
      RETURN 8
   ELSEIF pitem=40 // parafuso pequeno
      RETURN 11
   ELSEIF pitem=41 // bucha
      RETURN 21
   ELSEIF pitem=47 // fechadura
      IF pfecho=="2"
         RETURN 2
      ELSE
         RETURN 0
      ENDIF
   ELSE
      RETURN 0
   ENDIF
ELSEIF LEFT(pcod,2)=="73" .AND. RIGHT(pcod,4)=="4505"  // P5
   IF pitem=1      // trilho 1
      valor:=plar1+plar2+plar3+plar4-50
      RETURN valor/1000
   ELSEIF pitem=3 // perfil capa 1
      valor:=plar1+plar2+plar3+plar4-50
      RETURN valor/1000
   ELSEIF pitem=5 // perfil arremate 1
      valor:=plar2+plar3
      RETURN valor/1000
   ELSEIF pitem=6 // perfil arremate 2
      valor:=plar2+plar3
      RETURN valor/1000
   ELSEIF pitem=15 // perfil guia duplo 1
      valor:=palt2
      RETURN valor/1000
   ELSEIF pitem=16 // perfil guia duplo 2
      valor:=palt2
      RETURN valor/1000
   ELSEIF pitem=17 // perfil guia duplo 3
      valor:=plar1+plar2+plar3+plar4-50
      RETURN valor/1000
   ELSEIF pitem=21 // perfil AL-46 1
      valor:=palt2
      RETURN valor/1000
   ELSEIF pitem=22 // perfil AL-46 2
      valor:=palt3
      RETURN valor/1000
   ELSEIF pitem=25 // calha "H" 1
      valor:=palt2
      RETURN valor/1000
   ELSEIF pitem=27 // borracha
      valor:=2*plar1+palt2
      RETURN valor/1000
   ELSEIF pitem=28 // fitilho 5/7
      valor:=4*palt2+4*plar1+4*plar4
      RETURN valor/1000
   ELSEIF pitem=29 // fitilho 7/6
      valor:=2*palt2+100
      RETURN valor/1000
   ELSEIF pitem=30 // roldana
      RETURN 4
   //ELSEIF pitem=31 // suporte de fixaá∆o
   //   RETURN 2
   //ELSEIF pitem=32 // cunha
   //   RETURN 2
   ELSEIF pitem=33 // batedor
      RETURN 4
   ELSEIF pitem=34 // parafuso fecho
      RETURN 4
   ELSEIF pitem=35 // capa do parafuso fecho
      RETURN 4
   ELSEIF pitem=36 // porca
      RETURN 4
   ELSEIF pitem=37 // fecho central
      IF pfecho=="1"
         RETURN 1
      ELSE
         RETURN 0
      ENDIF
   ELSEIF pitem=39 // parafuso grande
      RETURN 4
   ELSEIF pitem=40 // parafuso pequeno
      RETURN 7
   ELSEIF pitem=41 // bucha
      RETURN 11
   ELSEIF pitem=47 // fechadura
      IF pfecho=="2"
         RETURN 1
      ELSE
         RETURN 0
      ENDIF
   ELSE
      RETURN 0
   ENDIF
ELSEIF LEFT(pcod,2)=="73" .AND. RIGHT(pcod,4)=="4506"  // P6
   IF pitem=1      // trilho 1
      valor:=plar1+50
      RETURN valor/1000
   ELSEIF pitem=3 // perfil capa
      valor:=plar1+50
      RETURN valor/1000
   ELSEIF pitem=5 // perfil arremate 1
      valor:=plar1+50
      RETURN valor/1000
   ELSEIF pitem=6 // perfil arremate 2
      valor:=plar1+50
      RETURN valor/1000
   ELSEIF pitem=7 // perfil arremate 3
      valor:=palt1+50
      RETURN valor/1000
   ELSEIF pitem=8 // perfil arremate 4
      valor:=palt2+50
      RETURN valor/1000
   ELSEIF pitem=9 // perfil arremate 5
      valor:=plar3+plar4
      RETURN valor/1000
   ELSEIF pitem=10// perfil arremate 6
      valor:=plar3+plar4
      RETURN valor/1000
   ELSEIF pitem=15 // perfil guia duplo 1 ou calha E
      valor:=plar1+50
      RETURN valor/1000
   ELSEIF pitem=16 // perfil guia duplo 2
      valor:=plar1+50
      RETURN valor/1000
   ELSEIF pitem=17 // perfil guia duplo 3
      valor:=plar1+50
      RETURN valor/1000
   ELSEIF pitem=18 // perfil guia duplo 4
      valor:=palt1+palt2
      RETURN valor/1000
   ELSEIF pitem=19 // perfil guia duplo 5
      valor:=palt1+palt2
      RETURN valor/1000
   ELSEIF pitem=21 // perfil AL-46 1
      valor:=palt3
      RETURN valor/1000
   ELSEIF pitem=22 // perfil AL-46 2
      valor:=palt4
      RETURN valor/1000
   ELSEIF pitem=25 // calha "H" 1
      valor:=palt3
      RETURN valor/1000
   ELSEIF pitem=27 // borracha
      valor:=2*plar1+2*palt1+2*palt3+2*plar2+2*plar5+150
      RETURN valor/1000
   ELSEIF pitem=28 // fitilho 5/7
      valor:=2*palt2+2*plar1+2*plar2+2*plar3+2*lar4+2*alt3+100
      RETURN valor/1000
   ELSEIF pitem=29 // fitilho 7/6
      valor:=3*palt3
      RETURN valor/1000
   ELSEIF pitem=30 // roldana
      RETURN 4
   ELSEIF pitem=31 // suporte de fixaá∆o
      RETURN 2
   ELSEIF pitem=32 // cunha
      RETURN 2
   ELSEIF pitem=33 // batedor
      RETURN 4
   ELSEIF pitem=34 // parafuso fecho
      RETURN 4
   ELSEIF pitem=35 // capa do parafuso fecho
      RETURN 4
   ELSEIF pitem=36 // porca
      RETURN 4
   ELSEIF pitem=37 // fecho central
      IF pfecho=="1"
         RETURN 1
      ELSE
         RETURN 0
      ENDIF
   ELSEIF pitem=39 // parafuso grande
      RETURN 4
   ELSEIF pitem=40 // parafuso pequeno
      RETURN 16
   ELSEIF pitem=41 // bucha
      RETURN 20
   ELSEIF pitem=47 // fechadura
      IF pfecho=="2"
         RETURN 1
      ELSE
         RETURN 0
      ENDIF
   ELSE
      RETURN 0
   ENDIF
ELSEIF LEFT(pcod,2)=="73" .AND. RIGHT(pcod,4)=="4507"  // P7
   IF pitem=1      // trilho 1
      valor:=plar1+plar2+plar3+plar4-50
      RETURN valor/1000
   ELSEIF pitem=2      // trilho 2
      valor:=plar1+plar2+plar3+plar4-50
      RETURN valor/1000
   ELSEIF pitem=3 // perfil capa 1
      valor:=plar1+plar2+plar3+plar4-50
      RETURN valor/1000
   ELSEIF pitem=4 // perfil capa 2
      valor:=plar1+plar2+plar3+plar4-50
      RETURN valor/1000
   ELSEIF pitem=5 // perfil arremate 1
      valor:=plar2+plar3
      RETURN valor/1000
   ELSEIF pitem=6 // perfil arremate 2
      valor:=plar2+plar3
      RETURN valor/1000
   ELSEIF pitem=7 // perfil arremate 3
      valor:=plar2+plar3
      RETURN valor/1000
   ELSEIF pitem=8 // perfil arremate 4
      valor:=plar2+plar3
      RETURN valor/1000
   ELSEIF pitem=15 // perfil guia duplo 1
      valor:=plar1+plar2+plar3+plar4-50
      RETURN valor/1000
   ELSEIF pitem=16 // perfil guia duplo 2
      valor:=plar1+plar2+plar3+plar4-50
      RETURN valor/1000
   ELSEIF pitem=17 // perfil guia duplo 3
      valor:=palt2+palt6
      RETURN valor/1000
   ELSEIF pitem=18 // perfil guia duplo 4
      valor:=palt3+palt7
      RETURN valor/1000
   ELSEIF pitem=21 // perfil AL-46 1
      valor:=palt2
      RETURN valor/1000
   ELSEIF pitem=22 // perfil AL-46 2
      valor:=palt2
      RETURN valor/1000
   ELSEIF pitem=23 // perfil AL-46 3
      valor:=palt6
      RETURN valor/1000
   ELSEIF pitem=24 // perfil AL-46 4
      valor:=palt7
      RETURN valor/1000
   ELSEIF pitem=25 // calha "H" 1
      valor:=palt2
      RETURN valor/1000
   ELSEIF pitem=26 // calha "H" 2
      valor:=palt6
      RETURN valor/1000
   ELSEIF pitem=27 // borracha
      valor:=2*palt2+2*palt6+2*plar1+2*plar5+200
      RETURN valor/1000
   ELSEIF pitem=28 // fitilho 5/7
      valor:=4*palt2+4*palt6+8*plar1+8*plar2
      RETURN valor/1000
   ELSEIF pitem=29 // fitilho 7/6
      valor:=3*palt2+3*palt6+200
      RETURN valor/1000
   ELSEIF pitem=30 // roldana
      RETURN 8
   ELSEIF pitem=31 // suporte de fixaá∆o
      RETURN 2
   ELSEIF pitem=32 // cunha
      RETURN 2
   ELSEIF pitem=33 // batedor
      RETURN 8
   ELSEIF pitem=34 // parafuso fecho
      RETURN 8
   ELSEIF pitem=35 // capa do parafuso fecho
      RETURN 8
   ELSEIF pitem=36 // porca
      RETURN 8
   ELSEIF pitem=37 // fecho central
      IF pfecho=="1"
         RETURN 2
      ELSE
         RETURN 0
      ENDIF
   ELSEIF pitem=39 // parafuso grande
      RETURN 8
   ELSEIF pitem=40 // parafuso pequeno
      RETURN 11
   ELSEIF pitem=41 // bucha
      RETURN 1920
   ELSEIF pitem=47 // fechadura
      IF pfecho=="2"
         RETURN 1
      ELSE
         RETURN 0
      ENDIF
   ELSE
      RETURN 0
   ENDIF
ELSEIF LEFT(pcod,2)=="73" .AND. RIGHT(pcod,4)=="4601"  // M1
   IF pitem=21 // perfil AL-46 1
      valor:=plar1+50
      RETURN valor/1000
   ELSEIF pitem=22 // perfil AL-46 2
      valor:=plar1+50
      RETURN valor/1000
   ELSEIF pitem=23 // perfil AL-46 3
      valor:=palt1+50
      RETURN valor/1000
   ELSEIF pitem=24 // perfil AL-46 4
      valor:=palt1+50
      RETURN valor/1000
   ELSEIF pitem=29 // fitilho 7/6
      valor:=2*palt1+2*plar1+200
      RETURN valor/1000
   ELSEIF pitem=34 // parafuso fecho
      RETURN 6
   ELSEIF pitem=40 // parafuso pequeno
      RETURN 6
   ELSEIF pitem=41 // bucha
      RETURN 6
   ELSEIF pitem=42 // dobradiáa
      RETURN 2
   ELSEIF pitem=43 // haste 200mm
      x:=plar1/2
      v1:=ABS(x-200)
      v2:=ABS(x-250)
      v3:=ABS(x-300)
      IF v1 < v2
         IF v1 < v3
            RETURN 1
         ELSE
            RETURN 0
         ENDIF
     ELSE
        RETURN 0
     ENDIF
   ELSEIF pitem=44 // haste 250mm
      x:=plar1/2
      v1:=ABS(x-200)
      v2:=ABS(x-250)
      v3:=ABS(x-300)
      IF v1 < v2
         RETURN 0
      ELSE
        IF v2 < v3
           RETURN 1
        ELSE
           RETURN 0
        ENDIF
     ENDIF
   ELSEIF pitem=45 // haste 300mm
      x:=plar1/2
      v1:=ABS(x-200)
      v2:=ABS(x-250)
      v3:=ABS(x-300)
      IF v1 < v2
         IF v1 < v3
            RETURN 0
         ELSE
            RETURN 1
         ENDIF
      ELSE
        IF v2 < v3
           RETURN 0
        ELSE
           RETURN 1
        ENDIF
     ENDIF
   ELSE
      RETURN 0
   ENDIF
ELSEIF LEFT(pcod,2)=="73" .AND. RIGHT(pcod,4)=="4602"  // M2
   IF pitem=21 // perfil AL-46 1
      valor:=2*palt1+100
      RETURN valor/1000
   ELSEIF pitem=22 // perfil AL-46 2
      valor:=2*plar1+100
      RETURN valor/1000
   ELSEIF pitem=23 // perfil AL-46 3
      valor:=2*palt2+100
      RETURN valor/1000
   ELSEIF pitem=24 // perfil AL-46 4
      valor:=2*plar2+100
      RETURN valor/1000
   ELSEIF pitem=29 // fitilho 7/6
      valor:=4*palt1+4*plar1+100
      RETURN valor/1000
   ELSEIF pitem=34 // parafuso fecho
      RETURN 12
   ELSEIF pitem=36 // porca
      RETURN 12
   ELSEIF pitem=40 // parafuso pequeno
      RETURN 12
   ELSEIF pitem=41 // bucha
      RETURN 12
   ELSEIF pitem=42 // dobradiáa
      RETURN 4
   ELSEIF pitem=43 // haste 200mm
      x:=plar1/2
      v1:=ABS(x-200)
      v2:=ABS(x-250)
      v3:=ABS(x-300)
      IF v1 < v2
         IF v1 < v3
            RETURN 2
         ELSE
            RETURN 0
         ENDIF
     ELSE
        RETURN 0
     ENDIF
   ELSEIF pitem=44 // haste 250mm
      x:=plar1/2
      v1:=ABS(x-200)
      v2:=ABS(x-250)
      v3:=ABS(x-300)
      IF v1 < v2
         RETURN 0
      ELSE
        IF v2 < v3
           RETURN 2
        ELSE
           RETURN 0
        ENDIF
     ENDIF
   ELSEIF pitem=45 // haste 300mm
      x:=plar1/2
      v1:=ABS(x-200)
      v2:=ABS(x-250)
      v3:=ABS(x-300)
      IF v1 < v2
         IF v1 < v3
            RETURN 0
         ELSE
            RETURN 2
         ENDIF
      ELSE
        IF v2 < v3
           RETURN 0
        ELSE
           RETURN 2
        ENDIF
     ENDIF
   ELSEIF pitem=46 // Perfil tubo
      valor:=palt1+50
      RETURN valor
   ELSE
      RETURN 0
   ENDIF
ELSEIF LEFT(pcod,2)=="73" .AND. RIGHT(pcod,4)=="4603"  // M3
   IF pitem=21 // perfil AL-46 1
      valor:=2*palt1+100
      RETURN valor/1000
   ELSEIF pitem=22 // perfil AL-46 2
      valor:=2*plar1+100
      RETURN valor/1000
   ELSEIF pitem=23 // perfil AL-46 3
      valor:=4*palt2+100
      RETURN valor/1000
   ELSEIF pitem=24 // perfil AL-46 4
      valor:=4*plar2+100
      RETURN valor/1000
   ELSEIF pitem=29 // fitilho 7/6
      valor:=2*plar1+2*plar2+2*plar3+2*palt1+2*palt2+2*palt3+150
      RETURN valor/1000
   ELSEIF pitem=34 // parafuso fecho
      RETURN 18
   ELSEIF pitem=36 // porca
      RETURN 18
   ELSEIF pitem=40 // parafuso pequeno
      RETURN 16
   ELSEIF pitem=41 // bucha
      RETURN 16
   ELSEIF pitem=42 // dobradiáa
      RETURN 6
   ELSEIF pitem=43 // haste 200mm
      x:=plar1/2
      v1:=ABS(x-200)
      v2:=ABS(x-250)
      v3:=ABS(x-300)
      IF v1 < v2
         IF v1 < v3
            RETURN 3
         ELSE
            RETURN 0
         ENDIF
     ELSE
        RETURN 0
     ENDIF
   ELSEIF pitem=44 // haste 250mm
      x:=plar1/2
      v1:=ABS(x-200)
      v2:=ABS(x-250)
      v3:=ABS(x-300)
      IF v1 < v2
         RETURN 0
      ELSE
        IF v2 < v3
           RETURN 3
        ELSE
           RETURN 0
        ENDIF
     ENDIF
   ELSEIF pitem=45 // haste 300mm
      x:=plar1/2
      v1:=ABS(x-200)
      v2:=ABS(x-250)
      v3:=ABS(x-300)
      IF v1 < v2
         IF v1 < v3
            RETURN 0
         ELSE
            RETURN 3
         ENDIF
      ELSE
        IF v2 < v3
           RETURN 0
        ELSE
           RETURN 3
        ENDIF
     ENDIF
   ELSEIF pitem=46 // Perfil tubo
      valor:=2*palt1
      RETURN valor
   ELSE
      RETURN 0
   ENDIF
ELSEIF LEFT(pcod,2)=="73" .AND. RIGHT(pcod,4)=="4604"  // M4
   IF pitem=21 // perfil AL-46 1
      valor:=4*palt1+100
      RETURN valor/1000
   ELSEIF pitem=22 // perfil AL-46 2
      valor:=4*plar1+100
      RETURN valor/1000
   ELSEIF pitem=23 // perfil AL-46 3
      valor:=4*palt2+100
      RETURN valor/1000
   ELSEIF pitem=24 // perfil AL-46 4
      valor:=4*plar2+100
      RETURN valor/1000
   ELSEIF pitem=29 // fitilho 7/6
      valor:=2*plar1+2*plar2+2*plar3+2*plar4+2*palt1+2*palt2+2*palt3+2*palt4+200
      RETURN valor/1000
   ELSEIF pitem=34 // parafuso fecho
      RETURN 24
   ELSEIF pitem=36 // porca
      RETURN 24
   ELSEIF pitem=40 // parafuso pequeno
      RETURN 20
   ELSEIF pitem=41 // bucha
      RETURN 20
   ELSEIF pitem=42 // dobradiáa
      RETURN 8
   ELSEIF pitem=43 // haste 200mm
      x:=plar1/2
      v1:=ABS(x-200)
      v2:=ABS(x-250)
      v3:=ABS(x-300)
      IF v1 < v2
         IF v1 < v3
            RETURN 4
         ELSE
            RETURN 0
         ENDIF
     ELSE
        RETURN 0
     ENDIF
   ELSEIF pitem=44 // haste 250mm
      x:=plar1/2
      v1:=ABS(x-200)
      v2:=ABS(x-250)
      v3:=ABS(x-300)
      IF v1 < v2
         RETURN 0
      ELSE
        IF v2 < v3
           RETURN 4
        ELSE
           RETURN 0
        ENDIF
     ENDIF
   ELSEIF pitem=45 // haste 300mm
      x:=plar1/2
      v1:=ABS(x-200)
      v2:=ABS(x-250)
      v3:=ABS(x-300)
      IF v1 < v2
         IF v1 < v3
            RETURN 0
         ELSE
            RETURN 4
         ENDIF
      ELSE
        IF v2 < v3
           RETURN 0
        ELSE
           RETURN 4
        ENDIF
     ENDIF
   ELSEIF pitem=46 // Perfil tubo
      valor:=3*palt1
      RETURN valor
   ELSE
      RETURN 0
   ENDIF
ELSEIF LEFT(pcod,2)=="73" .AND. RIGHT(pcod,4)=="4605"  // M5
   IF pitem=21 // perfil AL-46 1
      valor:=4*palt1+100
      RETURN valor/1000
   ELSEIF pitem=22 // perfil AL-46 2
      valor:=4*plar1+100
      RETURN valor/1000
   ELSEIF pitem=23 // perfil AL-46 3
      valor:=6*palt2+100
      RETURN valor/1000
   ELSEIF pitem=24 // perfil AL-46 4
      valor:=6*plar2+100
      RETURN valor/1000
   ELSEIF pitem=29 // fitilho 7/6
      valor:=2*plar1+2*plar2+2*plar3+2*plar4+2*plar5+2*palt1+2*palt2+2*palt3+2*palt4+2*palt5+250
      RETURN valor/1000
   ELSEIF pitem=34 // parafuso fecho
      RETURN 30
   ELSEIF pitem=36 // porca
      RETURN 30
   ELSEIF pitem=40 // parafuso pequeno
      RETURN 24
   ELSEIF pitem=41 // bucha
      RETURN 24
   ELSEIF pitem=42 // dobradiáa
      RETURN 10
   ELSEIF pitem=43 // haste 200mm
      x:=plar1/2
      v1:=ABS(x-200)
      v2:=ABS(x-250)
      v3:=ABS(x-300)
      IF v1 < v2
         IF v1 < v3
            RETURN 5
         ELSE
            RETURN 0
         ENDIF
     ELSE
        RETURN 0
     ENDIF
   ELSEIF pitem=44 // haste 250mm
      x:=plar1/2
      v1:=ABS(x-200)
      v2:=ABS(x-250)
      v3:=ABS(x-300)
      IF v1 < v2
         RETURN 0
      ELSE
        IF v2 < v3
           RETURN 5
        ELSE
           RETURN 0
        ENDIF
     ENDIF
   ELSEIF pitem=45 // haste 300mm
      x:=plar1/2
      v1:=ABS(x-200)
      v2:=ABS(x-250)
      v3:=ABS(x-300)
      IF v1 < v2
         IF v1 < v3
            RETURN 0
         ELSE
            RETURN 5
         ENDIF
      ELSE
        IF v2 < v3
           RETURN 0
        ELSE
           RETURN 5
        ENDIF
     ENDIF
   ELSEIF pitem=46 // Perfil tubo
      valor:=4*palt1
      RETURN valor
   ELSE
      RETURN 0
   ENDIF
ELSEIF LEFT(pcod,2)=="73" .AND. RIGHT(pcod,4)=="4606"  // M6
   IF pitem=21 // perfil AL-46 1
      valor:=2*palt1+100
      RETURN valor/1000
   ELSEIF pitem=22 // perfil AL-46 2
      valor:=2*plar1+100
      RETURN valor/1000
   ELSEIF pitem=15 // perfil guia duplo 1
      valor:=2*palt2+100
      RETURN valor/1000
   ELSEIF pitem=16 // perfil guia duplo 2
      valor:=2*plar2+100
      RETURN valor/1000
   ELSEIF pitem=27 // borracha
      valor:=2*palt2+2*plar2+50
      RETURN valor/1000
   ELSEIF pitem=29 // fitilho 7/6
      valor:=2*palt1+2*plar1+50
      RETURN valor/1000
   ELSEIF pitem=34 // parafuso fecho
      RETURN 6
   ELSEIF pitem=36 // porca
      RETURN 6
   ELSEIF pitem=40 // parafuso pequeno
      RETURN 12
   ELSEIF pitem=12 // bucha
      RETURN 12
   ELSEIF pitem=42 // dobradiáa
      RETURN 2
   ELSEIF pitem=43 // haste 200mm
      x:=plar1/2
      v1:=ABS(x-200)
      v2:=ABS(x-250)
      v3:=ABS(x-300)
      IF v1 < v2
         IF v1 < v3
            RETURN 1
         ELSE
            RETURN 0
         ENDIF
     ELSE
        RETURN 0
     ENDIF
   ELSEIF pitem=44 // haste 250mm
      x:=plar1/2
      v1:=ABS(x-200)
      v2:=ABS(x-250)
      v3:=ABS(x-300)
      IF v1 < v2
         RETURN 0
      ELSE
        IF v2 < v3
           RETURN 1
        ELSE
           RETURN 0
        ENDIF
     ENDIF
   ELSEIF pitem=45 // haste 300mm
      x:=plar1/2
      v1:=ABS(x-200)
      v2:=ABS(x-250)
      v3:=ABS(x-300)
      IF v1 < v2
         IF v1 < v3
            RETURN 0
         ELSE
            RETURN 1
         ENDIF
      ELSE
        IF v2 < v3
           RETURN 0
        ELSE
           RETURN 1
        ENDIF
     ENDIF
   //ELSEIF pitem=46 // Perfil tubo
   //   valor:=palt1+50
   //   RETURN valor
   ELSE
      RETURN 0
   ENDIF

ELSE
   RETURN 0
ENDIF


/*
 -----------------------------------
 ITEM  MATERIAL               UNID.
 -----------------------------------

   01   Trilho (1)............  m     // Perfil trilho
   02   Trilho (2)............  m     // Perfil trilho
   03   Tampa (1).............  m     // Perfil capa
   04   Tampa (2).............  m     // Perfil capa
   05   Acabamento (1)........  m     // Perfil arremate
   06   Acabamento (2)........  m     // Perfil arremate
   07   Acabamento (3)........  m     // Perfil arremate
   08   Acabamento (4)........  m     // Perfil arremate
   09   Acabamento (5)........  m     // Perfil arremate
   10   Acabamento (6)........  m     // Perfil arremate
   11   Acabamento (7)........  m     // Perfil arremate
   12   Acabamento (8)........  m     // Perfil arremate
   13   Acabamento (9)........  m     // Perfil arremate
   14   Acabamento (10).......  m     // Perfil arremate
   15   Calha "E" (1).........  m     // Perfil guia duplo
   16   Calha "E" (2).........  m     // Perfil guia duplo
   17   Calha "E" (3).........  m     // Perfil guia duplo
   18   Calha "E" (4).........  m     // Perfil guia duplo
   19   Calha "E" (5).........  m     // Perfil guia duplo
   20   Calha "E" (6).........  m     // Perfil guia duplo
   21   Perfil AL-46 (1)......  m     // Perfil AL-46
   22   Calha "F" (2).........  m     // Perfil AL-46
   23   Calha "F" (3).........  m     // Perfil AL-46
   24   Calha "F" (4).........  m     // Perfil AL-46
   25   Calha "H" (1).........  m     // Calha "H"
   26   Calha "H" (2).........  m     // Calha "H"
   27   Boracha...............  m     // Borracha
   28   Fitilho 5/7...........  m     // Escova de vedaá∆o 5/7
   29   Fitilho 7/6...........  m     // Escova de vedaá∆o 7/6
   30   Roldana...............  unid  // Roldana
   31   Suporte de Fixaá∆o....  unid  // Suporte de fixaá∆o
   32   Cunha.................  unid  // Cunha Trava
   33   Batedor...............  unid  // Batedeira Lim. Superior
   34   Parafuso Fecho........  unid  // Parafuso fecho
   35   Capa do Parafuso......  unid  // Capa do parafuso fecho
   36   Porca.................  unid  // Porca
   37   Fecho Central.........  unid  // Fecho central
   38   Fecho Lateral.........  unid  // Fecho lateral
   39   Parafuso Grande.......  unid  // Parafuso grande
   40   Parafuso Pequeno......  unid  // Parafuso pequeno
   41   Bucha.................  unid  // Bucha de Nylon
   42   Dobradiáa.............  unid  // Dobradiáa
   43   Haste 200mm...........  unid  // Haste janela 200 mm
   44   Haste 250mm...........  unid  // Haste janela 250 mm
   45   Haste 300mm...........  unid  // Haste janela 300 mm
   46   Perfil tubo...........  m
   47   Fechadura.............  unid

*/

********************************************************************************
PROCEDURE ConsReq()
// Consulta as Requisiá‰es de Material na Tela
********************************************************************************
// Declara os vetores de consulta.
LOCAL vdado[7],vmask[7],vcabe[7],vedit[7]
// Vari†veis para verificaá∆o de senha.
PRIVATE pv1:=pv2:=pv3:=pv4:=pv5:=.T.
// Declara as vari†veis auxiliares
PRIVATE mItem[27,10] // Matriz que ser† usada para ediá∆o dos itens
PRIVATE n,k,vmodo,vret
PRIVATE vordem,vdocto,vstatus,vdata,ves,vcodlocd,vcodlocp
PRIVATE vmovger,vvalor
PRIVATE vite,vcod,vpro,vuni,vqtd,vkt,valt,vlar,vare,vpre
PRIVATE vcodvm,vnpecas
PRIVATE vli,li,lf,vt,vord,tampa:=CHR(186)
/* vli:  linha inicial para ediá∆o dos itens.
   li:   linha atual.
   lf:   linha final.
   vt:   linha adicional quando houver rolamento da tela.
   vord: n£mero de itens .*/
// Inicializa a linha inicial para ediá∆o dos itens.
vli:=09
// Iniciliza mais algumas variaveis
li:=1
lf:=1
vt:=0
vord:=0
// Abertura dos arquivos de dados
marqs:={;
{(dircad+"FC_PRODU.DBF"),"Prc","Produtos do FC",3},;
{(dircad+"FC_LOCAL.DBF"),"Tlo","Locais de Estoque",2},;
{(dircad+"FC_COMPO.DBF"),"Com","Composiá∆o",1},;
{(dirmov+"FC_REQUI.DBF"),"Req","Requisiá‰es",5},;
{(dirmov+"FC_SALDO.DBF"),"Sdo","Saldo de Estoque",1},;
{(dirmov+"FC_SALGE.DBF"),"Sdg","Saldo de Estoque",1},;
{(dirmov+"FC_ITREQ.DBF"),"Rqi","Itens de Requisiá‰es",2}}
IF !AbreArqs(marqs,.F.)
   RETURN
ENDIF
SELECT Req
SET ORDER TO 1 // ordem
// Dados a serem apresentados.
vdado[01]:="ordem"
vdado[02]:="docto"
vdado[03]:="status"
vdado[04]:="data"
vdado[05]:="es"
vdado[06]:='codloc+Procura("Tlo",1,codloc,"nome")'
vdado[07]:='codop+nsenha'
// Cabeáalhos das colunas.
vcabe[01]:="Ordem"
vcabe[02]:="Nß Documento"
vcabe[03]:="Status"
vcabe[04]:="Data"
vcabe[05]:="E/S"
vcabe[06]:="Local"
vcabe[07]:="Operador"
// M†scaras de apresentaá∆o.
vmask[01]:="999999"
vmask[02]:="99999999"
vmask[03]:="!!"
vmask[04]:="99/99/99"
vmask[05]:="!"
vmask[06]:="@R 999-!!!!!!!!!!!!!!!!!!!!"
vmask[07]:="@R 999-!!!!!!!!!!!!!!!"
// vedit: vetor que determina os dados a serem editados.
AFILL(vedit,.F.)
// Informaá‰es para ajuda ao usu†rio.
PRIVATE mAjuda:={}
mAjuda:={;
"PgUp   - Retorna para a janela anterior",;
"PgDn   - Avanáa para a pr¢xima janela",;
"Home   - Retorna para o inicio do arquivo",;
"End    - Avanáa para o fim do arquivo",;
"Enter  - Mostra a Entrada em Tela Cheia",;
"Esc    - Finaliza a Consulta",;
"F2     - Pesquisa pela Ordem da Requisiá∆o",;
"F3     - Pesquisa pelo Local+Data+Status",;
"F4     - Pesquisa pela Local+Data+Documento",;
"F5     - Pesquisa pelo Documento+Status",;
"F6     - Pesquisa pelo Status+Documento+Ordem"}
// Construá∆o da Tela de Apresentaá∆o.
Sinal("REQUISIÄÂES","CONSULTAS")
Abrejan(2)
@ 04,01 SAY REPLICATE("ƒ",78)
// Barra de Tarefas.
SETCOLOR(vcr)
@ 22,00 SAY PADC("Enter=Consulta Esc=Encerra",80)
@ 23,00 SAY PADC("F1=Ajuda F2=Ordem F3=Local+Data+Sta F4=Local+Data+Doc F5=Doc+Sta F6=Sta+Doc+Ordem",80)
SETCOLOR(vcn)
// Chamada do procedimento de consulta desenvolvido com TBrowse.
ConsBrowse("Req",05,01,21,78,vdado,vmask,vcabe,vedit,1,{|| OpsReq()},;
"ordem",1,"999999",6,"Ordem",;
"codloc+DTOS(data)+status",2,"@R 999 99/99/99 99",15,"Loc+Status",;
"codloc+DTOS(data)+docto",3,"@R 999 99/99/99 99999999",21,"Loc+Doc",;
"docto",4,"@R 99999999 !!",15,"Doc+Status",;
"status+docto+ordem",5,"@R !! 99999999 99999999",15,"Status+Doc")
CLOSE DATABASES
RETURN

********************************************************************************
FUNCTION OpsReq()
// Opá‰es da consulta de Requisiá‰es.
********************************************************************************
LOCAL vtela
// Destaque do browse
@ 03,03 CLEAR TO 03,77
@ 03,03 SAY "Local:"
SETCOLOR(vcd)
@ 03,10 SAY Req->codloc+"-"+Procura("Tlo",1,codloc,"nome")
SETCOLOR(vcn)
// Teclas de opá‰es da consulta
IF LASTKEY()=K_ENTER
   // Enter - Consulta em tela cheia.
   //vtela:=SAVESCREEN(01,00,24,79)
   VisaoReq()
   //RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ENDIF
RETURN .F.

********************************************************************************
PROCEDURE VisaoReq()
// Visualiza a Entrada em Tela Cheia
********************************************************************************
LOCAL vtela:=SAVESCREEN(01,00,24,79)
SETCOLOR(vcn)
Abrejan(2)  // Abre a janela de dados.
DO WHILE .T.
   IniVarReq()
   vdocto:=Req->docto
   TransfReq()
   IniMatItReq(1,LEN(mItem))
   li:=lf:=1;vt:=0;vord:=0
   TransVetReq()
   UpdataReq()
   TelaReq()
   MostraItReq(1,vord,vcn)
   EditaItReq(5)
   SELECT Req
   IF vret=0
      EXIT
   ELSE
      SKIP vret
      LOOP
   ENDIF
ENDDO
RESTSCREEN(01,00,24,79,vtela)
RETURN

********************************************************************************
PROCEDURE ImprReq()
// Objetivo : imprimir a Entrada.
*********************************
LOCAL resto:=0
LOCAL vtit:="REQUISIÄ«O DE MATERIAL Nß "+TRANSFORM(vdocto,"@R 99999999")
IF !Imprime2(vtit)
   RETURN
ENDIF
SET DEVICE TO PRINTER
SET PRINTER TO &vcimpres
DO WHILE vcop > 0
   resto:=0
   pg   :=0
   /*
   vendeloja :=ALLTRIM(Procura("Loja",1,vcloja,"ende"))
   vbairloja :=ALLTRIM(Procura("Loja",1,vcloja,"bair"))
   vmuniloja :=ALLTRIM(Procura("Loja",1,vcloja,"muni"))
   vestaloja :=ALLTRIM(Procura("Loja",1,vcloja,"esta"))
   vcnpjloja :=ALLTRIM(Procura("Loja",1,vcloja,"cnpj"))
   vinscloja :=ALLTRIM(Procura("Loja",1,vcloja,"insc"))
   vceploja  :=ALLTRIM(Procura("Loja",1,vcloja,"cep"))
   vemailloja:=ALLTRIM(Procura("Loja",1,vcloja,"email"))
   */
   IF Escprint(80)
      RETURN
   ENDIF
   /*
         10        20        30        40        50        60        70        80        90
   3456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
   Data: XX/XX/XX - XX:XX:XX hs
   Setor Requisitado (De)..: XXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   Setor Requisitante(Para): XXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   */
   SET PRINTER ON
   ?? vcid10+vcia10+""
   SET PRINTER OFF
   SETPRC(0,0)
   @ PROW()+2,01 SAY vcnomeemp
   @ PROW()  ,01 SAY vcnomeemp
   //
   SET PRINT ON
   ?? vcid10+vcia15
   SET PRINT OFF
   //@ PROW()+1,01 SAY vendeloja+" - "+vbairloja+" - "+vmuniloja+"-"+vestaloja+" - Brasil - CEP:"+TRANSFORM(vceploja,"@R 99999-999")
   //@ PROW()+1,01 SAY "CGC:"+TRANSFORM(vcnpjloja,"@R 99.999.999/9999-99")+" - CGF:"+vinscloja+" - Email:"+vemailloja
   //
   SET PRINTER ON
   ?? vcid10+vcia10+""
   SET PRINTER OFF
   @ PROW()+1,01 SAY REPLICATE(CHR(205),79)
   @ PROW()+2,03 SAY vtit
   @ PROW(),  03 SAY vtit
   //
   SET PRINT ON
   ?? vcid10+vcia12
   SET PRINT OFF
   @ PROW()+2,03 SAY "Data: "+DTOC(vdata)+" - "+TRANSFORM(TIME(),"99:99")+" hs"

   @ PROW()+1,03 SAY "Setor Requisitado (De)..: "+vcodlocd+"-"+Procura("Tlo",1,vcodlocd,"nome")
   @ PROW()+1,03 SAY "Setor Requisitante(Para): "+vcodlocp+"-"+Procura("Tlo",1,vcodlocp,"nome")
   //@ PROW(),  59 SAY "Usu†rio Requisitante....: "+vcodop+vnsenha
   SELECT Rqi // Itens
   GO TOP
   SEEK vordem
   DO WHILE !EOF() .AND. Rqi->ordem=vordem
      IF Escprint(80)
         RETURN
      ENDIF
      //                          10        20        30        40        50        60        70        80        90
      //                 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345
      @ PROW()+2,00 SAY REPLICATE("-",96)
      @ PROW()+1,00 SAY "IT C‡DIGO  PRODUTO                                                UN   QUANT    PREÄO      VALOR"
      //                 XX XXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXxXXXXxXXXX XX XXXX.XX X.XXX,XX XXX.XXX,XX
      @ PROW()+1,00 SAY REPLICATE("-",96)
      DO WHILE !EOF() .AND. Rqi->ordem=vordem .AND. PROW()<=58
         @ PROW()+1,00 SAY Rqi->ite    PICTURE "99"
         @ PROW(),  03 SAY Rqi->codpro PICTURE "9999999"
         @ PROW(),  11 SAY Rqi->prod
         @ PROW(),  52 SAY IF(EMPTY(Rqi->alt),""," "+TRANSFORM(Rqi->quant/(Rqi->alt*Rqi->lar/1000000),"999")+"x"+STR(Rqi->alt,4)+"x"+STR(Rqi->lar,4))
         @ PROW(),  66 SAY Rqi->unid
         @ PROW(),  69 SAY TRANSFORM(Rqi->quant,"@E 9999.99")
         @ PROW(),  77 SAY TRANSFORM(Rqi->preco,"@E 9,999.99")
         @ PROW(),  86 SAY TRANSFORM(Rqi->quant*Rqi->preco,"@E 999,999.99")
         SKIP
         IF PROW() > 58
            EXIT
         ENDIF
      ENDDO
      @ PROW()+1,00 SAY REPLICATE("-",96)
      IF PROW() > 58
         EJECT
      ENDIF
   ENDDO
   @ PROW()+1,63 SAY "VALOR TOTAL.........."
   @ PROW(),  86 SAY vvalor PICTURE "@E 999,999.99"
   //
   @ PROW()+4, 01 SAY "___________________________________"
   @ PROW()+1, 01 SAY "     Visto do Requisitante         "
   //
   resto:=58-PROW()
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
PROCEDURE SaldoIni()
// Objetivo : Implantar os saldos iniciais.
*********************************************
// Atualiza Status
Sinal("SALDO","INICIAL")
// Declaraá∆o das vari†veis auxiliares
PRIVATE vcodloc,vdata,vcodpro,vprod,vunid,vmovger
PRIVATE vquant,vnpecas,valt,vlar,vcodvm
// Abertura dos arquivos de dados
//{(dirvm+"VM_ESTOQ.DBF"),"Stq","Estoque VM",2},;
//{(dirvm+"VM_ITSTQ.DBF"),"Sti","Itens de Estoque VM",1},;
marqs:={;
{(dircad+"FC_PRODU.DBF"),"Prc","Produtos do FC",3},;
{(dircad+"FC_GRUPO.DBF"),"Gru","Grupo de Produtos",2},;
{(dircad+"FC_LOCAL.DBF"),"Tlo","Locais de Estoque",2},;
{(dirmov+"FC_SALDO.DBF"),"Sdo","Saldo de Estoque",1},;
{(dirmov+"FC_SALGE.DBF"),"Sdg","Saldo de Estoque",1}}
IF !AbreArqs(marqs,.F.)
   RETURN
ENDIF
// Abertura de uma nova janela
Abrejan(2)
// Inicializaá∆o das vari†veis auxiliares
vcodloc:=SPACE(3)
vdata  :=DATE()
vcodpro:=vcodvm:=SPACE(7)
vprod  :=SPACE(40)
vunid  :=SPACE(2)
vmovger:=SPACE(1)
vquant :=vnpecas:=valt:=vlar:=0
// Apresentaá∆o dos T°tulos na tela
@ 05,05 SAY "Local..:"
@ 07,05 SAY "Data...:"
@ 09,05 SAY "Produto:"
@ 10,05 SAY "Unid...:"
@ 12,05 SAY "Quant..:"
// In°cio da rotina
DO WHILE .T.
   SETCOLOR(vcn)
   Aviso(24,"Digite os dados ou Tecle <Esc> Para Finalizar")
   SETCOLOR(vcd)
   @ 05,13 GET vcodloc PICTURE "999"
   Le()
   IF LASTKEY()=K_ESC
      EXIT
   ENDIF
   vcodloc:=Acha2(vcodloc,"Tlo",1,2,"codi","nome","999","@!",15,05,22,70,"C¢digo","Nome do Local")
   @ 05,13 SAY vcodloc PICTURE "999"
   @ 05,17 SAY Tlo->nome PICTURE "@!"
   @ 07,13 GET vdata PICTURE "99/99/99" VALID(!EMPTY(vdata) .AND. vdata<=DATE())
   @ 09,13 GET vcodpro PICTURE "9999999"
   Le()
   IF LASTKEY()=K_ESC
      EXIT
   ENDIF
   vcodpro:=Acha2(vcodpro,"Prc",1,2,"codpro","prod","9999999","@!",15,05,22,70,"C¢digo","Nome do Produto")
   vprod:=Prc->prod
   vunid:=LEFT(ALLTRIM(Prc->unid),2)
   @ 09,13 SAY vcodpro PICTURE "9999999"
   @ 09,21 SAY vprod   PICTURE "@!"
   @ 10,13 SAY vunid   PICTURE "!!"
   @ 10,15 GET vmovger PICTURE "!"
   Le()
   IF EMPTY(vmovger) // Cont†bil
      vquant:=SdoIn(vcodpro,vcodloc)
      @ 12,13 GET vquant PICTURE "@E 999,999.99"
      Le()
   ELSE              // Gerencial
      vquant:=SdoIg(vcodpro,vcodloc)
      /*
      @ 12,13 SAY vquant PICTURE "@E 999,999.99"
      EditaDim:=.F.
      IF ALLTRIM(vunid)=="M2"
         IF Chapa(vcodpro).OR.Modulado(vcodpro).OR.LEFT(vcodpro,2)=="43"
            // Se for chapa ou modulado ou box
            EditaDim:=.T.      // Solicita dimens‰es
         ELSE
            // Se n∆o for nenhum dos produtos acima
            SETCOLOR(vcn)
            Aviso(24,"Digite Zero Para Incluir Medidas")
            @ 12,13 GET vquant PICTURE "@E 999,999.99"
            Le()
            @ 24,00 CLEAR
         ENDIF
         IF vquant=0 .OR. EditaDim
            SETCOLOR(vcn)
            //vtela:=SAVESCREEN(01,00,24,79)
            SETCOLOR(vcf)
            Caixa(06,55,10,74,frame[6])
            @ 07,57 SAY "Quant__: "
            @ 08,57 SAY "Altura_: "
            @ 09,57 SAY "Largura: "
            SETCOLOR(vcr)
            @ 07,65 SAY vnpecas PICTURE "99999"
            @ 08,66 SAY valt    PICTURE "9999"
            @ 09,66 SAY vlar    PICTURE "9999"
            SETCOLOR(vcn)
            SET ESCAPE OFF
            IF Modulado(vcodpro)  // Se for modulado
               @ 07,65 GET vnpecas PICTURE "99999" //VALID vnpecas>0 .AND. vnpecas%10=0
               Le()
               IF EMPTY(vcodvm)
                  DimModula() // Solicita uma das dimens‰es padr‰es
               ENDIF
               @ 08,66 SAY valt PICTURE "9999" COLOR(vcr)
               @ 09,66 SAY vlar PICTURE "9999" COLOR(vcr)
               INKEY(0)
               vquant:=vnpecas*Quant(vunid,vcodpro,valt,vlar)
            ELSE
               @ 07,65 GET vnpecas PICTURE "99999" //VALID vnpecas>0
               @ 08,66 GET valt PICTURE "9999" VALID (valt>0 .AND. valt<3301)
               @ 09,66 GET vlar PICTURE "9999" VALID (vlar>0 .AND. vlar<3301)
               Le()
               vquant:=vnpecas*Quant(vunid,vcodpro,valt,vlar)
            ENDIF
            SET ESCAPE ON
            //RESTSCREEN(01,00,24,79,vtela)
            @ 12,13 SAY vquant PICTURE "@E 999,999.99" COLOR(vcd)
         ELSE
            vlar:=valt:=0
         ENDIF
      ELSE
      */
         @ 12,13 GET vquant PICTURE "@E 999,999.99" VALID(vquant>0)
         Le()
         vlar:=valt:=0
      //ENDIF
   ENDIF
   SETCOLOR(vcn)
   Aviso(24,"Implanta o Saldo Inicial")
   IF Confirme()
      IF EMPTY(vmovger) // Cont†bil
         GravaSdoIn(vcodpro,vcodloc,vquant)
      ELSE              // Gerencial
         GravaSdoIg(vcodpro,vcodloc,vquant,valt,vlar,vnpecas,vcodvm)
      ENDIF
   ENDIF
   vcodpro:=vcodvm:=SPACE(7)
   vquant:=vnpecas:=valt:=vlar:=0
   LOOP
ENDDO
SETCOLOR(vcn)
CLOSE DATABASES
RETURN

**************************************************************************
PROCEDURE GravaSdoIn(pcodpro,pcodloc,pquant)
// Grava Saldo Inicial em Estoque.
*****************************************************
SELECT Sdo
GO TOP
SEEK pcodpro+pcodloc
IF FOUND()
   IF Bloqreg(10)
      Sdo->sdoin:=pquant
      Sdo->saldo:=pquant+Sdo->entra-Sdo->saida+Sdo->trrec-Sdo->trexp
      UNLOCK
   ELSE
      Mensagem("Erro de Rede. Atualizaá∆o N∆o Efetuada !",3,1)
   ENDIF
ELSE
   IF Adireg(10)
      Sdo->codpro:=pcodpro
      Sdo->codloc:=pcodloc
      Sdo->sdoin :=pquant
      Sdg->saldo :=pquant
      UNLOCK
   ELSE
      Mensagem("Erro de Rede. Inclus∆o N∆o Efetuada !",3,1)
   ENDIF
ENDIF
RETURN

**************************************************************************
PROCEDURE GravaSdoIg(pcodpro,pcodloc,pquant,palt,plar,pnpecas,pcodvm)
// Grava Saldo Inicial em Estoque. (Gerencial)
*****************************************************
SELECT Sdg
GO TOP
SEEK pcodpro+pcodloc
IF FOUND()
   IF Bloqreg(10)
      Sdg->sdoin:=pquant
      Sdg->saldo:=pquant+Sdg->entra-Sdg->saida+Sdg->trrec-Sdg->trexp
      UNLOCK
   ELSE
      Mensagem("Erro de Rede. Atualizaá∆o N∆o Efetuada !",3,1)
   ENDIF
ELSE
   IF Adireg(10)
      Sdg->codpro:=pcodpro
      Sdg->codloc:=pcodloc
      Sdg->sdoin :=pquant
      Sdg->saldo :=pquant
      UNLOCK
   ELSE
      Mensagem("Erro de Rede. Inclus∆o N∆o Efetuada !",3,1)
   ENDIF
ENDIF
RETURN

/*
// Estoque VM
IF Chapa(pcodpro) // Se for chapa
   IF ExisteDim(pcodpro,palt,plar) // Se existir a dimens∆o
      SELECT Sti // Itens de Estoque VM
      IF Bloqreg(10)
         IF pcodloc="001" // Estoque MP
            Sti->quant:=pnpecas
         ENDIF
         IF pcodloc="051" // Estoque MP (Laminado)
            Sti->quant2:=pnpecas
         ENDIF
         UNLOCK
      ELSE
         Mensagem("Erro de Rede. Atualizaá∆o N∆o Efetuada !",3,1)
      ENDIF
      SELECT Stq // Estoque VM
      GO TOP
      SEEK pcodpro
      IF FOUND()
         IF Bloqreg(10)
            IF pcodloc="001" // Estoque MP
               Stq->quant:=pnpecas
            ENDIF
            IF pcodloc="051" // Estoque MP (Laminado)
               Stq->quant2:=pnpecas
            ENDIF
            UNLOCK
         ELSE
            Mensagem("Erro de Rede. Atualizaá∆o N∆o Efetuada !",3,1)
         ENDIF
      ENDIF
   ENDIF
ELSEIF Modulado(pcodpro,palt,plar) // Se for modulado
   SELECT Stq // Estoque VM
   GO TOP
   SEEK pcodvm
   IF FOUND()
      IF Bloqreg(10)
         Stq->quant:=pnpecas
         UNLOCK
      ELSE
         Mensagem("Erro de Rede. Atualizaá∆o N∆o Efetuada !",3,1)
      ENDIF
   ENDIF
ELSEIF BoxPadrao(pcodpro,palt,plar) // Se for box padr∆o
   IF palt=1835 // porta
      x:="1"
   ELSE         // fixo
      x:="2"
   ENDIF
   IF ExisteDim(LEFT(pcodpro,6)+x,palt,plar) // Se existir a dimens∆o
      SELECT Sti // Itens de Estoque VM
      IF Bloqreg(10)
         Sti->quant:=pnpecas
         UNLOCK
      ELSE
         Mensagem("Erro de Rede. Atualizaá∆o N∆o Efetuada !",3,1)
      ENDIF
      SELECT Stq // Estoque VM
      GO TOP
      SEEK LEFT(pcodpro,6)+x
      IF FOUND()
         IF Bloqreg(10)
            Stq->quant:=pnpecas
            UNLOCK
         ELSE
            Mensagem("Erro de Rede. Atualizaá∆o N∆o Efetuada !",3,1)
         ENDIF
      ENDIF
   ENDIF
ENDIF
RETURN
*/

**************************************************************************
PROCEDURE SdoIn(pcodpro,pcodloc)
// Pesquisa Saldo Inicial em Estoque.
*****************************************************
LOCAL vret:=0
LOCAL vareatrab:=SELECT()
SELECT Sdo
GO TOP
SEEK pcodpro+pcodloc
IF FOUND()
   vret:=Sdo->sdoin
ENDIF
SELECT(vareatrab)
RETURN(vret)

**************************************************************************
PROCEDURE SdoIg(pcodpro,pcodloc)
// Pesquisa Saldo Inicial em Estoque. (Gerencial)
*****************************************************
LOCAL vret:=0
LOCAL vareatrab:=SELECT()
SELECT Sdg
GO TOP
SEEK pcodpro+pcodloc
IF FOUND()
   vret:=Sdg->sdoin
ENDIF
SELECT(vareatrab)
RETURN(vret)

********************************************************************************
PROCEDURE TrExpeg(pordem)
// Objetivo: Transferir dando Saida do Local de Estoque.
// Sa°da (vcodlocd) (Gerencial)
********************************************************************************
LOCAL vareatrab:=SELECT()
SETCOLOR(vcp)
Aviso(24,"Atualizando Estoque. Aguarde...")
SETCOLOR(vcn)
SELECT Rqi // Itens de Requisiá∆o
GO TOP
SET SOFTSEEK ON
SEEK pordem
SET SOFTSEEK OFF
IF FOUND()
   mSaida:={} // Matriz para Saida
   DO WHILE Rqi->ordem=pordem .AND. !EOF()
      IF VAL(LEFT(Rqi->codpro,2)) < 95 // Se for anterior a serviáos
         AADD(mSaida,{Rqi->codpro,Rqi->quant,Rqi->alt,Rqi->lar,;
         Rqi->npecas,Rqi->codvm})
      ENDIF
      SKIP
   ENDDO
   IF !EMPTY(mSaida)
      i:=1
      DO WHILE i <= LEN(mSaida)
         TrExpig(mSaida[i])
         i++
      ENDDO
   ENDIF
ENDIF
SELECT(vareatrab)
@ 24,00 CLEAR
RETURN

********************************************************************************
PROCEDURE TrExpig(pitem)
// Objetivo: Transferir dando Saida por Item do Local de Estoque.
// Sa°da (vcodlocd) (Gerencial)
********************************************************************************
SELECT Sdg // Saldo de Estoque
GO TOP
SEEK pitem[1]+vcodlocd
IF FOUND()
   IF Bloqreg(10)
      Sdg->saldo-=pitem[2]
      Sdg->trexp+=pitem[2]
      UNLOCK
   ELSE
      Mensagem("Erro de Rede. Atualizaá∆o N∆o Efetuada !",3,1)
   ENDIF
ELSE
   IF Adireg(10)
      Sdg->codpro:=pitem[1]
      Sdg->codloc:=vcodlocd
      Sdg->saldo -=pitem[2]
      Sdg->trexp :=pitem[2]
      UNLOCK
   ELSE
      Mensagem("Erro de Rede. Atualizaá∆o N∆o Efetuada !",3,1)
   ENDIF
ENDIF
RETURN

/*
IF Chapa(pitem[1]) // Se for chapa
   IF ExisteDim(pitem[1],pitem[3],pitem[4]) // Se existir a dimens∆o
      SELECT Sti // Itens de Estoque VM
      IF Bloqreg(10)
         IF vcodlocd="001" // Estoque MP
            Sti->quant-=pitem[5]
         ENDIF
         IF vcodlocd="051" // Estoque MP (Laminado)
            Sti->quant2-=pitem[5]
         ENDIF
         UNLOCK
      ELSE
         Mensagem("Erro de Rede. Atualizaá∆o N∆o Efetuada !",3,1)
      ENDIF
      //
      SELECT Stq // Estoque VM
      GO TOP
      SEEK pitem[1]
      IF FOUND()
         IF Bloqreg(10)
            IF vcodlocd="001" // Estoque MP
               Stq->quant-=pitem[5]
            ENDIF
            IF vcodlocd="051" // Estoque MP (Laminado)
               Stq->quant2-=pitem[5]
            ENDIF
            UNLOCK
         ELSE
            Mensagem("Erro de Rede. Atualizaá∆o N∆o Efetuada !",3,1)
         ENDIF
      ENDIF
   ENDIF
ELSEIF Modulado(pitem[1],pitem[3],pitem[4]) .OR. ;
   Modulado(pitem[1],pitem[4],pitem[3])       // Se for modulado
   SELECT Stq // Estoque VM
   GO TOP
   SEEK pitem[6]
   IF FOUND()
      IF Bloqreg(10)
         Stq->quant-=pitem[5]
         UNLOCK
      ELSE
         Mensagem("Erro de Rede. Atualizaá∆o N∆o Efetuada !",3,1)
      ENDIF
   ENDIF
ELSEIF BoxPadrao(pitem[1],pitem[3],pitem[4]) // Se for box padr∆o
   IF pitem[3]=1835 .OR. pitem[4]=1835 // porta
      x:="1"
   ELSE                                // fixo
      x:="2"
   ENDIF
   IF ExisteDim(LEFT(pitem[1],6)+x,pitem[3],pitem[4]) // Se existir a dimens∆o
      SELECT Sti // Itens de Estoque VM
      IF Bloqreg(10)
         Sti->quant-=pitem[5]
         UNLOCK
      ELSE
         Mensagem("Erro de Rede. Atualizaá∆o N∆o Efetuada !",3,1)
      ENDIF
      SELECT Stq // Estoque VM
      GO TOP
      SEEK LEFT(pitem[1],6)+x
      IF FOUND()
         IF Bloqreg(10)
            Stq->quant-=pitem[5]
            UNLOCK
         ELSE
            Mensagem("Erro de Rede. Atualizaá∆o N∆o Efetuada !",3,1)
         ENDIF
      ENDIF
   ENDIF
ENDIF
RETURN
*/

********************************************************************************
PROCEDURE TrReceg(pordem)
// Objetivo: Transferir dando Entrada para o Local de Estoque.
// Entrada (vcodlocp) (Gerencial)
********************************************************************************
LOCAL vareatrab:=SELECT()
SETCOLOR(vcp)
Aviso(24,"Atualizando Estoque. Aguarde...")
SETCOLOR(vcn)
SELECT Rqi // Itens de Requisiá∆o
GO TOP
SET SOFTSEEK ON
SEEK pordem
SET SOFTSEEK OFF
IF FOUND()
   mEntra:={} // Matriz para Entrada
   DO WHILE Rqi->ordem=pordem .AND. !EOF()
      IF VAL(LEFT(Rqi->codpro,2)) < 95 // Se for anterior a serviáos
         AADD(mEntra,{Rqi->codpro,Rqi->quant,Rqi->alt,Rqi->lar,;
         Rqi->npecas,Rqi->codvm})
      ENDIF
      SKIP
   ENDDO
   IF !EMPTY(mEntra)
      i:=1
      DO WHILE i <= LEN(mEntra)
         TrRecig(mEntra[i])
         i++
      ENDDO
   ENDIF
ENDIF
SELECT(vareatrab)
@ 24,00 CLEAR
RETURN

********************************************************************************
PROCEDURE TrRecig(pitem)
// Objetivo: Transferir dando Entrada por Item para o Local de Estoque.
// Entrada (vcodlocp) (Gerencial)
********************************************************************************
SELECT Sdg // Saldo de Estoque
GO TOP
SEEK pitem[1]+vcodlocp
IF FOUND()
   IF Bloqreg(10)
      Sdg->saldo+=pitem[2]
      Sdg->trrec+=pitem[2]
      UNLOCK
   ELSE
      Mensagem("Erro de Rede. Atualizaá∆o N∆o Efetuada !",3,1)
   ENDIF
ELSE
   IF Adireg(10)
      Sdg->codpro:=pitem[1]
      Sdg->codloc:=vcodlocp
      Sdg->saldo :=pitem[2]
      Sdg->trrec :=pitem[2]
      UNLOCK
   ELSE
      Mensagem("Erro de Rede. Atualizaá∆o N∆o Efetuada !",3,1)
   ENDIF
ENDIF
RETURN

/*
IF Chapa(pitem[1]) // Se for chapa
   IF ExisteDim(pitem[1],pitem[3],pitem[4]) // Se existir a dimens∆o
      SELECT Sti // Itens de Estoque VM
      IF Bloqreg(10)
         IF vcodlocp="001" // Estoque MP
            Sti->quant+=pitem[5]
         ENDIF
         IF vcodlocp="051" // Estoque MP (Laminado)
            Sti->quant2+=pitem[5]
         ENDIF
         UNLOCK
      ELSE
         Mensagem("Erro de Rede. Atualizaá∆o N∆o Efetuada !",3,1)
      ENDIF
      //
      SELECT Stq // Estoque VM
      GO TOP
      SEEK pitem[1]
      IF FOUND()
         IF Bloqreg(10)
            IF vcodlocp="001" // Estoque MP
               Stq->quant+=pitem[5]
            ENDIF
            IF vcodlocp="051" // Estoque MP (Laminado)
               Stq->quant2+=pitem[5]
            ENDIF
            UNLOCK
         ELSE
            Mensagem("Erro de Rede. Atualizaá∆o N∆o Efetuada !",3,1)
         ENDIF
      ENDIF
   ENDIF
ELSEIF Modulado(pitem[1],pitem[3],pitem[4]) // Se for modulado
   SELECT Stq // Estoque VM
   GO TOP
   SEEK pitem[6]
   IF FOUND()
      IF Bloqreg(10)
         Stq->quant+=pitem[5]
         UNLOCK
      ELSE
         Mensagem("Erro de Rede. Atualizaá∆o N∆o Efetuada !",3,1)
      ENDIF
   ENDIF
ELSEIF BoxPadrao(pitem[1],pitem[3],pitem[4]) // Se for box padr∆o
   IF pitem[3]=1835 // porta
      x:="1"
   ELSE             // fixo
      x:="2"
   ENDIF
   IF ExisteDim(LEFT(pitem[1],6)+x,pitem[3],pitem[4]) // Se existir a dimens∆o
      SELECT Sti // Itens de Estoque VM
      IF Bloqreg(10)
         Sti->quant+=pitem[5]
         UNLOCK
      ELSE
         Mensagem("Erro de Rede. Atualizaá∆o N∆o Efetuada !",3,1)
      ENDIF
      SELECT Stq // Estoque VM
      GO TOP
      SEEK LEFT(pitem[1],6)+x
      IF FOUND()
         IF Bloqreg(10)
            Stq->quant+=pitem[5]
            UNLOCK
         ELSE
            Mensagem("Erro de Rede. Atualizaá∆o N∆o Efetuada !",3,1)
         ENDIF
      ENDIF
   ENDIF
ENDIF
RETURN
*/


********************************************************************************
//   Fim
********************************************************************************



