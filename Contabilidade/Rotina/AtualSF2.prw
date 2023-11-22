#INCLUDE "TOTVS.CH"

User Function AtualSF2()
Local c_Query := ""

   Begin Transaction
         // Monta o novo Update
         c_Query := "Update SF2010 Set F2_DTLANC = '' " + ;
                    "FROM SF2010 Nota (nolock) " + ;
                    "INNER JOIN SA1010 Cliente (nolock) ON A1_FILIAL = '' " + ;
                    "AND Cliente.D_E_L_E_T_ <> '*' " + ;
                    "AND A1_COD = F2_CLIENTE " + ;
                    "AND A1_LOJA = F2_LOJA " + ;
                    "Inner JOIN SD2010 Item (nolock) ON D2_FILIAL = '010101' " + ;
                    "AND Item.D_E_L_E_T_ <> '*' " + ;
                    "AND D2_DOC = F2_DOC " + ;
                    "AND D2_SERIE = F2_SERIE " + ;
                    "AND D2_TIPO = F2_TIPO " + ;
                    "AND D2_CLIENTE = F2_CLIENTE " + ;
                    "AND D2_LOJA = F2_LOJA " + ;
                    "AND D2_CF in ('5927', '5152', '6152') " + ;
                    "Where 1=1 " + ;
                    "AND F2_FILIAL = '010101' " + ;
                    "AND Year(F2_EMISSAO) = 2023 " + ;
                    "AND Nota.D_E_L_E_T_ <> '*'"

        // Tenta executar o update
        n_Erro := TcSqlExec(c_Query)
     
        // Se houve erro, mostra a mensagem e cancela a transação
        If n_Erro != 0
            MsgStop("Erro na execução da query: " + TcSqlError(), "Atenção")
            DisarmTransaction()
        Else
           l_AtuNotas := .T. 
        EndIf
   End Transaction

Return()
