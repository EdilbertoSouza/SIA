********************************************************************************
/* Programa.: MG_CADA3.PRG
   Fun��o...: M�dulo de Cadastros Gerais
   Data.....: 05/06/02
   Autor....: Edilberto L. Souza */
********************************************************************************
#include "SIG.CH"

// ###  Tabelas definidas em Matriz

********************************************************************************
PROCEDURE TabSisif(pcod)
// Objetivo: Retorna a tabela do SISIF conforme c�digo passado como par�metro
// Sintaxe.: TabSisif( <pcod> ) --> mTab
********************************************************************************
LOCAL mTab
IF pcod="01"  // modelos de documentos fiscais
   mTab:={;
   {"01","NOTA FISCAL - MODELOS 1 OU 1A"},;
   {"02","NOTA FISCAL DE VENDA A CONSUMIDOR - MODELO 2"},;
   {"04","NOTA FISCAL DE PRODUTOR - MODELO 4"},;
   {"06","NOTA FISCAL / CONTA DE ENERGIA EL�TRICA - MODELO 6"},;
   {"07","NOTA FISCAL DE SERVI�O DE TRANSPORTE - MODELO 7"},;
   {"08","CONHECIMENTO DE TRANSPORTE RODOVI�RIO DE CARGAS - MODELO 8"},;
   {"09","CONHECIMENTO DE TRANSPORTE AQUAVI�RIO DE CARGAS - MODELO 9"},;
   {"10","CONHECIMENTO A�RIO - MODELO 10"},;
   {"11","CONHECIMENTO DE TRANSPORTE FERROVI�RIO DE CARGAS - MODELO 11"},;
   {"13","BILHETE DE PASSAGEM RODOVI�RIO - MODELO 13"},;
   {"14","BILHETE DE PASSAGEM AQUAVI�RIO - MODELO 14"},;
   {"15","BILHETE DE PASSAGEM E NOTA DE BAGAGEM - MODELO 15"},;
   {"16","BILHETE DE PASSAGEM FERROVI�RIO - MODELO 16"},;
   {"17","DESPACHO DE TRANSPORTE - MODELO 17"},;
   {"18","RESUMO DE MOVIMENTO DI�RIO - MODELO 18"},;
   {"20","ORDEM DE COLETA DE CARGAS - MODELO 20"},;
   {"21","NOTA FISCAL DE SERVI�O DE COMUNICA��O - MODELO 21"},;
   {"22","NOTA FISCAL DE SERVI�O DE TELECOMUNICA��O - MODELO 22"},;
   {"23","GUIA NACIONAL DE RECOLHIMENTO DE TRIB. ESTADUAIS (GNRE) - MODELO 23"},;
   {"24","AUTORIZA��O DE CARREGAMENTO E TRANSPORTE - MODELO 24"},;
   {"25","MANIFESTO DE CARGAS - MODELO 25"},;
   {"36","NOTA FISCAL AVULSA"},;
   {"37","CUPOM FISCAL-ECF"},;
   {"38","MAPA RESUMO ECF"},;
   {"39","CONHECIMENTO DE TRANSPORTE AVULSO"}}
ENDIF
IF pcod="03"  // finalidade das informa��es fiscais
   mTab:={;
   {"01","INCLUS�O"},;
   {"02","RETIFICA��O"},;
   {"03","ACR�SCIMO"}}
ENDIF
IF pcod="04"  // unidade padr�o de comercializa��o
   mTab:={;
   {"UN","UNIDADE"},;
   {"KG","QUILOGRAMA"},;
   {"LT","LITRO"},;
   {"MT","METRO LINEAR"},;
   {"M2","METRO QUADRADO"},;
   {"M3","METRO C�BICO"},;
   {"KW","QUILOWATT HORA"},;
   {"PR","PAR"}}
ENDIF
IF pcod="05"  // opera��o do documento fiscal
   mTab:={;
   {"01","ENTRADA DE MERC ATRAV�S DE DOC. FISCAL EMIT. P/ PR�PRIO CONTRIBUINTE"},;
   {"02","ENTRADA DE MERC ATRAV�S DE DOC. FISCAL EMIT. P/ OUTRO CONTRIBUINTE OU ATRAV. DE NF AVULSA EMIT.P/ SEFAZ-CE"},;
   {"03","SA�DA DE MERCADORIA, INCLUSIVE POR ECF"},;
   {"04","AQUISI��O DE SERVI�O SUJ. AO ICMS, INCLUSIVE NF NF1 EM ENTRADA ENGLOB. DE CONHEC. DE TRANSPORTE"},;
   {"05","PRESTA��O DE SERVI�O SUJ. AO ICMS, INCLUSIVE POR ECF"},;
   {"06","CANCELAMENTO DE CUPOM FISCAL"},;
   {"07","OUTRAS OPERA��ES REALIZADAS POR ECF"},;
   {"08","DOCUMENTOS CANCELADOS"},;
   {"09","DOCUMENTOS DEVOLVIDOS"},;
   {"10","DOCUMENTOS EXTRAVIADOS"},;
   {"11","LEITURA Z"},;
   {"12","SERVI�O SUJEITO AO ISS"}}
ENDIF
IF pcod="06"  // situa��o do documento fiscal
   mTab:={;
   {"00","DOCUMENTO FISCAL UTILIZADO"},;
   {"01","DOCUMENTO FISCAL DEVOLVIDO - BAIXA A PEDIDO"},;
   {"02","DOCUMENTO FISCAL - BAIXA DE OF�CIO"},;
   {"03","DOCUMENTO FISCAL EXTRAVIADO"},;
   {"04","DOCUMENTO FISCAL DEVOLVIDO COM AIDF VENCIDA"},;
   {"05","DOCUMENTO FISCAL UTILIZADO VENCIDO"},;
   {"06","DOCUMENTO FISCAL CANCELADO"}}
ENDIF
IF pcod="07"  // condi��o do participante no documento fiscal
   mTab:={;
   {"01","EMITENTE DO DOCUMENTO FISCAL"},;
   {"02","REMETENTE DAS MERCADORIAS OU PRESTADOR DE SERVI�OS - N�O EMITENTE"},;
   {"03","DESTINAT�RIO DAS MERCADORIAS OU TOMADOR DE SERVI�OS"},;
   {"04","CONSIGNAT�RIO DAS MERCADORIAS"},;
   {"05","TRANSPORTADOR"},;
   {"06","CONSIGNANTE DAS MERCADORIAS"}}
ENDIF
IF pcod="08"  // c�digo do participante
   mTab:={;
   {"0","NENHUM (SE FOR ECF OU NFVC, QDO N�O TIVER DESTINAT�RIO OU QDO FOR DO EXTERIOR)"},;
   {"1","INSCRI��O ESTADUAL - IE (CGF)"},;
   {"2","CNPJ"},;
   {"3","CPF"}}
ENDIF
IF pcod="09"  // n�meros de seguran�a
   mTab:={;
   {"01","SELO FISCAL DE AUTENCIDADE"},;
   {"02","FORMUL�RIO CONT�NUO"},;
   {"03","FORMUL�RIO DE SEGURAN�A"},;
   {"04","DOCUMENTO EMITIDO MANUALMENTE"}}
ENDIF
IF pcod="10"  // tipo de icms
   mTab:={;
   {"01","NORMAL"},;
   {"02","ANTECIPADO"},;
   {"03","SUBSTITUI��O TRIBUT�RIA"},;
   {"04","DIFERENCIAL DE AL�QUOTAS"},;
   {"05","IMPORTA��O COM DIFERIMENTO"},;
   {"06","IMPORTA��O PAGO"},;
   {"07","ICMS RETIDO"}}
ENDIF
IF pcod="11"  // motivos de refer�ncia entre documentos fiscais
   mTab:={;
   {"01","CANCELAMENTO DE CUPOM FISCAL"},;
   {"02","RETIFICA��O DE INFORMA��ES DE DOCUMENTOS EMITIDOS ANTERIORMENTE"},;
   {"03","COMPLEMENTA��O DE INFORMA��ES DE DOCUMENTOS EMITIDOS ANTERIORMENTE"},;
   {"04","EMISS�O DE DOCUMENTO FISCAL REFERENTE A CUPOM EMITIDO POR ECF"},;
   {"05","REMESSA SIMB�LICA REFERENTE A VENDA � ORDEM"},;
   {"06","REMESSA DE MERCADORIA REFERENTE A VENDA POR CONTA E ORDEM DE TERCEIRO"},;
   {"07","DEVOLU��O DE VENDAS"},;
   {"08","RETORNO DE MERCADORIAS REMETIDAS PARA FORA DO ESTABELECIMENTO"},;
   {"09","REMESSA DE MERCADORIAS PARA VENDA FORA DO ESTABELECIMENTO"},;
   {"10","DEVOLU��O DE COMPRAS"},;
   {"11","GLOBALIZA��O DE VENDAS DE MERCADORIAS EFETUADAS FORA DO ESTABELECIMENTO"},;
   {"13","BILHETES DE PASSAGEM INCLU�DO EM RESUMO DE MOVIMENTO DI�RIO"},;
   {"14","NOTA FISCAL ENGLOBADORA DE AQUISI��O DE SERVI�OS DE TRANSPORTE"},;
   {"15","REMESSA DE MERCADORIAS REFERENTE A VENDA PARA ENTREGA FUTURA"},;
   {"16","RETORNO DE REMESSA PARA INDUSTRIALIZA��O"},;
   {"17","RETORNO DE REMESSA PARA CONSERTO"},;
   {"18","RETORNO DE REMESSA PARA EXPOSI��O AO P�BLICO"},;
   {"19","SIMPLES FATURAMENTO DE NOTA FISCAL EM CONSIGNA��O MERCANTIL"},;
   {"20","CTRC INCLU�DAS EM RESUMO DE MOVIMENTO DI�RIO"},;
   {"21","NOTA FISCAL DE ENTRADA, PARA FRUI��O DO CR�DITO PRESUMIDO"},;
   {"22","NOTA FISCAL DE RESSARCIMENTO"},;
   {"23","CUPONS RELACIONADOS EM LEITURA Z"},;
   {"24","RETORNO DE REMESSA PARA DEMONSTRA��O"},;
   {"99","OUTRAS SITUA��ES (ESPECIFICAR A SITUA��O NO CAMPO 17 - REGISTRO 67)"}}
ENDIF
IF pcod="12"  // c�digo valor fiscal
   mTab:={;
   {"01","OPERA��ES COM CR�DITO DO IMPOSTO"},;
   {"02","OPERA��ES SEM CR�DITO DO IMPOSTO - ISENTAS OU N�O TRIBUTADAS"},;
   {"03","OPERA��ES SEM CR�DITO DO IMPOSTO - OUTRAS"}}
ENDIF
IF pcod="13"  // c�digo da classe de consumidor de energia el�trica
   mTab:={;
   {"01","RESIDENCIAL"},;
   {"02","IND�STRIA"},;
   {"03","COM�RCIO E SERVI�O"},;
   {"04","RURAL"},;
   {"05","PODER P�BLICO"},;
   {"06","ILUMINA��O P�BLICA"},;
   {"07","RESIDENCIAL"},;
   {"08","CONSUMO PR�PRIO"},;
   {"09","REVENDA"}}
ENDIF
IF pcod="14"  // c�digo da situa��o tribut�ria (coluna A - origem da mercadoria)
   mTab:={;
   {"0","NACIONAL"},;
   {"1","ESTRANGEIRA - IMPORTA��O DIRETA"},;
   {"2","ESTRANGEIRA - ADIQUIRIDA NO MERCADO INTERNO"}}
ENDIF
IF pcod="15"  // c�digo da situa��o tribut�ria (coluna A - tributa��o pelo icms)
   mTab:={;
   {"00","TRIBUTADA INTEGRALMENTE"},;
   {"10","TRIBUTADA E COM COBRAN�A DE ICMS DE SUBSTITUI��O TRIBUT�RIA"},;
   {"20","TRIBUTADA COM REDU��O DE BASE DE C�LCULO"},;
   {"30","ISENTA OU N�O TRIBUTADA E COM COBRAN�A DE ICMS DE SUBSTITUI��O TRIBUT�RIA"},;
   {"40","ISENTA"},;
   {"41","N�O TRIBUTADA"},;
   {"50","SUSPENS�O"},;
   {"51","DIFERIMENTO"},;
   {"60","ICMS COBRADO ANTERIORMENTE POR SUBSTITUI��O TRIBUT�RIA"},;
   {"70","COM REDU��O DE BASE DE C�LCULO E COBRAN�A DO ICMS POR SUBSTITUI��O TRIBUT�RIA"},;
   {"90","OUTRAS"}}
ENDIF
IF pcod="16"  // c�digo da situa��o tribut�ria para cupom fiscal
   mTab:={;
   {"T17","TRIBUTADA INTEGRALMENTE COM 17%"},;
   {"T07","TRIBUTADA COM REDU��O DE BASE DE C�LCULOS DE 58,82% EQUIVALENTE A UMA AL�QUOTA EFETIVA DE 7%"},;
   {"T12","TRIBUTADA INTEGRALMENTE COM AL�QUOTA DE 12%"},;
   {"T25","TRIBUTADA INTEGRALMENTE COM AL�QUOTA DE 25%"},;
   {"TR","TRIBUTA��O COM REDU��O DE BASE DE C�LCULO"},;
   {"I","ISENTA OU N�O TRIBUTADA"},;
   {"F","ICMS SUBSTITUI��O"},;
   {"N","N�O INCID�NCIA"}}
ENDIF
IF pcod="17"  // c�digo de receita para gnre
   mTab:={;
   {"10001-3","ICMS COMUNICA��O"},;
   {"10002-1","ICMS ENERGIA EL�TRICA"},;
   {"10003-0","ICMS TRANSPORTE"},;
   {"10004-8","ICMS SUBSTITUI��O TRIBUT�RIA POR APURA��O"},;
   {"10005-6","ICMS IMPORTA��O"},;
   {"10006-4","ICMS AUTUA��O FISCAL"},;
   {"10007-2","PARCELAMENTO"},;
   {"10009-9","ICMS SUBSTITUI��O POR OPERA��O"},;
   {"15001-0","D�VIDA ATIVA"},;
   {"15001-1","MULTA P/INFORMA��O E OBRIGA��O ACESS�RIA"},;
   {"60001-6","TAXA"}}
ENDIF
FOR i=1 TO LEN(mTab)
   mTab[i,2]:=PADR(mTab[i,2],66)
NEXT
RETURN (mTab)

********************************************************************************
PROCEDURE TabDief(pnome)
// Objetivo: Retorna a tabela da DIEF conforme nome passado como par�metro
// Sintaxe.: TabDief( <pnome> ) --> mTab
********************************************************************************
LOCAL mTab
IF pnome="DIEF"  // tipo de dief
   mTab:={;
   {"1","Completa"}}
ENDIF
IF pnome="MTVO"  // motivo da declara��o
   mTab:={;
   {"01","MENSAL"},;
   {"02","ANUAL"},;
   {"03","BAIXA CADASTRAL"},;
   {"04","ALTERA��O DE REGIME DE RECOLHIMENTO"},;
   {"05","ALTERA��O DE ENDERE�O"},;
   {"06","ALTERA��O DE SISTEM�TICA DE TRIBUTA��O"},;
   {"07","FISCALIZA��O"}}
ENDIF
IF pnome="FINA"  // finalidades
   mTab:={;
   {"01","NORMAL (INCLUS�O)"},;
   {"02","RETIFICA��O"}}
ENDIF
IF pnome="REGI"  // regime de recolhimento
   mTab:={;
   {"01","NORMAL"},;
   {"02","EPP"}}
ENDIF
IF pnome="DISP"  // dispositivos autorizados
   mTab:={;
   {"01","BLOCOS"},;
   {"02","FORMUL�RIO CONT�NUO"},;
   {"03","FORMUL�RIO DE SEGURAN�A"},;
   {"04","JOGOS SOLTOS"},;
   {"05","ECF"}}
ENDIF
IF pnome="SITU"  // situa��o dos documentos
   mTab:={;
   {"1","EMITIDO"},;
   {"2","CANCELADO"}}
ENDIF
IF pnome="OPER"  // opera��es
   mTab:={;
   {"01","ENTRADA DE MERC ATRAV�S DE DOC. FISCAL EMIT. P/ PR�PRIO CONTRIBUINTE"},;
   {"02","ENTRADA DE MERC ATRAV�S DE DOC. FISCAL EMIT. P/ OUTRO CONTRIBUINTE OU ATRAV. DE NF AVULSA EMIT.P/ SEFAZ-CE"},;
   {"03","SA�DA DE MERCADORIA, INCLUSIVE POR ECF"},;
   {"04","AQUISI��O DE SERVI�O SUJ. AO ICMS, INCLUSIVE NF NF1 EM ENTRADA ENGLOB. DE CONHEC. DE TRANSPORTE"},;
   {"05","PRESTA��O DE SERVI�O SUJ. AO ICMS, INCLUSIVE POR ECF"},;
   {"07","OUTRAS OPERA��ES REALIZADAS POR ECF"},;
   {"11","LEITURA Z"},;
   {"12","SERVI�O SUJEITO AO ISS"}}
