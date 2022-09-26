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
ฑฑบPrograma  ณFACDR001บ Autor ณ Beatriz Azevedo (TBA087)บ Data ณ Ago/2021 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Imprimir Etiqueta T้rmica para produtos 			          บฑฑ
ฑฑบCliente   ณ Prime Medical                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAACD                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

************************
User Function FACDR001()
************************
Local l_Ret			:=.F.
Local l_Perg		:=.T.

Private lEnd		:= .F.
Private wnrel  		:= "FACDR001"
Private cDesc1	  	:= "Emissao de etiquetas de produtos para Coletor"
Private cDesc2	  	:= " "
Private cDesc3	  	:= " "
Private cString		:= "SB1"
Private tamanho   	:= "G"
Private limite 		:= 220
Private titulo		:= "Etiqueta Produtos Coletor"
Private aReturn   	:= {"Zebrado", 1,"Administracao", 2, 2, 2, "",0 }
Private nomeprog	:= "FACDR001"
Private nLastKey  	:= 0
Private aOrd		:= {"Codigo", "Nome","",""}
Private c_Perg 		:= "FACDR001"
Private c_Descr		:=""
Private c_Codbar	:=""

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
			RptStatus({|| FACDR01A()},Titulo)
		Endif
	Endif	
Endif 

Return

**************************
Static Function FACDR01A()
**************************
SETPRC(0,0)

@ 0,00 PSay "^XA"
@ 0,00 PSay "^MMT"
@ 0,00 PSay "^PW799"
@ 0,00 PSay "^LL0799"
@ 0,00 PSay "^LS0"

@ 0,00 PSay "^FO0,0^GFA,02304,02304,00024,:Z64:"
@ 0,00 PSay "eJztU7FKw1AUve9FedJAo6C4KHEsIp1FCs3gByjY/3Bxi/Shi39hwEUUnIUM3kFxdXEvTqVDyCIKbX2e5CUlRScRB+nhnnBzOZyc+x4hmuG/I/h+LK+uIhDdJl5IbhRzZcwITAX7TD77xjzlcyeOb9347pZ0W1Nbu8ZEVv96FKq37khwm6nLnjFs/TU1LJs9auo6Pmf1TOtgCH0qDPv7Szago2kB3Ba6/U5D7ZY5oV2z+uNUvLE3yQ997s9bffmi61/1LeRiv5xn3tZ/e8e50N5ZqX/uhCDyt7rqEfty4Z8M+vIm6UvdaNZPdP2jNzmfcXZG0Pvnp9Cnhf/g+tKJh5fwd+9OtRdHhf5+N1AP40BwqIxibzeY5AebJLkhEzmVH+wS/NVITeUHXQ1/593RtWn9KsNfVPXWX0bIT9EXf4H7bYnUqdxv7k9ZforwITOMKvrsPMOswf32Kv7UIPijqSVJjypYFLRMJIKVTmePfhOirG+g85qGCnJxQHNEB0SH5VxWnsBG2cw/IXWh38uram71C4S9C8xlW2aFZjn/24KfrDXDDDP8NT4B8Jyr3w==:1D01"
@ 0,00 PSay "^FO240,8^GB0,112,3,B^FS"
@ 0,00 PSay "^FO16,130^GB770,0,3,B^FS"
@ 0,00 PSay "^FO16,270^GB770,0,3,B^FS"
@ 0,00 PSay "^FO400,270^GB0,175,3,B^FS"
If 	Empty(c_Codbar)=.F.
	@ 0,00 PSay "^FO350,20^BY2,1,77^BCN, 77,Y,N,N,N^FD"+Alltrim(c_Codbar)+"^FS"
