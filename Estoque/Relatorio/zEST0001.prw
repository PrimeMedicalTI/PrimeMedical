//Bibliotecas
#Include "Totvs.ch"

/*/{Protheus.doc} User Function zEST0001
Relatório Estoque Prime
@author Andre Barreto de Brito
@since 04/04/2022
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

User Function zEST0001()
	Local aArea := FWGetArea()
	Local oReport
	Local aPergs   := {}
	Local xPar0 := Space(2)
	Local xPar1 := Space(2)
	
	//Adicionando os parametros do ParamBox
	aAdd(aPergs, {1, "Armazem de", xPar0,  "", ".T.", "NNR", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Armazem ate", xPar1,  "", ".T.", "NNR", ".T.", 80,  .F.})
	
	//Se a pergunta for confirma, cria as definicoes do relatorio
	If ParamBox(aPergs, "Informe os parametros")
		oReport := fReportDef()
		oReport:PrintDialog()
	EndIf
	
	FWRestArea(aArea)
Return

/*/{Protheus.doc} fReportDef
Definicoes do relatorio zEST0001
@author Andre Barreto de Brito
@since 04/04/2022
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

Static Function fReportDef()
	Local oReport
	Local oSection := Nil
	
	//Criacao do componente de impressao
	oReport := TReport():New( "zEST0001",;
		"Estoque Prime",;
		,;
		{|oReport| fRepPrint(oReport),};
		)
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9)
	
	//Orientacao do Relatorio
	oReport:SetLandscape()
	
	//Definicoes da fonte utilizada
	oReport:cFontBody := "Times New Roman"
	oReport:SetLineHeight(60)
	oReport:nFontBody := 16
	
	//Criando a secao de dados
	oSection := TRSection():New( oReport,;
		"Dados",;
		{"QRY_REP"})
	oSection:SetTotalInLine(.F.)
	
	//Colunas do relatorio
	TRCell():New(oSection, "ARMAZEM", "QRY_REP", "Armazem", /*cPicture*/, 20, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "PRODUTO_ID", "QRY_REP", "ID", /*cPicture*/, 15, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "PRODUTO", "QRY_REP", "Produto", /*cPicture*/, 60, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "LOTE", "QRY_REP", "Lote", /*cPicture*/, 15, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "VALIDADE", "QRY_REP", "Validade", /*cPicture*/, 10, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "STATUS", "QRY_REP", "Status", /*cPicture*/, 8, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "Saldo", "QRY_REP", "Saldo", /*cPicture*/, 6, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	
Return oReport

/*/{Protheus.doc} fRepPrint
Impressao do relatorio zEST0001
@author Andre Barreto de Brito
@since 04/04/2022
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
	cQryReport += "Select "		+ CRLF
	cQryReport += " NNR_DESCRI as ARMAZEM, B8_PRODUTO as Produto_ID, B1_DESC as Produto, B8_LOTECTL as Lote, B8_SALDO as Saldo, "		+ CRLF
	cQryReport += " Convert(Varchar(10),Convert(Datetime,B8_DTVALID,112),103) as VALIDADE, "		+ CRLF
	cQryReport += " Case when Convert(Datetime,B8_DTVALID,112) < GetDate() then 'VENCIDO' else 'OK' end Status "		+ CRLF
	cQryReport += "from SB8010 SaldoPorLote (nolock) "		+ CRLF
	cQryReport += "Inner Join SB1010 Produto (nolock) ON B1_FILIAL = '" + FWXFILIAL('SB1') + "' "		+ CRLF
	cQryReport += " AND Produto.D_E_L_E_T_ <> '*' "		+ CRLF
	cQryReport += " AND B1_COD = B8_PRODUTO "		+ CRLF
	cQryReport += " AND B1_RASTRO = 'L' "		+ CRLF
	cQryReport += "Inner JOIN NNR010 Armazem ON NNR_FILIAL = '" + FWXFILIAL('NNR') + "' "		+ CRLF
	cQryReport += " AND Armazem.D_E_L_E_T_ <> '*' "		+ CRLF
	cQryReport += " AND NNR_CODIGO = B8_LOCAL "		+ CRLF
	cQryReport += " AND NNR_CODIGO >= '" + MV_PAR01 + "' "		+ CRLF
	cQryReport += " AND NNR_CODIGO <= '" + MV_PAR02 + "' "		+ CRLF
	cQryReport += "Where 1=1 "		+ CRLF
	cQryReport += "AND B8_FILIAL = '" + FWXFILIAL('SB8') + "' "		+ CRLF
	cQryReport += "AND SaldoPorLote.D_E_L_E_T_ <> '*' "		+ CRLF
	cQryReport += "AND B8_SALDO <> 0 "		+ CRLF
	
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
