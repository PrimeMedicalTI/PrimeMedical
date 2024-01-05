#Include "PROTHEUS.Ch"
#Include "RWMAKE.CH"

 /*Tratamento para o campo E2_NATUREZ para usar no relatorio FINR150
  adicionado na formula na opção personalizar do relatorio FINR150 */

USER FUNCTION XSEDDESC(cNAT)

Local cRET := ''
Local cNATUREZA := STRTRAN(cNAT,".","")

cRET := POSICIONE("SED",1,XFILIAL("SED")+cNATUREZA,"SED->ED_DESCRIC")

RETURN cRET
