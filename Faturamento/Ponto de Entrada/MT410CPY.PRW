#include "TOTVS.ch"

/*/{Protheus.doc} User Function MT410CPY
    (Ponto de entrada acionado no Pedido de Vendas.)
    @type  Function
    @author 
    @since 27/01/2022
    @version 1.0
/*/
User Function MT410CPY

M->C5_FSNOME := Upper(cUserName)
 
Return
