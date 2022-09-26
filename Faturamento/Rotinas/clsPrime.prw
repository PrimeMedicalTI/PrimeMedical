#INCLUDE 'TOTVS.CH'

Class clsPrime

	Method New() Constructor

	Method mtdCalculaComissao()
	Method mtdSeparaPalavra()

EndClass

Method New() Class clsPrime

Return()

 Method mtdCalculaComissao( c_Vend, c_Regiao, c_Prod ) Class clsPrime
// Method mtdCalculaComissao( c_Vend, c_Cliente, c_Loja, c_Prod ) Class clsPrime

    Local n_Comissao := 0
    Local l_Grupo    := .F.

     //Verifica comissao do vendedor
    DbSelectArea("ZZ1")
    ZZ1->( DbSetOrder(1) )
    If ZZ1->( DbSeek( FWxFilial("ZZ1") + c_Vend ) )
        n_Comissao := ZZ1->ZZ1_FSCOMV
    Endif

    //Verifica comissao da Região
    DbSelectArea("ZZ0")
    ZZ0->( DbSetOrder(1))
    If ZZ0->( DbSeek( FWxFilial("ZZ0") + c_Vend + c_Regiao ))
        n_Comissao := ZZ0->ZZ0_FSCOMR
    Endif

    //Verifica comissao do vendedor no grupo de produto
    DbSelectArea("SB1")
    SB1->( DbSetOrder(1) )
    If SB1->( DbSeek( FWxFilial("SB1") + c_Prod ) )
        DbSelectArea("ZZ3")
        ZZ3->( DbSetOrder(2) )
        If ZZ3->( DbSeek( FWxFilial("ZZ3") + c_Vend ))

            While ZZ3->( !Eof() ) .And. ZZ3->ZZ3_FILIAL = FWxFilial("ZZ3") .And. ZZ3->ZZ3_FSCODV = c_Vend 
                If ZZ3->ZZ3_FSCODG = SB1->B1_GRUPO 
                    If ZZ3->ZZ3_FSCOMG > 0
                        n_Comissao := ZZ3->ZZ3_FSCOMG
                    Endif
                    l_Grupo := .T.
                Endif

                ZZ3->( DbSkip() )
            Enddo
            
            If !l_Grupo // Achou o vendedor, mas não achou o grupo
                n_Comissao := 0
            Else   
                //Verifica comissao do vendedor no cliente
                DbSelectArea("ZZ4")
                ZZ4->( DbSetOrder(2) )
                If ZZ4->( DbSeek( xFilial("ZZ4") + c_Vend + c_Prod ) )
                    If ZZ4->ZZ4_FSCOMP <> 0
                        n_Comissao := ZZ4->ZZ4_FSCOMP
                    Endif
               /* Else
                    n_Comissao := 0   */
                Endif
            Endif
        Endif
    Endif

 Return( n_Comissao )

********************************************************************************
//Metodo para arrumar texto em linhas separando as palavras (Nao separa silabas)
Method mtdSeparaPalavra( c_String, n_Carac, n_TLInhas ) Class clsPrime
********************************************************************************
Local n_Cont	    := 1
Local n_I		    := 1
Local c_Aux		    := ""
Local a_Palavras    := {}
Local a_Linhas	    := {}

If 	Len(c_String)>n_Carac     
	c_Aux:=StrTran(c_String," ", "|")
	a_Palavras:=Strtokarr (c_Aux, "|")
	c_Aux:=""

	Do	While n_Cont<=n_TLinhas .and. n_I<=Len(a_Palavras)
		If 	Len(c_Aux)+Len(a_Palavras[n_I])+1>n_Carac
			AADD(a_Linhas,c_Aux)
			c_Aux:=a_Palavras[n_I]+" "
			n_Cont++
		Else
			c_Aux+=a_Palavras[n_I]+" "
		Endif
		n_I++
	Enddo
	AADD(a_Linhas,c_Aux)
Else
	AADD(a_Linhas,c_String)
Endif

Return(a_Linhas)
