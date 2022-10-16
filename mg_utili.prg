*******************************************************************************
/* Programa: MG_UTILI.PRG
   Funá∆o..: M¢dulo dos Utilit†rios Compartilhados do Sistema.
   Sistema.: SIG-Sistema de Informaá‰es Gerenciais
   Autor...: Edilberto L.Souza */
*******************************************************************************
// Arquivos-cabeáalho.
#include "SIG.CH"

********************************************************************************
PROCEDURE Indexa(ComMenu)
// Objetivo: Recria os indices dos arquivos de dados e, caso o usu†rio
//           solicite, exclui os registros deletados atraves do comando PACK.
********************************************************************************
LOCAL mOpcoes:={},marqs:={}
// Atualiza a linha de status.
Sinal("ARQUIVOS","INDEXAÄ«O")
Abrejan(2)
// A 1¶ opá∆o vale pra todos os m¢dulos
mOpcoes:={{" ","01","Cadastros"}}
// Personaliza as opá‰es por m¢dulo
IF modulo="FC"
   AADD(mOpcoes,{" ","02","Movimento de Notas Fiscais"})
   AADD(mOpcoes,{" ","03","Movimento de Cupons Fiscais"})
   AADD(mOpcoes,{" ","04","Movimento de Compras"})
   AADD(mOpcoes,{" ","05","Movimento de Estoque"})
ELSEIF modulo="WM"
   AADD(mOpcoes,{" ","02","Movimento de Contas a Receber"})
   AADD(mOpcoes,{" ","03","Movimento de Contas Recebidas"})
   AADD(mOpcoes,{" ","04","Movimento de Contas a Pagar"})
   AADD(mOpcoes,{" ","05","Movimento de Contas Pagas"})
   AADD(mOpcoes,{" ","06","Movimento de Retiradas e Contas dos S¢cios"})
   AADD(mOpcoes,{" ","07","Movimento de Conciliaá∆o Banc†ria"})
ELSEIF modulo="EC"
   AADD(mOpcoes,{" ","02","Movimento Fiscal de Sa°da"})
   AADD(mOpcoes,{" ","03","Movimento Fiscal de Entrada"})
   AADD(mOpcoes,{" ","04","Movimento de Lanáamentos Cont†beis"})
ELSEIF modulo="TODOS"
   AADD(mOpcoes,{" ","02","Movimento de Notas Fiscais"})
   AADD(mOpcoes,{" ","03","Movimento de Cupons Fiscais"})
   AADD(mOpcoes,{" ","04","Movimento de Compras"})
   AADD(mOpcoes,{" ","05","Movimento de Estoque"})
   AADD(mOpcoes,{" ","06","Movimento de Contas a Receber"})
   AADD(mOpcoes,{" ","07","Movimento de Contas Recebidas"})
   AADD(mOpcoes,{" ","08","Movimento de Contas a Pagar"})
   AADD(mOpcoes,{" ","09","Movimento de Contas Pagas"})
   AADD(mOpcoes,{" ","10","Movimento de Retiradas e Contas dos S¢cios"})
   AADD(mOpcoes,{" ","11","Movimento de Conciliaá∆o Banc†ria"})
   AADD(mOpcoes,{" ","12","Movimento Fiscal de Sa°da"})
   AADD(mOpcoes,{" ","13","Movimento Fiscal de Entrada"})
   AADD(mOpcoes,{" ","14","Movimento de Lanáamentos Cont†beis"})
ENDIF
// Verifica se chama menu para escolha ou se reorganiza tudo
IF ComMenu
   mOpcoes:=BrowseMenu(05,10,15,70,mOpcoes,"OPÄÂES PARA REORGANIZAR")
   IF Mascan(mOpcoes,1,"*") = 0
      RETURN
   ENDIF
ELSE
   FOR i=1 TO LEN(mOpcoes)
      mOpcoes[i,1]:="*"
   NEXT
ENDIF
// A 1¶ opá∆o vale pra todos os m¢dulos
IF mOpcoes[1,1]="*"  // 01-Cadastros
   marqs:={;
   {dircad+"EC_MUNIC.DBF","Munic°pios",{{"C¢digo","uf+codmuni"},{"Nome","uf+munnomex"}}},;
   {dircad+"WM_LOJAS.DBF","Lojas",{{"C¢digo","codi"},{"Nome","nome"}}},;
   {dircad+"FC_PRODU.DBF","Produtos FC",{{"C¢digo","codpro"},{"Nome","prod"},{"C¢digo Auxiliar","codaux"}}},;
   {dircad+"FC_COMPO.DBF","Composiá∆o de Produtos",{{"Produto","codpro"}}},;
   {dircad+"FC_NATUR.DBF","Cfops",{{"CFOP","cfop"},{"Nome","nome"}}},;
   {dircad+"FC_TRANS.DBF","Transportadoras",{{"C¢digo","codtp"},{"Nome","nome"},{"CIC","cic"}}},;
   {dircad+"FC_FORNE.DBF","Fornecedores",{{"C¢digo","codfor"},{"Nome","nome"},{"CIC","cic"}}},;
   {dircad+"FC_SERVI.DBF","Serviáos",{{"C¢digo","codser"},{"Nome","serv"}}},;
   {dirmov+"FC_ITCUS.DBF","Itens de Custos",{{"C¢digo","codpro+ite"}}},;
   {dircad+"FC_GRUPO.DBF","Grupos de produtos",{{"C¢digo","codi"},{"Nome","nome"}}},;
   {dircad+"FC_LOCAL.DBF","Tlo",{{"C¢digo","codi"},{"Nome","nome"}}},;
   {dircad+"FC_USUAR.DBF","Usu",{{"C¢digo","codop"},{"Nome","nome"}}},;
   {dircad+"WM_OPERA.DBF","Operaá‰es",{{"C¢digo","codi"},{"Nome","nome"}}},;
   {dircad+"WM_DOLAR.DBF","D¢lar",{{"Data","data"}}},;
   {dircad+"WM_INDIC.DBF","Indice de Correá∆o",{{"Data","data"}}},;
   {dircad+"WM_BANCO.DBF","Bancos",{{"C¢digo","codi"},{"Nome","nome"}}},;
   {dircad+"WM_TIPAG.DBF","Tipos de Pagamento",{{"C¢digo","codi"},{"Nome","nome"}}},;
   {dircad+"WM_AGCOB.DBF","Agentes Cobradores",{{"C¢digo","codi"},{"Nome","nome"}}},;
   {dircad+"WM_TIPTR.DBF","Tipos de Transaá‰es",{{"C¢digo","codi"},{"Nome","nome"}}},;
   {dircad+"WM_LOJAS.DBF","Lojas",{{"C¢digo","codi"},{"Nome","nome"}}},;
   {dircad+"WM_EMPRE.DBF","Empresas",{{"C¢digo","codi"},{"Nome","nome"}}},;
   {dircad+"WM_SOCIO.DBF","S¢cios",{{"C¢digo","codi"},{"Nome do S¢cio","nome"}}},;
   {dircad+"WM_USUAR.DBF","Usuarios",{{"C¢digo","codop"},{"Nome","nome"}}},;
   {dircad+"EC_LANPA.DBF","Lanáamentos Padr‰es",{{"C¢digo","codigo"},{"Hist¢rico","histor"}}},;
   {dircad+"EC_USUAR.DBF","Usuarios",{{"C¢digo","codop"},{"Nome","nome"}}}}
   //{dircad+"EC_PARTI.DBF","Participantes",{{"C¢digo","codi"},{"CpfCnpj","cic"}}},;
ENDIF
// Personaliza as opá‰es por m¢dulo
IF modulo="FC"
   // Faturamento, Compras e Estoque
   IF mOpcoes[2,1]="*"  // 02-Notas Fiscais
      AADD(marqs,{dirmov+"FC_NOTAS.DBF","Notas Fiscais",{{"Loja+Serie+N£mero da NF","loja+serie+nunf"},{"Nome do Cliente","cli"},{"Data de Emiss∆o","data"},{"Cliente+N£mero NF","codcli+nunf"}}})
      AADD(marqs,{dirmov+"FC_ITNFS.DBF","Itens de NFs",{{"Loja+Serie+N£mero da NF","loja+serie+nunf"},{"N£mero do Item","loja+serie+nunf+ite"},{"C¢digo do Produto","codpro"},{"Data de Emiss∆o","data"}}})
      AADD(marqs,{dirmov+"FC_DUPNF.DBF","Duplicatas",{{"N£mero da NF","loja+serie+nunf"}}})
      AADD(marqs,{dirmov+"FC_NFTRN.DBF","Transporte",{{"N£mero da NF","loja+serie+nunf"}}})
      AADD(marqs,{dirmov+"FC_NFPED.DBF","Pedidos Importados",{{"N£mero da NF","loja+serie+nunf"},{"N£mero do Pedido","nupd"}}})
      AADD(marqs,{dirmov+"FC_REFNF.DBF","Referidos na NF",{{"N£mero da NF","loja+serie+nunf"}}})
      AADD(marqs,{dirmov+"FC_NUSEG.DBF","N£meros de Seguranáa",{{"Loja","loja+serie+nunfi"}}})
   ENDIF
   IF mOpcoes[3,1]="*"  // 03-Cupons Fiscais
      AADD(marqs,{dirmov+"FC_CUPOM.DBF","Cupons Fiscais",{{"N£mero","nucf"},{"Nome do Cliente","cli"},{"Data de Emiss∆o","data"}}})
      AADD(marqs,{dirmov+"FC_ITCFS.DBF","Itens de Cupons",{{"N£mero","nucf"},{"N£mero do Item","nucf+ite"},{"C¢digo do Produto","codpro"},{"Data","data"}}})
      AADD(marqs,{dirmov+"FC_CFPED.DBF","Pedidos Importados",{{"N£mero do CF","nucf"},{"N£mero do Pedido","nupd"}}})
   ENDIF
   IF mOpcoes[4,1]="*"  // 04-Pedidos de Compras
      AADD(marqs,{dirmov+"FC_PEDID.DBF","Pedidos de Compras",{{"N£mero","nupd"},{"Nome do Fornecedor","nome"},{"Data de Emiss∆o","data"}}})
      AADD(marqs,{dirmov+"FC_ITPED.DBF","Itens de Pedidos",{{"N£mero do Pedido","nupd"},{"N£mero do Item","nupd+ite"},{"C¢digo do Produto","codpro"},{"Data","data"}}})
   ENDIF
   IF mOpcoes[5,1]="*"  // 05-Estoque
      AADD(marqs,{dirmov+"FC_ENTRA.DBF","Entradas no Estoque",{{"N£mero de Ordem","ordem"},{"Nome do Fornecedor","nome"},{"Data de Entrada","data"},{"Fornecedor+Documento","codfor+docto"}}})
      AADD(marqs,{dirmov+"FC_ITENT.DBF","Itens de Entrada",{{"N£mero de Ordem","ordem"},{"N£mero do Item","ordem+ite"},{"C¢digo do Produto","codpro"},{"Data de Entrada","data"}}})
      AADD(marqs,{dirmov+"FC_DUPEN.DBF","Duplicatas",{{"N£mero de Ordem","ordem"}}})
      AADD(marqs,{dirmov+"FC_ENPED.DBF","Pedidos Importados",{{"N£mero de Ordem","ordem"},{"N£mero do Pedido de Compra","nupd"}}})
      AADD(marqs,{dirmov+"FC_REFEN.DBF","Referidos na Entrada",{{"N£mero de Ordem","ordem"}}})
      AADD(marqs,{dirmov+"FC_INVEN.DBF","Invent†rio",{{"Loja, Mes e Produto","loja+anomes+codpro"},{"Produto","codpro"}}})
      AADD(marqs,{dirmov+"FC_SALDO.DBF","Saldo de Estoque",{{"Produto, Local e AnoMes","codpro+codloc"}}})
      AADD(marqs,{dirmov+"FC_SALGE.DBF","Saldo de Estoque",{{"Produto e Local","codpro+codloc"}}})
      AADD(marqs,{dirmov+"FC_REQUI.DBF","Requisiá∆o",{{"N£mero de Ordem","ordem"},{"Local, Data e Status","codloc+DTOS(data)+status"},{"Local, Data e Documento","codloc+DTOS(data)+docto"},{"Documento","docto"},{"Status, Documento e Ordem","status+docto+ordem"}}})
      AADD(marqs,{dirmov+"FC_ITREQ.DBF","Itens de Requisiá∆o",{{"N£mero de Ordem","ordem"},{"N£mero do Documento","docto"}}})
   ENDIF
ELSEIF modulo="WM"
   // Financeiro
   IF mOpcoes[2,1]="*"  // 02-Contas a Receber
      AADD(marqs,{dirmov+"WM_CTREC.DBF","Contas a Receber",;
      {{"Ordem","ordem"},;
      {"Documento","docto"},;
      {"Loja","loja+docto"},;
      {"Vencimento","DTOS(venc)+docto"},;
      {"Nome do Devedor","nome"},;
      {"Emiss∆o","emis"},;
      {"Valor","valor"},;
      {"CIC","cic"},;
      {"C¢digo do Cliente","codcli+DTOS(venc)"},;
      {"Nß da NF","loja+serie+nunf"}}})
   ENDIF
   IF mOpcoes[3,1]="*"  // 03-Contas Recebidas
      AADD(marqs,{dirmov+"WM_RECEB.DBF","Contas Recebidas",{{"Nß de Ordem","ordem"},{"Documento","docto"},{"Loja","loja+docto"},{"Vencimento","DTOS(venc)+docto"},{"Nome do Devedor","nome"},{"Data de Emiss∆o","emis"},{"Valor","valor"},{"CIC","cic"},{"C¢digo do Cliente","codcli+DTOS(venc)"},{"Data de Recebimento","datpg"},{"Ordem de CR","ordemcr"}}})
   ENDIF
   IF mOpcoes[4,1]="*"  // 04-Contas a Pagar
      AADD(marqs,{dirmov+"WM_CTPAG.DBF","Contas a Pagar",{{"Nß de Ordem","ordem"},{"Documento","docto"},{"Loja","loja+docto"},{"Data de Vencimento","DTOS(venc)+docto"},{"Nome do Credor","nome"},{"Data de Emiss∆o","emis"},{"Valor","valor"},{"CIC","cic"},{"C¢digo do Fornecedor","codfor+DTOS(venc)"},{"Nß de Ordem de Entrada","ordemen"}}})
   ENDIF
   IF mOpcoes[5,1]="*"  // 05-Contas Pagas
      AADD(marqs,{dirmov+"WM_PAGAS.DBF","Contas Pagas",{{"Nß de Ordem","ordem"},{"Documento","docto"},{"Loja","loja"},{"Data de Vencimento","DTOS(venc)+docto"},{"Nome do Credor","nome"},{"Data de Emiss∆o","emis"},{"Nß do Cheque","ctb+cheque"},{"CIC","cic"},{"C¢digo do Fornecedor","codfor+DTOS(venc)"},{"Data de Pagamento","datpg"},{"Ordem de CP","ordemcp"},{"Valor","valor"}}})
   ENDIF
   IF mOpcoes[6,1]="*"  // 06-Retiradas e Contas dos S¢cios
      AADD(marqs,{dircad+"WM_RETIR.DBF","Retiradas e Contas Ö Pagar dos S¢cios",{{"Nß de Ordem","ordem"},{"Documento","docto"},{"C¢digo do S¢cio","codsoc+DTOS(venc)"},{"Descriá∆o do Pagamento","desc"},{"Data de Vencimento","DTOS(venc)+docto"},{"Data do Pagamento","DTOS(datpg)"},{"Valor","valor"}}})
      AADD(marqs,{dircad+"WM_RETPG.DBF","Retiradas e Contas Pagas dos S¢cios",{{"Nß de Ordem","ordem"},{"Documento","docto"},{"C¢digo do S¢cio","codsoc+DTOS(venc)"},{"Descriá∆o do Pagamento","desc"},{"Data de Vencimento","DTOS(venc)+docto"},{"Data do Pagamento","DTOS(datpg)"},{"Valor","valor"}}})
   ENDIF
   IF mOpcoes[7,1]="*"  // 07-Conciliaá∆o
      AADD(marqs,{dirmov+"WM_CTBAN.DBF","Contas Banc†rias",{{"Ctb","ctb"},{"Nome do Correntista","nome"},{"Banco+Agencia+Conta","banco+agenc+conta"}}})
      AADD(marqs,{dirmov+"WM_SALDO.DBF","Saldos Banc†rios",{{"Ordem","ordem"},{"Conta","ctb+DTOS(data)"},{"Data","data"}}})
      AADD(marqs,{dirmov+"WM_MBANC.DBF","Movimento Banc†rio",{{"Ordem","ordem"},{"Documento","docto"},{"Conta+Data de Pagamento","ctb+DTOS(datpg)"},{"Tipo de Transaá∆o","tiptr"},{"Conta+Data de Vencimento","ctb+DTOS(datext)"},{"Ordem do Contas a Receber","ordemrb"},{"Ordem do Contas a Pagar","ordempg"},{"Conta+Documento","ctb+docto"},{"Conta+Emiss∆o","ctb+DTOS(emis)"}}})
   ENDIF
ELSEIF modulo="EC"
   // Escrita Fiscal e Contabilidade
   IF mOpcoes[2,1]="*"  // 02-Movimento Fiscal de Sa°da
      AADD(marqs,{dirmov+"EC_ENCER.DBF","Encerramento de Ped°odos de Trabalho",{{"Ano/Mes","anomes"}}})
      AADD(marqs,{dirmov+"EC_RAICM.DBF","Registros de Apuraá∆o de ICMS",{{"Loja+Per°odo","loja+anomes"}}})
      AADD(marqs,{dirmov+"EC_REIPI.DBF","Registros de Apuraá∆o de IPI",{{"Loja+Per°odo","loja+anomesd"}}})
      AADD(marqs,{dirmov+"EC_SAIDA.DBF","Movimento Fiscal de Sa°da",{{"Ordem","ordem"},{"N£mero da NF","nunf"},{"Loja+Emiss∆o","loja+DTOS(datemi)"},{"Loja+Serie+NF","loja+serie+nunf"},{"Loja+Serie+Emiss∆o","loja+serie+DTOS(datemi)"},{"Cliente+NF","codcli+nunf"},{"Valor Cont†bil","vcontb"},{"Loja+Cfop+Emiss∆o","loja+cfop+DTOS(datemi)"}}})
   ENDIF
   IF mOpcoes[3,1]="*"  // 03-Movimento Fiscal de Entrada
      AADD(marqs,{dirmov+"EC_ENTRA.DBF","Movimento Fiscal de Entrada",{{"Ordem","ordem"},{"N£mero da NF","nunf"},{"Loja+Entrada","loja+DTOS(datent)"},{"Loja+Serie+NF","loja+serie+nunf"},{"Ordem de Entrada no Estoque","ordemen"},{"Fornecedor+NF","codfor+nunf"},{"Valor Cont†bil","vcontb"},{"Loja+Cfop+Entrada","loja+cfop+DTOS(datent)"}}})
   ENDIF
   IF mOpcoes[4,1]="*"  // 04-Movimento de Lanáamentos Cont†beis
      AADD(marqs,{dirmov+"EC_PC"+vcano+"E.DBF","Planos de Contas",{{"Conta","SUBSTR(codcta,4,12)"},{"T°tulo","titcta"}}})
      AADD(marqs,{dirmov+"EC_LA"+vcano+"E.DBF","Lanáamentos Cont†beis",{{"Conta de DÇbito+Data","ctadeb+locdeb+data"},{"Conta de CrÇdito+Data","ctacre+loccre+data"},{"Ordem","ordem"},{"Valor","valor"},{"Data+ordem","data+ordem"},{"Documento","docto"}}})
      AADD(marqs,{dirmov+"EC_LOTEL.DBF","Lotes Importados",{{"Conta de DÇbito+Data","ctadeb+locdeb+data"},{"Conta de CrÇdito+Data","ctacre+loccre+data"},{"Ordem","ordem"},{"Valor","valor"},{"Data+ordem","data+ordem"},{"Documento","docto"}}})
   ENDIF
