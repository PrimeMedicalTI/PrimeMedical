#include "topconn.ch"
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "protheus.ch"
#include "parmtype.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFFATR003บ Autor ณ Beatriz Azevedo (TBA087)บ Data ณ Jul/2021 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Imprimir Etiqueta T้rmica para produtos importados         บฑฑ
ฑฑบCliente   ณ Prime Medical                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Faturamento                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

************************
User Function FFATR003()
************************
Local l_Ret			:=.F.
Local l_Perg		:=.T.

Private lEnd		:= .F.
Private wnrel  		:= "FFATR003"
Private cDesc1	  	:= "Emissao de etiquetas de produtos importados"
Private cDesc2	  	:= " "
Private cDesc3	  	:= " "
Private cString		:= "SB1"
Private tamanho   	:= "G"
Private limite 		:= 220
Private titulo		:= "Etiqueta Produtos Importados"
Private aReturn   	:= {"Zebrado", 1,"Administracao", 2, 2, 2, "",0 }
Private nomeprog	:= "FFATR003"
Private nLastKey  	:= 0
Private aOrd		:= {"Codigo", "Nome","",""}
Private c_Perg 		:= "FFATR003"
Private c_Ref		:=""
Private c_CANVI		:=""
Private c_Codbar	:=""
Private c_Descr		:=""
Private c_NomFab	:=""
Private c_EndFab	:=""
Private c_BaiFab	:=""
Private c_MunFab	:=""
Private c_EstFab	:=""
Private c_CEPFab	:=""
Private c_PaiFab	:=""
Private c_NomReg	:=""
Private c_CGCReg	:=""
Private c_Resol 	:=""

Default n_Opc:="1"

f_CriaPerg(c_Perg)

Do 	While l_Perg=.T. .and. l_Ret=.F.
	l_Perg:=Pergunte(c_Perg,.T.)
	If 	l_Perg=.T.
		l_Ret:=f_ValidPar()
	Else 
		l_Ret=.F.
	Endif
Enddo

If 	l_Ret=.T.
	wnrel:=SetPrint(cString,wnrel,c_Perg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)

	If 	nLastKey = 27
		Set Filter to
	Else
		SetDefault(aReturn,cString)
		l_Ret:=f_Validpar()
		If	l_Ret=.T.
			RptStatus({|| FFATR03A()},Titulo)
		Endif
	Endif	
Endif 

Return

**************************
Static Function FFATR03A()
**************************
Local n_I		:=1
Local n_Lin		:=0
Local a_NomFab	:={}
Local a_EndFab	:={}
Local a_NomReg	:={}
Local c_RespTec :=SuperGETMV("FS_RESTEC",.F.,"GABRIELA CAMPOS DO CARMO")
Local c_CRFTec	:=SuperGETMV("FS_CRFTEC",.F.,"CRF-BA 13260")
Local o_Prime   := clsPrime():New()

a_NomFab:=o_Prime:mtdSeparaPalavra(c_NomFab, 42, 2)
a_EndFab:=o_Prime:mtdSeparaPalavra(c_EndFab, 42, 3)
a_NomReg:=o_Prime:mtdSeparaPalavra(c_NomReg, 42, 2)

SETPRC(0,0)

