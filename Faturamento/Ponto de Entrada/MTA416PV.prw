#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
���Programa  �MTA416PV  � Autor � Elisangela Souza   � Data �  24/11/2021 ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada na aprovacao do orcamento para gravar     ���
���          � dados adicionais.                                          ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Prime                                           ���
�������������������������������������������������������������������������͹��
���                     A T U A L I Z A C O E S                           ���
�������������������������������������������������������������������������͹��
���DATA      �ANALISTA           �ALTERACOES                              ���
���          �                   �                                        ���
�����������������������������������������������������������������������������
/*/
User Function MTA416PV()

Local aSaveArea := GetArea()

M->C5_PACIENT 	:= SCJ->CJ_FSPACIE
M->C5_FSCCONV	:= SCJ->CJ_FSCCONV
M->C5_CONVENI	:= SCJ->CJ_FSCONVE
M->C5_DTPROCE  	:= SCJ->CJ_FSDTPRO 
M->C5_OBSNOTA	:= SCJ->CJ_FSOBSNF
M->C5_FSORCAM	:= SCJ->CJ_NUM
M->C5_NOMECLI	:= Posicione("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_NOME")

RestArea(aSaveArea)

Return Nil
