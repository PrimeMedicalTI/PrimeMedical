#Include "Protheus.ch"
#Include "totvs.ch"


User Function vldcampd()  // Gatilho para alertar sobre o Risco do Cliente no Pedido de Vendas

	Local cCampo

	cCampo :=  Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+C5_LOJACLI,"A1_RISCO")

	IF cCampo == "E"

		MSGALERT( "Cliente Bloqueado para Faturamento", "Condicao Financeira" )

	ENDIF

RETURN  cCampo
