User Function F060COL()
    Local aArea    := GetArea()
    Local aCampos  := paramixb[1]
    Local nTamanho := Len(aCampos)
    Local nColNova := 6
     
    //Redimensionando o array, adicionando uma nova posição
    aSize(aCampos, nTamanho + 1)
     
    //Adicionando um campo novo na posição desejada
    aIns(aCampos, nColNova)
     
    //As posições das colunas são são, [1] Campo, [2] Nil, [3] Título, [4] Picture
    aCampos[nColNova] := {"E1_PORTADO", "", "Portado", ""}
     
    RestArea(aArea)
Return aCampos
