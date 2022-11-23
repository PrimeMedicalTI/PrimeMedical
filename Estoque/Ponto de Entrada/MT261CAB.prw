
#Include 'Protheus.ch'


/*/{Protheus.doc} MT261CAB
Este ponto de entrada MT261CAB, permite incluir campos customizados no cabeçalho da rotina de Transferência Mod. II.
@author André Brito
@since 18/11/2022
@return Não há.
/*/

User Function MT261CAB()

Local oNewDialog := PARAMIXB[1]
Local nX                 := PARAMIXB[2]
Local aCp               := Array(2,2)

aCp[1][1]="D3_OBSERVA"
aCp[1][2]=SPAC(30)

@ nX,201 SAY      "Observacao" OF oNewDialog PIXEL
@ 0  ,250 MSGET  aCp[1][2]  OF oNewDialog PIXEL

Return
