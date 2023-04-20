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
ฑฑบPrograma  ณFFATR001บ Autor ณ Beatriz Azevedo (TBA087)บ Data ณ Jul/2021 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Imprimir Etiqueta T้rmica para Documeto de Saida           บฑฑ
ฑฑบCliente   ณ Prime Medical                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Faturamento                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

*********************************************
User Function FFATR001(n_Opc, c_Doc, c_Serie)
*********************************************
Private lEnd		:= .F.
Private wnrel  		:= "FFATR001"
Private cDesc1	  	:= "Emissao de etiquetas de volumes para expedi็ใo"
Private cDesc2	  	:= " "
Private cDesc3	  	:= " "
Private cString		:= "SF2"
Private tamanho   	:= "P"
Private limite 		:= 200
Private titulo		:= "Etiqueta Expedi็ใo"
Private aReturn   	:= {"Zebrado", 1,"Administracao", 2, 2, 2, "",0 }
Private nomeprog	:= "FFATR001"
Private nLastKey  	:= 0
Private nBegin		:= 0
Private aLinha		:= { }
Private cPerg		:= "FFATR001"
Private aSenhas   	:= {}
Private aUsuarios 	:= {}
Private aOrd		:= {"Codigo", "Nome","",""}
Private WCURVA		:= {{"","","","","","",""}}  //CODIGO,DESCRICAO,3,4,5,6,7

Private c_Perg := "FFATR001"

Default n_Opc:="1"

f_CriaPerg(c_Perg)

If 	n_Opc="1"
	Pergunte(c_Perg,.T.)
	wnrel:=SetPrint(cString,wnrel,c_Perg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)
Else
	wnrel:=SetPrint(cString,wnrel,,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)
	mv_par03:=c_Doc
	mv_par04:=c_Serie
Endif	

If 	nLastKey == 27
	Set Filter to
Else
	SetDefault(aReturn,cString)
	RptStatus({|| FFATR01A()},Titulo)
Endif

Return

**************************
Static Function FFATR01A()
**************************
Local c_Qry		:="" 
Local n_QtVol	:=0

//Buscando dados dos documentos de saida 
c_Qry+="SELECT F2_DOC, F2_CLIENTE, F2_LOJA, A1_NOME, A1_CGC, A1_PESSOA, A1_TIPO, A1_END, A1_BAIRRO, "+CHR(13)+CHR(10)
c_Qry+="	A1_MUN, A1_EST, A1_CEP, F2_VOLUME1 "+CHR(13)+CHR(10)
c_Qry+="FROM "+RetSQLName("SF2")+" SF2 "+CHR(13)+CHR(10)
c_Qry+="	INNER JOIN "+RetSQLName("SA1")+" SA1 ON A1_COD=F2_CLIENTE "+CHR(13)+CHR(10)
c_Qry+="		AND A1_LOJA=F2_LOJA "+CHR(13)+CHR(10)
c_Qry+="		AND SA1.D_E_L_E_T_<>'*' "+CHR(13)+CHR(10)
c_Qry+="WHERE SF2.D_E_L_E_T_<>'*' "+CHR(13)+CHR(10)
c_Qry+="	AND F2_FILIAL='"+xFilial("SF2")+"' "+CHR(13)+CHR(10)
c_Qry+="	AND F2_DOC='"+mv_par03+"' "+CHR(13)+CHR(10)
c_Qry+="	AND F2_SERIE='"+mv_par04+"' "+CHR(13)+CHR(10)

Tcquery c_Qry new alias "q_DOCS"

Memowrite("C:\temp\ffatr01A.txt",c_Qry) // Salva query em arquivo txt

dbSelectArea("q_DOCS")
dbGoTop()
If	q_DOCS->(Eof())=.T.
	Msgbox("Nenhum documento de saida encontrado para os parametros escolhidos!")
Else
	n_QtVol:=If(q_DOCS->F2_VOLUME1>0,q_DOCS->F2_VOLUME1,mv_par05)
	IF	n_QtVol>0
		f_ImpEtiq(n_QtVol)
	Else
        ApMsgAlert("Quantidade de volumes zerada. Verifique!!", "Etiqueta nao sera impressa")
	Endif
Endif

q_DOCS->(dbCloseArea())

If aReturn[5] == 1    // Se Saida para disco, ativa SPOOL
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return

