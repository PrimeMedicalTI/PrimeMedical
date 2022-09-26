#include "topconn.ch"
#INCLUDE 'RWMAKE.CH'
#include "protheus.ch"
#include "parmtype.ch"

User function FFATG002( c_PedCli, c_Cliente, c_Loja)

Local c_Ret     := c_PedCli
Local cAliasC5  := GetNextAlias()

// Verifica de tem algum pedido de venda com essa informação
If !Empty(c_PedCli) .And. !Empty(c_Cliente) .And. !Empty(c_Loja) 

    BeginSql Alias cAliasC5
       SELECT TOP 1 C5_NUM
        FROM %table:SC5% SC5
        WHERE C5_FILIAL = %Exp:xFilial("SC5")%  AND 
            C5_FSPEDCL  = %Exp:c_PedCli%        AND    
            C5_CLIENTE  = %Exp:c_Cliente%       AND 
            C5_LOJACLI  = %Exp:c_Loja%          AND      
            SC5.%NotDel%				
    EndSql 

    If !(cAliasC5)->( Eof() )
        ApMsgAlert("Esse conteúdo já foi utilizado no pedido de venda " + (cAliasC5)->C5_NUM, "Pedido do Cliente")
        c_Ret := "" 
    Endif
Endif    

Return( c_Ret )
