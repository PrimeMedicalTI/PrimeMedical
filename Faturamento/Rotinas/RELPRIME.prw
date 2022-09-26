#Include 'Protheus.CH'
#Include 'RWMake.CH'
#Include 'TopConn.CH'
#Include 'RptDef.CH'
#Include 'FWPrintSetup.CH'
/*
------------------------------------------------------------------------------------------------------------
Função		: RELPRIME.PRW
Tipo		: Relatório
Descrição	: Relatório
Chamado     : 
Parâmetros	: 
Retorno		:
------------------------------------------------------------------------------------------------------------
Atualizações:
- 30/03/2021 - Fabio A. Moraes - Construção inicial do Fonte
------------------------------------------------------------------------------------------------------------
*/
User Function Relprime()
Local cPerg       := "RELPRIME"   
Private cCliente  := ""
Private cObs      := ""
Private aClientes := {}
Private aProdutos := {}
    
    oLogo      := TFont():New('Andale Mono',,10,,.F.)
	oCabecalho := TFont():New('Andale Mono',,14,,.T.)
	oTitle     := TFont():New('Andale Mono',,10,,.T.)		 
	oCorpoN    := TFont():New('Andale Mono',,09,,.T.)			
	oTexto     := TFont():New('Andale Mono',,08,,.F.)
	oCorpo     := TFont():New('Andale Mono',,09,,.F.)
	
	oPrint := FWMsPrinter():New("Envio de material para procedimento",,,,,,,,,,.F.,,)
	oPrint:SetPortrait()
	oPrint:SetPapersize(9,210,297)
	
	If !Pergunte(cPerg,.T.)
		Return
	Else
        cPedido  := MV_PAR01
        cCliente := MV_PAR02
        cObs     := MV_PAR03
        If Empty(cCliente) .OR. Empty(cPedido)
            MessageBox("Informe os dados para emissão do relatório","Prime Medical",48)
        Else 
            Imprime()
        EndIf
    EndIf

Return

Static Function Imprime()

