#Include "Protheus.ch"
#Include "totvs.ch"

/*/{Protheus.doc} User Function nomeFunction
	(long_description)
	@type  Function
	@author Roseclei ventura
	@since 21/08/2023
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/


User Function vldcamor()   // Gatilho para alertar sobre o Risco do Cliente no Orçamento de venda

	Local cCampo

	cCampo :=  Posicione("SA1",1,xFilial("SA1")+M->CJ_CLIENTE+CJ_LOJA,"A1_RISCO")

	IF cCampo == "E"

		MSGALERT( "Cliente Bloqueado para Faturamento", "Condicao Financeira" )

	ENDIF

RETURN cCampo