ENDIF
IF pnome="OCRE"  // outros cr�ditos
   mTab:={;
   {"01","CR�DITO PRESUMIDO"},;
   {"02","CR�DITO ANTECIPADO"},;
   {"03","CR�DITO DIFERENCIAL DE AL�QUOTA"},;
   {"04","CR�DITO TRANSFER�NCIA DE CR�DITO"},;
   {"05","CR�DITO BENS DO ATIVO IMOBILIZADO"},;
   {"06","CR�DITO RESTITUI��O DE IND�BITO"},;
   {"07","CR�DITO ICMS A MAIS OU EM DUPLICIDADE"},;
   {"08","CR�DITO ICMS IMPORTA��O DIFERIDO"},;
   {"09","CR�DITO DECORRENTE DE AUTO DE INFRA��O"},;
   {"11","ESTORNO D�BITO REVERS�O DE RESERVA DE TRANSFER�NCIA"},;
   {"12","SALDO CREDOR PER�ODO ANTERIOR"},;
   {"13","ALTERA��O DE REGIME EPP/NL"},;
   {"14","ALTERA��O DE REGIME NL/EPP"},;
   {"15","CR�DITOS EXTEMPOR�NEOS"},;
   {"16","SALDO DE ICMS ANTECIPADO - EPP"},;
   {"91","CR�DITO OUTROS"},;
   {"92","ESTORNO D�BITO OUTROS"}}
ENDIF
IF pnome="ODEB"  // outros d�bitos
   mTab:={;
   {"01","D�BITO RESERVA DE TRANSFER�NCIA DE CR�DITO"},;
   {"02","D�BITO DIFERENCIAL DE AL�QUOTA"},;
   {"03","D�BITO TRANSFER�NCIA DE CR�DITO"},;
   {"04","D�BITO COMPENSA��O DE D�BITOS NA D�VIDA ATIVA"},;
   {"06","ESTORNO CR�DITO SA�DAS ISENTAS OU N�O TRIBUTADAS"},;
   {"07","ESTORNO CR�DITO BENS DE ATIVO POR SA�DAS N�O TRIBUTADAS"},;
   {"08","ESTORNO CR�DITO SUFRAMA"},;
   {"09","ESTORNO CR�DITO DE BENS DO ATIVO POR BAIXA"},;
   {"10","FECOP ICMS NORMAL"},;
   {"98","D�BITO OUTROS"},;
   {"99","ESTORNO CR�DITO OUTROS"}}
ENDIF
IF pnome="DEDU"  // dedu��es
   mTab:={;
   {"01","DEDU��O REFERENTE AO FDI - PROVIN"},;
   {"02","DEDU��O REFERENTE AO FECOP DO ICMS NORMAL"},;
   {"03","INCENTIVO FISCAL"}}
ENDIF
IF pnome="SIMP"  // situa��o das mercadorias / produtos inventariados
   mTab:={;
   {"01","MERCADORIA P/ REVENDA"},;
   {"02","MAT�RIA-PRIMA"},;
   {"03","PRODUTO EM ELABORA��O"},;
   {"04","PRODUTO ACABADO"},;
   {"05","MATERIAL DE ACONDICIONAMENTO E EMBALAGEM"},;
   {"06","MERACADORIA RECEBIDA EM CONSIGNA��O"},;
   {"07","OUTRAS MERCADORIAS OU PRODUTOS"}}
ENDIF
IF pnome="COND"  // condi��o do participante
   mTab:={;
   {"01","EMITENTE DO DOCUMENTO FISCAL"},;
   {"02","REMETENTE DAS MERCADORIAS OU PRESTADOR DE SERVI�OS - N�O EMITENTE"},;
   {"03","DESTINAT�RIO DAS MERCADORIAS OU TOMADOR DE SERVI�OS"},;
   {"04","CONSIGNAT�RIO DAS MERCADORIAS"},;
   {"06","CONSIGNANTE DAS MERCADORIAS"}}
ENDIF
IF pnome="IDTF"  // identificadores
   mTab:={;
   {"1","INSCRI��O ESTADUAL - IE (CGF)"},;
   {"2","CNPJ"},;
   {"3","CPF"}}
ENDIF
IF pnome="REFE"  // motivos de refer�ncia
   mTab:={;
   {"04","EMISS�O DE DOCUMENTO FISCAL REFERENTE A CUPOM EMITIDO POR ECF"},;
   {"11","GLOBALIZA��O DE VENDAS DE MERCADORIAS EFETUADAS FORA DO ESTABELECIMENTO"},;
   {"13","BILHETES DE PASSAGEM INCLU�DO EM RESUMO DE MOVIMENTO DI�RIO"},;
   {"99","OUTRAS SITUA��ES (ESPECIFICAR A SITUA��O NO CAMPO 17 - REGISTRO 67)"}}
ENDIF
IF pnome="CVFI"  // c�digo valor fiscal
   mTab:={;
   {"01","OPERA��ES COM CR�DITO DO IMPOSTO"},;
   {"02","OPERA��ES SEM CR�DITO DO IMPOSTO - ISENTAS OU N�O TRIBUTADAS"},;
   {"03","OPERA��ES SEM CR�DITO DO IMPOSTO - OUTRAS"}}
ENDIF
IF pnome="CSTA"  // c�digo da situa��o tribut�ria - A (origem da mercadoria)
   mTab:={;
   {"0","NACIONAL"},;
   {"1","ESTRANGEIRA - IMPORTA��O DIRETA"},;
   {"2","ESTRANGEIRA - ADIQUIRIDA NO MERCADO INTERNO"}}
ENDIF
IF pnome="CSTB"  // c�digo da situa��o tribut�ria - B (tributa��o pelo icms)
   mTab:={;
   {"00","TRIBUTADA INTEGRALMENTE"},;
   {"10","TRIBUTADA E COM COBRAN�A DE ICMS DE SUBSTITUI��O TRIBUT�RIA"},;
   {"20","TRIBUTADA COM REDU��O DE BASE DE C�LCULO"},;
   {"30","ISENTA OU N�O TRIBUTADA E COM COBRAN�A DE ICMS DE SUBSTITUI��O TRIBUT�RIA"},;
   {"40","ISENTA"},;
   {"41","N�O TRIBUTADA"},;
   {"50","SUSPENS�O"},;
   {"51","DIFERIMENTO"},;
   {"60","ICMS COBRADO ANTERIORMENTE POR SUBSTITUI��O TRIBUT�RIA"},;
   {"70","COM REDU��O DE BASE DE C�LCULO E COBRAN�A DO ICMS POR SUBSTITUI��O TRIBUT�RIA"},;
   {"90","OUTRAS"}}
ENDIF
IF pnome="CSTC"  // c�digo da situa��o tribut�ria para cupom fiscal
   mTab:={;
   {"T17","TRIBUTADA INTEGRALMENTE COM 17%"},;
   {"T07","TRIBUTADA COM REDU��O DE BASE DE C�LCULOS DE 58,82% EQUIVALENTE A UMA AL�QUOTA EFETIVA DE 7%"},;
   {"T12","TRIBUTADA INTEGRALMENTE COM AL�QUOTA DE 12%"},;
   {"T25","TRIBUTADA INTEGRALMENTE COM AL�QUOTA DE 25%"},;
   {"TR","TRIBUTA��O COM REDU��O DE BASE DE C�LCULO"},;
   {"I","ISENTA OU N�O TRIBUTADA"},;
   {"F","ICMS SUBSTITUI��O"},;
   {"N","N�O INCID�NCIA"}}
ENDIF
IF pnome="GNRE"  // c�digo de receita para gnre
   mTab:={;
   {"10001-3","ICMS COMUNICA��O"},;
   {"10002-1","ICMS ENERGIA EL�TRICA"},;
   {"10003-0","ICMS TRANSPORTE"},;
   {"10004-8","ICMS SUBSTITUI��O TRIBUT�RIA POR APURA��O"},;
   {"10005-6","ICMS IMPORTA��O"},;
   {"10006-4","ICMS AUTUA��O FISCAL"},;
   {"10007-2","PARCELAMENTO"},;
   {"10009-9","ICMS SUBSTITUI��O POR OPERA��O"},;
   {"15001-0","D�VIDA ATIVA"},;
   {"15001-1","MULTA P/INFRA��O E OBRIGA��O ACESS�RIA"},;
   {"60001-6","TAXA"}}
ENDIF
IF pnome="UNID"  // unidade do produto ou servi�o
   mTab:={;
   {"UN","UNIDADE"},;
   {"KG","QUILOGRAMA"},;
   {"LT","LITRO"},;
   {"MT","METRO LINEAR"},;
   {"M2","METRO QUADRADO"},;
   {"M3","METRO C�BICO"},;
   {"KW","QUILOWATT HORA"},;
   {"PR","PAR"}}
ENDIF
IF pnome="MODE"  // modelos de documentos fiscais
   mTab:={;
   {"01","NOTA FISCAL - MODELOS 1"},;
   {"1A","NOTA FISCAL - MODELOS 1A"},;
   {"02","NOTA FISCAL DE VENDA A CONSUMIDOR - MODELO 2"},;
   {"04","NOTA FISCAL DE PRODUTOR - MODELO 4"},;
   {"06","NOTA FISCAL / CONTA DE ENERGIA EL�TRICA - MODELO 6"},;
   {"07","NOTA FISCAL DE SERVI�O DE TRANSPORTE - MODELO 7"},;
   {"08","CONHECIMENTO DE TRANSPORTE RODOVI�RIO DE CARGAS - MODELO 8"},;
   {"09","CONHECIMENTO DE TRANSPORTE AQUAVI�RIO DE CARGAS - MODELO 9"},;
   {"10","CONHECIMENTO A�RIO - MODELO 10"},;
   {"11","CONHECIMENTO DE TRANSPORTE FERROVI�RIO DE CARGAS - MODELO 11"},;
   {"13","BILHETE DE PASSAGEM RODOVI�RIO - MODELO 13"},;
   {"14","BILHETE DE PASSAGEM AQUAVI�RIO - MODELO 14"},;
   {"15","BILHETE DE PASSAGEM E NOTA DE BAGAGEM - MODELO 15"},;
   {"16","BILHETE DE PASSAGEM FERROVI�RIO - MODELO 16"},;
   {"17","DESPACHO DE TRANSPORTE - MODELO 17"},;
   {"18","RESUMO DE MOVIMENTO DI�RIO - MODELO 18"},;
   {"20","ORDEM DE COLETA DE CARGAS - MODELO 20"},;
   {"21","NOTA FISCAL DE SERVI�O DE COMUNICA��O - MODELO 21"},;
   {"22","NOTA FISCAL DE SERVI�O DE TELECOMUNICA��O - MODELO 22"},;
   {"23","GUIA NACIONAL DE RECOLHIMENTO DE TRIB. ESTADUAIS (GNRE) - MODELO 23"},;
   {"24","AUTORIZA��O DE CARREGAMENTO E TRANSPORTE - MODELO 24"},;
   {"25","MANIFESTO DE CARGAS - MODELO 25"},;
   {"36","NOTA FISCAL AVULSA"},;
   {"37","CUPOM FISCAL-ECF"},;
   {"38","MAPA RESUMO ECF"},;
   {"39","CONHECIMENTO DE TRANSPORTE AVULSO"}}
ENDIF
IF pnome="SUTR"  // icms substitui��o tribut�ria e fecop-icms-st a recolher
   mTab:={;
   {"01","ICMS-ST A RECOLHER DAS ENTRADAS INTERNAS"},;
   {"02","VALOR DO FECOP-ICMS-ST DAS SA�DAS INTERNAS"},;
   {"03","ICMS-ST A RECOLHER DAS SA�DAS INTERNAS"},;
   {"04","VALOR DO FECOP-ICMS-ST DAS ENTRADAS INTERESTADUAIS"},;
   {"05","ICMS-ST A RECOLHER DAS SA�DAS INTERESTADUAIS"}}
ENDIF
FOR i=1 TO LEN(mTab)
   mTab[i,2]:=PADR(mTab[i,2],66)
NEXT
RETURN (mTab)

********************************************************************************
PROCEDURE TabSintegra(pnome)
// Objetivo: Retorna a tabela do SINTEGRA conforme nome passado como par�metro
// Sintaxe.: TabSintegra( <pnome> ) --> mTab
********************************************************************************
LOCAL mTab
IF pnome="ESTR"  // Estrutura do arquivo magn�tico
   mTab:={{"3","CONV�NIO ICMS 57/95 NA VERS�O ATUAL"}}
ENDIF
IF pnome="NAOP"  // Natureza das opera��es
   mTab:={;
   {"2","INTERESTADUAIS OPERA��ES COM OU SEM SUBSTITUI��O TRIBUT�RIA"},;
   {"3","TOTALIDADE DAS OPERA��ES"}}
   //{"1","INTERESTADUAIS SOMENTE OPERA��ES SUJEITAS A SUBSTITUI��O"},;
ENDIF
IF pnome="FINA"  // Finalidade das Informa��es Fiscais
   mTab:={;
   {"1","NORMAL (INCLUS�O)"},;
   {"2","RETIFICA��O (TOTAL)"}}
ENDIF
IF pnome="SINF"  // Situa��o nf
   mTab:={;
   {"N","DOCUMENTO FISCAL NORMAL"},;
   {"S","DOCUMENTO FISCAL CANCELADO"},;
   {"E","LAN�AMENTO EXTEMPOR�NEO DE DOCUMENTO FISCAL NORMAL"},;
   {"X","LAN�AMENTO EXTEMPOR�NEO DE DOCUMENTO FISCAL CANCELADO"}}
ENDIF
FOR i=1 TO LEN(mTab)
   mTab[i,2]:=PADR(mTab[i,2],66)
NEXT
RETURN (mTab)

// ### ROTINAS DE CADASTRO DE TABELAS

********************************************************************************
PROCEDURE TabDados
// Cadastro das Tabelas
********************************************************************************
PARAMETERS ptab
PRIVATE codi,nome,vlin,pos1,pos2,majuda,pv[3],cred[3]
PRIVATE vdado[2],vmask[2],vcabe[2],vedit[2]
vdado:={"codi","nome"}
vmask:={"999","@!"}
vcabe:={"C�digo","Nome"}
vedit:={.F.,.F.}
pv:={.T.,.T.,.T.}
IF ptab=1
   Sinal("TABELA","BANCOS")
   IF Abrearq((dircad+"WM_BANCO.DBF"),"Tab",.F.,10)
      SET INDEX TO (dircad+"WM_BANC1"),(dircad+"WM_BANC2")
   ELSE
      Mensagem("A Tabela de Bancos N�o Est� Disponivel !",4,1)
      RETURN
   ENDIF
   vmask[1]:="999"
   cred:={"J1","J2","J3"}
ELSEIF ptab=2
   Sinal("TABELA","TIPO PAGTO.")
   IF Abrearq((dircad+"WM_TIPAG.DBF"),"Tab",.F.,10)
      SET INDEX TO (dircad+"WM_TIPA1"),(dircad+"WM_TIPA2")
   ELSE
      Mensagem("A Tabela de Tipos de Pagamento N�o Est� Disponivel !",4,1)
      RETURN
   ENDIF
   vmask[1]:="!!!"
   cred:={"L1","L2","L3"}
ELSEIF ptab=3
   Sinal("TABELA","AGENT.COBR.")
   IF Abrearq((dircad+"WM_AGCOB.DBF"),"Tab",.F.,10)
      SET INDEX TO (dircad+"WM_AGCO1"),(dircad+"WM_AGCO2")
   ELSE
      Mensagem("A Tabela de Agentes Cobradores N�o Est� Disponivel !",4,1)
      RETURN
   ENDIF
   vmask[1]:="@R 99.99"
   cred:={"M1","M2","M3"}
ELSEIF ptab=4
   Sinal("TABELA","TIPO TRANS.")
   IF Abrearq((dircad+"WM_TIPTR.DBF"),"Tab",.F.,10)
      SET INDEX TO (dircad+"WM_TIPT1"),(dircad+"WM_TIPT2")
   ELSE
      Mensagem("A Tabela de Tipos de Transa��o N�o Est� Disponivel !",4,1)
      RETURN
   ENDIF
   vmask[1]:="!999"
   cred:={"N1","N2","N3"}