ELSEIF modulo="TODOS"
   // Todos os M¢dulos:
   // Faturamento, Compras, Estoque, Financeiro,
   // Escrita Fiscal e Contabilidade
   IF mOpcoes[2,1]="*"  // 02-Notas Fiscais
      AADD(marqs,{dirmov+"FC_NOTAS.DBF","Notas Fiscais",{{"Loja+Serie+N£mero da NF","loja+serie+nunf"},{"Nome do Cliente","cli"},{"Data de Emiss∆o","data"},{"Cliente+N£mero NF","codcli+nunf"}}})
      AADD(marqs,{dirmov+"FC_ITNFS.DBF","Itens de NFs",{{"Loja+Serie+N£mero da NF","loja+serie+nunf"},{"N£mero do Item","loja+serie+nunf+ite"},{"C¢digo do Produto","codpro"},{"Data de Emiss∆o","data"}}})
      AADD(marqs,{dirmov+"FC_DUPNF.DBF","Duplicatas",{{"N£mero da NF","loja+serie+nunf"}}})
      AADD(marqs,{dirmov+"FC_NFTRN.DBF","Transporte",{{"N£mero da NF","loja+serie+nunf"}}})
      AADD(marqs,{dirmov+"FC_NFPED.DBF","Pedidos Importados",{{"N£mero da NF","loja+serie+nunf"},{"N£mero do Pedido","nupd"}}})
      AADD(marqs,{dirmov+"FC_REFNF.DBF","Referidos na NF",{{"N£mero da NF","loja+serie+nunf"}}})
      AADD(marqs,{dirmov+"FC_NUSEG.DBF","N£meros de Seguranáa",{{"Loja","loja+serie+nunfi"}}})
   ENDIF
   IF mOpcoes[3,1]="*"  // 03-Cupons Fiscais
      AADD(marqs,{dirmov+"FC_CUPOM.DBF","Cupons Fiscais",{{"N£mero","nucf"},{"Nome do Cliente","cli"},{"Data de Emiss∆o","data"}}})
      AADD(marqs,{dirmov+"FC_ITCFS.DBF","Itens de Cupons",{{"N£mero","nucf"},{"Pelo N£mero do Item","nucf+ite"},{"Pelo C¢digo do Produto","codpro"},{"Pela Data","data"}}})
      AADD(marqs,{dirmov+"FC_CFPED.DBF","Pedidos Importados",{{"Pelo N£mero do CF","nucf"},{"Pelo N£mero do Pedido","nupd"}}})
   ENDIF
   IF mOpcoes[4,1]="*"  // 04-Pedidos de Compras
      AADD(marqs,{dirmov+"FC_PEDID.DBF","Pedidos de Compras",{{"N£mero","nupd"},{"Nome do Fornecedor","nome"},{"Data de Emiss∆o","data"}}})
      AADD(marqs,{dirmov+"FC_ITPED.DBF","Itens de Pedidos",{{"N£mero do Pedido","nupd"},{"N£mero do Item","nupd+ite"},{"C¢digo do Produto","codpro"},{"Data","data"}}})
   ENDIF
   IF mOpcoes[5,1]="*"  // 05-Estoque
      AADD(marqs,{dirmov+"FC_ENTRA.DBF","Entradas no Estoque",{{"N£mero de Ordem","ordem"},{"C¢digo do Fonecedor+Documento","nome"},{"Data de Entrada","data"},{"Estado+Nome","codfor+docto"}}})
      AADD(marqs,{dirmov+"FC_ITENT.DBF","Itens de Entrada",{{"N£mero de Ordem","ordem"},{"N£mero do Item","ordem+ite"},{"C¢digo do Produto","codpro"},{"Data de Entrada","data"}}})
      AADD(marqs,{dirmov+"FC_DUPEN.DBF","Duplicatas",{{"N£mero de Ordem","ordem"}}})
      AADD(marqs,{dirmov+"FC_ENPED.DBF","Pedidos Importados",{{"N£mero de Ordem","ordem"},{"N£mero do Pedido de Compra","nupd"}}})
      AADD(marqs,{dirmov+"FC_REFEN.DBF","Referidos na Entrada",{{"N£mero de Ordem","ordem"}}})
      AADD(marqs,{dirmov+"FC_INVEN.DBF","Invent†rio",{{"Loja, Mes e Produto","loja+anomes+codpro"},{"Produto","codpro"}}})
      AADD(marqs,{dirmov+"FC_SALDO.DBF","Saldo de Estoque",{{"Produto, Local e AnoMes","codpro+codloc"}}})
      AADD(marqs,{dirmov+"FC_SALGE.DBF","Saldo de Estoque",{{"Produto e Local","codpro+codloc"}}})
      AADD(marqs,{dirmov+"FC_REQUI.DBF","Requisiá∆o",{{"N£mero de Ordem","ordem"},{"Local, Data e Status","codloc+DTOS(data)+status"},{"Local, Data e Documento","codloc+DTOS(data)+docto"},{"Documento","docto"},{"Status, Documento e Ordem","status+docto+ordem"}}})
      AADD(marqs,{dirmov+"FC_ITREQ.DBF","Itens de Requisiá∆o",{{"N£mero de Ordem","ordem"},{"N£mero do Documento","docto"}}})
   ENDIF
   IF mOpcoes[6,1]="*"  // 06-Contas a Receber
      AADD(marqs,{dirmov+"WM_CTREC.DBF","Contas a Receber",{{"Ordem","ordem"},{"Documento","docto"},{"Loja","loja+docto"},{"Vencimento","DTOS(venc)+docto"},{"Nome do Devedor","nome"},{"Emiss∆o","emis"},{"Valor","valor"},{"CIC","cic"},{"C¢digo do Cliente","codcli+DTOS(venc)"},{"Nß da NF","loja+serie+nunf"}}})
   ENDIF
   IF mOpcoes[7,1]="*"  // 07-Contas Recebidas
      AADD(marqs,{dirmov+"WM_RECEB.DBF","Contas Recebidas",{{"Nß de Ordem","ordem"},{"Documento","docto"},{"Loja","loja+docto"},{"Vencimento","DTOS(venc)+docto"},{"Nome do Devedor","nome"},{"Data de Emiss∆o","emis"},{"Valor","valor"},{"CIC","cic"},{"C¢digo do Cliente","codcli+DTOS(venc)"},{"Data de Recebimento","datpg"},{"Ordem de CR","ordemcr"}}})
   ENDIF
   IF mOpcoes[8,1]="*"  // 08-Contas a Pagar
      AADD(marqs,{dirmov+"WM_CTPAG.DBF","Contas a Pagar",{{"Nß de Ordem","ordem"},{"Documento","docto"},{"Loja","loja+docto"},{"Data de Vencimento","DTOS(venc)+docto"},{"Nome do Credor","nome"},{"Data de Emiss∆o","emis"},{"Valor","valor"},{"CIC","cic"},{"C¢digo do Fornecedor","codfor+DTOS(venc)"},{"Nß de Ordem de Entrada","ordemen"}}})
   ENDIF
   IF mOpcoes[9,1]="*"  // 09-Contas Pagas
      AADD(marqs,{dirmov+"WM_PAGAS.DBF","Contas Pagas",{{"Nß de Ordem","ordem"},{"Documento","docto"},{"Loja","loja"},{"Data de Vencimento","DTOS(venc)+docto"},{"Nome do Credor","nome"},{"Data de Emiss∆o","emis"},{"Nß do Cheque","ctb+cheque"},{"CIC","cic"},{"C¢digo do Fornecedor","codfor+DTOS(venc)"},{"Data de Pagamento","datpg"},{"Ordem de CP","ordemcp"},{"Valor","valor"}}})
   ENDIF
   IF mOpcoes[10,1]="*"  // 10-Retiradas e Contas dos S¢cios
      AADD(marqs,{dircad+"WM_RETIR.DBF","Retiradas e Contas Ö Pagar dos S¢cios",{{"Nß de Ordem","ordem"},{"Documento","docto"},{"C¢digo do S¢cio","codsoc+DTOS(venc)"},{"Descriá∆o do Pagamento","desc"},{"Data de Vencimento","DTOS(venc)+docto"},{"Data do Pagamento","DTOS(datpg)"},{"Valor","valor"}}})
      AADD(marqs,{dircad+"WM_RETPG.DBF","Retiradas e Contas Pagas dos S¢cios",{{"Nß de Ordem","ordem"},{"Documento","docto"},{"C¢digo do S¢cio","codsoc+DTOS(venc)"},{"Descriá∆o do Pagamento","desc"},{"Data de Vencimento","DTOS(venc)+docto"},{"Data do Pagamento","DTOS(datpg)"},{"Valor","valor"}}})
   ENDIF
   IF mOpcoes[11,1]="*"  // 11-Conciliaá∆o
      AADD(marqs,{dirmov+"WM_CTBAN.DBF","Contas Banc†rias",{{"Ctb","ctb"},{"Nome do Correntista","nome"},{"Banco+Agencia+Conta","banco+agenc+conta"}}})
      AADD(marqs,{dirmov+"WM_SALDO.DBF","Saldos Banc†rios",{{"Ordem","ordem"},{"Conta","ctb+DTOS(data)"},{"Data","data"}}})
      AADD(marqs,{dirmov+"WM_MBANC.DBF","Movimento Banc†rio",{{"Ordem","ordem"},{"Documento","docto"},{"Conta+Data de Pagamento","ctb+DTOS(datpg)"},{"Tipo de Transaá∆o","tiptr"},{"Conta+Data de Vencimento","ctb+DTOS(datext)"},{"Ordem do Contas a Receber","ordemrb"},{"Ordem do Contas a Pagar","ordempg"},{"Conta+Documento","ctb+docto"},{"Conta+Emiss∆o","ctb+DTOS(emis)"}}})
   ENDIF
   IF mOpcoes[12,1]="*"  // 12-Movimento Fiscal de Sa°da
      AADD(marqs,{dirmov+"EC_ENCER.DBF","Encerramento de Ped°odos de Trabalho",{{"Ano/Mes","anomes"}}})
      AADD(marqs,{dirmov+"EC_RAICM.DBF","Registros de Apuraá∆o de ICMS",{{"Loja+Per°odo","loja+anomes"}}})
      AADD(marqs,{dirmov+"EC_REIPI.DBF","Registros de Apuraá∆o de IPI",{{"Loja+Per°odo","loja+anomesd"}}})
      AADD(marqs,{dirmov+"EC_SAIDA.DBF","Movimento Fiscal de Sa°da",{{"Ordem","ordem"},{"N£mero da NF","nunf"},{"Data de Emiss∆o","datemi"},{"Loja+Serie+N£mero da NF","loja+serie+nunf"},{"Loja+Serie+Emiss∆o","loja+serie+DTOS(datemi)"},{"Cliente+NF","codcli+nunf"},{"Valor Cont†bil","vcontb"},{"Loja+Cfop+Emiss∆o","loja+cfop+DTOS(datemi)"}}})
   ENDIF
   IF mOpcoes[13,1]="*"  // 13-Movimento Fiscal de Entrada
      AADD(marqs,{dirmov+"EC_ENTRA.DBF","Movimento Fiscal de Entrada",{{"Ordem","ordem"},{"N£mero da NF","nunf"},{"Data da Entrada","datent"},{"Loja+Serie+NF","loja+serie+nunf"},{"Ordem de Entrada no Estoque","ordemen"},{"Fornecedor+NF","codfor+nunf"},{"Valor Cont†bil","vcontb"},{"Loja+Cfop+Entrada","loja+cfop+DTOS(datent)"}}})
   ENDIF
   IF mOpcoes[14,1]="*"  // 14-Movimento de Lanáamentos Cont†beis
      AADD(marqs,{dirmov+"EC_PC"+vcano+"E.DBF","Planos de Contas",{{"Conta","SUBSTR(codcta,4,12)"},{"T°tulo","titcta"}}})
      AADD(marqs,{dirmov+"EC_LA"+vcano+"E.DBF","Lanáamentos Cont†beis",{{"Conta de DÇbito+Data","ctadeb+locdeb+data"},{"Conta de CrÇdito+Data","ctacre+loccre+data"},{"Ordem","ordem"},{"Valor","valor"},{"Data+ordem","data+ordem"},{"Documento","docto"}}})
      AADD(marqs,{dirmov+"EC_LOTEL.DBF","Lotes Importados",{{"Conta de DÇbito+Data","ctadeb+locdeb+data"},{"Conta de CrÇdito+Data","ctacre+loccre+data"},{"Ordem","ordem"},{"Valor","valor"},{"Data+ordem","data+ordem"},{"Documento","docto"}}})
   ENDIF
ENDIF
IndexaArqs(marqs)
RETURN

****************************************************************************
FUNCTION IndexaArqs(matriz)
/* Objetivo..: Tenta reorganizar uma lista de arquivos definidos numa matriz
   Parametros: Matriz - nome da matriz com a lista de Arquivos .DBF
               Matriz = {{Dir+Arq, Desc.Arq, {{Descriá∆o Chave, Chave}}}}
   Exemplo: {{dircad+"EC_LANPA.DBF","Lanáamentos Padr‰es",;
             {{"C¢digo","codigo"},{"Hist¢rico","histor"}}}}
Criado por Edilberto */
****************************************************************************
LOCAL totarqs,indices,totinds,tam,ind,i,j
SETCOLOR(vca)
Aviso(08,"Reorganizaá∆o dos Arquivos do Sistema")
SETCOLOR(vcp)
Aviso(10,"Aguarde")
SETCOLOR(vcn)
totarqs:=LEN(matriz)
FOR i:=1 TO totarqs
   IF !Abrearq(matriz[i,1],"Arq",.T.,10)
      Mensagem("O Arquivo de "+matriz[i,2]+" N∆o Est† Dispon°vel !",5,1)
      Aviso(24,"Deseja Continuar a Reorganizaá∆o")
      IF !Confirme()
         RETURN
      ENDIF
   ENDIF
   SETCOLOR(vca)
   Aviso(12,"Cadastro de "+matriz[i,2])
   SETCOLOR(vcn)
   IF RIGHT(matriz[i,1],12) # "EC_PC"+vcano+"E.DBF"
      PACK
   ENDIF
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
// Objetivo: Apresenta andamento da indexaá∆o
*******************************************************************************
LOCAL nDone:=((RECNO()/LASTREC())*100)/3.3
@ 16,23 SAY REPLICATE(CHR(177),nDone)
@ 17,23 SAY REPLICATE("-",30)
@ 17,35 SAY " "+STR((RECNO()/LASTREC())*100,3)+"% "
RETURN .T.

*******************************************************************************
PROCEDURE Backup()
*******************************************************************************
LOCAL vdrv,barq,band,vfiles
Sinal("BACK-UP","ARQUIVOS")
Abrejan(2)
SETCOLOR(vca)
Aviso(08,"Back-Up dos Arquivos do Sistema")
SETCOLOR(vcn)
DO WHILE .T.
   vdrv:="E:"+SPACE(20)
   SETCOLOR(vcn)
   //@ 08,05 SAY "Drive e diret¢rio no qual ser† feita a c¢pia:"
   @ 10,05 SAY "Local de Destino da C¢pia de Seguranáa:"
   @ 10,45 GET vdrv PICTURE "@!"
   Le()
   IF LASTKEY()==K_ESC
      EXIT
   ENDIF
   vdrv:=ALLTRIM(vdrv)
   IF !Confirme()
      LOOP
   ENDIF
   //Abrejan(2)
   @ 10,01 CLEAR TO 10,78
   @ 10,08 SAY "Ser† iniciado o processo de c¢pia para o disco de seguranáa."
   @ 11,08 SAY "       N∆o interrompa de forma alguma este Processo !       "
   @ 14,08 SAY "               Deseja iniciar o Processo ?                  "
   IF !Confirme()
      LOOP
   ENDIF
   barq:={ |cFile,nPos| Sayd(12,20,"Compactando "+UPPER(cFile),"@X",25) }
   band:={ |nPos,nTotal| Sayd(12,53,STR(nPos/nTotal*100,3)+"%","@X",5) }
   @ 10,01 CLEAR TO 14,78
   SETCOLOR(vcp)
   Aviso(10,"Aguarde")
   SETCOLOR(vcn)
   // Sistema FC - Empresa Selecionada
   vfiles:=DbsMov("FC")
   IF !HB_ZIPFILE(vdrv+"\FC"+vcemp+".ZIP",vfiles,9,barq,.T.,,.F.,.F.,band)
      Mensagem("N∆o Foi Poss°vel Executar o Back-Up do FC",3,1)
   ENDIF
   // Sistema FC - Demais Empresas
   IF vcemp+vcloja="00" // WM - Matriz (Holding)
      IF FILE((".\EMP2\FC_NOTAS.DBF")) // 2-Montese
         dirmov:=".\EMP2\"
         vfiles:=DbsMov("FC")
         IF !HB_ZIPFILE(vdrv+"\FC2.ZIP",vfiles,9,barq,.T.,,.F.,.F.,band)
            Mensagem("N∆o Foi Poss°vel Executar o Back-Up do FC2",3,1)
         ENDIF
      ENDIF
      IF FILE((".\EMP3\FC_NOTAS.DBF")) // 3-Empresa Natal
         dirmov:=".\EMP3\"
         vfiles:=DbsMov("FC")
         IF !HB_ZIPFILE(vdrv+"\FC3.ZIP",vfiles,9,barq,.T.,,.F.,.F.,band)
            Mensagem("N∆o Foi Poss°vel Executar o Back-Up do FC3",3,1)
         ENDIF
      ENDIF
      dirmov:=".\EMP"+vcemp+"\"
   ENDIF
   Beep(2)
   @ 10,01 CLEAR TO 14,78
   SETCOLOR(vcp)
   Aviso(10,"  Backup Realizado !  ")
   INKEY(5)
   SETCOLOR(vcn)
   //Abrejan(2)
   Aviso(10,"Faz Back-Up TambÇm dos Outros Sistemas")
   IF !Confirme()
      EXIT
   ENDIF
   @ 10,01 CLEAR TO 10,78
   SETCOLOR(vcp)
   Aviso(10,"Aguarde")
   SETCOLOR(vcn)
   // Sistema WM - Empresa Selecionada
   vfiles:=DbsMov("WM")
   IF !HB_ZIPFILE(vdrv+"\WM"+vcemp+".ZIP",vfiles,9,barq,.T.,,.F.,.F.,band)
      Mensagem("N∆o Foi Poss°vel Executar o Back-Up do WM",3,1)
   ENDIF
   // Sistema WM - Demais Empresas
   IF vcemp+vcloja="00" // WM - Matriz (Holding)
      IF FILE((".\EMP2\WM_CTREC.DBF")) // 2-Montese
         dirmov:=".\EMP2\"
         vfiles:=DbsMov("WM")
         IF !HB_ZIPFILE(vdrv+"\WM2.ZIP",vfiles,9,barq,.T.,,.F.,.F.,band)
            Mensagem("N∆o Foi Poss°vel Executar o Back-Up do WM2",3,1)
         ENDIF
      ENDIF
      IF FILE((".\EMP3\WM_CTREC.DBF")) // 3-Empresa Natal
         dirmov:=".\EMP3\"
         vfiles:=DbsMov("WM")
         IF !HB_ZIPFILE(vdrv+"\WM3.ZIP",vfiles,9,barq,.T.,,.F.,.F.,band)
            Mensagem("N∆o Foi Poss°vel Executar o Back-Up do WM3",3,1)
         ENDIF
      ENDIF
      dirmov:=".\EMP"+vcemp+"\"
   ENDIF
   // Sistema EC - Empresa Selecionada
   vfiles:=DbsMov("EC")
   IF !HB_ZIPFILE(vdrv+"\EC"+vcemp+".ZIP",vfiles,9,barq,.T.,,.F.,.F.,band)
      Mensagem("N∆o Foi Poss°vel Executar o Back-Up do EC",3,1)
   ENDIF
   // Sistema EC - Demais Empresas
   IF vcemp+vcloja="00" // WM - Matriz (Holding)
      IF FILE((".\EMP2\EC_SAIDA.DBF")) // 2-Montese
         dirmov:=".\EMP2\"
         vfiles:=DbsMov("EC")
         IF !HB_ZIPFILE(vdrv+"\EC2.ZIP",vfiles,9,barq,.T.,,.F.,.F.,band)
            Mensagem("N∆o Foi Poss°vel Executar o Back-Up do EC2",3,1)
         ENDIF
      ENDIF
      IF FILE((".\EMP3\EC_SAIDA.DBF")) // 3-Empresa Natal
         dirmov:=".\EMP3\"
         vfiles:=DbsMov("EC")
         IF !HB_ZIPFILE(vdrv+"\EC3.ZIP",vfiles,9,barq,.T.,,.F.,.F.,band)
            Mensagem("N∆o Foi Poss°vel Executar o Back-Up do EC3",3,1)
         ENDIF
      ENDIF
      dirmov:=".\EMP"+vcemp+"\"
   ENDIF
   Beep(2)
   @ 10,01 CLEAR TO 14,78
   SETCOLOR(vcp)
   Aviso(10,"  Backup Realizado !  ")
   INKEY(5)
   SETCOLOR(vcn)
   EXIT
ENDDO
RETURN

********************************************************************************
PROCEDURE Recup()
********************************************************************************
Sinal("RECUPERAÄ«O","ARQUIVOS")
vtela:=SAVESCREEN(01,00,24,79)
Abrejan(2)
DO WHILE .T.
   vdrv:="E:"+SPACE(20)
   SETCOLOR(vcn)
   @ 08,05 SAY "Drive e diret¢rio do qual ser† recuperada a c¢pia:"
   @ 08,56 GET vdrv PICTURE "@!"
   Le()
   IF LASTKEY()==K_ESC
      RETURN
   ENDIF
   vdrv:=ALLTRIM(vdrv)
   IF !FILE(vdrv+"\FC"+vcemp+".ZIP")
      Mensagem("N∆o Existe o Arquivo no Diret¢rio Indicado!",3,1)
      LOOP
   ENDIF
   IF Confirme()
      EXIT
   ENDIF
ENDDO
Abrejan(2)
SETCOLOR(vca)
Aviso(08,"Recuperaá∆o dos Arquivos do Sistema")
SETCOLOR(vcn)
@ 11,08 SAY "Ser† iniciado o processo de c¢pia para o disco de trabalho."
@ 12,08 SAY "      N∆o interrompa de forma alguma este Processo !       "
@ 14,08 SAY "             Deseja iniciar o Processo ?                   "
IF Confirme()
   Abrejan(2)
   SETCOLOR(vcn)
   Aviso(04," Recuperaá∆o dos Arquivos ! ")
   vfiles:=HB_GetFilesInZip(vdrv+"\FC"+vcemp+".ZIP")
   barq:={ |cFile,nPos| Aviso(14,"Descompactando "+cFile) }
   band:={ |nPos,nTotal| Sayd(ROW(),30,STR(nPos/nTotal*100,3)+"%")}
   IF HB_UNZIPFILE(vdrv+"\FC"+vcemp+".ZIP",barq,,,dirmov,vfiles,band)
      Mensagem("Arquivos Restaurados com Sucesso!",5)
      Mensagem("Fim do Processo !",5)
   ELSE
      Mensagem("N∆o Foi Poss°vel Restaurar o Back-Up",3,1)
   ENDIF
   RESTSCREEN(01,00,24,79,vtela)
   Indexa(.F.) // sem Menu
ENDIF
RETURN

********************************************************************************
PROCEDURE Confimp(vimp)
// Objetivo: configuraá∆o da impressora.
********************************************************************************
LOCAL vtit
Abrejan(2)
Sinal("IMPRESSORA","CONFIGURAÄ«O")
IF vimp=1 .OR. vimp=2  // Elebra e Rima Padr∆o
   vtit:="Elebra e Rima Padr∆o"
   vcia05:=CHR(14)          // ativa a expans∆o em uma linha
   vcid05:=CHR(20)          // desativa a expans∆o
   vcia10:=CHR(30)+"0"      // impress∆o a 10 cpp
   vcid20:=CHR(18)          // desativa a condensaá∆o de caracteres
   vcia12:=CHR(30)+"2"      // impress∆o a 12 cpp
   vcia20:=CHR(30)+CHR(52)  // ativa condensaá∆o de caracteres
   vcia15:=CHR(30)+"3"      // ativa condensaá∆o a 15 cpp
   vcia17:=CHR(30)+"3"      // ativa a impress∆o para 163 caractere
   vciaip:=CHR(27)+"@"      // ativa a impress∆o
ELSEIF vimp=3          // configuraá∆o para Rima Itautec
   vtit:="Rima Itautec"
   vcia05:=CHR(14)          // ativa a expans∆o em uma linha
   vcid05:=CHR(20)          // desativa a expans∆o
   vcia10:=CHR(30)+"0"      // impress∆o a 10 cpp
   vcid10:=CHR(18)          // desativa a condensaá∆o de caracteres
   vcia12:=CHR(30)+"2"      // impress∆o a 12 cpp
   vcia20:=CHR(30)+CHR(52)  // ativa condensaá∆o de caracteres
   vcia15:=CHR(27)+"[6W"    // ativa condensaá∆o a 15 cpp
   vcia17:=CHR(27)+"[2W"    // ativa a impress∆o para 163 caractere
   vciaip:=CHR(27)+"[5W"    // ativa a impress∆o
ELSEIF vimp=4          // configuraá∆o para Elgin
   vtit:="Elgin"
   vcia05:=CHR(27)+"[9w"    // ativa a expans∆o em uma linha
   vcid05:=CHR(27)+"[8w"    // desativa a expans∆o
   vcia10:=CHR(27)+"[4w"    // impress∆o a 10 cpp
   vcid10:=CHR(27)+"[4w"    // desativa a condensaá∆o de caracteres
   vcia12:=CHR(27)+"[5w"    // impress∆o a 12 cpp
   vcia20:=CHR(27)+"[6w"    // ativa condensaá∆o de caracteres
   vcia15:=CHR(30)+"[6w"    // ativa condensaá∆o a 15 cpp
   vcia17:=CHR(27)+"[5w"    // ativa a impress∆o para 163 caractere
   vciaip:=CHR(27)+"[3w"    // ativa a impress∆o
ELSEIF vimp=5          // configuraá∆o para Epson Padr∆o
   vtit:="Epson Padr∆o FX"
   vcia05:=CHR(14)          // ativa a expans∆o em uma linha
   vcid05:=CHR(20)          // desativa a expans∆o
   vcia10:=CHR(30)+"0"      // impress∆o a 10 cpp
   vcid10:=CHR(18)          // desativa a condensaá∆o de caracteres
   vcia12:=CHR(30)+"2"      // impress∆o a 12 cpp
   vcia20:=CHR(15)          // ativa condensaá∆o de caracteres
   vcia15:=CHR(30)+"3"      // ativa condensaá∆o a 15 cpp
   vcia17:=CHR(30)+"3"      // ativa a impress∆o para 163 caractere
   vciaip:=CHR(27)+"@"      // ativa a impress∆o
ELSEIF vimp=6          // configuraá∆o para Epson LX-810
   vtit:="Epson LX-810"
   vcia05:=CHR(14)          // ativa a expans∆o em uma linha
   vcid05:=CHR(20)          // desativa a expans∆o
   vcia10:=CHR(27)+"P"      // impress∆o a 10 cpp
   vcid10:=CHR(18)          // desativa a condensaá∆o de caracteres
   vcia12:=CHR(27)+"M"      // impress∆o a 12 cpp
   vcia20:=CHR(15)          // ativa condensaá∆o de caracteres
   vcia15:=CHR(15)          // ativa condensaá∆o a 15 cpp
   vcia17:=CHR(15)          // ativa a impress∆o para 163 caractere
   vciaip:=CHR(27)+"P"      // ativa a impress∆o
