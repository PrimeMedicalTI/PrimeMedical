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
ฑฑบPrograma  ณFFATR002บ Autor ณ Beatriz Azevedo (TBA087)บ Data ณ Jul/2021 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Imprimir Etiqueta T้rmica para produtos nacionais           บฑฑ
ฑฑบCliente   ณ Prime Medical                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Faturamento                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

************************
User Function FFATR002()
************************
Local l_Ret			:=.F.
Local l_Perg		:=.T.

Private lEnd		:= .F.
Private wnrel  		:= "FFATR002"
Private cDesc1	  	:= "Emissao de etiquetas de produtos nacionais"
Private cDesc2	  	:= " "
Private cDesc3	  	:= " "
Private cString		:= "SB1"
Private tamanho   	:= "G"
Private limite 		:= 220
Private titulo		:= "Etiqueta Produtos Nacionais"
Private aReturn   	:= {"Zebrado", 1,"Administracao", 2, 2, 2, "",0 }
Private nomeprog	:= "FFATR002"
Private nLastKey  	:= 0
Private aOrd		:= {"Codigo", "Nome","",""}
Private c_Perg 		:= "FFATR002"
Private c_Ref		:=""
Private c_CANVI		:=""
Private c_Codbar	:=""
Private c_Desc		:=""

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
			RptStatus({|| FFATR02A()},Titulo)
		Endif
	Endif	
Endif 

Return

**************************
Static Function FFATR02A()
**************************
Local n_I	  	:=0
Local a_Desc	:={}
Local o_Prime   := clsPrime():New()
Local d_Data 	:=Date()
Local c_Hora 	:=Substr(Time(),1,5)

SETPRC(0,0)

a_Desc:=o_Prime:mtdSeparaPalavra(c_Desc, 50, 2)
If 	Len(a_Desc)<2
	AADD(a_Desc," ")
Endif

For n_I = 1 To mv_par04
	@ 0,00 PSay "^XA"
	//@ 0,00 PSay "CT~~CD,~CC^~CT~"
	//@ 0,00 PSay "^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ"
	//@ 0,00 PSay "^XA"
	@ 0,00 PSay "^MMT"
	@ 0,00 PSay "^PW559"
	@ 0,00 PSay "^LL0320"
	@ 0,00 PSay "^LS0"
//	@ 0,00 PSay "^FO0,0^GFA,02688,02688,00028,:Z64:"
//	@ 0,00 PSay "eJztlb9rE2EYx5/LEZSKJAd3W4/GulXQVdvh7uCytXAHly03OfoXuOgLLoEO/gcSmqVeoEOnJkLMUCdBMyh0aCC0IKVK6xiJvOfzvO+bS5pUKOIgxW/y/ri8+fR7z49cAf7r2ipJkm22gDODbUjqAAvbsCIuAeJ+vw82Tl2oQtwFsHvqEiBF1R2cvgOHdADgDIEuiaugXAunACLAiQZdguIGSzgNiRsCjTFX9f1K1/b9ckB+h3gDB2ArjgMUBg4DXXBcciqGCCDvWgCa8ItAIz91NuaAOM5BJ47JsypyXRu5Hm6rMWifMb4Jd4M4TXDPmT76jV9kQT6c8Vsacw4rfL3o59qCQz/bve0Fmd+z6fg4/olj5HKZnzXxQ2uP8hlBlk9H5ZMXTpwXlE8uzqh+XSqYiC/fizWq32HGZfXj+jDVJxzVTxTMJT8twHfmx7E3YClJsUGI45w4dnMcH/aICKkqKqgdTOcTe4Q9qNOWKq9fyCdGiLmhLXWMdiGfxN0aSu6t4Cb5JD/tk/Sze1pv1o9W4pzBvB9UpJ/lzvph/QTKodAlrlarsYkf2K7wy1NBbJEmUT/hVxgITme67OvulF9e1A9EIS3Fje9T1h33l3BaNM8t0xn1R0m8xGYZBddEdxk+inBdBYoMcnVcmYwYPBxFHJpacWiu4rbwS9SNJSY5+qyuVkqhOcWprdACk+sdyLjcmHfV9w3lVZy6T2oMYlckJ7yIY38c+b+l5FLJ3wM9X+YluTTTSLzFxEslOosM0yoGUVj2gsgLPdMrgqceL8CbOzvtdufHh/dnZx/Pmq9O9k6b6bBWo7M4NH3DWgz98vp6vGEvbtihHQeSezra/fKm0WlsPd65v/nyUfJkb+1heiQfoJXQjAzLzBfDil+uWJpnhJb4EaF+jtrfNpud18kI/c5byXlr1EpPRHhQDc2yZyy+C8J9v7xvwIYVGuKfH93navveabvTbB8fLR8fNXbPk7VGWi9Jv4msbAezeZmIy/Agjvtzr0PFrVxWhtxVq1ib1RW50qyuavg39QuLKOVt:1F2D"
	@ 0,00 PSay "^FO0,10^GFA,01280,01280,00020,:Z64:"
	@ 0,00 PSay "eJzFk79u2lAYxY8vpkYeEGulSCAm5IFnYOABMmBlQpY6RR2qdkBkwPGVJ8QQqQ9QCWWy/BS3UqW8QBBLLVAm5AFRKVEWHPdcIITSP1vbg8/lGh/9OJ8xwP9R0XU72ugUOzA6cF0XYrlMtbF4teAJ3i2X0srzvEDjwlrDWCPgVsRxrI1IRDwBt9K67XjaGFhP4OFrnoIt5rBxLlLYS5zzey2FaoEmb4bqV1zwMyGZo8kbSTtGY5fTJm+mqpcY6JxCmbwy+13JZvOYd6P8k2NeOG44iEfMcQZt8m5Wg0vOwVyaptrsJ+cLB29TgLOutcn7/G11Ar/LXFSiY5Ano7Gz62fSAchTwWrfD2JeBvvJ5nzfDwVVVeSpQO370VzJc6SDaJezlLXSvGrrkIeF7lfGIY+XybPAflkmtzw4mge+Ofr3UNt7o3mAnjd/ztlovOT+1fN2LOs90IJxqtciN4AJUQO2hTYrSwoUT/XWqOjVhM5tL++PXc7ckPDMM1u76N+W4R6JDfR/4weNOe/j1J96/Z6feL3Em5zlX9oQo3B4bb+p3ZWc8TCORinHKSSTycfE7T12u8nrD5+SvFKBGEoZjTCul0rxkIr1/Usmtw+Je9bv+lnPz5K83YIIRT0sy7Beb9auo6sw1blpEMy8SZL1vd5Dlkwz4+d+m+cvD/h60X37D0NXDvX7mNk+1K8z3wEr3BfQ:01D4"
	If 	Empty(c_Codbar)=.F.
