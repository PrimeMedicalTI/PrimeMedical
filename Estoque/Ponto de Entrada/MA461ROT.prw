#Include "Totvs.ch"
/*/{Protheus.doc} User Function zEST0001
Ponto de Entrada Estoque Prime
@author Roseclei Ventura
@since 13/07/2023
@version 1.0
@type function
@obs Ponto de entrada para adicionar botão a Outras Ações na tela Doc. de Saída
/*/
User function MA461ROT()
Local aRetorno:= {}
AAdd( aRetorno,{ "Despacho de Separação", "U_zEST0002", 2, 0 } )

Return( aRetorno )
