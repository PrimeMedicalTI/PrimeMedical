#include "TOTVS.ch"

/*/{Protheus.doc} User Function M460FIM
    (Ponto de entrada para gravar no cabeçalho da nota o numero do pedido.)
    @type  Function
    @author William Furtado
    @since 05/01/2022
    @version 1.0
/*/
User Function M460FIM()
    Local cPedido  := ''
    
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

    // Inserido em 05/05/2022 - Elisângela Souza
    // Grava registros nas tabelas SB2 e SB8
    If SF2->F2_TIPO = "N" // normal

        // Posiciona no cadastro de cliente
        DbSelectArea("SA1")
        SA1->( DbSetOrder(1))
        SA1->( DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))

        c_Local := SA1->A1_FSLOCAL

        If !Empty(c_Local)
            // Posiciona nos itens da nota fiscal
            DbSelectArea("SD2")
            SD2->( DbSetOrder(3))
            SD2->( DbSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))

            c_Filial    := SF2->F2_FILIAL
            c_Doc       := SF2->F2_DOC
            c_Serie     := SF2->F2_SERIE
            c_Cliente   := SF2->F2_CLIENTE
            c_Loja      := SF2->F2_LOJA

            While SD2->( !Eof()) .And. c_Filial  = SF2->F2_FILIAL  .And. c_Doc  = SF2->F2_DOC .And. c_Serie = SF2->F2_SERIE .And. ;
                                    c_Cliente = SF2->F2_CLIENTE .And. c_Loja = SF2->F2_LOJA
                c_TES   := SD2->D2_TES

                // Posiciona no cadastro de TES
                DbSelectArea("SF4")
                SF4->( DbSetOrder(1))
                SF4->( DbSeek(xFilial("SF4")+c_TES))

                If SF4->F4_PODER3 = "R" .And. SF4->F4_FSTIPO = "1" // Remessa Consignado 
                    // Função que valida e realiza a gravação
                    U_FFATA009(SD2->D2_FILIAL, SD2->D2_COD, c_Local, SD2->D2_LOTECTL, SD2->D2_DTVALID, SD2->D2_EMISSAO)
                Endif
                
                SD2->( DbSkip() )
            Enddo
        Endif    
    Endif

Return
