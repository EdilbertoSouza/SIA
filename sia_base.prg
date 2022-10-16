*******************************************************************************
/* Programa: SIA_BASE.PRG
   Fun‡Æo..: Manuten‡Æo da Estrutura de Dados do Sistema.
   Sistema.: SIA-Sistema de Informa‡äes Academicas
   Autor...: Edilberto L. Souza e Grazielly Moura
*/
*******************************************************************************
// Arquivos-cabe‡alho.
#include "SIA.CH"

********************************************************************************
FUNCTION CriaBase()
// Objetivo: Criar a Base de dados do sistema
// Sintaxe.: CriaBase(<pdir>) --> lSucesso (.T. ou .F.)
********************************************************************************
LOCAL mArqs, mStru, cArq
mArqs:={;
{"Professores.DBF"},;
{"Alunos.DBF"},;
{"Disciplinas.DBF"},;
{"Turmas.DBF"},;
{"ItensTurma.DBF"}}
SETCOLOR(vcp)
@ 24,01 SAY PADC("Criando Automaticamente a Base de Dados. Aguarde ...",78)
SETCOLOR(vcn)
FOR i:=1 TO LEN(mArqs)
   cArq := mArqs[i,1]
   IF !FILE(cDirBase+cArq)
      @ 24,65 SAY PADL(cArq, 13)
      mStru:=StruBase(cArq)
      DBCREATE(cDirBase+cArq, mStru)
   ENDIF
NEXT
Mensagem("Base de Dados Criada com Sucesso !",3,2)
RETURN .T.

********************************************************************************
PROCEDURE StruBase(parq)
// Objetivo: Retorna a estrutura de dados do sistema conforme
//           arquivo passado como parƒmetro
// Sintaxe.: StruVer( <parq> ) --> mStru
********************************************************************************
LOCAL mStru
// Arquivos de cadastro
IF parq="Professores.DBF"
   mStru:={;
   {"MATRICULA" ,"C", 5,0},;
   {"NOME"      ,"C", 40,0}}
ENDIF
IF parq="Alunos.DBF"
   mStru:={;
   {"MATRICULA" ,"C", 5,0},;
   {"NOME"      ,"C", 40,0}}
ENDIF
IF parq="Disciplinas.DBF"
   mStru:={;
   {"CODIGO"    ,"C", 5,0},;
   {"NOME"      ,"C", 40,0}}
ENDIF
IF parq="Turmas.DBF"
   mStru:={;
   {"CODIGO"    ,"C", 5,0},;
   {"PROFESSOR" ,"C", 5,0},;
   {"DISCIPLINA","C", 5,0},;
   {"SEMESTRE"  ,"C", 5,0}}
ENDIF
IF parq="ItensTurma.DBF"
   mStru:={;
   {"CODIGO"    ,"C", 5,0},;
   {"ALUNO"     ,"C", 5,0},;
   {"NOTA1"     ,"N", 5,2},;
   {"NOTA2"     ,"N", 5,2},;
   {"NOTAF"     ,"N", 5,2}}
ENDIF
RETURN mStru

********************************************************************************
PROCEDURE Indexa(ComMenu)
// Objetivo: Recria os indices dos arquivos de dados e, caso o usu rio
//           solicite, exclui os registros deletados atraves do comando PACK.
********************************************************************************
LOCAL mOpcoes:={},marqs:={}
// Atualiza a linha de status.
Sinal("ARQUIVOS","INDEXA€ÇO")
Abrejan(2)
mOpcoes:={{" ","01","Cadastros"}}
// Verifica se chama menu para escolha ou se reorganiza tudo
IF ComMenu
   mOpcoes:=BrowseMenu(05,10,15,70,mOpcoes,"OP€åES PARA REORGANIZAR")
   IF Mascan(mOpcoes,1,"*") = 0
      RETURN
   ENDIF
ELSE
   FOR i=1 TO LEN(mOpcoes)
      mOpcoes[i,1]:="*"
   NEXT