ELSEIF ptab=5
   Sinal("TABELA","GRUPO PRODS.")
   IF Abrearq((dircad+"FC_GRUPO.DBF"),"Tab",.F.,10)
      SET INDEX TO (dircad+"FC_GRUP1"),(dircad+"FC_GRUP2")
   ELSE
      Mensagem("A Tabela de Grupos de Produtos N�o Est� Disponivel !",4,1)
      RETURN
   ENDIF
   vmask[1]:="@R 99.99"
   cred:={"H1","H2","H3"}
ELSEIF ptab=6
   Sinal("TABELA","LOCAIS")
   IF Abrearq((dircad+"FC_LOCAL.DBF"),"Tab",.F.,10)
      SET INDEX TO (dircad+"FC_LOCA1"),(dircad+"FC_LOCA2")
   ELSE
      Mensagem("A Tabela de Locais de Estoque N�o Est� Disponivel !",4,1)
      RETURN
   ENDIF
   vmask[1]:="999"
   cred:={"I1","I2","I3"}
ELSEIF ptab=7
   Sinal("TABELA","EMPRESAS")
   IF Abrearq((dircad+"WM_EMPRE.DBF"),"Tab",.F.,10)
      SET INDEX TO (dircad+"WM_EMPR1"),(dircad+"WM_EMPR2")
   ELSE
      Mensagem("A Tabela de Empresas N�o Est� Disponivel !",4,1)
      RETURN
   ENDIF
   vmask[1]:="9"
   cred:={"O1","O2","O3"}
ELSEIF ptab=8
   Sinal("TABELA","S�CIOS")
   IF Abrearq((dircad+"WM_SOCIO.DBF"),"Tab",.F.,10)
      SET INDEX TO (dircad+"WM_SOCI1"),(dircad+"WM_SOCI2")
   ELSE
      Mensagem("A Tabela de S�cios N�o Est� Disponivel !",4,1)
      RETURN
   ENDIF
   vmask[1]:="9"
   cred:={"P1","P2","P3"}
ENDIF
// Informa��es para ajuda ao usu�rio.
mAjuda:={;
"F5         - Pesquisa pelo C�digo",;
"F6         - Pesquisa pelo Nome",;
"F9         - Impress�o da Tabela",;
"Ins        - Inclui um Novo Registro",;
"Ctrl+Enter - Edita o Registro sob cursor",;
"Del        - Exclui o Registro sob cursor",;
"Esc        - Finaliza"}
// Constru��o da Tela de Apresenta��o.
Abrejan(2)
SETCOLOR(vcr)
@ 23,00 SAY PADC("F1=Ajuda F5=C�digo F6=Nome F9=Impr Ins=Inclui Ctrl+Enter=Altera Del=Exclui <Esc>",80)
SETCOLOR(vcn)
pos1:=INT((77-MAX(LEN(codi),LEN(vcabe[01]))-MAX(LEN(nome),LEN(vcabe[02])))/2)
pos2:=pos1+MAX(LEN(codi),LEN(vcabe[01]))+3
// Chamada do procedimento de consulta desenvolvido com TBrowse.
ConsBrowse("Tab",03,01,22,78,vdado,vmask,vcabe,vedit,0,{|| Ftab()},;
           "codi",1,vmask[1],LEN(vmask[1]),"C�digo",;
           "nome",2,vmask[2],LEN(vmask[2]),"Nome")
CLOSE DATABASE
RETURN

*******************************************************************************
FUNCTION Ftab()
// Fun��o com op��es da Consulta
*******************************************************************************
LOCAL vtela,vreg
IF LASTKEY()=K_F2
   // Tecla <F2> - Redefinindo para anular pesquisa pela chave1
   RETURN .T.
ELSEIF LASTKEY()=K_F3
   // Tecla <F3> - Redefinindo para anular pesquisa pela chave2
   RETURN .T.
ELSEIF LASTKEY()=K_F5
   // Tecla <F5> - Pesquisa por C�digo
   @ 24,00 CLEAR
   SET ORDER TO 1
   vcodi:=SPACE(LEN(vdado[1]))
   @ 24,20 SAY "C�digo Desejado: " GET vcodi PICTURE vmask[1]
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
      Mensagem("Desculpe, C�digo N�o Encontrado !",3,1)
      GO rec
      RETURN .T.
   ENDIF
   RETURN .T.
ELSEIF LASTKEY()=K_F6
   // Tecla <F6> - Pesquisa por Nome
   @ 24,00 CLEAR
   SET ORDER TO 2
   vnome:=SPACE(LEN(nome))
   @ 24,05 SAY "Nome Desejado: " GET vnome PICTURE vmask[2]
   Le()
   IF EMPTY(vnome)
      RETURN .T.
   ENDIF
   rec:=RECNO()
   SET SOFTSEEK ON
   SEEK vnome
   SET SOFTSEEK OFF
   IF EOF()
      Mensagem("Desculpe, Nome N�o Encontrado !",3,1)
      GO rec
      RETURN .T.
   ENDIF
   RETURN .T.