Local nCont     := 0
Local nRow      := 0100
Local nRow2	    := 0100
Local nItens    := 0
Local nTotal    := 0
Local oBrush1   := TBrush():New(,CLR_GRAY)
Local oFont1    := TFont():New('Arial',,12,,.T.)
Local oFont2    := TFont():New('Arial',,08,,.T.)
Local oFont3    := TFont():New('Arial',,20,,.T.,,,,,,.T.)
Local oFont4    := TFont():New('Arial',,14,,.T.)

    
    BuscaDados()
    //oFont1:Underline  := .T.

    oPrint:StartPage()

    //Cabeçalho
    //oPrint:Box(nRow2,0050,0400,1000,"-4")
    //oPrint:Box(nRow2,1000,0400,2000,"-4")
	//oPrint:FillRect({nRow2,1000,0400,2000},oBrush1,"-4") 
    oPrint:SayBitmap(nRow,0155,"C:\totvs\Protheus\protheus_data\system\Prime.jpg",0500,0250)
    oPrint:SayAlign(nRow,1000,"Salvador "+AllTrim(Str(Day(Date())))+" de "+MesExtenso(Month(Date()))+" de "+AllTrim(Str(Year(Date()))),oFont1,1150,0050,CLR_BLACK,1,0)
    oPrint:SayAlign(nRow+0100,0700,"ENVIO DE MATERIAL PARA PROCEDIMENTO",oFont3,1450,0050,CLR_BLUE,2,0)
    oPrint:SayAlign(nRow+0260,0155,"PEDIDO Nº: "+cPedido,oFont4,1000,0050,CLR_BLACK,0,0)
    oPrint:SayAlign(nRow+0300,0155,"DADOS DO CLIENTE:",oFont4,1000,0050,CLR_BLACK,0,0)
    oPrint:SayAlign(nRow+0340,0155,"CLIENTE: "+aClientes[1]+" - "+aClientes[2] ,oFont4,1000,0050,CLR_BLACK,0,0)
    oPrint:SayAlign(nRow+0380,0155,"ENDEREÇO: "+aClientes[3],oFont4,1000,0050,CLR_BLACK,0,0)
    oPrint:SayAlign(nRow+0420,0155,"COMPLEMENTO: ",oFont4,1000,0050,CLR_BLACK,0,0)
    oPrint:SayAlign(nRow+0420,1000,"NÚMERO:",oFont4,1000,0050,CLR_BLACK,0,0)
    oPrint:SayAlign(nRow+0460,0155,"BAIRRO: "+aClientes[4],oFont4,0550,0050,CLR_BLACK,0,0)
    oPrint:SayAlign(nRow+0460,0700,"CEP: "+aClientes[5],oFont4,0500,0050,CLR_BLACK,0,0)
    oPrint:SayAlign(nRow+0460,1200,"CIDADE: "+aClientes[6],oFont4,0500,0050,CLR_BLACK,0,0)
    oPrint:SayAlign(nRow+0460,1700,"ESTADO: "+aClientes[7],oFont4,0500,0050,CLR_BLACK,0,0)
    oPrint:SayAlign(nRow+0500,0155,"TELEFONES :"+aClientes[8],oFont4,1000,0050,CLR_BLACK,0,0)
    oPrint:SayAlign(nRow+0500,1000,"FAX: "+aClientes[9],oFont4,1000,0050,CLR_BLACK,0,0)
    oPrint:SayAlign(nRow+0600,0155,"Conforme solicitação, estamos enviando os seguintes produtos:",oFont4,1000,0050,CLR_BLACK,0,0)
    nRow2 := nRow+0650
    oPrint:FillRect({nRow2,0155,nRow2+0050,2150},oBrush1,"-4")
    oPrint:SayAlign(nRow+0650,0155,"REFERÊNCIA",oFont1,0300,0050,CLR_BLACK,2,0)
    oPrint:SayAlign(nRow+0650,0450,"DESCRIÇÃO",oFont1,0500,0050,CLR_BLACK,2,0) 
    oPrint:SayAlign(nRow+0650,0950,"ANVISA",oFont1,0300,0050,CLR_BLACK,2,0) 
    oPrint:SayAlign(nRow+0650,1250,"LOTE",oFont1,0300,0050,CLR_BLACK,2,0)
    oPrint:SayAlign(nRow+0650,1550,"VALIDADE",oFont1,0300,0050,CLR_BLACK,2,0) 
    oPrint:SayAlign(nRow+0650,1850,"UND",oFont1,0100,0050,CLR_BLACK,2,0)
    oPrint:SayAlign(nRow+0650,1950,"QTDE",oFont1,0200,0050,CLR_BLACK,2,0)  
    //For dos produtos
    nRow := nRow+0650
    For nCont := 1 to Len(aProdutos)
        nRow += 0050
        oPrint:SayAlign(nRow,0155,aProdutos[nCont][1],oFont1,0300,0050,CLR_BLACK,2,0)
        oPrint:SayAlign(nRow,0450,aProdutos[nCont][2],oFont1,0500,0050,CLR_BLACK,0,0) 
        oPrint:SayAlign(nRow,0950,aProdutos[nCont][6],oFont1,0300,0050,CLR_BLACK,2,0) 
        oPrint:SayAlign(nRow,1250,aProdutos[nCont][7],oFont1,0300,0050,CLR_BLACK,2,0)
        oPrint:SayAlign(nRow,1550,aProdutos[nCont][8],oFont1,0300,0050,CLR_BLACK,2,0) 
        oPrint:SayAlign(nRow,1850,aProdutos[nCont][3],oFont1,0100,0050,CLR_BLACK,2,0)
        oPrint:SayAlign(nRow,1950,Transform(aProdutos[nCont][5],"@E 999,999,999.99"),oFont1,0200,0050,CLR_BLACK,2,0)
        nItens := nItens + 1
        nTotal := nTotal + aProdutos[nCont][5]  
    Next
    nRow += 0100
    oPrint:SayAlign(nRow,0155,"Observação: "+cObs,oFont1,2000,0050,CLR_BLACK,0,0)
    oPrint:Line(nRow+0080,0550,nRow+0080,2150)
    oPrint:SayAlign(nRow+0100,0570,"Itens "+Transform(nItens,"@E 999,999,999.99"),oFont1,0200,0050,CLR_BLACK,2,0)
    oPrint:SayAlign(nRow+0100,1600,"Total Geral "+Transform(nTotal,"@E 999,999,999.99"),oFont1,0500,0050,CLR_BLACK,2,0)  
    oPrint:SayAlign(nRow+0250,0155,"Recebido em ___/___/___",oFont1,0400,0050,CLR_BLACK,2,0)
    oPrint:Line(nRow+0320,0155,nRow+0320,0555)
    oPrint:SayAlign(nRow+0250,1300,"Responsável p/ entrega ___/___/___",oFont1,0600,0050,CLR_BLACK,2,0)
    oPrint:Line(nRow+0320,1300,nRow+0320,1900)
    oPrint:Line(nRow+0520,0155,nRow+0500,2150)
    oPrint:SayAlign(nRow+0550,0155,"Rua Itagi nº 413 Galpão nº 10, Quadra 09, lote 15 a 17, Jardim Belo Horizonte - Pitangueiras - Lauro de Freitas - BA, CEP 42.700-000",oFont1,2000,0050,CLR_BLACK,2,0)
    oPrint:SayAlign(nRow+0580,0155,"Fone:(71) 3045-9777 E-Mail: vendas@primemedical.com.br Site: www.primemedical.com.br",oFont1,2000,0050,CLR_BLACK,2,0)
    oPrint:EndPage()
	oPrint:Print()

