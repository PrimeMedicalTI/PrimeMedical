#INCLUDE "rwmake.ch"
#include "topconn.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LEM67028  � Autor � CASSIO LOUREIRO    � Data �  17/12/03   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo AUTOMATICO NO CADASTRO DE ativo                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FGATATF01

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cString := "SN1"

_cArqSN1:= retsqlname("SN1")
cQry := " SELECT max(N1_CBASE) AS CBASE "
cQry := cQry +" FROM "+ _cArqSN1 +" SN1 "
cQry := cQry +" WHERE  N1_GRUPO='"+M->N1_GRUPO+"' AND SN1.D_E_L_E_T_<>'*' "

TCQUERY cQry NEW ALIAS "QRY"

DbselectArea("QRY")            
cSeq:=strzero(val(substr(QRY->CBASE,5))+1,6)

cCod:= substr(QRY->CBASE,1,4)+cSeq
If empty(substr(QRY->CBASE,1,4))
	cCod := strzero(val(M->N1_GRUPO),4)+cSeq
Endif
M->N1_ITEM := "0001"

DbselectArea("QRY")
DbCloseArea()               

Return(cCod)
