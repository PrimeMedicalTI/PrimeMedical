#INCLUDE "TOTVS.CH"

User Function AtualSE1()
Local c_Query := ""

   Begin Transaction
                 
         c_Query := "Update SE1010 Set E1_NFELETR = F2_NFELETR, " + ;
                "E1_PORTADO = C5_FSBANCO, E1_AGEDEP = C5_FSAGENC, " + ;
                "E1_CONTA = C5_FSCTA from SF2010 F2 (nolock) " + ;
                "Inner Join SE1010 E1 ON E1_FILIAL = F2_FILIAL " + ;
                "AND E1.D_E_L_E_T_ <> '*' AND E1_NUM = F2_DOC " + ;
                "AND E1_SERIE = F2_SERIE AND E1_CLIENTE = F2_CLIENTE " + ;
                "AND E1_LOJA = F2_LOJA Inner Join SC5010 C5 ON C5_FILIAL = F2_FILIAL " + ;
                "AND C5.D_E_L_E_T_ <> '*' AND C5_NUM = F2_PEDIDO " + ;
                "Where F2.D_E_L_E_T_ <> '*' " + ;
                "AND F2_ESPECIE = 'RPS'" + ; 
                "AND ((E1_PORTADO = '') OR (F2_NFELETR <> E1_NFELETR))" 
 
        //Tenta executar o update
        n_Erro := TcSqlExec(c_Query)
     
        //Se houve erro, mostra a mensagem e cancela a transação
        If n_Erro != 0
            MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
            DisarmTransaction()
        Else
           l_AtuNotas := .T. 
        EndIf
   End Transaction

Return()