Endif
@ 0,00 PSay "^FO56,150^AAN,012,008^FH_^FDDESCRICAO:^FS"
@ 0,00 PSay "^FO56,170^A0N,030,040^FH_^FD"+c_Descr+"^FS"
@ 0,00 PSay "^FO56,210^AAN,012,008^FH_^FDEMBALAGEM:^FS"
@ 0,00 PSay "^FO56,230^A0N,030,040^FH_^FD"+mv_par05+"^FS"
If 	Empty(mv_par02)=.F.
	@ 0,00 PSay "^FO40,290^BY2,1,67^BCN, 67,Y,N,N,N^FD"+Alltrim(mv_par02)+"^FS"
	@ 0,00 PSay "^FO430,290^A0N,030,040^FH_^FDLote: ^FS"
	@ 0,00 PSay "^FO430,320^A0N,030,040^FH_^FD"+mv_par02+"^FS"
	@ 0,00 PSay "^FO430,360^A0N,030,040^FH_^FDValidade: "+DToC(mv_par03)+"^FS"
Endif
@ 0,00 PSay "^PQ"+Str(MV_PAR04,5)+",0,1,Y"
@ 0,00 PSay "^XZ"	

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
	c_Qry:="SELECT B1_DESC, B1_CODBAR "
	c_Qry+="FROM "+RetSqlName("SB1")+" SB1 "
		c_Qry+="WHERE D_E_L_E_T_<>'*' "
			c_Qry+="AND B1_COD='"+mv_par01+"' "
			c_Qry+="AND B1_FILIAL='"+xFilial("SB1")+"' "

	TCQUERY c_Qry NEW ALIAS "q_SB1"

	If	q_SB1->(Eof())=.T.
		ApMsgAlert("Produto nใo cadastrado"+CHR(13)+CHR(10)+"Verifique o parametro 01 !!", "Etiqueta nao sera impressa")
		l_Ret:=.F.
	Else
		c_Descr	:=q_SB1->B1_DESC
		c_Codbar:=q_SB1->B1_CODBAR
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
o_perg:mtdPutSX1(c_Perg		,"01"		,"Produto"			,""			,""			,"mv_ch1"	,"C"		,TamSX3("B1_COD")[1]	,0			,0			,"G"	,""			,"mv_par01"	,""			,""					,""					,""			,""					,""					,""					,""			,""					,""					,""					,""			,""					,""					,""				,""			,""			,""			,""			,""			,""			,""			,""			,""			,"FSSB11"	 ,""		,""			,""			,""			,""	)
o_perg:mtdPutSX1(c_Perg		,"02"		,"Lote"				,""			,""			,"mv_ch2"	,"C"		,TAMSX3("B8_LOTECTL")[1],0			,0			,"G"	,""			,"mv_par02"	,""			,""					,""					,""			,""					,""					,""					,""			,""					,""					,""					,""			,""					,""					,""				,""			,""			,""			,""			,""			,""			,""			,""			,""			,"FSSB81",""		,""			,""			,""			,""	)
o_perg:mtdPutSX1(c_Perg		,"03"		,"Validade	"		,""			,""			,"mv_ch3"	,"D"		,TAMSX3("B8_DTVALID")[1],0			,0			,"S"	,""			,"mv_par03"	,""			,""					,""					,""			,""					,""					,""					,""			,""					,""					,""					,""			,""					,""					,""				,""			,""			,""			,""			,""			,""			,""			,""			,""			,""		 ,"" 		,""			,""			,""			,""	)
o_perg:mtdPutSX1(c_Perg		,"04"		,"Quantidade"		,""			,""			,"mv_ch4"	,"N"		,TAMSX3("D1_QUANT")[1],0			,0			,"G"	,""			,"mv_par04"	,""			,""					,""					,""			,""					,""					,""					,""			,""					,""					,""					,""			,""					,""					,""				,""			,""			,""			,""			,""			,""			,""			,""			,""			,""		 ,"" 		,""			,""			,""			,""	)
o_perg:mtdPutSX1(c_Perg		,"05"		,"Embalagem"		,""			,""			,"mv_ch5"	,"C"		,TAMSX3("F1_ESPECI1")[1],0			,0			,"G"	,""			,"mv_par05"	,""			,""					,""					,""			,""					,""					,""					,""			,""					,""					,""					,""			,""					,""					,""				,""			,""			,""			,""			,""			,""			,""			,""			,""			,""		 ,"" 		,""			,""			,""			,""	)

Return