**********************************
Static Function f_ImpEtiq(n_QtVol)
**********************************
//Local c_BitMap1	:="c:\temp\prime.png" //GetMV("FS_LOGOCQ") //"c:\totvs\Logo_bmd.Bmp"
Local c_CliNom	:=q_DOCS->A1_NOME
Local c_CliCGC	:=If(q_DOCS->A1_PESSOA="J",Transform(q_DOCS->A1_CGC,"@R 99.999.999/9999-99"),Transform(q_DOCS->A1_CGC,"@R 999.999.999-99"))
Local c_CliEnd	:=Alltrim(q_DOCS->A1_END)
Local c_CliBai	:=Alltrim(q_DOCS->A1_BAIRRO)
Local c_CliCEP	:=Transform(q_DOCS->A1_CEP,"@R 99.999-999")
Local c_CliMun	:=Alltrim(q_DOCS->A1_MUN)
Local c_CliEst	:=Alltrim(q_DOCS->A1_EST)
Local n_I	  	:=0
Local n_X	  	:=0
Local c_Vol	  	:=""
Local a_CliNom	:={}
Local a_CliEnd	:={}
Local o_Prime   := clsPrime():New()

a_CliNom:=o_Prime:mtdSeparaPalavra(c_CliNom, 36, 2)
If 	Len(a_CliNom)<2
	AADD(a_CliNom," ")
Endif

a_CliEnd:=o_Prime:mtdSeparaPalavra(c_CliEnd, 40, 2)

For n_I = 1 To n_QtVol
	c_Vol:=Alltrim(Str(n_I,5))+"/"+Alltrim(Str(n_QtVol,5))

	@ 0,00 PSay "^XA"
//	@ 0,00 PSay "CT~~CD,~CC^~CT~"
//	@ 0,00 PSay "^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ"
//	@ 0,00 PSay "^XA"
	@ 0,00 PSay "^MMT"
	@ 0,00 PSay "^PW799"
	@ 0,00 PSay "^LL0799"
	@ 0,00 PSay "^LS0"
	@ 0,00 PSay "^FO0,0^GFA,09984,09984,00052,:Z64:"
	@ 0,00 PSay "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:5EC6"
	@ 0,00 PSay "^FT23,252^A0N,45,45^FH\^FDREMETENTE^FS"
	@ 0,00 PSay "^FT23,327^A0N,39,38^FH\^FDPRIME MEDICAL COMERCIO DE MATERIAL  ^FS"
	@ 0,00 PSay "^FT23,375^A0N,39,38^FH\^FDMEDICO ERIELLI^FS"
	@ 0,00 PSay "^FT23,468^A0N,37,36^FH\^FDCNPJ: 09.342.946/0001-00^FS"
	@ 0,00 PSay "^FT23,503^AEN,32,15^FH\^FDRUA ITAGI,413,QUADRA 9,GALPAO 10^FS"
	@ 0,00 PSay "^FT23,545^AEN,32,15^FH\^FDPITANGUEIRAS^FS"
	@ 0,00 PSay "^FT23,591^AEN,32,15^FH\^FDCEP 42.701-370^FS"
	@ 0,00 PSay "^FT23,640^AHN,21,13^FH\^FDLAURO DE FREITAS-BA^FS"
	@ 0,00 PSay "^PQ1,0,1,Y^XZ"

	@ 0,00 PSay "^XA"
	@ 0,00 PSay "CT~~CD,~CC^~CT~"
	@ 0,00 PSay "^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ"
	@ 0,00 PSay "^XA"
	@ 0,00 PSay "^MMT"
	@ 0,00 PSay "^PW799"
	@ 0,00 PSay "^LL0799"
	@ 0,00 PSay "^LS0"
	@ 0,00 PSay "^FO0,0^GFA,09984,09984,00052,:Z64:"
	@ 0,00 PSay "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:FF2F"
	@ 0,00 PSay "^FT574,56^A0N,28,28^FH\^FDNF "+mv_par03+"^FS"
	@ 0,00 PSay "^FT612,90^A0N,28,28^FH\^FDVOL "+c_Vol+"^FS"
	@ 0,00 PSay "^FT23,252^A0N,45,45^FH\^FDDESTINATARIO^FS"
	n_Lin:=277
	For n_X:=1 To Len(a_CliNom)
		n_Lin+=50
		@ 0,00 PSay "^FT23,"+Str(n_Lin,3)+"^A0N,39,38^FH\^FD"+a_CliNom[n_X]+"^FS"
	Next
	n_Lin+=91
	@ 0,00 PSay "^FT23,"+Str(n_Lin,3)+"^A0N,37,36^FH\^FDCNPJ: "+c_CliCGC+"^FS"
	For n_X:=1 To Len(a_CliEnd)
		n_Lin+=45
		@ 0,00 PSay "^FT23,"+Str(n_Lin,3)+"^A0N,32,25^FH\^FD"+a_CliEnd[n_X]+"^FS"
	Next
	n_Lin+=45
	@ 0,00 PSay "^FT23,"+Str(n_Lin,3)+"^A0N,32,25^FH\^FD"+c_CliBai+"^FS"
	n_Lin+=45
	@ 0,00 PSay "^FT23,"+Str(n_Lin,3)+"^A0N,32,25^FH\^FDCEP "+c_CliCEP+"^FS"
	n_Lin+=45
	@ 0,00 PSay "^FT23,"+Str(n_Lin,3)+"^A0N,32,25^FH\^FD"+c_CliMun+"-"+c_CliEst+"^FS"

