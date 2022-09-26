 /*/{Protheus.doc} GQREENTR
Ponto de entrada na finalizacao do documento de entrada
@author Francisco
@since 08/11/2016
@version undefined

@type function
/*/
User Function GQREENTR()

	Local a_SF1Area	:= SF1->( GetArea() )
	Local a_SD1Area	:= SD1->( GetArea() )
	Local a_SC5Area	:= SC5->( GetArea() )
	Local a_SC6Area	:= SC6->( GetArea() )
	Local a_SC9Area	:= SC9->( GetArea() )

	if SF1->F1_TIPO = 'B'
		u_FCOMA02A()
	endif

	RestArea( a_SF1Area )
	RestArea( a_SD1Area )
	RestArea( a_SC5Area )
	RestArea( a_SC6Area )
	RestArea( a_SC9Area )

Return()