ELSEIF LASTKEY()=K_F9
   // Tecla <F9> - Imprime Relat�rio
   vreg:=RECNO()
   vtela:=SAVESCREEN(01,00,23,79)
   Reltab(ptab)
   SELECT Tab
   GO vreg
   RESTSCREEN(01,00,23,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_INS
   // Tecla <Ins> - Inclus�o no browse.
   vlin:=ROW()
   IF pv[1]
      IF !Senha(cred[1])
         RETURN .T.
      ENDIF
      pv[1]:=.F.
   ENDIF
   SELECT("Tab")
   SET ORDER TO 1
   vtela:=SAVESCREEN(vlin-1,01,vlin+1,78)
   vcodi:=SPACE(LEN(codi))
   vnome:=SPACE(LEN(nome))
   @ vlin-1, 01 TO vlin+1,78
   SETCOLOR(vcn)
   @ vlin, pos1 GET vcodi PICTURE vmask[1]
   @ vlin, pos2 GET vnome PICTURE vmask[2]
   Aviso(24,"Digite os Novos Dados")
   Le()
   IF EMPTY(vcodi)
      RESTSCREEN(vlin-1,01,vlin+1,78,vtela)
      RETURN .T.
   ENDIF
   SET ORDER TO 1
   SEEK vcodi
   IF FOUND()
      Mensagem("Desculpe, C�digo j� Cadastrado !",3,1)
      RESTSCREEN(vlin-1,01,vlin+1,78,vtela)
      RETURN .T.
   ENDIF
   IF Confirme()
      IF Adireg(10)
         REPLACE codi WITH vcodi
         REPLACE nome WITH vnome
         UNLOCK
      ELSE
         Mensagem("Erro de Rede, Inclus�o N�o Efetuada!",3,1)
      ENDIF
      RESTSCREEN(vlin-1,01,vlin+1,78,vtela)
      RETURN .T.
   ENDIF
   RESTSCREEN(vlin-1,01,vlin+1,78,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_CTRL_ENTER
   // Tecla <Ctrl+Enter> - Altera��o no browse.
   vlin:=ROW()
   IF pv[2]
      IF !Senha(cred[2])
         RETURN .T.
      ENDIF
      pv[2]:=.F.
   ENDIF
   SELECT("Tab")
   vtela:=SAVESCREEN(vlin-1,01,vlin+1,78)
   vcodi:=codi
   vnome:=nome
   @ vlin-1, 01 TO vlin+1,78
   SETCOLOR(vcr)
   @ vlin, pos1 SAY vcodi PICTURE vmask[1]
   SETCOLOR(vcn)
   @ vlin, pos2 GET vnome PICTURE vmask[2]
   Aviso(24,"Altere os Dados ou Tecle <PgDn>")
   Le()
   IF UPDATED()
      IF Bloqreg(10)
         REPLACE nome WITH vnome
         UNLOCK
      ELSE
         Mensagem("O Registro N�o Est� Dispon�vel !",3,1)
      ENDIF
      RESTSCREEN(vlin-1,01,vlin+1,78,vtela)
      RETURN .T.
   ELSE
      RESTSCREEN(vlin-1,01,vlin+1,78,vtela)
      RETURN .T.
   ENDIF
ELSEIF LASTKEY()=K_DEL
   // Tecla <Del> - Exclus�o no browse.
   vlin:=ROW()
   IF pv[3]
      IF !Senha(cred[3])
         RETURN .T.
      ENDIF
      pv[3]:=.F.
   ENDIF
   SELECT("Tab")
   vtela:=SAVESCREEN(vlin-1,01,vlin+1,78)
   @ vlin-1, 01 TO vlin+1,78
   SETCOLOR(vcr)
   @ vlin, pos1 SAY codi PICTURE vmask[1]
   @ vlin, pos2 SAY nome PICTURE vmask[2]
   SETCOLOR(vcn)
   IF Exclui()
      IF Bloqreg(10)
         DELETE
         UNLOCK
      ELSE
         Mensagem("O Registro N�o Est� Dispon�vel !",3,1)
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
PROCEDURE Reltab(ptab)
// Relat�rio das Tabelas
*******************************************************************************
LOCAL vtit1,vtit2
IF ptab=1
   Sinal("BANCOS","RELAT�RIO")
   vtit1:="Relat�rio dos Bancos"
ELSEIF ptab=2
   Sinal("TIPO PAGTO.","RELAT�RIO")
   vtit1:="Relat�rio dos Tipos de Pagamento"
ELSEIF ptab=3
   Sinal("AGENT.COBR.","RELAT�RIO")
   vtit1:="Relat�rio dos Agentes de Cobran�a"
ELSEIF ptab=4
   Sinal("TIPO TRANS.","RELAT�RIO")
   vtit1:="Relat�rio dos Tipos de Transa��es"
ELSEIF ptab=5
   Sinal("GRUPO PRODS.","RELAT�RIO")
   vtit1:="Relat�rio dos Grupos de Produtos"
ELSEIF ptab=6
   Sinal("LOCAIS","RELAT�RIO")
   vtit1:="Relat�rio dos Locais de Estoque"
ELSEIF ptab=7
   Sinal("EMPRESAS","RELAT�RIO")
   vtit1:="Relat�rio das Empresas"
ELSEIF ptab=8
   Sinal("S�CIOS","RELAT�RIO")
   vtit1:="Relat�rio dos S�cios"
ENDIF
vtit2:="Ordem de c�digo"
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
   @ PROW()+1,pos1 SAY "C�digo"
   @ PROW()  ,pos2 SAY "Nome"
   @ PROW()+1,0 SAY REPLICATE("-",80)
   DO WHILE PROW()<58 .AND. .NOT. EOF()
      IF Escprint(80)
         RETURN
      ENDIF
      @ PROW()+1,pos1  SAY codi PICTURE vmask[1]
      @ PROW()  ,pos2  SAY nome PICTURE vmask[2]
      SKIP
   ENDDO
ENDDO
@ PROW()+2,0 SAY REPLICATE("=",80)
EJECT
SET PRINTER TO
SET DEVICE TO SCREEN
IF vcporta="2" // tela
   Imprtela(vcimpres,80)
ENDIF
RETURN

********************************************************************************
// ### ROTINA DE INDICES
********************************************************************************
/* Programa.: WM_INDIC.PRG
   Sistema..: Administra��o de Opera��es
   Autor....: Antonio J.M. Costa
   Data.....: 08/03/92
   Fun��o...: Cadastro dos Indices de Corre��o. */
********************************************************************************
PROCEDURE Matind(ptab)
// Manuten��o do Cadastro dos Indices
********************************************************************************
PRIVATE pv,cred,majuda
PRIVATE vdado[2],vmask[2],vcabe[2]
pv:={.T.,.T.,.T.}
IF ptab=1
   Sinal("COTA��O","D�LAR")
   IF Abrearq((dircad+"WM_DOLAR.DBF"),"Indice",.F.,10)
      SET INDEX TO (dircad+"WM_DOLA1")
   ELSE
      Mensagem("O Arquivo de Cota��o do D�lar N�o Est� Dispon�vel !",5,1)
      RETURN
   ENDIF
   cred:={"Q1","Q2","Q3"}
ELSEIF ptab=2
   Sinal("�NDICE","CORRE��O")
   IF Abrearq((dircad+"WM_INDIC.DBF"),"Indice",.F.,10)
      SET INDEX TO (dircad+"WM_INDI1")
   ELSE
      Mensagem("O Arquivo de �ndice de Corre��o N�o Est� Dispon�vel !",5,1)
      RETURN
   ENDIF
   cred:={"R1","R2","R3"}
ENDIF
GO TOP
vdado:={"data","valor"}
vmask:={"99/99/99","@E 999,999.99"}
vcabe:={"Data","Cota��o"}
vedit:={.F.,.F.}
// informa��es para ajuda ao usu�rio
mAjuda:={;
"F3         - Impress�o da Tabela",;
"F5         - Pesquisa pela Data",;
"Ins        - Inclui um Novo Registro",;
"Ctrl+Enter - Edita o Registro",;
"Del        - Exclui o Registro",;
"Esc        - Finaliza"}
Abrejan(2)
SETCOLOR(vcr)
@ 23,00 SAY PADC("F1=Ajuda F5=Data Ins=Inclui Ctrl+Enter=Altera Del=Exclui <Esc>",80)
SETCOLOR(vcn)
ConsBrowse("Indice",03,01,22,78,vdado,vmask,vcabe,vedit,0,{|| Fdbi()},;
           "data",1,vmask[1],LEN(vmask[1]),"Data")
CLOSE DATABASE
RETURN

********************************************************************************
FUNCTION Fdbi(modo)
// Fun��o para Consulta com DBEDIT
********************************************************************************
LOCAL vtela
IF LASTKEY()=K_INS
   vlin:=ROW()
   IF pv[1]
      IF !Senha(cred[1])
         RETURN .T.
      ENDIF
      pv[1]:=.F.
   ENDIF
   SELECT("Indice")
   vtela:=SAVESCREEN(vlin-1,02,vlin+1,76)  // Salva a tela.
   vdata:=CTOD(SPACE(8))
   vcota:=0.000
   @ vlin-1, 02 TO vlin+1,76
   SETCOLOR(vcn)
   @ vlin, 29  GET vdata PICTURE "99/99/99"
   @ vlin, 40  GET vcota PICTURE "@E 999,999.99"
   Aviso(24,"Digite os Novos Dados")
   Le()
   IF EMPTY(vdata)
      RESTSCREEN(vlin-1,02,vlin+1,76,vtela)
      RETURN .T.
   ENDIF
   SEEK vdata
   IF FOUND()
      Mensagem("Desculpe, Data j� Cadastrada !",3,1)
      RESTSCREEN(vlin-1,02,vlin+1,76,vtela)
      RETURN .T.
   ENDIF
   IF Confirme()
      APPEND BLANK
      REPLACE data WITH vdata,valor WITH vcota
   ENDIF
   RESTSCREEN(vlin-1,02,vlin+1,76,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_CTRL_ENTER
   vlin:=ROW()
   IF pv[2]
      IF !Senha(cred[2])
         RETURN .T.
      ENDIF
      pv[2]:=.F.
   ENDIF
   SELECT("Indice")
   vtela:=SAVESCREEN(vlin-1,02,vlin+1,76)  // Salva a tela.
   vdata:=Indice->data
   vcota:=Indice->valor
   @ vlin-1, 02 TO vlin+1,76
   SETCOLOR(vcn)
   @ vlin, 29  GET vdata PICTURE "99/99/99"
   @ vlin, 40  GET vcota PICTURE "@E 999,999.99"
   Aviso(24,"Altere os Dados ou Tecle <PgDn>")
   Le()
   IF UPDATED()
      IF Confirme()
         IF Bloqreg(10)
            REPLACE data WITH vdata,valor WITH vcota
         ELSE
            Mensagem("O Registro N�o Est� Dispon�vel!",3,1)
         ENDIF
      ENDIF
   ENDIF
   RESTSCREEN(vlin-1,02,vlin+1,76,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_DEL
   vlin:=ROW()
   IF pv[3]
      IF !Senha(cred[3])
         RETURN .T.
      ENDIF
      pv[3]:=.F.
   ENDIF
   SELECT("Indice")
   vtela:=SAVESCREEN(vlin-1,02,vlin+1,76)  // Salva a tela.
   @ vlin-1, 02 TO vlin+1,76
   SETCOLOR(vcr)
   @ vlin, 29  SAY data  PICTURE "99/99/99"
   @ vlin, 40  SAY valor PICTURE "@E 999,999.99"
   SETCOLOR(vcn)
   IF Exclui()
      IF Bloqreg(10)
         DELETE
      ELSE
         Mensagem("O Registro N�o Est� Dispon�vel!",3,1)
      ENDIF
      SKIP
   ENDIF
   RESTSCREEN(vlin-1,02,vlin+1,76,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_F2
   RETURN .T.
ELSEIF LASTKEY()=K_F5
   @ 24,00 CLEAR
   SET ORDER TO 1
   vdata:=CTOD(SPACE(8))
   @ 24,20 SAY "Data Desejada: " GET vdata
   Le()
   IF EMPTY(vdata)
      RETURN .T.
   ENDIF
   rec:=RECNO()
   SET SOFTSEEK ON
   SEEK vdata
   SET SOFTSEEK OFF
   IF EOF()
      Mensagem("Data N�o Encontrada !",5,1)
      GO rec
      RETURN .T.
   ENDIF
   RETURN .T.
ENDIF
RETURN .F.

********************************************************************************
// ### ROTINAS DE CADASTRO DE CONTAS BANC�RIAS
********************************************************************************
/* Programa.: WM_CTBAN.PRG
   Sistema..: Administra��o de Opera��es
   Autor....: Antonio J. M. Costa
   Data.....: 21/11/94
   Fun��o...: Cadastro de Contas Banc�rias.            */
********************************************************************************
PROCEDURE ConsCtb()
// Consultas e Pesquisas aos Registros do Arquivo de Dados
********************************************************************************
// Declara os vetores para a fun��o de consulta.
LOCAL vdado[11],vmask[11],vcabe[11],vedit[11]
// Vari�veis para verifica��o de senha.
PRIVATE pv1:=pv2:=pv3:=pv4:=pv5:=.T.
// Abertura dos arquivos de dados
vano:=RIGHT(STR(YEAR(DATE()),4),2)
marqs:={;
{(dirmov+"WM_CTBAN.DBF"),"Ctb","Contas Banc�rias",3},;
{(dircad+"WM_BANCO.DBF"),"Tban","Bancos",2},;
{(dirmov+"WM_SALDO.DBF"),"Sdo","Saldos Banc�rios",2},;
{(dirmov+"EC_PC"+vano+"E.DBF"),"Plc","Plano de Contas",2}}
IF !AbreArqs(marqs,.F.)
   RETURN
ENDIF
SELECT Plc
SET FILTER TO LEFT(Plc->codcta,3)==SPACE(03)
SELECT Ctb
// vdado: vetor dos nomes dos campos
vdado[1]:="ctb"
vdado[2]:='banco+LEFT(Procura("Tban",1,banco,"nome"),35)'
vdado[3]:="agenc"
vdado[4]:="conta"
vdado[5]:="nome"
vdado[6]:="contab"
vdado[7]:="cont"
vdado[8]:="ddd+telf"
vdado[9]:="data"
vdado[10]:='SaldoAtu(ctb)'
vdado[11]:='SaldoGer(ctb)'
// vmask: vetor das m�scaras de apresenta��o dos dados.
vmask[1]:="99"
vmask[2]:="@R 999-!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
vmask[3]:="@!"
vmask[4]:="@!"
vmask[5]:="@!"
vmask[6]:="@R 9999.99.99.999-9"
vmask[7]:="@!"
vmask[8]:="@R (X999)XX99-9999"
vmask[9]:="99/99/99"
vmask[10]:="@E 999,999,999.99"
vmask[11]:="@E 999,999,999.99"
// vcabe: vetor dos t�tulos para o cabe�alho das colunas.
vcabe[1]:="Codigo"
vcabe[2]:="Banco"
vcabe[3]:="Ag�ncia"
vcabe[4]:="N� C/C"
vcabe[5]:="Correntista"
vcabe[6]:="Contabilidade"
vcabe[7]:="Contato / Gerente"
vcabe[8]:="Telefone"
vcabe[9]:="Data"
vcabe[10]:="    Saldo Atual"
vcabe[11]:="Saldo Gerencial"
// vedit: vetor que determina os dados a serem editados.
AFILL(vedit,.T.)
vedit[1]:=.F.
vedit[2]:=.F.
vedit[3]:=.F.
vedit[4]:=.F.
// Informa��es para ajuda ao usu�rio.
majuda:={;
"Ins        - Inclui uma nova Conta Banc�ria no Sistema",;
"Ctrl+Enter - Altera a Conta Banc�ria sob Cursor",;
"Del        - Exclui a Conta Banc�ria sob Cursor",;
"Enter      - Consulta a Conta Banc�ria em Tela Cheia",;
"F2         - Pesquisa pelo C�digo da Conta Banc�ria",;
"F3         - Pesquisa pelo Nome do Correntista"}
// Constru��o da Tela de Apresenta��o.
Sinal("CONTAS","CONSULTA")
Abrejan(2)
@ 04,01 SAY REPLICATE("�",78)
// Barra de Tarefas.
SETCOLOR(vcr)
@ 22,00 SAY PADC("Ins=Inclui Ctrl+Enter=Altera Del=Exclui Enter=Consulta Esc=Encerra",80)
@ 23,00 SAY PADC("F1=Ajuda  F2=C�digoConta  F3=Correntista",80)
SETCOLOR(vcn)
// Chamada do procedimento de consulta desenvolvido com TBrowse.
ConsBrowse("Ctb",05,01,21,78,vdado,vmask,vcabe,vedit,1,{|| OpsCtb()},;
           "ctb" ,1,"99",2 ,"C�digoConta",;
           "nome",2,"@!",40,"Correntista")
CLOSE DATABASE
RETURN

********************************************************************************
FUNCTION OpsCtb()
// Op��es da consulta de Conta Banc�rias.
********************************************************************************
LOCAL vtela
// Destaque do browse
@ 03,03 CLEAR TO 03,77
@ 03,03 SAY "Conta:"
SETCOLOR(vcd)
@ 03,10 SAY Ctb->ctb+"-"+Ctb->nome
SETCOLOR(vcn)
// Teclas de op��es da consulta
IF LASTKEY()=K_INS
   // Ins - Inclus�o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatCtb(1)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_CTRL_ENTER
   // Ctrl+Enter - Altera��o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatCtb(2)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_DEL
   // Del - Exclus�o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatCtb(3)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_ENTER
   // Enter - Consulta em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatCtb(4)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
//ELSEIF LASTKEY()=K_F9
   // F9 - Relat�rio.
  // vtela:=SAVESCREEN(01,00,24,79)
  // RelCtb()
  // RESTSCREEN(01,00,24,79,vtela)
  // RETURN .T.
ENDIF
RETURN .F.

********************************************************************************
PROCEDURE MatCtb(modo)
/* Gerenciador de CTA.CORRENTE
   Parametros: modo - opera��o a ser realizada: 1 - Inclus�o
                                                2 - Altera�ao
                                                3 - Exclus�o */
********************************************************************************
IF modo=1
   IF pv1
      IF !Senha("S1")
         RETURN
      ENDIF
      pv1:=.F.
   ENDIF
   Sinal("CONTAS","INCLUS�O")
ELSEIF modo=2
   IF pv2
      IF !Senha("S2")
         RETURN
      ENDIF
      pv2:=.F.
   ENDIF
   Sinal("CONTAS","ALTERA��O")
ELSEIF modo=3
   IF pv3
      IF !Senha("S3")
         RETURN
      ENDIF
      pv3:=.F.
   ENDIF
   Sinal("CONTAS","EXCLUS�O")
ENDIF
SELECT Ctb
Abrejan(2)
DO WHILE .T.
   // Inicializa��o das vari�veis auxiliares.
   vctb   :=SPACE(02)
   vbanco :=SPACE(03)
   vagenc :=SPACE(10)
   vconta :=SPACE(12)
   vcontab:=SPACE(12)
   vnomeag:=vnome:=vcont:=SPACE(40)
   vddd   :=SPACE(04)
   vtel   :=SPACE(08)
   vdata  :=CTOD(SPACE(08))
   vsdoatu:=vsdoger:=0
   // Apresenta os t�tulos na tela
   TitCtb()
   IF modo#1 // Se n�o for Inclus�o
      // Transfere os dados do registro para as vari�veis auxiliares.
      TransfCtb()
   ENDIF
   // Mostra os dados com as variaveis auxiliares
   MostraCtb()
   IF modo=3 // Se for Exclus�o
      IF Exclui() // Deleta o registro do arquivo.
         IF Bloqreg(10)
            DELETE
            UNLOCK
         ELSE
            Mensagem("O Registro N�o Est� Dispon�vel !",3,1)
         ENDIF
      ENDIF
      EXIT
   ENDIF
   IF modo=4 // Se for Consulta
      SETCOLOR(vcr)
      @ 23,00 SAY PADC("PageUp=Pr�ximo Registro   PageDown=Registro Anterior   Esc=Retorna",80)
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
         "PgUp        - Exibe o Pr�ximo Registro",;
         "PgDn        - Exibe o Registro Anterior",;
         "Esc         - Volta � Tela de Consulta"}
         Ajuda2(mAjuda2)
         LOOP
      ENDIF
   ENDIF
   // Edita os Dados do Registro
   EditaCtb()
   IF LASTKEY()=K_ESC
      EXIT
   ENDIF
   IF !Confirme()
      LOOP
   ENDIF
   IF modo=1 // Inclus�o
      SET ORDER TO 3
      GO TOP
      SEEK vbanco+vagenc+vconta
      SET ORDER TO 1
      IF FOUND()
         Mensagem("Desculpe, Conta Banc�ria J� Cadastrada !",5,1)
         LOOP
      ENDIF
      // Inclui um novo registro no arquivo.
      IF Adireg(10)
         UNLOCK
      ELSE
         Mensagem("Erro de Rede, Inclus�o N�o Efetuada!",3,1)
      ENDIF
   ENDIF
   // Atualiza o conte�do dos campos do registro com as vari�veis auxiliares.
   IF Bloqreg(10)
      AtualCtb()
      COMMIT
      UNLOCK
   ELSE
      Mensagem("O Registro N�o Est� Dispon�vel !",3,1)
   ENDIF
   IF modo=1
      LOOP
   ENDIF
   EXIT
ENDDO
RETURN

********************************************************************************
STATIC PROCEDURE TitCtb()
// Apresenta os t�tulos do arquivo na tela.
********************************************************************************
SETCOLOR(vcn)
@ 05,03 SAY "C�digo_____________:"
@ 06,03 SAY "Banco______________:"
@ 07,03 SAY "Ag�ncia N�_________:"
@ 08,03 SAY "Conta Corrente N�__:"
@ 09,03 SAY "Nome da Ag�ncia____:"
@ 10,03 SAY "Nome do Correntista:"
@ 11,03 SAY "Contato / Gerente__:"
@ 12,03 SAY "Telefone___________:"
@ 13,03 SAY "Data de Abertura___:"
@ 14,03 SAY "Contabilidade______:"
@ 17,05 SAY "Saldo Atual______:"
@ 18,05 SAY "Saldo Gerencial__:"
@ 16,03 TO 19,41
RETURN

********************************************************************************
STATIC PROCEDURE MostraCtb()
// Mostra os dados do arquivo na tela.
********************************************************************************
SETCOLOR(vcd)
@ 05,24 SAY vctb      PICTURE "99"
@ 06,24 SAY vbanco    PICTURE "999"
Sayd(06,27,"-"+Procura("Tban",1,vbanco,"nome"),"@!",51)
@ 07,24 SAY vagenc    PICTURE "@!"
@ 08,24 SAY vconta    PICTURE "@!"
@ 09,24 SAY vnomeag   PICTURE "@!"
@ 10,24 SAY vnome     PICTURE "@!"
@ 11,24 SAY vcont     PICTURE "@!"
@ 12,24 SAY vddd      PICTURE "@R (X999)"
@ 12,30 SAY vtel      PICTURE "@R XX99-9999"
@ 13,24 SAY vdata     PICTURE "99/99/99"
@ 14,24 SAY vcontab   PICTURE "@R 9999.99.99.999-9"
Sayd(14,41,Procura("Plc",1,vcontab,"titcta"),"@X",36)
@ 17,24 SAY vsdoatu   PICTURE "@E 9,999,999.99"
@ 18,24 SAY vsdoger   PICTURE "@E 9,999,999.99"
SETCOLOR(vcn)
RETURN

********************************************************************************
STATIC PROCEDURE EditaCtb()
// Edita os dados do arquivo atrav�s das vari�veis auxiliares.
********************************************************************************
@ 24,00 CLEAR
Aviso(24,"Digite os Dados, ou Tecle <Esc> para Finalizar")
SETCOLOR(vcd)
@ 05,24 GET vctb    PICTURE "99"
@ 06,24 GET vbanco  PICTURE "999" VALID Banco(06,24)
@ 07,24 GET vagenc  PICTURE "@!"
@ 08,24 GET vconta  PICTURE "@!"
@ 09,24 GET vnomeag PICTURE "@!"
@ 10,24 GET vnome   PICTURE "@!"
@ 11,24 GET vcont   PICTURE "@!"
@ 12,24 GET vddd    PICTURE "@R (X999)" VALID Ddd(12,24)
@ 12,30 GET vtel    PICTURE "@R XX99-9999" VALID Telefone(12,30,"vtel")
@ 13,24 GET vdata   PICTURE "99/99/99"
@ 14,24 GET vcontab PICTURE "@R 9999.99.99.999-9" VALID Contab(14,24)
SETCOLOR(vcn)
Le()
IF LASTKEY()=K_ESC
   RETURN
ENDIF
RETURN

********************************************************************************
STATIC PROCEDURE TransfCtb()
// Transfere os dados dos campos do arquivo p/as vari�veis auxiliares.
********************************************************************************
vctb   :=Ctb->ctb
vbanco :=Ctb->banco
vagenc :=Ctb->agenc
vconta :=Ctb->conta
vnome  :=Ctb->nome
vnomeag:=Ctb->nomeag
vcont  :=Ctb->cont
vddd   :=Ctb->ddd
vtel   :=Ctb->telf
vdata  :=Ctb->data
vcontab:=Ctb->contab
vsdoatu:=SaldoAtu(vctb)
vsdoger:=SaldoGer(vctb)
RETURN

********************************************************************************
STATIC PROCEDURE AtualCtb()
// Atualiza os dados dos campos do arquivo com as variaveis auxiliares.
********************************************************************************
Ctb->ctb   :=vctb
Ctb->banco :=vbanco
Ctb->agenc :=vagenc
Ctb->conta :=vconta
Ctb->nome  :=vnome
Ctb->nomeag:=vnomeag
Ctb->cont  :=vcont
Ctb->ddd   :=vddd
Ctb->telf  :=vtel
Ctb->data  :=vdata
Ctb->contab:=vcontab
RETURN

******************************************************************************
PROCEDURE SaldoGer(pconta)
// Transfere os valores de Saldo do arquivo para as vari�veis
***************************
LOCAL areatu:=SELECT()
vsdoger:=0
SELECT Sdo
SET ORDER TO 2
GO TOP
Ultimo(pconta)
IF Sdo->ctb==pconta
   vsdoger:=Sdo->sdoger
ENDIF
SELECT(areatu)
RETURN vsdoger

******************************************************************************
PROCEDURE SaldoAtu(pconta)
// Transfere os valores de Saldo do arquivo para as vari�veis
***************************
LOCAL areatu:=SELECT()
vsdoatu:=0
SELECT Sdo
SET ORDER TO 2
GO TOP
Ultimo(pconta)
IF Sdo->ctb==pconta
   vsdoatu:=Sdo->sdoatu
ENDIF
SELECT(areatu)
RETURN vsdoatu

********************************************************************************
PROCEDURE Relctb(ordem)
/*
Objetivo : emite os relat�rios das contas banc�rias.
Par�metro: ordem: 1 -> por conta.
                  2 -> por correntista.
*/
********************************************************************************
// Atualiza a linha de status.
Sinal("CONTAS","RELAT�RIO")
// Abertura dos arquivos de dados
vano:=RIGHT(STR(YEAR(DATE()),4),2) // "04"
marqs:={{(dirmov+"WM_CTBAN.DBF"),"Ctb","Contas Banc�rias",3},;
        {(dircad+"WM_BANCO.DBF"),"Tban","Bancos",2},;
        {(dirmov+"EC_PC"+vano+"E.DBF"),"Plc","Plano de Contas",2}}
IF !AbreArqs(marqs,.F.)
   RETURN
ENDIF
SELECT Plc
SET FILTER TO LEFT(Plc->codcta,3)==SPACE(03)
SELECT Ctb
SET RELATION TO banco INTO Tban
IF ordem=1
   vcodi:=vcodf:=SPACE(2)
   SET ORDER TO 1
   // Pesquisa a faixa de codigos cujas registros devem ser impressos.
   Pesqint(2,"999","C�digos das Contas")
   bcond:={|vcod,vnome| vcod<=vcodf}
   vtit:="Ordem de C�digo"
ELSEIF ordem=2
   vcodi:=vcodf:=SPACE(40)
   SET ORDER TO 2
   // Pesquisa a faixa de nomes cujas registros devem ser impressos.
   Pesqint(40,"@!","Nomes de Correntistas")
   bcond:={|vcod,vnome| vnome<=vcodf}
   vtit:="Ordem de Correntista"
ENDIF
IF !Imprime2("Relat�rio das Contas Banc�rias")
   CLOSE DATABASE
   RETURN
ENDIF
pg:=0                   // Contador de p�ginas.
nr:=0
SET DEVICE TO PRINTER   // Direciona para a impressora.
SET PRINTER TO &vcimpres
// DO WHILE principal
DO WHILE !EOF() .AND. EVAL(bcond,banco,nome)
   // Impressao do cabe�alho.
   Cabe(vcnomeemp,vsist,"Relat�rio das Contas Banc�rias",vtit,80,vcia10)
   // Impressao dos dados.
   // DO WHILE das p�ginas.
   DO WHILE PROW()<58 .AND. !EOF() .AND. EVAL(bcond,banco,nome)
      IF Escprint(80)
         CLOSE DATABASE
         RETURN
      ENDIF
      // Impress�o dos dados.
      @ PROW()+1,01 SAY "C�digo:"+Ctb->ctb
      @ PROW()  ,11 SAY "Banco__: "+Ctb->banco
      @ PROW(),  29 SAY Tban->nome
      @ PROW()+1,11 SAY "Agencia: "+Ctb->agenc
      @ PROW(),  29 SAY Ctb->nomeag
      @ PROW()+1,11 SAY "Contato/Gerente_: "+Ctb->cont
      @ PROW()+1,11 SAY "Conta: "+Ctb->conta
      @ PROW(),  29 SAY Ctb->nome
      @ PROW()+1,11 SAY "Telefone: "+Ctb->ddd+Ctb->tel
      @ PROW(),  55 SAY "Data: "+DTOC(Ctb->data)
      @ PROW()+1,00 SAY REPLICATE("-",80)
      nr++
      SKIP
   ENDDO  // Fim do DO WHILE da p�gina.
ENDDO  // Fim do DO WHILE principal.
@ PROW()+1,0 SAY PADC("Registros Impressos: "+STR(nr,3))
@ PROW()+1,0 SAY PADC(" Fim  do  Relat�rio ",80,"=")
EJECT
SET PRINTER TO
SET DEVICE TO SCREEN
IF vcporta="2" // tela
   Imprtela(vcimpres,80)
ENDIF
CLOSE DATABASE
RETURN

********************************************************************************
// ### ROTINAS DE CADASTRO DE OPERA��ES
********************************************************************************
/* Programa.: WM_OPERA.PRG
   Sistema..: Administra��o de Opera��es
   Autor....: Antonio J.M. Costa
   Data.....: 24/11/94
   Fun��o...: Cadastro das Opera��es.                  */
********************************************************************************
PROCEDURE ConsOpe()
// Consultas e Pesquisas aos Registros do Arquivo de Dados
********************************************************************************
// Cria os vetores para a fun��o de consulta.
LOCAL vdado[03],vmask[03],vcabe[03],vedit[03]
// Vari�veis para verifica��o de senha.
PRIVATE pv1:=pv2:=pv3:=pv4:=pv5:=.T.
// Abertura do arquivo de dados
IF Abrearq((dircad+"WM_OPERA.DBF"),"Ope",.F.,10)
   SET INDEX TO (dircad+"WM_OPER1"), (dircad+"WM_OPER2")
ELSE
   Mensagem("Arquivo de Opera��es N�o Est� Dispon�vel !",5,1)
   RETURN
ENDIF
// vdado: vetor dos nomes dos campos
vdado[1]:="codi"
vdado[2]:="tipo"
vdado[3]:="nome"
// vmask: vetor das m�scaras de apresenta��o dos dados.
vmask[1]:="@!"
vmask[2]:="!"
vmask[3]:="@!"
// vcabe: vetor dos t�tulos para o cabe�alho das colunas.
vcabe[1]:="C�digo"
vcabe[2]:="Tipo"
vcabe[3]:="Descri��o"
// vedit: vetor que determina os dados a serem editados.
AFILL(vedit,.F.)
vedit[2]:=.T.
vedit[3]:=.T.
// Informa��es para ajuda ao usu�rio.
majuda:={;
"Ins        - Inclui uma nova Opera��o no Sistema",;
"Ctrl+Enter - Altera a Opera��o sob Cursor",;
"Del        - Exclui a Opera��o sob Cursor",;
"Enter      - Consulta a Opera��o em Tela Cheia",;
"F2         - Pesquisa pelo C�digo da Opera��o",;
"F3         - Pesquisa pela Descri��o da Opera��o"}
// Constru��o da Tela de Apresenta��o.
Sinal("OPERA��ES","CONSULTA")
Abrejan(2)
@ 04,01 SAY REPLICATE("�",78)
// Barra de Tarefas.
SETCOLOR(vcr)
@ 22,00 SAY PADC("Ins=Inclui Ctrl+Enter=Altera Del=Exclui Enter=Consulta Esc=Encerra",80)
@ 23,00 SAY PADC("F1=Ajuda  F2=C�digo  F3=Descri��o",80)
SETCOLOR(vcn)
// Chamada do procedimento de consulta desenvolvido com TBrowse.
ConsBrowse("Ope",05,01,21,78,vdado,vmask,vcabe,vedit,1,{|| OpsOpe()},;
           "codi",1,"@!",12,"C�digo",;
           "nome",2,"@!",40,"Descri��o")
CLOSE DATABASE
RETURN

********************************************************************************
FUNCTION OpsOpe()
// Op��es da consulta de Opera��es.
********************************************************************************
LOCAL vtela
// Destaque do browse
@ 03,03 CLEAR TO 03,77
@ 03,03 SAY "Opera��o:"
SETCOLOR(vcd)
@ 03,18 SAY Ope->codi+"-"+Ope->nome
SETCOLOR(vcn)
// Teclas de op��es da consulta
IF LASTKEY()=K_INS
   // Ins - Inclus�o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatOpe(1)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_CTRL_ENTER
   // Ctrl+Enter - Altera��o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatOpe(2)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_DEL
   // Del - Exclus�o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatOpe(3)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_ENTER
   // Enter - Consulta em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatOpe(4)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_F9
   // F9 - Relat�rio.
   vtela:=SAVESCREEN(01,00,24,79)
   RelOpe(1)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ENDIF
RETURN .F.

********************************************************************************
PROCEDURE MatOpe(modo)
/* Gerenciador de Opera��es
   Parametros: modo - opera��o a ser realizada: 1 - Inclus�o
                                                2 - Altera��o
                                                3 - Exclus�o */
********************************************************************************
IF modo=1
   IF pv1
      IF !Senha("G1")
         RETURN
      ENDIF
      pv1:=.F.
   ENDIF
   Sinal("OPERA�OES","INCLUS�O")
ELSEIF modo=2
   IF pv2
      IF !Senha("G2")
         RETURN
      ENDIF
      pv2:=.F.
   ENDIF
   Sinal("OPERA�OES","ALTERA��O")
ELSEIF modo=3
   IF pv3
      IF !Senha("G3")
         RETURN
      ENDIF
      pv3:=.F.
   ENDIF
   Sinal("OPERA�OES","EXCLUS�O")
ENDIF
SELECT Ope
Abrejan(2)
DO WHILE .T.
   // Inicializa��o das vari�veis auxiliares.
   vcodi:=SPACE(12)
   vnome:=SPACE(30)
   vtipo:=SPACE(1)
   // Apresenta os t�tulos na tela
   TitOpe()
   //
   IF modo#1 // Se n�o for Inclus�o
      // Transfere os dados do registro para as vari�veis auxiliares.
      vcodi:=Ope->codi
      vnome:=Ope->nome
      vtipo:=Ope->tipo
   ENDIF
   // Mostra os dados com as variaveis auxiliares
   MostraOpe()
   //
   IF modo=3 // Exclus�o
      IF Exclui() // Deleta o registro do arquivo.
         IF Bloqreg(10)
            DELETE
            UNLOCK
         ELSE
            Mensagem("O Registro N�o Est� Dispon�vel !",3,1)
         ENDIF
      ENDIF
      EXIT
   ENDIF
   IF modo=4 // Consulta
      SETCOLOR(vcr)
      @ 23,00 SAY PADC("PageUp=Pr�ximo Registro   PageDown=Registro Anterior   Esc=Retorna",80)
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
         "PgUp        - Exibe o Pr�ximo Registro",;
         "PgDn        - Exibe o Registro Anterior",;
         "Esc         - Volta � Tela de Consulta"}
         Ajuda2(mAjuda2)
         LOOP
      ENDIF
   ENDIF
   // Edita os Dados do Registro
   EditaOpe()
   IF LASTKEY()=K_ESC
      EXIT
   ENDIF
   IF !Confirme()
      LOOP
   ENDIF
   IF modo=1 // Inclus�o
      SET ORDER TO 1
      GO TOP
      SEEK vcodi
      IF FOUND()
         Mensagem("Desculpe, Opera��o J� Cadastrada !",5,1)
         LOOP
      ENDIF
      // Inclui um novo registro no arquivo.
      IF Adireg(10)
         UNLOCK
      ELSE
         Mensagem("Erro de Rede, Inclus�o N�o Efetuada!",3,1)
      ENDIF
   ENDIF
   // Atualiza o conte�do dos campos do registro com as vari�veis auxiliares.
   IF Bloqreg(10)
      Ope->codi:=vcodi;Ope->nome:=vnome;Ope->tipo:=vtipo
      COMMIT
      UNLOCK
   ELSE
      Mensagem("O Registro N�o Est� Dispon�vel !",3,1)
   ENDIF
   IF modo=1
      LOOP
   ENDIF
   EXIT
ENDDO
RETURN

********************************************************************************
STATIC PROCEDURE TitOpe()
// Apresenta os t�tulos do arquivo na tela.
********************************************************************************
SETCOLOR(vcn)
@ 07,05 SAY "C�digo da Opera��o_:"
@ 09,05 SAY "Nome da Opera��o___:"
@ 11,05 SAY "Tipo da Opera��o___:"
RETURN

********************************************************************************
STATIC PROCEDURE MostraOpe()
// Mostra os dados do arquivo na tela.
********************************************************************************
SETCOLOR(vcd)
@ 07,26 SAY vcodi  PICTURE "@!"
@ 09,26 SAY vnome  PICTURE "@!"
@ 11,26 SAY vtipo  PICTURE "!"
SETCOLOR(vcn)
RETURN

********************************************************************************
STATIC PROCEDURE EditaOpe()
// Edita os dados do arquivo atrav�s das vari�veis auxiliares.
********************************************************************************
Aviso(24,"Digite os Dados, ou Tecle <Esc> para Finalizar")
@ 11,30 SAY "( R=Receita, D=Despesa, T=T�tulo )"
SETCOLOR(vcd)
@ 07,26 GET vcodi PICTURE "@!"
@ 09,26 GET vnome PICTURE "@!"
@ 11,26 GET vtipo PICTURE "!" VALID vtipo$"RDT"
SETCOLOR(vcn)
Le()
IF LASTKEY()=K_ESC
   RETURN
ENDIF
Limpa(11,30,34)
RETURN

********************************************************************************
PROCEDURE RelOpe(ordem)
/*
Objetivo : emite o relat�rio das opera��es financeiras.
Par�metro: ordem: 1 -> por c�digo
                  2 -> por Descri��o da opera��o.
*/
********************************************************************************
// Atualiza a linha de status.
Sinal("OPERA��O","RELAT�RIO")
IF ordem=1
   vcodi:=vcodf:=SPACE(12)
   SET ORDER TO 1
   // Pesquisa a faixa de codigos cujas registros devem ser impressos.
   Pesqint(12,"@!","C�digos das Contas")
   bcond:={|vcod,vnome| vcod<=vcodf}
   vtit:="Ordem de C�digo"
ELSEIF ordem=2
   vcodi:=vcodf:=SPACE(40)
   SET ORDER TO 2
   // Pesquisa a faixa de nomes cujas registros devem ser impressos.
   Pesqint(40,"@!","Descri��o das Opera��es")
   bcond:={|vcod,vnome| vnome<=vcodf}
   vtit:="Ordem de Descri��o"
ENDIF
IF !Imprime2("Relat�rio das Opera��es Financeiras")
   RETURN
ENDIF
pg:=0                   // Contador de p�ginas.
nr:=0
SET DEVICE TO PRINTER   // Direciona para a impressora.
SET PRINTER TO &vcimpres
// DO WHILE principal
DO WHILE !EOF() .AND. EVAL(bcond,codi,nome)
   // Impressao do cabe�alho.
   Cabe(vcnomeemp,vsist,"Relat�rio das Opera��es Financeiras",vtit,80,vcia10)
   @ PROW()+1,01 SAY "C�digo"
   @ PROW()  ,15 SAY "Tipo"
   @ PROW()  ,20 SAY "Descri��o da Opera��o"
   @ PROW()+1,0 SAY REPLICATE("-",80)
   // Impressao dos dados.
   // DO WHILE das p�ginas.
   DO WHILE PROW()<58 .AND. !EOF() .AND. EVAL(bcond,codi,nome)
      IF Escprint(80)
         RETURN
      ENDIF
      // Impress�o dos dados.
      @ PROW()+1,01  SAY codi PICTURE "@!"
      @ PROW()  ,15  SAY tipo PICTURE "@!"
      @ PROW()  ,20  SAY nome PICTURE "@!"
      SKIP
   ENDDO  // Fim do DO WHILE das p�ginas.
ENDDO  // Fim do DO WHILE principal.
@ PROW()+1,0 SAY PADC(" Fim  do  Relat�rio ",80,"=")
EJECT
SET PRINTER TO
SET DEVICE TO SCREEN
IF vcporta="2" // tela
   Imprtela(vcimpres,80)
ENDIF
RETURN

********************************************************************************
// ### ROTINAS DE CADASTRO DE LAN�AMENTOS PADR�ES
********************************************************************************
PROCEDURE ConsLpa()
// Consultas e Pesquisas aos Registros do Arquivo de Dados
********************************************************************************
LOCAL vdado[4],vmask[4],vcabe[4],vedit[4]
// Vari�veis para verifica��o de senha.
PRIVATE pv1:=pv2:=pv3:=pv4:=pv5:=.T.
// Abertura do arquivo de dados
IF Abrearq((dircad+"EC_LANPA.DBF"),"Lpa",.F.,10)
   SET INDEX TO (dircad+"EC_LANP1"), (dircad+"EC_LANP2")
ELSE
   Mensagem("Arquivo de Lan�amentos Padr�es N�o Est� Dispon�vel !",5,1)
   RETURN
ENDIF
// vdado: vetor dos nomes dos campos
vdado[1]:="codigo"
vdado[2]:="debito"
vdado[3]:="credit"
vdado[4]:='LEFT(histor,25)'
// vmask: vetor das m�scaras de apresenta��o dos dados.
vmask[1]:="999"
vmask[2]:="@R 9999.99.99.999-9 999"
vmask[3]:="@R 9999.99.99.999-9 999"
vmask[4]:="@X"
// vcabe: vetor dos t�tulos para o cabe�alho das colunas.
vcabe[1]:="C�d"
vcabe[2]:="D�bito           Loc"
vcabe[3]:="Cr�dito          Loc"
vcabe[4]:="Hist�rico"
// vedit: vetor que determina os dados a serem editados.
AFILL(vedit,.T.)
vedit[1]:=.F.
// Informa��es para ajuda ao usu�rio.
majuda:={;
"Ins        - Inclui um novo Lan�amento Padr�o no Sistema",;
"Ctrl+Enter - Altera o Lan�amento Padr�o sob Cursor",;
"Del        - Exclui o Lan�amento Padr�o sob Cursor",;
"Enter      - Consulta o Lan�amento Padr�o em Tela Cheia",;
"F2         - Pesquisa pelo C�digo",;
"F3         - Pesquisa pelo Hist�rico",;
"F9         - Emite Relat�rio dos Lan�amentos Padr�es"}
// Constru��o da Tela de Apresenta��o.
Sinal("LAN�.PADR�O","CONSULTA")
Abrejan(2)
@ 04,01 SAY REPLICATE("�",78)
// Barra de Tarefas.
SETCOLOR(vcr)
@ 22,00 SAY PADC("Ins=Inclui Ctrl+Enter=Altera Del=Exclui Enter=Consulta Esc=Encerra",80)
@ 23,00 SAY PADC("F1=Ajuda  F2=C�digo  F3=Hist�rico  F9=Relat�rio",80)
SETCOLOR(vcn)
// Chamada do procedimento de consulta desenvolvido com TBrowse.
ConsBrowse("Lpa",05,01,21,78,vdado,vmask,vcabe,vedit,1,{|| OpsLpa()},;
           "codigo",1,"999",3,"C�digo",;
           "histor",2,"@X",20,"Hist�rico")
CLOSE DATABASE
RETURN

********************************************************************************
FUNCTION OpsLpa()
// Op��es da consulta de Lan�amentos Padr�es.
********************************************************************************
LOCAL vtela
// Destaque do browse
@ 03,03 CLEAR TO 03,77
@ 03,03 SAY "Lan�amento Padr�o:"
SETCOLOR(vcd)
@ 03,21 SAY Lpa->codigo+"-"+LEFT(Lpa->histor,30)
SETCOLOR(vcn)
// Teclas de op��es da consulta
IF LASTKEY()=K_INS
   // Ins - Inclus�o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatLpa(1)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_CTRL_ENTER
   // Ctrl+Enter - Altera��o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatLpa(2)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_DEL
   // Del - Exclus�o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatLpa(3)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_ENTER
   // Enter - Consulta em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatLpa(4)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_F9
   // F9 - Relat�rio.
   vtela:=SAVESCREEN(01,00,24,79)
   RelLpa()
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ENDIF
RETURN .F.

********************************************************************************
PROCEDURE MatLpa(modo)
/* Gerenciador de lan�amentos padr�es
   Parametros: modo - opera��o a ser realizada: 1 - Inclus�o
                                                2 - Altera��o
                                                3 - Exclus�o */
********************************************************************************
IF modo=1
   IF pv1
      IF !Senha("U1")
         RETURN
      ENDIF
      pv1:=.F.
   ENDIF
   Sinal("LAN�.PADR�O","INCLUS�O")
ELSEIF modo=2
   IF pv2
      IF !Senha("U2")
         RETURN
      ENDIF
      pv2:=.F.
   ENDIF
   Sinal("LAN�.PADR�O","ALTERA��O")
ELSEIF modo=3
   IF pv3
      IF !Senha("U3")
         RETURN
      ENDIF
      pv3:=.F.
   ENDIF
   Sinal("LAN�.PADR�O","EXCLUS�O")
ENDIF
SELECT Lpa
Abrejan(2)
SET ORDER TO 1
DO WHILE .T.
   // Inicializa��o das vari�veis auxiliares.
   vcodigo:=SPACE(03)
   vdebito:=SPACE(15)
   vcredit:=SPACE(15)
   vhistor:=SPACE(250)
   // Apresenta os t�tulos na tela
   TitLpa()
   IF modo#1 // Se n�o for Inclus�o
      // Transfere os dados do registro para as vari�veis auxiliares.
      vcodigo:=Lpa->codigo
      vdebito:=Lpa->debito
      vcredit:=Lpa->credit
      vhistor:=Lpa->histor
   ENDIF
   // Mostra os dados com as variaveis auxiliares
   MostraLpa()
   //
   IF modo=3 // Exclus�o
      IF Exclui()
         // Deleta o registro do arquivo.
         IF Bloqreg(10)
            DELETE
            UNLOCK
         ELSE
            Mensagem("O Registro N�o Est� Dispon�vel !",3,1)
         ENDIF
      ENDIF
      EXIT
   ENDIF
   //
   IF modo=4 // Consulta
      SETCOLOR(vcr)
      @ 23,00 SAY PADC("PageUp=Pr�ximo Registro   PageDown=Registro Anterior   Esc=Retorna",80)
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
         "PgUp        - Exibe o Pr�ximo Registro",;
         "PgDn        - Exibe o Registro Anterior",;
         "Esc         - Volta � Tela de Consulta"}
         Ajuda2(mAjuda2)
         LOOP
      ENDIF
   ENDIF
   // Edita os Dados do Registro
   EditaLpa()
   IF LASTKEY()=K_ESC
      EXIT
   ENDIF
   IF !Confirme()
      LOOP
   ENDIF
   IF modo=1 // Inclus�o
      SET ORDER TO 1
      GO TOP
      SEEK vcodigo
      IF FOUND()
         Mensagem("Desculpe, C�digo J� Cadastrado !",5,1)
         LOOP
      ENDIF
      // Inclui um novo registro no arquivo.
      IF Adireg(10)
         UNLOCK
      ELSE
         Mensagem("Erro de Rede, Inclus�o N�o Efetuada!",3,1)
      ENDIF
   ENDIF
   // Atualiza o conte�do dos campos do registro com as vari�veis auxiliares.
   IF Bloqreg(10)
      Lpa->codigo:=vcodigo
      Lpa->debito:=vdebito
      Lpa->credit:=vcredit
      Lpa->histor:=vhistor
      COMMIT
      UNLOCK
   ELSE
      Mensagem("O Registro N�o Est� Dispon�vel !",3,1)
   ENDIF
   IF modo=1
      LOOP
   ENDIF
   EXIT
ENDDO
RETURN

********************************************************************************
STATIC PROCEDURE TitLpa()
// Apresenta os t�tulos do arquivo na tela.
********************************************************************************
SETCOLOR(vcn)
@ 07,5 SAY "C�digo do Lan�amento Padr�o:"
@ 09,5 SAY "C�digo de D�bito___________:"
@ 11,5 SAY "C�digo de Cr�dito__________:"
@ 13,5 SAY "Hist�rico__________________:"
RETURN
********************************************************************************
STATIC PROCEDURE MostraLpa()
// Mostra os dados do arquivo na tela.
********************************************************************************
SETCOLOR(vcd)
@ 07,34 SAY vcodigo PICTURE "999"
@ 09,34 SAY vdebito PICTURE "@R 9999.99.99.999-9 999"
@ 11,34 SAY vcredit PICTURE "@R 9999.99.99.999-9 999"
@ 13,34 SAY vhistor PICTURE "@X"
SETCOLOR(vcn)
RETURN
********************************************************************************
STATIC PROCEDURE EditaLpa()
// Edita os dados do arquivo atrav�s das vari�veis auxiliares.
********************************************************************************
Aviso(24,"Digite os Dados, ou Tecle <Esc> para Finalizar")
SETCOLOR(vcd)
@ 07,34 GET vcodigo PICTURE "999"
@ 09,34 GET vdebito PICTURE "@R 9999.99.99.999-9 999"
@ 11,34 GET vcredit PICTURE "@R 9999.99.99.999-9 999"
@ 13,34 GET vhistor PICTURE "@X"
SETCOLOR(vcn)
Le()
IF LASTKEY()=K_ESC
   RETURN
ENDIF
RETURN

********************************************************************************
PROCEDURE RelLpa()
// Imprime rela��o dos Lan�amentos Padr�es.
********************************************************************************
vtit:="LAN�AMENTOS PADR�ES"
IF !Imprime2(vtit)
   RETURN
ENDIF
//
j:=0      // Contador dos registros impressos
pg:=1     // Contador de p�ginas.
SET DEVICE TO PRINTER
SET PRINTER TO &vcimpres
SET PRINTER ON
?? vcia12
SET PRINTER OFF
//
GO TOP
DO WHILE !EOF()
   @ PROW()+1,00  SAY vcemp+"-"+vcnomeemp+"   "+vtit+"           EMISS�O:"+TRANSFORM(DATE(),"99/99/99")+"   P�G.:"+STRZERO(pg++,4)
   @ PROW()+1,00  SAY REPLICATE("=",90)
   //                           10        20        30        40        50        60        70        80        90
   //                  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123
   @ PROW()+1,00  SAY "C�D  CONTA D�BITO          CONTA CR�DITO         HIST�RICO"
   //                  XXX  XXXX.XX.XX.XXX-X XXX  XXXX.XX.XX.XXX-X XXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   @ PROW()+1,00  SAY REPLICATE("=",90)
   //
   DO WHILE PROW()<60 .AND. !EOF()
      IF Escprint(80)
         RETURN
      ENDIF
      // Impress�o dos dados.
      @ PROW()+1,00 SAY Lpa->codigo PICTURE "999"
      @ PROW()  ,05 SAY Lpa->debito PICTURE "@R 9999.99.99.999-9 999"
      @ PROW()  ,27 SAY Lpa->credit PICTURE "@R 9999.99.99.999-9 999"
      @ PROW()  ,49 SAY LEFT(Lpa->histor,40) PICTURE "@X"
      SKIP
   ENDDO
   EJECT
ENDDO
//
SET PRINTER ON
?? vcid10+vcia10
SET PRINTER OFF
//
SET PRINTER TO
SET DEVICE TO SCREEN
IF vcporta="2" // tela
   Imprtela(vcimpres,160)
ENDIF
SELECT Lpa
RETURN

********************************************************************************
// ### ROTINAS DE CADASTRO DE LOJAS
********************************************************************************
PROCEDURE ConsLoja()
// Consultas e Pesquisas aos Registros do Arquivo de Dados
********************************************************************************
LOCAL vdado[16],vmask[16],vcabe[16],vedit[16]
// Vari�veis para verifica��o de senha.
PRIVATE pv1:=pv2:=pv3:=pv4:=pv5:=.T.
// Declara��o das variaveis auxiliares
PRIVATE vemp,vrazao,vcodi,vnome,vfanta,vcep,vende,vnum,vcomp,vbair
PRIVATE vmuni,vesta,vcodmuni,vcnpj,vinsc,vcont,vcargo,vddd,vtel,vfax,vemail
PRIVATE muf:=GeraMatriz((dirvm+"VM_CONFI.DBF"),"estados","ESTADOS")
// Abertura do arquivo de dados
IF Abrearq((dircad+"EC_MUNIC.DBF"),"Muni",.F.,10)
   SET INDEX TO (dircad+"EC_MUNI1"),(dircad+"EC_MUNI2")
ELSE
   Mensagem("Arquivo de Munic�pios N�o Est� Dispon�vel !",5,1)
   RETURN
ENDIF
IF Abrearq((dircad+"WM_LOJAS.DBF"),"Loja",.F.,10)
   SET INDEX TO (dircad+"WM_LOJA1"),(dircad+"WM_LOJA2")
   SET FILTER TO Loja->emp==vcemp
ELSE
   Mensagem("Arquivo de Lojas N�o Est� Dispon�vel !",5,1)
   RETURN
ENDIF
// vdado: vetor dos nomes dos campos
vdado[1] :="codi"
vdado[2] :="nome"
vdado[3] :="fanta"
vdado[4] :="ende"
vdado[5] :="bair"
vdado[6] :="muni"
vdado[7] :="codmuni"
vdado[8] :="esta"
vdado[9] :="cnpj"
vdado[10]:="insc"
vdado[11]:="cep"
vdado[12]:="cont"
vdado[13]:="cargo"
vdado[14]:="ddd+tel"
vdado[15]:="ddd+fax"
vdado[16]:="email"
// vmask: vetor das m�scaras de apresenta��o dos dados.
vmask[1] :="9"
vmask[2] :="@X"
vmask[3] :="@X"
vmask[4] :="@X"
vmask[5] :="@X"
vmask[6] :="@X"
vmask[7] :="99999"
vmask[8] :="!!"
vmask[9] :="99999999999999" // "@R 99.999.999/9999-99"
vmask[10]:="@!"
vmask[11]:="@R 99999-999"
vmask[12]:="@X"
vmask[13]:="@X"
vmask[14]:="@R (X999)XX99-9999"
vmask[15]:="@R (X999)XX99-9999"
vmask[16]:="@X"
// vcabe: vetor dos t�tulos para o cabe�alho das colunas.
vcabe[1] :="Loja"
vcabe[2] :="Nome"
vcabe[3] :="Fantasia"
vcabe[4] :="Endere�o"
vcabe[5] :="Bairro"
vcabe[6] :="Munic�pio"
vcabe[7] :="C�digo"
vcabe[8] :="UF"
vcabe[9] :="CNPJ"
vcabe[10]:="Inscri��o"
vcabe[11]:="CEP"
vcabe[12]:="Contato"
vcabe[13]:="Cargo"
vcabe[14]:="Telefone"
vcabe[15]:="Fax"
vcabe[16]:="Email"
// vedit: vetor que determina os dados a serem editados.
AFILL(vedit,.T.)
// Informa��es para ajuda ao usu�rio.
majuda:={;
"Ins        - Inclui uma nova Loja no Sistema",;
"Ctrl+Enter - Altera a Loja sob Cursor",;
"Del        - Exclui a Loja sob Cursor",;
"Enter      - Consulta a Loja em Tela Cheia",;
"F2         - Pesquisa pelo C�digo da Loja",;
"F3         - Pesquisa pelo Nome da Loja"}
// Constru��o da Tela de Apresenta��o.
Sinal("LOJAS","CONSULTA")
Abrejan(2)
@ 04,01 SAY REPLICATE("�",78)
// Barra de Tarefas.
SETCOLOR(vcr)
@ 22,00 SAY PADC("Ins=Inclui Ctrl+Enter=Altera Del=Exclui Enter=Consulta Esc=Encerra",80)
@ 23,00 SAY PADC("F1=Ajuda  F2=C�digo  F3=Nome",80)
SETCOLOR(vcn)
// Chamada do procedimento de consulta desenvolvido com TBrowse.
ConsBrowse("Loja",05,01,21,78,vdado,vmask,vcabe,vedit,1,{|| OpsLoja()},;
           "codi",1,"9",1,"C�digo",;
           "nome",2,"@X",10,"Nome")
CLOSE DATABASE
RETURN

********************************************************************************
FUNCTION OpsLoja()
// Op��es da consulta de Lojas.
********************************************************************************
LOCAL vtela
// Destaque do browse
@ 03,03 CLEAR TO 03,77
@ 03,03 SAY "Empresa:"
SETCOLOR(vcd)
@ 03,12 SAY Loja->emp+"-"+Loja->razao
SETCOLOR(vcn)
// Teclas de op��es da consulta
IF LASTKEY()=K_INS
   // Ins - Inclus�o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatLoja(1)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_CTRL_ENTER
   // Ctrl+Enter - Altera��o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatLoja(2)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_DEL
   // Del - Exclus�o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatLoja(3)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_ENTER
   // Enter - Consulta em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatLoja(4)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
//ELSEIF LASTKEY()=K_F9
   // F9 - Relat�rio.
  // vtela:=SAVESCREEN(01,00,24,79)
  // RelLoja()
  // RESTSCREEN(01,00,24,79,vtela)
  // RETURN .T.
ENDIF
RETURN .F.

********************************************************************************
PROCEDURE MatLoja(modo,instalando)
/* Gerenciador dos Registros de Lojas
   Parametros: modo - opera��o a ser realizada:
                  1 - Inclus�o
                  2 - Altera��o
                  3 - Exclusao
                  4 - Consulta */
********************************************************************************
IF instalando=NIL
   instalando=.F.
ENDIF
IF instalando
   // Declara��o das variaveis auxiliares
   PRIVATE vemp,vrazao,vcodi,vnome,vfanta,vcep,vende,vnum,vcomp,vbair
   PRIVATE vmuni,vesta,vcodmuni,vcnpj,vinsc,vcont,vcargo,vddd,vtel,vfax,vemail
   PRIVATE muf:=GeraMatriz((dirvm+"VM_CONFI.DBF"),"estados","ESTADOS")
ELSE
   IF modo=1
      IF pv1
         IF !Senha("E1")
            RETURN
         ENDIF
         pv1:=.F.
      ENDIF
      Sinal("LOJAS","INCLUS�O")
   ELSEIF modo=2
      IF pv2
         IF !Senha("E2")
            RETURN
         ENDIF
         pv2:=.F.
      ENDIF
      Sinal("LOJAS","ALTERA��O")
   ELSEIF modo=3
      IF pv3
         IF !Senha("E3")
            RETURN
         ENDIF
         pv3:=.F.
      ENDIF
      Sinal("LOJAS","EXCLUS�O")
   ENDIF
ENDIF
SELECT Loja
Abrejan(2)
SET ORDER TO 1
DO WHILE .T.
   // Inicializa��o das vari�veis auxiliares.
   IniVarLoja()
   IF modo=1 // Se for inclus�o
      IF !instalando
         vemp:=vcemp
      ENDIF
   ENDIF
   // Apresenta os t�tulos na tela
   TelaLoja()
   IF modo#1 // Se n�o for Inclus�o
      // Transfere os dados do registro para as vari�veis auxiliares.
      TransfLoja()
   ENDIF
   // Mostra os dados com as variaveis auxiliares
   MostraLoja()
   //
   IF modo=3 // Exclus�o
      IF Exclui()
         // Deleta o registro do arquivo.
         IF Bloqreg(10)
            DELETE
            UNLOCK
         ELSE
            Mensagem("O Registro N�o Est� Dispon�vel !",3,1)
         ENDIF
      ENDIF
      EXIT
   ENDIF
   IF modo=4 // Consulta
      SETCOLOR(vcr)
      @ 23,00 SAY PADC("PageUp=Pr�ximo Registro   PageDown=Registro Anterior   Esc=Retorna",80)
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
         "PgUp        - Exibe o Pr�ximo Registro",;
         "PgDn        - Exibe o Registro Anterior",;
         "Esc         - Volta � Tela de Consulta"}
         Ajuda2(mAjuda2)
         LOOP
      ENDIF
   ENDIF
   // Edita os Dados do Registro
   EditaLoja()
   IF LASTKEY()=K_ESC
      EXIT
   ENDIF
   IF !Confirme()
      LOOP
   ENDIF
   IF modo=1 // Inclus�o
      IF !instalando
         GO TOP
         SEEK vcodi
         IF FOUND()
            Mensagem("Desculpe, Loja J� Cadastrada !",5,1)
            LOOP
         ENDIF
      ENDIF
      // Inclui um novo registro no arquivo.
      IF Adireg(10)
         UNLOCK
      ELSE
         Mensagem("Erro de Rede, Inclus�o N�o Efetuada!",3,1)
      ENDIF
   ENDIF
   // Atualiza o conte�do dos campos do registro com as vari�veis auxiliares.
   IF Bloqreg(10)
      AtualLoja()
      COMMIT
      UNLOCK
   ELSE
      Mensagem("O Registro N�o Est� Dispon�vel !",3,1)
   ENDIF
   IF instalando
      SELECT Emp
      IF Adireg(10)
         Emp->codi:=vemp
         Emp->nome:=vrazao
         UNLOCK
      ELSE
         Mensagem("Erro de Rede, Inclus�o N�o Efetuada!",3,1)
      ENDIF
      EXIT
   ENDIF
   IF modo=1
      LOOP
   ENDIF
   EXIT
ENDDO
RETURN

********************************************************************************
PROCEDURE IniVarLoja()
// Inicializa��o das vari�veis auxiliares.
********************************************************************************
vemp    :=SPACE(01)
vrazao  :=SPACE(40)
vcodi   :=SPACE(01)
vnome   :=SPACE(10)
vfanta  :=SPACE(20)
vcep    :=SPACE(08)
vende   :=SPACE(40)
vnum    :=SPACE(05)
vcomp   :=SPACE(20)
vbair   :=SPACE(20)
vmuni   :=SPACE(20)
vesta   :=SPACE(02)
vcodmuni:=SPACE(05)
vcnpj   :=SPACE(14)
vinsc   :=SPACE(14)
vcont   :=SPACE(20)
vcargo  :=SPACE(15)
vddd    :=SPACE(04)
vtel    :=SPACE(08)
vfax    :=SPACE(08)
vemail  :=SPACE(50)
RETURN

********************************************************************************
PROCEDURE TelaLoja()
// Apresenta os t�tulos do arquivo na tela.
********************************************************************************
/*
                    10        20        30        40        50        60        70        80
           012345678901234567890123456789012345678901234567890123456789012345678901234567890
@ 04,02 SAY "Empresa:X  Raz�o Social:40XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
@ 06,02 SAY "Loja:X  Nome da Loja:40XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
@ 08,02 SAY "Fantasia:20XXXXXXXXXXXXXXXXXX  CEP:XXXXX-XXX
@ 08,02 SAY "Endere�o:40XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  N�mero:XXXXX
@ 10,02 SAY "Complemento:20XXXXXXXXXXXXXXXXXX  Bairro:XXXXXXXXXXXXXXXXXXXX
@ 12,02 SAY "UF:XX  Munic�pio:XXXXX-50XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
@ 14,02 SAY "CNPJ:18.XXX.XXX/XXXX-XX  Inscri��o:18XXXXXXXXXXXXXXXX
@ 16,02 SAY "Contato:20XXXXXXXXXXXXXXXXXX  Cargo:20XXXXXXXXXXXXXXXXXX
@ 18,02 SAY "DDD:XXX  Telefone:XXXX-XXXX  Fax:XXXX-XXXX
@ 20,02 SAY "Email:50XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
*/
SETCOLOR(vcn)
@ 03,05 SAY "Empresa:"
@ 03,16 SAY "Raz�o Social:"
@ 05,05 SAY "Loja:"
@ 05,13 SAY "Nome da Loja:"
@ 07,05 SAY "Fantasia:"
@ 07,36 SAY "CEP:"
@ 09,05 SAY "Endere�o:"
@ 09,56 SAY "N�mero:"
@ 11,05 SAY "Complemento:"
@ 11,39 SAY "Bairro:"
@ 13,05 SAY "UF:"
@ 13,12 SAY "Munic�pio:"
@ 15,05 SAY "CNPJ:"
@ 15,30 SAY "Inscri��o:"
@ 17,05 SAY "Contato:"
@ 17,35 SAY "Cargo:"
@ 19,05 SAY "DDD:"
@ 19,14 SAY "Telefone:"
@ 19,34 SAY "Fax:"
@ 21,05 SAY "Email:"
RETURN

********************************************************************************
PROCEDURE MostraLoja()
// Mostra os dados do arquivo na tela.
********************************************************************************
SETCOLOR(vcd)
@ 03,13 SAY vemp     PICTURE "9"
@ 03,29 SAY vrazao   PICTURE "@X"
@ 05,10 SAY vcodi    PICTURE "9"
@ 05,26 SAY vnome    PICTURE "@X"
@ 07,14 SAY vfanta   PICTURE "@X"
@ 07,40 SAY vcep     PICTURE "@R 99999-999"
@ 09,14 SAY vende    PICTURE "@X"
@ 09,63 SAY vnum     PICTURE "@X"
@ 11,17 SAY vcomp    PICTURE "@X"
@ 11,46 SAY vbair    PICTURE "@X"
@ 13,08 SAY vesta    PICTURE "!!"
@ 13,22 SAY vcodmuni PICTURE "99999"
Sayd(13,27,"-"+Procura("Muni",1,vesta+vcodmuni,"munnomex"),"@!",51)
@ 13,28 SAY IF(EMPTY(vcodmuni),vmuni,"")
Sayd(15,10,vcnpj,MaskCIC(vcnpj),18)
Sayd(15,40,vinsc,MaskIE(vesta,vinsc),18)
@ 17,13 SAY vcont    PICTURE "@X"
@ 17,41 SAY vcargo   PICTURE "@X"
Sayd(19,09,vddd,"@R XX99",4)
Sayd(19,23,vtel,"@R X999-9999",9)
Sayd(19,38,vfax,"@R X999-9999",9)
@ 21,11 SAY vemail   PICTURE "@X"
SETCOLOR(vcn)
RETURN

********************************************************************************
PROCEDURE EditaLoja()
// Edita os dados do arquivo atrav�s das vari�veis auxiliares.
********************************************************************************
@ 24,00 CLEAR
Limpa(15,10,18)
Limpa(15,40,18)
Aviso(24,"Digite os Dados ou <Esc> Para Retornar")
SETCOLOR(vcd)
@ 03,13 GET vemp     PICTURE "9"
@ 03,29 GET vrazao   PICTURE "@X"
@ 05,10 GET vcodi    PICTURE "9" VALID(!EMPTY(vcodi)) // .AND. EMPTY(ALLTRIM(Procura("Loja",1,vcodi,"codi"))))
@ 05,26 GET vnome    PICTURE "@X"
@ 07,14 GET vfanta   PICTURE "@X"
@ 07,40 GET vcep     PICTURE "@R 99999-999"
@ 09,14 GET vende    PICTURE "@X"
@ 09,63 GET vnum     PICTURE "@X"
@ 11,17 GET vcomp    PICTURE "@X"
@ 11,46 GET vbair    PICTURE "@X"
//@ 12,28 GET vmuni    PICTURE "@X"
@ 13,08 GET vesta    PICTURE "!!" VALID ASCAN(muf,vesta)>0
@ 13,22 GET vcodmuni PICTURE "99999" VALID CodMuni(13,22,vesta,"vcodmuni")
@ 15,10 GET vcnpj    PICTURE "99999999999999" VALID ValidaCIC(vcnpj,vesta)
@ 15,40 GET vinsc    PICTURE "@!" VALID ValidaIE(vesta,vinsc,vcnpj)
@ 17,13 GET vcont    PICTURE "@X"
@ 17,41 GET vcargo   PICTURE "@X"
@ 19,09 GET vddd     PICTURE "@R X999" VALID Ddd(19,09)
@ 19,23 GET vtel     PICTURE "@R XX99-9999" VALID Telefone(19,23,"vtel")
@ 19,38 GET vfax     PICTURE "@R XX99-9999" VALID Telefone(19,38,"vfax")
@ 21,11 GET vemail   PICTURE "@X"
SETCOLOR(vcn)
Le()
IF LASTKEY()==K_ESC
   RETURN
ENDIF
RETURN

********************************************************************************
PROCEDURE TransfLoja()
// Transfere os dados dos campos do arquivo para respectivas as vari�veis
// auxiliares.
********************************************************************************
vemp    :=Loja->emp
vrazao  :=Loja->razao
vcodi   :=Loja->codi
vnome   :=Loja->nome
vfanta  :=Loja->fanta
vcep    :=Loja->cep
vende   :=Loja->ende
vnum    :=Loja->num
vcomp   :=Loja->comp
vbair   :=Loja->bair
vmuni   :=Loja->muni
vesta   :=Loja->esta
vcodmuni:=Loja->codmuni
vcnpj   :=Loja->cnpj
vinsc   :=Loja->insc
vcont   :=Loja->cont
vcargo  :=Loja->cargo
vddd    :=Loja->ddd
vtel    :=Loja->tel
vfax    :=Loja->fax
vemail  :=Loja->email
RETURN

********************************************************************************
PROCEDURE AtualLoja()
// Atualiza os dados dos campos do arquivo com as variaveis auxiliares.
********************************************************************************
Loja->emp    :=vemp
Loja->razao  :=vrazao
Loja->codi   :=vcodi
Loja->nome   :=vnome
Loja->fanta  :=vfanta
Loja->cep    :=vcep
Loja->ende   :=vende
Loja->num    :=vnum
Loja->comp   :=vcomp
Loja->bair   :=vbair
Loja->muni   :=vmuni
Loja->esta   :=vesta
Loja->codmuni:=vcodmuni
Loja->cnpj   :=vcnpj
Loja->insc   :=vinsc
Loja->cont   :=vcont
Loja->cargo  :=vcargo
Loja->ddd    :=vddd
Loja->tel    :=vtel
Loja->fax    :=vfax
Loja->email  :=vemail
RETURN

********************************************************************************
// ### ROTINAS DE CADASTRO DE N�MERO DE SEGURAN�A
********************************************************************************
PROCEDURE ConsSeg()
// Consultas e Pesquisas aos Registros do Arquivo de Dados
********************************************************************************
LOCAL vdado[12],vmask[12],vcabe[12],vedit[12]
// Vari�veis para verifica��o de senha.
PRIVATE pv1:=pv2:=pv3:=pv4:=pv5:=.T.
// Declara��o das variaveis auxiliares
PRIVATE vloja,vserie,vmodelo,vaidf,vlimite,vnunfi,vnunff,vnunf
PRIVATE vtipods,vserds,vnudsi,vnudsf,vnuds
// Declara e carrega matrizes
PRIVATE mtab01:=TabSisif("01")
PRIVATE mtab09:=TabSisif("09")
// Abertura dos arquivos de dados
marqs:={;
{(dircad+"WM_LOJAS.DBF"),"Loja","Lojas",2},;
{(dirmov+"FC_NUSEG.DBF"),"Seg","N�mero de Seguran�a",1}}
IF !AbreArqs(marqs,.F.)
   RETURN
ENDIF
RELEASE marqs
SELECT Loja
SET FILTER TO Loja->emp==vcemp
SELECT Seg
// vdado: vetor dos nomes dos campos
vdado[1] :='loja+Procura("Loja",1,loja,"nome")'
vdado[2] :="serie"
vdado[3] :="modelo"
vdado[4] :="aidf"
vdado[5] :="limite"
vdado[6] :="nunfi"
vdado[7] :="nunff"
vdado[8] :="nunf"
vdado[9] :="serds"
vdado[10]:="nudsi"
vdado[11]:="nudsf"
vdado[12]:="nuds"
// vmask: vetor das m�scaras de apresenta��o dos dados.
vmask[1] :="@R 9-!!!!!!!!!!"
vmask[2] :="9"
vmask[3] :="99"
vmask[4] :="@R 99999/9999"
vmask[5] :="99/99/99"
vmask[6] :="99999"
vmask[7] :="99999"
vmask[8] :="99999"
vmask[9] :="!!"
vmask[10]:="9999999999"
vmask[11]:="9999999999"
vmask[12]:="9999999999"
// vcabe: vetor dos t�tulos para o cabe�alho das colunas.
vcabe[1] :="Loja"
vcabe[2] :="Serie"
vcabe[3] :="Modelo"
vcabe[4] :="AIDF"
vcabe[5] :="Limite"
vcabe[6] :="NF Inicial"
vcabe[7] :="NF Final"
vcabe[8] :="�ltima NF"
vcabe[9] :="Serie"
vcabe[10]:="N� Seg.Inicial"
vcabe[11]:="N� Seg.Final"
vcabe[12]:="�ltimo N� Seg."
// vedit: vetor que determina os dados a serem editados.
AFILL(vedit,.F.)
// Informa��es para ajuda ao usu�rio.
majuda:={;
"Ins        - Inclui um novo N�mero de Seguran�a no Sistema",;
"Ctrl+Enter - Altera o N�mero de Seguran�a sob Cursor",;
"Del        - Exclui o N�mero de Seguran�a sob Cursor",;
"Enter      - Consulta o N�mero de Seguran�a em Tela Cheia",;
"F2         - Pesquisa pela Loja"}
// Constru��o da Tela de Apresenta��o.
Sinal("N� SEGURAN�A","CONSULTA")
Abrejan(2)
@ 04,01 SAY REPLICATE("�",78)
// Barra de Tarefas.
SETCOLOR(vcr)
@ 22,00 SAY PADC("Ins=Inclui Ctrl+Enter=Altera Del=Exclui Enter=Consulta Esc=Encerra",80)
@ 23,00 SAY PADC("F1=Ajuda  F2=Loja",80)
SETCOLOR(vcn)
// Chamada do procedimento de consulta desenvolvido com TBrowse.
ConsBrowse("Seg",05,01,21,78,vdado,vmask,vcabe,vedit,0,{|| OpsSeg()},;
           "loja",1,"9",1,"Loja")
CLOSE DATABASE
RETURN

********************************************************************************
FUNCTION OpsSeg()
// Op��es da consulta do Registro de N�meros de Seguran�a.
********************************************************************************
LOCAL vtela
// Destaque do browse
@ 03,03 CLEAR TO 03,77
@ 03,03 SAY "Empresa:"
SETCOLOR(vcd)
@ 03,13 SAY vcemp+"-"+vcnomeemp
SETCOLOR(vcn)
// Teclas de op��es da consulta
IF LASTKEY()=K_INS
   // Ins - Inclus�o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatSeg(1)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_CTRL_ENTER
   // Ctrl+Enter - Altera��o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatSeg(2)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_DEL
   // Del - Exclus�o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatSeg(3)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_ENTER
   // Enter - Consulta em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatSeg(4)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
//ELSEIF LASTKEY()=K_F9
   // F9 - Relat�rio.
  // vtela:=SAVESCREEN(01,00,24,79)
  // RelSeg()
  // RESTSCREEN(01,00,24,79,vtela)
  // RETURN .T.
ENDIF
RETURN .F.

********************************************************************************
PROCEDURE MatSeg(modo)
/* Gerenciador dos Registros de N�mero de Seguran�a
   Parametros: modo - opera��o a ser realizada:
                  1 - Inclus�o
                  2 - Altera��o
                  3 - Exclusao
                  4 - Consulta */
********************************************************************************
IF modo=1
   IF pv1
      IF !Senha("F1")
         RETURN
      ENDIF
      pv1:=.F.
   ENDIF
   Sinal("N� SEGURAN�A","INCLUS�O")
ELSEIF modo=2
   IF pv2
      IF !Senha("F2")
         RETURN
      ENDIF
      pv2:=.F.
   ENDIF
   Sinal("N� SEGURAN�A","ALTERA��O")
ELSEIF modo=3
   IF pv3
      IF !Senha("F3")
         RETURN
      ENDIF
      pv3:=.F.
   ENDIF
   Sinal("N� SEGURAN�A","EXCLUS�O")
ENDIF
SELECT Seg
Abrejan(2)
SET ORDER TO 1
DO WHILE .T.
   // Inicializa��o das vari�veis auxiliares.
   IniVarSeg()
   // Apresenta os t�tulos na tela
   TelaSeg()
   IF modo#1 // Se n�o for Inclus�o
      // Transfere os dados do registro para as vari�veis auxiliares.
      TransfSeg()
   ENDIF
   // Mostra os dados com as variaveis auxiliares
   MostraSeg()
   //
   IF modo=3 // Exclus�o
      IF Exclui()
         // Deleta o registro do arquivo.
         IF Bloqreg(10)
            DELETE
            UNLOCK
         ELSE
            Mensagem("O Registro N�o Est� Dispon�vel !",3,1)
         ENDIF
      ENDIF
      EXIT
   ENDIF
   IF modo=4 // Consulta
      SETCOLOR(vcr)
      @ 23,00 SAY PADC("PageUp=Pr�ximo Registro   PageDown=Registro Anterior   Esc=Retorna",80)
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
         "PgUp        - Exibe o Pr�ximo Registro",;
         "PgDn        - Exibe o Registro Anterior",;
         "Esc         - Volta � Tela de Consulta"}
         Ajuda2(mAjuda2)
         LOOP
      ENDIF
   ENDIF
   // Edita os Dados do Registro
   EditaSeg()
   IF LASTKEY()=K_ESC
      EXIT
   ENDIF
   IF !Confirme()
      LOOP
   ENDIF
   IF modo=1 // Inclus�o
      // Inclui um novo registro no arquivo.
      IF Adireg(10)
         UNLOCK
      ELSE
         Mensagem("Erro de Rede, Inclus�o N�o Efetuada!",3,1)
      ENDIF
   ENDIF
   // Atualiza o conte�do dos campos do registro com as vari�veis auxiliares.
   IF Bloqreg(10)
      AtualSeg()
      COMMIT
      UNLOCK
   ELSE
      Mensagem("O Registro N�o Est� Dispon�vel !",3,1)
   ENDIF
   IF modo=1
      LOOP
   ENDIF
   EXIT
