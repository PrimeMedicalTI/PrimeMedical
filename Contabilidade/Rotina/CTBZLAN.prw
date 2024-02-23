#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function CTBZLAN()

//----------------------------------------------------------------------------
//|Programa  | CTBZLAN     | Autor | TITO DUARTE         |Criado| 08.Jan.2005|
//----------------------------------------------------------------------------
//|Descricao | Limpa os campos abaixo permitindo nova importa��o dos lan�a-  |
//|          | mentos para a Contagbilidade Gerencial                        |
//|          | Financeiro : E1_LA,E2_LA,EV_LA,EZ_LA,E5_LA,EF_LA              |
//|          | Fiscal     :                                                  |
//|          | Doc.Entrada:                                                  |
//|          | Doc.Saida  :                                                  |
//|          | ALTERADO   : POR TITO DUARTE                                  |
//----------------------------------------------------------------------------
//|Uso       | SIGACTB                                                       |
//----------------------------------------------------------------------------

SetPrvt("CSTRING,NLASTKEY,CCANCEL,WREGUA,LCONTINUA,WREGNAT")

//If Alltrim(UPPER(Substr(cUsuario,7,15))) <> "ADMINISTRADOR" .AND. Alltrim(UPPER(Substr(cUsuario,7,15))) <> "WILLIANNE"
//   Msgbox("Apenas o Administrador tem Acesso a Esta Rotina","Atencao","ALERT")
//   Return
//Endif

nLastKey := 0
cCancel  := "######## CANCELADO PELO OPERADOR ###########"
wRegua   := 0
cPerg    := PADR("PVLAN5",10)
Criaperg()

//ALTERADO PARA A ROTINA SER EXECUTADA SOMENTE PELO ADMINISTRADOR - TIAGO LIMA 07/08/2006
//IF SUBSTR(cUsuario,7,14) = "Administrador"

PERGUNTE(cPerg,.T.)

//�������������������������������������������������������������Ŀ
//� Variaveis utilizadas para par�metros                        �
//� mv_par01            // data inicial                         �
//� mv_par02            // data final                           �
//� mv_par03            // 1-Financeiro                         �
//�                        2-Fiscal                             �
//�                        3-Doc.Entrada                        �
//�                        4-Doc.Saida                          �
//���������������������������������������������������������������

@ 96,42 TO 323,505 DIALOG oDlg5 TITLE "Limpar Flag Integra��o Cont�bil"
@ 8,10 TO 84,222
@ 23,15 SAY "Este programa inicializa os registros do Per�odo selecionados,"
@ 33,15 SAY "permitindo nova integra��o com a Contabilidade Gerencial."
@ 53,15 SAY "ANTES DE CONFIRMAR VERIFIQUE SE OS DADOS ESTAO REALMENTE CORRETOS!" 
@ 70,15 SAY "Desenvolvido: TL Consultoria"
@ 91,139 BMPBUTTON TYPE 5 ACTION Pergunte("PVLAN5")
@ 91,168 BMPBUTTON TYPE 1 ACTION OkProc()
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
ACTIVATE DIALOG oDlg5

If nLastKey = 27
	lContinua := .F.
	Return
Endif

RETURN


//_____________________________________________________________________________________________________________________________________________________________
Static Function OkProc()

Close(oDlg5)
If mv_par07 <> 4
	RptStatus({||L_receb()}  , "Aguarde","Limpando registros do conta a receber provis�o/baixa")
Endif
If mv_par08 <> 4
	RptStatus({||L_pagar()}  , "Aguarde","Limpando registros do conta a pagar provis�o/baixa")
Endif
If mv_par09 <> 4
	RptStatus({||L_movim()}  , "Aguarde","Limpando registros movimenta��o banc�ria")
Endif
If mv_par10 <> 4
	RptStatus({||L_cheque()} , "Aguarde","Limpando registros de cheque")
Endif
If mv_par11 <> 4
	RptStatus({||L_docsai()} , "Aguarde","Limpando registro nota fiscal de saida")
