#Include "TOTVS.CH"    
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#include "topconn.ch"      

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³MT103FIM    ºAutor  ³Elisângela Souza  º Data ³  19/06/17   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³  Ponto de Entrada no Documento de Entrada para inclusao de º±±
±±º          ³  Informacoes da NF-e de Importacao                         º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                        º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
                     
User Function MT100GE2()

Local a_Area    := GetArea() 
//Local aTitAtual := PARAMIXB[1]
Local nOpc 		:= PARAMIXB[2]
//Local aHeadSE2	:= PARAMIXB[3]
//Local aParcelas := ParamIXB[5]
//Local nX 		:= ParamIXB[4]
Local c_Doc		:= SD1->D1_DOC
Local c_Serie	:= SD1->D1_SERIE
Local c_Fornec	:= SD1->D1_FORNECE
Local c_Loja	:= SD1->D1_LOJA

DbSelectArea("SD1")
SD1->( DbSetOrder (1))
SD1->( DbSeek(xFilial("SD1")+c_Doc+c_Serie+c_Fornec+c_Loja))

If nOpc == 1 //.. inclusao
    SE2->E2_DECRESC := SD1->D1_DESCFRE
	SE2->E2_SDDECRE := SD1->D1_DESCFRE
Endif

RestArea(a_Area)  

Return(Nil)
