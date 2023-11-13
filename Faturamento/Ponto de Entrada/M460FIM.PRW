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
