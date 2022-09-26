#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

User Function PCFEA001()

	LjMsgRun("Aguarde enquanto o cadastro e importado... ","Importacao de Cadastro",{|| f_ImpAjuste() })

Return()

Static Function f_ImpAjuste()

	Local n_RetTela			:= 0

	Local a_Produtos 		:= {}
	Local c_Cadastro		:= "Custos"

	Local c_Linha 			:= ""
	Local a_Linha			:= {}

	Local o_TxtArray		:= clsTxt2Array():New()

	Private lMsErroAuto	:= .F.
	Private c_Arquivo		:= Space(200)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tela interface usuario                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	n_RetTela	:= U_PCFGA003("Cadastro de "+ c_Cadastro)

	IF n_RetTela <> 1
		Return()
	ENDIF

	IF FT_FUSE(c_Arquivo) <> 1

		ShowHelpDlg("Importacao de "+c_Cadastro,;
			{"Problema ao abrir o arquivo.","Nao foi possivel abrir o arquivo"},5,;
			{"Verifique o arquivo antes de continuar","Ou procure o setor de TI"},5)
		Return()

	ENDIF

	FT_FGoTop()

	WHILE !FT_FEOF()

		c_Linha 	:= FT_FREADLN()
		a_Linha		:= o_TxtArray:mtdGerArray(c_Linha,";")	

		a_Produtos	:= {{ "DQ_COD"  , a_Linha[1]        											, NIL},; // Controla Referencia
                        { "DQ_LOCAL"    , a_Linha[2]    											, NIL},;
						{ "DQ_DATA"	    , dDATABASE     											, NIL},;
                        { "DQ_CM1"	    , Val(StrTran(StrTran(a_Linha[3],".",""),",",".")) 			, NIL},;
                        { "DQ_CM2"	    , 0        													, NIL},;
                        { "DQ_CM3"	    , 0       													, NIL},;
                        { "DQ_CM4"	    , 0        													, NIL},;
                        { "DQ_CM5"   	, 0  														, NIL}} // Peso Bruto
				
		
		Begin Transaction

			 MSExecAuto({|x,y,z| MATA338(x,y)},a_Produtos,3)
			 //3-Inclus�o, 4-Altera��o e 5-Exclus�o 

			If lMsErroAuto
				DisarmTransaction()
				MostraErro()
				break
			EndIf

		End Transaction
	
		FT_FSKIP()

	ENDDO
	FT_FUse()

Return()
