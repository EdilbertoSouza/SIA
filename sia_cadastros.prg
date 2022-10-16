*******************************************************************************
/* Programa: SIA_CADASTROS.PRG
   Funá∆o..: Manutená∆o dos Cadastros do Sistema.
   Sistema.: SIA-Sistema de Informaá‰es Academicas
   Autor...: Edilberto L. Souza e Grazielly Moura
*/
*******************************************************************************
// Definiáao dos arquivos-cabeáalho e das constantes utilizadas.
#include "SIA.CH"
#include "SETCURS.CH"

********************************************************************************
PROCEDURE Professores()
// Cadastro de Professores
********************************************************************************
PRIVATE mDados, mMasca, mCabec
mDados:={"matricula","nome"}
mMasca:={"99999","@!"}
mCabec:={"Matricula","Nome"}
TabDados("Professores", "Professores.DBF")
RETURN

********************************************************************************
PROCEDURE Alunos()
// Cadastro de Alunos
********************************************************************************
PRIVATE mDados, mMasca, mCabec
mDados:={"matricula","nome"}
mMasca:={"99999","@!"}
mCabec:={"Matricula","Nome"}
TabDados("Alunos", "Alunos.DBF")
RETURN

********************************************************************************
PROCEDURE Disciplinas()
// Cadastro de Disciplinas
********************************************************************************
PRIVATE mDados, mMasca, mCabec
mDados:={"codigo","nome"}
mMasca:={"99999","@!"}
mCabec:={"C¢digo","Nome"}
TabDados("Disciplinas", "Disciplinas.DBF")
RETURN

********************************************************************************
PROCEDURE TabDados(cTitulo, cTabela)
// Cadastro das Tabelas
********************************************************************************
LOCAL cIndice
PRIVATE codi,nome,vlin,pos1,pos2,majuda,pv[3],cred[3]
PRIVATE vdado,vmask,vcabe,vedit

vedit:={.F.,.F.}
pv:={.F.,.F.,.F.}

Sinal("CADASTRO", UPPER(cTitulo))
IF Abrearq((cDirBase+cTabela),"Tab",.F.,10)
   cIndice:=LEFT(cTabela,LEN(cTabela)-5)
   SET INDEX TO (cDirBase+cIndice+"1.CDX"),(cDirBase+cIndice+"2.CDX")
ELSE
   Mensagem("A Tabela de "+ cTitulo+" N∆o Est† Disponivel !",3,1)
   RETURN
ENDIF
// Informaá‰es para ajuda ao usu†rio.
mAjuda:={;
"F5         - Pesquisa por " + mCabec[1],;
"F6         - Pesquisa por " + mCabec[2],;
"F9         - Impress∆o da Tabela",;
"Ins        - Inclui um Novo Registro",;
"Ctrl+Enter - Edita o Registro Atual",;
"Del        - Exclui o Registro Atual",;
"Esc        - Finaliza"}
// Construá∆o da Tela de Apresentaá∆o.
Abrejan(2)
SETCOLOR(vcr)
@ 23,00 SAY PADC("F1=Ajuda F5="+mCabec[1]+" F6="+mCabec[2]+" F9=Impr Ins=Inclui Ctrl+Enter=Altera Del=Exclui <Esc>",80)
SETCOLOR(vcn)
pos1:=INT((77-MAX(LEN(&(mDados[1])),LEN(mCabec[1]))-MAX(LEN(&(mDados[2])),LEN(mCabec[2])))/2)
pos2:=pos1+MAX(LEN(&(mDados[1])), LEN(mCabec[1]))+3
// Chamada do procedimento de consulta desenvolvido com TBrowse.
ConsBrowse("Tab",03,01,22,78,mDados,mMasca,mCabec,vedit,0,{|| Ftab()},;
           mDados[1],1,mMasca[1],LEN(mMasca[1]),mCabec[1],;
           mDados[2],2,mMasca[2],LEN(mMasca[2]),mCabec[2])
CLOSE DATABASE
RETURN

*******************************************************************************
FUNCTION Ftab()
// Funá∆o com opá‰es da Consulta
*******************************************************************************
LOCAL vtela,vreg
IF LASTKEY()=K_F2
   // Tecla <F2> - Redefinindo para anular pesquisa pela chave1
   RETURN .T.
ELSEIF LASTKEY()=K_F3
   // Tecla <F3> - Redefinindo para anular pesquisa pela chave2
   RETURN .T.
ELSEIF LASTKEY()=K_F5
   // Tecla <F5> - Pesquisa por C¢digo
   @ 24,00 CLEAR
   SET ORDER TO 1
   vcodi:=SPACE(LEN(mDados[1]))
   @ 24,20 SAY mCabec[1] + ": " GET vcodi PICTURE mMasca[1]
   Le()
   IF EMPTY(vcodi)
      RETURN .T.
   ENDIF
   vcodi:=Zeracod(ALLTRIM(vcodi))
   rec:=RECNO()
   SET SOFTSEEK ON
   SEEK vcodi
   SET SOFTSEEK OFF
   IF EOF()
      Mensagem("Desculpe, N∆o Encontrado !",3,1)
      GO rec
      RETURN .T.
   ENDIF
   RETURN .T.
