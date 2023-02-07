#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M020ALT   �Autor  �                    � Data �  26/05/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada na altera��o do fornecedor para compati-   ���
���          �bilizar a classe valor                                      ���
�������������������������������������������������������������������������͹��
���Uso       �AP                                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

	//CTH->CTH_BLOQ	:= SA2->A2_MSBLQL - COMENTADO EM 20/05/2022  POR SOLICITA��O DE ALINE
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
