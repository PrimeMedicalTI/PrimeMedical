#include "TOTVS.ch"
#include "TOPCONN.ch"

/*/{Protheus.doc} User Function FESTM099
    Fonte para modificar a movimentação de reavaliação para valorizada
    @type  Function
    @author 
    @since 26/07/2022
    @version 1.0
/*/
User Function FESTM099

Local a_Area := GetArea()

MsgRun("Processando a rotina...","Processando",{|| fsAjuste() })

RestArea(a_Area)

Return

/*/{Protheus.doc} User Function ProcConta
    Fonte que preencher a conta contábil nos produtos e nas notas de entrada e saída
    @type  Function
    @author 
    @since 27/01/2022
    @version 1.0
/*/

Static Function fsAjuste

   Begin Transaction

         c_Query := " SELECT D3_TM, D3_COD, D3_QUANT, D3_CF, D3_LOCAL, D3_CUSTO1, D3_CMFIXO, SD3.R_E_C_N_O_  AS REC, B1_CONTA"
         c_Query += " FROM " + RetSqlName("SD3") + " SD3, " + RetSqlName("SB1") + " SB1 "
         c_Query += " WHERE SD3.D_E_L_E_T_ <> '*' "
         c_Query += " AND SB1.D_E_L_E_T_ <> '*' "
         c_Query += " AND B1_COD = D3_COD "
         c_Query += " AND D3_CUSTO1 <> 0 "
         c_Query += " AND D3_EMISSAO >= '20220801' AND D3_EMISSAO <= '20220831' "
         c_Query += " AND D3_CF IN ('REA', 'DEA') "
         c_Query += " ORDER BY D3_COD, D3_LOCAL "

         Tcquery c_Query new alias "QRY"

         DbSelectArea("QRY")
         QRY->( DbGotop())
         
         While QRY->( !Eof() )

            DbSelectArea("SB9")
            SB9->( DbSetOrder(1))
            SB9->( DbSeek(xFilial("SB9")+QRY->D3_COD+QRY->D3_LOCAL+"20220731"))

            If SB9->( Found())
               DbSelectArea("SD3")
               SD3->( dbGoTo(QRY->REC) )

               RecLock("SD3",.F.)
                  SD3->D3_TM        := If(QRY->D3_TM="499","100","600")
                  SD3->D3_CF        := If(QRY->D3_CF="DEA","DE6","RE6")
                  SD3->D3_CUSTO1    := ((SB9->B9_QINI * QRY->D3_CMFIXO)-SB9->B9_VINI1)
                  SD3->D3_CHAVE     := "E0"
                  SD3->D3_CONTA     := QRY->B1_CONTA
                  SD3->D3_STSERV    := "1"
                  SD3->D3_GARANTI   := "N"
                  SD3->D3_CMFIXO    := 0
               MsUnLock()

            Endif

            QRY->( DbSkip())
         Enddo

         QRY->( DbCloseArea() )

   End Transaction

Return