Endif
If mv_par12 <> 4
	RptStatus({||L_docent()} , "Aguarde","Limpando registros nota fiscal entrada")
Endif
If mv_par13 <> 4
	RptStatus({||L_nfman()}  , "Aguarde","Limpando registros nota fiscal manual/fiscal")
Endif
If mv_par14==1
	RptStatus({||L_ativo()}  , "Aguarde","Limpando registros do ativo/deprecia��o")
Endif
If mv_par17==1
	RptStatus({||L_caixa()}  , "Aguarde","Limpando registros do ativo/deprecia��o")
Endif

Return

// Limpar flag contabil da rotina do contas a receber
Static Function L_receb()

If MV_PAR07==1 .OR. MV_PAR07==3
	cQry := ""
	cQry += "UPDATE "+RETSQLNAME("SE1") + " SET E1_LA = ' '"
	cQry += " WHERE E1_EMISSAO   >= '" + dtos(mv_par01) + "'"
	cQry += " AND   E1_EMISSAO   <= '" + dtos(mv_par02) + "'"
	cQry += " AND   E1_FILIAL    >= '" + mv_par03       + "' "
	cQry += " AND   E1_FILIAL    <= '" + mv_par04       + "' "
	cQry += " AND   E1_NUM       >= '" + MV_PAR05       + "'"
	cQry += " AND   E1_NUM       <= '" + MV_PAR06       + "'"
	cQry += " AND   D_E_L_E_T_<> '*'"
	TCSQLExec(cQry)
	
	cQry := ""
	cQry += "UPDATE "+RETSQLNAME("SEV")+" SET EV_LA = ' ' FROM "+RETSQLNAME("SE1")+" E1,"+RETSQLNAME("SEV")+" EV "
	cQry += " WHERE  E1_NUM   = EV_NUM
	cQry += " AND E1_PREFIXO  = EV_PREFIXO "
	cQry += " AND E1_PARCELA  = EV_PARCELA "
	cQry += " AND E1_FILIAL   = EV_FILIAL "
	cQry += " AND E1_CLIENTE  = EV_CLIFOR "
	cQry += " AND E1_TIPO     = EV_TIPO "
	cQry += " AND E1_LOJA     = EV_LOJA "
	cQry += " AND E1_EMISSAO >= '" + dtos(mv_par01)  + "' "
	cQry += " AND E1_EMISSAO <= '" + dtos(mv_par02)  + "' "
	cQry += " AND E1_FILIAL  >= '" + mv_par03       + "' "
	cQry += " AND E1_FILIAL  <= '" + mv_par04       + "' "
	cQry += " AND E1_NUM     >= '" + MV_PAR05 + "' "
	cQry += " AND E1_NUM     <= '" + MV_PAR06 + "' "
	cQry += " AND E1.D_E_L_E_T_ <> '*' "
	cQry += " AND EV.D_E_L_E_T_ <> '*'
	TCSQLExec(cQry)
	
	cQry := ""
	cQry += "UPDATE "+RETSQLNAME("SEZ") + " SET EZ_LA = ' ' FROM "+RETSQLNAME("SE1")+" E1,"+RETSQLNAME("SEZ")+" EZ "
	cQry += " WHERE  E1_NUM   = EZ_NUM "
	cQry += " AND E1_PREFIXO  = EZ_PREFIXO "
	cQry += " AND E1_PARCELA  = EZ_PARCELA "
	cQry += " AND E1_FILIAL   = EZ_FILIAL "
	cQry += " AND E1_CLIENTE  = EZ_CLIFOR "
	cQry += " AND E1_TIPO     = EZ_TIPO "
	cQry += " AND E1_LOJA     = EZ_LOJA "
	cQry += " AND E1_EMISSAO >= '" + dtos(mv_par01) + "' "
	cQry += " AND E1_EMISSAO <= '" + dtos(mv_par02) + "' "
	cQry += " AND E1_FILIAL  >= '" + mv_par03 + "' "
	cQry += " AND E1_FILIAL  <= '" + mv_par04 + "' "
	cQry += " AND E1_NUM     >= '" + MV_PAR05 + "' "
	cQry += " AND E1_NUM     <= '" + MV_PAR06 + "' "
	cQry += " AND E1.D_E_L_E_T_ <> '*' "
	cQry += " AND EZ.D_E_L_E_T_ <> '*' "
	TCSQLExec(cQry)
	
