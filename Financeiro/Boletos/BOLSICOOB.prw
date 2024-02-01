//-----------------------------------------------------------------------------------------------------------------------------------
#include "rwmake.ch"
#include "protheus.ch"
#INCLUDE "Report.CH"
#INCLUDE 'TOPCONN.CH'
//-----------------------------------------------------------------------------------------------------------------------------------
#DEFINE _cCarteira "1"
#DEFINE _cMoeda    "9"
//-----------------------------------------------------------------------------------------------------------------------------------
User Function BLTSICOOB(cNota)

	Local	aPergs := {}
	Private lExec    := .F.
	Private cIndexName := ''
	Private cIndexKey  := ''
	Private cFilter    := ''

	DEFAULT cNota := Space(09)

	Tamanho  := "M"
	titulo   := "Impressao de Boleto com Codigo de Barras"
	cDesc1   := "Este programa destina-se a impressao do Boleto com Codigo de Barras."
	cDesc2   := ""
	cDesc3   := ""
	cString  := /*"SEE" */   "SE1"
	wnrel    := "BOLETO"
	lEnd     := .F.
	cPerg     := Padr("BOLTSICOOB",10)
	aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
	nLastKey := 0

	cNf	:= cNota

	dbSelectArea("SE1")

	PutSx1( cPerg   ,"01","De Prefixo"	           ,"","","mv_ch1","C",3,0,0,"G","","","","","MV_PAR01","","","","","","","","","","","","","","","","",{},{},{})
	PutSx1( cPerg   ,"02","Ate Prefixo"	           ,"","","mv_ch2","C",3,0,0,"G","","","","","MV_PAR02","","","","","","","","","","","","","","","","",{},{},{})
	PutSx1( cPerg   ,"03","De Numero"		       ,"","","mv_ch3","C",9,0,0,"G","","SE1","","","MV_PAR03","","","","","","","","","","","","","","","","",{},{},{})
	PutSx1( cPerg   ,"04","Ate Numero"	           ,"","","mv_ch4","C",9,0,0,"G","","SE1","","","MV_PAR04","","","","","","","","","","","","","","","","",{},{},{})
	PutSx1( cPerg   ,"05","De Parcela"	           ,"","","mv_ch5","C",2,0,0,"G","","","","","MV_PAR05","","","","","","","","","","","","","","","","",{},{},{})
	PutSx1( cPerg   ,"06","Ate Parcela"	           ,"","","mv_ch6","C",2,0,0,"G","","","","","MV_PAR06","","","","","","","","","","","","","","","","",{},{},{})
	PutSx1( cPerg   ,"07","De Portador"	           ,"","","mv_ch7","C",3,0,0,"G","","","","","MV_PAR07","","","","","","","","","","","","","","","","",{},{},{})
	PutSx1( cPerg   ,"08","Ate Portador" 	       ,"","","mv_ch8","C",3,0,0,"G","","","","","MV_PAR08","","","","","","","","","","","","","","","","",{},{},{})
	PutSx1( cPerg   ,"09","De Cliente"	           ,"","","mv_ch9","C",6,0,0,"G","","SA1","","","MV_PAR09","","","","","","","","","","","","","","","","",{},{},{})
	PutSx1( cPerg   ,"10","Ate Cliente"	           ,"","","mv_cha","C",6,0,0,"G","","SA1","","","MV_PAR10","","","","","","","","","","","","","","","","",{},{},{})
	PutSx1( cPerg   ,"11","De Loja"		           ,"","","mv_chb","C",2,0,0,"G","","","","","MV_PAR11","","","","","","","","","","","","","","","","",{},{},{})
	PutSx1( cPerg   ,"12","Ate Loja"		       ,"","","mv_chc","C",2,0,0,"G","","","","","MV_PAR12","","","","","","","","","","","","","","","","",{},{},{})
	PutSx1( cPerg   ,"13","De Emissao"	           ,"","","mv_chd","D",8,0,0,"G","","","","","MV_PAR13","","","","","","","","","","","","","","","","",{},{},{})
	PutSx1( cPerg   ,"14","De Emissao"	           ,"","","mv_che","D",8,0,0,"G","","","","","MV_PAR14","","","","","","","","","","","","","","","","",{},{},{})
	PutSx1( cPerg   ,"15","De Vencimento"	       ,"","","mv_chf","D",8,0,0,"G","","","","","MV_PAR15","","","","","","","","","","","","","","","","",{},{},{})
	PutSx1( cPerg   ,"16","Ate Vencimento"         ,"","","mv_chg","D",8,0,0,"G","","","","","MV_PAR16","","","","","","","","","","","","","","","","",{},{},{})
	PutSx1( cPerg   ,"17","Do Bordero"	           ,"","","mv_chh","C",6,0,0,"G","","","","","MV_PAR17","","","","","","","","","","","","","","","","",{},{},{})
	PutSx1( cPerg   ,"18","Ate Bordero"            ,"","","mv_chi","C",6,0,0,"G","","","","","MV_PAR18","","","","","","","","","","","","","","","","",{},{},{})
	PutSx1( cPerg   ,"19","Banco     "             ,"","","mv_chj","C",3,0,0,"G","","SEE","","","MV_PAR19","","","","","","","","","","","","","","","","",{},{},{})
	PutSx1( cPerg   ,"20","Agencia    "            ,"","","mv_chl","C",5,0,0,"G","","","","","MV_PAR20","","","","","","","","","","","","","","","","",{},{},{})
	PutSx1( cPerg   ,"21","Conta      "            ,"","","mv_chm","C",10,0,0,"G","","","","","MV_PAR21","","","","","","","","","","","","","","","","",{},{},{})

	If Empty(cNF)

		If !Pergunte (cPerg,.T.)
			Return
		Endif

		cIndexName	:= Criatrab(Nil,.F.)
		cIndexKey		:= "E1_PORTADO+E1_CLIENTE+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)"

		cFilter		+= "E1_FILIAL=='"+xFilial("SE1")+"'.And.E1_SALDO>0.And."
		cFilter		+= "E1_PREFIXO>='" + MV_PAR01 + "'.And.E1_PREFIXO<='" + MV_PAR02 + "'.And."
		cFilter		+= "E1_NUM>='" + MV_PAR03 + "'.And.E1_NUM<='" + MV_PAR04 + "'.And."
		cFilter		+= "E1_PARCELA>='" + MV_PAR05 + "'.And.E1_PARCELA<='" + MV_PAR06 + "'.And."
		cFilter		+= "E1_CLIENTE>='" + MV_PAR09 + "'.And.E1_CLIENTE<='" + MV_PAR10 + "'.And."
		cFilter		+= "E1_LOJA>='" + MV_PAR11 + "'.And.E1_LOJA<='"+MV_PAR12+"'.And."
		cFilter		+= "DTOS(E1_EMISSAO)>='"+DTOS(mv_par13)+"'.and.DTOS(E1_EMISSAO)<='"+DTOS(mv_par14)+"'.And."
		cFilter		+= "DTOS(E1_VENCREA)>='"+DTOS(mv_par15)+"'.and.DTOS(E1_VENCREA)<='"+DTOS(mv_par16)+"'.And."
		cFilter		+= "E1_NUMBOR>='" + MV_PAR17 + "'.And.E1_NUMBOR<='" + MV_PAR18 + "'.And."
		cFilter		+= "!(E1_TIPO$MVABATIM)"

		If Empty(MV_PAR19)
			cFilter		+= ".And. E1_PORTADO>='" + MV_PAR07 + "'.And.E1_PORTADO<='" + MV_PAR08 + "' "
			cFilter		+= ".And. E1_PORTADO<>'   '"
		Endif

	Else

		cFilter		+= "E1_NUM = '" + cNF + "' "

	Endif

	IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
	DbSelectArea("SE1")

	#IFNDEF TOP
		DbSetIndex(cIndexName + OrdBagExt())
	#ENDIF

	dbGoTop()

	If Empty(cNF)

		@ 001,001 TO 400,700 DIALOG oDlg TITLE "SeleÁ„o de Titulos"
		@ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK"
		@ 180,310 BMPBUTTON TYPE 01 ACTION (lExec := .T.,Close(oDlg))
		@ 180,280 BMPBUTTON TYPE 02 ACTION (lExec := .F.,Close(oDlg))

		ACTIVATE DIALOG oDlg CENTERED

		dbGoTop()

	Else

		lExec := .t.

	Endif

	If lExec
		Processa({ |lEnd| MontaRel() })
	Endif

	RetIndex("SE1")
	Ferase(cIndexName+OrdBagExt())