ENDIF
SETCOLOR(vcp)
Aviso(12,"Configurando o Sistema para as Impressoras "+vtit)
SETCOLOR(vcn)
INKEY(4)
RETURN

********************************************************************************
PROCEDURE Confcor(vcor)
// Objetivo: configuraá∆o das cores da tela.
********************************************************************************
IF vcor=1
   // Padr∆o Monocrom†tico
   vcn:="W/N,N/W,,,W+/BG"
   vci:="N/W,W/N,,,BG/W+"
   vca:="W+/N,N/W,,,BG/W+"
   vcp:="W+*/N,N/W,,,BG/W+"
   vcr:="W+/BG,N/W,,,BG/W+"
   vcm:="W/N,N/W,,,W+/BG"
   vcf:="W+/RB,N/W,,,W+/BG"
ELSEIF vcor=2
   // Padr∆o Azul
   vcn:="W/N,N/W,,,W+/B"
   vci:="W+/B,W/N,,,B/W+"
   vca:="W+/N,N/W,,,B/W+"
   vcp:="W+*/N,N/W,,,B/W+"
   vcr:="W+/B,N/W,,,B/W+"
   vcm:="W/N,W+/B,,,W+/B"
   vcf:="W+/BG,GR+/B,,,W+/B"
ELSEIF vcor=3
   // Padr∆o Verde
   vcn:="W/N,N/W,,,W+/G"
   vci:="W+/G,W/N,,,G/W+"
   vca:="W+/N,N/W,,,G/W+"
   vcp:="W+*/N,N/W,,,G/W+"
   vcr:="W+/G,N/W,,,G/W+"
   vcm:="W/N,W+/G,,,W+/G"
   vcf:="W+/BG,W+/R,,,W+/G"
ELSEIF vcor=4
   // Padr∆o P£rpura
   vcn:="W/N,N/W,,,W+/RB"
   vci:="W+/RB,W/N,,,RB/W+"
   vca:="W+/N,N/W,,,RB/W+"
   vcp:="W+*/N,N/W,,,RB/W+"
   vcr:="W+/RB,N/W,,,RB/W+"
   vcm:="W/N,W+/RB,,,W+/RB"
   vcf:="W+/BG,GR+/RB,,,W+/RB"
ELSEIF vcor=5
   // Padr∆o Vermelho
   vcn:="W/N,N/W,,,W+/R"
   vci:="W+/R,W/N,,,R/W+"
   vca:="W+/N,N/W,,,R/W+"
   vcp:="W+*/N,N/W,,,R/W+"
   vcr:="W+/R,N/W,,,R/W+"
   vcm:="W/N,W+/R,,,W+/R"
   vcf:="W+/BG,GR+/R,,,W+/R"
ELSEIF vcor=6
   // Padr∆o Cristal L°quido.
   vcn:="W/N,N/W,,,B+/N"
   vci:="N/W,N/W,,,B+/N"
   vca:="W+/N,N/W,,,B+/N"
   vcp:="W+*/N,N/W,,,B+/N"
   vcr:="N/W,N/W,,,B+/N"
   vcm:="W/N,N/W,,,B+/N"
   vcf:="W+/BG,N/W,,,B+/N"
ENDIF
// Reapresenta a linha de status com as novas cores definidas.
SETCOLOR(vci)
@ 01,00 SAY SPACE(12)+"∫"+SPACE(12)+"∫"+SPACE(28)+"∫"+SPACE(11)+"∫"+SPACE(13)
@ 01,70 SAY DATE()
@ 01,26 SAY vsist
Sinal("MENU","PRINCIPAL")
SETCOLOR(vcn)
// Salva a tela.
vt2:=SAVESCREEN(01,00,24,79)
RETURN


// ### Rotinas de Usu†rios, Acesso e Credenciamento

********************************************************************************
PROCEDURE ConsUsu()
// Consultas e Pesquisas aos Registros do Arquivo de Dados
***********************************************************
LOCAL vdado[4],vmask[4],vcabe[4],vedit[4]
PRIVATE vnome,vcred //vcodop,vnome,vsenha,vcred
// modo: operaá∆o a ser realizada.
PRIVATE vmodo:=4 // 4-Consulta
PRIVATE pv:=.T.
// Abertura do arquivo de dados.
IF Abrearq((dircad+modulo+"_USUAR.DBF"),"Usu",.F.,10)
   SET INDEX TO (dircad+modulo+"_USUA1"), (dircad+modulo+"_USUA2")
ELSE
   Mensagem("O Arquivo de Usu†rios N∆o Est† Dispon°vel !",3,1)
   RETURN
ENDIF
// vdado: vetor dos nomes dos campos
vdado[01]:="codop"
vdado[02]:="nome"
vdado[03]:="IIF(!EMPTY(Usu->senha),REPLICATE('*',15),SPACE(15))"
vdado[04]:="cred"
// vmask: vetor das m†scaras de apresentaá∆o dos dados.
vmask[01]:="999"
vmask[02]:="@!"
vmask[03]:="@!"
vmask[04]:="@!"
// vcabe: vetor dos t°tulos para o cabeáalho das colunas.
vcabe[01]:="C¢digo"
vcabe[02]:="Nome"
vcabe[03]:="Senha"
vcabe[04]:="Credenciamento"
// vedit: vetor com os campos que podem ser editados.
AFILL(vedit,.F.)
// Informaá‰es para ajuda ao usu†rio.
majuda:={;
"Ins        - Inclui um novo Usu†rio no Sistema",;
"Ctrl+Enter - Altera o Usu†rio sob Cursor",;
"Del        - Exclui o Usu†rio sob Cursor",;
"Enter      - Consulta o Usu†rio em Tela Cheia",;
"F2         - Pesquisa pelo C¢digo do Usu†rio",;
"F3         - Pesquisa pelo Nome do Usu†rio"}
// Construá∆o da Tela de Apresentaá∆o.
Sinal("USUµRIOS","CONSULTA")
Abrejan(2)
@ 04,01 SAY REPLICATE("ƒ",78)
// Barra de Tarefas.
SETCOLOR(vcr)
@ 22,00 SAY PADC("Ins=Inclui Ctrl+Enter=Altera Del=Exclui Enter=Consulta ",80)
@ 23,00 SAY PADC(" F1=Ajuda    F2=C¢digo     F3=Nome    Esc=Fim ",80)
SETCOLOR(vcn)
// Chamada do procedimento de consulta desenvolvido com TBrowse.
ConsBrowse("Usu",05,01,21,78,vdado,vmask,vcabe,vedit,0,{|| OpsUsu()},;
           "codop",1,"999",3 ,"C¢digo",;
           "nome" ,2,"@!" ,15,"Nome")
CLOSE DATABASES
RETURN

********************************************************************************
FUNCTION OpsUsu()
// opá‰es da consulta de usu†rios.
********************************************************************************
LOCAL vtela
// Destaque do browse
SETCOLOR(vcn)
@ 03,03 SAY "Usu†rio:"
SETCOLOR(vcd)
@ 03,13 SAY Usu->codop PICTURE "999"
@ 03,18 SAY Usu->nome
SETCOLOR(vcn)
// Teclas de opá‰es da consulta
IF LASTKEY()=K_INS
   // Ins - Inclus∆o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   IF pv
      IF !Senha("05")
         RETURN .F.
      ENDIF
      pv:=.F.
   ENDIF
   Sinal("USUµRIOS","INCLUS«O")
   MatUsu(1)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_CTRL_ENTER
   // Ctrl+Enter - Alteraá∆o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   IF pv
      IF !Senha("05")
         RETURN .F.
      ENDIF
      pv:=.F.
   ENDIF
   Sinal("USUµRIOS","ALTERAÄ«O")
   MatUsu(2)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_DEL
   // Del - Exclus∆o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   IF pv
      IF !Senha("05")
         RETURN .F.
      ENDIF
      pv:=.F.
   ENDIF
   Sinal("USUµRIOS","EXCLUS«O")
   MatUsu(3)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_ENTER
   // Enter - Consulta em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   vcodop:=SPACE(3)
   vnome :=SPACE(15)
   vcred :=SPACE(40)
   vsenha:=SPACE(45)
   TransfUsu()
   CredItens(2)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ENDIF
RETURN .F.

********************************************************************************
PROCEDURE MatUsu(modo)
/* Gerenciador de Usu†rios
   Parametros: modo - operaá∆o a ser realizada: 1 - Inclus∆o
                                                2 - Alteraáao
                                                3 - Exclus∆o */
********************************************************************************
DO WHILE .T.
   Abrejan(2)
   IF modo=1 // Se for Inclus∆o
      // Inicializa variaveis para inclus∆o
      vcodop:=SPACE(3)
      vnome :=SPACE(15)
      vsenha:=SPACE(45)
      vcred :=SPACE(40)
      SET ORDER TO 1
   ELSE      // Sen∆o (Alteraá∆o, Exclus∆o ou Consulta)
      // Transfere os campos do registro p/as variaveis
      TransfUsu()
   ENDIF
   TitUsu()
   MostraUsu()
   IF modo=1 .OR. modo=2
      EditaUsu(modo)
      IF !Confirme()
         LOOP
      ENDIF
      IF modo=1
         // Inclui um novo registro no arquivo.
         IF Adireg(10)
            Usu->codop:=vcodop
            UNLOCK
         ELSE
            Mensagem("Erro de Rede, Inclus∆o N∆o Efetuada !",4,1)
         ENDIF
      ENDIF
      // Atualiza o conte£do dos campos do registro.
      IF Bloqreg(10)
         AtualUsu()
         UNLOCK
      ELSE
         Mensagem("O Registro N∆o Est† Dispon°vel !",3,1)
      ENDIF
   ELSEIF modo=3
      IF Exclui()
         // Deleta o registro do arquivo.
         IF Bloqreg(10)
            DELETE
            UNLOCK
         ELSE
            Mensagem("O Registro N∆o Est† Dispon°vel !",3,1)
         ENDIF
      ENDIF
   ENDIF
   EXIT
ENDDO
SETCOLOR(vcn)
RETURN

********************************************************************************
PROCEDURE TitUsu()
// Apresenta os t°tulos do arquivo na tela.
*******************************************
SETCOLOR(vcn)
@ 09,10 SAY "C¢digo________: "
@ 11,10 SAY "Nome__________: "
@ 13,10 SAY "Senha_________: "
RETURN

********************************************************************************
PROCEDURE MostraUsu()
// Mostra os dados do arquivo na tela.
**************************************
SETCOLOR(vcd)
@ 09,26 SAY vcodop   PICTURE "999"
@ 11,26 SAY vnome    PICTURE "@!"
@ 13,26 SAY IIF(!EMPTY(vsenha),"***************",SPACE(15))
SETCOLOR(vcn)
RETURN

