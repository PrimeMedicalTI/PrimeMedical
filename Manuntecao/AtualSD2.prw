#INCLUDE "TOTVS.CH"

User Function AtualSD2()
Local c_Query := ""

   Begin Transaction
                 
         c_Query := "Update SC5010 Set C5_FSNOME = Upper(USR_I.USR_CODIGO) " + ;
                  "from SC5010 " + ;
                  "LEFT JOIN SYS_USR USR_I ON ( " + ;
                  "    USR_I.USR_ID = LEFT( " + ;
                  "        SUBSTRING(C5_USERLGI, 11, 1) + " + ;
                  "        SUBSTRING(C5_USERLGI, 15, 1) + " + ;
                  "        SUBSTRING(C5_USERLGI, 19, 1) + " + ;
                  "        SUBSTRING(C5_USERLGI, 02, 1) + " + ;
                  "        SUBSTRING(C5_USERLGI, 06, 1) + " + ;
                  "        SUBSTRING(C5_USERLGI, 10, 1) + " + ;
                  "        SUBSTRING(C5_USERLGI, 14, 1) + " + ;
                  "        SUBSTRING(C5_USERLGI, 01, 1) + " + ;
                  "        SUBSTRING(C5_USERLGI, 18, 1) + " + ;
                  "        SUBSTRING(C5_USERLGI, 05, 1) + " + ;
                  "        SUBSTRING(C5_USERLGI, 09, 1) + " + ;
                  "        SUBSTRING(C5_USERLGI, 13, 1) + " + ;
                  "        SUBSTRING(C5_USERLGI, 17, 1) + " + ;
                  "        SUBSTRING(C5_USERLGI, 04, 1) + " + ;
                  "        SUBSTRING(C5_USERLGI, 08, 1), " + ;
                  "    6) " + ;
                  ") " + ;
                  "Where Upper(USR_I.USR_CODIGO) is not null " + ;
                  "AND C5_FSNOME <> Upper(USR_I.USR_CODIGO)"
         n_Erro := TcSqlExec(c_Query)

         c_Query := "Update SD2010 Set D2_FSURSPE = C5.C5_FSNOME " + ;
                  "from SD2010 D2 (nolock) " + ;
                  "Inner Join SC6010 C6 (nolock) ON C6_FILIAL = D2_FILIAL AND " + ;
                  "                            C6.D_E_L_E_T_ <> '*' AND " + ;
                  "                            C6_PRODUTO = D2_COD AND " + ;
                  "                            C6_NUM = D2_PEDIDO AND " + ;
                  "                            C6_ITEM = D2_ITEMPV " + ;
                  "Inner Join SC5010 C5 (nolock) ON C5_FILIAL = C6_FILIAL AND " + ;
                  "                               C5.D_E_L_E_T_ <> '*' AND " + ;
                  "                               C5_NUM = C6_NUM " + ;
                  "Where D2.D_E_L_E_T_ <> '*' AND " + ;
                  "      Isnull(D2_FSURSPE, '') <> C5.C5_FSNOME"
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
