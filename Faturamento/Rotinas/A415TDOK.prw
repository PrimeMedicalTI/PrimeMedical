#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

User function A415TDOK() 

Local lRet := .T. //Variável utilizada para controle e validação ao clicar no botão SALVAR do Orçamento de venda

dbSelectArea("TMP1")
dbGotop()

M->CJ_FSUSER := ALLTRIM(USRRETNAME(RETCODUSR()))

Return(lRet)
