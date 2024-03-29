#INCLUDE 'TOTVS.CH'

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篜rograma  矼440STTS  篈utor  矱lisangela Souza    � Data � 07/01/2022  罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋esc.     砅onto de entrada ap髎 libercao do pedido de venda.          罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � SIGAFAT                                                    罕�
北掏屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北�                     A L T E R A C O E S                               罕�
北掏屯屯屯屯退屯屯屯屯屯屯屯屯屯送屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篋ata      篜rogramador       篈lteracoes                               罕�
北�          �                  �                                         罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

User Function M440STTS()

Local a_SC9Area	:= SC9->(GetArea())
Local a_SF4Area	:= SF4->(GetArea())

DbSelectArea("SC9")
SC9->( DbSetOrder(1))
SC9->( DbSeek(xFilial("SC9")+SC5->C5_NUM))

While SC9->( !Eof() ) .And. SC9->C9_FILIAL = SC5->C5_FILIAL .And. SC9->C9_PEDIDO = SC5->C5_NUM

	DbSelectArea("SC6")
	SC6->( DbSetOrder(1))
	SC6->( DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM))

	DbSelectArea("SF4")
	SF4->( DbSetOrder(1))
	SF4->( DbSeek(xFilial("SF4")+SC6->C6_TES))

	If Empty(SC9->C9_NFISCAL)
		DbSelectArea("SC9")
		RecLock("SC9",.F.)
			SC9->C9_FSTPSAI := SF4->F4_TEXTO
			SC9->C9_FSEST	:= SF4->F4_ESTOQUE
		MsUnLock()
	Endif

	SC9->( DbSkip() )
Enddo

RestArea(a_SC9Area)
RestArea(a_SF4Area)

Return()
