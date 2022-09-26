//Bibliotecas
#Include "Totvs.ch"

/*/{Protheus.doc} User Function PFATR001
Relatorio Pedido x Saldo
@author Andre Brito
@since 06/05/2022
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

User Function PFATR001()
	Local aArea := FWGetArea()
	Local oReport
	Local aPergs   := {}
	Local xPar0 := Space(10)
	
	//Adicionando os parametros do ParamBox
	aAdd(aPergs, {1, "Pedido", xPar0,  "", ".T.", "", ".T.", 80,  .T.})
	
	//Se a pergunta for confirma, cria as definicoes do relatorio
	If ParamBox(aPergs, "Informe os parametros")
		oReport := fReportDef()
		oReport:PrintDialog()
	EndIf
	
	FWRestArea(aArea)
Return

/*/{Protheus.doc} fReportDef
Definicoes do relatorio PFATR001
@author Andre Brito
@since 06/05/2022
@version 1.0
@type function
/*/

Static Function fReportDef()
	Local oReport
	Local oSection := Nil
	Local oBreak := Nil
	
	//Criacao do componente de impressao
	oReport := TReport():New( "PFATR001",;
		"Pedido x Saldo",;
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
	oReport:SetLineHeight(50)
	oReport:nFontBody := 11
	
	//Criando a secao de dados
	oSection := TRSection():New( oReport,;
		"Dados",;
		{"QRY_REP"})
	oSection:SetTotalInLine(.F.)
	
	//Colunas do relatorio
	TRCell():New(oSection, "Pedido", "QRY_REP", "Pedido", /*cPicture*/, 10, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "ID", "QRY_REP", "ID", /*cPicture*/, 20, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "Produto", "QRY_REP", "Produto", /*cPicture*/, 50, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "Lote", "QRY_REP", "Lote", /*cPicture*/, 20, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "Validade", "QRY_REP", "Validade", /*cPicture*/, 10, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "Armazem", "QRY_REP", "Armazem", /*cPicture*/, 10, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "QtdPedido", "QRY_REP", "QtdPedido", /*cPicture*/, 10, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "Estoque", "QRY_REP", "Estoque", /*cPicture*/, 10, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "Status ", "QRY_REP", "Status ", /*cPicture*/, 10, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	
	//Quebras do relatorio
	oBreak := TRBreak():New(oSection, oSection:Cell("Pedido"), {||"Total da Quebra"}, .F.)
	
Return oReport

/*/{Protheus.doc} fRepPrint
Impressao do relatorio PFATR001
@author Andre Brito
@since 06/05/2022
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
	cQryReport += "SELECT "		+ CRLF
	cQryReport += " C6_NUM as Pedido, C6_PRODUTO as ID, C6_DESCRI as Produto, C6_LOTECTL as Lote, C6_DTVALID as VALIDADE, C6_LOCAL as Armazem, C6_QTDVEN as QtdPedido, B8_SALDO as Estoque, "		+ CRLF
	cQryReport += " Case when C6_QTDVEN > B8_SALDO then 'FALTA' else '' end as Status "		+ CRLF
	cQryReport += "FROM SC6010 Pedido "		+ CRLF
	cQryReport += "INNER JOIN SB8010 B8 ON B8.D_E_L_E_T_ <> '*' "		+ CRLF
	cQryReport += " AND B8_FILIAL ='"+xFilial("SB8")+"' " + CRLF
	cQryReport += " AND B8_PRODUTO = C6_PRODUTO "		+ CRLF
	cQryReport += " AND B8_LOCAL = C6_LOCAL "		+ CRLF
	cQryReport += " AND B8_LOTECTL = C6_LOTECTL "		+ CRLF
	cQryReport += " AND B8_DTVALID = C6_DTVALID "		+ CRLF
	cQryReport += " "		+ CRLF
	cQryReport += "WHERE 1=1 "		+ CRLF
	cQryReport += "AND Pedido.D_E_L_E_T_ <> '*' "		+ CRLF
	cQryReport += "AND C6_FILIAL ='"+xFilial("SC6")+"' " + CRLF
	cQryReport += "AND C6_NUM = '" + MV_PAR01 + "' "		+ CRLF
	cQryReport += " "		+ CRLF
	cQryReport += "UNION ALL "		+ CRLF
	cQryReport += " "		+ CRLF
	cQryReport += "SELECT "		+ CRLF
	cQryReport += " C6_NUM as Pedido, C6_PRODUTO as ID, C6_DESCRI as Produto, C6_LOTECTL as Lote, C6_DTVALID as Validade, C6_LOCAL as Armazem, C6_QTDVEN as QtdPedido, B2_QATU as Estoque, "		+ CRLF
	cQryReport += " Case when C6_QTDVEN > B2_QATU then 'FALTA' else '' end as Status "		+ CRLF
	cQryReport += " "		+ CRLF
	cQryReport += "FROM SC6010 Pedido "		+ CRLF
	cQryReport += "INNER JOIN SB2010 B2 ON B2.D_E_L_E_T_ <> '*' "		+ CRLF
	cQryReport += " AND B2_FILIAL ='"+xFilial("SB2")+"' " + CRLF
	cQryReport += " AND B2_COD = C6_PRODUTO "		+ CRLF
	cQryReport += " AND B2_LOCAL = C6_LOCAL "		+ CRLF
	cQryReport += " "		+ CRLF
	cQryReport += "WHERE 1=1 "		+ CRLF
	cQryReport += "AND Pedido.D_E_L_E_T_ <> '*' "		+ CRLF
	cQryReport += "AND C6_FILIAL ='"+xFilial("SC6")+"' " + CRLF
	cQryReport += "AND C6_NUM = '" + MV_PAR01 + "'"		+ CRLF
	
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
