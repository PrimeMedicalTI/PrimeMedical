/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篜rograma  � M410LIOK � Autor � 					 � Data �  19/06/09   罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋escricao � Ponto de entrada para validar a linha do pedido de venda.  罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � Morais de Castro ( Faturamento )                           罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
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