/*
	@ 0,00 PSay "^FT23,327^A0N,39,38^FH\^FD"+c_CliNom+"^FS"
	@ 0,00 PSay "^FT23,468^A0N,37,36^FH\^FDCNPJ: "+c_CliCGC+"^FS"
	@ 0,00 PSay "^FT23,503^AEN,32,15^FH\^FD"+c_CliEnd+"^FS"
	@ 0,00 PSay "^FT23,545^AEN,32,15^FH\^FD"+c_CliBai+"^FS"
	@ 0,00 PSay "^FT23,591^AEN,32,15^FH\^FDCEP "+c_CliCEP+"^FS"
	@ 0,00 PSay "^FT23,640^AHN,21,13^FH\^FD"+c_CliMun+"-"+c_CliEst+"^FS"
*/
	@ 0,00 PSay "^PQ1,0,1,Y^XZ"
/*
	@ 0,00 PSay "CT~~CD,~CC^~CT~"
	@ 0,00 PSay "^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ"
	@ 0,00 PSay "^XA"
	@ 0,00 PSay "^MMT"
	@ 0,00 PSay "^PW799"
	@ 0,00 PSay "^LL0799"
	@ 0,00 PSay "^LS0"
	@ 0,00 PSay "^FO0,0^GFA,08320,08320,00052,:Z64:"+c_Logo01+c_Logo02+c_Logo03+c_Logo04+c_Logo05+;
		c_Logo06+c_Logo07+c_Logo08+c_Logo09+c_Logo10+c_Logo11+c_Logo12+c_Logo13+c_Logo14+c_Logo15+;
		c_Logo16+c_Logo17+c_Logo18+c_Logo19+c_Logo20+c_Logo21+c_Logo22+c_Logo23+c_Logo24+c_Logo25+" "
	@ 0,00 PSay "^FT574,56^A0N,28,28^FH\^FDNF "+mv_par03+"^FS"
	@ 0,00 PSay "^FT612,90^A0N,28,28^FH\^FDVOL "+c_Vol+"^FS"
	@ 0,00 PSay "^CF0,40" 
	@ 0,00 PSay "^FT23,222,45,45^FH\^FDDESTINATARIO^FS"
	@ 0,00 PSay "^CF0,30"
	@ 0,00 PSay "^FT23,297,39,38^FH\^FD"+c_CliNom+"^FS"
	@ 0,00 PSay "^FT23,438,37,36^FH\^FDCNPJ: "+c_CliCGC+"^FS"
	@ 0,00 PSay "^CFA,25"
	@ 0,00 PSay "^FT23,473,32,15^FH\^FD"+c_CliEnd+"^FS"
	@ 0,00 PSay "^FT23,515,32,15^FH\^FD"+c_CliBai+"^FS"
	@ 0,00 PSay "^FT23,561,32,15^FH\^FDCEP "+c_CliCEP+"^FS"
	@ 0,00 PSay "^CFA,20"
	@ 0,00 PSay "^FT23,669,21,13^FH\^FD"+c_CliMun+"-"+c_CliEst+"^FS"
	@ 0,00 PSay "^PQ1,0,1,Y^XZ"
*/

Next

Return

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

