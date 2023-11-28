#INCLUDE "TOTVS.CH"

User Function AtualSF1()
Local c_Query := ""

   Begin Transaction
         // Monta o novo Update para SF1010
         c_Query := "Update SF1010 Set F1_DTLANC = '' " + ;
                    "from SD1010 DevItem (nolock) " + ;
                    "INNER JOIN SF1010 Nota (nolock) ON F1_FILIAL = '010101' " + ;
                    "AND Nota.D_E_L_E_T_ <> '*' " + ;
                    "AND F1_DOC = D1_DOC " + ;
                    "AND F1_SERIE = D1_SERIE " + ;
                    "AND F1_TIPO = D1_TIPO " + ;
                    "AND F1_FORNECE = D1_FORNECE " + ;
                    "AND F1_LOJA = D1_LOJA " + ;
                    "Where 1=1 " + ;
                    "AND D1_FILIAL = '010101' " + ;
                    "AND D1_CF in ('1152', '2152') " + ;
                    "AND Year(D1_DTDIGIT) = 2023 " + ;
                    "AND DevItem.D_E_L_E_T_ <> '*'"

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
