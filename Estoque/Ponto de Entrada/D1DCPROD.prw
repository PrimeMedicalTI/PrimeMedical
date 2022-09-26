User Function D1DCPROD()

Local c_Desc := Posicione("SB1",1,XFILIAL("SB1")+ acols[n,ascan(aheader,{|x| alltrim(x[2]) == "D1_COD"})],"B1_DESC")

Return c_Desc
