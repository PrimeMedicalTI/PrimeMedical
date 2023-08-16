#Include "Protheus.ch"
#Include "totvs.ch"


User Function vldcamor()   // Gatilho para alertar sobre o Risco do Cliente no Orçamento de venda

	Local cCampo

	cCampo :=  Posicione("SA1",1,xFilial("SA1")+M->CJ_CLIENTE+CJ_LOJA,"A1_RISCO")

	IF cCampo == "E"

		MSGALERT( "Cliente Bloqueado para Faturamento", "Condicao Financeira" )

	ENDIF

RETURN  cCampo
