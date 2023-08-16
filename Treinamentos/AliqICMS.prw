#INCLUDE 'Totvs.ch'

User Function AliqICMS()
		
    Local aEstadosBr := {"AC","AL","AP","AM","BA","CE","DF","ES","GO","MA","MT","MS","MG","PA","PB","PR","PE","PI","RJ","RN","RS","RO","RR","SC","SP","SE","TO"}
    Local nHnd 
    Local cFile := 'C:/TEMP/Aliquotas.txt' 
    Local cLine
    Local nCount := 1
    nHnd := FCreate(cFile)
    If nHnd == -1
        MsgStop("Falha ao criar arquivo ["+cFile+"]","FERROR "+cValToChar(fError()))
        Return
    Endif
	
	WHILE nCount <= Len(aEstadosBr)
		cEstado := aEstadosBr[nCount]

        if cEstado = 'RO'
		    cLine := cEstado + ';' + SUBS(GETMV("MV_ESTICM"),AT(cEstado,GETMV("MV_ESTICM"))+2,5) + Chr(13) + Chr(10)
        else
            cLine := cEstado + ';' + SUBS(GETMV("MV_ESTICM"),AT(cEstado,GETMV("MV_ESTICM"))+2,2) + Chr(13) + Chr(10)
        endif         
		FWRITE(nHnd, cLine)
		nCount++
	END

    FClose(nHnd)
    Alert('Arquivo gerado com sucesso.')

Return
