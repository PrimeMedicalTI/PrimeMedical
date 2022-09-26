#INCLUDE 'TOTVS.CH'

User Function FFATG01A( c_Comis )

	Local n_Comis   := 0
	Local c_Cliente := M->C5_CLIENTE
	Local c_Loja    := M->C5_LOJACLI
	Local c_Vend    := ""
	Local c_Prod    := ""
    Local nX        := 0
    Local c_Regiao  := ""

	Local o_Prime   := clsPrime():New()

    DbSelectArea("SA1")
    SA1->( DbSetOrder(1) )
    SA1->( DbSeek(xFilial("SA1")+c_Cliente+c_Loja))
    c_Regiao := SA1->A1_FSREGI

	for nX := 1 To Len(aCols) Step 1

        c_Prod  := aCols[ nX ][ aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"}) ]
            
		if c_Comis == "1"
	
            c_Vend  := M->C5_VEND1
            n_Comis := o_Prime:mtdCalculaComissao( c_Vend, c_Regiao, c_Prod )
 //           n_Comis := o_Prime:mtdCalculaComissao( c_Vend, c_Cliente, c_Loja, c_Prod )
            
            aCols[ nX ][ aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS1"}) ] := n_Comis

		elseif c_Comis == "2"

            c_Vend  := M->C5_VEND2
            n_Comis := o_Prime:mtdCalculaComissao( c_Vend, c_Regiao, c_Prod )
//            n_Comis := o_Prime:mtdCalculaComissao( c_Vend, c_Cliente, c_Loja, c_Prod )

			aCols[ nX ][ aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS2"}) ] := n_Comis

		elseif c_Comis == "3"

            c_Vend  := M->C5_VEND3
            n_Comis := o_Prime:mtdCalculaComissao( c_Vend, c_Regiao, c_Prod )
//            n_Comis := o_Prime:mtdCalculaComissao( c_Vend, c_Cliente, c_Loja, c_Prod )

			aCols[ nX ][ aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS3"}) ] := n_Comis

		elseif c_Comis == "4"
			
            c_Vend  := M->C5_VEND4
            n_Comis := o_Prime:mtdCalculaComissao( c_Vend, c_Regiao, c_Prod )
//            n_Comis := o_Prime:mtdCalculaComissao( c_Vend, c_Cliente, c_Loja, c_Prod )

            aCols[ nX ][ aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS4"}) ] := n_Comis

		else
			
            c_Vend  := M->C5_VEND5
//            n_Comis := o_Prime:mtdCalculaComissao( c_Vend, c_Regiao, c_Prod )
            n_Comis := o_Prime:mtdCalculaComissao( c_Vend, c_Cliente, c_Loja, c_Prod )
            
            aCols[ nX ][ aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS5"}) ] := n_Comis

		endif

	Next nX

Return( c_Vend )

Function u_FFATG01B()

	Local n_Comis   := 0
	Local c_Cliente := M->C5_CLIENTE
	Local c_Loja    := M->C5_LOJACLI
    Local c_Regiao  := ""
	Local c_Prod    := ""
    Local nX        := 0

    Local c_Vend1   := M->C5_VEND1
    Local c_Vend2   := M->C5_VEND2
    Local c_Vend3   := M->C5_VEND3
    Local c_Vend4   := M->C5_VEND4
    Local c_Vend5   := M->C5_VEND5
    
	Local o_Prime   := clsPrime():New()

    DbSelectArea("SA1")
    SA1->( DbSetOrder(1) )
    SA1->( DbSeek(xFilial("SA1")+c_Cliente+c_Loja))
    c_Regiao := SA1->A1_FSREGI

	For nX := 1 To Len(aCols) Step 1

        c_Prod  := aCols[ nX ][ aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"}) ]

        //    
		If !Empty( c_Vend1 )
			
            n_Comis := o_Prime:mtdCalculaComissao( c_Vend, c_Regiao, c_Prod )
//            n_Comis := o_Prime:mtdCalculaComissao( c_Vend1, c_Cliente, c_Loja, c_Prod )
            
            aCols[ nX ][ aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS1"}) ] := n_Comis
        Else
            aCols[ nX ][ aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS1"}) ] := 0
		Endif
        
        //
        If !Empty( c_Vend2 )

            n_Comis := o_Prime:mtdCalculaComissao( c_Vend, c_Regiao, c_Prod )
//            n_Comis := o_Prime:mtdCalculaComissao( c_Vend2, c_Cliente, c_Loja, c_Prod )

			aCols[ nX ][ aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS2"}) ] := n_Comis
        Else
			aCols[ nX ][ aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS2"}) ] := 0
        Endif

        //
		If !Empty( c_Vend3 )

            n_Comis := o_Prime:mtdCalculaComissao( c_Vend, c_Regiao, c_Prod )
//            n_Comis := o_Prime:mtdCalculaComissao( c_Vend3, c_Cliente, c_Loja, c_Prod )

			aCols[ nX ][ aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS3"}) ] := n_Comis
        Else    
			aCols[ nX ][ aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS3"}) ] := 0
		Endif

        //
        If !Empty( c_Vend4 )
			
            n_Comis := o_Prime:mtdCalculaComissao( c_Vend, c_Regiao, c_Prod )
//            n_Comis := o_Prime:mtdCalculaComissao( c_Vend4, c_Cliente, c_Loja, c_Prod )

            aCols[ nX ][ aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS4"}) ] := n_Comis
        Else
            aCols[ nX ][ aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS4"}) ] := 0
		Endif

        //	
        If !Empty( c_Vend5 )

            n_Comis := o_Prime:mtdCalculaComissao( c_Vend, c_Regiao, c_Prod )
//            n_Comis := o_Prime:mtdCalculaComissao( c_Vend5, c_Cliente, c_Loja, c_Prod )
            
            aCols[ nX ][ aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS5"}) ] := n_Comis
        Else
            aCols[ nX ][ aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS5"}) ] := 0
		Endif

	Next nX

Return( c_Cliente )
