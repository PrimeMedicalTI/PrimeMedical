
#Include 'Protheus.ch'


/*/{Protheus.doc} MT261CAB
Este ponto de entrada MT261CAB, permite incluir campos customizados no cabe�alho da rotina de Transfer�ncia Mod. II.
@author Andr� Brito
@since 18/11/2022
@return N�o h�.
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
