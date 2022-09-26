#include "TOTVS.ch"
#include "TOPCONN.ch"

/*/{Protheus.doc} User Function FESTM001
    Fonte para preencher a conta contábil nos produtos e nas notas de entrada e saída e nos livros fiscais(SFT)
    @type  Function
    @author 
    @since 27/01/2022
    @version 1.0
/*/
User Function FESTM001
Local a_Area := GetArea()

MsgRun("Processando a rotina...","Processando",{|| ProcConta() })

RestArea(a_Area)
Return

/*/{Protheus.doc} User Function ProcConta
    Fonte que preencher a conta contábil nos produtos e nas notas de entrada e saída
    @type  Function
    @author 
    @since 27/01/2022
    @version 1.0
/*/

Static Function ProcConta
Local c_Conta    := ""
Local c_Grupo    := ""
Local c_Query    := ""
Local n_Erro     := 0
Local l_AtuNotas := .F.
Local c_Prod     := ""

dbSelectArea("SBM")
dbGoTop()
dbSetOrder(1)

Do While !Eof()
   
   c_Conta := SBM->BM_CONTA
   c_Grupo := SBM->BM_GRUPO

   Begin Transaction
         //Monta o Update
         c_Query := " UPDATE " + RetSqlName("SB1") + " "
         c_Query += "     SET B1_CONTA = '" + c_Conta + "' "
         c_Query += " WHERE "
         c_Query += "     B1_FILIAL = '" + FWxFilial('SB1') + "' "
         c_Query += "     AND B1_GRUPO = '" + c_Grupo + "' "
         c_Query += "     AND B1_CONTA = ' ' " 
         c_Query += "     AND D_E_L_E_T_ = ' ' "
 
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

   dbSelectArea("SBM")
   dbSkip()
EndDo

If l_AtuNotas
   n_Erro := 0 
   dbSelectArea("SB1")
   dbGoTop()
   dbSetOrder(1)

   Do While !Eof()
      c_Prod  := SB1->B1_COD
      c_Conta := SB1->B1_CONTA

      If !Empty(SB1->B1_GRUPO) .And. !Empty(SB1->B1_CONTA)
         Begin Transaction
            //Monta o Update
            c_Query := " UPDATE " + RetSqlName("SD1") + " "
            c_Query += "     SET D1_CONTA = '" + c_Conta + "' "
            c_Query += " WHERE "
            c_Query += "     D1_FILIAL = '" + FWxFilial('SD1') + "' "
            c_Query += "     AND D1_CONTA = ' ' "
            c_Query += "     AND D1_COD = '" + c_Prod + "' "
            c_Query += "     AND D_E_L_E_T_ = ' ' "
 
            //Tenta executar o update
            n_Erro := TcSqlExec(c_Query)
     
            //Se houve erro, mostra a mensagem e cancela a transação
            If n_Erro != 0
               MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
               DisarmTransaction()
            EndIf
         End Transaction

         Begin Transaction
            //Monta o Update
            c_Query := " UPDATE " + RetSqlName("SD2") + " "
            c_Query += "     SET D2_CONTA = '" + c_Conta + "' "
            c_Query += " WHERE "
            c_Query += "     D2_FILIAL = '" + FWxFilial('SD2') + "' "
            c_Query += "     AND D2_CONTA = ' ' "
            c_Query += "     AND D2_COD = '" + c_Prod + "' "
            c_Query += "     AND D_E_L_E_T_ = ' ' "
 
            //Tenta executar o update
            n_Erro := TcSqlExec(c_Query)
     
            //Se houve erro, mostra a mensagem e cancela a transação
            If n_Erro != 0
               MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
               DisarmTransaction()
            EndIf
         End Transaction

         Begin Transaction
            //Monta o Update
            c_Query := " UPDATE " + RetSqlName("SFT") + " "
            c_Query += "     SET FT_CONTA = '" + c_Conta + "' "
            c_Query += " WHERE "
            c_Query += "     FT_FILIAL = '" + FWxFilial('SFT') + "' "
            c_Query += "     AND FT_CONTA = ' ' "
            c_Query += "     AND FT_PRODUTO = '" + c_Prod + "' "
            c_Query += "     AND D_E_L_E_T_ = ' ' "
 
            //Tenta executar o update
            n_Erro := TcSqlExec(c_Query)
     
            //Se houve erro, mostra a mensagem e cancela a transação
            If n_Erro != 0
               MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
               DisarmTransaction()
            EndIf
         End Transaction
      EndIf

      dbSelectArea("SB1")
      dbSkip()
   EndDo 
EndIf

Return
