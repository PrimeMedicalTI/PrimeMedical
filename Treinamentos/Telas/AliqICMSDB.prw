#INCLUDE 'Totvs.ch'

User Function AliqICMS()
		
    Local aEstadosBr := {"AC","AL","AP","AM","BA","CE","DF","ES","GO","MA","MT","MS","MG","PA","PB","PR","PE","PI","RJ","RN","RS","RO","RR","SC","SP","SE","TO"}
    Local cEstado
    Local nCount := 1
	
	DbSelectArea("SZ1")  // Seleciona a tabela ZA1
	SZ1->(DbSetOrder(1)) // Define a ordem (ajuste de acordo com sua necessidade)

	while SZ1->(!EOF())
		RecLock("SZ1",.F.)			
			DBDELETE()
			SZ1->(DbSkip())
		MsUnLock()		
	end
	
	WHILE nCount <= Len(aEstadosBr)
		cEstado := aEstadosBr[nCount]
		
		RecLock("SZ1",.T.)

			SZ1->Z1_FILIAL := xFilial("SZ1")
			SZ1->Z1_EST := cEstado // Insere o valor do estado		

	        // Insere a alíquota
			IF cEstado = 'RO'
				SZ1->Z1_ALIQ := SUBS(GETMV("MV_ESTICM"),AT(cEstado,GETMV("MV_ESTICM"))+2,5)
			ELSE
				SZ1->Z1_ALIQ := SUBS(GETMV("MV_ESTICM"),AT(cEstado,GETMV("MV_ESTICM"))+2,2)
			ENDIF	

		MsUnLock()		
		nCount++
	END

	dbCloseArea("SZ1")		
	Alert('Dados gravados no banco de dados com sucesso.')

Return