ENDIF
If MV_PAR07==2 .OR. MV_PAR07==3
	cQry := ""
	cQry += "UPDATE "+RETSQLNAME("SE5") + " SET E5_LA = ' ' "
	cQry += " WHERE E5_DATA  >= '" + DTOS(mv_par01) + "' "
	cQry += " AND E5_DATA    <= '" + DTOS(mv_par02) + "' "
	cQry += " AND E5_NUMCHEQ  = ''  "
	cQry += " AND E5_RECPAG   = 'R' "
	cQry += " AND D_E_L_E_T_ <> '*' "
	TCSQLExec(cQry)
ENDIF
RETURN


// Limpar flag contabil da rotina do contas a pagar
Static Function L_pagar()
If MV_PAR08==1 .OR. MV_PAR08==3
	cQry := ""
	cQry += "UPDATE "+RETSQLNAME("SE2") + " SET E2_LA = ' ' "
	cQry += " WHERE E2_EMISSAO >= '" + dtos(mv_par01) + "' "
	cQry += " AND E2_EMISSAO   <= '" + dtos(mv_par02) + "' "
	cQry += " AND E2_FILIAL    >= '" + mv_par03       + "' "
	cQry += " AND E2_FILIAL    <= '" + mv_par04       + "' "
	cQry += " AND E2_NUM       >= '" + MV_PAR05       + "' "
	cQry += " AND E2_NUM       <= '" + MV_PAR06       + "' "
	cQry += " AND D_E_L_E_T_<> '*' "
	TCSQLExec(cQry)
	
	cQry := ""
	cQry += "UPDATE "+RETSQLNAME("SEV") + " SET EV_LA = ' ' FROM "+RETSQLNAME("SE2")+" E2,"+RETSQLNAME("SEV")+" EV "
	cQry += " WHERE  E2_NUM   = EV_NUM "
	cQry += " AND E2_PREFIXO  = EV_PREFIXO "
	cQry += " AND E2_PARCELA  = EV_PARCELA "
	cQry += " AND E2_FILIAL   = EV_FILIAL "
	cQry += " AND E2_FORNECE  = EV_CLIFOR "
	cQry += " AND E2_TIPO     = EV_TIPO "
	cQry += " AND E2_LOJA     = EV_LOJA "
	cQry += " AND E2_EMISSAO >= '" + dtos(mv_par01) + "' "
	cQry += " AND E2_EMISSAO <= '" + dtos(mv_par02) + "' "
	cQry += " AND E2_FILIAL  >= '" + mv_par03       + "' "
	cQry += " AND E2_FILIAL  <= '" + mv_par04       + "' "
	cQry += " AND E2_NUM     >= '" + MV_PAR05       + "' "
	cQry += " AND E2_NUM     <= '" + MV_PAR06       + "' "
	cQry += " AND E2.D_E_L_E_T_ <> '*' "
	cQry += " AND EV.D_E_L_E_T_ <> '*' "
	TCSQLExec(cQry)
	
	cQry := ""
	cQry += "UPDATE "+RETSQLNAME("SEZ") + " SET EZ_LA = ' ' FROM "+RETSQLNAME("SE2")+" E2,"+RETSQLNAME("SEZ")+" EZ "
	cQry += " WHERE  E2_NUM   = EZ_NUM
	cQry += " AND E2_PREFIXO  = EZ_PREFIXO
	cQry += " AND E2_PARCELA  = EZ_PARCELA "
	cQry += " AND E2_FILIAL   = EZ_FILIAL
	cQry += " AND E2_FORNECE  = EZ_CLIFOR
	cQry += " AND E2_TIPO     = EZ_TIPO "
	cQry += " AND E2_LOJA     = EZ_LOJA
	cQry += " AND E2_EMISSAO >= '" + dtos(mv_par01) + "' "
	cQry += " AND E2_EMISSAO <= '" + dtos(mv_par02) + "' "
	cQry += " AND E2_FILIAL  >= '" + mv_par03       + "' "
	cQry += " AND E2_FILIAL  <= '" + mv_par04       + "' "
	cQry += " AND E2_NUM     >= '" + MV_PAR05       + "' "
	cQry += " AND E2_NUM     <= '" + MV_PAR06       + "' "
	cQry += " AND E2.D_E_L_E_T_ <> '*' "
	cQry += " AND EZ.D_E_L_E_T_ <> '*' "
	TCSQLExec(cQry)
	
