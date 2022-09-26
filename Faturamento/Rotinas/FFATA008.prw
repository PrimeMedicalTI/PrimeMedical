#include "topconn.ch"
#INCLUDE 'RWMAKE.CH'
#include "protheus.ch"
#include "parmtype.ch"

User Function FFATA008
Local a_Area := GetArea()

MsgRun("Processando a rotina...","Processando",{|| FFATA08P() })

RestArea(a_Area)
Return

// Rotina de execução
Static Function FFATA08P

Local cAliaSB6  := GetNextAlias()

// Verifica os registros da SB6 para realizar uma carga nas tabelas de saldo SB2 e SB8

BeginSql Alias cAliaSB6
    SELECT DISTINCT B6_FILIAL, B6_CLIFOR, B6_LOJA, B6_PRODUTO, A1_FSLOCAL, B6_DOC, B6_SERIE, D2_QUANT, D2_LOTECTL, D2_DTVALID, D2_EMISSAO
    
    FROM %table:SB6% SB6 
        INNER JOIN %table:SA1% SA1 ON A1_COD = B6_CLIFOR AND A1_LOJA = B6_LOJA AND SA1.%NotDel% AND A1_FSLOCAL <> ''
        
        LEFT  JOIN %table:SD2% SD2 ON D2_FILIAL = B6_FILIAL AND D2_DOC = B6_DOC AND D2_SERIE = B6_SERIE AND D2_COD = B6_PRODUTO 
            AND D2_CLIENTE =  B6_CLIFOR AND D2_LOJA = B6_LOJA AND D2_IDENTB6 = B6_IDENT AND SD2.%NotDel%

        INNER JOIN  %table:SF4% SF4 ON B6_TES = F4_CODIGO AND F4_PODER3 = %Exp:"R"% AND F4_FSTIPO = %Exp:"1"%  AND SF4.%NotDel%

    WHERE B6_FILIAL   = %Exp:xFilial("SB6")%  AND 
          B6_TPCF     = %Exp:'C'%             AND    
          B6_PODER3   = %Exp:'R'%             AND 
          SB6.%NotDel%				
    ORDER BY B6_FILIAL, B6_CLIFOR, B6_LOJA, B6_PRODUTO
EndSql 

// Verifica se tem algum registro
While !(cAliaSB6)->( Eof() )
    c_Filial    := (cAliaSB6)->( B6_FILIAL )
    c_Cod       := (cAliaSB6)->( B6_PRODUTO )
    c_Local     := (cAliaSB6)->( A1_FSLOCAL )
    c_Lote      := (cAliaSB6)->( D2_LOTECTL )
    d_DtValid   := Stod((cAliaSB6)->( D2_DTVALID ))
    d_Data      := Stod((cAliaSB6)->( D2_EMISSAO ))

    // Função que valida e realiza a gravação
    U_FFATA009(c_Filial, c_Cod, c_Local, c_Lote, d_DtValid, d_Data)

    (cAliaSB6)->( DbSkip() )
Enddo

(cAliaSB6)->( DBCloseArea() )

Return
