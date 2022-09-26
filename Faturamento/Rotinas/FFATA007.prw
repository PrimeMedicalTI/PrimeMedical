#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch" 

// ---------------------------------------------------------------------------------------------------------------------
// EXECBLOCK   - Rotina para validar a edi��o do campo pre�o de venda no pedido de venda, se o pedido for de faturamento
//               com origem na op��o retornar da consigna��o o pre�o n�o pode ser modificado.
// Elis�ngela Souza - Janeiro/2022
// CLIENTE     - Prime
// ---------------------------------------------------------------------------------------------------------------------

User Function FFATA007()

Local a_Area    := GetARea()
Local l_Ret     := .T.
Local c_Tipo    := M->C5_TIPO
Local c_NumDoc  := aCols[n][aScan(aHeader,{|x|AllTrim(x[2])=="C6_FSNFDEV"})]

If  c_Tipo = "N" .And. !Empty(c_NumDoc) 
    l_Ret := .F.
Endif

RestArea(a_Area)

Return(l_Ret)
