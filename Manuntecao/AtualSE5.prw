#INCLUDE "TOTVS.CH"

User Function AtualSE5()
Local c_Query := ""

   Begin Transaction
                 
        c_Query := "Update SE5010 Set E5_FSMUN = A1_MUN, E5_FSUF = A1_EST " + ;
          "from SE5010 E5 " + ;
          "Inner Join SA1010 A1 ON A1_COD = E5_CLIENTE AND A1_LOJA = E5_LOJA AND A1.D_E_L_E_T_ <> '*' " + ;
          "Where E5.D_E_L_E_T_ <> '*' AND E5_RECPAG = 'R' AND E5_FSMUN = ''"
        n_Erro := TcSqlExec(c_Query)

        c_Query := "Update SE5010 Set E5_FSMUN = A2_MUN, E5_FSUF = A2_EST " + ;
                "from SE5010 E5 " + ;
                "Inner Join SA2010 A2 ON A2_COD = E5_FORNECE AND A2_LOJA = E5_LOJA AND A2.D_E_L_E_T_ <> '*' " + ;
                "Where E5.D_E_L_E_T_ <> '*' AND E5_RECPAG = 'P' AND E5_FSMUN = ''"
        n_Erro := TcSqlExec(c_Query)
     
        //Se houve erro, mostra a mensagem e cancela a transa��o
        If n_Erro != 0
            MsgStop("Erro na execu��o da query: "+TcSqlError(), "Aten��o")
            DisarmTransaction()
        Else
           l_AtuNotas := .T. 
           MsgAlert("Terminou", "Aten��o")
        EndIf
   End Transaction

Return()
