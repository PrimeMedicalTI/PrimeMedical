#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �F200PORT �Autor �Roseclei Ventura 28/11/2023
��������������������������������������������������������������������͹��
���Desc. � Ponto de entrada que com retorno T/F se a baixa ser� pelo
portador do Titulo ou pelo parametro
��� � ���
�������������������������������������������������������������������������͹��
O que este ponto de entrada faz � na verdade retornar .T. se o retorno dever� 
considerar a conta para baixa do titulo a mesma enviada no bordero de cobran�a,
 ou seja, E1_PORTADO, E1_AGEDEP e E1_CONTA, ou .F. se a conta informada
 no par�metro da tela de retorno cnab.
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F200PORT()
   Local lRet := .T.

   If AllTrim(cBanco) == '637' .OR. AllTrim(cBanco) == '033' .OR. AllTrim(cBanco) == '001' .OR. AllTrim(cBanco) == '748' .OR. AllTrim(cBanco) == '422' .OR. AllTrim(cBanco) == '341'
      lRet := .F.
   Endif

   Return lRet

/*
User Function F200PORT()
Local lRet := .T.

If AllTrim(cBanco) == '637' // Se For Banco Santander Ent�o N�o Considera o E1_PORTADO Considera o Banco Informado nos Par�metros
lRet := .F.
Endif 

Return lRet  */