ENDIF
If MV_PAR08==2 .OR. MV_PAR08==3
	cQry := ""
	cQry += "UPDATE "+RETSQLNAME("SE5") + " SET E5_LA = ' ' "
	cQry += " WHERE E5_DATA  >= '" + DTOS(mv_par01) + "' "
	cQry += " AND E5_DATA    <= '" + DTOS(mv_par02) + "' "
	cQry += " AND E5_NUMCHEQ  = ''  "
	cQry += " AND E5_RECPAG   = 'P' "
	cQry += " AND D_E_L_E_T_ <> '*' "
	TCSQLExec(cQry)
ENDIF
RETURN

// Limpar flag contabil da rotina do movimento bancario
Static Function L_movim()
// MOVIMENTO BANCARIO A RECEBER
If MV_PAR09==1 .OR. MV_PAR09==3
	cQry := ""
	cQry += "UPDATE "+RETSQLNAME("SE5") + " SET E5_LA = ' ' "
	cQry += " WHERE E5_DATA  >= '" + DTOS(mv_par01) + "' "
	cQry += " AND E5_DATA    <= '" + DTOS(mv_par02) + "' "
	cQry += " AND E5_NUMERO  >= '" + MV_PAR05 + "' "
	cQry += " AND E5_NUMERO  <= '" + MV_PAR06 + "' "
	cQry += " AND E5_MOEDA   <> ''  "
	cQry += " AND E5_RECPAG   = 'R' "
	cQry += " AND D_E_L_E_T_ <> '*' "
	TCSQLExec(cQry)
ENDIF
// MOVIMENTO BANCARIO A PAGAR
If MV_PAR09==2 .OR. MV_PAR09==3
	cQry := ""
	cQry += "UPDATE "+RETSQLNAME("SE5") + " SET E5_LA = ' '  "
	cQry += " WHERE E5_DATA  >= '" + DTOS(mv_par01) + "' "
	cQry += " AND E5_DATA    <= '" + DTOS(mv_par02) + "' "
	cQry += " AND E5_NUMERO  >= '" + MV_PAR05 + "' "
	cQry += " AND E5_NUMERO  <= '" + MV_PAR06 + "' "
	cQry += " AND E5_MOEDA   <> ''  "
	cQry += " AND E5_RECPAG   = 'P' "
	cQry += " AND D_E_L_E_T_ <> '*' "
	TCSQLExec(cQry)
ENDIF
RETURN

// Limpar flag contabil da rotina cheques
Static Function L_cheque()
// LIMPAR CHEQUE TITULOS MDIVERSOS
IF MV_PAR10==1 .OR. MV_PAR10==3
	cQry := ""
	cQry += "UPDATE "+RETSQLNAME("SEF") + " SET EF_LA = ' ' "
	cQry += " WHERE EF_DATA  >= '" + dtos(mv_par01) + "' "
	cQry += " AND EF_DATA    <= '" + dtos(mv_par02) + "' "
	cQry += " AND EF_NUM     <> '' "
	cQry += " AND D_E_L_E_T_ <> '*' "
	TCSQLExec(cQry)
	