ENDDO
RETURN

********************************************************************************
PROCEDURE IniVarSeg()
// Inicializa��o das vari�veis auxiliares.
********************************************************************************
vloja    :=SPACE(01)
vserie   :=SPACE(01)
vmodelo  :=SPACE(02)
vaidf    :=SPACE(09)
vlimite  :=CTOD(SPACE(08))
vnunfi   :=SPACE(05)
vnunff   :=SPACE(05)
vnunf    :=SPACE(05)
vtipods  :=SPACE(02)
vserds   :=SPACE(02)
vnudsi   :=SPACE(10)
vnudsf   :=SPACE(10)
vnuds    :=SPACE(10)
RETURN

********************************************************************************
PROCEDURE TelaSeg()
// Apresenta os t�tulos do arquivo na tela.
********************************************************************************
SETCOLOR(vcn)
@ 04,05 SAY "Empresa:"
@ 05,05 SAY "Loja:"
@ 06,05 SAY "Serie:"
@ 07,05 SAY "Modelo:"
@ 08,05 SAY "AIDF:"
@ 09,05 SAY "Data Limite para Emiss�o:"
@ 10,05 SAY "NF Inicial:"
@ 11,05 SAY "NF Final..:"
@ 12,05 SAY "�ltima NF.:"
@ 13,05 SAY "Tipo:"
@ 14,05 SAY "Serie:"
@ 15,05 SAY "N� Seg.Inicial:"
@ 16,05 SAY "N� Seg.Final..:"
@ 17,05 SAY "�ltimo N� Seg.:"
RETURN

