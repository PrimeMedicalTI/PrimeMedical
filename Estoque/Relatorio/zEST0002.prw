//Bibliotecas
#Include "Totvs.ch"

/*/{Protheus.doc} User Function zEST0002
Despacho de Separação
@author Roseclei Ventura
@since 27/10/2022
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

User Function zEST0002()
	Local aArea := FWGetArea()
	Local oReport
	Local aPergs   := {}
	Local xPar0 := Space(6)
	
	//Adicionando os parametros do ParamBox
	aAdd(aPergs, {1, "Pedido", xPar0,  "", ".T.", "SC9", ".T.", 80,  .T.})
	
	//Se a pergunta for confirma, cria as definicoes do relatorio
	If ParamBox(aPergs, "Informe os parametros")
		oReport := fReportDef()
		oReport:PrintDialog()
	EndIf
	
	FWRestArea(aArea)
Return

/*/{Protheus.doc} fReportDef
Definicoes do relatorio zEST0002
@author Roseclei Ventura
@since 27/10/2022
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

Static Function fReportDef()
	Local oReport
	Local oSection := Nil
	Local oBreak := Nil
	
	//Criacao do componente de impressao
	oReport := TReport():New( "zEST0002",;
		"DESPACHO DE SEPARAÇÃO",;
		,;
		{|oReport| fRepPrint(oReport),};
		)
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9)
	
	//Orientacao do Relatorio
	oReport:SetLandscape()
	
	//Definicoes da fonte utilizada
	oReport:cFontBody := "Arial"
	oReport:SetLineHeight(40)
	oReport:nFontBody := 10
	
	//Criando a secao de dados
	oSection := TRSection():New( oReport,;
		"Dados",;
		{"QRY_REP"})
	oSection:SetTotalInLine(.F.)
	
	//Colunas do relatorio
	TRCell():New(oSection, "PEDIDO", "QRY_REP", "PEDIDO", /*cPicture*/, 20, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	//TRCell():New(oSection, "NOTA", "QRY_REP", "NOTA", /*cPicture*/, 26, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	//TRCell():New(oSection, "CODCLI", "QRY_REP", "CODCLI", /*cPicture*/, 22, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "CLIENTE", "QRY_REP", "CLIENTE", /*cPicture*/, 66, /*lPixel*/, /*{|| code-block de impressao }*/, "RIGHT", /*lLineBreak*/, "RIGHT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "ITEM", "QRY_REP", "ITEM", /*cPicture*/, 10, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "COD", "QRY_REP", "COD", /*cPicture*/, 68, /*lPixel*/, /*{|| code-block de impressao }*/, "RIGHT", /*lLineBreak*/, "RIGHT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "PRODUTO", "QRY_REP", "PRODUTO", /*cPicture*/, 50, /*lPixel*/, /*{|| code-block de impressao }*/, "RIGHT", /*lLineBreak*/, "RIGHT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "QTD", "QRY_REP", "QTD", /*cPicture*/, 7, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	//TRCell():New(oSection, "ARMAZEM", "QRY_REP", "ARMAZEM", /*cPicture*/, 7, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "LOTE", "QRY_REP", "LOTE", /*cPicture*/, 36, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "DTVALID", "QRY_REP", "DTVALID", /*cPicture*/, 30, /*lPixel*/, /*{|| code-block de impressao }*/, "RIGHT", /*lLineBreak*/, "RIGHT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	
	//Quebras do relatorio
	oBreak := TRBreak():New(oSection, oSection:Cell("PEDIDO"), {||"Total da Quebra"}, .F.)
	
Return oReport

/*/{Protheus.doc} fRepPrint
Impressao do relatorio zEST0002
@author Roseclei Ventura
@since 27/10/2022
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

Static Function fRepPrint(oReport)
	Local aArea    := FWGetArea()
	Local cQryReport  := ""
	Local oSectDad := Nil
	Local nAtual   := 0
	Local nTotal   := 0
	
	//Pegando as secoes do relatorio
	oSectDad := oReport:Section(1)
	
	//Montando consulta de dados
	cQryReport += "select "	+ CRLF
	cQryReport += " C9_PEDIDO as Pedido, " + CRLF
	/*/cQryReport += " C9_NFISCAL as Nota, " + CRLF
	cQryReport += " C9_CLIENTE as CodCLi, "	  + CRLF
	cQryReport += " A1_NOME as Cliente, " + CRLF /*/
	cQryReport += " Rtrim(C9_CLIENTE) + ' - ' + A1_NREDUZ as Cliente, " + CRLF 
	cQryReport += " C9_ITEM as Item, " + CRLF
	cQryReport += " C9_PRODUTO as Cod, " + CRLF
	cQryReport += " B1_DESC as Produto, " + CRLF
	cQryReport += " C9_QTDLIB as Qtd, " + CRLF
	/*/cQryReport += " C9_LOCAL as Armazem, " + CRLF /*/
	cQryReport += " C9_LOTECTL as Lote, " + CRLF
	cQryReport += " case when C9_DTVALID < GETDATE( ) then 'VENCIDO' else CONVERT(Varchar(10),CONVERT(DATE,C9_DTVALID,112),103) end as DTVALID "+ CRLF
	cQryReport += " from SC9010 Pedido (Nolock) "		+ CRLF
	cQryReport += " inner join SB1010 Produto (Nolock) ON Produto.D_E_L_E_T_ <> '*' " + CRLF
	cQryReport += " AND B1_COD = C9_PRODUTO " + CRLF
	cQryReport += " inner join SA1010 Cliente (Nolock) ON Cliente.D_E_L_E_T_ <> '*' " + CRLF
	cQryReport += " AND A1_COD = C9_CLIENTE " + CRLF
	cQryReport += " AND A1_LOJA = C9_LOJA "	+ CRLF
	cQryReport += " Where 1=1 "	+ CRLF
	cQryReport += " AND Pedido.C9_FILIAL = '010101' " + CRLF
	cQryReport += " AND Pedido.D_E_L_E_T_ <> '*' "	+ CRLF
	cQryReport += " AND C9_PEDIDO = '" + MV_PAR01 + "' " + CRLF
	cQryReport += " order by Pedido, Item"	+ CRLF
	
	//Executando consulta e setando o total da regua
	PlsQuery(cQryReport, "QRY_REP")
	DbSelectArea("QRY_REP")
	Count to nTotal
	oReport:SetMeter(nTotal)
	
	//Enquanto houver dados
	oSectDad:Init()
	QRY_REP->(DbGoTop())
	While ! QRY_REP->(Eof())
	
		//Incrementando a regua
		nAtual++
		oReport:SetMsgPrint("Imprimindo registro " + cValToChar(nAtual) + " de " + cValToChar(nTotal) + "...")
		oReport:IncMeter()
		
		//Imprimindo a linha atual
		oSectDad:PrintLine()
		
		QRY_REP->(DbSkip())
	EndDo
	oSectDad:Finish()
	QRY_REP->(DbCloseArea())
	
	FWRestArea(aArea)
Return