Return

Static Function BuscaDados()
Local cSql := ""

    cSql := "SELECT        "
    cSql += "   A1_COD,    "
    cSql += "   A1_NOME,   "
    cSql += "   A1_END,    "
    cSql += "   A1_BAIRRO, "
    cSql += "   A1_CEP,    "
    cSql += "   A1_MUN,    "
    cSql += "   A1_EST,    "
    cSql += "   A1_TEL,    "
    cSql += "   A1_FAX     "
    cSql += "FROM          "
    cSql += "  "+RetSqlName('SA1')+" SA1 "
    cSql += "WHERE         "
    cSql += "  A1_FILIAL = '"+FWxFilial('SA1')+"' AND "
    cSql += "  A1_COD = '"+cCliente+"' AND D_E_L_E_T_ = ' ' "
    TcQuery cSql New Alias 'TRB'
    TRB->(DbSelectArea('TRB'))
    
    aAdd(aClientes,TRB->A1_COD)
    aAdd(aClientes,TRB->A1_NOME)
    aAdd(aClientes,TRB->A1_END)
    aAdd(aClientes,TRB->A1_BAIRRO)
    aAdd(aClientes,TRB->A1_CEP)
    aAdd(aClientes,TRB->A1_MUN)
    aAdd(aClientes,TRB->A1_EST)
    aAdd(aClientes,TRB->A1_TEL)
    aAdd(aClientes,TRB->A1_FAX)

    TRB->(DbCloseArea())
    
    //Busca os produtos da D3
    cSql := "Select " 
	cSql += "  SB1.B1_COD,    "
	cSql += "  SB1.B1_DESC,   "
	cSql += "  SB1.B1_UM,     "
	cSql += "  SD3.D3_DOC,    "
	cSql += "  SD3.D3_QUANT,  "
    cSql += "  'Anvisa' ANV,  "
    cSql += "  'Lote'  LOTE,  "
    cSql += "  'Validade' VAL "        
    cSql += "From             "
	cSql += "  "+RetSqlName('SD3')+" SD3 "
    cSql += "Inner Join      "
	cSql += "   "+RetsqlName('SB1')+" SB1 on "
	cSql += "   SB1.B1_COD = SD3.D3_COD and  "
	cSql += "   SB1.D_E_L_E_T_ = ' '         "
    cSql += "where                           "
	cSql += "   SD3.D3_DOC = '"+cPedido+"' and   "
    cSql += "   SD3.D3_CF = 'DE4' and        "
    cSql += "   SD3.D_E_L_E_T_ = ' '         "
    TcQuery cSql New Alias 'TRB'
    TRB->(DbSelectArea('TRB'))
    Do While TRB->(!Eof())
        aAdd(aProdutos,{TRB->B1_COD  ,;
                        TRB->B1_DESC ,;
                        TRB->B1_UM   ,;
                        TRB->D3_DOC  ,;
                        TRB->D3_QUANT,;
                        TRB->ANV     ,;
                        TRB->LOTE    ,;
                        TRB->VAL})
        TRB->(DbSkip())
    EndDo
    TRB->(DbCloseArea())
Return