//		@ 0,00 PSay "^BY2,2,63^FT286,80^BEN,,Y,N"
		@ 0,00 PSay "^FO160,07^BY2,1,77^BCN, 77,Y,N,N,N"
		@ 0,00 PSay "^FD"+Alltrim(c_Codbar)+"^FS"
	Endif
//	@ 0,00 PSay "^FO10,130^A0N,26^FDWWW.PRIMEMEDICAL.COM.BR^FS"

	@ 0,00 PSay "^FO10,120^A0N,20^FD"+a_Desc[1]+"^FS"
	@ 0,00 PSay "^FO10,150^A0N,20^FD"+a_Desc[2]+"^FS"
	@ 0,00 PSay "^FO10,190^A0N,20^FDANVISA: "+c_CANVI+"^FS"
	@ 0,00 PSay "^FO10,220^A0N,20^FDREF. "+c_Ref+"^FS"
	If 	Empty(mv_par02)=.F.
		@ 0,00 PSay "^FO10,250^A0N,20^FDLOTE: "+mv_par02+"^FS"
		@ 0,00 PSay "^FO10,280^A0N,20^FDVAL.: "+DtoC(mv_par03)+"          Impressao: "+ Dtoc(d_Data)+" - "+c_Hora+"^FS"
		@ 0,00 PSay "^FO290,180^BY2,1,67^BCN, 67,Y,N,N,N"
		@ 0,00 PSay "^FD"+Alltrim(mv_par02)+"^FS"
	Endif
	//@ 0,00 PSay "^FO460,300^A0N,14^FD"+Dtoc(d_Data)+" "+c_Hora+"^FS"
	@ 0,00 PSay "^PQ1,0,1,Y"
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
	c_Qry:="SELECT B1_FSREF, B1_FSCANVI, B1_CODBAR, B1_COD, B1_DESC "
	c_Qry+="FROM "+RetSqlName("SB1")+" SB1 "
		c_Qry+="WHERE D_E_L_E_T_<>'*' "
			c_Qry+="AND B1_COD='"+mv_par01+"' "
			c_Qry+="AND B1_FILIAL='"+xFilial("SB1")+"' "

	TCQUERY c_Qry NEW ALIAS "q_SB1"

	If	q_SB1->(Eof())=.T.
		ApMsgAlert("Produto nใo cadastrado"+CHR(13)+CHR(10)+"Verifique o parametro 01 !!", "Etiqueta nao sera impressa")
		l_Ret:=.F.
	Else
		c_Ref	:=q_SB1->B1_COD	//q_SB1->B1_FSREF
		c_CANVI	:=q_SB1->B1_FSCANVI
		c_Codbar:=q_SB1->B1_CODBAR
		c_Desc	:=Alltrim(q_SB1->B1_DESC)
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
o_perg:mtdPutSX1(c_Perg		,"01"		,"Produto"			,""			,""			,"mv_ch1"	,"C"		,TamSX3("B8_PRODUTO")[1]	,0			,0		,"G"	,""			,"mv_par01"	,""			,""					,""					,""			,""					,""					,""					,""			,""					,""					,""					,""			,""					,""					,""				,""			,""			,""			,""			,""			,""			,""			,""			,""			,"FSSB82"	 ,""		,""			,""			,""			,""	)
o_perg:mtdPutSX1(c_Perg		,"02"		,"Lote"				,""			,""			,"mv_ch2"	,"C"		,TAMSX3("B8_LOTECTL")[1],0			,0			,"S"	,""			,"mv_par02"	,""			,""					,""					,""			,""					,""					,""					,""			,""					,""					,""					,""			,""					,""					,""				,""			,""			,""			,""			,""			,""			,""			,""			,""			,""       ,""		,""			,""			,""			,""	)
o_perg:mtdPutSX1(c_Perg		,"03"		,"Validade	"		,""			,""			,"mv_ch3"	,"D"		,TAMSX3("B8_DTVALID")[1],0			,0			,"S"	,""			,"mv_par03"	,""			,""					,""					,""			,""					,""					,""					,""			,""					,""					,""					,""			,""					,""					,""				,""			,""			,""			,""			,""			,""			,""			,""			,""			,""		 ,"" 		,""			,""			,""			,""	)
o_perg:mtdPutSX1(c_Perg		,"04"		,"Quantidade"		,""			,""			,"mv_ch4"	,"N"		,TAMSX3("F2_VOLUME1")[1],0			,0			,"G"	,""			,"mv_par04"	,""			,""					,""					,""			,""					,""					,""					,""			,""					,""					,""					,""			,""					,""					,""				,""			,""			,""			,""			,""			,""			,""			,""			,""			,""		 ,"" 		,""			,""			,""			,""	)

Return
