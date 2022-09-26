// retorna descrição do produto do pedido de compras para o documento de entrada
User Function MT103IPC()

Local a_Area        := GetArea() 
Local ExpN1         := PARAMIXB[1] //Validações do ClienteReturn Nil
Local nPosDescri    := aScan(aHeader,{|x| AllTrim(x[2])=="D1_FSDESC"})
Local nPosLote      := aScan(aHeader,{|x| AllTrim(x[2])=="D1_LOTECTL"})
Local nPosValid     := aScan(aHeader,{|x| AllTrim(x[2])=="D1_DTVALID"})

aCols[ExpN1,nPosDescri] := SC7->C7_DESCRI
aCols[ExpN1,nPosLote]   := SC7->C7_FSLOTE
aCols[ExpN1,nPosValid]  := SC7->C7_FSDTVAL

RestArea(a_Area)                          

Return 
