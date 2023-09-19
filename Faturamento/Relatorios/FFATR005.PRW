#include "COLORS.CH"
#include "FONT.CH"
#include "REPORT.CH"
#Include "TOTVS.ch"
#Include "TBICONN.CH"
#include "RPTDEF.CH"
#include "FWPrintSetup.ch"
#include 'TOPCONN.CH'
#INCLUDE "rwmake.ch"
#Include 'protheus.ch'
#Include 'parmtype.ch'

#Define ENTER  Chr(10) + Chr (13)

/*/{Protheus.doc} FFATR005
Programa responsavel pela Impressï¿½o de Orcamento de venda
@author Elisângela Souza
@since Novembro/2021
@version 12.1.25

/*/
User Function FFATR005()

	Local n_TotGer 		:= 0
	Local n_TotVal 		:= 0
	Local nItem	    	:= 0
	Local _nValIpi		:= 0
	Local n_VlrMer		:= 0
	Local n_Frete 		:= 0
	Local n_Despes		:= 0
	Local n_Segur		:= 0
	Local n_FAut		:= 0
	Local I
	Local n_Pag			:= 1
	Local l_Prop		:= .F.
	Local d_Entreg		:= ""

	Private	cImag001	:= "Marca.bmp" // "DANFE01.bmp"	

	Private oArial7  	:=	TFont():New("Arial",,9,,.F.,,,,,.F.,.F.) // 7
	Private oArial8		:=	TFont():New("Arial",,10,,.F.,,,,,.F.,.F.)// 8
	Private oArial8N	:=	TFont():New("Arial",,10,,.T.,,,,,.F.,.F.) // 8
  	Private oArial10	:=	TFont():New("Arial",,12,,.F.,,,,,.F.,.F.)// 10 
	Private oArial11N	:=	TFont():New("Arial",,13,,.T.,,,,,.F.,.F.) //11
	Private oArial11	:=	TFont():New("Arial",,13,,.F.,,,,,.F.,.F.) //11
	Private n_Lin
	
	oPrn := FWMSPrinter():New("FFATR005_"+DtoS(date())+"_"+SubStr(Time(),1,2)+SubStr(Time(),4,2)+SubStr(Time(),7,2)  )
	oPrn:SetPortrait() // ou SetLandscape()

	If !Empty(SCJ->CJ_PROSPE)
		DbSelectArea("SUS")
		SUS->( DbSetOrder(1))
		SUS->( DbSeek(xFilial("SUS")+SCJ->CJ_PROSPE+SCJ->CJ_LOJPRO))
		l_Prop	:= .T.
	Else	
		DbSelectArea("SA1")
		SA1->( DbSetOrder(1))
		SA1->( DbSeek(xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA))
	Endif

	DbSelectArea("SE4")
	SE4->( DbSetOrder(1))
	SE4->( DbSeek(xFilial("SE4")+SCJ->CJ_CONDPAG))

	DbSelectArea("SX5")
	SX5->( DbSetOrder(1))
	SX5->( DbSeek(xFilial("SX5")+"24"+SE4->E4_FORMA))

	DbSelectArea("SCK")
	SCK->( DbSetOrder(1))
	SCK->( DbSeek(xFilial("SCK")+SCJ->CJ_NUM))

	Cabec1() 
	Cab_Cliente(l_Prop)
	Cab_Grade()

	// Verifica a data de entrega
	c_Ent := " SELECT MAX(CK_ENTREG) AS CK_ENTREG "
	c_Ent += " FROM " + RetSqlName("SCK") 
	c_Ent += " WHERE CK_NUM  = '" + SCJ->CJ_NUM + "'"
	c_Ent += " AND CK_FILIAL = '" + SCJ->CJ_FILIAL + "'"
	c_Ent += " AND D_E_L_E_T_ <> '*' "
	
	TcQuery c_Ent New Alias "QET"
			
	If QET->( !Eof() )	
		d_Entreg	:= Stod(QET->CK_ENTREG)
	Endif

	QET->( DbCloseArea())

	// Verifica os registros
	While SCK->( !Eof()) .And. SCK->CK_FILIAL = xFilial("SCK") .And. SCK->CK_NUM = SCJ->CJ_NUM
	
		c_Num := " SELECT COUNT(*) AS NITEM "
		c_Num += " FROM " + RetSqlName("SCK")
		c_Num += " WHERE CK_NUM  = '" + SCJ->CJ_NUM + "'"
		c_Num += " AND CK_FILIAL = '" + SCJ->CJ_FILIAL + "'"
		c_Num += " AND D_E_L_E_T_ <> '*' "
		
		TcQuery c_Num New Alias "QNI"
			
		If QNI->( !Eof() )	
			n_Frete 	:= SCJ->CJ_FRETE / QNI->NITEM
			n_Despes	:= SCJ->CJ_DESPESA / QNI->NITEM
			n_Segur		:= SCJ->CJ_SEGURO / QNI->NITEM
			n_FAut		:= SCJ->CJ_FRETAUT / QNI->NITEM
		Endif
		
		QNI->( DbCloseArea())
		
		DbSelectArea("SB1")
		SB1->( DbSetOrder(1))
		SB1->( DbSeek(xFilial("SB1")+SCK->CK_PRODUTO))

		c_Desc := Alltrim(SB1->B1_DESC)

		DbSelectArea("SCK")

		If	n_Lin >= 2700 
			n_Lin += 30
			oPrn:Say(n_Lin,2000,"Página: " + Alltrim(Str(n_Pag)) ,oArial8,,0) 
			n_Pag := n_Pag + 1
			Cabec1()
			Cab_Cliente(l_Prop)
			Cab_Grade()
		Endif

		nItem ++
		
		If SCK->CK_VALDESC > 0
			n_VlrMer := SCK->CK_VALOR + SCK->CK_VALDESC // Inseri o somatório porque não estava sendo considerado o desconto para cálculo do IPI
		Else
			n_VlrMer := SCK->CK_VALOR 
		Endif
			
		If l_Prop // Prospect
			MaFisIni(SCJ->CJ_PROSPE,SCJ->CJ_LOJPRO, "C","N", SUS->US_TIPO, MaFisRelImp("FFATR001",{"SCJ","SCK"}),,,"SB1","FFATR001")
		Else
			MaFisIni(SCJ->CJ_CLIENTE,SCJ->CJ_LOJA, "C","N", SA1->A1_TIPO, MaFisRelImp("FFATR001",{"SCJ","SCK"}),,,"SB1","FFATR001")
		Endif	
		
		MaFisAdd(   SCK->CK_PRODUTO	,; // 1-Codigo do Produto ( Obrigatorio )
					SCK->CK_TES    	,; // 2-Codigo do TES ( Opcional )
					SCK->CK_QTDVEN 	,; // 3-Quantidade ( Obrigatorio )
					SCK->CK_PRCVEN 	,; // 4-Preco Unitario ( Obrigatorio )
					SCK->CK_VALDESC	,; // 5-Valor do Desconto ( Opcional )
					""             	,; // 6-Numero da NF Original ( Devolucao/Benef )
					""				,; // 7-Serie da NF Original ( Devolucao/Benef )
					0				,; // 8-RecNo da NF Original no arq SD1/SD2
					n_Frete			,; // 9-Valor do Frete do Item ( Opcional )
					n_Despes        ,; // 10-Valor da Despesa do item ( Opcional )
					n_Segur			,; // 11-Valor do Seguro do item ( Opcional )
					n_FAut      	,; // 12-Valor do Frete Autonomo ( Opcional )
					n_VlrMer		,; // 13-Valor da Mercadoria ( Obrigatorio ) // SCK->CK_VALOR
					0				,; // 14-Valor da Embalagem ( Opiconal )
					0				,; // 15-RecNo do SB1
					0)				   // 16-RecNo do SF4

		_nValIpi  += MaFisRet(nItem,"IT_VALIPI" )
		
		oPrn:Line(n_Lin,0090,n_Lin+60,0090)  // Linha vertical Inicial
		oPrn:Line(n_Lin,0590,n_Lin+60,0590)  // Linha vertical Referencia / Descrição
		oPrn:Line(n_Lin,1270,n_Lin+60,1270)  // Linha vertical Referencia / Descrição
		oPrn:Line(n_Lin,1570,n_Lin+60,1570)  // Linha vertical Descrição / Fabricante
		oPrn:Line(n_Lin,1670,n_Lin+60,1670)  // Linha vertical Fabricante / Unidade de Medida
		oPrn:Line(n_Lin,1820,n_Lin+60,1820)  // Linha vertical Quantidade / Vl.Unitario
		oPrn:Line(n_Lin,2030,n_Lin+60,2030)  // Linha vertical Vl.Unitario / Vl.Total
		oPrn:Line(n_Lin,2250,n_Lin+60,2250)  // Linha vertical Final

		n_Lin += 30 
		oPrn:Say(n_Lin,0100,SCK->CK_PRODUTO,oArial8,,0)
		oPrn:Say(n_Lin,0600,SubStr(c_Desc,1,38),oArial8,,0)
		oPrn:Say(n_Lin,1280,SubStr(SB1->B1_FABRIC,1,16),oArial8,,0)
		oPrn:Say(n_Lin,1580,SCK->CK_UM,oArial8,,0)
		oPrn:Say(n_Lin,1670,Trans(SCK->CK_QTDVEN,"@E@R 999,999,999.99"),oArial8,,,,1)

		If SCK->CK_PRUNIT = 0
			oPrn:Say(n_Lin,1820,Trans(SCK->CK_PRCVEN,"@E@R 999,999,999.99"),oArial8,,,,1)
			n_PrUnit := SCK->CK_PRCVEN  
		Else
			oPrn:Say(n_Lin,1820,Trans(SCK->CK_PRUNIT,"@E@R 999,999,999.99"),oArial8,,,,1)
			n_PrUnit := SCK->CK_PRUNIT  
		Endif

		n_VlTot := ( SCK->CK_QTDVEN * SCK->CK_PRCVEN ) + SCK->CK_VALDESC

		oPrn:Say(n_Lin,2040,Trans(n_VlTot,"@E@R 999,999,999.99"),oArial8,,,,1)

		If Len(c_Desc) > 38 //42	
			n_Lin += 30 
			oPrn:Line(n_Lin,0090,n_Lin+60,0090)  // Linha vertical Inicial
			oPrn:Line(n_Lin,0590,n_Lin+60,0590)  // Linha vertical Referencia / Descrição
			oPrn:Line(n_Lin,1270,n_Lin+60,1270)  // Linha vertical Referencia / Descrição
			oPrn:Line(n_Lin,1570,n_Lin+60,1570)  // Linha vertical Descrição / Fabricante
			oPrn:Line(n_Lin,1670,n_Lin+60,1670)  // Linha vertical Fabricante / Unidade de Medida
			oPrn:Line(n_Lin,1820,n_Lin+60,1820)  // Linha vertical Quantidade / Vl.Unitario
			oPrn:Line(n_Lin,2030,n_Lin+60,2030)  // Linha vertical Vl.Unitario / Vl.Total
			oPrn:Line(n_Lin,2250,n_Lin+60,2250)  // Linha vertical Final

			oPrn:Say(n_Lin,0600,SubStr(c_Desc,39,38),oArial8,,0)
			oPrn:Say(n_Lin,1280,SubStr(SB1->B1_FABRIC,17,16),oArial8,,0)
		
			n_Lin += 30 
			oPrn:Line(n_Lin,0090,n_Lin+30,0090)  // Linha vertical Inicial
			oPrn:Line(n_Lin,0590,n_Lin+30,0590)  // Linha vertical Referencia / Descrição
			oPrn:Line(n_Lin,1270,n_Lin+30,1270)  // Linha vertical Referencia / Descrição
			oPrn:Line(n_Lin,1570,n_Lin+30,1570)  // Linha vertical Descrição / Fabricante
			oPrn:Line(n_Lin,1670,n_Lin+30,1670)  // Linha vertical Fabricante / Unidade de Medida
			oPrn:Line(n_Lin,1820,n_Lin+30,1820)  // Linha vertical Quantidade / Vl.Unitario
			oPrn:Line(n_Lin,2030,n_Lin+30,2030)  // Linha vertical Vl.Unitario / Vl.Total
			oPrn:Line(n_Lin,2250,n_Lin+30,2250)  // Linha vertical Final

			oPrn:Say(n_Lin,0600,"Reg. ANVISA: " + SB1->B1_FSCANVI ,oArial8,,0) // " Reg. ANVISA: " + SB1->B1_FSCANVI
		Else
			n_Lin += 30 
			oPrn:Line(n_Lin,0090,n_Lin+30,0090)  // Linha vertical Inicial
			oPrn:Line(n_Lin,0590,n_Lin+30,0590)  // Linha vertical Referencia / Descrição
			oPrn:Line(n_Lin,1270,n_Lin+30,1270)  // Linha vertical Referencia / Descrição
			oPrn:Line(n_Lin,1570,n_Lin+30,1570)  // Linha vertical Descrição / Fabricante
			oPrn:Line(n_Lin,1670,n_Lin+30,1670)  // Linha vertical Fabricante / Unidade de Medida
			oPrn:Line(n_Lin,1820,n_Lin+30,1820)  // Linha vertical Quantidade / Vl.Unitario
			oPrn:Line(n_Lin,2030,n_Lin+30,2030)  // Linha vertical Vl.Unitario / Vl.Total
			oPrn:Line(n_Lin,2250,n_Lin+30,2250)  // Linha vertical Final

			oPrn:Say(n_Lin,0600,"Reg. ANVISA: " + SB1->B1_FSCANVI ,oArial8,,0) // " Reg. ANVISA: " + SB1->B1_FSCANVI
			oPrn:Say(n_Lin,1280,SubStr(SB1->B1_FABRIC,17,16),oArial8,,0)

			n_Lin += 30 
			oPrn:Line(n_Lin,0090,n_Lin+30,0090)  // Linha vertical Inicial
			oPrn:Line(n_Lin,0590,n_Lin+30,0590)  // Linha vertical Referencia / Descrição
			oPrn:Line(n_Lin,1270,n_Lin+30,1270)  // Linha vertical Referencia / Descrição
			oPrn:Line(n_Lin,1570,n_Lin+30,1570)  // Linha vertical Descrição / Fabricante
			oPrn:Line(n_Lin,1670,n_Lin+30,1670)  // Linha vertical Fabricante / Unidade de Medida
			oPrn:Line(n_Lin,1820,n_Lin+30,1820)  // Linha vertical Quantidade / Vl.Unitario
			oPrn:Line(n_Lin,2030,n_Lin+30,2030)  // Linha vertical Vl.Unitario / Vl.Total
			oPrn:Line(n_Lin,2250,n_Lin+30,2250)  // Linha vertical Final

			oPrn:Say(n_Lin,1280,SubStr(SB1->B1_FABRIC,33,16),oArial8,,0)
		Endif

		oPrn:Line(n_Lin+30,0090,n_Lin+30,2250)  // Linha abaixo

		n_Lin 		+= 30
		n_TotGer 	+= n_VlTot
		n_TotVal 	+= SCK->CK_VALOR

		SCK->( DbSkip() )

	Enddo

	MaFisEnd()

	If	n_Lin >= 2700
		Cabec1()
		Cab_Cliente(l_Prop)
	Endif	
	
	oPrn:Line(n_Lin,0090,n_Lin,2250)  // Linha acima
	oPrn:Line(n_Lin,0090,n_Lin+120,0090)  // Linha vertical Inicial
	oPrn:Line(n_Lin,2030,n_Lin+60,2030)  // Linha vertical Vl.Unitario / Vl.Total
	oPrn:Line(n_Lin,2250,n_Lin+120,2250)  // Linha vertical Final
	
	n_Lin += 30
	oPrn:Say(n_Lin+10,0800,"VALOR TOTAL R$ ",oArial11N,,0)
	oPrn:Say(n_Lin+10,2050,Trans((n_TotGer),"@E@R 999,999,999.99"),oArial11N,,,,1)

	n_Lin += 30
	oPrn:Line(n_Lin,0090,n_Lin,2250)  // Linha abaixo

	n_Lin += 30
	oPrn:Say(n_Lin+10,0100,"Valor por Extenso:",oArial11N,,0)
	oPrn:Say(n_Lin+10,0400,Extenso(n_TotGer,.F.,1,,"1",.T.,.F.),oArial11,,,,1)
	
	n_Lin += 30
	oPrn:Line(n_Lin,0090,n_Lin,2250)  // Linha abaixo

	//n_Lin += 60
	//oPrn:Line(n_Lin+30,1559,n_Lin+30,2260)  // Linha abaixo

	n_Lin += 80
	
	
	oPrn:Say(n_Lin,0100,"PAGAMENTO: ",oArial11N,,0)
	oPrn:Say(n_Lin,0320,Alltrim(SE4->E4_DESCRI),oArial11,,,,1)

	/*
	
	//oPrn:Say(n_Lin,0700,"MOEDA: ",oArial11N,,0)
	//oPrn:Say(n_Lin,1100,Alltrim(SX5->X5_DESCRI),oArial11,,,,1)
		

	//DateDiffDay( dDate1 , dDate2 )
	oPrn:Say(n_Lin,1750,"PRAZO ENTREGA: ",oArial11N,,0)
	oPrn:Say(n_Lin,2050,DTOC(d_Entreg),oArial11,,,,1) 
	
	*/

	n_Lin += 80
	oPrn:Say(n_Lin,0100,"Informamos que o pedido está  sujeito a disponibilidade de estoque.",oArial11N,,0)
	
	n_Lin += 80

	If	n_Lin >= 2700
		Cabec1()
	Endif
	
	// tem paciente informado
	If !Empty(SCJ->CJ_FSPACIE)
		oPrn:Say(n_Lin,0100,"Paciente: " + Alltrim(SCJ->CJ_FSPACIE),oArial7,100)
		n_Lin += 30
	
		If	n_Lin >= 2700
			Cabec1()
		Endif
	Endif
			
	// tem convenio informado
	If !Empty(SCJ->CJ_FSCONVE)
		oPrn:Say(n_Lin,0100,"Convenio: " + Alltrim(SCJ->CJ_FSCONVE),oArial7,100)
		n_Lin += 30
	
		If	n_Lin >= 2700
			Cabec1()
		Endif
	Endif

	cDescr := Alltrim(SCJ->CJ_FSOBSNF)
	nLinha:= MLCount(cDescr,180)
	
	For I := 1 to nLinha
		oPrn:Say(n_Lin,0100,MemoLine(cDescr,180,I),oArial7,100)
		n_Lin += 30
	
		If	n_Lin >= 2700
			Cabec1()
		Endif
	Next
	
	If	n_Lin >= 2700
		Cabec1()
	Endif
	
	Rodap1(n_Pag)

	oPrn:Preview()
	MS_FLUSH()

