#INCLUDE'Protheus.ch'
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)
 
User Function MA261CPO()
 
Local _aArea := GetArea()
Local _aAreaX3 := SX3->(GetArea())
dbSelectArea("SX3")
dbSetOrder(2)
If dbSeek("D3_OBSERVA")
	AADD(aHeader,{ "Observação", "_cDestSub", x3_picture,x3_tamanho, x3_decimal, ".F.",x3_usado, x3_tipo, x3_arquivo, x3_context,SX3->X3_CBOX,SX3->X3_RELACAO,".F.","V" } )
Endif

RestArea(_aAreaX3)
RestArea(_aArea)
Return
