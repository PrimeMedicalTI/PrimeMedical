#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

User function A415TDOK() 

Local lRet := .T. //Vari�vel utilizada para controle e valida��o ao clicar no bot�o SALVAR do Or�amento de venda

dbSelectArea("TMP1")
dbGotop()

M->CJ_FSUSER := ALLTRIM(USRRETNAME(RETCODUSR()))

Return(lRet)
