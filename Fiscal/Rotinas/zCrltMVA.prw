#include 'protheus.ch'
#include "TOTVS.CH"
 
User Function zCrltMVA()

    Local cAlias := "ZZ8"
    Local cTitulo := "Controle de MVA"
    Local cVldExc := ".T."
    Local cVldOk := ".T." 

    GravarMVA()
 
    DBSelectArea(cAlias)
    DBSetOrder(1)
    AxCadastro(cAlias,cTitulo,cVldExc,cVldOk)   
 
Return

Static Function GravarMVA()

    Local cAlias := getNextAlias()

    BeginSql alias cAlias   	

        SELECT DISTINCT UF, B1_POSIPI as NCM, 0 as MVA
        FROM SB1010 
        Inner Join (
                Select X5_CHAVE as UF from SX5010
                Where X5_TABELA = '12'
                AND X5_CHAVE in ('BA','PE','SE')
        ) Estados ON 1=1
        WHERE D_E_L_E_T_ <> '*'
        AND B1_PICMENT <> ''
        AND UF + B1_POSIPI not in (Select ZZ8_UF + ZZ8_NCM from ZZ8010)
        Order by  UF

    EndSQL
    
    DBSelectArea("ZZ8")	

    Begin Transaction

    While (cAlias)->(!EOF())   

        RecLock("ZZ8", .T.) 
        ZZ8->(ZZ8_UF) := (cAlias)->(UF)
        ZZ8->(ZZ8_NCM) := (cAlias)->(NCM)
        ZZ8->(ZZ8_MVA) := (cAlias)->(MVA)
        ZZ8->(MsUnLock())  
        
        (cAlias)->(DbSkip())
        
    EndDo

    End Transaction
    (cAlias)->(DbCloseArea())
    ZZ8->(DbCloseArea())	

    Return .T.

Return