********************************************************************************
PROCEDURE MostraSeg()
// Mostra os dados do arquivo na tela.
********************************************************************************
SETCOLOR(vcd)
@ 04,13 SAY vcemp       PICTURE "9"
@ 04,14 SAY "-"+vcnomeemp PICTURE "@!"
@ 05,10 SAY vloja       PICTURE "9"
Sayd(05,11,IF(!EMPTY(vloja),"-"+Loja(vloja),""),"@!",11)
@ 06,11 SAY vserie      PICTURE "9"
@ 07,12 SAY vmodelo     PICTURE "99"
Sayd(07,14,IF(!EMPTY(vmodelo),"-"+mtab01[Mascan(mtab01,1,vmodelo),2],""),"@!",66)
@ 08,10 SAY vaidf       PICTURE "@R 99999/9999"
@ 09,30 SAY vlimite     PICTURE "99/99/99"
@ 10,16 SAY vnunfi      PICTURE "99999"
@ 11,16 SAY vnunff      PICTURE "99999"
@ 12,16 SAY vnunf       PICTURE "99999"
@ 13,10 SAY vtipods  PICTURE "99"
Sayd(13,12,IF(!EMPTY(vtipods),"-"+mtab09[Mascan(mtab09,1,vtipods),2],""),"@!",66)
@ 14,11 SAY vserds      PICTURE "!!"
@ 15,20 SAY vnudsi      PICTURE "9999999999"
@ 16,20 SAY vnudsf      PICTURE "9999999999"
@ 17,20 SAY vnuds       PICTURE "9999999999"
SETCOLOR(vcn)
RETURN