Return .T.

Static Function Cabec1()
   
	Local cEmissao := ""

	cEmissao += Alltrim(SM0->M0_CIDCOB)+","
   	cEmissao += cValToChar(Day(dDatabase))
    cEmissao += " de "
    cEmissao += MesExtenso(dDatabase)
    cEmissao += " de "
    cEmissao += cValToChar(Year(dDatabase))

	oPrn:StartPage()

	oPrn:SayBitMap(0075,0100,cImag001,0400,0200)

	oPrn:Say(0100,1800,"ORÇAMENTO Nº",oArial11N,,0)
	oPrn:Say(0146,1850,SCJ->CJ_NUM,oArial11N,,0)
	//oPrn:Say(0246,0116,"DADOS DO CLIENTE",oArial11N,,0)
	oPrn:Say(0246,1600,cEmissao,oArial10,,0)

	n_Lin := 300
Return

Static Function Cab_Cliente(l_Prop)
	oPrn:Box(n_Lin,0090,n_Lin+360,2250)

	If l_Prop // Prospect
		DbSelectArea("SUS")

		n_Lin += 40 
		oPrn:Say(n_Lin,0116,"Cliente: ",oArial8N,,0)
		oPrn:Say(n_Lin,0237,SUS->US_NOME + Space(10)+Transform(SUS->US_CGC,If(SUS->US_PESSOA=='J','@R 99.999.999/9999-99','@R 999.999.999-99')) ,oArial8,,0)
		
		n_Lin += 50
		oPrn:Say(n_Lin,0116,"Endereço:",oArial8N,,0)
		oPrn:Say(n_Lin,0265,Alltrim(SUS->US_END),oArial8,,0)

		n_Lin += 50
		/*oPrn:Say(n_Lin,0116,"Complemento:",oArial8N,,0)
		oPrn:Say(n_Lin,0300,SA1->A1_COMPLEM,oArial8,,0)*/

		n_Lin += 50
		oPrn:Say(n_Lin,0116,"Bairro:",oArial8N,,0)
		oPrn:Say(n_Lin,0250,SUS->US_BAIRRO,oArial8,,0)

		oPrn:Say(n_Lin,0616,"CEP:",oArial8N,,0)
		oPrn:Say(n_Lin,0700,SUS->US_CEP,oArial8,,0)
		
		oPrn:Say(n_Lin,0916,"Cidade:",oArial8N,,0)
		oPrn:Say(n_Lin,1050,SUS->US_MUN,oArial8,,0)
		
		oPrn:Say(n_Lin,1516,"Estado:",oArial8N,,0)
		oPrn:Say(n_Lin,1670,SUS->US_EST,oArial8,,0)

		n_Lin += 50
		oPrn:Say(n_Lin,0116,"Telefone:"		,oArial8N,,0)
		oPrn:Say(n_Lin,0250,Alltrim(SUS->US_DDD) + " " + SUS->US_TEL		,oArial8 ,,0)

		n_Lin += 50
		oPrn:Say(n_Lin,0116,"Email:"		,oArial8N,,0)
		oPrn:Say(n_Lin,0250,SUS->US_EMAIL	,oArial8 ,,0)

		n_Lin += 50
		/*oPrn:Say(n_Lin,0116,"Contato:"		,oArial8N,,0)
		oPrn:Say(n_Lin,0250,SA1->A1_CONTATO	,oArial8 ,,0)*/
	Else	
		DbSelectArea("SA1")

		n_Lin += 40 
		oPrn:Say(n_Lin,0116,"Cliente: ",oArial8N,,0)
		oPrn:Say(n_Lin,0237,SA1->A1_NOME + Space(10)+Transform(SA1->A1_CGC,If(SA1->A1_PESSOA=='J','@R 99.999.999/9999-99','@R 999.999.999-99')) ,oArial8,,0)
		
		n_Lin += 50
		oPrn:Say(n_Lin,0116,"Endereço:",oArial8N,,0)
		oPrn:Say(n_Lin,0265,Alltrim(SA1->A1_END),oArial8,,0)

		n_Lin += 50
		oPrn:Say(n_Lin,0116,"Complemento:",oArial8N,,0)
		oPrn:Say(n_Lin,0300,SA1->A1_COMPLEM,oArial8,,0)

		n_Lin += 50
		oPrn:Say(n_Lin,0116,"Bairro:",oArial8N,,0)
		oPrn:Say(n_Lin,0250,SA1->A1_BAIRRO,oArial8,,0)

		oPrn:Say(n_Lin,0616,"CEP:",oArial8N,,0)
		oPrn:Say(n_Lin,0700,SA1->A1_CEP,oArial8,,0)
		
		oPrn:Say(n_Lin,0916,"Cidade:",oArial8N,,0)
		oPrn:Say(n_Lin,1050,SA1->A1_MUN,oArial8,,0)
		
		oPrn:Say(n_Lin,1516,"Estado:",oArial8N,,0)
		oPrn:Say(n_Lin,1670,SA1->A1_EST,oArial8,,0)

		n_Lin += 50
		oPrn:Say(n_Lin,0116,"Telefone:"		,oArial8N,,0)
		oPrn:Say(n_Lin,0250,Alltrim(SA1->A1_DDD) + " " + SA1->A1_TEL		,oArial8 ,,0)

		n_Lin += 50
		oPrn:Say(n_Lin,0116,"Email:"		,oArial8N,,0)
		oPrn:Say(n_Lin,0250,SA1->A1_EMAIL	,oArial8 ,,0)

		n_Lin += 50
		oPrn:Say(n_Lin,0116,"Contato:"		,oArial8N,,0)
		oPrn:Say(n_Lin,0250,SA1->A1_CONTATO	,oArial8 ,,0)
	Endif

	n_Lin += 80
	oPrn:Say(n_Lin,0116,"Conforme solicitado, estamos enviando o orcamento dos seguintes produtos:",oArial11N,,0)
	n_Lin += 60
