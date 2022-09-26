User Function F060COL()
    Local aArea    := GetArea()
    Local aCampos  := paramixb[1]
    Local nTamanho := Len(aCampos)
    Local nColNova := 6
     
    //Redimensionando o array, adicionando uma nova posi��o
    aSize(aCampos, nTamanho + 1)
     
    //Adicionando um campo novo na posi��o desejada
    aIns(aCampos, nColNova)
     
    //As posi��es das colunas s�o s�o, [1] Campo, [2] Nil, [3] T�tulo, [4] Picture
    aCampos[nColNova] := {"E1_PORTADO", "", "Portado", ""}
     
    RestArea(aArea)
Return aCampos