Return
//-----------------------------------------------------------------------------------------------------------------------------------
Static Function MontaRel()

	Local oPrint
	Local nX			:= 0
	Local cNroDoc 	:= " "
	Local aDadosEmp   	:= {	SM0->M0_NOMECOM                                    					,; //[1]Nome da Empresa
	SM0->M0_ENDCOB                                   						,; //[2]Endere√ßo
	AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
	"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
	"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
	"CNPJ: "+TRANSFORM(SM0->M0_CGC,"@R 99.999.999/9999-99")				 ,; //[6]CNPJ
	"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
	Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //[7]I.E

	Local aDadosTit   := {}
	Local aDadosBanco := {}
	Local aDatSacado  := {}
//	Local aBolText    := {"APOS O VENCIMENTO COBRAR MORA DE R$....... ","PROTESTAR APOS 10 DIAS CORRIDOS DO VENCIMENTO ","AO DIA"}

	Local nI          := 1
	Local aCB_RN_NN   := {}
	Local nVlrAbat	:= 0

	Private cStartPath:= GetSrvProfString("Startpath","")

	oPrint:= TMSPrinter():New( "Boleto Laser" )
	oPrint:SetPortrait() 						// ou SetLandscape()
	oPrint:Setup()   							// Inicia uma nova p√°gina

	DbGoTop()
	ProcRegua(RecCount())

	Do While !EOF()

		If Marked("E1_OK")

			If Empty(MV_PAR19)

				//Posiciona o SA6 (Bancos)
				DbSelectArea("SA6")
				DbSetOrder(1)
				DbSeek(xFilial("SA6")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA,.T.)


				//Posiciona na Arq de Parametros CNAB
				DbSelectArea("SEE")
				DbSetOrder(1)
				DbSeek(xFilial("SEE")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA),.T.)

			Else

				//Posiciona o SA6 (Bancos)

				DbSelectArea("SA6")
				DbSetOrder(1)
				DbSeek(xFilial("SA6")+MV_PAR19+MV_PAR20+MV_PAR21,.T.)

				//Posiciona na Arq de Parametros CNAB
				DbSelectArea("SEE")
				DbSetOrder(1)
				DbSeek(xFilial("SEE")+MV_PAR19+MV_PAR20+MV_PAR21,.T.)

			Endif

			//Posiciona o SA1 (Cliente)
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)

			// Efetua o Preenchimento do Campo E1_NUMBCO com
			// o Numero Sequencial da Tabela EE_FAXATU.

			DbSelectArea("SE1")

			If Empty(SE1->E1_NUMBCO)
				NossoNum()
			Endif

			aAdd(aDadosBanco, Alltrim(SEE->EE_CODIGO))            // [1]Numero do Banco
			aAdd(aDadosBanco, Alltrim(SA6->A6_NOME))              // [2]Nome do Banco
			aAdd(aDadosBanco, Alltrim(SEE->EE_AGENCIA))           // [3]Ag√™ncia
			aAdd(aDadosBanco, Alltrim(SEE->EE_CONTA)) 			  // [4]Conta Corrente
			aAdd(aDadosBanco, Right(Alltrim(SEE->EE_DVCTA),1))    // [5]D√≠gito da conta corrente
			aAdd(aDadosBanco, Alltrim(_cCarteira))                // [6]Codigo da Carteira
			aAdd(aDadosBanco, Right(Alltrim(SE1->E1_PARCELA),1))  // [7] PARCELA

			If Empty(SA1->A1_ENDCOB)
				aDatSacado   := {AllTrim(SA1->A1_NOME)           	,;      	// [1]Raz√£o Social
				AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           	,;      	// [2]C√≥digo
				AllTrim(SA1->A1_END )							,;      	// [3]Endere√ßo
				AllTrim(SA1->A1_MUN )                            	,;  		// [4]Cidade
				SA1->A1_EST                                      	,;     	// [5]Estado
				SA1->A1_CEP                                      	,;      	// [6]CEP
				SA1->A1_CGC									,;       // [7]CGC
				SA1->A1_PESSOA								,;       // [8]PESSOA
				AllTrim(SA1->A1_BAIRRO)                           	}        // [9]Bairro
			Else
				aDatSacado   := {AllTrim(SA1->A1_NOME)            	,;   	// [1]Raz√£o Social
				AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA            ,;   	// [2]C√≥digo
				AllTrim(SA1->A1_ENDCOB)						,;   	// [3]Endere√ßo
				AllTrim(SA1->A1_MUNC)	                           ,;   	// [4]Cidade
				SA1->A1_ESTC	                                    ,;   		// [5]Estado
				SA1->A1_CEPC                                      ,;   	// [6]CEP
				SA1->A1_CGC									,;		// [7]CGC
				SA1->A1_PESSOA								,;		// [8]PESSOA
				AllTrim(SA1->A1_BAIRRO)                            }      	// [9]Bairro
			Endif

			nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
			nVlrTitulo := (E1_SALDO+E1_SDACRES-nVlrAbat)

			//--------------------------------------------------------------
			//Parte do Nosso Numero. Sao 8 digitos para identificar o titulo
			//--------------------------------------------------------------

		/*if .not. empty ( SE1->E1_PARCELA)
			_cParcela := StrZero( Asc( Upper( ALLTRIM( SE1->E1_PARCELA ) ) ) - 64, 3, 0 )
		else
			_cParcela := '001'
		endif*/

		if .not. empty(SE1->E1_PARCELA)
    		_cParcela := StrZero(Val(ALLTRIM(SE1->E1_PARCELA)), 3, 0)
		else
    		_cParcela := '001'
		endif

		
		cNroDoc	 := StrZero( Val( Alltrim ( SE1->E1_NUM ) + _cParcela ), 8 )
		/*
		----------------------
		Monta codigo de barras
		----------------------
		*/
			aCB_RN_NN := fLinhaDig(aDadosBanco[1]      ,; // Numero do Banco
			_cMoeda             ,; // Codigo da Moeda
			aDadosBanco[6]      ,; // Codigo da Carteira
			aDadosBanco[3]      ,; // Codigo da Agencia
			aDadosBanco[4]      ,; // Codigo da Conta
			aDadosBanco[5]      ,; // DV da Conta
			nVlrTitulo		  ,; // Valor do Titulo
			E1_VENCTO           ,; // Data de Vencimento do Titulo
			cNroDoc              ) // Numero do Documento no Contas a Receber


			aDadosTit	:= {AllTrim(E1_NUM)+AllTrim(E1_PARCELA)	,;  // [1] N√∫mero do t√≠tulo
			E1_EMISSAO                          	,;  // [2] Data da emiss√£o do t√≠tulo
			dDataBase                    		,;  // [3] Data da emiss√£o do boleto
			E1_VENCTO                           	,;  // [4] Data do vencimento
			nVlrTitulo		               	,;  // [5] Valor do t√≠tulo
			aCB_RN_NN[3]                        	,;  // [6] Nosso n√∫mero (Ver f√≥rmula para calculo)
			E1_PREFIXO                          	,;  // [7] Prefixo da NF
			E1_TIPO	                           	}   // [8] Tipo do Titulo

			Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,,aCB_RN_NN)
			nX := nX + 1

		EndIf
		DbSkip()
		IncProc()
		nI++
	EndDo

	oPrint:Preview()     // Visualiza antes de imprimir

