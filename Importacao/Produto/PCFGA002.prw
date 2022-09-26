#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} PCFGA002
Programa responsavel por importar o cadastro de produtos

@author francisco.ssa
@since 08/09/2014
@version 11.80

@return Nil, Nao Esperado
@example

(examples)
@see (links_or_references)
/*/
User Function PCFGA002()

	LjMsgRun("Aguarde enquanto o cadastro e importado... ","Importacao de Cadastro",{|| f_ImpProdutos() })

Return()

Static Function f_ImpProdutos()

	Local n_RetTela			:= 0

	Local a_Produtos 		:= {}
	Local c_Cadastro		:= "Produtos"

	Local c_Linha 			:= ""
	Local a_Linha			:= {}

	Local o_TxtArray		:= clsTxt2Array():New()

	Private lMsErroAuto	:= .F.
	Private c_Arquivo		:= Space(200)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tela interface usuario                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

		a_Produtos	:= {{ "B1_FSCTRRE"  , a_Linha[1]        , NIL},; // Controla Referencia
                        { "B1_GRUPO"    , a_Linha[2]        , NIL},;
                        { "B1_COD"	    , a_Linha[3]        , NIL},;
                        { "B1_DESC"	    , a_Linha[4]	    , NIL},;
                        { "B1_TIPO"    	, a_Linha[5]	    , Nil},;
                        { "B1_UM"      	, a_Linha[6] 	    , Nil},;
                        { "B1_LOCPAD"  	, a_Linha[7]        , Nil},; 
                        { "B1_POSIPI"   , a_Linha[8]        , NIL},;
                        { "B1_IPI"      , Val(a_Linha[9])   , NIL},; // Aliquota de IPI
                        { "B1_QE"       , Val(a_Linha[10])  , NIL},; // Quantidade por Embalagem
                        { "B1_FSCANVI"  , a_Linha[11]       , NIL},; // Registro ANVISA
                        { "B1_FSDTANV"  , Ctod(a_Linha[12]) , NIL},; // Validade ANVISA
                        { "B1_LOCALIZ"  , a_Linha[13]       , NIL},; // Controla Endereço
                        { "B1_RASTRO"   , a_Linha[14]       , NIL},; // Rastro
                        { "B1_ORIGEM"   , a_Linha[15]       , NIL},; // Origem
                        { "B1_FABRIC"   , a_Linha[16]       , NIL},; // Fabricante
                        { "B1_PESO"     , Val(a_Linha[17])  , NIL},;// Peso Liquido
                        { "B1_PESBRU"   , Val(a_Linha[18])  , NIL}} // Peso Bruto

		If ExistBlock( "CFGA2INC" )
			a_Produtos	:= ExecBlock( "CFGA2INC", .F., .F., {a_Produtos,a_Linha} )
		EndIf

		Begin Transaction

			MSExecAuto({|x,y| Mata010(x,y)},a_Produtos,3)

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