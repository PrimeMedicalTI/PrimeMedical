#include "TOTVS.CH"
#include "RESTFUL.CH"

WSRESTFUL AliquotasEstado DESCRIPTION "Lista de Alíquotas ICMS por Estado"

    WSDATA cbuscar AS STRING
    WSMETHOD GET ALL DESCRIPTION 'Retorna todas as alíquotas' WSSYNTAX '/AliquotasEstado/lista?{cbuscar}' PATH 'lista' PRODUCES APPLICATION_JSON

END WSRESTFUL

WSMETHOD GET ALL WSRECEIVE cbuscar WSREST AliquotasEstado
    Local lRet := .T.
	Local aAliquotas := {}
	Local oJson := JsonObject():New() 
	Local cJson := ""   
	Local cMV_ESTICM := ""
	Local aEstados := {} 
    Local cBuscador  := Self:cbuscar
    Local nCount := 1

	cMV_ESTICM := ConTeu("MV_ESTICM")
	aEstados := StrTok(cMV_ESTICM, ",") // Separando os estados por vírgula

    WHILE nCount <= Len(aEstados)
        cEstado := aEstados[nCount]
		IF Empty(cBuscador) .OR. cBuscador == Left(cEstado,2)
			aAdd(aAliquotas,JsonObject():New())
			aAliquotas[Len(aAliquotas)]['Estado'] := Left(cEstado,2)
			aAliquotas[Len(aAliquotas)]['Aliquota'] := SubStr(cEstado,3,Len(cEstado))
		ENDIF
        nCount++
	END

	IF Len(aAliquotas) == 0
		SetRestFault(400, 'Estado não encontrado!')
		lRet := .F.
		Return(lRet)
	ENDIF

	oJson["AliquotasEstado"] := aAliquotas 
	cJson := FwJSonSerialize(oJson)
	::SetResponse(cJson) 			

	Return lRet

Return lRet
