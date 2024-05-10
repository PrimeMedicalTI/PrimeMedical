#Include "TOPCONN.CH"
 
/*------------------------------------------------------------------------------------------------------*
 | P.E.:  M460FIM                                                                                       |
 | Desc:  Gravação dos dados após gerar NF de Saída                                                     |
 | Links: http://tdn.totvs.com/pages/releaseview.action?pageId=6784180                                  |
 *------------------------------------------------------------------------------------------------------*/
 
User Function M460FIM()
    Local cPedido  := '' 
    Local c_Query := ""   
    Local aAreaSF2 := SF2->(GetArea())
    Local aAreaSD2 := sd2->(GetArea())
    Local aAreaSC5 := sc5->(GetArea())
    Local aAreaSE1 := sE1->(GetArea())
    Local aAreaSA1 := sA1->(GetArea())
    
    //Pega o pedido
    DbSelectArea("SD2")
    SD2->(DbSetorder(3))
    If SD2->(DbSeek(SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))
        cPedido := SD2->D2_PEDIDO
    Endif          
     
    //Se tiver pedido
    If !Empty(cPedido)
        DbSelectArea("SC5")
        SC5->(DbSetorder(1))
         
        //Se posiciona pega o tipo de pagamento
        If SC5->(DbSeek(FWxFilial('SC5')+cPedido))
            Reclock("SF2",.F.)
            SF2->F2_PEDIDO  := SC5->C5_NUM
            SF2->F2_FSCADM  := SC5->C5_FSCADM
            SF2->F2_PACIENT := SC5->C5_PACIENT
            SF2->F2_FSCCONV := SC5->C5_FSCCONV 
            SF2->F2_CONVENI := SC5->C5_CONVENI
            SF2->F2_DTPROCE := SC5->C5_DTPROCE
            SF2->F2_MENNOTA := SC5->C5_MENNOTA
            SF2->F2_FSNOME  := Upper(cUserName)            
            MsUnlock()
        Endif        
    Endif 

   // Atualizar Titulos de Serviços **************************************************************

   Begin Transaction 

        c_Query := "Update SFT010 Set D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ " + ;
                  "Where FT_SERIE = 'A' AND D_E_L_E_T_ <> '*'"
        n_Erro := TcSqlExec(c_Query)

        c_Query := "Update SF3010 Set D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ " + ;
                "Where F3_SERIE = 'A' AND D_E_L_E_T_ <> '*'"
        n_Erro := TcSqlExec(c_Query)               

        c_Query := "Update SB1010 Set B1_CODAPEL = Rtrim(Ltrim(Substring(B1_COD,1,Len(B1_COD)-1))) " + ;
          "Where B1_COD like '%.'"
        n_Erro := TcSqlExec(c_Query)

        c_Query := "Update SE5010 Set E5_FSMUN = A1_MUN, E5_FSUF = A1_EST " + ;
          "from SE5010 E5 " + ;
          "Inner Join SA1010 A1 ON A1_COD = E5_CLIENTE AND A1_LOJA = E5_LOJA AND A1.D_E_L_E_T_ <> '*' " + ;
          "Where E5.D_E_L_E_T_ <> '*' AND E5_RECPAG = 'R' AND Year(E5_DATA) = Year(GetDate()) AND E5_FSMUN = ''"
        n_Erro := TcSqlExec(c_Query)

        c_Query := "Update SE5010 Set E5_FSMUN = A2_MUN, E5_FSUF = A2_EST " + ;
                "from SE5010 E5 " + ;
                "Inner Join SA2010 A2 ON A2_COD = E5_FORNECE AND A2_LOJA = E5_LOJA AND A2.D_E_L_E_T_ <> '*' " + ;
                "Where E5.D_E_L_E_T_ <> '*' AND E5_RECPAG = 'P' AND Year(E5_DATA) = Year(GetDate()) AND E5_FSMUN = ''"
        n_Erro := TcSqlExec(c_Query)

        c_Query := "Update SE1010 Set E1_PORTADO = C5_FSBANCO, " + ;
           "E1_AGEDEP = C5_FSAGENC, E1_CONTA = C5_FSCTA from SF2010 F2 (nolock) " + ;
           "Inner Join SE1010 E1 (nolock) ON E1_FILIAL = F2_FILIAL " + ;
           "AND E1.D_E_L_E_T_ <> '*' AND E1_NUM = F2_DOC " + ;
           "AND E1_SERIE = F2_SERIE AND E1_CLIENTE = F2_CLIENTE " + ;
           "AND E1_LOJA = F2_LOJA AND E1_FSFORMA = 'BOL' " + ;
           "AND (E1_PORTADO = '') AND E1_BAIXA = '' " + ;
           "Inner Join SC5010 C5 (nolock) ON C5_FILIAL = F2_FILIAL " + ;
           "AND C5.D_E_L_E_T_ <> '*' AND C5_NUM = F2_PEDIDO " + ;
           "AND C5_FSBANCO <> '' Where F2.D_E_L_E_T_ <> '*'"
        n_Erro := TcSqlExec(c_Query)

         c_Query := "Update SE1010 Set E1_NFELETR = F2_NFELETR, " + ;
                "E1_PORTADO = C5_FSBANCO, E1_AGEDEP = C5_FSAGENC, " + ;
                "E1_CONTA = C5_FSCTA from SF2010 F2 (nolock) " + ;
                "Inner Join SE1010 E1 (nolock) ON E1_FILIAL = F2_FILIAL " + ;
                "AND E1.D_E_L_E_T_ <> '*' AND E1_NUM = F2_DOC " + ;
                "AND E1_SERIE = F2_SERIE AND E1_CLIENTE = F2_CLIENTE " + ;
                "AND E1_LOJA = F2_LOJA Inner Join SC5010 C5 (nolock) ON C5_FILIAL = F2_FILIAL " + ;
                "AND C5.D_E_L_E_T_ <> '*' AND C5_NUM = F2_PEDIDO " + ;
                "Where F2.D_E_L_E_T_ <> '*' " + ;
                "AND F2_ESPECIE = 'RPS'" + ; 
                "AND ((E1_PORTADO = '') OR (F2_NFELETR <> E1_NFELETR))"         
        n_Erro := TcSqlExec(c_Query)

        c_Query2 := "Update SB1010 Set B1_UCOM = DataUltimaNota, B1_UPRC = ValorUltimaNota " + ;
           "from SB1010 B1 (nolock) " + ;
           "Inner Join ( " + ;
           "   Select D1.D1_COD, D1_DTDIGIT as DataUltimaNota, Round((D1_VUNIT),2) as ValorUltimaNota " + ;
           "   from SD1010 D1 (nolock) " + ;
           "   INNER JOIN SF1010 Nota (nolock) ON Nota.D_E_L_E_T_ <> '*' " + ;
           "   AND F1_DOC = D1_DOC " + ;
           "   AND F1_SERIE = D1_SERIE " + ;
           "   AND F1_TIPO = D1_TIPO " + ;
           "   AND F1_FORNECE = D1_FORNECE " + ;
           "   AND F1_LOJA = D1_LOJA " + ;
           "   Inner Join ( " + ;
           "      Select BM_GRUPO, BM_DESC, D1_COD, Rtrim(B1_DESC) AS Produto, Max(D1.R_E_C_N_O_) as Recno " + ;
           "      from SD1010 D1 (nolock) " + ;
           "      INNER JOIN SB1010 Produto (nolock) ON B1_FILIAL = '' " + ;
           "      AND Produto.D_E_L_E_T_ <> '*' " + ;
           "      AND B1_COD = D1.D1_COD " + ;
           "      INNER JOIN SBM010 Grupo (nolock) ON BM_FILIAL = '' " + ;
           "      AND Grupo.D_E_L_E_T_ <> '*' " + ;
           "      AND BM_GRUPO = B1_GRUPO " + ;
           "      INNER JOIN SF4010 TipoEntrada (nolock) ON TipoEntrada.F4_FILIAL = '' " + ;
           "      AND TipoEntrada.D_E_L_E_T_ <> '*' " + ;
           "      AND TipoEntrada.F4_CODIGO = D1_TES " + ;
           "      AND TipoEntrada.F4_ESTOQUE = 'S' " + ;
           "      AND TipoEntrada.F4_DUPLIC = 'S' " + ;
           "      AND TipoEntrada.F4_TIPO = 'E' " + ;
           "      Inner Join SX5010 CFOP (nolock) ON X5_FILIAL = '' " + ;
           "      AND CFOP.D_E_L_E_T_ <> '*' " + ;
           "      AND X5_TABELA = '13' " + ;
           "      AND X5_CHAVE = TipoEntrada.F4_CF " + ;
           "      where 1=1 " + ;
           "      AND D1.D_E_L_E_T_ <> '*' " + ;
           "      AND D1_TIPO = 'N' " + ;
           "      AND X5_DESCRI like '%COMPRA%' " + ;
           "      Group by BM_GRUPO, BM_DESC, D1_COD, B1_DESC " + ;
           "   ) UltimaNota ON UltimaNota.Recno = D1.R_E_C_N_O_ " + ;
           ") ULtimaNota ON ULtimaNota.D1_COD = B1_COD " + ;
           "Where Round(B1_UPRC,2) <> ValorUltimaNota"
         n_Erro := TcSqlExec(c_Query2)

         // Atualizar o Usuário que fez o Pedido na SD2 ****************************************************************************************
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

         // Update SE5010 (Movimentos Bancarios) para deletar registros vindo do banco e Sheila não reconcilia ***************************************
         c_Query := "Update SE5010 Set D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ " + ;
         "from SE5010 E5 (nolock) " + ;
         "Where D_E_L_E_T_ <> '*' AND E5_RECONC = '' AND E5_RECPAG = 'R' AND E5_NATUREZ like 'DESP%' " + ;
         "AND Year(E5_DATA) >= 2024 AND Convert(Datetime,E5_DATA,112) <= GetDate() - 1"
         n_Erro := TcSqlExec(c_Query)

         // Colocar a Natureza na SF1 ***********************************************************************************************************
         c_Query := "Update SE1010 Set E1_FSNATUR = ED_DESCRIC " + ;
         "from SE1010 E1 " + ;
         "Inner Join SED010 SED ON SED.ED_FILIAL = '' AND SED.D_E_L_E_T_ <> '*' AND ED_CODIGO = E1_NATUREZ " + ;
         "Where 1=1 AND E1.D_E_L_E_T_ <> '*' AND E1_FSNATUR <> ED_DESCRIC"
         n_Erro := TcSqlExec(c_Query)  

        If n_Erro != 0
            MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
            DisarmTransaction()
        Else
           l_AtuNotas := .T. 
        EndIf
   End Transaction 

    RestArea(aAreaSF2)
    RestArea(aAreaSD2)
    RestArea(aAreaSC5)
    RestArea(aAreaSE1)
    RestArea(aAreaSA1)
  
Return