********************************************************************************
PROCEDURE EditaSeg()
// Edita os dados do arquivo atrav�s das vari�veis auxiliares.
********************************************************************************
@ 24,00 CLEAR
Aviso(24,"Digite os Dados ou <Esc> Para Retornar")
SETCOLOR(vcd)
@ 05,10 GET vloja       PICTURE "9" VALID Lojas(05,10)
@ 06,11 GET vserie      PICTURE "9" VALID !EMPTY(vserie)
@ 07,12 GET vmodelo     PICTURE "99" VALID Modelo(07,12)
@ 08,10 GET vaidf       PICTURE "@R 99999/9999" VALID !EMPTY(vaidf)
@ 09,30 GET vlimite     PICTURE "99/99/99" VALID !EMPTY(vlimite)
@ 10,16 GET vnunfi      PICTURE "99999" VALID !EMPTY(vnunfi)
@ 11,16 GET vnunff      PICTURE "99999" VALID VAL(vnunff)>VAL(vnunfi)
@ 12,16 GET vnunf       PICTURE "99999" VALID !EMPTY(vnunf)
@ 13,10 GET vtipods     PICTURE "99" VALID Tipods(13,10)
@ 14,11 GET vserds      PICTURE "!!" VALID IF(vtipods="01",!EMPTY(vserds),.T.)
@ 15,20 GET vnudsi      PICTURE "9999999999" VALID !EMPTY(vnudsi)
@ 16,20 GET vnudsf      PICTURE "9999999999" VALID VAL(vnudsf)>VAL(vnudsi)
@ 17,20 GET vnuds       PICTURE "9999999999" VALID !EMPTY(vnuds)
SETCOLOR(vcn)
Le()
IF LASTKEY()==K_ESC
   RETURN
