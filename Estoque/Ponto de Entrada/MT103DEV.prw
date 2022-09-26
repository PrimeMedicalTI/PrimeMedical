#include "rwmake.ch"
#Include 'Protheus.ch'
#INCLUDE "topconn.ch"
#include "TOTVS.CH"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma ³MT103LDVº Autor ³Elisângela Souza       º Data ³  07/07/17  º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³Ponto de Entrada para inibir a alteração Codigo do Documentoº±±
±±º          ³na rotina de Transferencia.                                 º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÌÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±º                    A T U A L I Z A C O E S                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDATA      |PROGRAMADOR       |ALTERACOES                               º±±
±±º          |                  |                                         º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
// https://tdn.totvs.com/pages/releaseview.action?pageId=393366406

User Function MT103DEV()

Local dDtDe     := PARAMIXB[1]
Local dDtAte    := PARAMIXB[2]
Local cCliente  := PARAMIXB[3]
Local cLoja     := PARAMIXB[4]
Local cFieldQry := PARAMIXB[5]
Local cQuery    := ""

Local a_SaveArea  := GetArea()
Local oFont       := TFont():New('Courier new',,-16,.F.)
Local aItems      := {'Venda','Consigna��o','Todos'}
   
Private l_Ret	:= .F.
Private o_Dlg
Private c_Query := ""

//Alert(c_Query)

// cria di�logo
DEFINE MSDIALOG o_Dlg TITLE "Tipo de Nota" FROM 000, 000  TO 200, 300 COLORS 0, 16777215 PIXEL
 
// Usando o m�todo New
oSay1:= TSay():New(20,02,{||'Tipo:'},o_Dlg,,oFont,,,,.T.,CLR_RED,CLR_WHITE,200,20)

// Combo Box
cCombo1:= aItems[1]   
oCombo1 := TComboBox():New(20,30,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},aItems,65,10,o_Dlg,,,,,,.T.,,,,,,,,,'cCombo1')
oCombo1:bGetKey := {|self,cText,nkey|texto(self,cText,nkey,o_Dlg)}

//SButton():New( 50,070,01,{||cQuery:= U_SelNota(dDtDe, dDtAte, cCliente, cLoja, cFieldQry, cCombo1)},o_Dlg,.T.,,)
SButton():New( 50,070,01,{||o_Dlg:End(),cQuery:= SelNota(dDtDe, dDtAte, cCliente, cLoja, cFieldQry, cCombo1)},o_Dlg,.T.,,)
//SButton():New( 50,100,02,{||Close(o_Dlg)},o_Dlg,.T.,,)
       
ACTIVATE MSDIALOG o_Dlg CENTERED

RestArea(a_SaveArea)

Return (cQuery)

// Fun��o que realiza o filtro conforme a op��o do combo box
Static Function SelNota(dDtDe, dDtAte, cCliente, cLoja, cFieldQry, cCombo1)

Local c_Tipo  := cCombo1

c_Query := " SELECT DISTINCT " + cFieldQry //Cabe�alho da "Query" obrigat�rio do par�metro "PARAMIXB[5]"
c_Query += " FROM   " + RetSqlName("SF2") + " SF2, " + RetSqlName("SD2") + " SD2, " + RetSqlName("SF4") + " SF4"
c_Query += " WHERE F2_FILIAL = '" + xFilial("SF2") + "'"
c_Query += " AND F2_EMISSAO BETWEEN '" + DtoS(dDtDe) + "' AND '" + DtoS(dDtAte) + "'"
c_Query += " AND F2_CLIENTE     = '" + cCliente + "'" 
c_Query += " AND F2_LOJA        = '" + cLoja + "'" 
c_Query += " AND F2_FILIAL      = D2_FILIAL "
c_Query += " AND F2_DOC         = D2_DOC "
c_Query += " AND F2_CLIENTE     = D2_CLIENTE "
c_Query += " AND F2_LOJA        = D2_LOJA "
c_Query += " AND F4_FILIAL      = '" + xFilial("SF4") + "'"
c_Query += " AND F2_TIPO NOT IN ('D') "
c_Query += " AND F2_FLAGDEV     <> '1' "
c_Query += " AND F4_CODIGO      = D2_TES "
c_Query += " AND SD2.D_E_L_E_T_ <> '*' " 
c_Query += " AND SF2.D_E_L_E_T_ <> '*' "
c_Query += " AND SF4.D_E_L_E_T_ <> '*' "

If c_Tipo = "Consigna��o"
    c_Query += " AND F4_PODER3 = 'R' "  
ElseIf c_Tipo = "Venda"
    c_Query += " AND F4_PODER3 = 'N' "  
Endif

Close(o_Dlg)

Return c_Query
