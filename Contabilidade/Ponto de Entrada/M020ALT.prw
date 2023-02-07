#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M020ALT   ºAutor  ³                    º Data ³  26/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada na alteração do fornecedor para compati-   º±±
±±º          ³bilizar a classe valor                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³AP                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

	//CTH->CTH_BLOQ	:= SA2->A2_MSBLQL - COMENTADO EM 20/05/2022  POR SOLICITAÇÃO DE ALINE
User Function M020ALT

Local aArea := GetArea()

DbSelectArea("CTH")
CTH->(DbSetOrder(1))

If !(CTH->(DbSeek(xFilial("CTH")+"F"+ALLTRIM(SA2->A2_COD))))	                 
	RecLock("CTH",.T.)
	CTH->CTH_FILIAL	:= xFilial("CTH") 
	CTH->CTH_CLVL	:= "F"+ALLTRIM(SA2->A2_COD)
	CTH->CTH_CLASSE	:= "2"          
	CTH->CTH_DESC01	:= SA2->A2_NOME
	//CTH->CTH_BLOQ	:= SA2->A2_MSBLQL
	CTH->CTH_NORMAL := "1"
	CTH->CTH_DTEXIS := CTOD("01/01/80")     
	CTH->CTH_CLVLLP := "F"+ALLTRIM(SA2->A2_COD)
	CTH->(MsUnLock())          
Else
	RecLock("CTH",.F.)
	CTH->CTH_FILIAL	:= xFilial("CTH") 
	CTH->CTH_CLVL	:= "F"+ALLTRIM(SA2->A2_COD)
	CTH->CTH_CLASSE	:= "2"          
	CTH->CTH_DESC01	:= SA2->A2_NOME
	//CTH->CTH_BLOQ	:= SA2->A2_MSBLQL
	CTH->CTH_NORMAL := "1"
	CTH->CTH_DTEXIS := CTOD("01/01/80")
	CTH->CTH_CLVLLP := "F"+ALLTRIM(SA2->A2_COD)
	CTH->(MsUnLock())          	
EndIF
	
RestArea(aArea)

Return(.T.)                  
