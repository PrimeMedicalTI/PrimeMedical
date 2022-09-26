#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} u_FCOMA02A
Verifica se a nota fiscal de beneficiamento tem poder de terceiro = 'D'
e TES de venda de consignacao.
Chamado: PE GQREENTR
@type function
@author Francisco Mendonca
@since 22/07/21
@version 12.1.25
@return nil, nil
/*/
User function FCOMA003()

If SF1->F1_TIPO $ "DB"
    cNome := Posicione("SA1",1,xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,"A1_NOME")
Else
    cNome := Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_NOME")
Endif

Return cNome
