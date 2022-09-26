#include 'totvs.ch'

CLASS clsTxt2Array

	Method New() CONSTRUCTOR
	Method mtdGerArray(c_Linha,c_Chave)

ENDCLASS

//-----------------------------------------------------------------
METHOD New() CLASS clsTxt2Array

Return Self

Method mtdGerArray(c_Linha,c_Chave) Class clsTxt2Array

	Local a_Array	:= {}
	Local c_Campo	:= ""
	Local nX		:= 0

	Default c_Chave	:= ";"

	For nX := 1 TO LEN(c_Linha)

		IF Substr(c_Linha,nX,1) <> c_Chave

			c_Campo += Substr(c_Linha,nX,1)

		ELSE

			AADD(a_Array,c_Campo)

			c_Campo := ""

		ENDIF

	Next

	AADD(a_Array,c_Campo)

Return(a_Array)