For n_I = 1 To mv_par04
//	@ 0,00 PSay "^XA"
//	@ 0,00 PSay "CT~~CD,~CC^~CT~"
//	@ 0,00 PSay "^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ"
	@ 0,00 PSay "^XA"
	@ 0,00 PSay "^MMT"
	@ 0,00 PSay "^PW799"
	@ 0,00 PSay "^LL799"
	@ 0,00 PSay "^LS0"
	@ 0,00 PSay "^FT14,79^A0N,31,31^FH\^FD"+Alltrim(c_Descr)+"^FS"
	@ 0,00 PSay "^FT14,149^A0N,28,28^FH\^FDCODIGO^FS"
	@ 0,00 PSay "^FT292,149^A0N,28,28^FH\^FDLOTE/S\90RIE^FS"
	@ 0,00 PSay "^FT659,149^A0N,28,28^FH\^FDVALIDADE^FS"
	@ 0,00 PSay "^FO18,99^GB759,0,5^FS"
	@ 0,00 PSay "^FT14,182^A0N,23,24^FH\^FD"+mv_par01+"^FS"
	@ 0,00 PSay "^FT292,182^A0N,23,24^FH\^FD"+mv_par02+"^FS"
	@ 0,00 PSay "^FT650,182^A0N,23,24^FH\^FD"+DToC(mv_par03)+"^FS"
	@ 0,00 PSay "^FO14,188^GB397,595,5^FS"
	@ 0,00 PSay "^FO415,187^GB373,595,5^FS"
	@ 0,00 PSay "^BY2,2,63^FT40,756^BEN,,Y,N"
	@ 0,00 PSay "^FD"+Alltrim(c_Codbar)+"^FS"
	@ 0,00 PSay "^FT244,720^A0N,20,19^FH\^FDReg.Anvisa No.^FS"
	@ 0,00 PSay "^FT244,751^A0N,20,19^FH\^FD"+c_CANVI+"^FS"
	@ 0,00 PSay "^FT422,224^A0N,25,24^FH\^FDFabricado por:^FS"
	n_Lin:=229
	For n_I:=1 To Len(a_NomFab)
		n_Lin+=20
		@ 0,00 PSay "^FT422,"+Str(n_Lin,3)+"^A0N,17,16^FH\^FD"+a_NomFab[n_I]+"^FS"
	Next
	For n_I:=1 To Len(a_EndFab)
		n_Lin+=20
		@ 0,00 PSay "^FT422,"+Str(n_Lin,3)+"^A0N,17,16^FH\^FD"+a_EndFab[n_I]+"^FS"
	Next
	n_Lin+=20
	@ 0,00 PSay "^FT422,"+Str(n_Lin,3)+"^A0N,17,16^FH\^FD"+c_BaiFab+"^FS"
	n_Lin+=20
	@ 0,00 PSay "^FT422,"+Str(n_Lin,3)+"^A0N,17,16^FH\^FD"+c_MunFab+"^FS"
	n_Lin+=20
	@ 0,00 PSay "^FT422,"+Str(n_Lin,3)+"^A0N,17,16^FH\^FD"+c_EstFab+"^FS"
	n_Lin+=20
	@ 0,00 PSay "^FT422,"+Str(n_Lin,3)+"^A0N,17,16^FH\^FD"+c_PaiFab+"^FS"

	n_Lin:=445
	@ 0,00 PSay "^FT422,"+Str(n_Lin,3)+"^A0N,25,24^FH\^FDRegistrado por^FS"
	n_Lin+=5
	For n_I:=1 To Len(a_NomReg)
		n_Lin+=20
		@ 0,00 PSay "^FT422,"+Str(n_Lin,3)+"^A0N,17,16^FH\^FD"+a_NomReg[n_I]+"^FS"
	Next
	n_Lin+=20
	@ 0,00 PSay "^FT422,"+Str(n_Lin,3)+"^A0N,17,16^FH\^FDCNPJ "+Transform(c_CGCReg,"@R 99.999.999/9999-99")+"^FS"
	
	@ 0,00 PSay "^FT422,574^A0N,25,24^FH\^FDImportado por^FS"
	@ 0,00 PSay "^FT422,599^A0N,17,16^FH\^FDPRIME MEDICAL COMERCIO DE^FS"
	@ 0,00 PSay "^FT422,619^A0N,17,16^FH\^FDMATERIAL MEDICO ERIELI^FS"
	@ 0,00 PSay "^FT422,639^A0N,17,16^FH\^FDCNPJ 09.342.945/0001-00^FS"

	@ 0,00 PSay "^FT422,720^A0N,25,24^FH\^FDResponsavel Tecnico^FS"
	@ 0,00 PSay "^FT422,741^A0N,17,16^FH\^FD"+c_RespTec+"^FS"
	@ 0,00 PSay "^FT422,761^A0N,17,16^FH\^FD"+c_CRFTec+"^FS"
	@ 0,00 PSay "^PQ1,0,1,Y^"
	@ 0,00 PSay "^XZ"	
Next

If aReturn[5] == 1    // Se Saida para disco, ativa SPOOL
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return

****************************
Static Function f_ValidPar()
****************************
Local c_Qry:=""
Local l_Ret:=.T.

If 	mv_par04<=0
	ApMsgAlert("Quantidade de etiquetas invalida"+CHR(14)+CHR(10)+"Verifique o parametro 04 !!", "Etiqueta nao sera impressa")
	l_Ret:=.F.
