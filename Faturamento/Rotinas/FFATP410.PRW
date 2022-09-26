//Bibliotecas
#include "Ap5Mail.ch"
#include "rwmake.ch"
#include "protheus.ch"
#INCLUDE "Report.CH"
#INCLUDE 'TOPCONN.CH'
#Include 'FWMVCDef.ch'
#include "vkey.ch"
#include "TOTVS.CH"
#include "TbiConn.ch"
#include 'FONT.CH'
#include 'COLORS.CH'

#DEFINE ENTER CHR(13)+CHR(10)
/*/{Protheus.doc} U_FFATP410
Rotina executada a partir do PE M410LIOK.
Objetivo:
VALIDAÇÃO DE SALDOS EM ESTOQUE NOS ITENS DO PEDIDO DE VENDAS (SB2 X SB8 X SBF)

Principais parâmetros considerados:
FS_LFT410 - Ativa calculo manual do saldo da SB2 (.T. = calcula por essa rotina .F. = considera SB2).
            O objetivo desse cálculo é garantir a validação levando em consderação o saldo empenhado 
            de pedidos de vendas no campo B2_QPEDVEN
MV_RASTRO - ATIVA CONTROLE DE LOTE NA FILIAL ATIVA
MV_LOCALIZ- ATIVA CONTROLE DE ENDERECO NA FILIAL ATIVA

@type function
@version 12.1.33
@author Eduardo
@since 30/08/2022
@return variant, retorno boleano
/*/
Function U_FFATP410()
Local   l_Ret       :=  .T.
Local   c_Tes       :=  ""
Local   c_Produto   :=  ""
Local   c_Armazem   :=  ""
Local   c_Lote      :=  ""
Local   n_Quantid   :=  0
Local   c_Estoque   :=  "N"
Local   c_Ctrlote   :=  "N"
Local   c_CtrEnder  :=  "N"
Local   c_Mens      :=  ""
Local   n_SaldoEst  :=  0
Local   l_RastroFil :=  .F.
Local   l_EnderFil  :=  .F.
Local   l_CalcSB2   :=  SuperGetMV("FS_LFT410",.F.,.T.) //Ativa calculo manual do saldo da SB2
Local   c_Item      :=  ""
Local   l_Execute   :=  ((INCLUI .Or. ALTERA) .And. Len(aCols) > 0)
If l_Execute
        c_Item      :=  aCols[n][aScan(aHeader,{|x|AllTrim(x[2])=="C6_ITEM"     })]
        l_RastroFil :=  ( Alltrim( SuperGetMV("MV_RASTRO" ,.F.,"N") ) == "S" )
        l_EnderFil  :=  ( Alltrim( SuperGetMV("MV_LOCALIZ",.F.,"N") ) == "S" )
        c_Tes       :=  aCols[n][aScan(aHeader,{|x|AllTrim(x[2])=="C6_TES"      })]
        c_Produto   :=  aCols[n][aScan(aHeader,{|x|AllTrim(x[2])=="C6_PRODUTO"  })]
        c_Ctrlote   :=  Iif(l_RastroFil, Posicione("SB1",1,xFilial("SB1")+c_Produto,"B1_RASTRO") , c_Ctrlote )
        c_CtrEnder  :=  Iif(l_EnderFil , Posicione("SB1",1,xFilial("SB1")+c_Produto,"B1_LOCALIZ"), c_CtrEnder)
        c_Armazem   :=  aCols[n][aScan(aHeader,{|x|AllTrim(x[2])=="C6_LOCAL"    })]
        c_Lote      :=  aCols[n][aScan(aHeader,{|x|AllTrim(x[2])=="C6_LOTECTL"  })]
        c_Endereco  :=  aCols[n][aScan(aHeader,{|x|AllTrim(x[2])=="C6_LOCALIZ"  })]
        n_Quantid   :=  aCols[n][aScan(aHeader,{|x|AllTrim(x[2])=="C6_QTDVEN"   })]
   
    If !Empty(c_Tes) .And. !Empty(c_Produto) .And. !Empty(c_Armazem) 
        c_Estoque   :=  Posicione("SF4",1,xFilial("SF4")+c_Tes,"F4_ESTOQUE")
        If c_Estoque == "S"
            //avaliar saldo do armazem apenas
            SB2->( dbSetOrder(1) )
            If SB2->( !dbSeek(xFilial("SB2") + c_Produto + c_Armazem, .T. ) )
                c_Mens  +=  "Nao encontrado nenhum registro de saldo em estoque para o produto "+Alltrim(c_Produto)+" no armazem "+c_Armazem+" !"          
                l_Ret   :=  .F.
            Else
                n_SaldoEst  :=  SaldoSB2()
                If l_CalcSB2
                    n_SaldoEst := SB2->B2_QATU - SB2->B2_QPEDVEN
                    If ALTERA
                        n_QtdSC6    :=  Posicione("SC6",2,xFilial("SC6")+M->C5_NUM+c_Item+c_Produto,"C6_QTDVEN" )//2-C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO
                        If n_QtdSC6 == 0
                            n_QtdSC6 := f_QtdSC6(xFilial("SC6"),M->C5_NUM,c_Item,c_Produto)
                        Endif
                        n_SaldoEst  :=  n_SaldoEst + n_QtdSC6
                    Endif
                Endif
                If n_SaldoEst < n_Quantid
                    c_Mens  +=  "Produto e Armazém Avaliado: " + c_Produto + " / "+c_Armazem +ENTER
                    c_Mens  +=  "Saldo em Estoque          : " + Alltrim( Str( n_SaldoEst ) ) +ENTER
                    c_Lin   :=  Alltrim( Str( n ) )
                    c_Mens  +=  "Quantidade Linha ("+c_Lin+") : " + Alltrim( Str( n_Quantid ) ) +ENTER
                    c_Mens  +=  "Resultado: Saldo insuficiente para atender a essa linha do pedido."
                    l_Ret   :=  .F.
                Endif
            Endif       

            If l_Ret .And. l_RastroFil .And. !(Empty(c_Ctrlote) .Or. c_Ctrlote == "N") //Possui controle de lote
                //avaliar saldo do armazem por lote ou sub-lote 
                If !Empty(c_Lote)
                    //Avaliando com lote informado na linha do pedido
                    SB8->( dbSetOrder(3) )//3-B8_FILIAL, B8_PRODUTO, B8_LOCAL, B8_LOTECTL, B8_NUMLOTE, B8_DTVALID
                    If SB8->( !dbSeek(xFilial("SB8") +c_Produto +c_Armazem +c_Lote, .T. ) )
                        c_Mens  +=  "Nao encontrado nenhum registro de saldo em estoque por lote para o produto "+Alltrim(c_Produto)+" no armazem "+c_Armazem+" e lote "+c_Lote+" !"
                        l_Ret   :=  .F.
                    Else
                        n_SaldoEst  :=  SB8->B8_SALDO - SB8->B8_EMPENHO
                        If n_SaldoEst < n_Quantid
                            c_Mens  +=  "Avaliação de saldo por produto, armazem e com lote informado no pedido." +ENTER
                            c_Mens  +=  "Produto, Armazém e Lote Avaliado: " + c_Produto + " / "+c_Armazem  + " / "+c_Lote +ENTER
                            c_Mens  +=  "Saldo em Estoque por lote       : " + Alltrim( Str( n_SaldoEst ) ) +ENTER
                            c_Lin   :=  Alltrim( Str( n ) )
                            c_Mens  +=  "Quantidade Linha ("+c_Lin+")    : " + Alltrim( Str( n_Quantid ) ) +ENTER
                            c_Mens  +=  "Resultado: Saldo insuficiente para atender a essa linha do pedido."
                            l_Ret   :=  .F.
                        Endif
                    Endif
                Else
                    //Avaliando sem lote informado na linha do pedido
                    SB8->( dbSetOrder(3) )//3-B8_FILIAL, B8_PRODUTO, B8_LOCAL, B8_LOTECTL, B8_NUMLOTE, B8_DTVALID
                    If SB8->( !dbSeek(xFilial("SB8") +c_Produto +c_Armazem, .T. ) )
                        c_Mens  +=  "Nao encontrado nenhum registro de saldo em estoque por lote para o produto "+Alltrim(c_Produto)+" no armazem "+c_Armazem+" !"
                        l_Ret   :=  .F.
                    Else
                        n_SaldoEst  :=  0
                        While SB8->(!Eof()) .And. SB8->B8_PRODUTO == c_Produto .And. SB8->B8_LOCAL == c_Armazem
                            n_SaldoEst  +=  SB8->B8_SALDO - SB8->B8_EMPENHO
                            SB8->(dbSkip())
                        Enddo 
                        If n_SaldoEst < n_Quantid
                            c_Mens  +=  "Avaliação de saldo por produto, armazem e sem lote informado no pedido." +ENTER
                            c_Mens  +=  "Produto e Armazém Avaliado      : " + c_Produto + " / "+c_Armazem +ENTER
                            c_Mens  +=  "Saldo em Estoque por lote       : " + Alltrim( Str( n_SaldoEst ) ) +ENTER
                            c_Lin   :=  Alltrim( Str( n ) )
                            c_Mens  +=  "Quantidade Linha ("+c_Lin+")    : " + Alltrim( Str( n_Quantid ) ) +ENTER
                            c_Mens  +=  "Resultado: Saldo insuficiente para atender a essa linha do pedido."
                            l_Ret   :=  .F.
                        Endif
                    Endif
                Endif
            Endif

            If l_Ret .And. l_EnderFil .And. c_CtrEnder == "S" //Possui controle de localizacao
                //avaliar saldo do armazem por endereco 
                If !Empty(c_Endereco)
                    //Avaliando com endereco informado na linha do pedido
                    SBF->( dbSetOrder(1) )//1-BF_FILIAL, BF_LOCAL, BF_LOCALIZ, BF_PRODUTO, BF_NUMSERI, BF_LOTECTL, BF_NUMLOTE
                    If SBF->( !dbSeek(xFilial("SBF") +c_Armazem +c_Endereco +c_Produto , .T. ) )
                        c_Mens  +=  "Nao encontrado nenhum registro de saldo em estoque por endereco para o produto "+Alltrim(c_Produto)+" no armazem "+c_Armazem+" e endereco "+c_Endereco+" !"
                        l_Ret   :=  .F.
                    Else
                        n_SaldoEst  :=  SBF->BF_QUANT - SBF->BF_EMPENHO
                        If n_SaldoEst < n_Quantid
                            c_Mens  +=  "Avaliação de saldo por produto, armazem e com endereco informado no pedido." +ENTER
                            c_Mens  +=  "Produto, Armazém e endereco Avaliado: " + c_Produto + " / "+c_Armazem + " / "+c_Endereco  +ENTER
                            c_Mens  +=  "Saldo em Estoque por endereco       : " + Alltrim( Str( n_SaldoEst ) ) +ENTER
                            c_Lin   :=  Alltrim( Str( n ) )
                            c_Mens  +=  "Quantidade Linha ("+c_Lin+")    : " + Alltrim( Str( n_Quantid ) ) +ENTER
                            c_Mens  +=  "Resultado: Saldo insuficiente para atender a essa linha do pedido."
                            l_Ret   :=  .F.
                        Endif
                    Endif
                Else
                    //Avaliando sem endereco informado na linha do pedido
                    SBF->( dbSetOrder(2) )//1-BF_FILIAL, BF_PRODUTO, BF_LOCAL, BF_LOTECTL, BF_NUMLOTE, BF_PRIOR, BF_LOCALIZ, BF_NUMSERI
                    If SBF->( !dbSeek(xFilial("SBF") +c_Produto +c_Armazem, .T. ) )
                        c_Mens  +=  "Nao encontrado nenhum registro de saldo em estoque por endereco para o produto "+Alltrim(c_Produto)+" no armazem "+c_Armazem+" !"
                        l_Ret   :=  .F.
                    Else
                        n_SaldoEst  :=  0
                        While SBF->(!Eof()) .And. SBF->BF_PRODUTO == c_Produto .And. SBF->BF_LOCAL == c_Armazem
                            n_SaldoEst  +=  SBF->BF_QUANT - SBF->BF_EMPENHO
                            SBF->(dbSkip())
                        Enddo 
                        If n_SaldoEst < n_Quantid
                            c_Mens  +=  "Avaliação de saldo por produto, armazem e sem endereco informado no pedido." +ENTER
                            c_Mens  +=  "Produto e Armazém Avaliado      : " + c_Produto + " / "+c_Armazem +ENTER
                            c_Mens  +=  "Saldo em Estoque por endereco   : " + Alltrim( Str( n_SaldoEst ) ) +ENTER
                            c_Lin   :=  Alltrim( Str( n ) )
                            c_Mens  +=  "Quantidade Linha ("+c_Lin+")    : " + Alltrim( Str( n_Quantid ) ) +ENTER
                            c_Mens  +=  "Resultado: Saldo insuficiente para atender a essa linha do pedido."
                            l_Ret   :=  .F.
                        Endif
                    Endif
                Endif
            Endif
        Endif
    Endif