Return Nil


/*
+-----------+----------+-------+--------------------+------+-------------+
| Programa  |Impress   |Autor  |PSS PARTNERS        | Data |  23/10/2014 |
+-----------+----------+-------+--------------------+------+-------------+
| Desc.     |Impressao dos dados do boleto em modo grafico               |
|           |                                                            |
+-----------+------------------------------------------------------------+
*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
	Local oFont8
	Local oFont11c
	Local oFont10
	Local oFont12
	Local oFont14
	Local oFont16n
	Local oFont15
	Local oFont14n
	Local oFont24
	Local nI := 0
	Local cStartPath := GetSrvProfString("StartPath","")
	Local cBmp := 030

	cBmp := cStartPath + "sicoob.bmp" //Logo do Banco                                     *********************************** AQUI ********************


//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
	oFont8   := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont11  := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont9  := TFont():New("Arial",9,8,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont10  := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont12  := TFont():New("Arial Narrow",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont14  := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont21  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16n := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont15n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont14n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

	oPrint:StartPage()   // Inicia uma nova p√°gina

/******************/
/* PRIMEIRA PARTE */
/******************/

	nRow1 := 0



	If File(cBmp)
		oPrint:SayBitmap(nRow1+0080,100,cBmp,215,65) // ******************* Primeiro Logo ********************************
	Endif

