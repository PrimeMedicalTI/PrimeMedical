/*/
�����������������������������������������������������������������������������
���Programa  � M410LIOK � Autor � 					 � Data �  19/06/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada para validar a linha do pedido de venda.  ���
�������������������������������������������������������������������������͹��
���Uso       � Morais de Castro ( Faturamento )                           ���
�����������������������������������������������������������������������������
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