Else
	//Validar Produto 
	c_Qry:="SELECT B1_FSREF, B1_FSCANVI, B1_CODBAR, B1_DESC, B1_FSRESOL, B1_FSFABR, B1_FSLJFAB, B1_FSREGP, "
	c_Qry+="	B1_FSLJREG, FAB.NOMFAB, FAB.ENDFAB, FAB.BAIFAB, FAB.MUNFAB, FAB.ESTFAB, FAB.CEPFAB, FAB.PAIFAB, "
	c_Qry+="	REG.NOMREG, REG.CGCREG "
	c_Qry+="FROM "+RetSqlName("SB1")+" SB1 "
	c_Qry+="	OUTER APPLY "
	c_Qry+="		(SELECT A2_NOME NOMFAB, A2_END ENDFAB, A2_BAIRRO BAIFAB, A2_MUN MUNFAB, A2_EST ESTFAB, "
	c_Qry+="			A2_CEP CEPFAB, A2_PAIS PAIFAB "
	c_Qry+="			FROM "+RetSqlName("SA2")+" " 
	c_Qry+="			WHERE D_E_L_E_T_<>'*' "
	c_Qry+="				AND A2_COD=SB1.B1_FSFABR "
	c_Qry+="				AND A2_LOJA=SB1.B1_FSLJFAB "
	c_Qry+="		) FAB "
	c_Qry+="	OUTER APPLY "
	c_Qry+="		(SELECT A2_NOME NOMREG, A2_CGC CGCREG "
	c_Qry+="			FROM "+RetSqlName("SA2")+" "
	c_Qry+="			WHERE D_E_L_E_T_<>'*' "
	c_Qry+="				AND A2_COD=SB1.B1_FSREGP "
	c_Qry+="				AND A2_LOJA=SB1.B1_FSLJREG "
	c_Qry+="		) REG "
		c_Qry+="WHERE D_E_L_E_T_<>'*' "
			c_Qry+="AND B1_COD='"+mv_par01+"' "
			c_Qry+="AND B1_FILIAL='"+xFilial("SB1")+"' "

	TCQUERY c_Qry NEW ALIAS "q_SB1"

	If	q_SB1->(Eof())=.T.
		ApMsgAlert("Produto nใo cadastrado"+CHR(13)+CHR(10)+"Verifique o parametro 01 !!", "Etiqueta nao sera impressa")
		l_Ret:=.F.
	Else
		c_Ref	:=q_SB1->B1_FSREF
		c_CANVI	:=q_SB1->B1_FSCANVI
		c_Codbar:=q_SB1->B1_CODBAR
		c_Descr :=q_SB1->B1_DESC
		c_NomFab:=Alltrim(q_SB1->NOMFAB)
		c_EndFab:=Alltrim(q_SB1->ENDFAB)
		c_BaiFab:=q_SB1->BAIFAB
		c_MunFab:=q_SB1->MUNFAB
		c_EstFab:=q_SB1->ESTFAB
		c_CEPFab:=q_SB1->CEPFAB
		c_PaiFab:=Posicione("SYA",1,xFilial("SYA")+q_SB1->PAIFAB,"YA_DESCR")
		c_NomReg:=Alltrim(q_SB1->NOMREG)
		c_CGCReg:=If(Empty(q_SB1->CGCREG)=.T., "00000000000000",q_SB1->CGCREG)
		c_Resol :=q_SB1->B1_FSRESOL
		l_Ret	:=.T.
	Endif

	q_SB1->(dbCloseArea())  

	If 	l_Ret=.T.
		//Validar Produto X Lote
		c_Qry:="SELECT COUNT(*) n_Cont "
		c_Qry+="FROM "+RetSqlName("SB8")+" SB8 "
			c_Qry+="WHERE D_E_L_E_T_<>'*' "
				c_Qry+="AND B8_PRODUTO='"+mv_par01+"' "
				c_Qry+="AND B8_FILIAL='"+xFilial("SB8")+"' "
				c_Qry+="AND B8_LOTECTL='"+mv_par02+"' "
				c_Qry+="AND B8_DTVALID='"+DtoS(mv_par03)+"' "

		TCQUERY c_Qry NEW ALIAS "q_SB8"

		If	q_SB8->n_Cont=0 .and. Empty(mv_par02)=.F.
			ApMsgAlert("Lote nใo pertence ao produto informado"+CHR(13)+CHR(10)+"Verifique o parametro 02 !!", "Etiqueta nao sera impressa")
			l_Ret:=.F.
		Endif

		q_SB8->(dbCloseArea())  

		If 	l_Ret=.T.
			If 	Empty(mv_par02)=.T.
				If	ApMsgYesNo("Continua impressao da etqueta?","Lote nao informado")=.F.
					l_Ret:=.F.
				Else
					If 	Empty(mv_par03)=.T.
						If	ApMsgYesNo("Continua impressao da etqueta?","Lote sem validade")=.F.
							l_Ret:=.F.
						Endif
					Endif 
				Endif	
			Endif
		Endif	
	Endif
Endif 

Return(l_Ret)

/*
********************************************************
Static Function f_SepPalav(c_String, n_Carac, n_TLInhas)
********************************************************
Local n_Cont	:=1
Local n_I		:=1
Local c_Aux		:=""
Local a_Palavras:={}
Local a_Linhas	:={}

If 	Len(c_String)>(n_Carac*n_TLinhas) 
	c_Aux:=StrTran(c_String," ", "|")
	a_Palavras:=Strtokarr (c_Aux, "|")
	c_Aux:=""

	Do	While n_Cont<=n_TLinhas .and. n_I<=Len(a_Palavras)
		If 	Len(c_Aux)+Len(a_Palavras[n_I])+1>n_Carac
			AADD(a_Linhas,c_Aux)
			c_Aux:=""
			n_Cont++
		Else
			c_Aux+=a_Palavras[n_I]+" "
		Endif
		n_I++
	Enddo
Else
	AADD(a_Linhas,c_String)
Endif

Return(a_Linhas)
*/

