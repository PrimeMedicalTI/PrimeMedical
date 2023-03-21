#Include 'Protheus.ch'
 
User Function MA261TRD3()
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recebe os identificadores Recno() gerados na tabela SD3      ³
//³ para que seja feito o posicionamento                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 
Local aRecSD3 := PARAMIXB[1]
Local nX := 1
Local cScan := Ascan(AHEADER,{ |x| x[2] == 'D3_QUANT'})
 
For nX := 1 To Len(aRecSD3)
 
    SD3->(DbGoto(aRecSD3[nX][1])) // Requisicao RE4
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Customizacoes de usuario      ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 
    IF cScan > 0
        RecLock('SD3', .F.)
        SD3->D3_OBS := aCols[nX,cScan]
        MsUnlock()
    Endif
     
    SD3->(DbGoto(aRecSD3[nX][2])) // Devolucao DE4
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Customizacoes de usuario      ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 
    IF cScan > 0
        RecLock('SD3', .F.)
        SD3->D3_OBS := aCols[nX,cScan]
        MsUnlock()
    Endif
 
Next nX
 
Return Nil
