#Include "Totvs.ch"
/*/{Protheus.doc} User Function zEST0001
Ponto de Entrada Estoque Prime
@author Roseclei Ventura
@since 13/07/2023
@version 1.0
@type function
@obs Ponto de entrada para adicionar bot�o a Outras A��es na tela Doc. de Sa�da
/*/
User function MA461ROT()
Local aRetorno:= {}
AAdd( aRetorno,{ "Despacho de Separa��o", "U_zEST0002", 2, 0 } )

Return( aRetorno )
