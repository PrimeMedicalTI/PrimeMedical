#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M030ALT   �Autor  �Ihorran Milholi     � Data �  16/06/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada na altera��o do cliente para compati-      ���
���          �bilizar a classe valor                                      ���
�������������������������������������������������������������������������͹��
���Uso       �AP                                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


// CTH->CTH_BLOQ	:= SA1->A1_MSBLQL   - Comentado em 20/05/2022 por solicita��o de Aline
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
