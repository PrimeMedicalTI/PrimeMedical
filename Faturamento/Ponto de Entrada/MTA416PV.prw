#INCLUDE "rwmake.ch"

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篜rograma  矼TA416PV  � Autor � Elisangela Souza   � Data �  24/11/2021 罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋escricao � Ponto de entrada na aprovacao do orcamento para gravar     罕�
北�          � dados adicionais.                                          罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � Especifico Prime                                           罕�
北掏屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北�                     A T U A L I Z A C O E S                           罕�
北掏屯屯屯屯退屯屯屯屯屯屯屯屯屯退屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篋ATA      篈NALISTA           篈LTERACOES                              罕�
北�          �                   �                                        罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
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