Endif

If !l_Ret .And. !Empty(c_Mens)
    Help( ,, 'Atencao- objeto: FFATP410',, c_Mens, 1, 0 )
Endif

Return(l_Ret)

/*/{Protheus.doc} f_QtdSC6
Quantidade do item do pedido registrado na tabela SC6.

@type function
@version 12.1.33
@author Eduardo
@since 30/08/2022
/*/
Static Function f_QtdSC6(c_Filial,c_Numped,c_ItemPed,c_Prod) //Posicione("SC6",2,xFilial("SC6")+M->C5_NUM+c_Item+c_Produto,"C6_QTDVEN" )//2-C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO
Local   n_Quant     :=  0
Local   c_SC6Alias  :=  GetNextAlias()

BEGINSQL ALIAS c_SC6Alias
    SELECT C6_QTDVEN
    FROM %table:SC6% SC6
    WHERE
        SC6.%notDel%
    AND SC6.C6_FILIAL   =   %exp:c_Filial%
    AND SC6.C6_NUM      =   %exp:c_Numped%
    AND SC6.C6_ITEM     =   %exp:c_ItemPed%
    AND SC6.C6_PRODUTO  =   %exp:c_Prod%
ENDSQL

If (c_SC6Alias)->(!Eof())
    n_Quant := (c_SC6Alias)->C6_QTDVEN
Endif

(c_SC6Alias)->(DBCloseArea()())

Return(n_Quant)
