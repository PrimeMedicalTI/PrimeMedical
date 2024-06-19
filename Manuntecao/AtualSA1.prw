#INCLUDE "TOTVS.CH"

User Function AtualSA1()
Local c_Query := ""

   Begin Transaction
                 
        // Update SA1010 (Clientes) para atualizar o bairro com base no CEP e UF da tabela ZZ9010 *******************************************
         c_Query := "Update SA1010 Set A1_BAIRRO = ZZ9_BAIRRO " + ;
                  "from SA1010 (nolock) " + ;
                  "Inner Join ZZ9010 (nolock) ON ZZ9_CEP = A1_CEP " + ;
                  "AND ZZ9_UF = A1_EST " + ;
                  "Where A1_BAIRRO <> ZZ9_BAIRRO"
         n_Erro := TcSqlExec(c_Query)

        //Se houve erro, mostra a mensagem e cancela a transação
        If n_Erro != 0
            MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
            DisarmTransaction()
        Else
           l_AtuNotas := .T. 
           MsgAlert("Terminou", "Atenção")
                                                                                                                                                                                                                                                                                                                                                                                                                                       
        EndIf
   End Transaction

Return()
