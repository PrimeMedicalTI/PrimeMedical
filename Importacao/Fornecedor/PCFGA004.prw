#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} PCFGA004
Programa responsavel por importar o cadastro de fornecedores

@author francisco.ssa
@since 08/09/2014
@version 11.80

@return Nil, Nao Esperado
@example

(examples)
@see (links_or_references)
/*/
User Function PCFGA004()

	LjMsgRun("Aguarde enquanto o cadastro e importado... ","Importacao de Cadastro",{|| f_ImpFornecedores() })

Return()

Static Function f_ImpFornecedores()

	Local n_RetTela			:= 0
	Local a_Fornecedores 	:= {}
	Local c_Cadastro		:= "Fornecedores"

	Local c_Linha 			:= ""
	Local a_Linha			:= {}

	Local o_TxtArray		:= clsTxt2Array():New()

	Private lMsErroAuto	:= .F.
	Private c_Arquivo		:= Space(200)

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//?ela interface usuario                                ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	n_RetTela	:= U_PCFGA003("Cadastro de "+c_Cadastro)

	IF n_RetTela <> 1
		Return()
	ENDIF

	IF FT_FUSE(c_Arquivo) <> 1

		ShowHelpDlg("Importacao de "+c_Cadastro,;
			{"Problema ao abrir o arquivo.","Nao foi possivel abrir o arquivo"},5,;
			{"Verifique o arquivo antes de continuar","Ou procure o setor de TI"},5)
		Return()

	ENDIF

	WHILE !FT_FEOF()

		c_Linha 	:= FT_FReadLn()		//Leitura da linha
		a_Linha		:= o_TxtArray:mtdGerArray(c_Linha,";")	//U_TBCSVTOARRAY( c_Linha, ";" )

		//a_Fornecedores	:= {{"A2_COD"	,Padr( a_Linha[1], TamSX3("A2_COD")[1] )		,NIL},;
			//{"A2_LOJA"				,Padr( a_Linha[2], TamSX3("A2_LOJA")[1] )		,NIL},;
		a_Fornecedores	:= {{"A2_COD"	,Padr( LEFT(a_Linha[5],8), TamSX3("A2_COD")[1] )		,NIL},;
			{"A2_LOJA"				,Padr( RIGHT(a_Linha[5],4), TamSX3("A2_LOJA")[1] )		,NIL},;
			{"A2_NOME"    			,Padr( a_Linha[3], TamSX3("A2_NOME")[1] )		,Nil},;
			{"A2_NREDUZ"   			,Padr( a_Linha[4], TamSX3("A2_NREDUZ")[1] ) 	,Nil},;
			{"A2_TIPO" 	 			,Padr( a_Linha[6], TamSX3("A2_TIPO")[1] )    	,Nil},;
			{"A2_CGC" 	 			,Padr( a_Linha[5], TamSX3("A2_CGC")[1] )    	,Nil},;
			{"A2_END" 	 			,Padr( a_Linha[7], TamSX3("A2_END")[1] )    	,Nil},;
			{"A2_BAIRRO" 			,Padr( a_Linha[8], TamSX3("A2_BAIRRO")[1] )    	,Nil},;
			{"A2_CEP" 	 			,Padr( a_Linha[9], TamSX3("A2_CEP")[1] )    	,Nil},;
			{"A2_EST" 	 			,Padr( a_Linha[10], TamSX3("A2_EST")[1] )   	,Nil},;
			{"A2_COD_MUN" 			,Padr( a_Linha[11], TamSX3("A2_COD_MUN")[1] )   	,Nil},;
			{"A2_MUN" 	 			,Padr( a_Linha[12], TamSX3("A2_MUN")[1] )   	,Nil},;
			{"A2_EMAIL"  			,Padr( a_Linha[13], TamSX3("A2_EMAIL")[1] )   	,Nil},;
			{"A2_DDD" 	 			,Padr( a_Linha[14], TamSX3("A2_DDD")[1] )   	,Nil},;
			{"A2_TEL"  			,Padr( a_Linha[15], TamSX3("A2_TEL")[1] )   	,Nil}}

		If ExistBlock( "CFGA4INC" )
			a_Fornecedores	:= ExecBlock( "CFGA4INC", .F., .F., {a_Fornecedores,a_Linha} )
		EndIf

		Begin Transaction

			MSExecAuto({|x,y| Mata020(x,y)},a_Fornecedores,3)

			If lMsErroAuto
				DisarmTransaction()
				MostraErro()
				break
			EndIf

		End Transaction

		FT_FSKIP()

	ENDDO
	FT_FUse()				//Fecha arquivo

Return()
