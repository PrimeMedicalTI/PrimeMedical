#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} PCCGA004
Programa responsavel por importar o cadastro de Cliente

@author francisco.ssa
@since 08/09/2014
@version 11.80

@return Nil, Nao Esperado
@example

(examples)
@see (links_or_references)
/*/
User Function PCCGA004()

	LjMsgRun("Aguarde enquanto o cadastro e importado... ","Importacao de Cadastro",{|| f_ImpClientes() })

Return()

Static Function f_ImpClientes()

	Local n_RetTela			:= 0
	Local a_Clientes    	:= {}
	Local c_Cadastro		:= "Cliente"

	Local c_Linha 			:= ""
	Local a_Linha			:= {}

	Local o_TxtArray		:= clsTxt2Array():New()

	Private lMsErroAuto	:= .F.
	Private c_Arquivo		:= Space(200)

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//?ela interface usuario                                ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	n_RetTela	:= U_PCCGA003("Cadastro de "+c_Cadastro)

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

		//a_Clientes	:= {{"A1_COD"	,Padr( a_Linha[1], TamSX3("A1_COD")[1] )		,NIL},;
			//{"A1_LOJA"				,Padr( RIGHT(a_Linha[2],8), TamSX3("A1_LOJA")[1] )		,NIL},;
		    a_Clientes		:= {{"A1_COD"	,Padr( LEFT(a_Linha[1],4), TamSX3("A1_COD")[1] )		,NIL},;
			{"A1_LOJA"				,Padr( a_Linha[2], TamSX3("A1_LOJA")[1] )		,NIL},;
			{"A1_NOME"    			,Padr( a_Linha[3], TamSX3("A1_NOME")[1] )		,Nil},;
			{"A1_NREDUZ"   			,Padr( a_Linha[4], TamSX3("A1_NREDUZ")[1] ) 	,Nil},;
			{"A1_PESSOA" 	 		,Padr( a_Linha[6], TamSX3("A1_PESSOA")[1] )    	,Nil},;
			{"A1_TIPO" 	 			,Padr( a_Linha[7], TamSX3("A1_TIPO")[1] )    	,Nil},;
			{"A1_CGC" 	 			,Padr( a_Linha[5], TamSX3("A1_CGC")[1] )    	,Nil},;
			{"A1_END" 	 			,Padr( a_Linha[8], TamSX3("A1_END")[1] )    	,Nil},;
			{"A1_BAIRRO" 			,Padr( a_Linha[9], TamSX3("A1_BAIRRO")[1] )    	,Nil},;
			{"A1_CEP" 	 			,Padr( a_Linha[10], TamSX3("A1_CEP")[1] )    	,Nil},;
			{"A1_EST" 	 			,Padr( a_Linha[11], TamSX3("A1_EST")[1] )   	,Nil},;
			{"A1_COD_MUN" 			,Padr( a_Linha[12], TamSX3("A1_COD_MUN")[1] )   	,Nil},;
			{"A1_MUN" 	 			,Padr( a_Linha[13], TamSX3("A1_MUN")[1] )   	,Nil},;
			{"A1_EMAIL"  			,Padr( a_Linha[14], TamSX3("A1_EMAIL")[1] )   	,Nil}}

		If ExistBlock( "CCGA4INC" )
			a_Clientes	:= ExecBlock( "CCGA4INC", .F., .F., {a_Clientes,a_Linha} )
		EndIf

		Begin Transaction

			MSExecAuto({|x,y| Mata030(x,y)},a_Clientes,3)

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