ELSEIF LASTKEY()=K_F6
   // Tecla <F6> - Pesquisa por Nome
   @ 24,00 CLEAR
   SET ORDER TO 2
   vnome:=SPACE(LEN(nome))
   @ 24,05 SAY mCabec[2] + ": " GET vnome PICTURE mMasca[2]
   Le()
   IF EMPTY(vnome)
      RETURN .T.
   ENDIF
   rec:=RECNO()
   SET SOFTSEEK ON
   SEEK vnome
   SET SOFTSEEK OFF
   IF EOF()
      Mensagem("Desculpe, N∆o Encontrado !",3,1)
      GO rec
      RETURN .T.
   ENDIF
   RETURN .T.
ELSEIF LASTKEY()=K_F9
   // Tecla <F9> - Imprime Relat¢rio
   vreg:=RECNO()
   vtela:=SAVESCREEN(01,00,23,79)
   //RelTab(cTabela)
   Mensagem("Rotina a Implementar")
   SELECT Tab
   GO vreg
   RESTSCREEN(01,00,23,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_INS
   // Tecla <Ins> - Inclus∆o no browse.
   vlin:=ROW()
   SELECT("Tab")
   SET ORDER TO 1
   vtela:=SAVESCREEN(vlin-1,01,vlin+1,78)
   vcodi:=SPACE(5)
   vnome:=SPACE(50)
   @ vlin-1, 01 TO vlin+1,78
   SETCOLOR(vcn)
   @ vlin, pos1 GET vcodi PICTURE mMasca[1]
   @ vlin, pos2 GET vnome PICTURE mMasca[2]
   Aviso(24,"Digite os Novos Dados")
   Le()
   IF EMPTY(vcodi)
      RESTSCREEN(vlin-1,01,vlin+1,78,vtela)
      RETURN .T.
   ENDIF
   vcodi:=Zeracod(vcodi)
   SET ORDER TO 1
   SEEK vcodi
   IF FOUND()
      Mensagem("Desculpe, C¢digo j† Cadastrado !",3,1)
      RESTSCREEN(vlin-1,01,vlin+1,78,vtela)
      RETURN .T.
   ENDIF
   IF Confirme()
      IF Adireg(10)
         REPLACE &(mDados[1]) WITH vcodi
         REPLACE &(mDados[2]) WITH vnome
         UNLOCK
      ELSE
         Mensagem("Erro de Rede, Inclus∆o N∆o Efetuada!",3,1)
      ENDIF
      RESTSCREEN(vlin-1,01,vlin+1,78,vtela)
      RETURN .T.
   ENDIF
   RESTSCREEN(vlin-1,01,vlin+1,78,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_CTRL_ENTER
   // Tecla <Ctrl+Enter> - Alteraá∆o no browse.
   vlin:=ROW()
   SELECT("Tab")
   vtela:=SAVESCREEN(vlin-1,01,vlin+1,78)
   vcodi:=&(mDados[1])
   vnome:=&(mDados[2])
   @ vlin-1, 01 TO vlin+1,78
   SETCOLOR(vcr)
   @ vlin, pos1 SAY vcodi PICTURE mMasca[1]
   SETCOLOR(vcn)
   @ vlin, pos2 GET vnome PICTURE mMasca[2]
   Aviso(24,"Altere os Dados ou Tecle <PgDn>")
   Le()
   IF UPDATED()
      IF Bloqreg(10)
         REPLACE nome WITH vnome
         UNLOCK
      ELSE
         Mensagem("O Registro N∆o Est† Dispon°vel !",3,1)
      ENDIF
      RESTSCREEN(vlin-1,01,vlin+1,78,vtela)
      RETURN .T.
   ELSE
      RESTSCREEN(vlin-1,01,vlin+1,78,vtela)
      RETURN .T.
   ENDIF
ELSEIF LASTKEY()=K_DEL
   // Tecla <Del> - Exclus∆o no browse.
   vlin:=ROW()
   SELECT("Tab")
   vtela:=SAVESCREEN(vlin-1,01,vlin+1,78)
   @ vlin-1, 01 TO vlin+1,78
   SETCOLOR(vcr)
   @ vlin, pos1 SAY &(mDados[1]) PICTURE mMasca[1]
   @ vlin, pos2 SAY &(mDados[2]) PICTURE mMasca[2]
   SETCOLOR(vcn)
   IF Exclui()
      IF Bloqreg(10)
         DELETE
         UNLOCK
      ELSE
         Mensagem("O Registro N∆o Est† Dispon°vel !",3,1)
      ENDIF
      SKIP
      RESTSCREEN(vlin-1,01,vlin+1,78,vtela)
      RETURN .T.
   ELSE
      RESTSCREEN(vlin-1,01,vlin+1,78,vtela)
      RETURN .T.
   ENDIF
ENDIF
RETURN .F.

*******************************************************************************
PROCEDURE RelTab(cTabela)
// Relat¢rio das Tabelas
*******************************************************************************
LOCAL vtit1,vtit2
IF cTabela=1
   Sinal("CADASTRO","RELAT‡RIO")
   vtit1:="Relat¢rio de "
ENDIF
vtit2:="Ordem de c¢digo"
tk:=0
IF !Imprime2(vtit1)
   RETURN
ENDIF
pg:=0
GO TOP
SET DEVICE TO PRINTER
SET PRINTER TO &vcimpres
DO WHILE !EOF()
   Cabe(vcnomeemp,vsist,vtit1,vtit2,80,vcia10)
   @ PROW()+1,pos1 SAY "C¢digo"
   @ PROW()  ,pos2 SAY "Nome"
   @ PROW()+1,0 SAY REPLICATE("-",80)
   DO WHILE PROW()<58 .AND. .NOT. EOF()
      IF EscPrint(80)
         RETURN
      ENDIF
      @ PROW()+1,pos1  SAY codi PICTURE mMasca[1]
      @ PROW()  ,pos2  SAY nome PICTURE mMasca[2]
      SKIP
   ENDDO
ENDDO
@ PROW()+2,0 SAY REPLICATE("=",80)
EJECT
SET PRINTER TO
SET DEVICE TO SCREEN
IF vcporta="2" // tela
   ImprTela(vcimpres,80)
ENDIF
RETURN

********************************************************************************
PROCEDURE Turmas()
// Consulta o Cadastro de Turmas
********************************************************************************
// Declara os vetores de consulta.
LOCAL vdado[4],vmask[4],vcabe[4],vedit[4]
// Declara as vari†veis auxiliares
PRIVATE mItem[30,6] // Matriz que ser† usada para ediá∆o dos itens
PRIVATE n,k,vret
PRIVATE vprofessor,vdisciplina,vsemestre
PRIVATE vite,vmat,valu,vnt1,vnt2,vntf
PRIVATE vli,li,lf,vt,vord,tampa:=CHR(186)
/* vli:  linha inicial para ediá∆o dos itens.
   li:   linha atual.
   lf:   linha final.
   vt:   linha adicional quando houver rolamento da tela.
   vord: n£mero de itens .*/
// Inicializa a linha inicial para ediá∆o dos itens.
vli:=9
// Iniciliza mais algumas variaveis
li:=1
lf:=1
vt:=0
vord:=0
// Abertura dos arquivos de dados
IF Abrearq((cDirBase+"Turmas.DBF"),"Turma",.F.,10)
   SET INDEX TO (cDirBase+"Turma1.CDX"),(cDirBase+"Turma2.CDX"),(cDirBase+"Turma3.CDX")
ELSE
   Mensagem("A Tabela de Turmas N∆o Est† Disponivel !",3,1)
   RETURN
ENDIF
IF Abrearq((cDirBase+"ItensTurma.DBF"),"Item",.F.,10)
   SET INDEX TO (cDirBase+"ItensTurm1.CDX")
ELSE
   Mensagem("A Tabela de Professores N∆o Est† Disponivel !",3,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF Abrearq((cDirBase+"Professores.DBF"),"Prof",.F.,10)
   SET INDEX TO (cDirBase+"Professore1.CDX"),(cDirBase+"Professore2.CDX")
ELSE
   Mensagem("A Tabela de Professores N∆o Est† Disponivel !",3,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF Abrearq((cDirBase+"Disciplinas.DBF"),"Disc",.F.,10)
   SET INDEX TO (cDirBase+"Disciplina1.CDX"),(cDirBase+"Disciplina2.CDX")
ELSE
   Mensagem("A Tabela de Disciplinas N∆o Est† Disponivel !",3,1)
   CLOSE DATABASE
   RETURN
ENDIF
IF Abrearq((cDirBase+"Alunos.DBF"),"Aluno",.F.,10)
   SET INDEX TO (cDirBase+"Aluno1.CDX"),(cDirBase+"Aluno2.CDX")
ELSE
   Mensagem("A Tabela de Alunos N∆o Est† Disponivel !",3,1)
   CLOSE DATABASE
   RETURN
ENDIF
SELECT Turma
SET ORDER TO 1 // codigo
// Dados a serem apresentados.
vdado[01]:="codigo"
vdado[02]:='Turma->professor+Procura("Prof",1,professor,"nome")'
vdado[03]:='Turma->disciplina+Procura("Disc",1,disciplina,"nome")'
vdado[04]:="semestre"
// Cabeáalhos das colunas.
vcabe[01]:="C¢digo"
vcabe[02]:="Professor"
vcabe[03]:="Disciplina"
vcabe[04]:="Semestre"
// M†scaras de apresentaá∆o.
vmask[01]:="99999"
vmask[02]:="@R 99999-!!!!!!!!!!!!!!!!!!!!"
vmask[03]:="@R 99999-!!!!!!!!!!!!!!!!!!!!"
vmask[04]:="@R 9999.9"
// vedit: vetor que determina os dados a serem editados.
AFILL(vedit,.F.)
// Informaá‰es para ajuda ao usu†rio.
PRIVATE mAjuda:={}
mAjuda:={;
"PgUp   - Retorna para a janela anterior",;
"PgDn   - Avanáa para a pr¢xima janela",;
"Home   - Retorna para o inicio do arquivo",;
"End    - Avanáa para o fim do arquivo",;
"Enter  - Mostra a Turma em Tela",;
"Esc    - Finaliza a Consulta",;
"F2     - Pesquisa pelo C¢digo da Turma",;
"F3     - Pesquisa pelo Professor",;
"F4     - Pesquisa pela Disciplina",;
"F5     - Pesquisa pelo Semestre"}
// Construá∆o da Tela de Apresentaá∆o.
Sinal("CADASTRO", "TURMAS")
Abrejan(2)
@ 04,01 SAY REPLICATE("ƒ",78)
// Barra de Tarefas.
SETCOLOR(vcr)
@ 22,00 SAY PADC("Ins=Inclui Ctrl+Enter=Altera Del=Exclui Enter=Consulta Esc=Encerra",80)
@ 23,00 SAY PADC("F1=Ajuda F2=Codigo F3=Professor F4=Disciplina F5=Semestre",80)
SETCOLOR(vcn)
// Chamada do procedimento de consulta desenvolvido com TBrowse.
ConsBrowse("Turma",05,01,21,78,vdado,vmask,vcabe,vedit,1,{|| OpsTurma()},;
"codigo"    ,1,"99999"     ,5,"C¢digo",;
"professor" ,2,"99999"     ,5,"Professor",;
"disciplina",3,"99999"     ,5,"Disciplina",;
"semestre"  ,4,"@R 9999.9" ,5,"Semestre")
CLOSE DATABASES
RETURN

********************************************************************************
FUNCTION OpsTurma()
// Opá‰es da consulta de Turmas.
********************************************************************************
LOCAL vtela
// Destaque do browse
@ 03,03 CLEAR TO 03,77
@ 03,03 SAY "Disciplina:"
SETCOLOR(vcd)
@ 03,14 SAY Turma->disciplina+"-"+Procura("Disc",1,disciplina,"nome")
SETCOLOR(vcn)
// Teclas de opá‰es da consulta
IF LASTKEY()=K_INS
   // Tecla <Ins> - Inclus∆o
   ManutencaoTurma(1)
   RETURN .T.
ELSEIF LASTKEY()=K_CTRL_ENTER
   // Tecla <Ctrl+Enter> - Alteraá∆o
   ManutencaoTurma(2)
   RETURN .T.
ELSEIF LASTKEY()=K_DEL
   // Tecla <Del> - Exclus∆o
   ManutencaoTurma(3)
   RETURN .T.
ELSEIF LASTKEY()=K_ENTER
   // Tecla <Enter> - Consulta
   ManutencaoTurma(4)
   RETURN .T.
ENDIF
RETURN .F.

********************************************************************************
PROCEDURE ManutencaoTurma(modo)
/* Manutená∆o das Turmas
   ParÉmetro:  modo   1-Inclus∆o  2-Alteraá∆o  3-Exclus∆o  4-Consulta */
********************************************************************************
LOCAL vtela:=SAVESCREEN(01,00,24,79)
PRIVATE mItem[30,10] // Matriz que ser† usada para ediá∆o dos itens
PRIVATE n,k,vmodo
PRIVATE vcodigo,vprofessor,vdisciplina,vsemestre
PRIVATE vite,vmat,valu,vnt1,vnt2,vntf
PRIVATE vli,li,lf,vt,vord,tampa:=CHR(186)
/* vli:  linha inicial para ediá∆o dos itens.
   li:   linha atual.
   lf:   linha final.
   vt:   linha adicional quando houver rolamento da tela.
   vord: n£mero de itens. */
// Inicializa a linha inicial para ediá∆o dos itens.
vli:=9
// Apresenta a operaá∆o escolhida.
IF modo=1
   Sinal("TURMA","INCLUS«O")
ELSEIF modo=2
   Sinal("TURMA","ALTERAÄ«O")
ELSEIF modo=3
   Sinal("TURMA","EXCLUS«O")
ELSEIF modo=4
   Sinal("TURMA","CONSULTA")
ENDIF
//
DO WHILE .T.
   Abrejan(2)
   SELECT Turma
   SET ORDER TO 1
   IniVarTurma()  // Inicializa as vari†veis auxiliares
   vmodo:=modo
   IF vmodo=1
      SET ORDER TO 1
      GO BOTTOM
      vcodigo:=STRZERO(VAL(Turma->codigo)+1,5)
   ELSE
      vcodigo:=Turma->codigo
   ENDIF
   TelaTurma()
   IniMatItTurma(1,LEN(mItem))
   li:=lf:=1;vt:=0;vord:=0
   IF vmodo=1  // Inclus∆o
      EditaTurma()
      IF LASTKEY()=K_ESC
         EXIT
      ENDIF
      EditaItTurma(vmodo)
   ENDIF
   SEEK vcodigo
   IF FOUND()
      TransfTurma()
      TransVetTurma()
      TelaTurma()
      MostraItTurma(1,vord,vcn)
      IF vmodo=2 // Alteraá∆o
         EditaTurma()
         IF LASTKEY()=K_ESC
            EXIT
         ENDIF
         EditaItTurma(vmodo)
      ELSEIF vmodo=3 // Exclus∆o
         ExcluiTurma()
         EXIT
      ELSEIF vmodo=4 // Consulta
         EditaItTurma(vmodo)
         EXIT
      ENDIF
   ENDIF
ENDDO
SETCOLOR(vcn)
RESTSCREEN(01,00,24,79,vtela)
RETURN

******************************************************************************
PROCEDURE IniVarTurma()
// Inicializa vari†veis auxiliares
**********************************
vcodigo    :=SPACE(5)
vprofessor :=SPACE(5)
vdisciplina:=SPACE(5)
vsemestre  :=SPACE(5)
RETURN

********************************************************************************
PROCEDURE TelaTurma()
// Apresenta os dados na tela.
********************************************************************************
/*       10        20        30        40        50        60        70        80
01234567890123456789012345678901234567890123456789012345678901234567890123456789
4    C¢digo:XXXXX                             Semestre: XXXX.X
5
6    Professor.:XXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
7    Disciplina:XXXXX-40XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
*/
SETCOLOR(vcn)
@ 04,05 SAY "C¢digo:"
@ 04,46 SAY "Semestre:"
@ 06,05 SAY "Professor.:"
@ 07,05 SAY "Disciplina:"
SETCOLOR(vcd)
@ 04,12 SAY vcodigo     PICTURE "99999"
@ 04,56 SAY vsemestre   PICTURE "@R 9999.9"
@ 06,16 SAY vprofessor  PICTURE "99999"
@ 06,21 SAY "-"+Procura("Prof",1,vprofessor,"nome")
@ 07,16 SAY vdisciplina PICTURE "99999"
@ 07,21 SAY "-"+Procura("Disc",1,vdisciplina,"nome")
SETCOLOR(vcr)
// M†scara de ediá∆o dos itens.
//                   10        20        30        40        50        60        70        80
//          01234567890123456789012345678901234567890123456789012345678901234567890123456789
@ 09,01 SAY "IT≥MATRIC.≥ALUNO                                    ≥ NOTA1| NOTA2| NOTA FINAL"
//           99 XXXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   99,99  99,99       99,99
SETCOLOR(vcn)
RETURN

********************************************************************************
PROCEDURE EditaTurma()
// Edita os dados na tela.
********************************************************************************
SETCURSOR(IF(READINSERT(),SC_INSERT,SC_NORMAL))
//
osemestre:=GetNew()
osemestre:colorSpec:=vcd
osemestre:row:=04;osemestre:col:=56
osemestre:name:="vsemestre";osemestre:picture:="@R 9999.9"
osemestre:block:={|valor| IF(PCOUNT()>0,vsemestre:=valor,vsemestre)}
osemestre:postBlock:={|valor| !Empty(vsemestre)}
//
oprofessor:=GetNew()
oprofessor:colorSpec:=vcd
oprofessor:row:=06;oprofessor:col:=16
oprofessor:name:="vprofessor";oprofessor:picture:="99999"
oprofessor:block:={|valor| IF(PCOUNT()>0,vprofessor:=valor,vprofessor)}
oprofessor:postBlock:={|valor| ValidaProfessor()}
//
odisciplina:=GetNew()
odisciplina:colorSpec:=vcd
odisciplina:row:=07;odisciplina:col:=16
odisciplina:name:="vdisciplina";odisciplina:picture:="99999"
odisciplina:block:={|valor| IF(PCOUNT()>0,vdisciplina:=valor,vdisciplina)}
odisciplina:postBlock:={|valor| ValidaDisciplina()}
//
SETCOLOR(vcr) // Linha de Orientaá∆o ao usu†rio
@ 23,01 SAY PADC("F1=Ajuda   F10=Calculadora    Esc=Fim",80)
SETCOLOR(vcn)
Aviso(24,"Digite os dados ou tecle <Esc> para encerrar")
SETCURSOR(2)
READMODAL({osemestre,oprofessor,odisciplina})
SETCURSOR(0)
RETURN

******************************************************************************
FUNCTION ValidaProfessor()
******************************************************************************
DO WHILE .T.
   vprofessor:=Zeracod(vprofessor)
   vprofessor:=Acha2(vprofessor,"Prof",1,2,"matricula","nome","99999","@!",;
   15,02,22,78,"Matricula","Nome")
   IF EMPTY(vprofessor) .OR. LASTKEY()==K_ESC
      LOOP
   ENDIF
   TelaTurma()
   RETURN .T.
ENDDO

******************************************************************************
FUNCTION ValidaDisciplina()
******************************************************************************
DO WHILE .T.
   vdisciplina:=Zeracod(vdisciplina)
   vdisciplina:=Acha2(vdisciplina,"Disc",1,2,"codigo","nome","99999","@!",;
   15,02,22,78,"C¢digo","Nome")
   IF EMPTY(vdisciplina) .OR. LASTKEY()==K_ESC
      LOOP
   ENDIF
   TelaTurma()
   RETURN .T.
ENDDO

******************************************************************************
PROCEDURE IniMatItTurma(pi,pf)
// Inicializa a matriz de itens
// pi-elemento inicial    pf-elemento final
******************************************************************************
DO WHILE pi <= pf
   mItem[pi,1]:=SPACE(2)    // item
   mItem[pi,2]:=SPACE(5)    // matricula
   mItem[pi,3]:=SPACE(40)   // aluno
   mItem[pi,4]:=0           // nota 1
   mItem[pi,5]:=0           // nota 2
   mItem[pi,6]:=0           // nota 3
   pi++
ENDDO
RETURN

********************************************************************************
PROCEDURE MostraItTurma(ni,nf,vcor,pmodo)
/* Objetivo: Apresenta os itens das notas na tela.
   ParÉmetros: ni:   n£mero do item inicial.
               nf:   n£mero do item final.
               vcor: padr∆o de cor a serem apresentados os itens. */
********************************************************************************
// M†scara de ediá∆o dos itens.
//                   10        20        30        40        50        60        70        80
//          01234567890123456789012345678901234567890123456789012345678901234567890123456789
//09,01 SAY "IT≥MATRIC.≥ALUNO                                    ≥ NOTA1| NOTA2| NOTA FINAL"
//           99 XXXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   99,99  99,99       99,99
SETCOLOR(vcor)
IF pmodo==NIL
   pmodo=1
ENDIF
FOR i=ni TO IF(nf<23-vli,nf,22-vli)
   IF !EMPTY(mItem[i+vt,2])
      @ vli+i,01 SAY STRZERO(i+vt,2) // item
      @ vli+i,04 SAY mItem[i+vt,2] PICTURE "99999" // matricula
      @ vli+i,12 SAY mItem[i+vt,3] PICTURE "@!"      // aluno
      @ vli+i,55 SAY IF(!EMPTY(mItem[i+vt,4]),TRANSFORM(mItem[i+vt,4],"@E 99.99"),"") // nota1
      @ vli+i,62 SAY IF(!EMPTY(mItem[i+vt,5]),TRANSFORM(mItem[i+vt,5],"@E 99.99"),"") // nota2
      @ vli+i,74 SAY IF(!EMPTY(mItem[i+vt,6]),TRANSFORM(mItem[i+vt,6],"@E 99.99"),"") // notaf
      @ vli+i,03 SAY "≥"
      @ vli+i,11 SAY "≥"
      @ vli+i,53 SAY "≥"
      @ vli+i,60 SAY "≥"
      @ vli+i,67 SAY "≥"
   ELSE
      @ vli+i,1 SAY SPACE(78)
   ENDIF
NEXT
SETCOLOR(vcn)
RETURN

********************************************************************************
PROCEDURE EditaItTurma(pmodo)
// Edita os itens na tela.
********************************************************************************
LOCAL vmodo:=pmodo
vret:=0
DO WHILE .T.
   // Apresenta a linha de orientaá∆o ao usu†rio.
   SETCOLOR(vcr)
   IF vmodo=4 // Consulta
      @ 23,00 SAY PADC(" F1=Ajuda   Setas=Movimenta Cursor   F3=Imprime   Esc=Retorna ",80)
   ELSE
      @ 23,00 SAY PADC(" F1=Ajuda   Ins=Inclui Item   Del=Exclui Item   F8=Edita   Esc=Encerra ",80)
   ENDIF
   // Apresenta a setinha indicando o item selecionado.
   SETCOLOR(vcp)
   @ vli+li,0 SAY CHR(178)
   SETCOLOR(vcn)
   // Mostra o item selecionado.
   MostraItTurma(li,li,vca)
   // Aguarda o pressionamento de uma tecla de controle pelo usu†rio.
   tk:=INKEY(0)
   IF (li+vt) > LEN(mItem)
       Mensagem("N∆o Pode Cadastrar Mais de "+STR(LEN(mItem),2)+" Itens!",3,1)
       LOOP
   ENDIF
   IF tk=K_F1  // Pressionada a tecla <F1>:ajuda
      IF vmodo=4     // Consulta
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
      vite :=mItem[li+vt,1]  // nr. do item
      vmat :=mItem[li+vt,2]  // matricula
      valu :=mItem[li+vt,3]  // aluno
      vnt1 :=mItem[li+vt,4]  // nota 1
      vnt2 :=mItem[li+vt,5]  // nota 2
      vntf :=mItem[li+vt,6]  // nota final
      SETCOLOR(vcn)
      @ vli+li,01 SAY vite  PICTURE "99"
      // Solicita o c¢digo do produto.
      @ vli+li,04 GET vmat PICTURE "99999"
      Aviso(24,"Digite a Matr°cula do Aluno")
      Le()
      @ 24,00 CLEAR
      vmat:=Acha2(vmat,"Aluno",1,2,"matricula","nome","99999","@!",15,05,22,76,"Matr°cula","Nome do Aluno")
      // Retorna se a matr°cula estiver em branco.
      IF EMPTY(vmat)
         @ vli+li,01 SAY SPACE(78)
         LOOP
      ENDIF
      valu:=Aluno->nome
      // Reapresenta os dados na tela.
      @ vli+li,04 SAY vmat  PICTURE "99999"
      @ vli+li,12 SAY valu  PICTURE "@!"
      // continua a ediá∆o dos itens
      @ vli+li,55 GET vnt1 PICTURE "@E 99.99"
      @ vli+li,62 GET vnt2 PICTURE "@E 99.99"
      @ vli+li,74 GET vntf PICTURE "@E 99.99"
      Le()
      SETCOLOR(vcn)
      IF EMPTY(mItem[li+vt,2])
         ++vord
      ENDIF
      // Atualiza a matriz dos itens.
      mItem[li+vt,1]:=STRZERO(li+vt,2)
      mItem[li+vt,2]:=vmat
      mItem[li+vt,3]:=valu
      mItem[li+vt,4]:=vnt1
      mItem[li+vt,5]:=vnt2
      mItem[li+vt,6]:=vntf
      // Reapresenta o item
      @ vli+li,0 SAY tampa
      MostraItTurma(li,li,vcn)
      // Incrementa uma linha de ediá∆o.
      IF li<(22-vli)
         ++li
      ELSE
         // Realiza o rolamento da tela.
         IF vt<(LEN(mItem)-(22-vli))
            ++vt
            SCROLL(vli+1,1,22,78,1)
            MostraItTurma(li,li,vcn)
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
      MostraItTurma(li,li,vcn)
      // Decrementa a linha dos itens.
      IF li>1
         --li
      ELSE
         // Realiza o rolamento da tela.
         IF vt>0
            --vt
            SCROLL(vli+1,1,22,78,-1)
            // Mostra o item.
            MostraItTurma(li,li,vcn)
         ENDIF
      ENDIF
   ELSEIF tk=K_DOWN
      // Foi pressionada a Seta para Baixo: desloca para o item seguinte.
      SETCOLOR(vcn)
      @ vli+li,0 SAY tampa
      // Mostra o item.
      MostraItTurma(li,li,vcn)
      // Incrementa a linha dos itens.
      IF li<lf
         ++li
      ELSE
         // Realiza o rolamento da tela.
         IF vt<(LEN(mItem)-(22-vli)) .AND. !EMPTY(mItem[li+vt,02])
            ++vt
            SCROLL(vli+1,1,22,78,1)
            // Mostra o item.
            MostraItTurma(li,li,vcn)
         ENDIF
      ENDIF
   ELSEIF tk=K_PGUP
      // Page Up: se for consulta carrega pr¢ximo registro.
      IF vmodo#4
         LOOP
      ELSE
         vret:=1
         EXIT
      ENDIF
   ELSEIF tk=K_PGDN
      // Page Up: se for consulta carrega registro anterior.
      IF vmodo#4
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
      AADD(mItem,{SPACE(2),SPACE(5),SPACE(40),0,0,0})
      // Atualiza as linhas de controle de ediá∆o na tela.
      IF vt>0
         --vt
      ELSE
         IF lf>1 .AND. lf<(22-vli)
            --lf
         ENDIF
      ENDIF
      // Reapresenta os itens, eliminando o que foi deletado.
      MostraItTurma(1,(22-vli),vcn)
   ELSEIF tk=K_F3  // Imprime
      IF vmodo#4 // Se o modo for diferente de Consulta volta ao inicio
         LOOP
      ENDIF
      // ImprTurma()
      Mensagem("Rotina a implementar")
      LOOP
   ELSEIF tk=K_F8
      IF vmodo>2 // Se o modo for Exclus∆o ou Consulta volta ao inicio
         LOOP
      ENDIF
      EditaTurma()
   ELSEIF tk=K_ESC
      IF vmodo=4 // Se o modo for consulta volta ao browse
         EXIT
      ENDIF
      // Foi pressionada a tecla <Esc>: finaliza a ediá∆o dos itens.
      @ 24,00 CLEAR
      Aviso(24,"Grava os dados da Turma")
      IF Confirme()
         // Atualiza, gravando as vari†veis auxiares no registro do arquivo.
         GravaTurma(vmodo)
      ELSE
         EXIT
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
PROCEDURE ExcluiTurma()
**************************************************************************
IF !Exclui() // se n∆o exclui
   RETURN    // retorna
ENDIF
// ITENS
SELECT Item
SET ORDER TO 1
GO TOP
SEEK vcodigo
DO WHILE Item->codigo=vcodigo .AND. !EOF()
   IF Bloqreg(10)
      DELETE // Deleta os itens.
      UNLOCK
   ELSE
      Mensagem("O Registro N∆o Est† Dispon°vel !",3,1)
   ENDIF
   SKIP
ENDDO
// CABEÄALHO
SELECT Turma
IF Bloqreg(10)
   DELETE // Deleta o Cabeáalho.
   UNLOCK
ELSE
   Mensagem("O Registro N∆o Est† Dispon°vel !",3,1)
ENDIF
RETURN

********************************************************************************
PROCEDURE TransfTurma()
// Transfere os dados do arquivo para as vari†veis auxiliares.
********************************************************************************
vcodigo    :=Turma->codigo
vprofessor :=Turma->professor
vdisciplina:=Turma->disciplina
vsemestre  :=Turma->semestre
RETURN

**************************************************************************
PROCEDURE TransVetTurma()
// Transfere os itens do arquivo de dados para os vetores.
***********************************************************
LOCAL k:=1,areatrab:=SELECT()
SELECT Item
GO TOP
SEEK vcodigo
IF FOUND()
   DO WHILE Item->codigo=vcodigo .AND. k<=LEN(mItem) .AND. !EOF()
      mItem[k,1]:=STRZERO(k,2)   // item
      mItem[k,2]:=Item->aluno    // matricula do aluno
      mItem[k,3]:=Procura("Aluno",1,Item->aluno,"nome") // nome do aluno
      mItem[k,4]:=Item->nota1    // nota 1
      mItem[k,5]:=Item->nota2    // nota 2
      mItem[k,6]:=Item->notaf    // nota final
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
PROCEDURE GravaTurma(pmodo)
// pmodo: 1-Inclus∆o, 2-Alteraá∆o
// Grava registros nos arquivos de Cabeáalho e Itens
******************************************************************
LOCAL i
@ 24,00 CLEAR
SETCOLOR(vcp)
Aviso(24,"Atualizando Registros. Aguarde..")
SETCOLOR(vcn)
// CABEÄALHO
SELECT Turma
IF pmodo=1  // Se for inclus∆o inclui novo registro
   GO BOTTOM
   vcodigo:=STRZERO(VAL(Turma->codigo)+1,5)
   IF Adireg(10)
      Turma->codigo :=vcodigo
      UNLOCK
   ELSE
      Mensagem("Erro de Rede, Inclus∆o N∆o Efetuada!",3,1)
   ENDIF
ENDIF
IF Bloqreg(10)
   Turma->professor :=vprofessor
   Turma->disciplina:=vdisciplina
   Turma->semestre  :=vsemestre
   UNLOCK
ELSE
   Mensagem("Erro de Rede, Atualizaá∆o N∆o Efetuada!",3,1)
ENDIF
// ITENS
SELECT Item
SET ORDER TO 1 // codigo
GO TOP
IF pmodo=2 // Se for Alteraá∆o
   SEEK vcodigo
   IF FOUND()
      DO WHILE Item->codigo=vcodigo .AND. !EOF()
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
i:=1
DO WHILE i <= LEN(mItem)   // Inclui os itens
   IF Adireg(10)
      Item->codigo:=vcodigo    // codigo da turma
      Item->aluno :=mItem[i,2] // matricula do aluno
      Item->nota1 :=mItem[i,4] // nota 1
      Item->nota2 :=mItem[i,5] // nota 2
      Item->notaf :=mItem[i,6] // nota final
      UNLOCK
   ELSE
      Mensagem("Erro de Rede. Inclus∆o N∆o Efetuada !",3,1)
   ENDIF
   i++
ENDDO
SELECT Turma
RETURN

