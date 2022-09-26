/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบPrograma  ณ M410LIOK บ Autor ณ 					 บ Data ณ  19/06/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de entrada para validar a linha do pedido de venda.  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Morais de Castro ( Faturamento )                           บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
/*/

User Function FGFAT001

Local c_TOp := aCols[1][aScan(aHeader, {|x| AllTrim(x[2]) == "C6_OPER"})]
Local i     := 0

For i:=1 To Len(aCols)
    If aCols[i][Len(aHeader) + 1] == .F.
        c_TOp := aCols[i][aScan(aHeader, {|x| AllTrim(x[2]) == "C6_OPER"})] 
        Exit
	Endif
Next

Return c_TOp
