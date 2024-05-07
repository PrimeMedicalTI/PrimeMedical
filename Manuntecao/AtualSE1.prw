#INCLUDE "TOTVS.CH"

User Function AtualSE1()
Local c_Query := ""

   Begin Transaction
                 
         c_Query := "Update SE1010 Set E1_FSNATUR = ED_DESCRIC " + ;
         "from SE1010 E1 " + ;
         "Inner Join SED010 SED ON SED.ED_FILIAL = '' AND SED.D_E_L_E_T_ <> '*' AND ED_CODIGO = E1_NATUREZ " + ;
         "Where 1=1 AND E1.D_E_L_E_T_ <> '*' AND E1_FSNATUR <> ED_DESCRIC"
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