Return

Static Function Cab_Grade()

	oPrn:Line(n_Lin,0090,n_Lin,2250)  		// Linha acima
	oPrn:Line(n_Lin,0090,n_Lin+60,0090)  	// Linha vertical Inicial
	oPrn:Line(n_Lin,2250,n_Lin+60,2250)  	// Linha vertical Final
	oPrn:Line(n_Lin+60,0090,n_Lin+60,2250)  // Linha acima
	
	oPrn:Line(n_Lin,0590,n_Lin+60,0590)  // Linha vertical Referencia / Descrição
	oPrn:Line(n_Lin,1270,n_Lin+60,1270)  // Linha vertical Referencia / Descrição
	oPrn:Line(n_Lin,1570,n_Lin+60,1570)  // Linha vertical Descrição / Fabricante
	oPrn:Line(n_Lin,1670,n_Lin+60,1670)  // Linha vertical Fabricante / Unidade de Medida
	oPrn:Line(n_Lin,1820,n_Lin+60,1820)  // Linha vertical Quantidade / Vl.Unitario
	oPrn:Line(n_Lin,2030,n_Lin+60,2030)  // Linha vertical Vl.Unitario / Vl.Total
	
	n_Lin += 30
	oPrn:Say(n_Lin,0100,"REF."			,oArial8N,,0)
	oPrn:Say(n_Lin,0600,"DESCRIÇÃO"		,oArial8N,,0)
	oPrn:Say(n_Lin,1280,"FAB"			,oArial8N,,0)
	oPrn:Say(n_Lin,1580,"UN"			,oArial8N,,0)
	oPrn:Say(n_Lin,1670,"QTDE"			,oArial8N,,0)
	oPrn:Say(n_Lin,1820,"VALOR UNIT."	,oArial8N,,0)
	oPrn:Say(n_Lin,2040,"VALOR TOTAL"	,oArial8N,,0)

	n_Lin += 30
