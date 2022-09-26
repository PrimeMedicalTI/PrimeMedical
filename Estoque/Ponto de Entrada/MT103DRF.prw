#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
    
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³MT103DRF  ºAutor  ³Francis Macedo    º Data ³  01/04/2019   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Ponto de entrada para já trazer o código de receita no Doc. º±± 
±±           ³de Entrada para o impostos IR e PCC.                        º±± 
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACOM                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
/*/

User Function MT103DRF()

Local nCombo  := PARAMIXB[1]
Local cCodRet := PARAMIXB[2]
Local aImpRet := {}

nCombo  := 1

If Alltrim(SA2->A2_TIPO)='F'
	cCodRet := "3208" //Pessoa Fisica - Aluguel
Else
	cCodRet := "1708" //Pessoa Jurídica	
Endif

aadd(aImpRet,{"IRR",nCombo,cCodRet})

nCombo  := 1
cCodRet := "5952"
aadd(aImpRet,{"PIS",nCombo,cCodRet})

nCombo  := 1
cCodRet := "5952"
aadd(aImpRet,{"COF",nCombo,cCodRet})

nCombo  := 1
cCodRet := "5952"
aadd(aImpRet,{"CSL",nCombo,cCodRet})

Return aImpRet