//oPrint:Say  (nRow1+0084,100,aDadosBanco[2],oFont10 )	        // [2]Nome do Banco 


	oPrint:Line (nRow1+0150,100,nRow1+0150,2300)

	oPrint:Say  (nRow1+0150,100 ,"Benefici·rio",oFont10)
	oPrint:Say  (nRow1+0200,100 ,aDadosEmp[1]+" ("+aDadosEmp[6]+")"             ,oFont8)
	oPrint:Say  (nRow1+0250,100 ,aDadosEmp[2]                                    ,oFont8)
	oPrint:Say  (nRow1+0300,100 ,aDadosEmp[4]+"    "+aDadosEmp[3] ,oFont8) // CEP+Cidade+Estado
	oPrint:Say  (nRow1+0350,100 ,aDadosEmp[6] ,oFont8)

	oPrint:Say  (nRow1+0650,1510,"Nosso N˙mero"                                 ,oFont8)
	cString :=  Right(AllTrim(SE1->E1_NUMBCO),7)+'-'+SE1->E1_NUMDV
	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow1+0700,nCol,cString,oFont11c)

	oPrint:Say  (nRow1+0550,1510,"AgÍncia/CÛdigo Benefici·rio",oFont8)
	oPrint:Say  (nRow1+0600,1510,aDadosBanco[3]+"/"+aDadosBanco[4]+" "+aDadosBanco[5],oFont10)

	oPrint:Say  (nRow1+0150,1510,"Vencimento",oFont8)
	oPrint:Say  (nRow1+0200,1510,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)

	oPrint:Say  (nRow1+0450,1510,"Data de emiss„o",oFont8)
	oPrint:Say  (nRow1+0500,1510,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)


	oPrint:Say  (nRow1+0150,1910,"Valor do Documento",oFont8)
	oPrint:Say  (nRow1+0205,1910,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

	oPrint:Say  (nRow1+0450,0100,"InstruÁıes(texto de responsabilidade do benefici·rio)",oFont10)
	oPrint:Say  (nRow1+0550,0100,"Vencido mora 0,08%ad/multa 2,00%",oFont10)
	oPrint:Say  (nRow1+0600,0100,"N√O ACEITAMOS DEP”SITO PARA LIQUIDA«√O DO TÕTULO.",oFont12)
	oPrint:Say  (nRow1+0650,0100,"QUALQUER ALTERA«√O NA DATA DE VENCIMENTO SER¡ COBRADO TAXA ADICIONAL.",oFont12)
	oPrint:Say  (nRow1+0700,0100,"NEGATIVA«√O NO SERASA E PROTESTO AUTOM¡TICO AP”S O VENCIMENTO.",oFont12)
	oPrint:Say  (nRow1+0250,1510,"Outros AcrÈscimos",oFont8)
	oPrint:Say  (nRow1+0250,1910,"Mora / Multa",oFont8)
	oPrint:Say  (nRow1+0350,1510,"Desconto / Abatimento",oFont8)
	oPrint:Say  (nRow1+0350,1910,"Outras DeduÁıes",oFont8)
	oPrint:Say  (nRow1+0450,1910,"Valor Cobrado",oFont8)

	oPrint:Line (nRow1+0350,1510,nRow1+0350,2300 )
	oPrint:Line (nRow1+0250,1510,nRow1+0250,2300 )
	oPrint:Line (nRow1+0450, 100,nRow1+0450,2300 )
	oPrint:Line (nRow1+0450,1510,nRow1+0450,2300 ) //---
	oPrint:Line (nRow1+0550,1510,nRow1+0550,2300 )
	oPrint:Line (nRow1+0750, 100,nRow1+0750,2300 )
	oPrint:Line (nRow1+0650,1510,nRow1+0650,2300 )

	oPrint:Line (nRow1+0150,2300,nRow1+0750,2300 )
	oPrint:Line (nRow1+0150,100,nRow1+0750,0100 )
	oPrint:Line (nRow1+0150,1500,nRow1+0750,1500 ) //--
	oPrint:Line (nRow1+0150,1900,nRow1+0550,1900 )


/*****************/
/* SEGUNDA PARTE */
/*****************/

	nRow2   := 0

//Pontilhado separador
/*
For nI := 100 to 2300 step 50
oPrint:Line(nRow2+0580, nI,nRow2+0580, nI+30)
Next nI
*/

/*
If File(cBmp)
	oPrint:SayBitmap(nRow2+0644,100,cBmp,215,65)    *********COMENTEI PQ ESTA CHAMANDO NO LUGAR ERRADO************************** AQUI ************
Endif
*/
	oPrint:Say  (nRow2+880,100,"Dados do Pagador",oFont11)

	oPrint:Line (nRow2+0950,100,nRow2+0950,2300 )
	oPrint:Line (nRow2+1050,100,nRow2+1050,2300 )
	oPrint:Line (nRow2+1150,100,nRow2+1150,2300 )
	oPrint:Line (nRow2+1250,100,nRow2+1250,2300 )
	oPrint:Line (nRow2+1350,100,nRow2+1350,2300 )
	oPrint:Line (nRow2+1600,100,nRow2+1600,2300 )

	oPrint:Line (nRow2+0950,0100,nRow2+1600,0100)
	oPrint:Line (nRow2+0950,1800,nRow2+1050,1800)
	oPrint:Line (nRow2+1250,1700,nRow2+1350,1700)
	oPrint:Line (nRow2+1250,1500,nRow2+1350,1500)
	oPrint:Line (nRow2+0950,2300,nRow2+1600,2300)

	oPrint:Say  (nRow2+0950,110 ,"Nome do Pagador"                                        ,oFont8)
	oPrint:Say  (nRow2+1000,110 ,aDatSacado[1]+"                   ",oFont10) //Nome


	oPrint:Say  (nRow2+0950,1810 ,"Nro.Documento"                                  ,oFont8)
	oPrint:Say  (nRow2+1000,1810 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela

	oPrint:Say  (nRow2+1050,110 ,"EndereÁo"                                        ,oFont8)
	oPrint:Say  (nRow2+1100,110 ,aDatSacado[3]+"                   ",oFont10) //Endereco

	oPrint:Say  (nRow2+1150,110 ,"Bairro"                                        ,oFont8)
	oPrint:Say  (nRow2+1200,110 ,aDatSacado[9]+"                   ",oFont10) //Bairro

	oPrint:Say  (nRow2+1250,110 ,"Municipio"                                        ,oFont8)
	oPrint:Say  (nRow2+1300,110 ,aDatSacado[4]+"                   ",oFont10) //Cidade

	oPrint:Say  (nRow2+1250,1510 ,"UF"                                        ,oFont8)
	oPrint:Say  (nRow2+1300,1510,aDatSacado[5]+"                   ",oFont10) //UF

	oPrint:Say  (nRow2+1250,1710 ,"CEP"                                        ,oFont8)
	oPrint:Say  (nRow2+1300,1710,aDatSacado[6]+"                   ",oFont10) //CEP


	oPrint:Say  (nRow2+1350,110 ,"Mensagem Pagador"                                        ,oFont8)
	oPrint:Say  (nRow2+1630,200 ,"Este recibo somente ter· validade com a  autenticaÁ„o mec‚nica ou"                                        ,oFont8)
	oPrint:Say  (nRow2+1680,200 ,"acompanhado do recibo de pagamento emitido pelo Banco. Recebimento"                                        ,oFont8)
	oPrint:Say  (nRow2+1730,200 ,"atravÈs do cheque n.          do banco. Esta esta quitaÁ„o sÛ ter·"                                        ,oFont8)
	oPrint:Say  (nRow2+1780,200 ,"validade apÛs o pagamento do cheque pelo banco pagador."                                        ,oFont8)
	oPrint:Say  (nRow2+1620,1350 ," AutenticaÁ„o Mec‚nica  -  Recibo do Pagador" ,oFont8)


	oPrint:Line (nRow2+1630,1200,nRow2+1630,1300 )
	oPrint:Line (nRow2+1630,1200,nRow2+1800,1200)
	oPrint:Line (nRow2+1630,2000,nRow2+1630,2100 )
	oPrint:Line (nRow2+1630,2100,nRow2+1800,2100)


/******************/
/* TERCEIRA PARTE */
/******************/

	nRow3 := 0

	For nI := 100 to 2300 step 50
		oPrint:Line(nRow3+1880, nI, nRow3+1880, nI+30)
	Next nI

	oPrint:Line (nRow3+2000,100,nRow3+2000,2300)
	oPrint:Line (nRow3+2000,500,nRow3+1920, 500)
	oPrint:Line (nRow3+2000,710,nRow3+1920, 710)

	If File(cBmp)
		oPrint:SayBitmap(nRow3+1934,100,cBmp,215,65)		// [2]Nome do Banco    *********troquei o nome SICOOB por cBmp************************** AQUI ********************
	Endif

	oPrint:Say  (nRow3+1934,575,aDadosBanco[1],oFont16n)	// 	[1]Numero do Banco    ********** adicionei ,oFont16n e alterei a margem 1934 ******************* AQUI ***********
	oPrint:Say  (nRow3+1934,0900,transform(aCB_RN_NN[2],"@R 99999.99999 99999.999999 99999.999999 9 99999999999999"),oFont15n)			//	Linha Digitavel do Codigo de Barras

	oPrint:Line (nRow3+2100,100,nRow3+2100,2300 )
	oPrint:Line (nRow3+2200,100,nRow3+2200,2300 )
	oPrint:Line (nRow3+2270,100,nRow3+2270,2300 )
	oPrint:Line (nRow3+2340,100,nRow3+2340,2300 )

	oPrint:Line (nRow3+2000,2300 ,nRow3+2850,2300 )
	oPrint:Line (nRow3+2000,100 ,nRow3+2850,100 )
	oPrint:Line (nRow3+2200,500 ,nRow3+2340,500 )
	oPrint:Line (nRow3+2270,750 ,nRow3+2340,750 )
	oPrint:Line (nRow3+2200,1000,nRow3+2340,1000)
	oPrint:Line (nRow3+2200,1300,nRow3+2270,1300)
	oPrint:Line (nRow3+2200,1480,nRow3+2340,1480)

	oPrint:Say  (nRow3+2000,110 ,"Local de Pagamento",oFont8)
	oPrint:Say  (nRow3+2015,400 ,"PAGAVEL EM QUALQUER BANCO ATE VENCIMENTO",oFont10)


	oPrint:Say  (nRow3+2000,1810,"Vencimento",oFont8)
	cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
	nCol	 	 := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2040,nCol,cString,oFont11c)

	oPrint:Say  (nRow3+2100,100 ,"Benefici·rio",oFont8)
	oPrint:Say  (nRow3+2140,100 ,aDadosEmp[1]+"        - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ  ************ recuar um pouco  *********AQUI********************

	oPrint:Say  (nRow3+2100,1810,"AgÍncia/CÛdigo Benefici·rio",oFont8)
	cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"  "+aDadosBanco[5])

	nCol 	 := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2140,nCol,cString ,oFont11c)

	oPrint:Say (nRow3+2200,100 ,"Data do Documento"                             ,oFont8)
	oPrint:Say (nRow3+2230,100, StrZero(Day(dDataBase),2) +"/"+ StrZero(Month(dDataBase),2) +"/"+ Right(Str(Year(dDataBase)),4), oFont10)

	oPrint:Say (nRow3+2200,505 ,"Nro.Documento"                                 ,oFont8)
	oPrint:Say (nRow3+2230,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela

	oPrint:Say (nRow3+2200,1005,"EspÈcie Doc."                                  ,oFont8)
	oPrint:Say (nRow3+2230,1050,aDadosTit[8]									,oFont10) //Tipo do Titulo

	oPrint:Say (nRow3+2200,1305,"Aceite"                                        ,oFont8)
	oPrint:Say (nRow3+2230,1400,"N"                                             ,oFont10)

	oPrint:Say  (nRow3+2200,1485,"Data do Processamento"                        ,oFont8)
	oPrint:Say  (nRow3+2230,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao


	oPrint:Say  (nRow3+2200,1810,"Nosso N˙mero"                                 ,oFont8)
	cString :=  Right(AllTrim(SE1->E1_NUMBCO),7)+'-'+SE1->E1_NUMDV
	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2230,nCol,cString,oFont11c)


	oPrint:Say  (nRow3+2270,100 ,"Uso do Banco"                                 ,oFont8)

	oPrint:Say  (nRow3+2270,505 ,"Carteira"                                     ,oFont8)
	oPrint:Say  (nRow3+2300,555 ,aDadosBanco[6]                                 ,oFont10)

	oPrint:Say  (nRow3+2270,755 ,"EspÈcie"                                      ,oFont8)
	oPrint:Say  (nRow3+2300,805 ,"R$"                                           ,oFont10)

	oPrint:Say  (nRow3+2270,1005,"Quantidade"                                   ,oFont8)
	oPrint:Say  (nRow3+2270,1485,"Valor"                                        ,oFont8)

	oPrint:Say  (nRow3+2270,1810,"Valor do Documento"                          	,oFont8)
	cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
	oPrint:Say  (nRow3+2300,nCol,cString,oFont11c)

	oPrint:Say  (nRow3+2340,100 ,"InstruÁıes (texto de responsabilidade do benefici·rio) ",oFont8)

	oPrint:Say  (nRow3+2440,110 ,"Vencimento mora 0,08%ad/ multa 2,00%"                       ,oFont10)
	oPrint:Say  (nRow3+2490,110 ,"N√O ACEITAMOS DEP”SITO PARA LIQUIDA«√O DO TÕTULO."   ,oFont10)
	oPrint:Say  (nRow3+2550,110 ,"QUALQUER ALTERA«√O NA DATA DE VENCIMENTO SER¡ COBRADO TAXA ADICIONAL."   ,oFont10)
	oPrint:Say  (nRow3+2600,110 ,"NEGATIVA«√O NO SERASA E PROTESTO AUTOM¡TICO AP”S O VENCIMENTO."   ,oFont10)

	oPrint:Say  (nRow3+2340,1810,"(-)Desconto/Abatimento"                       ,oFont8)
	oPrint:Say  (nRow3+2410,1810,"(-)Outras DeduÁıes"                           ,oFont8)
	oPrint:Say  (nRow3+2480,1810,"(+)Mora/Multa"                                ,oFont8)
	oPrint:Say  (nRow3+2550,1810,"(+)Outros AcrÈscimos"                         ,oFont8)
	oPrint:Say  (nRow3+2620,1810,"(=)Valor Cobrado"                             ,oFont8)


	oPrint:Say  (nRow3+2690,100 ,"Pagador"                                       ,oFont8)
	oPrint:Say  (nRow3+2700,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"           ,oFont10)

	if aDatSacado[8] = "J"
		oPrint:Say  (nRow3+2700,1750,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
	Else
		oPrint:Say  (nRow3+2700,1750,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
	EndIf

	oPrint:Say  (nRow3+2753,400 ,aDatSacado[3]+"    "+aDatSacado[9]                          ,oFont10)
	oPrint:Say  (nRow3+2806,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado


	oPrint:Say  (nRow3+2815,100 ,"Pagador/Avalista"                             ,oFont8)
	oPrint:Say  (nRow3+2855,1500,"AutenticaÁ„o Mec‚nica - Ficha de CompensaÁ„o" ,oFont8)

	oPrint:Line (nRow3+2000,1800,nRow3+2690,1800 )
	oPrint:Line (nRow3+2410,1800,nRow3+2410,2300 )
	oPrint:Line (nRow3+2480,1800,nRow3+2480,2300 )
	oPrint:Line (nRow3+2550,1800,nRow3+2550,2300 )
	oPrint:Line (nRow3+2620,1800,nRow3+2620,2300 )
	oPrint:Line (nRow3+2690,100 ,nRow3+2690,2300 )

	oPrint:Line (nRow3+2850,100,nRow3+2850,2300  )


	MSBAR3("INT25",25.3,0.75,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.0220,1.50,Nil,Nil,"A",.F.)//datasupri



	oPrint:EndPage() // Finaliza a p√°gina
Return Nil



/*
+-----------+----------+-------+--------------------+------+-------------+
| Programa  |BOLSICOOB   |Autor  |PSS PARTNERS      | Data |  23/10/2014 |
+-----------+----------+-------+--------------------+------+-------------+
| Desc.     |Obten√ß√£o da linha digitavel/codigo de barras                |
|           |                                                            |
+-----------+------------------------------------------------------------+
*/
Static Function fLinhaDig(cCodBanco, ; // Codigo do Banco (756)
	cCodMoeda, ; // Codigo da Moeda (9)
	cCarteira, ; // Codigo da Carteira
	cAgencia , ; // Codigo da Agencia
	cConta   , ; // Codigo da Conta
	cDvConta , ; // Digito verificador da Conta
	nValor   , ; // Valor do Titulo
	dVencto  , ; // Data de vencimento do titulo
	cNroDoc   )  // Numero do Documento Ref ao Contas a Receber

	Local cValorFinal := StrZero(int(nValor*100),10)
	Local cFator      := StrZero( (dVencto - CtoD("03/07/2000")) + 1000, 4 )

//em observa√ß√£o - acredito que sejam desnecess√°rios
//Local cCodBar   	:= Replicate("0",43)
//Local cCampo1   	:= Replicate("0",05)+"."+Replicate("0",05)
//Local cCampo2   	:= Replicate("0",05)+"."+Replicate("0",06)
//Local cCampo3   	:= Replicate("0",05)+"."+Replicate("0",06)
//Local cCampo4   	:= Replicate("0",01)
//	Local cCampo5   	:= Replicate("0",14)

	Local cTemp     	:= ""
	Local cDV			:= "" // Digito verificador dos campos
	Local cLinDig		:= ""
	Local _cNumDoBco  	:= right(rtrim(SE1->E1_NUMBCO), 7) // Nosso numero
	Local _cParcela
	Local _cCodCliente	:= padl(ALLTRIM(SEE->EE_CODEMP),10,'0') //acrescentado por augusto (c√≥digo do cliente)
	Local _cCodCAR 	:= Alltrim(SEE->EE_CODCART)
	Local _cDV_CB		:= ""
/*
	if .not. empty ( SE1->E1_PARCELA)
		_cParcela := StrZero( Asc( Upper( ALLTRIM( SE1->E1_PARCELA ) ) ) - 64, 3, 0 )
	else
		_cParcela := '001'
	endif
	*/
	if .not. empty(SE1->E1_PARCELA)
    		_cParcela := StrZero(Val(ALLTRIM(SE1->E1_PARCELA)), 3, 0)
		else
    		_cParcela := '001'
		endif

//	-------------------------
//	Definicao do NOSSO NUMERO
//	-------------------------
	If At("-",cConta) > 0
		cDig   := Right(AllTrim(cConta),1)
		cConta := AllTrim(Str(Val(Left(cConta,At('-',cConta)-1) + cDig)))
	Else
		cConta := AllTrim(Str(Val(cConta)))
	Endif

	cTemp			:= Alltrim(cAgencia) + _cCodCliente + _cNumDoBco //base num√©rica para calcular o digito verificador do nosso n√∫mero
	cConstRep			:= "319731973197319731973" //constante fornecida pelo SICOOB "3197"
	nSoma_Resultado 	:= 0

	FOR _nI := 1 TO 21  STEP 1

		_nD_NN :=  VAL( SUBSTR( cTemp, _nI, 1 ) ) // PEGA UM DIGITO DO NOSSO NUMERO
		_nD_CR :=  VAL( SUBSTR( cConstRep   , _nI, 1 ) ) // PEGA UM DIGITO DA CONSTANTE REPETIDA

		nSoma_Resultado += _nD_NN * _nD_CR

	NEXT

	_nRestoOperacao	:= Mod( nSoma_Resultado, 11 )

	IF _nRestoOperacao == 0 .OR. _nRestoOperacao  == 1
		_cDV_NumBco := '0'

	else

		_cDV_NumBco  := STR( 11 - _nRestoOperacao, 1 ) //digito verificador do n√∫mero do banco

	ENDIF


	cNossoNum	:= _cNumDoBco + _cDV_NumBco

//GRAVA O D√ùGITO VERIFICAR DO NOSSO N√öMERO
	RECLOCK("SE1",.F.)
	SE1->E1_NUMDV := _cDV_NumBco
	SE1->(MSUNLOCK() )


//	-----------------------------
//	Definicao do CODIGO DE BARRAS
//	-----------------------------

//Campo Obrigat√≥rio: determinado pelo BACEN
	cCodBar := Alltrim(cCodBanco)        // 01 a 03
	cCodBar += Alltrim(cCodMoeda)        // 04 a 04
	cCodBar += "0"					// 05 a 05 - DV (ser√° preenchido ap√≥s o c√°lculo, conforme fun√ß√£o delphi
	cCodBar += cFator		              // 06 a 09
	cCodBar += Alltrim(cValorFinal)      // 10 a 19

//Campo Livre, conforme defini√ß√£o de cada banco
	cCodBar += cCarteira             	// 20 a 20
	cCodBar += cAgencia		   		// 21 a 24
	cCodBar += _cCodCAR				// 25 A 26
	cCodBar += _cCodCliente			// 27 a 33
	cCodBar += _cNumDoBco + _cDV_NumBco	// 34 a 41
	cCodBar += _cParcela			     // 32 a 35

	cCodBar := LEFT( cCodBar, 4 ) + (_cDV_CB := Modulo11( cCodBar )) + SUBSTR( cCodBar, 6 )


/*
-----------------------------------------------------
Definicao da LINHA DIGITAVEL (Representacao Numerica)
-----------------------------------------------------

Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
AAABC.CCDDX		DDDDD.DDFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV

CAMPO 1:
AAA = Codigo do banco na Camara de Compensacao                                            Substr(Right(AllTrim(SE1->E1_NUMBCO
B = Codigo da moeda, sempre 9
CCC = Codigo da Carteira de Cobranca
DD = Dois primeiros digitos no nosso numero
X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
*/

	cTemp   := cCodBanco + cCodMoeda + cCarteira + Right(AllTrim(SE1->E1_AGEDEP), 4)
	cDV		:= Alltrim( Str( Modulo10(cTemp) ) )

	cCampo1 := SubStr( cTemp, 1, 5 ) + Alltrim( SubStr( cTemp, 6 ) ) + cDV

/*

CAMPO 2:
DDDDDD = Restante do Nosso Numero
E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
FFF = Tres primeiros numeros que identificam a agencia
Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
*/

	cTemp	:= PADL(alltrim(_cCODCAR),2,"0") + RIGHT(_cCodCliente,7) + LEFT(_cNumDoBco,1)
	cDV		:= Alltrim( Str( Modulo10(cTemp) ) )

	cCampo2 := Substr( cTemp, 1, 5 ) + Substr( cTemp, 6 )  + cDV

/*
CAMPO 3:
F = Restante do numero que identifica a agencia
GGGGGG = Numero da Conta + DAC da mesma
HHH = Zeros (Nao utilizado)
Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
*/

	cTemp  	:= Substr( _cNumDoBco, 2 ) + _cDV_NumBco + _cParcela
	cDV		:= Alltrim( Str (Modulo10(cTemp) ) )

	cCampo3	:= Substr( cTemp, 1, 5 ) +  Substr(cTemp,6)  + cDV

/*
CAMPO 4:
K = DAC do Codigo de Barras
*/

	cCampo4 :=  _cDV_CB

/*
CAMPO 5:
UUUU = Fator de Vencimento
VVVVVVVVVV = Valor do Titulo
*/
	cCampo5 := cFator + cValorFinal

	cLinDig := cCampo1 + cCampo2 + cCampo3 + cCampo4 + cCampo5

	cTemp := substr(cLinDig,01,03) //codigo do banco
	cTemp += substr(cLinDig,04,01) //moeda
	cTemp += substr(cLinDig,33,01) //digito verificador
	cTemp += substr(cLinDig,34,04) //fator de vencimento
	cTemp += substr(cLinDig,38,10) //valor do documento
	cTemp += substr(cLinDig,05,01) //carteira
	cTemp += substr(cLinDig,06,04) //agencia
	cTemp += substr(cLinDig,11,02) //modalidade de cobran√ßa
	cTemp += substr(cLinDig,13,07) //c√≥digo do cliente
	cTemp += substr(cLinDig,20,01) //nosso n√∫mero inicio
	cTemp += substr(cLinDig,22,07) //nosso n√∫mero fim
	cTemp += substr(cLinDig,29,03) //parcela

	cLinDig := cCampo1 + cCampo2 + cCampo3 + Modulo11(cTemp) + cCampo5


Return {cCodBar, cLinDig, cNossoNum}


//+-----------+----------+-------+--------------------+------+-------------+
//| Programa  |AJUSTASX1 |Autor  |PSS PARTNERS        | Data | 23/10/2014  |
//+-----------+----------+-------+--------------------+------+-------------+
//| Desc.     |Ajuste das perguntas no SX1                                 |
//+-----------+------------------------------------------------------------+

Static Function AjustaSX1(cPerg, aPergs)
	Local _sAlias	:= Alias()
	Local aCposSX1	:= {}
	Local nX 		:= 0
	Local lAltera	:= .F.
	Local nCondicao
	Local cKey		:= ""
	Local nJ			:= 0

	aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
		"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
		"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
		"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
		"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
		"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
		"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
		"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }

	dbSelectArea("SX1")
	dbSetOrder(1)
	For nX:=1 to Len(aPergs)
		lAltera := .F.
		If MsSeek(cPerg+Right(aPergs[nX][11], 2))
			If (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .And.;
					Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
				aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
				lAltera := .T.
			Endif
		Endif

		If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]
			lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
		Endif

		If ! Found() .Or. lAltera
			RecLock("SX1",If(lAltera, .F., .T.))
			Replace X1_GRUPO with cPerg
			Replace X1_ORDEM with Right(aPergs[nX][11], 2)
			For nj:=1 to Len(aCposSX1)
				If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
						FieldPos(AllTrim(aCposSX1[nJ])) > 0
					Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
				Endif
			Next nj
			MsUnlock()
			cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."

			If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
				aHelpSpa := aPergs[nx][Len(aPergs[nx])]
			Else
				aHelpSpa := {}
			Endif

			If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
				aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
			Else
				aHelpEng := {}
			Endif

			If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
				aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
			Else
				aHelpPor := {}
			Endif

			PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
		Endif
	Next
Return

/*
+-----------+----------+-------+--------------------+------+-------------+
| Programa  |MODULO10  |Autor  |PSS PARTNERS        | Data |  23/10/2014 |
+-----------+----------+-------+--------------------+------+-------------+
| Desc.     |C√°lculo do Modulo 10 para obten√ß√£o do DV dos campos do      |
|           |Codigo de Barras                                            |
+-----------+------------------------------------------------------------+
*/
Static Function Modulo10(cData)

	LOCAL L,D,P := 0
	LOCAL B     := .F.
	L := Len(cData)
	B := .T.
	D := 0
	While L > 0
		P := Val(SubStr(cData, L, 1))
		If (B)
			P := P * 2
			If P > 9
				P := P - 9
			End
		End
		D := D + P
		L := L - 1
		B := !B
	End
	D := 10 - (Mod(D,10))
	If D = 10
		D := 0
	End
Return(D)

//+-----------+----------+-------+--------------------+------+-------------+
//| Programa  |MODULO11  |Autor  |PSS PARTNERS        | Data | 23/10/2014  |
//+-----------+----------+-------+--------------------+------+-------------+
//| Desc.     |Calculo do Modulo 11 para obtencao do DV do Codigo de Barras|
//+-----------+------------------------------------------------------------+
Static Function Modulo11( _cCodBarra )

	LOCAL _cDvMod11 	:= ''
	LOCAL cIndice 	:= "43290876543298765432987654329876543298765432"
	LOCAL nContador	:= 0
	LOCAL nSoma		:= 0

	FOR nContador := 1 TO 44  STEP 1
		nSoma +=  VAL( SUBSTR( _cCodBarra, nContador, 1 ) ) *  VAL( SUBSTR( cIndice , nContador, 1 ) ) // SOMAT√ìRIA PARA COMPOR A BASE DE C√ùLCULO PARA O D√ùGITO VERIFICADOR
	NEXT

	_cDvMod11 := ALLTRIM( STR( 11 - MOD( nSoma, 11 ) ) )

	IF _cDvMod11 <= '1' .OR. _cDvMod11 > '9'
		_cDvMod11 := '1'
	ENDIF

Return _cDvMod11