**********************************
Static Function f_CriaPerg(c_Perg)
**********************************
Local a_PAR01	:= {}
Local a_PAR02	:= {}
Local a_PAR03	:= {}

Private o_perg   :=	clsComponentes():new()

c_Perg := PADR(c_Perg,10)

Aadd(a_PAR01, "")
Aadd(a_PAR02, "")
Aadd(a_PAR03, "")

//mtdPutSX1( 	 X1_GRUPO	, X1_ORDEM	, X1_PERGUNT		, X1_PERSPA	, X1_PERENG	, X1_VARIAVL, X1_TIPO	, X1_TAMANHO			, X1_DECIMAL, X1_PRESEL, X1_GSC	, X1_VALID	, X1_VAR01	, X1_DEF01	, X1_DEFSPA1		, X1_DEFENG1		, X1_CNT01	, X1_VAR02			, X1_DEF02			, X1_DEFSPA2		, X1_DEFENG2, X1_CNT02			, X1_VAR03			, X1_DEF03			, X1_DEFSPA3, X1_DEFENG3		, X1_CNT03			, X1_VAR04		, X1_DEF04	, X1_DEFSPA4, X1_DEFENG4, X1_CNT04	, X1_VAR05	, X1_DEF05	, X1_DEFSPA5, X1_DEFENG5, X1_CNT05	, X1_F3	 , X1_PYME	, X1_GRPSXG	, X1_HELP	, X1_PICTURE, X1_IDFIL)
//				 X1_GRUPO	, X1_ORDEM	, X1_PERGUNT		, X1_PERSPA	, X1_PERENG	, X1_VARIAVL, X1_TIPO	, X1_TAMANHO			, X1_DECIMAL, X1_PRESEL, X1_GSC	, X1_VALID	, X1_VAR01	, X1_DEF01	, X1_DEFSPA1		, X1_DEFENG1		, X1_CNT01	, X1_VAR02			, X1_DEF02			, X1_DEFSPA2		, X1_DEFENG2, X1_CNT02			, X1_VAR03			, X1_DEF03			, X1_DEFSPA3, X1_DEFENG3		, X1_CNT03			, X1_VAR04		, X1_DEF04	, X1_DEFSPA4, X1_DEFENG4, X1_CNT04	, X1_VAR05	, X1_DEF05	, X1_DEFSPA5, X1_DEFENG5, X1_CNT05	, X1_F3	 , X1_PYME	, X1_GRPSXG	, X1_HELP	, X1_PICTURE, X1_IDFIL)
o_perg:mtdPutSX1(c_Perg		,"01"		,"Produto"			,""			,""			,"mv_ch1"	,"C"		,TamSX3("B1_COD")[1]	,0			,0			,"G"	,""			,"mv_par01"	,""			,""					,""					,""			,""					,""					,""					,""			,""					,""					,""					,""			,""					,""					,""				,""			,""			,""			,""			,""			,""			,""			,""			,""			,"FSSB11"	 ,""		,""			,""			,""			,""	)
o_perg:mtdPutSX1(c_Perg		,"02"		,"Lote"				,""			,""			,"mv_ch2"	,"C"		,TAMSX3("B8_LOTECTL")[1],0			,0			,"G"	,""			,"mv_par02"	,""			,""					,""					,""			,""					,""					,""					,""			,""					,""					,""					,""			,""					,""					,""				,""			,""			,""			,""			,""			,""			,""			,""			,""			,"FSSB81",""		,""			,""			,""			,""	)
o_perg:mtdPutSX1(c_Perg		,"03"		,"Validade	"		,""			,""			,"mv_ch3"	,"D"		,TAMSX3("B8_DTVALID")[1],0			,0			,"S"	,""			,"mv_par03"	,""			,""					,""					,""			,""					,""					,""					,""			,""					,""					,""					,""			,""					,""					,""				,""			,""			,""			,""			,""			,""			,""			,""			,""			,""		 ,"" 		,""			,""			,""			,""	)
o_perg:mtdPutSX1(c_Perg		,"04"		,"Quantidade"		,""			,""			,"mv_ch4"	,"N"		,TAMSX3("F2_VOLUME1")[1],0			,0			,"G"	,""			,"mv_par04"	,""			,""					,""					,""			,""					,""					,""					,""			,""					,""					,""					,""			,""					,""					,""				,""			,""			,""			,""			,""			,""			,""			,""			,""			,""		 ,"" 		,""			,""			,""			,""	)

Return