ENDIF
// LIMPAR CHEQUE (SE5) REF TRANSF BANCARIA
IF MV_PAR10==2 .OR. MV_PAR10==3
	cQry := ""
	cQry += "UPDATE "+RETSQLNAME("SE5") + " SET E5_LA = ' '  "
	cQry += " WHERE E5_DATA   >= '" + DTOS(mv_par01) + "' "
	cQry += " AND E5_DATA     <= '" + DTOS(mv_par02) + "' "
	cQry += " AND (E5_NUMCHEQ <> '' OR E5_TIPODOC IN ('TR','TE','CH') )"
	cQry += " AND D_E_L_E_T_ <> '*' "
	TCSQLExec(cQry)
ENDIF

RETURN

// Limpar flag contabil da rotina documento de entrada
Static Function L_Docent()
// LIMPAR DOCUMENTO DE ENTRADA
IF MV_PAR12==1
	cQry := "UPDATE "+RETSQLNAME("SF1") + " SET F1_DTLANC = '' "
	cQry += " WHERE F1_DTDIGIT >= '" + dtos(mv_par01) + "' "
	cQry += " AND F1_DTDIGIT   <= '" + dtos(mv_par02) + "' "
	cQry += " AND F1_FILIAL    >= '" + mv_par03       + "' "
	cQry += " AND F1_FILIAL    <= '" + mv_par04       + "' "
	cQry += " AND F1_DOC       >= '" + mv_par05       + "' "
	cQry += " AND F1_DOC       <= '" + mv_par06       + "' "
	cQry += " AND D_E_L_E_T_   <> '*' "
	TCSQLExec(cQry)
ENDIF
RETURN

// Limpar flag contabil da rotina documento de saida
Static Function L_Docsai()
// LIMPAR DOCUMENTO DE SAIDA
IF MV_PAR11==1
	cQry := "UPDATE "+RETSQLNAME("SF2") + " SET F2_DTLANC = '' "
	cQry += " WHERE F2_EMISSAO >= '" + dtos(mv_par01) + "'"
	cQry += " AND F2_EMISSAO   <= '" + dtos(mv_par02) + "'"
	cQry += " AND F2_FILIAL    >= '" + mv_par03       + "' "
	cQry += " AND F2_FILIAL    <= '" + mv_par04       + "' "
	cQry += " AND F2_DOC       >= '" + mv_par05       + "' "
	cQry += " AND F2_DOC       <= '" + mv_par06       + "' "
	cQry += " AND D_E_L_E_T_   <> '*' "
	TCSQLExec(cQry)
ENDIF
Return

// Limpar flag contabil da rotina nota manual atrav�s do livros fiscal
Static Function L_Nfman()
// LIMPAR MANUAL DE ENTRADA
IF MV_PAR13==1 .OR. MV_PAR13==3
	cQry := "UPDATE "+RETSQLNAME("SF3") + " SET F3_DTLANC = '' "
	cQry += " WHERE F3_ENTRADA >= '" + dtos(mv_par01) + "' "
	cQry += " AND F3_ENTRADA   <= '" + dtos(mv_par02) + "' "
	cQry += " AND F3_FILIAL    >= '" + mv_par03       + "' "
	cQry += " AND F3_FILIAL    <= '" + mv_par04       + "' "
	cQry += " AND F3_NFISCAL   >= '" + mv_par05       + "' "
	cQry += " AND F3_NFISCAL   <= '" + mv_par06       + "' "
	cQry += " AND SUBSTRING(F3_CFO,1,1) IN ('1','2','3') "
	cQry += " AND D_E_L_E_T_   <> '*' "
	TCSQLExec(cQry)
ENDIF