//mtdPutSX1( 	 X1_GRUPO	, X1_ORDEM	, X1_PERGUNT			, X1_PERSPA	, X1_PERENG	, X1_VARIAVL, X1_TIPO	, X1_TAMANHO			, X1_DECIMAL, X1_PRESEL, X1_GSC	, X1_VALID	, X1_VAR01	, X1_DEF01			, X1_DEFSPA1		, X1_DEFENG1		, X1_CNT01	, X1_VAR02			, X1_DEF02			, X1_DEFSPA2		, X1_DEFENG2, X1_CNT02			, X1_VAR03			, X1_DEF03			, X1_DEFSPA3, X1_DEFENG3		, X1_CNT03			, X1_VAR04		, X1_DEF04	, X1_DEFSPA4, X1_DEFENG4, X1_CNT04	, X1_VAR05	, X1_DEF05	, X1_DEFSPA5, X1_DEFENG5, X1_CNT05	, X1_F3	, X1_PYME	, X1_GRPSXG	, X1_HELP	, X1_PICTURE	, X1_IDFIL )
//				 X1_GRUPO	, X1_ORDEM	, X1_PERGUNT			, X1_PERSPA	, X1_PERENG	, X1_VARIAVL, X1_TIPO	, X1_TAMANHO			, X1_DECIMAL, X1_PRESEL, X1_GSC	, X1_VALID	, X1_VAR01	, X1_DEF01			, X1_DEFSPA1		, X1_DEFENG1		, X1_CNT01	, X1_VAR02			, X1_DEF02			, X1_DEFSPA2		, X1_DEFENG2, X1_CNT02			, X1_VAR03			, X1_DEF03			, X1_DEFSPA3, X1_DEFENG3		, X1_CNT03			, X1_VAR04		, X1_DEF04	, X1_DEFSPA4, X1_DEFENG4, X1_CNT04	, X1_VAR05	, X1_DEF05	, X1_DEFSPA5, X1_DEFENG5, X1_CNT05	, X1_F3	, X1_PYME	, X1_GRPSXG	, X1_HELP	, X1_PICTURE	, X1_IDFIL

o_perg:mtdPutSX1(c_Perg		,"01"		,"Emissao de"			,""			,""			,"mv_ch1"	,"D"		,TAMSX3("F2_EMISSAO")[1],0			,0			,"G"	,""			,"mv_par01"	,""					,""					,""					,""			,""					,""					,""					,""			,""					,""					,""					,""			,""					,""					,""				,""			,""			,""			,""			,""			,""			,""			,""			,""			,""		 ,"" 		,""			,""			,""			,""	)
o_perg:mtdPutSX1(c_Perg		,"02"		,"Emissao ate"			,""			,""			,"mv_ch1"	,"D"		,TAMSX3("F2_EMISSAO")[1],0			,0			,"G"	,""			,"mv_par02"	,""					,""					,""					,""			,""					,""					,""					,""			,""					,""					,""					,""			,""					,""					,""				,""			,""			,""			,""			,""			,""			,""			,""			,""			,""		 ,"" 		,""			,""			,""			,""	)
o_perg:mtdPutSX1(c_Perg		,"03"		,"Nota Fiscal"			,""			,""			,"mv_ch3"	,"C"		,TamSX3("F2_DOC")[1]	,0			,0			,"G"	,""			,"mv_par03"	,""					,""					,""					,""			,""					,""					,""					,""			,""					,""					,""					,""			,""					,""					,""				,""			,""			,""			,""			,""			,""			,""			,""			,""			,"SF2"	,""		,""			,""			,""			,""	)
o_perg:mtdPutSX1(c_Perg		,"04"		,"Serie"				,""			,""			,"mv_ch4"	,"C"		,TAMSX3("F2_SERIE")[1]	,0			,0			,"G"	,""			,"mv_par04"	,""					,""					,""					,""			,""					,""					,""					,""			,""					,""					,""					,""			,""					,""					,""				,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""		,""			,""			,""			,""	)
o_perg:mtdPutSX1(c_Perg		,"05"		,"Qtd.Vol"				,""			,""			,"mv_ch5"	,"N"		,TAMSX3("F2_VOLUME1")[1],0			,0			,"G"	,""			,"mv_par05"	,""					,""					,""					,""			,""					,""					,""					,""			,""					,""					,""					,""			,""					,""					,""				,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""	 	,""			,""			,""			,""	)

Return