ENDIF
// A 1¦ op‡Æo vale pra todos os m¢dulos
IF mOpcoes[1,1]="*"  // 01-Cadastros
   marqs:={;
   {cDirBase+"Professores.DBF", "Professores", {{"Matricula","matricula"},{"Nome","nome"}}},;
   {cDirBase+"Alunos.DBF"     , "Alunos"     , {{"Matricula","matricula"},{"Nome","nome"}}},;
   {cDirBase+"Disciplinas.DBF", "Disciplinas", {{"C¢digo","codigo"},{"Nome","nome"}}},;
   {cDirBase+"Turmas.DBF"     , "Turmas"     , {{"C¢digo","codigo"},{"Professor","professor"},{"Disciplina","disciplina"},{"Semestre","semestre"}}},;
   {cDirBase+"ItensTurma.DBF" , "ItensTurma" , {{"C¢digo","codigo"}}}}
ENDIF
IndexaArqs(marqs)
RETURN

****************************************************************************
FUNCTION IndexaArqs(matriz)
/* Objetivo..: Tenta reorganizar uma lista de arquivos definidos numa matriz
   Parametros: Matriz - nome da matriz com a lista de Arquivos .DBF
               Matriz = {{Dir+Arq, Desc.Arq, {{Descri‡Æo Chave, Chave}}}}
   Exemplo: {{dircad+"EC_LANPA.DBF","Lan‡amentos Padräes",;
             {{"C¢digo","codigo"},{"Hist¢rico","histor"}}}}
Criado por Edilberto */
****************************************************************************
LOCAL totarqs,indices,totinds,tam,ind,i,j
SETCOLOR(vca)
Aviso(08,"Reorganiza‡Æo dos Arquivos do Sistema")
SETCOLOR(vcp)
Aviso(10,"Aguarde")
SETCOLOR(vcn)
totarqs:=LEN(matriz)
FOR i:=1 TO totarqs
   IF !Abrearq(matriz[i,1],"Arq",.T.,10)
      Mensagem("O Arquivo de "+matriz[i,2]+" NÆo Est  Dispon¡vel !",5,1)
      Aviso(24,"Deseja Continuar a Reorganiza‡Æo")
      IF !Confirme()
         RETURN
      ENDIF
   ENDIF
   SETCOLOR(vca)
   Aviso(12,"Cadastro de "+matriz[i,2])
   SETCOLOR(vcn)
   PACK
   indices:=matriz[i,3]
   totinds:=LEN(indices)
   FOR j:=1 TO totinds
      IF j < 10
         tam:=LEN(matriz[i,1])-5
         ind:=LEFT(matriz[i,1],tam)+STR(j,1)+".CDX"
      ELSE
         tam:=LEN(matriz[i,1])-6
         ind:=LEFT(matriz[i,1],tam)+STR(j,2)+".CDX"
      ENDIF
      Aviso(14,"Reorganizando o Arquivo por "+indices[j,1])
      INDEX ON &(indices[j,2]) TO (ind) EVAL Andamento_Indexacao() EVERY 100
      @ 14,01 CLEAR TO 17,77
   NEXT
   @ 12,01 SAY SPACE(78)
   SET ORDER TO 1
   CLOSE DATABASE
NEXT
Beep(2)
SETCOLOR(vcp)
Aviso(10,"  Arquivos  Reorganizados !  ")
INKEY(5)
SETCOLOR(vcn)
RETURN

*******************************************************************************
PROCEDURE Andamento_Indexacao()
// Objetivo: Apresenta andamento da indexa‡Æo
*******************************************************************************
LOCAL nDone:=((RECNO()/LASTREC())*100)/3.3
@ 16,23 SAY REPLICATE(CHR(177),nDone)
@ 17,23 SAY REPLICATE("-",30)
@ 17,35 SAY " "+STR((RECNO()/LASTREC())*100,3)+"% "
RETURN .T.