// LIMPAR MANUAL DE SAIDAS
IF MV_PAR13==2 .OR. MV_PAR13==3
	cQry := "UPDATE "+RETSQLNAME("SF3") + " SET F3_DTLANC = '' "
	cQry += " WHERE F3_ENTRADA >= '" + dtos(mv_par01) + "' "
	cQry += " AND F3_ENTRADA   <= '" + dtos(mv_par02) + "' "
	cQry += " AND F3_FILIAL    >= '" + mv_par03       + "' "
	cQry += " AND F3_FILIAL    <= '" + mv_par04       + "' "
	cQry += " AND F3_NFISCAL   >= '" + mv_par05       + "' "
	cQry += " AND F3_NFISCAL   <= '" + mv_par06       + "' "
	cQry += " AND SUBSTRING(F3_CFO,1,1) IN ('5','6','7') "
	cQry += " AND D_E_L_E_T_   <> '*' "
	TCSQLExec(cQry)
ENDIF
Return

// Limpar flag contabil da rotina livros fiscais
Static Function L_fiscal()
Return

// Limpar flag contabil da rotina do ativo/deprecia��o
Static Function L_ativo()
// LIMPAR FLAG
IF MV_PAR14==1 
	cQry := "UPDATE "+RETSQLNAME("SN4") + " SET N4_DCONTAB = '' "
	cQry += " WHERE N4_DATA    >= '" + dtos(mv_par01) + "' "
	cQry += " AND N4_DATA      <= '" + dtos(mv_par02) + "' "
	cQry += " AND N4_FILIAL    >= '" + mv_par03       + "' "
	cQry += " AND N4_FILIAL    <= '" + mv_par04       + "' "
	cQry += " AND N4_CBASE     >= '" + mv_par15       + "' "
	cQry += " AND N4_CBASE     <= '" + mv_par16       + "' "
	cQry += " AND D_E_L_E_T_   <> '*' "
	TCSQLExec(cQry)
ENDIF
Return

// Limpar flag contabil da rotina do movimento bancario
Static Function L_CAIXA()
// MOVIMENTO BANCARIO A RECEBER
If MV_PAR17==1 .OR. MV_PAR17==3
	cQry := ""
	cQry += "UPDATE "+RETSQLNAME("SEU") + " SET EU_LA = ' ' "
	cQry += " WHERE EU_DTDIGIT >= '" + DTOS(mv_par01) + "' "
	cQry += " AND EU_DTDIGIT   <= '" + DTOS(mv_par02) + "' "
	cQry += " AND EU_FILIAL    >= '" + MV_PAR03 + "' "
	cQry += " AND EU_FILIAL    <= '" + MV_PAR04 + "' "
	cQry += " AND D_E_L_E_T_   <> '*' "
	TCSQLExec(cQry)
ENDIF
RETURN