********************************************************************************
PROCEDURE EditaUsu(modo2)
// Edita os dados do arquivo.
*****************************
SETCOLOR(vcd)
IF modo2=1
   @ 09,26 GET vcodop PICTURE "999" VALID (vcodop#"499".AND.LEFT(vcodop,1)="4".AND.!EMPTY(vcodop))
   Aviso(24,"Digite o C¢digo, ou Tecle <Esc> para Finalizar")
   Le()
   IF LASTKEY()=K_ESC
      RETURN
   ENDIF
   GO TOP
   SEEK vcodop
   IF FOUND()
      Mensagem("Desculpe, Usu†rio J† Cadastrado !",5,1)
      RETURN
   ENDIF
ENDIF
@ 11,26 GET vnome   PICTURE "@!"
Le()
SETCOLOR(vcn)
Aviso(24,"Deseja Cadastrar a Senha")
IF Confirme()
   vsenha:=DigSenha(13,26,"Digite a Senha, 15 Caracteres no M†ximo")
ENDIF
IF !EMPTY(vsenha)
   CredItens(1)
ENDIF
@ 24,00 CLEAR
RETURN

********************************************************************************
PROCEDURE TransfUsu()
// Transfere os dados do arquivo.
*********************************
vcodop:=Usu->codop
vnome :=Usu->nome
vcred :=Usu->cred
vsenha:=Usu->senha
RETURN

********************************************************************************
PROCEDURE AtualUsu()
// Atualiza os dados dos campos do arquivo.
*******************************************
Usu->nome :=vnome
Usu->cred :=vcred
Usu->senha:=vsenha
RETURN

**************************************************************************
PROCEDURE CredItens(modo3)
**************************
LOCAL vtela:=SAVESCREEN(01,00,24,79)
LOCAL i:=1
PRIVATE vli:=4,li:=1,vt:=0,lf:=18
IF modulo="FC"
   PRIVATE mcred:={;
   {" ","01-Incluir Cadastros","01"},;
   {" ","02-Alterar Cadastros","02"},;
   {" ","03-Excluir Cadastros","03"},;
   {" ","04-Imprimir Relat¢rios de Cadastros","04"},;
   {" ","05-Gerenciar Usu†rios do Sistema","05"},;
   {" ","A1-Incluir Produto e Composiá∆o","A1"},;
   {" ","A2-Alterar Produto e Composiá∆o","A2"},;
   {" ","A3-Excluir Produto e Composiá∆o","A3"},;
   {" ","A6-Consultar Custos de Produtos","A6"},;
   {" ","A7-Atualizar Custos de Produtos","A7"},;
   {" ","B1-Incluir Fornecedor","B1"},;
   {" ","B2-Alterar Fornecedor","B2"},;
   {" ","B3-Excluir Fornecedor","B3"},;
   {" ","C1-Incluir CFOP","C1"},;
   {" ","C2-Alterar CFOP","C2"},;
   {" ","C3-Excluir CFOP","C3"},;
   {" ","D1-Incluir Transportadora","D1"},;
   {" ","D2-Alterar Transportadora","D2"},;
   {" ","D3-Excluir Transportadora","D3"},;
   {" ","E1-Incluir Loja","E1"},;
   {" ","E2-Alterar Loja","E2"},;
   {" ","E3-Excluir Loja","E3"},;
   {" ","F1-Incluir N£mero de Seguranáa","F1"},;
   {" ","F2-Alterar N£mero de Seguranáa","F2"},;
   {" ","F3-Excluir N£mero de Seguranáa","F3"},;
   {" ","G1-Incluir Operaá∆o Financeira","G1"},;
   {" ","G2-Alterar Operaá∆o Financeira","G2"},;
   {" ","G3-Excluir Operaá∆o Financeira","G3"},;
   {" ","H1-Incluir Grupo de Produtos","H1"},;
   {" ","H2-Alterar Grupo de Produtos","H2"},;
   {" ","H3-Excluir Grupo de Produtos","H3"},;
   {" ","I1-Incluir Local de Estoque","I1"},;
   {" ","I2-Alterar Local de Estoque","I2"},;
   {" ","I3-Excluir Local de Estoque","I3"},;
   {" ","Z1-Incluir Usu†rio","Z1"},;
   {" ","Z2-Alterar Usu†rio","Z2"},;
   {" ","Z3-Excluir Usu†rio","Z3"},;
   {" ","11-Incluir/Alt/Excluir/Cancelar Notas Fiscais","11"},;
   {" ","12-Alterar Notas Fiscais Ap¢s...","12"},;
   {" ","13-Imprimir Relat¢rios de Notas Fiscais","13"},;
   {" ","14-Imprimir Relat¢rios de Duplicatas","14"},;
   {" ","16-Incluir/Alt/Excluir/Cancelar Cupons Fiscais","16"},;
   {" ","21-Incluir Solicitaá‰es de Compras","21"},;
   {" ","22-Alterar Solicitaá‰es de Compras","22"},;
   {" ","23-Excluir Solicitaá‰es de Compras","23"},;
   {" ","24-Imprimir Relat¢rios de Solicitaá‰es de Compras","24"},;
   {" ","31-Incluir Cotaá‰es","31"},;
   {" ","32-Alterar Cotaá‰es","32"},;
   {" ","33-Excluir Cotaá‰es","33"},;
   {" ","34-Imprimir Relat¢rios de Cotaá‰es","34"},;
   {" ","41-Incluir Pedidos de Compras","41"},;
   {" ","42-Alterar Pedidos de Compras","42"},;
   {" ","43-Excluir Pedidos de Compras","43"},;
   {" ","44-Imprimir Relat¢rios de Pedidos de Compras","44"},;
   {" ","51-Incluir Entradas no Estoque","51"},;
   {" ","52-Alterar Entradas no Estoque","52"},;
   {" ","53-Excluir Entradas no Estoque","53"},;
   {" ","61-Incluir Requisiá‰es de Material","61"},;
   {" ","62-Alterar Requisiá‰es de Material","62"},;
   {" ","63-Excluir Requisiá‰es de Material","63"},;
   {" ","64-Transferir Requisiá‰es de Material","64"},;
   {" ","71-Implantar Saldos Iniciais","71"},;
   {" ","72-Emiss∆o de Relat¢rios de Estoque","72"},;
   {" ","91-Importar e Recuperar Dados Para o Sistema","91"}}
ELSEIF modulo="WM"
   PRIVATE mcred:={;
   {" ","01-Incluir Cadastros","01"},;
   {" ","02-Alterar Cadastros","02"},;
   {" ","03-Excluir Cadastros","03"},;
   {" ","04-Imprimir Relat¢rios de Cadastros","04"},;
   {" ","05-Gerenciar Usu†rios do Sistema","05"},;
   {" ","J1-Incluir Banco","J1"},;
   {" ","J2-Alterar Banco","J2"},;
   {" ","J3-Excluir Banco","J3"},;
   {" ","L1-Incluir Tipo de Pagamento","L1"},;
   {" ","L2-Alterar Tipo de Pagamento","L2"},;
   {" ","L3-Excluir Tipo de Pagamento","L3"},;
   {" ","M1-Incluir Agente de Cobranáa","M1"},;
   {" ","M2-Alterar Agente de Cobranáa","M2"},;
   {" ","M3-Excluir Agente de Cobranáa","M3"},;
   {" ","N1-Incluir Tipo de Transaá∆o","N1"},;
   {" ","N2-Alterar Tipo de Transaá∆o","N2"},;
   {" ","N3-Excluir Tipo de Transaá∆o","N3"},;
   {" ","E1-Incluir Loja","E1"},;
   {" ","E2-Alterar Loja","E2"},;
   {" ","E3-Excluir Loja","E3"},;
   {" ","O1-Incluir Empresa","O1"},;
   {" ","O2-Alterar Empresa","O2"},;
   {" ","O3-Excluir Empresa","O3"},;
   {" ","P1-Incluir S¢cio","P1"},;
   {" ","P2-Alterar S¢cio","P2"},;
   {" ","P3-Excluir S¢cio","P3"},;
   {" ","Q1-Incluir Cotaá∆o de D¢lar","Q1"},;
   {" ","Q2-Alterar Cotaá∆o de D¢lar","Q2"},;
   {" ","Q3-Excluir Cotaá∆o de D¢lar","Q3"},;
   {" ","R1-Incluir ÷ndice de Correá∆o","R1"},;
   {" ","R2-Alterar ÷ndice de Correá∆o","R2"},;
   {" ","R3-Excluir ÷ndice de Correá∆o","R3"},;
   {" ","S1-Incluir Conta Banc†ria","S1"},;
   {" ","S2-Alterar Conta Banc†ria","S2"},;
   {" ","S3-Excluir Conta Banc†ria","S3"},;
   {" ","G1-Incluir Operaá∆o Financeira","G1"},;
   {" ","G2-Alterar Operaá∆o Financeira","G2"},;
   {" ","G3-Excluir Operaá∆o Financeira","G3"},;
   {" ","B1-Incluir Fornecedor","B1"},;
   {" ","B2-Alterar Fornecedor","B2"},;
   {" ","B3-Excluir Fornecedor","B3"},;
   {" ","Z1-Incluir Usu†rio","Z1"},;
   {" ","Z2-Alterar Usu†rio","Z2"},;
   {" ","Z3-Excluir Usu†rio","Z3"},;
   {" ","09-Cadastrar e Alterar Contas a Receber","09"},;
   {" ","10-Excluir Contas a Receber","10"},;
   {" ","11-Baixar Contas a Receber","11"},;
   {" ","12-Estornar Contas Recebidas","12"},;
   {" ","13-Emitir Relat¢rios de Contas a Receber","13"},;
   {" ","14-Cadastrar e Alterar Contas a Pagar","14"},;
   {" ","15-Excluir e Estornar Contas a Pagar","15"},;
   {" ","16-Baixar Contas a Pagar","16"},;
   {" ","17-Emitir Relat¢rios de Contas a Pagar","17"},;
   {" ","18-Realizar Conciliaá∆o Banc†ria","18"},;
   {" ","19-Emitir Relat¢rios Banc†rios","19"},;
   {" ","20-Consultar Arquivos de Dados","20"},;
   {" ","21-Gerenciar Retiradas e Contas dos S¢cios","21"},;
   {" ","22-Gerenciar Transferància de Dados","22"},;
   {" ","23-Liberar Inclus∆o de Cheque de Terceiros","23"}}
ELSEIF modulo="EC"
   PRIVATE mcred:={;
   {" ","01-Incluir Cadastros","01"},;
   {" ","02-Alterar Cadastros","02"},;
   {" ","03-Excluir Cadastros","03"},;
   {" ","04-Imprimir Relat¢rios de Cadastros","04"},;
   {" ","05-Gerenciar Usu†rios do Sistema","05"},;
   {" ","T1-Incluir no Plano de Contas","T1"},;
   {" ","T2-Alterar o  Plano de Contas","T2"},;
   {" ","T3-Excluir do Plano de Contas","T3"},;
   {" ","U1-Incluir Lanáamento Padr∆o","U1"},;
   {" ","U2-Alterar Lanáamento Padr∆o","U2"},;
   {" ","U3-Excluir Lanáamento Padr∆o","U3"},;
   {" ","B1-Incluir Fornecedor","B1"},;
   {" ","B2-Alterar Fornecedor","B2"},;
   {" ","B3-Excluir Fornecedor","B3"},;
   {" ","C1-Incluir CFOP","C1"},;
   {" ","C2-Alterar CFOP","C2"},;
   {" ","C3-Excluir CFOP","C3"},;
   {" ","Z1-Incluir Usu†rio","Z1"},;
   {" ","Z2-Alterar Usu†rio","Z2"},;
   {" ","Z3-Excluir Usu†rio","Z3"},;
   {" ","11-Incluir Movimento de Sa°da","11"},;
   {" ","12-Alterar Movimento de Sa°da","12"},;
   {" ","13-Excluir Movimento de Sa°da","13"},;
   {" ","21-Incluir Movimento de Entrada","21"},;
   {" ","22-Alterar Movimento de Entrada","22"},;
   {" ","23-Excluir Movimento de Entrada","23"},;
   {" ","31-Imprimir Relat¢rios da Escrita Fiscal","31"},;
   {" ","32-Encerrar Per°odos Fiscais de Trabalho","32"},;
   {" ","41-Incluir Lanáamento Cont†bil","41"},;
   {" ","42-Alterar Lanáamento Cont†bil","42"},;
   {" ","43-Excluir Lanáamento Cont†bil","43"},;
   {" ","51-Importar Lotes para a Contabilidade","51"},;
   {" ","52-Imprimir Relat¢rios da Contabilidade","52"},;
   {" ","53-Encerrar/Desencerrar o Resultado do Exerc°cio","53"},;
   {" ","61-Importar Dados Para o Sistema","61"}}
ELSE
   Mensagem("M¢dulo N∆o Definido !",3,1)
   RETURN
ENDIF
vcred:=ALLTRIM(vcred)
DO WHILE i<=LEN(vcred)
   mcred[Mascan(mcred,3,SUBSTR(vcred,i,2)),1]:="*"
   i:=i+2
ENDDO
IF LEN(mcred)<lf
   lf:=LEN(mcred)
ENDIF
// Limpa regi∆o da tela
SETCOLOR(vcn)
@ 05,01 CLEAR TO 22,78
// Apresenta a linha de orientaá∆o ao usu†rio.
SETCOLOR(vci)
IF modo3=1
   @ 23,00 SAY PADC("Insert=Marca/Desmarca  <Setas>  <Esc>",80)
ELSE
   @ 23,00 SAY PADC("<Setas>  <Esc>",80)
ENDIF
MostraCred(li,lf,vcn)
DO WHILE .T.
   SETCOLOR(vcp)
   // Mostra o item selecionado.
   MostraCred(li,li,vca)
   // Aguarda o pressionamento de uma tecla de controle.
   tk:=INKEY(0)
   IF tk=K_INS
      IF modo3=1
         // marca/desmarca o item
         IF EMPTY(mcred[li+vt,1])
            mcred[li+vt,1]:="*"
         ELSE
            mcred[li+vt,1]:=" "
         ENDIF
         MostraCred(li,li,vca)
      ENDIF
   ELSEIF tk=K_UP
      // Seta para Cima: desloca para o item anterior.
      SETCOLOR(vcn)
      // Mostra o item.
      MostraCred(li,li,vcn)
      // Decrementa a linha dos itens.
      IF li>1
         --li
      ELSE
         // Realiza o rolamento da tela.
         IF vt>0
            --vt
            SCROLL(vli+1,11,lf+4,69,-1)
            // Mostra o item.
            MostraCred(li,li,vcn)
         ENDIF
      ENDIF
   ELSEIF tk=K_DOWN
      // Seta para Baixo: desloca para o item seguinte.
      SETCOLOR(vcn)
      // Mostra o item.
      MostraCred(li,li,vcn)
      // Incrementa a linha dos itens.
      IF li<lf
         ++li
      ELSE
         // Realiza o rolamento da tela.
         IF vt<(LEN(mcred)-(lf+4-vli)) .AND. !EMPTY(mcred[li+vt])
            ++vt
            SCROLL(vli+1,11,lf+4,69,1)
            // Mostra o item.
            MostraCred(li,li,vcn)
         ENDIF
      ENDIF
   ELSEIF tk=K_ESC
      // <Esc>: finaliza a ediá∆o dos itens.
      IF modo3=1
         @ 24,00 CLEAR
         i:=1
         vcred:=SPACE(40)
         addcred:=SPACE(0)
         DO WHILE i<=LEN(mcred)
            IF mcred[i,1]="*"
               addcred+=mcred[i,3]
            ENDIF
            i++
         ENDDO
         vcred:=addcred
      ENDIF
      EXIT
   ENDIF
ENDDO
RESTSCREEN(01,00,24,79,vtela)
RETURN

********************************************************************************
PROCEDURE MostraCred(ni,nf,vcor)
/* Apresenta os itens de credenciamento.
   ni:   n£mero do item inicial.
   nf:   n£mero do item final.
   vcor: padr∆o de cor para apresentaá∆o dos itens.*/
******************************************************
LOCAL i
SETCOLOR(vcor)
FOR i=ni TO IF(nf<5+lf-vli,nf,4+lf-vli)
    @ vli+i,12 SAY mcred[i+vt,1]
    @ vli+i,15 SAY mcred[i+vt,2]
NEXT
SETCOLOR(vcn)
RETURN

*******************************************************************************
FUNCTION AltSenha()
***********************
LOCAL vezes:=1
LOCAL i
LOCAL telasen:=SAVESCREEN(01,00,24,79)
DO WHILE .T.
   vcodop  :=SPACE(3)
   vsenha  :=SPACE(45)
   vnsenha :=SPACE(15)
   TituloSen()
   MostraSen()
   SETCOLOR(vcr)
   @ 13,13 SAY PADC("SENHA - ALTERAÄ«O",61)
   SETCOLOR(vcn)
   @ 15,18 GET vcodop PICTURE "999"
   @ 24,00 CLEAR
   Aviso(24,"Digite o Codigo do Usu†rio ou <Esc> Para Retornar")
   Le()
   IF LASTKEY()==K_ESC
      RESTSCREEN(01,00,24,79,telasen)
      EXIT
   ENDIF
   @ 24,00 CLEAR
   IF Abrearq((dircad+modulo+"_USUAR.DBF"),"Usu",.F.,10)
      SET INDEX TO (dircad+modulo+"_USUA1")
   ELSE
      Mensagem("O Arquivo de Usu†rios N∆o Est† Dispon°vel!",3,1)
   ENDIF
   SEEK vcodop
   IF EOF()
      IF vezes <=3
         Mensagem("Operador N∆o Cadastrado Digite Novamente",4,1)
         @ 24,00 CLEAR
         vezes++
         CLOSE Usu
         LOOP
      ELSE
         Mensagem("N£mero de Tentativas Excedeu Tràs Vezes. Acesso Negado...",4,1)
         RESTSCREEN(01,00,24,79,telasen)
         CLOSE Usu
         EXIT
      ENDIF
   ELSE
      vnsenha:=Usu->nome
      vsenha :=Usu->senha
      MostraSen()
      IF DigSenha(15,50,"Digite a Senha Atual")==ALLTRIM(vsenha)
         vsenha:=DigSenha(15,50,"Digite a Nova Senha")
         IF Bloqreg(10)
            Usu->senha:=vsenha
            UNLOCK
            Mensagem("Senha Atualizada Com Sucesso",3,2)
         ELSE
            Mensagem("O Arquivo de Usu†rios N∆o Est† Dispon°vel!",3,1)
         ENDIF
         RESTSCREEN(01,00,24,79,telasen)
         CLOSE Usu
         EXIT
      ELSE
         IF vezes <=3
            Mensagem("Senha N∆o Compat°vel Com Operador",4,1)
            vezes++
            CLOSE Usu
            LOOP
         ELSE
            Mensagem("N£mero de Tentativas Excedeu Tràs Vezes. Acesso Negado...",5,1)
            RESTSCREEN(01,00,24,79,telasen)
            CLOSE Usu
            EXIT
         ENDIF
      ENDIF
   ENDIF
ENDDO
RETURN

********************************************************************************
FUNCTION Senha(pnivel)
// Objetivo: Verificar credenciamento e senha do usu†rio permitindo
//           ou n∆o o acesso.
********************************************************************************
// Declaraá∆o das vari†veis
LOCAL vezes,i,aberto,telant,areant,recant
PRIVATE vcred //vcodop,vsenha,vnsenha,vcred
// Inicializaá∆o das vari†veis
vezes:=1
aberto:=.F.
telant:=SAVESCREEN(01,00,24,79)
areant:=SELECT()
recant:=RECNO()
// Verificaá∆o da abertura do arquivo de usu†rios
IF SELECT("Usu") > 0
   aberto:=.T.
ENDIF
// In°cio da Rotina
DO WHILE .T.
   // Abertura do arquivo de dados.
   IF !aberto
      IF Abrearq((dircad+modulo+"_USUAR.DBF"),"Usu",.F.,10)
         SET INDEX TO (dircad+modulo+"_USUA1")
      ELSE
         Mensagem("O Arquivo de Usu†rios N∆o Est† Dispon°vel!",3,1)
         EXIT
      ENDIF
   ENDIF
   vcodop  :=SPACE(03)
   vsenha  :=SPACE(45)
   vnsenha :=SPACE(15)
   vcred   :=SPACE(40)
   TituloSen()
   MostraSen()
   SETCOLOR(vcr)
   @ 13,13 SAY PADC("SENHA - ACESSO",61)
   SETCOLOR(vcn)
   @ 15,18 GET vcodop PICTURE "999" VALID !EMPTY(vcodop)
   @ 24,00 CLEAR
   Aviso(24,"Digite o Codigo do Operador ou <Esc> Para Retornar")
   Le()
   IF LASTKEY()==K_ESC
      EXIT
   ENDIF
   @ 24,00 CLEAR
   GO TOP
   SEEK vcodop
   IF EOF()
      IF vezes <=3
         Mensagem("Operador N∆o Cadastrado Digite Novamente",4,1)
         @ 24,00 CLEAR
         vezes++
         IF !aberto
            CLOSE Usu
         ENDIF
         LOOP
      ELSE
         Mensagem("N£mero de Tentativas Excedeu Tràs Vezes. Acesso Negado...",4,1)
         EXIT
      ENDIF
   ELSE
      vnsenha:=Usu->nome
      vsenha :=Usu->senha
      vcred  :=ALLTRIM(Usu->cred)
      i:=1
      DO WHILE i<=LEN(vcred)
         IF pnivel==SUBSTR(vcred,i,2)
            EXIT
         ENDIF
         i:=i+2
      ENDDO
      IF vcodop#"499"
         IF i > LEN(vcred)
            Mensagem("Operador N∆o Credenciado Para Esta Operaá∆o!",5,1)
            EXIT
         ENDIF
      ENDIF
      MostraSen()
      IF DigSenha(15,50,"Digite a Senha")==ALLTRIM(vsenha)
         SETCOLOR(vcn)
         IF !aberto
            CLOSE Usu
         ENDIF
         RESTSCREEN(01,00,24,79,telant)
         SELECT(areant)
         IF recant > 0
            GO recant
         ENDIF
         RETURN .T.
      ELSE
         IF vezes <=3
            Mensagem("Senha N∆o Compat°vel Com Operador",4,1)
            vezes++
            IF !aberto
               CLOSE Usu
            ENDIF
            LOOP
         ELSE
            Mensagem("N£mero de Tentativas Excedeu Tràs Vezes. Acesso Negado...",5,1)
            EXIT
         ENDIF
      ENDIF
   ENDIF
ENDDO
IF !aberto
   CLOSE Usu
ENDIF
SETCOLOR(vcn)
RESTSCREEN(01,00,24,79,telant)
SELECT(areant)
IF recant > 0
   GO recant
ENDIF
RETURN .F.

*************************************************************************
PROCEDURE GravSen()
// Grava senha mestra
***********************
IF Abrearq((dircad+modulo+"_USUAR.DBF"),"Usu",.F.,10)
   SET INDEX TO (dircad+modulo+"_USUA1")
ELSE
   Mensagem("O Arquivo de Usu†rios N∆o Est† Dispon°vel!",3,1)
   RETURN
ENDIF
telasen:=SAVESCREEN(01,00,24,79)
DO WHILE .T.
   vcodop  :="499"
   vnsenha :=SPACE(15)
   vsenha  :=SPACE(45)
   @ 24,00 CLEAR
   TituloSen()
   MostraSen()
   SETCOLOR(vcr)
   @ 13,13 SAY PADC("CADASTRA SENHA MESTRA",61)
   SETCOLOR(vcn)
   Aviso(24,"Digite o Nome do Supervisor ou <Esc> Para Retornar")
   SETCOLOR(vcd)
   @ 15,27 GET vnsenha PICTURE "@!"
   Le()
   SETCOLOR(vcn)
   IF LASTKEY()==K_ESC
      CLOSE Usu
      RETURN
   ENDIF
   @ 24,00 CLEAR
   vsenha:=DigSenha(15,50,"Digite a Senha")
   IF !Confirme()
      LOOP
   ENDIF
   SELECT Usu
   SEEK vcodop
   IF EOF()
     IF Adireg(10)
        Usu->codop:=vcodop
        UNLOCK
     ELSE
        Mensagem("Erro de Rede. Inclus∆o N∆o Efetuada !",3,1)
        LOOP
     ENDIF
   ENDIF
   IF Bloqreg(10)
      Usu->codop :=vcodop
      Usu->nome  :=vnsenha
      Usu->senha :=vsenha
      UNLOCK
   ELSE
      Mensagem("Erro de Rede. Inclus∆o N∆o Efetuada !",3,1)
      LOOP
   ENDIF
   EXIT
ENDDO
CLOSE Usu
RESTSCREEN(01,00,24,79,telasen)
RETURN

*************************************************************************
PROCEDURE TituloSen()
***********************
SETCOLOR(vca)
Caixa(12,10,17,76,frame[1])
SETCOLOR(vcn)
@ 15,13 SAY "Oper: "
@ 15,22 SAY "Nome: "
@ 15,44 SAY "Senha: "
RETURN

**************************************************************************
PROCEDURE MostraSen()
***********************
SETCOLOR(vcd)
@ 15,18 SAY vcodop  PICTURE "999"
@ 15,27 SAY vnsenha PICTURE "@!"
@ 15,50 SAY SPACE(15)
SETCOLOR(vcn)
RETURN

*************************************************************************
FUNCTION DigSenha(lin,col,pmens)
********************************
LOCAL se[15],i:=1,vse:=SPACE(1),psenha
//             20        30        40        50        60        70
//       3456789012345678901234567890123456789012345678901234567890123456
//       Oper:XXX Nome:XXXXXXXXXXXXXXX  Senha:XXXXXXXXXXXXXXX
SETCOLOR(vcn)
@ 24,00 CLEAR
AFILL(se," ")
Aviso(24,pmens)
DO WHILE i <= 15
   vse:=CHR(INKEY(0))
   IF ISALPHA(vse)
      se[i]:=UPPER(vse)
   ENDIF
   IF ISDIGIT(vse)
      se[i]:=vse
   ENDIF
   IF LASTKEY()==K_BS
      IF i > 1
         i--
         col--
         se[i]:=" "
         @ lin,col SAY " "
         LOOP
      ENDIF
   ENDIF
   IF LASTKEY()==K_ENTER
      EXIT
   ENDIF
   SETCOLOR(vcd)
   @ lin,col SAY "*"
   i++
   col++
ENDDO
SETCOLOR(vcn)
// SET CONSOLE ON
A:=180
B:=190
C:=200
D:=210
psenha:=ALLTRIM(STR(ASC(se[01])+A++))+;
        ALLTRIM(STR(ASC(se[02])+B++))+;
        ALLTRIM(STR(ASC(se[03])+C++))+;
        ALLTRIM(STR(ASC(se[04])+D++))+;
        ALLTRIM(STR(ASC(se[05])+A++))+;
        ALLTRIM(STR(ASC(se[06])+B++))+;
        ALLTRIM(STR(ASC(se[07])+C++))+;
        ALLTRIM(STR(ASC(se[08])+D++))+;
        ALLTRIM(STR(ASC(se[09])+A++))+;
        ALLTRIM(STR(ASC(se[10])+B++))+;
        ALLTRIM(STR(ASC(se[11])+C++))+;
        ALLTRIM(STR(ASC(se[12])+D++))+;
        ALLTRIM(STR(ASC(se[13])+A++))+;
        ALLTRIM(STR(ASC(se[14])+B++))+;
        ALLTRIM(STR(ASC(se[15])+C++))
@ 24,00 CLEAR
RETURN psenha


// ### Rotinas de Validaá‰es

********************************************************************************
FUNCTION VdFormaPg(pformapg) // Valida Forma de Pagamento
********************************************************************************
PRIVATE GetList:={}
vformapg:=Acha3(vformapg,mFormapg,15,02,22,78,"!!999","@!","C¢d.","Forma de Pagamento")
IF EMPTY(vformapg).OR.LASTKEY()==K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY vformapg PICTURE "!!999"
Sayd(linha,coluna+5,"-"+mFormapg[Mascan(mFormapg,1,vformapg),2],"@!",30)
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION Modelo(linha,coluna,pdata)
********************************************************************************
IF pdata=NIL
   RETURN VdModelo(linha,coluna)
ELSEIF YEAR(pdata)<2005
   RETURN VdModelo(linha,coluna)
ELSE
   RETURN VdMode(linha,coluna)
ENDIF

********************************************************************************
PROCEDURE DescModelo(pmodelo,pdata)
********************************************************************************
IF YEAR(pdata)<2005
   RETURN IF(!EMPTY(pmodelo),"-"+mtab01[Mascan(mtab01,1,pmodelo),2],"")
ELSE
   RETURN IF(!EMPTY(pmodelo),"-"+mMode[Mascan(mMode,1,pmodelo),2],"")
ENDIF

********************************************************************************
FUNCTION VdModelo(linha,coluna)
********************************************************************************
PRIVATE GetList:={}
vmodelo:=Acha3(vmodelo,mTab01,15,02,22,78,"99","@!","C¢d.","Modelo")
IF EMPTY(vmodelo).OR.LASTKEY()==K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY vmodelo PICTURE "99"
x:=Mascan(mtab01,1,vmodelo)
IF x > 0
   Sayd(linha,coluna+2,"-"+mtab01[x,2],"@!",66)
ENDIF
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION VdMode(linha,coluna)
********************************************************************************
PRIVATE GetList:={}
vmodelo:=Acha3(vmodelo,mMode,15,02,22,78,"99","@!","C¢d.","Modelo")
IF EMPTY(vmodelo).OR.LASTKEY()==K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY vmodelo PICTURE "99"
x:=Mascan(mMode,1,vmodelo)
IF x > 0
   Sayd(linha,coluna+2,"-"+mMode[x,2],"@!",66)
ENDIF
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION Finalidade(linha,coluna,pdata)
********************************************************************************
IF pdata=NIL
   RETURN VdFinali(linha,coluna)
ELSEIF YEAR(pdata)<2005
   RETURN VdFinali(linha,coluna)
ELSE
   RETURN VdFina(linha,coluna)
ENDIF

********************************************************************************
PROCEDURE DescFinali(pfinali,pdata)
********************************************************************************
IF YEAR(pdata)<2005
   RETURN IF(!EMPTY(pfinali),"-"+mtab03[Mascan(mtab03,1,pfinali),2],"")
ELSE
   RETURN IF(!EMPTY(pfinali),"-"+mFina[Mascan(mFina,1,pfinali),2],"")
ENDIF

********************************************************************************
FUNCTION VdFinali(linha,coluna)
********************************************************************************
PRIVATE GetList:={}
vfinalidade:=Acha3(vfinalidade,mTab03,15,02,22,78,"99","@!","C¢d.","Finalidade")
IF EMPTY(vfinalidade).OR.LASTKEY()==K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY vfinalidade PICTURE "99"
x:=Mascan(mtab03,1,vfinalidade)
IF x > 0
   Sayd(linha,coluna+2,"-"+mtab03[x,2],"@!",66)
ENDIF
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION VdFina(linha,coluna)
********************************************************************************
PRIVATE GetList:={}
vfina:=Acha3(vfina,mFina,15,02,22,78,"99","@!","C¢d.","Finalidade")
IF EMPTY(vfina).OR.LASTKEY()==K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY vfina PICTURE "99"
x:=Mascan(mFina,1,vfina)
IF x > 0
   Sayd(linha,coluna+2,"-"+mFina[x,2],"@!",66)
ENDIF
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION Operacao(linha,coluna,pdata)
********************************************************************************
IF pdata=NIL
   RETURN VdOperacao(linha,coluna)
ELSEIF YEAR(pdata)<2005
   RETURN VdOperacao(linha,coluna)
ELSE
   RETURN VdOper(linha,coluna)
ENDIF

********************************************************************************
PROCEDURE DescOpera(popera,pdata)
********************************************************************************
IF YEAR(pdata)<2005
   RETURN IF(!EMPTY(popera),"-"+mtab05[Mascan(mtab05,1,popera),2],"")
ELSE
   RETURN IF(!EMPTY(popera),"-"+mOper[Mascan(mOper,1,popera),2],"")
ENDIF

********************************************************************************
FUNCTION VdOperacao(linha,coluna)
********************************************************************************
PRIVATE GetList:={}
vopera:=Acha3(vopera,mTab05,15,02,22,78,"99","@!","C¢d.","Operaá∆o")
IF EMPTY(vopera).OR.LASTKEY()==K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY vopera PICTURE "99"
x:=Mascan(mtab05,1,vopera)
IF x > 0
   Sayd(linha,coluna+2,"-"+mtab05[x,2],"@!",66)
ENDIF
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION VdOper(linha,coluna)
********************************************************************************
PRIVATE GetList:={}
vopera:=Acha3(vopera,mOper,15,02,22,78,"99","@!","C¢d.","Operaá∆o")
IF EMPTY(vopera).OR.LASTKEY()==K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY vopera PICTURE "99"
x:=Mascan(mOper,1,vopera)
IF x > 0
   Sayd(linha,coluna+2,"-"+mOper[x,2],"@!",66)
ENDIF
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION Sit(linha,coluna,pdata)
********************************************************************************
IF pdata=NIL
   RETURN VdSit(linha,coluna)
ELSEIF YEAR(pdata)<2005
   RETURN VdSit(linha,coluna)
ELSE
   RETURN VdSitu(linha,coluna)
ENDIF

********************************************************************************
PROCEDURE DescSitu(psit,pdata)
********************************************************************************
IF YEAR(pdata)<2005
   RETURN IF(!EMPTY(psit),"-"+mtab06[Mascan(mtab06,1,psit),2],"")
ELSE
   RETURN IF(!EMPTY(psit),"-"+mSitu[Mascan(mSitu,1,psit),2],"")
ENDIF

********************************************************************************
FUNCTION VdSit(linha,coluna)
********************************************************************************
PRIVATE GetList:={}
vsit:=Acha3(vsit,mTab06,15,02,22,78,"99","@!","C¢d.","Situaá∆o do Documento Fiscal")
IF EMPTY(vsit).OR.LASTKEY()==K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY vsit PICTURE "99"
x:=Mascan(mtab06,1,vsit)
IF x > 0
   Sayd(linha,coluna+2,"-"+mtab06[x,2],"@!",66)
ENDIF
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION VdSitu(linha,coluna)
********************************************************************************
PRIVATE GetList:={}
vsit:=Acha3(vsit,mSitu,15,02,22,78,"99","@!","C¢d.","Situaá∆o do Documento Fiscal")
IF EMPTY(vsit).OR.LASTKEY()==K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY vsit PICTURE "99"
x:=Mascan(mSitu,1,vsit)
IF x > 0
   Sayd(linha,coluna+2,"-"+mSitu[x,2],"@!",66)
ENDIF
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION Cond(linha,coluna,pdata)
********************************************************************************
IF pdata=NIL
   RETURN VdCondicao(linha,coluna)
ELSEIF YEAR(pdata)<2005
   RETURN VdCondicao(linha,coluna)
ELSE
   RETURN VdCond(linha,coluna)
ENDIF

********************************************************************************
PROCEDURE DescCond(pcond,pdata)
********************************************************************************
IF YEAR(pdata)<2005
   RETURN IF(!EMPTY(pcond),"-"+mtab07[Mascan(mtab07,1,pcond),2],"")
ELSE
   RETURN IF(!EMPTY(pcond),"-"+mCond[Mascan(mCond,1,pcond),2],"")
ENDIF

********************************************************************************
FUNCTION VdCondicao(linha,coluna)
********************************************************************************
PRIVATE GetList:={}
vcond:=Acha3(vcond,mTab07,15,02,22,78,"99","@!","C¢d.","Condiá∆o do Participante")
IF EMPTY(vcond).OR.LASTKEY()==K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY vcond PICTURE "99"
x:=Mascan(mtab07,1,vcond)
IF x > 0
   Sayd(linha,coluna+2,"-"+mtab07[x,2],"@!",66)
ENDIF
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION VdCond(linha,coluna)
********************************************************************************
PRIVATE GetList:={}
vcond:=Acha3(vcond,mCond,15,02,22,78,"99","@!","C¢d.","Condiá∆o do Participante")
IF EMPTY(vcond).OR.LASTKEY()==K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY vcond PICTURE "99"
x:=Mascan(mCond,1,vcond)
IF x > 0
   Sayd(linha,coluna+2,"-"+mCond[x,2],"@!",66)
ENDIF
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION Tipods(linha,coluna,pdata)
********************************************************************************
IF pdata=NIL
   RETURN VdTipods(linha,coluna)
ELSEIF YEAR(pdata)<2005
   RETURN VdTipods(linha,coluna)
ELSE
   RETURN VdDisp(linha,coluna)
ENDIF

********************************************************************************
PROCEDURE DescDisp(pdisp,pdata)
********************************************************************************
IF YEAR(pdata)<2005
   RETURN IF(!EMPTY(pdisp),"-"+mtab09[Mascan(mtab09,1,pdisp),2],"")
ELSE
   RETURN IF(!EMPTY(pdisp),"-"+mDisp[Mascan(mDisp,1,pdisp),2],"")
ENDIF

********************************************************************************
FUNCTION VdTipods(linha,coluna)
********************************************************************************
PRIVATE GetList:={}
vtipods:=Acha3(vtipods,mTab09,15,02,22,78,"99","@!","C¢d.","Dispositivo de Seguranáa")
IF EMPTY(vtipods).OR.LASTKEY()==K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY vtipods PICTURE "99"
x:=Mascan(mtab09,1,vtipods)
IF x > 0
   Sayd(linha,coluna+2,"-"+mtab09[x,2],"@!",66)
ENDIF
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION VdDisp(linha,coluna)
********************************************************************************
PRIVATE GetList:={}
vtipods:=Acha3(vtipods,mDisp,15,02,22,78,"99","@!","C¢d.","Dispositivo de Seguranáa")
IF EMPTY(vtipods).OR.LASTKEY()==K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY vtipods PICTURE "99"
x:=Mascan(mDisp,1,vtipods)
IF x > 0
   Sayd(linha,coluna+2,"-"+mDisp[x,2],"@!",66)
ENDIF
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION MotivoRef(linha,coluna,pdata)
********************************************************************************
IF pdata=NIL
   RETURN VdMotivo(linha,coluna)
ELSEIF YEAR(pdata)<2005
   RETURN VdMotivo(linha,coluna)
ELSE
   RETURN VdRefe(linha,coluna)
ENDIF

********************************************************************************
PROCEDURE DescRefe(pmotivo,pdata)
********************************************************************************
IF YEAR(pdata)<2005
   RETURN IF(!EMPTY(pmotivo),"-"+mtab11[Mascan(mtab11,1,pmotivo),2],"")
ELSE
   RETURN IF(!EMPTY(pmotivo),"-"+mRefe[Mascan(mRefe,1,pmotivo),2],"")
ENDIF

********************************************************************************
FUNCTION VdMotivo(linha,coluna)
********************************************************************************
PRIVATE GetList:={}
vmotivo:=Acha3(vmotivo,mTab11,15,02,22,78,"99","@!","C¢d.",;
"Motivo de Referància entre Documentos Fiscais")
IF EMPTY(vmotivo).OR.LASTKEY()==K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY vmotivo PICTURE "99"
x:=Mascan(mtab11,1,vmotivo)
IF x > 0
   Sayd(linha,coluna+2,"-"+mtab11[x,2],"@!",66)
ENDIF
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION VdRefe(linha,coluna)
********************************************************************************
PRIVATE GetList:={}
vmotivo:=Acha3(vmotivo,mRefe,15,02,22,78,"99","@!","C¢d.",;
"Motivo de Referància entre Documentos Fiscais")
IF EMPTY(vmotivo).OR.LASTKEY()==K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY vmotivo PICTURE "99"
x:=Mascan(mRefe,1,vmotivo)
IF x > 0
   Sayd(linha,coluna+2,"-"+mRefe[x,2],"@!",66)
ENDIF
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION VdMtvo(linha,coluna)
********************************************************************************
PRIVATE GetList:={}
vmtvo:=Acha3(vmtvo,mMtvo,15,02,22,78,"99","@!","C¢d.","Motivo")
IF EMPTY(vmtvo).OR.LASTKEY()==K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY vmtvo PICTURE "99"
x:=Mascan(mMtvo,1,vmtvo)
IF x > 0
   Sayd(linha,coluna+2,"-"+mMtvo[x,2],"@!",66)
ENDIF
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION VdRegi(linha,coluna)
********************************************************************************
PRIVATE GetList:={}
vregi:=Acha3(vregi,mRegi,15,02,22,78,"99","@!","C¢d.","Regime")
IF EMPTY(vregi).OR.LASTKEY()==K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY vregi PICTURE "99"
x:=Mascan(mRegi,1,vregi)
IF x > 0
   Sayd(linha,coluna+2,"-"+mRegi[x,2],"@!",66)
ENDIF
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION CodFis(linha,coluna,pvar)
********************************************************************************
PRIVATE GetList:={}
&(pvar):=Acha3(&(pvar),mcodfis,15,15,21,76,"9","@!")
IF EMPTY(&(pvar)).OR.LASTKEY()==K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY &(pvar) PICTURE "9"
x:=Mascan(mcodfis,1,&(pvar))
IF x > 0
   Sayd(linha,coluna+1,"-"+mcodfis[x,2],"@!",21)
ENDIF
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION TipoPag(linha,coluna)
********************************************************************************
PRIVATE GetList:={}
vtipg:=Acha2(vtipg,"Tpg",1,2,"codi","nome","!!!","@!",15,15,22,76)
SETCOLOR(vcd)
IF EMPTY(vtipg).OR.LASTKEY()==K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY vtipg PICTURE "!!!"
Sayd(linha,coluna+3,"-"+Procura("Tpg",1,vtipg,"nome"),"@!",21)
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION Tpgif(linha,coluna,pvar)
********************************************************************************
PRIVATE GetList:={}
IF !EMPTY(&(pvar))
   &(pvar):=Acha2(&(pvar),"Tpg",1,2,"codi","nome","!!!","@!",15,15,22,76)
   SETCOLOR(vcd)
   @ linha,coluna SAY &(pvar) PICTURE "!!!"
   Sayd(linha,coluna+3,"-"+Procura("Tpg",1,&(pvar),"nome"),"@!",21)
   SETCOLOR(vcn)
//ELSE
   //SETCOLOR(vcd)
   //Sayd(linha,coluna+3,"-TODOS(AS)","@!",21)
   //SETCOLOR(vcn)
ENDIF
IF LASTKEY()==K_ESC
   RETURN .F.
ENDIF
RETURN .T.

******************************************************************************
FUNCTION VdMatriz(linha,coluna,pvar,pmat)
// Valida a existància de um dado vari†vel numa matriz e
// exibe o c¢digo e a descriá∆o correspondente
******************************************************************************
LOCAL vlar, valt, lse, cse, lid, cid
PRIVATE GetList:={}
// Eliminando espaáos em branco e vendo maior largura
vlar:=0
FOR i=1 TO LEN(pmat)
   pmat[i,2]:=ALLTRIM(pmat[i,2])
   vlar:=MAX(LEN(pmat[i,2])+10,vlar)
NEXT
// Altualizando demais variaveis para exibiá∆o proporcional
valt:=LEN(pmat)+4
lse:=(25-valt)/2
cse:=(80-vlar)/2
lid:=lse+valt
cid:=cse+vlar
// Validando com a funá∆o
&(pvar):=Acha3(&(pvar),pmat,lse,cse,lid,cid,"@!","@!","C¢d.","Descriá∆o")
IF EMPTY(&(pvar)).OR.LASTKEY()==K_ESC
   RETURN .F.
ENDIF
// Exibindo o valor escolhido na tela
SETCOLOR(vcd)
@ linha,coluna SAY &(pvar) PICTURE "@!"
x:=Mascan(pmat,1,&(pvar))
IF x > 0
   Sayd(linha,coluna+LEN(&(pvar)),"-"+pmat[x,2],"@!",LEN(pmat[1,2])+1)
ENDIF
RETURN .T.

**************************************************************************
FUNCTION Codv(linha,coluna)
**************************************************************************
PRIVATE GetList:={}
vcodv:=Acha2(vcodv,"Ved",1,2,"codv","ngv","999","@!",15,15,22,76)
IF EMPTY(vcodv).OR.LASTKEY()==K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY vcodv PICTURE "999"
Sayd(linha,coluna+3,"-"+Procura("Ved",1,vcodv,"ngv"),"@!",25)
SETCOLOR(vcn)
RETURN .T.

**************************************************************************
FUNCTION Vedif(linha,coluna,pvar)
**************************************************************************
PRIVATE GetList:={}
IF !EMPTY(&(pvar))
   &(pvar):=Acha2(&(pvar),"Ved",1,2,"codv","ngv","999","@!",15,15,22,76)
   SETCOLOR(vcd)
   @ linha,coluna SAY &(pvar) PICTURE "999"
   Sayd(linha,coluna+3,"-"+Procura("Ved",1,&(pvar),"ngv"),"@!",16)
   SETCOLOR(vcn)
ENDIF
IF LASTKEY()==K_ESC
   RETURN .F.
ENDIF
RETURN .T.

**************************************************************************
FUNCTION AgCobif(linha,coluna,pvar)
**************************************************************************
PRIVATE GetList:={}
IF !EMPTY(&(pvar))
   &(pvar):=Acha2(&(pvar),"Tag",1,2,"codi","nome","@R 99.99","@!",15,15,22,76)
   SETCOLOR(vcd)
   @ linha,coluna SAY &(pvar) PICTURE "@R 9999"
   Sayd(linha,coluna+4,"-"+Procura("Tag",1,&(pvar),"nome"),"@!",31)
   SETCOLOR(vcn)
ENDIF
IF LASTKEY()==K_ESC
   RETURN .F.
ENDIF
RETURN .T.

********************************************************************************
FUNCTION Banco(linha,coluna)
********************************************************************************
PRIVATE GetList:={}
vbanco:=Acha2(vbanco,"Tban",1,2,"codi","nome","999","@!",15,15,22,76)
IF EMPTY(vbanco).OR.LASTKEY()==K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY vbanco PICTURE "999"
Sayd(linha,coluna+3,"-"+Procura("Tban",1,vbanco,"nome"),"@!",51)
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION Opera(linha,coluna)
********************************************************************************
PRIVATE GetList:={}
vopera:=Acha2(vopera,"Ope",1,2,"codi","nome","@!","@!",15,10,22,76)
IF EMPTY(vopera).OR.LASTKEY()==K_ESC
   RETURN .F.
ENDIF
IF Procura("Ope",1,vopera,"tipo")="T"
   Mensagem("Operaá∆o Apenas para Resumo",3,1)
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY ALLTRIM(vopera) PICTURE "@!"
Sayd(linha,coluna+12,"-"+LEFT(Procura("Ope",1,vopera,"nome"),30),"@!",31)
//Sayd(linha,coluna+LEN(ALLTRIM(vopera)),"-"+Procura("Ope",1,vopera,"nome"),"@!",41)
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION Opeif(linha,coluna,pvar)
********************************************************************************
PRIVATE GetList:={}
IF !EMPTY(&(pvar))
   &(pvar):=Acha2(&(pvar),"Ope",1,2,"codi","nome","@!","@!",15,10,22,76)
   SETCOLOR(vcd)
   @ linha,coluna SAY ALLTRIM(&(pvar)) PICTURE "@!"
   Sayd(linha,coluna+LEN(ALLTRIM(&(pvar))),"-"+Procura("Ope",1,&(pvar),"nome"),"@!",41)
   SETCOLOR(vcn)
ENDIF
IF LASTKEY()==K_ESC
   RETURN .F.
ENDIF
RETURN .T.

********************************************************************************
FUNCTION CodPro(linha,coluna)
********************************************************************************
PRIVATE GetList:={}
vcodpro:=Zeracod(vcodpro)
vcodpro:=Acha2(vcodpro,"Prc",1,2,"codpro","prod","9999999","@!",;
         15,02,22,78,"C¢digo","Produtos")
IF EMPTY(vcodpro) //.OR. LASTKEY()==K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY vcodpro PICTURE "9999999"
Sayd(linha,coluna+7,"-"+Procura("Prc",1,vcodpro,"prod"),"@!",40)
Sayd(linha,coluna+47," "+Procura("Prc",1,vcodpro,"unid"),"@!",2)
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION CodGru(linha,coluna)
********************************************************************************
PRIVATE GetList:={}
vcodgru:=Zeracod(vcodgru)
vcodgru:=Acha2(vcodgru,"Gru",1,2,"codi","nome","@R 99.99","@!",;
         15,02,22,78,"C¢digo","Grupo de Produtos")
IF EMPTY(vcodgru) //.OR. LASTKEY()==K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY vcodgru PICTURE "@R 99.99"
Sayd(linha,coluna+5,"-"+Procura("Gru",1,vcodgru,"nome"),"@!",40)
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION CodLoc(linha,coluna)
********************************************************************************
PRIVATE GetList:={}
vcodloc:=Zeracod(vcodloc)
vcodloc:=Acha2(vcodloc,"Tlo",1,2,"codi","nome","999","@!",;
         15,02,22,78,"C¢digo","Local")
IF EMPTY(vcodloc) .OR. LASTKEY()==K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY vcodloc PICTURE "999"
Sayd(linha,coluna+3,"-"+Procura("Tlo",1,vcodloc,"nome"),"@!",41)
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION Contab(linha,coluna) // Plano de Contas da Contabilidade
********************************************************************************
PRIVATE GetList:={}
vcontab:=Acha2(vcontab,"Plc",1,2,"SUBSTR(codcta,4,12)","titcta","@R 9999.99.99.999-9","@X",15,15,22,76)
IF EMPTY(vcontab).OR.LASTKEY()==K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY vcontab PICTURE "@R 9999.99.99.999-9"
Sayd(linha,coluna+17,Procura("Plc",1,vcontab,"titcta"),"@X",36)
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION Lojas(linha,coluna)
********************************************************************************
PRIVATE GetList:={}
vloja:=Acha2(vloja,"Loja",1,2,"codi","nome","9","@!",15,25,22,56)
IF EMPTY(vloja).OR.LASTKEY()==K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY vloja
Sayd(linha,coluna+1,"-"+Procura("Loja",1,vloja,"nome"),"@!",11)
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION Codgruif(linha,coluna,pcodgru)
********************************************************************************
PRIVATE GetList:={}
IF !EMPTY(&(pcodgru))
   &(pcodgru):=Acha2(&(pcodgru),"Gru",1,2,"codi","nome","@R 99.99","@!",;
   15,02,22,78,"C¢digo","Grupo de Produtos")
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY &(pcodgru) PICTURE "@R 99.99"
Sayd(linha,coluna+5,"-"+Procura("Gru",1,&(pcodgru),"nome"),"@!",41)
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION Lojasif(linha,coluna,ploja)
********************************************************************************
PRIVATE GetList:={}
IF !EMPTY(&ploja)
   &ploja:=Acha2(&ploja,"Loja",1,2,"codi","nome","9","@!",15,25,22,56)
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY &ploja
Sayd(linha,coluna+1,"-"+Procura("Loja",1,&ploja,"nome"),"@!",11)
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION Clienif(linha,coluna,pclien)
********************************************************************************
PRIVATE GetList:={}
IF !EMPTY(&pclien)
   &pclien:=Acha2(&pclien,"Cli",1,2,"codcli","nome","99999","@!",15,02,22,78)
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY &pclien
Sayd(linha,coluna+5,"-"+Procura("Cli",1,&pclien,"nome"),"@!",41)
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION Forneif(linha,coluna,pforne)
********************************************************************************
PRIVATE GetList:={}
IF !EMPTY(&pforne)
   &pforne:=Acha2(&pforne,"For",1,2,"codfor","nome","99999","@!",15,02,22,78)
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY &pforne
Sayd(linha,coluna+5,"-"+Procura("For",1,&pforne,"nome"),"@!",41)
SETCOLOR(vcn)
RETURN .T.

/********************************************************************************
FUNCTION Produif(linha,coluna,pProdu)
********************************************************************************
PRIVATE GetList:={}
IF !EMPTY(&pProdu)
   &pProdu:=Acha2(&pProdu,"Prc",1,2,"codpro","prod","9999999","@!",15,02,22,78)
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY &pProdu
Sayd(linha,coluna+7,"-"+Procura("Prc",1,&pProdu,"prod"),"@!",41)
SETCOLOR(vcn)
RETURN .T.
*/

********************************************************************************
FUNCTION Produif(linha,coluna,varcod,opcod)
********************************************************************************
PRIVATE GetList:={}
IF opcod=NIL
   opcod:="1"
ENDIF
IF !EMPTY(&varcod)
   IF opcod="1" // codpro
      &varcod:=Acha2(&varcod,"Prc",1,2,"codpro","prod","9999999","@!",;
      15,02,22,78,"C¢d.Produto ","Nome do Produto")
   ELSE         // codaux
      &varcod:=Acha2(&varcod,"Prc",3,2,"codaux","prod","9999999","@!",;
      15,02,22,78,"C¢d.Auxiliar","Nome do Produto")
   ENDIF
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY &varcod
IF opcod="1" // codpro
   Sayd(linha,coluna+7,"-"+Procura("Prc",1,&varcod,"prod"),"@!",41)
ELSE         // codaux
   Sayd(linha,coluna+7,"-"+Procura("Prc",3,&varcod,"prod"),"@!",41)
ENDIF
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION Opcod(linha,coluna)
********************************************************************************
PRIVATE GetList:={}
vopcod:=Acha3(vopcod,mopcod,15,15,20,65,"9","@!","Opá∆o","Ordem")
IF EMPTY(vopcod).OR.LASTKEY()==K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY vopcod PICTURE "9"
x:=Mascan(mopcod,1,vopcod)
IF x > 0
   Sayd(linha,coluna+1,"-"+mopcod[x,2],"@!",18)
ENDIF
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION Opfrete(linha,coluna,varcod,mfrete)
********************************************************************************
LOCAL mopfrete:=IF(mfrete=NIL,{{"1","CIF"},{"2","FOB"}},mfrete)
PRIVATE GetList:={}
&varcod:=Acha3(&varcod,mopfrete,15,15,20,65,"9","@!","C¢d.","Frete")
IF EMPTY(&varcod).OR.LASTKEY()==K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY &varcod PICTURE "9"
x:=Mascan(mopfrete,1,&varcod)
IF x > 0
   Sayd(linha,coluna+1,"-"+mopfrete[x,2],"@!",4)
ENDIF
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION Opfatura(linha,coluna,varcod,mfatura)
********************************************************************************
LOCAL mopfatura:=IF(mfatura=NIL,{{"1","∑ VISTA"},{"2","∑ PRAZO"}},mfatura)
PRIVATE GetList:={}
&varcod:=Acha3(&varcod,mopfatura,15,15,20,65,"9","@!","C¢d.","Fatura")
IF EMPTY(&varcod).OR.LASTKEY()==K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY &varcod PICTURE "9"
x:=Mascan(mopfatura,1,&varcod)
IF x > 0
   Sayd(linha,coluna+1,"-"+mopfatura[x,2],"@!",8)
ENDIF
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION OpExerc()
********************************************************************************
LOCAL i, mdir:=mops:={}
PRIVATE GetList:={}
mdir:=DIRECTORY(dirmov+"EC_LA??E.DBF")
FOR i=1 TO LEN(mdir)
   AADD(mops,{SUBSTR(mdir[i,1],6,2),Ano(SUBSTR(mdir[i,1],6,2))})
NEXT
vano:=Acha3(vano,mops,15,25,22,55,"9","@!","Ano","Exerc°cio")
IF EMPTY(vano)
   RETURN .F.
ENDIF
RETURN .T.

********************************************************************************
FUNCTION Lojif(ploja)
********************************************************************************
PRIVATE GetList:={}
IF !EMPTY(&ploja)
   &ploja:=Acha2(&ploja,"Loja",1,2,"codi","nome","9","@!",15,25,22,56)
ENDIF
RETURN .T.

********************************************************************************
FUNCTION Cliif(pcli)
********************************************************************************
PRIVATE GetList:={}
IF !EMPTY(&pcli)
   &pcli:=Acha2(&pcli,"Cli",1,2,"codcli","nome","99999","@!",15,02,22,78)
ENDIF
RETURN .T.

********************************************************************************
FUNCTION Cfoif(pcfop)
********************************************************************************
PRIVATE GetList:={}
IF !EMPTY(&pcfop)
   &pcfop:=Acha2(&pcfop,"Nat",1,2,"codi","nome","@R 9.999","@!",15,02,22,78)
ENDIF
RETURN .T.

********************************************************************************
FUNCTION CodMuni(linha,coluna,puf,pcodmuni)
********************************************************************************
PRIVATE GetList:={}
&pcodmuni:=Acha2(puf+&pcodmuni,"Muni",1,2,"uf+codmuni","uf+munnomex",;
"@R !!-99999","@R !!-!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",;
15,02,22,78,"UF-C¢digo","UF-Nome do Munic°pio")
&pcodmuni:=RIGHT(&pcodmuni,5)
IF EMPTY(&pcodmuni).OR.LASTKEY()==K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY &pcodmuni PICTURE "99999"
Sayd(linha,coluna+5,"-"+Procura("Muni",1,puf+&pcodmuni,"munnomex"),"@!",51)
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION Ddd(linha,coluna)
********************************************************************************
vddd:=FormaDdd(vddd)
SETCOLOR(vcd)
@ linha,coluna SAY vddd
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION Telefone(linha,coluna,pvar)
********************************************************************************
&(pvar):=FormaTel(&(pvar))
SETCOLOR(vcd)
@ linha,coluna SAY &(pvar)
SETCOLOR(vcn)
RETURN .T.

********************************************************************************
FUNCTION CFOP(linha,coluna,pes,pdata,prestringe)
********************************************************************************
PRIVATE GetList:={}
// Valida a existància do CFOP na tabela
vcfop:=Acha2(vcfop,"Nat",1,2,"cfop","nome","@R 9.999","@!",15,10,22,65,"C¢digo","Nome")
Le()
IF EMPTY(vcfop) .OR. LASTKEY()=K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha, coluna SAY vcfop PICTURE "@R 9.999"
Sayd(linha,coluna+5,"-"+Procura("Nat",1,vcfop,"nome"),"@!",41)
SETCOLOR(vcn)
// Valida o Estado (Unidade Federativa)
IF pes=="E"         // se for NF de Entrada
   IF vuf=="EX"
      // se Estado do Remetente=Exterior
      IF !(LEFT(vcfop,1)=="3") // s¢ pode 3.XXx
         Mensagem("CFOP Incompat°vel para Operaá‰es com o Exterior",3,1)
         RETURN .F.
      ENDIF
   ELSE
      IF vuf==Procura("Loja",1,vloja,"esta")
         // se Estado do Remetente=Estado do Emitente
         IF !(LEFT(vcfop,1)=="1") // s¢ pode 1.XXx
            Mensagem("CFOP Incompat°vel para Operaá‰es dentro do Estado",3,1)
            RETURN .F.
         ENDIF
      ELSE
         // se Estado do Remetente#Estado do Emitente
         IF !(LEFT(vcfop,1)=="2") // s¢ pode 2.XXx
            Mensagem("CFOP Incompat°vel para Operaá‰es Interestaduais",3,1)
            RETURN .F.
         ENDIF
      ENDIF
   ENDIF
ENDIF
IF pes=="S"         // se for NF de Sa°da
   IF vuf=="EX"
      // se Estado do Destinat†rio=Exterior
      IF !(LEFT(vcfop,1)=="7") // s¢ pode 7.XXx
         Mensagem("CFOP Incompat°vel para Operaá‰es com o Exterior",3,1)
         RETURN .F.
      ENDIF
   ELSE
      IF vuf==Procura("Loja",1,vloja,"esta")
         // se Estado do Destinat†rio=Estado do Emitente
         IF !(LEFT(vcfop,1)=="5") // s¢ pode 5.XXx
            Mensagem("CFOP Incompat°vel para Operaá‰es dentro do Estado",3,1)
            RETURN .F.
         ENDIF
      ELSE
         // se Estado do Destinat†rio#Estado do Emitente
         IF !(LEFT(vcfop,1)=="6") // s¢ pode 6.XXx
            Mensagem("CFOP Incompat°vel para Operaá‰es Interestaduais",3,1)
            RETURN .F.
         ENDIF
      ENDIF
   ENDIF
ENDIF
// Valida conforme as regras para o per°odo
IF pdata<CTOD("01/01/2003")
   // AtÇ Dezembro/2002 o CFOP era 3 d°gitos
   IF !CFOP3(prestringe)
      RETURN .F.
   ENDIF
ELSE
   // A partir de Janeiro/2003 o CFOP passou a ser 4 d°gitos
   IF !CFOP4(prestringe)
      RETURN .F.
   ENDIF
ENDIF
RETURN .T.

********************************************************************************
FUNCTION CFOP3(restringe)
********************************************************************************
IF LEN(ALLTRIM(vcfop))=4
   Mensagem("CFOP com D°gitos a mais",3,1)
   RETURN .F.
ENDIF
IF restringe
   // Valida o CIC do destinat†rio
   IF LEFT(ALLTRIM(vcic),8)==LEFT(ALLTRIM(Procura("Loja",1,vloja,"cnpj")),8)
      // Destinat†rio: Matriz ou Filial
      mliberados:={"21","22","75","76","92","98","99"} // s¢ pode ser um destes
      IF ASCAN(mliberados,RIGHT(ALLTRIM(vcfop),2))=0
         Mensagem("CFOP Incompat°vel para Operaá‰es de Transferància",3,1)
         RETURN .F.
      ENDIF
   ELSE
      // Destinat†rio: Clientes
      mliberados:={"11","12","31","32","71","72","73","74","91","95","99"}
      IF ASCAN(mliberados,RIGHT(ALLTRIM(vcfop),2))=0
         Mensagem("CFOP N∆o Liberado pela Contabilidade",3,1)
         RETURN .F.
      ENDIF
   ENDIF
   RELEASE mliberados
ENDIF
RETURN .T.

********************************************************************************
FUNCTION CFOP4(restringe)
********************************************************************************
PRIVATE GetList:={}
IF LEN(ALLTRIM(vcfop))=3
   Mensagem("CFOP Antigo de 3 D°gitos",3,1)
   RETURN .F.
ENDIF
IF RIGHT(ALLTRIM(vcfop),2)="00"
   Mensagem("CFOP Apenas para Resumos de Informaá‰es",3,1)
   RETURN .F.
ENDIF
IF restringe
   // Valida o CIC do destinat†rio
   IF LEFT(ALLTRIM(vcic),8)==LEFT(ALLTRIM(Procura("Loja",1,vloja,"cnpj")),8)
      // Destinat†rio: Matriz ou Filial
      mliberados:={"151","152","552","557","920","949"} // s¢ pode ser um destes
      IF ASCAN(mliberados,RIGHT(vcfop,3))=0
         Mensagem("CFOP Incompat°vel para Operaá‰es de Transferància",3,1)
         RETURN .F.
      ENDIF
   ELSE
      // Destinat†rio: Clientes
      mliberados:={"101","102","107","108","109","110","116","117",;
      "118","119","122","123","124","201","202","551","553","556",;
      "901","902","908","910","912","913","914","915","916","920",;
      "921","922","923","924","929","949"}
      //mliberados:={"101","102"}
      IF ASCAN(mliberados,RIGHT(vcfop,3))=0
         Mensagem("CFOP N∆o Liberado pela Contabilidade",3,1)
         RETURN .F.
      ENDIF
   ENDIF
   RELEASE mliberados
ENDIF
// Verifica se o destinat†rio n∆o Ç contribuinte.
mNao:={"CONSU","ISENT"}
IF (vcfop="6101" .OR. vcfop="6102")
   IF (LEN(ALLTRIM(vcic))=11 .OR. ASCAN(mNao,LEFT(vinsc,5))>0)
      Mensagem("CFOP Incompat°vel para Cliente N∆o Contribuinte",3,1)
      RETURN .F.
   ENDIF
ENDIF
// Verifica se o destinat†rio Ç contribuinte.
IF (vcfop="6107" .OR. vcfop="6108")
   IF ASCAN(mNao,LEFT(vinsc,5))=0
      Mensagem("CFOP Incompat°vel para Cliente Contribuinte",3,1)
      RETURN .F.
   ENDIF
ENDIF
// Verifica se Ç Zona Franca ou ALC's.
IF (RIGHT(vcfop,3)="109" .OR. RIGHT(vcfop,3)="110")
   mzona:={"AM","AP","RO"}
   IF ASCAN(mzona,vuf)=0
      Mensagem("CFOP Incompat°vel para Local fora da Zona Franca ou ALC",3,1)
      RETURN .F.
   ENDIF
ENDIF
RETURN .T.

********************************************************************************
FUNCTION Imobilizado(pdata,pcfop)
// Objetivo: Retorna se Ç imobilizado
********************************************************************************
IF YEAR(pdata) < 2003 // cfop de 3 d°gitos
   IF (RIGHT(ALLTRIM(pcfop),2)="91" .OR. RIGHT(ALLTRIM(pcfop),2)="92")
      RETURN .T.
   ELSE
      RETURN .F.
   ENDIF
ELSE                  // cfop de 4 d°gitos
   IF (VAL(RIGHT(pcfop,3)) > 550 .AND. VAL(RIGHT(pcfop,3)) < 556)
      RETURN .T.
   ELSE
      RETURN .F.
   ENDIF
ENDIF

********************************************************************************
FUNCTION Consumo(pdata,pcfop)
// Objetivo: Retorna se Ç consumo
********************************************************************************
IF YEAR(pdata) < 2003 // cfop de 3 d°gitos
   IF (RIGHT(ALLTRIM(pcfop),2)="97" .OR. RIGHT(ALLTRIM(pcfop),2)="98")
      RETURN .T.
   ELSE
      RETURN .F.
   ENDIF
ELSE                  // cfop de 4 d°gitos
   IF (VAL(RIGHT(pcfop,3)) = 556 .OR. VAL(RIGHT(pcfop,3)) = 557)
      RETURN .T.
   ELSE
      RETURN .F.
   ENDIF
ENDIF

********************************************************************************
FUNCTION ValidaCIC(pcic,puf)
// ValidaCIC(<pcic>,[puf]) -> <.T.|.F.>
// Testa a validade do CPF ou CGC em movimentos com mensagens
********************************************************************************
IF puf#NIL
   IF ALLTRIM(puf)=="EX" // exterior
      RETURN .T.
   ENDIF
ENDIF
IF EMPTY(pcic)
   Mensagem("Campo de Preenchimento Obrigat¢rio !",3,1)
   RETURN .F.
ENDIF
IF LEN(ALLTRIM(pcic))=11
   IF pcic="00000000000" .OR. !TestaCPF(pcic)
      Mensagem("CPF Inv†lido!",3,1)
      RETURN .F.
   ENDIF
ELSEIF LEN(ALLTRIM(pcic))=14
   IF pcic="00000000000000" .OR. !TestaCGC(pcic)
      Mensagem("CGC Inv†lido",3,1)
      RETURN .F.
   ENDIF
ELSE
   Mensagem("Quantidade de Caracteres Fora do Padr∆o !",4,1)
   RETURN .F.
ENDIF
RETURN .T.

********************************************************************************
FUNCTION TestaCIC(puf,pcic)
// Testa a validade do CPF ou CGC em movimentos sem mensagens
********************************************************************************
IF ALLTRIM(puf)=="EX" // exterior
   RETURN .T.
ENDIF
IF EMPTY(pcic)
   RETURN .F.
ENDIF
IF LEN(ALLTRIM(pcic))=11
   IF pcic="00000000000" .OR. !TestaCPF(pcic)
      RETURN .F.
   ENDIF
ELSEIF LEN(ALLTRIM(pcic))=14
   IF pcic="00000000000000" .OR. !TestaCGC(pcic)
      RETURN .F.
   ENDIF
ELSE
   RETURN .F.
ENDIF
RETURN .T.

********************************************************************************
FUNCTION PesqCIC(puf,pcic,pmodo)
// Validaá∆o de CIC para Cadastros com mensagens
********************************************************************************
LOCAL vrecatual:=RECNO()
IF ALLTRIM(puf)=="EX" // exterior
   RETURN .T.
ENDIF
IF EMPTY(pcic)
   Mensagem("Campo de Preenchimento Obrigat¢rio !",3,1)
   RETURN .F.
ENDIF
IF LEN(ALLTRIM(pcic))=11
   IF pcic="00000000000" .OR. !TestaCPF(pcic)
      Mensagem("CPF Inv†lido!",3,1)
      RETURN .F.
   ENDIF
ELSEIF LEN(ALLTRIM(pcic))=14
   IF pcic="00000000000000" .OR. !TestaCGC(pcic)
      Mensagem("CGC Inv†lido",3,1)
      RETURN .F.
   ENDIF
ELSE
   Mensagem("Quantidade de Caracteres Fora do Padr∆o !",4,1)
   RETURN .F.
ENDIF
Aviso(24,"Pesquisando a Existància de Outro CIC")
IF ALIAS()="Cli"
   SET ORDER TO 2 // cic
ELSE
   SET ORDER TO 3 // cic
ENDIF
GO TOP
SEEK pcic
IF !EOF()
   IF pmodo=1 .OR. RECNO()#vrecatual
      IF ALIAS()="Cli"
         Mensagem("Cliente J† Cadastrado!",5,1)
      ELSE
         Mensagem("Fornecedor J† Cadastrado!",5,1)
      ENDIF
      @ 24,00 CLEAR
      SET ORDER TO 1
      GO vrecatual
      RETURN .F.
   ENDIF
ENDIF
SET ORDER TO 1
GO vrecatual
@ 24,00 CLEAR
RETURN .T.

**************************************************************************
FUNCTION TestaCGC(pcic2)
// Testa a validade do CGC
******************************************
LOCAL d[12], i, soma:=0
FOR i=1 TO 12
    d[i]=VAL(SUBSTR(pcic2,i,1))
NEXT
// Teste do primeiro d°gito
soma=5*d[1]+4*d[2]+3*d[3]+2*d[4]+9*d[5]+8*d[6]+7*d[7]+6*d[8]+5*d[9];
    +4*d[10]+3*d[11]+2*d[12]
resto1:=soma%11
IF resto1=0 .OR. resto1=1
   pridig:=0
ELSE
   pridig:=11-resto1
ENDIF
// Teste do segundo d°gito
soma:=6*d[1]+5*d[2]+4*d[3]+3*d[4]+2*d[5]+9*d[6]+8*d[7]+7*d[8]+6*d[9];
    +5*d[10]+4*d[11]+3*d[12]+2*pridig
resto2:=soma%11
IF resto2=0 .OR. resto2=1
   segdig:=0
ELSE
   segdig:=11-resto2
ENDIF
IF pridig <> VAL(SUBSTR(pcic2,13,1)) .OR. segdig <> VAL(SUBSTR(pcic2,14,1))
   RETURN(.F.)
ELSE
   RETURN(.T.)
ENDIF

**************************************************************************
FUNCTION TestaCPF(pcic3)
// Testa a validade do CPF
***************************************
LOCAL num:=0, mult:=1, soma:=0, dig:=0
FOR i:=9 TO 1 STEP -1
    num:=VAL(SUBSTR(ALLTRIM(pcic3),i,1))
    mult++
    soma:= soma + num*mult
NEXT
dig:=(soma*10)%11
IF dig = 10
   dig:=0
ENDIF
d1:=dig
num:=0; mult:=1; soma:=0; dig:=0
FOR i:=10 TO 1 STEP -1
    num:=VAL(SUBSTR(ALLTRIM(pcic3),i,1))
    mult++
    soma:= soma + num*mult
NEXT
dig:=(soma*10)%11
IF dig = 10
   dig:=0
ENDIF
d2:=dig
IF d1 <> VAL(SUBSTR(ALLTRIM(pcic3),10,1)) .OR.;
   d2 <> VAL(SUBSTR(ALLTRIM(pcic3),11,1))
   RETURN(.F.)
ELSE
   RETURN(.T.)
ENDIF

********************************************************************************
FUNCTION ValidaIE(puf,pie,pcic)
********************************************************************************
/* Validaá∆o de Inscriá∆o Estadual com mensagens
   Parametros    : puf: 2 caracteres,maiusculo,unidade federativa
                   pie: tam.variavel,alfanumerico,insc.estadual
                   pcic:tam.variavel,alfanumerico,cpf ou cnpj
   Retorno       : Logico */
********************************************************************************
IF ALLTRIM(puf)=="EX" // exterior
   RETURN .T.
ENDIF
IF ASCAN(muf,puf)=0
   Mensagem("Estado N∆o Encontrado !",3,1)
   RETURN .F.
ENDIF
//vinsc:=FormaIE(vinsc)
IF EMPTY(pie)
   Mensagem("Campo de Preencimento Obrigat¢rio !",3,1)
   RETURN .F.
ENDIF
IF ALLTRIM(pie)=="ISENTO"
   IF !TestaCGC(pcic)
      Mensagem("CGC Inv†lido",3,1)
      RETURN .F.
   ELSE
      RETURN .T.
   ENDIF
ENDIF
IF ALLTRIM(pie)="CONSUMO"
   IF !TestaCPF(pcic)
      Mensagem("CPF Inv†lido",3,1)
      RETURN .F.
   ELSE
      RETURN .T.
   ENDIF
ENDIF
IF !TestaIE(puf,pie)
   Mensagem("Inscriá∆o Estadual Inv†lida !",3,1)
   RETURN .F.
ENDIF
RETURN .T.

********************************************************************************
FUNCTION TestaIE(puf2,pie2)
********************************************************************************
/* Testa a Validaá∆o de Inscriá∆o Estadual sem mensagens
   Parametros    : puf2: 2 caracteres,maiusculo,unidade federativa
                   pie2: tam.variavel,alfanumerico,insc.estadual
   Retorno       : Logico
   Desenvolvedor : Machado, Paulo H.S. - phmach@terra.com.br */
********************************************************************************
LOCAL ok:=.F.,base,vpos,valg,vsom,vres,vdig1,vdig2,vpro,p,d,n,vbase2,origem
vbase2:=base:=origem:=""
FOR vpos:=1 TO LEN(ALLTRIM(pie2))
    IF SUBSTR(pie2,vpos,1)$"0123456789P"
       origem+=SUBSTR(pie2,vpos,1)
    ENDIF
NEXT
mascara:="99999999999999"
IF puf2=="AC"
   mascara:="99,99,9999-9"
   base   :=PADR(origem,9,"0")
   IF LEFT(base,2)=="01" .AND. SUBSTR(base,3,2)<>"00"
      vsom:=0
      FOR vpos:=1 TO 8
          valg:=VAL(SUBSTR(base,vpos,1))
          valg:=valg*(10-vpos)
          vsom+=valg
      NEXT
      vres  :=vsom%11
      vdig1 :=STR(IF(vres<2,0,11-vres),1,0)
      vbase2:=LEFT(base,8)+vdig1
      ok    :=(vbase2==origem)
   ENDIF
ELSEIF puf2=="AL"
   mascara:="999999999"
   base   :=PADR(origem,9,"0")
   IF LEFT(base,2)=="24"
      vsom:=0
      FOR vpos:=1 TO 8
          valg:=VAL(SUBSTR(base,vpos,1))
          valg:=valg*(10-vpos)
          vsom+=valg
      NEXT
      vpro  :=vsom*10
      vres  :=vpro%11
      vdig1 :=IF(vres==10,"0",STR(vres,1,0))
      vbase2:=LEFT(base,8)+vdig1
      ok    :=(vbase2==origem)
   ENDIF
ELSEIF puf2=="AM"
   mascara:="99,999,999-9"
   base   :=PADR(origem,9,"0")
   vsom   :=0
   FOR vpos:=1 TO 8
       valg:=VAL(SUBSTR(base,vpos,1))
       valg:=valg*(10-vpos)
       vsom+=valg
   NEXT
   IF vsom<11
      vdig1:=STR(11-vsom,1,0)
   ELSE
      vres :=vsom%11
      vdig1:=IF(vres<2,"0",STR(11-vres,1,0))
   ENDIF
   vbase2:=LEFT(base,8)+vdig1
   ok    :=(vbase2==origem)
ELSEIF puf2=="AP"
   mascara:="999999999"
   base   :=PADR(origem,9,"0")
   IF LEFT(base,2)=="03"
      n:=VAL(LEFT(base,8))
      IF     n>=3000001 .AND. n<=3017000
         p:=5
         d:=0
      ELSEIF n>=3017001 .AND. n<=3019022
         p:=9
         d:=1
      ELSEIF n>=3019023
         p:=0
         d:=0
      ENDIF
      vsom:=p
      FOR vpos:=1 TO 8
          valg:=VAL(SUBSTR(base,vpos,1))
          valg:=valg*(10-vpos)
          vsom+=valg
      NEXT
      vres :=vsom%11
      vdig1:=11-vres
      IF vdig1==10
         vdig1:=0
      ELSEIF vdig1==11
         vdig1:=d
      ENDIF
      vdig1 :=STR(vdig1,1,0)
      vbase2:=LEFT(base,8)+vdig1
      ok    :=(vbase2==origem)
   ENDIF
ELSEIF puf2=="BA"
   mascara:="999999-99"
   base   :=PADR(origem,8,"0")
   IF LEFT(base,1)$"0123458"
      vsom:=0
      FOR vpos:=1 TO 6
          valg:=VAL(SUBSTR(base,vpos,1))
          valg:=valg*(8-vpos)
          vsom+=valg
      NEXT
      vres  :=vsom%10
      vdig2 :=STR(IF(vres==0,0,10-vres),1,0)
      vbase2:=LEFT(base,6)+vdig2
      vsom  :=0
      FOR vpos:=1 TO 7
          valg:=VAL(SUBSTR(vbase2,vpos,1))
          valg:=valg*(9-vpos)
          vsom+=valg
      NEXT
      vres :=vsom%10
      vdig1:=STR(IF(vres==0,0,10-vres),1,0)
   ELSE
      vsom:=0
      FOR vpos:=1 TO 6
          valg:=VAL(SUBSTR(base,vpos,1))
          valg:=valg*(8-vpos)
          vsom+=valg
      NEXT
      vres  :=vsom%11
      vdig2 :=STR(IF(vres<2,0,11-vres),1,0)
      vbase2:=LEFT(base,6)+vdig2
      vsom  :=0
      FOR vpos:=1 TO 7
          valg:=VAL(SUBSTR(vbase2,vpos,1))
          valg:=valg*(9-vpos)
          vsom+=valg
      NEXT
      vres :=vsom%11
      vdig1:=STR(IF(vres<2,0,11-vres),1,0)
   ENDIF
   vbase2:=LEFT(base,6)+vdig1+vdig2
   ok:=(vbase2==origem)
ELSEIF puf2=="CE"
   mascara:="99999999-9"
   base   :=PADR(origem,9,"0")
   vsom   :=0
   FOR vpos:=1 TO 8
       valg:=VAL(SUBSTR(base,vpos,1))
       valg:=valg*(10-vpos)
       vsom+=valg
   NEXT
   vres :=vsom%11
   vdig1:=11-vres
   IF vdig1>9;vdig1:=0;ENDIF
   vbase2:=LEFT(base,8)+STR(vdig1,1,0)
   ok    :=(vbase2==origem)
ELSEIF puf2=="DF"
   mascara:="999,99999,999-99"
   base   :=PADR(origem,13,"0")
   IF LEFT(base,3)=="073"
      vsom:=0
      vmul:={4,3,2,9,8,7,6,5,4,3,2}
      FOR vpos:=1 TO 11
          valg:=VAL(SUBSTR(base,vpos,1))
          valg:=valg*vmul[vpos]
          vsom+=valg
      NEXT
      vres  :=vsom%11
      vdig1 :=IF(vres<2,0,11-vres)
      vbase2:=LEFT(base,11)+STR(vdig1,1,0)
      vsom  :=0
      vmul  :={5,4,3,2,9,8,7,6,5,4,3,2}
      FOR vpos:=1 TO 12
          valg:=VAL(SUBSTR(vbase2,vpos,1))
          valg:=valg*vmul[vpos]
          vsom+=valg
      NEXT
      vres  :=vsom%11
      vdig2 :=IF(vres<2,0,11-vres)
      vbase2+=STR(vdig2,1,0)
      ok    :=(vbase2==origem)
   ENDIF
ELSEIF puf2=="ES"
   mascara:="999999999"
   base   :=PADR(origem,9,"0")
   vsom   :=0
   FOR vpos:=1 TO 8
       valg:=VAL(SUBSTR(base,vpos,1))
       valg:=valg*(10-vpos)
       vsom+=valg
   NEXT
   vres  :=vsom%11
   vdig1 :=STR(IF(vres<2,0,11-vres),1,0)
   vbase2:=LEFT(base,8)+vdig1
   ok    :=(vbase2==origem)
ELSEIF puf2=="GO"
   mascara:="99,999,999-9"
   base   :=PADR(origem,9,"0")
   IF LEFT(base,2)$"10,11,15"
      vsom:=0
      FOR vpos:=1 TO 8
          valg:=VAL(SUBSTR(base,vpos,1))
          valg:=valg*(10-vpos)
          vsom+=valg
      NEXT
      vres:=vsom%11
      IF vres==0
         vdig1:="0"
      ELSEIF vres==1
         n    :=VAL(LEFT(base,8))
         vdig1:=IF(n>=10103105 .AND. n<=10119997,"1","0")
      ELSE
         vdig1:=STR(11-vres,1,0)
      ENDIF
      vbase2:=LEFT(base,8)+vdig1
      ok    :=(vbase2==origem)
   ENDIF
ELSEIF puf2=="MA"
   mascara:="999999999"
   base   :=PADR(origem,9,"0")
   IF LEFT(base,2)=="12"
      vsom:=0
      FOR vpos:=1 TO 8
          valg:=VAL(SUBSTR(base,vpos,1))
          valg:=valg*(10-vpos)
          vsom+=valg
      NEXT
      vres  :=vsom%11
      vdig1 :=STR(IF(vres<2,0,11-vres),1,0)
      vbase2:=LEFT(base,8)+vdig1
      ok    :=(vbase2==origem)
   ENDIF
ELSEIF puf2=="MT"
   mascara:="9999999999-9"
   vmul   :={3,2,9,8,7,6,5,4,3,2}
   vsom:=0
   FOR vpos:=1 TO 10
       valg:=VAL(SUBSTR(base,vpos,1))
       valg:=valg*vmul[vpos]
       vsom+=valg
   NEXT
   vres  :=vsom%11
   vdig1 :=IF(vres<2,0,11-vres)
   vbase2:=LEFT(base,10)+STR(vdig1,1,0)
   ok    :=(vbase2==origem)
ELSEIF puf2=="MS"
   mascara:="999999999"
   base   :=PADR(origem,9,"0")
   IF LEFT(base,2)=="28"
      vsom:=0
      FOR vpos:=1 TO 8
          valg:=VAL(SUBSTR(base,vpos,1))
          valg:=valg*(10-vpos)
          vsom+=valg
      NEXT
      vres  :=vsom%11
      vdig1 :=STR(IF(vres<2,0,11-vres),1,0)
      vbase2:=LEFT(base,8)+vdig1
      ok    :=(vbase2==origem)
   ENDIF
ELSEIF puf2=="MG"
   mascara:="999,999,999/9999"
   base   :=PADR(origem,13,"0")
   vbase2 :=LEFT(base,3)+"0"+SUBSTR(base,4,8)
   n      :=2
   vsom   :=""
   FOR vpos:=1 TO 12
       valg:=VAL(SUBSTR(vbase2,vpos,1))
       n   :=IF(n==2,1,2)
       valg:=ALLTRIM(STR(valg*n,2,0))
       vsom+=valg
   NEXT
   n     :=0
   FOR vpos:=1 TO LEN(vsom);n+=VAL(SUBSTR(vsom,vpos,1));NEXT
   vsom  :=n
   DO WHILE RIGHT(STR(n,3,0),1)<>"0";n++;enddo
   vdig1 :=STR(n-vsom,1,0)
   vbase2:=LEFT(base,11)+vdig1
   vsom  :=0
   vmul  :={3,2,11,10,9,8,7,6,5,4,3,2}
   FOR vpos:=1 TO 12
       valg:=VAL(SUBSTR(vbase2,vpos,1))
       valg:=valg*vmul[vpos]
       vsom+=valg
   NEXT
   vres  :=vsom%11
   vdig2 :=IF(vres<2,0,11-vres)
   vbase2+=STR(vdig2,1,0)
   ok    :=(vbase2==origem)
ELSEIF puf2=="PA"
   mascara:="99-999999-9"
   base   :=PADR(origem,9,"0")
   IF LEFT(base,2)=="15"
      vsom:=0
      FOR vpos:=1 TO 8
          valg:=VAL(SUBSTR(base,vpos,1))
          valg:=valg*(10-vpos)
          vsom+=valg
      NEXT
      vres  :=vsom%11
      vdig1 :=STR(IF(vres<2,0,11-vres),1,0)
      vbase2:=LEFT(base,8)+vdig1
      ok    :=(vbase2==origem)
   ENDIF
ELSEIF puf2=="PB"
   mascara:="99,999,999-9"
   base   :=PADR(origem,9,"0")
   vsom   :=0
   FOR vpos:=1 TO 8
       valg:=VAL(SUBSTR(base,vpos,1))
       valg:=valg*(10-vpos)
       vsom+=valg
   NEXT
   vres  :=vsom%11
   vdig1 :=11-vres
   IF vdig1>9;vdig1:=0;ENDIF
   vbase2:=LEFT(base,8)+STR(vdig1,1,0)
   ok    :=(vbase2==origem)
ELSEIF puf2=="PE"
   mascara:="99,9,999,9999999-9"
   base   :=PADR(origem,14,"0")
   vsom   :=0
   vmul   :={5,4,3,2,1,9,8,7,6,5,4,3,2}
   FOR vpos:=1 TO 13
       valg:=VAL(SUBSTR(base,vpos,1))
       valg:=valg*vmul[vpos]
       vsom+=valg
   NEXT
   vres  :=vsom%11
   vdig1 :=11-vres
   IF(vdig1>9,vdig1-=10,)
   vbase2:=LEFT(base,13)+STR(vdig1,1,0)
   ok    :=(vbase2==origem)
ELSEIF puf2=="PI"
   mascara:="999999999"
   base   :=PADR(origem,9,"0")
   vsom   :=0
   FOR vpos:=1 TO 8
       valg:=VAL(SUBSTR(base,vpos,1))
       valg:=valg*(10-vpos)
       vsom+=valg
   NEXT
   vres  :=vsom%11
   vdig1 :=STR(IF(vres<2,0,11-vres),1,0)
   vbase2:=LEFT(base,8)+vdig1
   ok    :=(vbase2==origem)
ELSEIF puf2=="PR"
   mascara:="999,99999-99"
   base   :=PADR(origem,10,"0")
   vsom   :=0
   vmul   :={3,2,7,6,5,4,3,2}
   FOR vpos:=1 TO 8
       valg:=VAL(SUBSTR(base,vpos,1))
       valg:=valg*vmul[vpos]
       vsom+=valg
   NEXT
   vres  :=vsom%11
   vdig1 :=STR(IF(vres<2,0,11-vres),1,0)
   vbase2:=LEFT(base,8)+vdig1
   vsom  :=0
   vmul  :={4,3,2,7,6,5,4,3,2}
   FOR vpos:=1 TO 9
       valg:=VAL(SUBSTR(vbase2,vpos,1))
       valg:=valg*vmul[vpos]
       vsom+=valg
   NEXT
   vres  :=vsom%11
   vdig2 :=STR(IF(vres<2,0,11-vres),1,0)
   vbase2+=vdig2
   ok    :=(vbase2==origem)
ELSEIF puf2=="RJ"
   mascara:="99,999,99-9"
   base   :=PADR(origem,8,"0")
   vsom   :=0
   vmul   :={2,7,6,5,4,3,2}
   FOR vpos:=1 TO 7
       valg:=VAL(SUBSTR(base,vpos,1))
       valg:=valg*vmul[vpos]
       vsom+=valg
   NEXT
   vres  :=vsom%11
   vdig1 :=STR(IF(vres<2,0,11-vres),1,0)
   vbase2:=LEFT(base,7)+vdig1
   ok    :=(vbase2==origem)
ELSEIF puf2=="RN"
   mascara:="99,999,999-9"
   base   :=PADR(origem,9,"0")
   IF LEFT(base,2)=="20"
      vsom:=0
      FOR vpos:=1 TO 8
          valg:=VAL(SUBSTR(base,vpos,1))
          valg:=valg*(10-vpos)
          vsom+=valg
      NEXT
      vpro  :=vsom*10
      vres  :=vpro%11
      vdig1 :=STR(IF(vres>9,0,vres),1,0)
      vbase2:=LEFT(base,8)+vdig1
      ok    :=(vbase2==origem)
   ENDIF
ELSEIF puf2=="RO"
   mascara:="9999999999999-9"
   base   :=PADR(origem,13,"0")
   vsom   :=0
   FOR vpos:=1 TO 5
       valg:=VAL(SUBSTR(base,vpos,1))
       valg:=valg*(7-vpos)
       vsom+=valg
   NEXT
   FOR vpos:=6 TO 13
       valg:=VAL(SUBSTR(base,vpos,1))
       valg:=valg*(15-vpos)
       vsom+=valg
   NEXT
   vres  :=vsom%11
   vdig1 :=11-vres
   IF vdig1>9;vdig1-=10;ENDIF
   base:=base+STR(vdig1,1,0)
   ok    :=(base==origem)
ELSEIF puf2=="RR"
   mascara:="99999999-9"
   base   :=PADR(origem,9,"0")
   IF LEFT(base,2)=="24"
      vsom:=0
      FOR vpos:=1 TO 8
          valg:=VAL(SUBSTR(base,vpos,1))
          valg:=valg*vpos
          vsom+=valg
      NEXT
      vres  :=vsom%9
      vdig1 :=STR(vres,1,0)
      vbase2:=LEFT(base,8)+vdig1
      ok    :=(vbase2==origem)
   ENDIF
ELSEIF puf2=="RS"
   mascara:="999/999999-9"
   base   :=PADR(origem,10,"0")
   n      :=VAL(LEFT(base,3))
   IF n>0 .AND. n<468
      vsom:=0
      vmul:={2,9,8,7,6,5,4,3,2}
      FOR vpos:=1 TO 9
          valg:=VAL(SUBSTR(base,vpos,1))
          valg:=valg*vmul[vpos]
          vsom+=valg
      NEXT
      vres  :=vsom%11
      vdig1 :=11-vres
      IF vdig1>9;vdig1:=0;ENDIF
      vbase2:=LEFT(base,9)+STR(vdig1,1,0)
      ok    :=(vbase2==origem)
   ENDIF
ELSEIF puf2=="SC"
   mascara:="999,999,999"
   base   :=PADR(origem,9,"0")
   vsom   :=0
   FOR vpos:=1 TO 8
       valg:=VAL(SUBSTR(base,vpos,1))
       valg:=valg*(10-vpos)
       vsom+=valg
   NEXT
   vres  :=vsom%11
   vdig1 :=IF(vres<2,"0",STR(11-vres,1,0))
   vbase2:=LEFT(base,8)+vdig1
   ok    :=(vbase2==origem)
ELSEIF puf2=="SE"
   mascara:="99999999-9"
   base   :=PADR(origem,9,"0")
   vsom   :=0
   FOR vpos:=1 TO 8
       valg:=VAL(SUBSTR(base,vpos,1))
       valg:=valg*(10-vpos)
       vsom+=valg
   NEXT
   vres  :=vsom%11
   vdig1 :=11-vres
   IF vdig1>9;vdig1:=0;ENDIF
   vbase2:=LEFT(base,8)+STR(vdig1,1,0)
   ok    :=(vbase2==origem)
ELSEIF puf2=="SP"
   IF LEFT(base,1)=="P"
      mascara:="P-99999999,9/999"
      base   :=PADR(origem,13,"0")
      vbase2 :=SUBSTR(base,2,8)
      vsom   :=0
      vmul   :={1,3,4,5,6,7,8,10}
      FOR vpos:=1 TO 8
          valg:=VAL(SUBSTR(vbase2,vpos,1))
          valg:=valg*vmul[vpos]
          vsom+=valg
      NEXT
      vres  :=vsom%11
      vdig1 :=RIGHT(STR(vres,2,0),1)
      vbase2:=LEFT(base,9)+vdig1+SUBSTR(base,11,3)
   ELSE
      mascara:="999,999,999,999"
      base   :=PADR(origem,12,"0")
      vsom   :=0
      vmul   :={1,3,4,5,6,7,8,10}
      FOR vpos:=1 TO 8
          valg:=VAL(SUBSTR(base,vpos,1))
          valg:=valg*vmul[vpos]
          vsom+=valg
      NEXT
      vres  :=vsom%11
      vdig1 :=RIGHT(STR(vres,2,0),1)
      vbase2:=LEFT(base,8)+vdig1+SUBSTR(base,10,2)
      vsom  :=0
      vmul  :={3,2,10,9,8,7,6,5,4,3,2}
      FOR vpos:=1 TO 11
          valg:=VAL(SUBSTR(vbase2,vpos,1))
          valg:=valg*vmul[vpos]
          vsom+=valg
      NEXT
      vres  :=vsom%11
      vdig2 :=RIGHT(STR(vres,2,0),1)
      vbase2+=vdig2
   ENDIF
   ok:=(vbase2==origem)
ELSEIF puf2=="TO"
   // ver com a SEFAZ-TO
   mascara:="99,999,999-9"
   base   :=PADR(origem,9,"0")
   vbase2 :=LEFT(base,8)
   vsom   :=0
   FOR vpos:=1 TO 8
      valg:=VAL(SUBSTR(vbase2,vpos,1))
      valg:=valg*(10-vpos)
      vsom+=valg
   NEXT
   vres   :=vsom%11
   vdig1  :=STR(IF(vres<2,0,11-vres),1,0)
   vbase2 :=LEFT(base,8)+vdig1
   ok     :=(vbase2==origem)
   /*
   mascara:="99,99,999999-9"
   base   :=PADR(origem,11,"0")
   IF SUBSTR(base,3,2)$"01,02,03,99"
      vbase2:=LEFT(base,2)+SUBSTR(base,5,6)
      vsom  :=0
      FOR vpos:=1 TO 8
          valg:=VAL(SUBSTR(vbase2,vpos,1))
          valg:=valg*(10-vpos)
          vsom+=valg
      NEXT
      vres  :=vsom%11
      vdig1 :=STR(IF(vres<2,0,11-vres),1,0)
      vbase2:=LEFT(base,10)+vdig1
      ok    :=(vbase2==origem)
   ENDIF
   */
ENDIF
IF !ok
   RETURN .F.
ENDIF
RETURN .T.


// ### ROTINAS DE USO GERAL v2.2

********************************************************************************
FUNCTION Impar(pnum)
********************************************************************************
LOCAL vresto:=pnum % 2
RETURN IF(vresto>0,.T.,.F.)

********************************************************************************
FUNCTION Par(pnum)
********************************************************************************
LOCAL vresto:=pnum % 2
RETURN IF(vresto=0,IF(pnum=0,.F.,.T.),.F.)

********************************************************************************
FUNCTION Limpa(linha,coluna,tamanho)
*******************************************************************************
@ linha,coluna SAY SPACE(tamanho)
RETURN .T.

**************************************************************************
FUNCTION FormaDdd(pddd)
*******************************************************************************
RETURN REPLICATE(" ",4-LEN(ALLTRIM(pddd)))+ALLTRIM(pddd)

**************************************************************************
FUNCTION FormaTel(ptel)
*******************************************************************************
RETURN REPLICATE(" ",8-LEN(ALLTRIM(ptel)))+ALLTRIM(ptel)

**************************************************************************
FUNCTION FormaIE(pie)
*******************************************************************************
pie:=STRTRAN(pie,".","")
pie:=STRTRAN(pie,"-","")
pie:=STRTRAN(pie,"/","")
RETURN ALLTRIM(pie)+REPLICATE(" ",14-LEN(ALLTRIM(pie)))

*******************************************************************************
FUNCTION MaskCIC(pcic)
*******************************************************************************
IF LEN(ALLTRIM(pcic))=11
   RETURN "@R 999.999.999-99"
ELSEIF LEN(ALLTRIM(pcic))=14
   RETURN "@R 99.999.999/9999-99"
ELSE
   RETURN "@!"
ENDIF

*******************************************************************************
FUNCTION MaskIE(puf,pie)
*******************************************************************************
LOCAL mascara
IF VAL(ALLTRIM(pie))=0
   RETURN "@!"
ENDIF
IF puf=="AC"
   mascara:="@R 99.99.9999-9"
ELSEIF puf=="AL"
   mascara:="@R 999999999"
ELSEIF puf=="AM"
   mascara:="@R 99.999.999-9"
ELSEIF puf=="AP"
   mascara:="@R 999999999"
ELSEIF puf=="BA"
   mascara:="@R 999999-99"
ELSEIF puf=="CE"
   mascara:="@R 99999999-9"
ELSEIF puf=="DF"
   mascara:="@R 999.99999.999-99"
ELSEIF puf=="ES"
   mascara:="@R 999999999"
ELSEIF puf=="GO"
   mascara:="@R 99.999.999-9"
ELSEIF puf=="MA"
   mascara:="@R 999999999"
ELSEIF puf=="MT"
   mascara:="@R 9999999999-9"
ELSEIF puf=="MS"
   mascara:="@R 999999999"
ELSEIF puf=="MG"
   mascara:="@R 999.999.999/9999"
ELSEIF puf=="PA"
   mascara:="@R 99-999999-9"
ELSEIF puf=="PB"
   mascara:="@R 99.999.999-9"
ELSEIF puf=="PE"
   mascara:="@R 99.9.999.9999999-9"
ELSEIF puf=="PI"
   mascara:="@R 999999999"
ELSEIF puf=="PR"
   mascara:="@R 999.99999-99"
ELSEIF puf=="RJ"
   mascara:="@R 99.999.99-9"
ELSEIF puf=="RN"
   mascara:="@R 99.999.999-9"
ELSEIF puf=="RO"
   mascara:="@R 9999999999999-9"
ELSEIF puf=="RR"
   mascara:="@R 99999999-9"
ELSEIF puf=="RS"
   mascara:="@R 999/999999-9"
ELSEIF puf=="SC"
   mascara:="@R 999.999.999"
ELSEIF puf=="SE"
   mascara:="@R 99999999-9"
ELSEIF puf=="SP"
   IF LEFT(pie,1)=="P"
      mascara:="@R P-99999999.9/999"
   ELSE
      mascara:="@R 999.999.999.999"
   ENDIF
ELSEIF puf=="TO"
   mascara:="@R 99.999.999-9"
ENDIF
RETURN mascara

********************************************************************************
PROCEDURE Dataseis(pdata)
// Converte uma data do formato DD/MM/AA(AA) para o formato "DDMMAA(AA)"
********************************************************************************
RETURN STRTRAN(DTOC(pdata),"/","")

********************************************************************************
PROCEDURE Tiraponto(pvalor,ptam)
// Converte um valor do formato 9999.99 para o formato "0000999999"
********************************************************************************
LOCAL vvalc:=ALLTRIM(STRTRAN(STR(pvalor),".",""))
RETURN REPLICATE("0",ptam-LEN(vvalc))+vvalc

********************************************************************************
PROCEDURE Valer(cvalor)
// Converte um valor do formato "999.999,99" para o formato 999999.99
********************************************************************************
LOCAL valor:=ALLTRIM(STRTRAN(cvalor,".",""))
valor:=STRTRAN(valor,",",".")
RETURN VAL(valor)

********************************************************************************
PROCEDURE TiraAcento(pnome)
// Converte um nome tirando acentuaá∆o
// Ex.: de "S«O PAULO" para "SAO PAULO"
********************************************************************************
pnome:=STRTRAN(pnome,"∆","A")
pnome:=STRTRAN(pnome,"†","A")
pnome:=STRTRAN(pnome,"‰","O")
pnome:=STRTRAN(pnome,"¢","O")
pnome:=STRTRAN(pnome,"°","I")
pnome:=STRTRAN(pnome,"Ç","E")
pnome:=STRTRAN(pnome,"á","C")
pnome:=STRTRAN(pnome,"«","A")
pnome:=STRTRAN(pnome,"µ","A")
pnome:=STRTRAN(pnome,"Â","O")
pnome:=STRTRAN(pnome,"‡","O")
pnome:=STRTRAN(pnome,"÷","I")
pnome:=STRTRAN(pnome,"ê","E")
pnome:=STRTRAN(pnome,"Ä","C")
RETURN pnome

********************************************************************************
PROCEDURE DV(pnum)
// Calcula o d°gito verificador para o Nosso N£mero (M¢dulo 11)
// ParÉmetro: pnum - nosso numero (em Caracter com 11 algarismos)
********************************************************************************
LOCAL d01,d02,d03,d04,d05,d06,d07,d08,d09,d10,d11
LOCAL m01,m02,m03,m04,m05,m06,m07,m08,m09,m10,m11
LOCAL vnumtotal,vdv
// Pega o d°gito da direita p/ esquerda
d01:=SUBSTR(pnum,11,1)
d02:=SUBSTR(pnum,10,1)
d03:=SUBSTR(pnum,9,1)
d04:=SUBSTR(pnum,8,1)
d05:=SUBSTR(pnum,7,1)
d06:=SUBSTR(pnum,6,1)
d07:=SUBSTR(pnum,5,1)
d08:=SUBSTR(pnum,4,1)
d09:=SUBSTR(pnum,3,1)
d10:=SUBSTR(pnum,2,1)
d11:=SUBSTR(pnum,1,1)
// Multiplica pelos pesos (9 atÇ 2)
m01:=VAL(d01)*9
m02:=VAL(d02)*8
m03:=VAL(d03)*7
m04:=VAL(d04)*6
m05:=VAL(d05)*5
m06:=VAL(d06)*4
m07:=VAL(d07)*3
m08:=VAL(d08)*2
m09:=VAL(d09)*9
m10:=VAL(d10)*8
m11:=VAL(d11)*7
// Soma os multiplos
vnumtotal:=m01+m02+m03+m04+m05+m06+m07+m08+m09+m10+m11
// Calcula o resto da divis∆o do total por 11
vdv:=vnumtotal % 11
vdv:=IF(vdv=10,"X",STR(vdv,1))
RETURN (vdv)

********************************************************************************
FUNCTION Encerrado(pdata)
// Verifica se o mes do parÉmetro pdata consta no arquivo de encerramento
********************************************************************************
LOCAL vareatu, vanomesqui
vareatu:=SELECT()
vanomesqui:=STR(YEAR(pdata),4)+STRZERO(MONTH(pdata),2)+IF(DAY(pdata) < 16,"1","2")
SELECT Ept
SEEK vanomesqui
IF FOUND()
   Mensagem("Per°odo de Trabalho Encerrado !",3,1)
   SELECT(vareatu)
   RETURN .T.
ENDIF
SELECT(vareatu)
RETURN .F.

********************************************************************************
FUNCTION ValidaPar(ppar1)
// Objetivo: Validar os ParÉmetros de Execuá∆o do Sistema
// ParÉmetros: ppar1 - ParÉmetro externo
// Obs: ppar tem a seguinte ordem: ABCDD
//      A  - Empresa
//      B  - Loja
//      C  - Setor
//      DD - Ano ou Exerc°cio
********************************************************************************
PRIVATE vemp,vloja,vsetor,vano
// Exibiá∆o do nome do sistema
SetConsoleTitle(cNmSist)
// Definiá∆o dos diret¢rios de trabalho
dirvm:=""
dircad:=".\CAD\"
dirmov:=".\EMP0\"
// Se n∆o existir o diret¢rio de cadastros
IF !FILE(dircad+"NUL")
   Mensagem("N∆o Foi Encontrado o Diret¢rio de Cadastros",3,1)
   RETURN .F.
ENDIF
// Se n∆o existir os arquivos de °ndices das Empresas, Lojas e Munic°pios
IF !FILE((dircad+"WM_LOJA1.CDX"))
   // Abertura dos arquivos de Dados (Sem °ndices)
   marqs:={;
   {(dircad+"WM_EMPRE.DBF"),"Emp","Empresas",0},;
   {(dircad+"WM_LOJAS.DBF"),"Loja","Lojas",0},;
   {(dircad+"EC_MUNIC.DBF"),"Muni","Munic°pios",0}}
   IF !AbreArqs(marqs,.T.) // em modo exclusivo
      RETURN .F.
   ENDIF
   // Cria os °ndices
   SETCOLOR(vcp)
   Aviso(24,"Criando os Indices de Empresas, Lojas e Munic°pios. Aguarde...")
   SETCOLOR(vcn)
   SELECT Loja
   PACK
   INDEX ON codi TO (dircad+"WM_LOJA1")
   INDEX ON nome TO (dircad+"WM_LOJA2")
   SELECT Emp
   PACK
   INDEX ON codi TO (dircad+"WM_EMPR1")
   INDEX ON nome TO (dircad+"WM_EMPR2")
   SELECT Muni
   PACK
   INDEX ON uf+codmuni TO (dircad+"EC_MUNI1")
   INDEX ON uf+munnomex TO (dircad+"EC_MUNI2")
   CLOSE DATABASE
ENDIF
// Abertura do arquivo de Dados (Com °ndices)
marqs:={;
{(dircad+"WM_EMPRE.DBF"),"Emp","Empresas",2},;
{(dircad+"WM_LOJAS.DBF"),"Loja","Lojas",2},;
{(dircad+"EC_MUNIC.DBF"),"Muni","Munic°pios",2}}
IF !AbreArqs(marqs,.F.) // em modo compartilhado
   RETURN .F.
ENDIF
SELECT Loja
// Se n∆o for passado os parÉmetros na linha de execuá∆o
IF ppar1=Nil
   // Solicita ao usu†rio que informe
   Caixa2(08,10,17,70,frame[6])
   SETCOLOR(vci)
   @ 09,11 SAY PADC("SIG - SISTEMA DE INFORMAÄÂES GERENCIAIS",59)
   @ 10,11 SAY PADC("Abertura do M¢dulo: "+modulo+" "+Versao(),59)
   SETCOLOR(vcn)
   @ 12,11 SAY "Data....:"
   @ 13,11 SAY "Empresa.:"
   @ 14,11 SAY "Loja....:"
   @ 15,11 SAY "Setor...:"
   IF modulo="EC"
      @ 16,11 SAY "Ano.....:"
   ENDIF
   Aviso(24,"Digite os Dados Para Abertura do Sistema")
   SETCOLOR("GR+/N")
   @ 12,21 SAY ALLTRIM(Dds(DATE()))+","+Dataext(DATE())
   // Inicializaá∆o das variaveis auxiliares
   vemp:=vloja:=SPACE(1)
   vsetor:=1
   vano:=SPACE(2)
   // Ediá∆o dos parÉmetros
   SETCOLOR(vcd)
   @ 13,21 GET vemp PICTURE "9" VALID ValidaEmp(13,21)
   @ 14,21 GET vloja PICTURE "9" VALID Lojas(14,21)
   @ 15,21 GET vsetor PICTURE "9" VALID (vsetor > 0 .AND. vsetor < 6)
   @ 16,21 GET vano PICTURE "99" WHEN modulo="EC" VALID !EMPTY(vano)
   Le()
   IF LASTKEY()==K_ESC
      CLOSE DATABASE
      RETURN .F.
   ENDIF
ELSE
   // Se for passado os parÉmetros na linha de execuá∆o
   vemp:=LEFT(ppar1,1)
   vloja:=SUBSTR(ppar1,2,1)
   vsetor:=IF(!EMPTY(SUBSTR(ppar1,3,1)),VAL(SUBSTR(ppar1,3,1)),1)
   vano:=IF(!EMPTY(SUBSTR(ppar1,4,2)),SUBSTR(ppar1,4,2),SPACE(2))
   SET FILTER TO Loja->emp==vemp
   SET ORDER TO 1
ENDIF
// Verificaá∆o da Empresa
vcnomeemp:=ALLTRIM(Procura("Emp",1,vemp,"nome"))
IF EMPTY(vcnomeemp)
   CLOSE DATABASE
   Mensagem("Empresa N∆o Cadastrada !",4,1)
   RETURN .F.
ENDIF
// Verificaá∆o da Loja
IF EMPTY(Procura("Loja",1,vloja,"nome"))
   CLOSE DATABASE
   Mensagem("Loja N∆o Cadastrada !",4,1)
   RETURN .F.
ENDIF
// Verificaá∆o do setor para acesso ao menu
IF (vsetor < 1 .OR. vsetor > 5)
   vsetor:=1
ENDIF
// Solicitaá∆o do Ano de Exerc°cio para a Contabilidade
IF modulo="EC"
   IF VAL(vano)=0
      Aviso(24,"Digite o Ano do Exerc°cio")
      Caixa2(08,25,10,46,frame[1])
      SETCOLOR(vci)
      @ 09,26 SAY "Ano do Exerc°cio:"
      SETCOLOR(vcd)
      @ 09,44 GET vano PICTURE "99" VALID !EMPTY(vano)
      SETCOLOR(vcn)
      Le()
   ENDIF
ENDIF
// Atualizaá∆o das vari†veis p£blicas
vcemp :=vemp
vcloja:=vloja
mp    :=vsetor
vcano :=vano
// Definiá∆o do nome do sistema
vsist:=cSgSist+" "+modulo+" "+Versao()+" - "+ALLTRIM(Procura("Loja",1,vcloja,"fanta"))
IF modulo="EC"
   vsist+=" "+Ano(vcano)
ENDIF
CLOSE DATABASE
// Definiá∆o do diret¢rio de trabalho dos arquivos de movimentos
dirmov:=".\EMP"+vcemp+"\"  // idÇia: ".\EMP"+vcemp+"\MOV"+vcano
// Se n∆o existir o diret¢rio de movimentos
IF !FILE(dirmov+"NUL")
   Mensagem("N∆o Foi Encontrado o Diret¢rio de Movimentos",3,1)
   RETURN .F.
ENDIF
IF ASCAN({"FC","WM","EC"},modulo) > 0
   // Procura impressoras instaladas
   CLEAR
   SETCOLOR(vcp)
   Aviso(10,"Procurando Impressoras. Aguarde...")
   SETCOLOR(vcn)
   mPrinters:=GetPrinters(.T.)
   @ 10,00 CLEAR
   IF EMPTY(mPrinters)
      vcPrnPadrao:="N∆o Existe Impressora Padr∆o"
      SETCOLOR(vcp)
      Aviso(10,"N∆o Existe Impressora Instalada")
   ELSE
      vcPrnPadrao:=GetDefaultPrinter()
      SETCOLOR(vcn)
      Aviso(12,"Impressora Padr∆o: "+vcPrnPadrao)
      Aviso(14,"Pressione <Ctrl+P> para Mudar de Impressora Padr∆o")
   ENDIF
   SETCOLOR(vcn)
   Aviso(16,"Pressione Qualquer Tecla para Continuar")
   INKEY(0)
   CLEAR
   IF LASTKEY()==K_CTRL_P
      MudaPrnPadrao()
   ENDIF
   CLEAR
ENDIF
SETCOLOR(vcn) //("W/B")
@ 00,00 SAY PADR(cDirSist,80)
SETCOLOR(vcr)
// Retorna
RETURN .T.

********************************************************************************
FUNCTION ValidaEmp(linha,coluna)
// Validaá∆o da Empresa informada
********************************************************************************
PRIVATE GetList:={}
vemp:=Acha2(vemp,"Emp",1,2,"codi","nome","9","@!",15,10,22,70,"C¢digo","Nome da Empresa")
IF EMPTY(vemp).OR.LASTKEY()==K_ESC
   RETURN .F.
ENDIF
SETCOLOR(vcd)
@ linha,coluna SAY vemp PICTURE "9"
Sayd(linha,coluna+1,"-"+Emp->nome,"@!",41)
SETCOLOR(vcn)
SET FILTER TO Loja->emp==vemp
SET ORDER TO 1
RETURN .T.

********************************************************************************
FUNCTION Empresa(ploja)
// Identificaá∆o da Empresa no FC,WM e EC pela Loja do VM
********************************************************************************
LOCAL vemp
IF ploja$"012345" // Se a loja for Matriz, Filial I (Aldeota),
                  // Filial II (Monte Castelo), Filial III (Natal),
                  // Filial IV(S∆o Paulo), Filial V (Laminado)
   vemp:="0"      // A empresa Ç Walter Marinho & Cia. Ltda.
ELSEIF ploja="6"  // Se a loja for Filial VI (Montese)
   vemp:="2"      // A empresa Ç Comercial de Vidros Montese Epp.
ELSEIF ploja="7"  // Se a loja for Filial VII (Belem)
   vemp:="4"      // A empresa Ç Marglass Industria de Vidros Par† Ltda.
ELSEIF ploja="8"  // Se a loja for Filial 8
   vemp:="5"      // A empresa Ç Marglass S∆o Lu°s.
ENDIF
RETURN vemp

******************************************************************************
PROCEDURE Loja(pcod)
******************************************************************************
LOCAL pnome
IF pcod=="0"
   pnome:="MATRIZ    "
ELSEIF pcod=="1"
   pnome:="FILIAL I  "
ELSEIF pcod=="2"
   pnome:="FILIAL II "
ELSEIF pcod=="3"
   pnome:="FILIAL III"
ELSEIF pcod=="4"
   pnome:="FILIAL IV "
ELSEIF pcod=="5"
   pnome:="FILIAL V  "
ELSEIF pcod=="6"
   pnome:="FILIAL VI "
ELSEIF pcod=="7"
   pnome:="FILIAL VII"
ELSE
   pnome:="          "
ENDIF
RETURN pnome

**************************************************************************
PROCEDURE Logotipo(pDiv)
***************************
LOCAL vtit:=cSgSist
IF pDiv="1"
   vtit:=vtit+"-"+"Divis∆o de Vidro Comum"
ELSEIF pDiv="2"
   vtit:=vtit+"-"+"Divis∆o de Vidro Curvo"
ELSEIF pDiv="3"
   vtit:=vtit+"-"+"Divis∆o de Vidro Temperado"
ELSEIF pDiv="4"
   vtit:=vtit+"-"+"Divis∆o de Vidro Laminado"
ELSEIF pDiv="5" .OR. pDiv==NIL
   vtit:=vtit+"-"+"Padr∆o Mundial em Vidros"
ENDIF
@ PROW(),01 SAY vcid10+vcia10+vcia20+vcia05+vtit+vcid10+vcia10
RETURN

********************************************************************************
FUNCTION Ano(pano)
// Retorna o ano em 4 digitos
// Ex.: Ano("03") -> "2003"
********************************************************************************
RETURN IF(VAL(pano)>60,"19"+pano,"20"+pano)

********************************************************************************
FUNCTION Mes(pmes)
// Retorna o nome do mes
// Ex.: Mes("03") -> "Maráo   "
********************************************************************************
LOCAL vmeses:={"janeiro  ","fevereiro","maráo    ","abril    ",;
               "maio     ","junho    ","julho    ","agosto   ",;
               "setembro ","outubro  ","novembro ","dezembro "}
RETURN IF(VAL(pmes)>0.AND.VAL(pmes)<13,vmeses[VAL(pmes)],"")

********************************************************************************
FUNCTION MesExt(dd)
// Retorna o màs por extenso.
********************************************************************************
LOCAL mes:={"Janeiro","Fevereiro","Maráo","Abril","Maio","Junho","Julho",;
      "Agosto","Setembro","Outubro","Novembro","Dezembro"}
IF EMPTY(dd)
   RETURN ""
ENDIF
RETURN mes[MONTH(dd)]

**************************************************************************
PROCEDURE ImprRecAvu()
// Imprime Recibos Avulsos.
**********************************
LOCAL vextenso,vporta:="1",vcop,vvalor:=0,vcodcli:=SPACE(05)
LOCAL vcli:=SPACE(40),vref:=SPACE(40),vdata:=CTOD(SPACE(8)),vform:="2"
DO WHILE .T.
   Abrejan(2)
   vcop:=1
   SETCOLOR(vcn)
   Aviso(24,"Entre com os Dados ou <Esc> Para Retornar")
   @ 06,10 SAY "Recibos a Imprimir___:"
   @ 08,10 SAY "Impressora___________:     1-LPT1  2-LPT2"
   @ 10,10 SAY "Valor________________:"
   @ 12,10 SAY "Cliente______________:"
   @ 14,10 SAY "Referente____________:"
   @ 16,10 SAY "Data do Pagamento____:"
   @ 18,10 SAY "Formul†rio___________:"
   SETCOLOR(vcd)
   @ 06,33 GET vcop    PICTURE "9" VALID vcop>0
   @ 08,33 GET vporta  PICTURE "9" VALID vporta$"12"
   @ 10,33 GET vvalor  PICTURE "@E 999,999.99" VALID vvalor>0
   @ 12,33 GET vcodcli PICTURE "99999"
   Le()
   IF LASTKEY()=K_ESC
      SETCOLOR(vcn)
      RETURN
   ENDIF
   IF !EMPTY(vcodcli)
      IF !AbreArqs({{(dirvm+"VM_CLIEN.DBF"),"Cli","Clientes",2}},.F.)
         RETURN
      ENDIF
      vcodcli:=Zeracod(vcodcli)
      vcodcli:=Acha2(vcodcli,"Cli",1,3,"codcli","nome+'≥'+muni+'≥'+esta","99999","@!",;
               15,02,22,78,"C¢digo","Cliente/Munic°pio/UF")
      vcli:=Procura("Cli",1,vcodcli,"nome")
      CLOSE DATABASE
      SETCOLOR(vcd)
      @ 12,33 SAY vcodcli PICTURE "99999"
      @ 12,39 SAY vcli PICTURE "@!"
   ENDIF
   @ 12,39 GET vcli  PICTURE "@!"
   @ 14,33 GET vref  PICTURE "@!"
   @ 16,33 GET vdata PICTURE "99/99/99"
   @ 18,33 GET vform PICTURE "9" VALID vform$"12"
   Le()
   IF LASTKEY()==K_ESC
      SETCOLOR(vcn)
      RETURN
   ENDIF
   IF !Confirme()
      LOOP
   ENDIF
   //
   @ 24,00 CLEAR
   SETCOLOR(vcp)
   Aviso(24,"Imprimindo Recibo. Aguarde...")
   SETCOLOR(vcn)
   SET DEVICE TO PRINTER
   IF vporta=="1"
      SET PRINTER TO LPT1
   ELSE
      SET PRINTER TO LPT2
   ENDIF
   //
   IF vform=="1" // Formul†rio Timbrado
      SET PRINT ON
      ?? CHR(27)+CHR(120)+CHR(1)  // seleciona modo NLQ
      ?? CHR(27)+CHR(107)+CHR(1)  // fonte SansSerif
      ?? CHR(27)+CHR(33)+CHR(64)  // it†lico
      ?? vcia10                   // 10 cpp
      SET PRINT OFF
      DO WHILE vcop>0
         IF Escprint(80)
            RETURN
         ENDIF
         @ 09,62 SAY vvalor PICTURE "@E 999,999.99"
         @ PROW()+3,18 SAY vcli
         vextenso:=Ext(vvalor)
         IF LEN(vextenso)>55
            @ PROW()+3,19 SAY LEFT(vextenso,55)
            @ PROW()+2,12 SAY RIGHT(vextenso,LEN(vextenso)-55)
            @ PROW(),PCOL() SAY REPLICATE("*",117-LEN(vextenso))
         ELSE
            @ PROW()+3,19 SAY vextenso+REPLICATE("*",55-LEN(vextenso))
            @ PROW()+2,12 SAY REPLICATE("*",62)
         ENDIF
         @ PROW()+2,15 SAY vref
         @ PROW()+6,45 SAY ALLTRIM(STR(DAY(vdata)))
         @ PROW(),  53 SAY MesExt(vdata)
         @ PROW(),  68 SAY ALLTRIM(STR(YEAR(vdata)))
         EJECT
         vcop--
      ENDDO
      SET PRINT ON
      ?? CHR(27)+CHR(120)+CHR(0)  // seleciona modo Draft
      ?? CHR(27)+"2"              // espaáamento normal (4,23mm)
      ?? CHR(27)+"5"              // cancela modo it†lico
      ?? vcia10                   // 10 cpp
      SET PRINT OFF
      SET DEVICE TO SCREEN
      @ 24,00 CLEAR
   ELSE // Formul†rio Avulso
      SET PRINT ON
      ?? vcid10+vcia10              // 10 cpp
      SET PRINT OFF
      DO WHILE vcop>0
         IF Escprint(80)
            RETURN
         ENDIF
         @ PROW()+9,32 SAY "R E C I B O"
         @ PROW()  ,32 SAY "R E C I B O"
         @ PROW()+2,60 SAY "R$"
         @ PROW()  ,63 SAY vvalor PICTURE "@E 999,999.99"
         @ PROW()  ,60 SAY "R$"
         @ PROW()  ,63 SAY vvalor PICTURE "@E 999,999.99"
         @ PROW()+3,00 SAY "Recebi(emos) de "+vcli+" "+vcodcli
         vextenso:=Ext(vvalor)
         IF LEN(vextenso)>55
            @ PROW()+2,00 SAY "A importÉncia de ("+LEFT(vextenso,55)
            @ PROW()+1,00 SAY ALLTRIM(RIGHT(vextenso,LEN(vextenso)-55))
            @ PROW(),PCOL() SAY REPLICATE("*",117-LEN(ALLTRIM(vextenso)))+")"
         ELSE
            @ PROW()+2,00 SAY "A importÉncia de ("+vextenso+REPLICATE("*",55-LEN(vextenso))
            @ PROW()+1,00 SAY REPLICATE("*",62)+")"
         ENDIF
         @ PROW()+2,00 SAY "Referente a "+vref
         IF EMPTY(vdata)
            @ PROW()+5,35 SAY "Fortaleza,    de                     de"
         ELSE
            @ PROW()+5,35 SAY "Fortaleza, "+ALLTRIM(STR(DAY(vdata)))
            @ PROW()  ,48 SAY " de "+MesExt(vdata)+" de "+ALLTRIM(STR(YEAR(vdata)))
         ENDIF
         @ PROW()+9,00 SAY ""
         vcop--
      ENDDO
      SET DEVICE TO SCREEN
      @ 24,00 CLEAR
   ENDIF
   LOOP
ENDDO

*******************************************************************************
FUNCTION ValJuros(pvalor,ptaxa,pvenc,pdatpg)
*******************************************************************************
LOCAL valjuros:=0
pvalor:=IF(pvalor=NIL,vvalor,pvalor)
ptaxa :=IF(ptaxa=NIL,vtaxa,ptaxa)
pvenc :=IF(pvenc=NIL,vvenc,pvenc)
pdatpg:=IF(pdatpg=NIL,vdatpg,pdatpg)
IF EMPTY(pdatpg)    // A pagar
   IF DATE()>pvenc
      valjuros:=ptaxa*pvalor/3000*(DATE()-pvenc)
   ENDIF
ELSE                // Pago
   IF pdatpg>pvenc
      valjuros:=ptaxa*pvalor/3000*(pdatpg-pvenc)
   ENDIF
ENDIF
RETURN ROUND(valjuros,2)

*******************************************************************************
FUNCTION JurosDia(pvalor,ptaxa)
*******************************************************************************
LOCAL jurosdia:=0
pvalor:=IF(pvalor=NIL,vvalor,pvalor)
ptaxa :=IF(ptaxa=NIL,vtaxa,ptaxa)
jurosdia:=ptaxa*pvalor/3000
RETURN ROUND(jurosdia,2)

*******************************************************************************
FUNCTION TaxaJuros(pvalor,pjurosdia)
*******************************************************************************
LOCAL taxajuros:=0
pvalor   :=IF(pvalor=NIL,vvalor,pvalor)
pjurosdia:=IF(pjurosdia=NIL,vjurosdia,pjurosdia)
taxajuros:=pjurosdia/pvalor*3000
RETURN ROUND(taxajuros,2)

********************************************************************************
FUNCTION Arred(pcod,palt,plar)
// Arredonda a †rea do vidro para m£ltiplo de 5 ou 25 cm.
********************************************************************************
IF VAL(LEFT(pcod,2)) > 69          // se n∆o for vidro
   RETURN 1
ENDIF
IF VAL(LEFT(pcod,2)) < 70          // se for vidro
   IF VAL(LEFT(pcod,2)) < 10
      IF RIGHT(pcod,1)=="0"        // se for chapa
         RETURN palt*plar/1000000
      ENDIF
   ENDIF
   IF LEFT(pcod,6)=="071079"       // se for vidro aramado
      palt:=IF(palt%250>0,palt+(250-palt%250),palt)
      plar:=IF(plar%250>0,plar+(250-plar%250),plar)
      RETURN palt*plar/1000000
   ENDIF
   IF VAL(LEFT(pcod,2)) > 39       // se for vidro temperado
      IF palt*plar/1000000 < 0.04  // se a †rea for menor que 0.04 m2
         RETURN 0.04
      ENDIF
   ENDIF
   palt:=IF(palt%50>0,palt+(50-palt%50),palt)
   plar:=IF(plar%50>0,plar+(50-plar%50),plar)
   RETURN palt*plar/1000000
ENDIF

********************************************************************************
FUNCTION AnoMesAnt(panomes)
// Objetivo: Retorna o per°odo anterior conforme per°odo passado como parÉmetro
// Sintaxe.: AnoMesAnt( <panomes> ) --> anomesant
********************************************************************************
LOCAL anomesant,ano,mes,anoant,mesant
ano:=VAL(LEFT(panomes,4))
mes:=VAL(RIGHT(panomes,2))
mesant:=IF(mes=1,12,mes-1)
anoant:=IF(mes=1,ano-1,ano)
anomesant:=STR(anoant,4)+STRZERO(mesant,2)
RETURN anomesant

********************************************************************************
FUNCTION AcertaMatriz(pmatriz)
********************************************************************************
FOR i=1 TO LEN(pmatriz)
   FOR j=1 TO LEN(pmatriz[i])
      IF VALTYPE(pmatriz[i,j])=="N"
         pmatriz[i,j]:=TRANSFORM(pmatriz[i,j],"@E 999,999.99")
      ENDIF
   NEXT
NEXT
RETURN pmatriz

********************************************************************************
FUNCTION UnPadrao(punid)
********************************************************************************
IF punid="UM"
   RETURN "UN"
ELSEIF punid="SC"
   RETURN "UN"
ELSEIF punid="M "
   RETURN "MT"
ELSEIF punid="RL"
   RETURN "UN"
ELSEIF punid="PÄ"
   RETURN "UN"
ELSEIF punid="TN"
   RETURN "KG"
ELSEIF punid="BL"
   RETURN "UN"
ELSEIF punid="CX"
   RETURN "UN"
ELSEIF punid="TB"
   RETURN "UN"
ELSEIF punid="PA"
   RETURN "PR"
ELSEIF punid="FD"
   RETURN "UN"
ELSEIF punid="GR"
   RETURN "UN"
ELSEIF punid="GL"
   RETURN "UN"
ELSEIF punid="BD"
   RETURN "UN"
ELSEIF punid="PC"
   RETURN "UN"
ELSEIF punid="RS"
   RETURN "UN"
ELSE
   RETURN punid
ENDIF

*****************************************************************************
FUNCTION GeraMatriz(pArq,pMemo,pValor)
/* Gera uma matriz com dados do arquivo .DBF pArq
   pArq    = nome do Arquivo .DBF que contÇm os campos memo com
             as configuraá‰es.
   pMemo   = nome do campo memo do Arquivo .DBF
   pValor  = nome do t°tulo no campo memo que contàm os dados da  matriz
   Retorna = matriz com dados  */
*****************************************************************************
LOCAL vareatu:=SELECT()
LOCAL vtexto,vdado,i,vlinhas:=0,mMatriz:={}
//
IF !Abrearq(pArq,"Cfg",.F.,10)
   Mensagem("O Arquivo de Configuraá‰es N∆o Est† Dispon°vel!",3,1)
   RETURN mMatriz
ENDIF
//
@ 24,00 CLEAR
SETCOLOR(vcp)
Aviso(24,"Carregando Configuraá‰es. Aguarde...")
SETCOLOR(vcn)
//
SELECT Cfg
GO TOP
IF EOF()
   Mensagem("N∆o Foi Encontrado o Registro de Configuraá∆o!",3,1)
   CLOSE Cfg
   SELECT (vareatu)
   RETURN mMatriz
ENDIF
vtexto:=Cfg->&pMemo
CLOSE Cfg
SELECT (vareatu)
vlinhas:=MLCOUNT(vtexto,75)
i:=1
DO WHILE i <= vlinhas
   IF UPPER(ALLTRIM(MEMOLINE(vtexto,75,i)))=="*"+UPPER(pValor)
      EXIT
   ENDIF
   i++
ENDDO
IF i > vlinhas
   Mensagem("N∆o Foi Encontrado no Campo Memo o T°tulo com Dados da Matriz!",4,1)
   RETURN mMatriz
ENDIF
//
i++
DO WHILE i <= vlinhas
   IF UPPER(ALLTRIM(MEMOLINE(vtexto,75,i)))=="*FIM"
      EXIT
   ENDIF
   vdado:=ALLTRIM(MEMOLINE(vtexto,75,i))
   IF !EMPTY(vdado)
      AADD(mMatriz,&vdado)
   ENDIF
   i++
ENDDO
//
@ 24,00 CLEAR
RETURN mMatriz

********************************************************************************
PROCEDURE DbsMov(pmodulo)
// Objetivo: Retorna uma matriz de uma dimens∆o com os arquivos de
//           dados com Path desta vers∆o do SIG conforme m¢dulo exe
//           passado como parÉmetro.
// Sintaxe.: DbsMov( <pmodulo> ) --> mArqs
// Exemplo.: DbsMov("FC") --> mArqs{dir+"FC*.DB?"}
********************************************************************************
LOCAL i,mArqs,mDirCad,mDirMov
mDirMov:=DIRECTORY(dirmov+"*.DB?")
mArqs:={}
IF pmodulo=NIL
   // se n∆o for passado o m¢dulo como parÉmetro
   FOR i=1 TO LEN(mDirMov)
      // adiciona na matriz todos os m¢dulos
      AADD(mArqs,dirmov+mDirMov[i,1])
   NEXT
ELSE
   // se for passado
   FOR i=1 TO LEN(mDirMov)
      // adiciona na matriz o m¢dulo passado como parÉmetro
      IF LEFT(mDirMov[i,1],2)==pmodulo
         AADD(mArqs,dirmov+mDirMov[i,1])
      ENDIF
   NEXT
ENDIF
RETURN mArqs

**************************************************************************
FUNCTION TestaCod(tcod1,tcod2)
// Testa o c¢digo do tipo de vidro
**********************************
IF VAL(LEFT(tcod1,2))<70 .AND. SUBSTR(tcod1,3,3)==tcod2
   RETURN .T.
ELSE
   RETURN .F.
ENDIF

**************************************************************************
FUNCTION Versao()
**********************************
RETURN "2.4"

********************************************************************************
//                                   Fim
********************************************************************************

