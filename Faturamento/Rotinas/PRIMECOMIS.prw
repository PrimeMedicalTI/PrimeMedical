#Include 'Protheus.CH'
#Include 'RwMake.CH'
#Include 'TopConn.CH'
/*
------------------------------------------------------------------------------------------------------------
Função		: PRIMECOMIS.PRW
Tipo		: Programa
Descrição	: Programa para calcular a comissão do vendedor
Chamado     : 
Parâmetros	: 
Retorno		:
------------------------------------------------------------------------------------------------------------
Atualizações:
- 02/04/2021 - Fabio A. Moraes - Construção inicial do Fonte
------------------------------------------------------------------------------------------------------------
*/
User Function PrimeComis( c_Comis )

    Local n_Comis   := 0
    Local c_Cliente := M->C5_CLIENTE
    Local c_Loja    := M->C5_LOJACLI
    Local c_Vend    := ""
    Local c_Prod    := aCols[ n ][ aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"}) ]
    Local c_Regiao  := ""

    Local o_Prime   := clsPrime():New()

    DbSelectArea("SA1")
    SA1->( DbSetOrder(1) )
    SA1->( DbSeek(xFilial("SA1")+c_Cliente+c_Loja))
    c_Regiao := SA1->A1_FSREGI

    If c_Comis == "1"
        c_Vend  := M->C5_VEND1
    Elseif c_Comis == "2"
        c_Vend  := M->C5_VEND2
    Elseif c_Comis == "3"
        c_Vend  := M->C5_VEND3
    Elseif c_Comis == "4"
        c_Vend  := M->C5_VEND4
    Else
        c_Vend  := M->C5_VEND5
    Endif

    n_Comis := o_Prime:mtdCalculaComissao( c_Vend, c_Regiao, c_Prod )

Return( n_Comis )