//
Static Function CriaPerg
Local _sAlias := Alias()
Local aRegs   := {}
Local i
Local j
dbSelectArea("SX1")
dbSetOrder(1)
//cPerg := PADR(cPerg,6)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Data Inicial         ","","","mv_ch1","D",08,00,0,"G","","mv_par01","                  ","","","","","                  ","","","","","                  ","","","","","            ","","","","","     ","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data Final           ","","","mv_ch2","D",08,00,0,"G","","mv_par02","                  ","","","","","                  ","","","","","                  ","","","","","            ","","","","","     ","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","De Filial            ","","","mv_ch3","C",02,00,0,"G","","mv_par03","                  ","","","","","                  ","","","","","                  ","","","","","            ","","","","","     ","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Ate Filial           ","","","mv_ch4","C",02,00,0,"G","","mv_par04","                  ","","","","","                  ","","","","","                  ","","","","","            ","","","","","     ","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","De Documento         ","","","mv_ch5","C",09,00,0,"G","","mv_par05","                  ","","","","","                  ","","","","","                  ","","","","","            ","","","","","     ","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Ate Documento        ","","","mv_ch6","C",09,00,0,"G","","mv_par06","                  ","","","","","                  ","","","","","                  ","","","","","            ","","","","","     ","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Ref a Cts a Receber  ","","","mv_ch7","N", 1,00,0,"C","","mv_par07","Limpar Provisao   ","","","","","Limpar Baixas     ","","","","","Ambos             ","","","","","Nao Limpar  ","","","","","     ","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Ref a Cts a Pagar    ","","","mv_ch8","N", 1,00,0,"C","","mv_par08","Limpar Provisao   ","","","","","Limpar Baixas     ","","","","","Ambos             ","","","","","Nao Limpar  ","","","","","     ","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Ref a Mov.Bancaria   ","","","mv_ch9","N", 1,00,0,"C","","mv_par09","Limpar Recebimento","","","","","Limpar Pagamentos ","","","","","Ambos             ","","","","","Nao Limpar  ","","","","","     ","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","Ref a Cheques        ","","","mv_chA","N", 1,00,0,"C","","mv_par10","Limpar Chq Normal ","","","","","Limpar Chq s/TB   ","","","","","Ambos             ","","","","","Nao Limpar  ","","","","","     ","","","","","","","","",""})
aAdd(aRegs,{cPerg,"11","Ref a Nf Saida       ","","","mv_chB","N", 1,00,0,"C","","mv_par11","Limpar            ","","","","","Nao Limpar        ","","","","","                  ","","","","","            ","","","","","     ","","","","","","","","",""})
aAdd(aRegs,{cPerg,"12","Ref a Nf Entrada     ","","","mv_chC","N", 1,00,0,"C","","mv_par12","Limpar            ","","","","","Nao Limpar        ","","","","","                  ","","","","","            ","","","","","     ","","","","","","","","",""})
aAdd(aRegs,{cPerg,"13","Ref a Nf Manual (LF) ","","","mv_chD","N", 1,00,0,"C","","mv_par13","Entrada           ","","","","","Saidas            ","","","","","Ambos             ","","","","","Nao Limpar  ","","","","","     ","","","","","","","","",""}) 
aAdd(aRegs,{cPerg,"14","Ref a Ativo/Deprec   ","","","mv_chE","N", 1,00,0,"C","","mv_par14","Limpar            ","","","","","N�o Limpar        ","","","","","                  ","","","","","            ","","","","","     ","","","","","","","","",""})
aAdd(aRegs,{cPerg,"15","De Bem               ","","","mv_chF","C",10,00,0,"G","","mv_par15","                  ","","","","","                  ","","","","","                  ","","","","","            ","","","","","     ","","","","","","","","",""})
aAdd(aRegs,{cPerg,"16","Ate Bem              ","","","mv_chG","C",10,00,0,"G","","mv_par16","                  ","","","","","                  ","","","","","                  ","","","","","            ","","","","","     ","","","","","","","","",""})
aAdd(aRegs,{cPerg,"17","Ref a Caixinha       ","","","mv_chH","N", 1,00,0,"C","","mv_par17","Limpar            ","","","","","N�o Limpar        ","","","","","                  ","","","","","            ","","","","","     ","","","","","","","","",""})
For i := 1 to Len(aRegs)
	If ! dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j := 1 to Len(aRegs[i])//FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(_sAlias)
Return

/*/
// POR ARQUIVO RETORNO OU TODOS
If MV_PAR05==3 .OR. MV_PAR05==4
	cQry := ""
	cQry += "UPDATE "+RETSQLNAME("SE5") + " SET E5_LA = ' '  "
	cQry += " WHERE E5_DATA >= '" + DTOS(mv_par01) + "' "
	cQry += " AND E5_DATA   <= '" + DTOS(mv_par02) + "' "
	cQry += " AND E5_RECPAG  = 'R' "
	cQry += " AND E5_ARQCNAB = '" + ALLTRIM(MV_PAR06) + "' "
	cQry += " AND D_E_L_E_T_ <> '*' "
	TCSQLExec(cQry)
ENDIF
/*/
