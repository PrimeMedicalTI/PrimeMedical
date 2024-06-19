#include 'protheus.ch'
#include "TOTVS.CH"

User Function ZCep()
    Local cAlias := "ZZ9"
    Local cTitulo := "Cep Bairros"     
    Local cVldExc := ".T."
    Local cVldOk := ".T."    
    
    dbSelectArea(cAlias)
    dbSetOrder(1)
    
    DBSelectArea(cAlias)
    DBSetOrder(1)
    AxCadastro(cAlias,cTitulo,cVldExc,cVldOk)  
    
Return