Return

Static Function Rodap1(n_Pag)
	Local c_Email := GetNewPar("FS_MAILORC", "vendas@primemedical.com.br")
	Local c_Site  := GetNewPar("FS_SITEORC", "www.primemedical.com.br")
	
	n_Lin := 2870
	oPrn:Say(n_Lin,0100,"Proposta Digitada por:",oArial11N,,0)
	oPrn:Say(n_Lin,0600,SCJ->CJ_FSUSER,oArial8N,,0)
	oPrn:Say(n_Lin,2000,"Página: " + Alltrim(Str(n_Pag)) ,oArial8,,0) 

	n_Lin := n_Lin + 30
	oPrn:Line(n_Lin,0090,n_Lin,2250)  // Linha acima
	
	n_Lin += 50
	oPrn:Say(n_Lin,0200,Alltrim(SM0->M0_ENDCOB) + ', '+Alltrim(SM0->M0_COMPCOB) + ' - ' + Alltrim(SM0->M0_BAIRCOB) + ' - ' + Alltrim(SM0->M0_CIDCOB) + '-' + Alltrim(SM0->M0_ESTCOB) + ' CEP: ' + SM0->M0_CEPCOB,oArial8,100) //450

	n_Lin += 50
//	oPrn:Say(n_Lin,0300,"Fone: " + Alltrim(SM0->M0_TEL) + "  E-mail: " + Alltrim(c_Email) + "  Site: " + AllTrim(c_Site),oArial8,100) 
	oPrn:Say(n_Lin,0200,'CNPJ: '+ Transform(SM0->M0_CGC,'@R 99.999.999/9999-99') + "  Fone: " + Alltrim(SM0->M0_TEL) + "  E-mail: " + Alltrim(c_Email) + "  Site: " + AllTrim(c_Site) ,oArial8,100) 

	/*n_Lin += 100
	oPrn:Line(n_Lin,0090,n_Lin,2260)
	oPrn:Say(n_Lin+10,0116,Dtoc(dDatabase)+Time(),oArial8N,100)*/

	oPrn:EndPage()


Return