ENDIF
RETURN

********************************************************************************
PROCEDURE TransfSeg()
// Transfere os dados dos campos do arquivo para respectivas as vari�veis
// auxiliares.
********************************************************************************
vloja    :=Seg->loja
vserie   :=Seg->serie
vmodelo  :=Seg->modelo
vaidf    :=Seg->aidf
vlimite  :=Seg->limite
vnunfi   :=Seg->nunfi
vnunff   :=Seg->nunff
vnunf    :=Seg->nunf
vtipods  :=Seg->tipods
vserds   :=Seg->serds
vnudsi   :=Seg->nudsi
vnudsf   :=Seg->nudsf
vnuds    :=Seg->nuds
RETURN

********************************************************************************
PROCEDURE AtualSeg()
// Atualiza os dados dos campos do arquivo com as variaveis auxiliares.
********************************************************************************
Seg->loja    :=vloja
Seg->serie   :=vserie
Seg->modelo  :=vmodelo
Seg->aidf    :=vaidf
Seg->limite  :=vlimite
Seg->nunfi   :=vnunfi
Seg->nunff   :=vnunff
Seg->nunf    :=vnunf
SEg->tipods  :=vtipods
Seg->serds   :=vserds
Seg->nudsi   :=vnudsi
Seg->nudsf   :=vnudsf
Seg->nuds    :=vnuds
RETURN

********************************************************************************
// ### ROTINAS DE CADASTRO DE ENCERRAMENTO DE PERIODOS DE TRABALHO
********************************************************************************
PROCEDURE ConsEpt()
// Consultas e Pesquisas aos Registros do Arquivo de Dados
********************************************************************************
// Declara��o das variaveis auxiliares
LOCAL vdado[1],vmask[1],vcabe[1],vedit[1]
PRIVATE pv1:=pv2:=pv3:=pv4:=pv5:=.T.
PRIVATE vano, vmes, vqui, majuda
// Abertura do arquivo de dados
IF Abrearq((dirmov+"EC_ENCER.DBF"),"Ept",.F.,10)
   SET INDEX TO (dirmov+"EC_ENCE1")
ELSE
   Mensagem("Arquivo de Encerramento de Per�odos de Trabalho N�o Est� Dispon�vel !",5,1)
   RETURN
ENDIF
// vdado: vetor dos nomes dos campos
vdado[1] :="RIGHT(anomes,1)+'� Quinzena de '+LEFT(Mes(SUBSTR(anomes,5,2)),3)+'/'+LEFT(anomes,4)"
// vmask: vetor das m�scaras de apresenta��o dos dados.
vmask[1] :="@X"
// vcabe: vetor dos t�tulos para o cabe�alho das colunas.
vcabe[1] :="Per�odo Encerrado"
// vedit: vetor que determina os dados a serem editados.
AFILL(vedit,.F.)
// Informa��es para ajuda ao usu�rio.
majuda:={;
"F2         - Pesquisa pelo Ano/M�s",;
"Ins        - Inclui um novo Registro de Encerramento",;
"Del        - Exclui o Registro de Encerramento sob Cursor",;
"Esc        - Retorna ao menu Principal"}
// Constru��o da Tela de Apresenta��o.
Sinal("ENCERRAMENTO","CONSULTA")
Abrejan(2)
@ 04,01 SAY REPLICATE("�",78)
// Barra de Tarefas.
SETCOLOR(vcr)
@ 23,00 SAY PADC("F1=Ajuda F2=Pesquisa Ins=Encerra Del=Desencerra Esc=Retorna",80)
SETCOLOR(vcn)
// Chamada do procedimento de consulta desenvolvido com TBrowse.
ConsBrowse("Ept",03,01,22,78,vdado,vmask,vcabe,vedit,0,{|| OpsEpt()},;
           "anomes",1,"@R 9999/99",6,"Ano/Mes")
CLOSE DATABASE
RETURN

********************************************************************************
FUNCTION OpsEpt()
// Op��es da consulta do Registro de Encerramento de Per�odos de Trabalho.
********************************************************************************
LOCAL vtela
// Teclas de op��es da consulta
IF LASTKEY()=K_INS
   // Ins - Inclus�o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatEpt(1)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_DEL
   // Del - Exclus�o em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatEpt(3)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ELSEIF LASTKEY()=K_ENTER
   // Enter - Consulta em tela cheia.
   vtela:=SAVESCREEN(01,00,24,79)
   MatEpt(4)
   RESTSCREEN(01,00,24,79,vtela)
   RETURN .T.
ENDIF
RETURN .F.

********************************************************************************
PROCEDURE MatEpt(modo)
/* Gerenciador dos Registros de Encerramento de Per�odos de Trabalho
   Parametros: modo - opera��o a ser realizada:
                  1 - Inclus�o
                  3 - Exclusao */
********************************************************************************
IF modo=1
   IF pv1
      IF !Senha("32")
         RETURN
      ENDIF
      pv1:=.F.
   ENDIF
   Sinal("ENCERRAMENTO","INCLUS�O")
ELSEIF modo=3
   IF pv2
      IF !Senha("32")
         RETURN
      ENDIF
      pv2:=.F.
   ENDIF
   Sinal("ENCERRAMENTO","EXCLUS�O")
ENDIF
SELECT Ept
Abrejan(2)
SET ORDER TO 1
DO WHILE .T.
   // Inicializa��o das vari�veis auxiliares.
   IniVarEpt()
   // Apresenta os t�tulos na tela
   TelaEpt()
   IF modo#1 // Se n�o for Inclus�o
      // Transfere os dados do registro para as vari�veis auxiliares.
      TransfEpt()
   ENDIF
   // Mostra os dados com as variaveis auxiliares
   MostraEpt()
   //
   IF modo=3 // Exclus�o
      IF Exclui()
         // Deleta o registro do arquivo.
         IF Bloqreg(10)
            DELETE
            UNLOCK
         ELSE
            Mensagem("O Registro N�o Est� Dispon�vel !",3,1)
         ENDIF
      ENDIF
      EXIT
   ENDIF
   IF modo=4 // Consulta
      SETCOLOR(vcr)
      @ 23,00 SAY PADC("PageUp=Pr�ximo Registro   PageDown=Registro Anterior   Esc=Retorna",80)
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
         "PgUp        - Exibe o Pr�ximo Registro",;
         "PgDn        - Exibe o Registro Anterior",;
         "Esc         - Volta � Tela de Consulta"}
         Ajuda2(mAjuda2)
         LOOP
      ENDIF
   ENDIF
   // Edita os Dados do Registro
   EditaEpt()
   IF LASTKEY()=K_ESC
      EXIT
   ENDIF
   IF !Confirme()
      LOOP
   ENDIF
   IF modo=1 // Inclus�o
      // Inclui um novo registro no arquivo.
      IF Adireg(10)
         Ept->anomes:=""
         UNLOCK
      ELSE
         Mensagem("Erro de Rede, Inclus�o N�o Efetuada!",3,1)
      ENDIF
   ENDIF
   // Atualiza o conte�do dos campos do registro com as vari�veis auxiliares.
   IF Bloqreg(10)
      AtualEpt()
      COMMIT
      UNLOCK
   ELSE
      Mensagem("O Registro N�o Est� Dispon�vel !",3,1)
   ENDIF
   IF modo=1
      LOOP
   ENDIF
   EXIT
ENDDO
RETURN

********************************************************************************
PROCEDURE IniVarEpt()
// Inicializa��o das vari�veis auxiliares.
********************************************************************************
vqui :=SPACE(1)
vmes :=SPACE(2)
vano :=SPACE(4)
RETURN

********************************************************************************
PROCEDURE TelaEpt()
// Apresenta os t�tulos do arquivo na tela.
********************************************************************************
@ 05,14 SAY "Quinzena:"
@ 07,14 SAY "M�s.....:"
@ 09,14 SAY "Ano.....:"
RETURN

********************************************************************************
PROCEDURE MostraEpt()
// Mostra os dados do arquivo na tela.
********************************************************************************
SETCOLOR(vcd)
@ 05,23 SAY vqui+"Quinzena" PICTURE "@R 9� !XXXXXXXX"
@ 07,23 SAY vmes+Mes(vmes) PICTURE "@R 99 !XXXXXXXX"
@ 09,23 SAY vano PICTURE "9999"
SETCOLOR(vcn)
RETURN

********************************************************************************
PROCEDURE EditaEpt()
// Edita os dados do arquivo atrav�s das vari�veis auxiliares.
********************************************************************************
@ 24,00 CLEAR
Aviso(24,"Digite os Dados ou <Esc> Para Retornar")
SETCOLOR(vcd)
@ 05,23 GET vqui PICTURE "9" VALID vqui$"12"
@ 07,23 GET vmes PICTURE "99" VALID vdMes(07,23,vmes)
@ 09,23 GET vano PICTURE "9999" VALID(!EMPTY(vano))
SETCOLOR(vcn)
Le()
IF LASTKEY()==K_ESC
   RETURN
ENDIF
RETURN

FUNCTION vdMes(linha,coluna,pmes)
pmes:=Zeracod(pmes)
IF VAL(pmes) > 0 .AND. VAL(pmes) < 13
   @ 07,23 SAY pmes+Mes(pmes) PICTURE "@R 99 !XXXXXXXX"
   RETURN .T.
ENDIF
RETURN .F.

********************************************************************************
PROCEDURE TransfEpt()
// Transfere os dados dos campos do arquivo para respectivas as vari�veis
// auxiliares.
********************************************************************************
vano:=LEFT(Ept->anomes,4)
vmes:=SUBSTR(Ept->anomes,5,2)
vqui:=RIGHT(Ept->anomes,1)
RETURN

********************************************************************************
PROCEDURE AtualEpt()
// Atualiza os dados dos campos do arquivo com as variaveis auxiliares.
********************************************************************************
Ept->anomes:=vano+vmes+vqui
RETURN

*******************************************************************************
//                                  F i m
*******************************************************************************


