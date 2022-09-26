#INCLUDE "RWMAKE.CH"

// ---------------------------------------------------------------------------------------------------------------------
// EXECBLOCK   - Ponto de entrada para validação de linha de pedido de vendas
//             - ocorre durante a troca da linha da getdados
// Beatriz     - Janeiro/2022
// CLIENTE     - Prime
// ---------------------------------------------------------------------------------------------------------------------
// Implementação: Validar se existe outro pV com o mesmo Paciemte / Data do procedimento quando a TES utilizada for de 
//                Procedimento F4_FSTIPO='2'
// ---------------------------------------------------------------------------------------------------------------------

User Function M410LIOK()

Local a_Area    := GetARea()
Local l_Ret     := .T.
Local c_Tes     := aCols[n][aScan(aHeader,{|x|AllTrim(x[2])=="C6_TES"})]
Local c_Item    := aCols[n][aScan(aHeader,{|x|AllTrim(x[2])=="C6_ITEM"})]
Local c_CFO    	:= Alltrim(aCols[n][aScan(aHeader,{|x|AllTrim(x[2])=="C6_CF"})])
Local c_Lote	:= aCols[n][aScan(aHeader,{|x|AllTrim(x[2])=='C6_LOTECTL'})]
Local d_Valid	:= aCols[n][aScan(aHeader,{|x|AllTrim(x[2])=='C6_DTVALID'})]
Local c_Tipo    := Posicione("SF4",1,xFilial("SF4")+c_Tes,"F4_FSTIPO")
Local c_Poder3  := Posicione("SF4",1,xFilial("SF4")+c_Tes,"F4_PODER3")
Local c_Param 	:= GetMv("FS_CFCONSI")

// Procedimento
If  c_Tipo='2' .And. Empty(M->C5_PACIENT)=.F. .And. Empty(M->C5_DTPROCE)=.F. .AND. INCLUI=.T. 
    l_Ret := U_FFATA005(M->C5_PACIENT, M->C5_DTPROCE)
Endif

// Inserido em 10/02/2022 - Elisângela Souza
If !(c_CFO$c_Param) .And. !Empty(d_Valid) .And. d_Valid < dDataBase .And. !Empty(c_Lote) 
	AVISO("M410LIOK", "A data de validade está menor que a data atual. Item: " + c_Item, { "OK" }, 1)
//	l_Ret := .T.
Endif


// Inserido em 05/05/2022 - Elisângela Souza - Consignado
If M->C5_TIPO ="N" .And. c_Poder3 = "R" .And. c_Tipo = "1"
    DbSelectArea("SA1")
    SA1->( DbSetOrder(1))
    If SA1->( DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI) )
        If Empty(SA1->A1_FSLOCAL)
        	AVISO("M410LIOK-LOCAL", "Cliente não possui armazém informado!",{ "OK" }, 1)
            l_Ret := .F.
        Endif
    Endif
Endif

// Inserido em 05/09/2022 para apresentar o saldo em estoque
If FindFunction( "U_FFATP410" ) .Or. FindFunction( "FFATP410" )
    l_Ret   :=  U_FFATP410() //Validacao de saldos em estoque (SB2 x SB8s)
Endif

RestArea(a_Area)

Return(l_Ret)
