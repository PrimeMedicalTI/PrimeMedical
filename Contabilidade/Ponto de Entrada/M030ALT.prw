#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M030ALT   ºAutor  ³Ihorran Milholi     º Data ³  16/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada na alteração do cliente para compati-      º±±
±±º          ³bilizar a classe valor                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³AP                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


// CTH->CTH_BLOQ	:= SA1->A1_MSBLQL   - Comentado em 20/05/2022 por solicitação de Aline
User Function M030ALT           

Local aArea := GetArea()	

DbSelectArea("CTH")                                	
CTH->(DbSetOrder(1))

If !(CTH->(DbSeek(xFilial("CTH")+"C"+ALLTRIM(SA1->A1_COD))))
	RecLock("CTH",.T.)
	CTH->CTH_FILIAL	:= xFilial("CTH")
	CTH->CTH_CLVL	:= "C"+ALLTRIM(SA1->A1_COD)
	CTH->CTH_CLASSE	:= "2"
	CTH->CTH_DESC01	:= SA1->A1_NOME
	//CTH->CTH_BLOQ	:= SA1->A1_MSBLQL 
	CTH->CTH_NORMAL := "2"
	CTH->CTH_DTEXIS := CTOD("01/01/80")
	CTH->CTH_CLVLLP := "C"+ALLTRIM(SA1->A1_COD)
	CTH->(MsUnLock())	     
Else
	RecLock("CTH",.F.)   
	CTH->CTH_FILIAL	:= xFilial("CTH")
	CTH->CTH_CLVL	:= "C"+ALLTRIM(SA1->A1_COD)
	CTH->CTH_CLASSE	:= "2"
	CTH->CTH_DESC01	:= SA1->A1_NOME
	//CTH->CTH_BLOQ	:= SA1->A1_MSBLQL 
	CTH->CTH_NORMAL := "2"
	CTH->CTH_DTEXIS := CTOD("01/01/80")
	CTH->CTH_CLVLLP := "C"+ALLTRIM(SA1->A1_COD)
	CTH->(MsUnLock())	
EndIF
	
RestArea(aArea)

Return(.T.)
