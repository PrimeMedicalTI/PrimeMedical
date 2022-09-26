
 /*/{Protheus.doc} GQREENTR
Ponto de entrada na finalizacao do documento de entrada
@author Francisco
@since 08/11/2016
@version undefined

@type function
/*/
User Function MT120LOK

Local l_Valido      := .T.
Local l_LoteVenc    := SuperGetMV("MV_LOTVENC") == "S"
Local n_PosCod      := aScan(aHeader,{|x| AllTrim(x[2])=="C7_PRODUTO"})
Local n_PosLocal    := aScan(aHeader,{|x| AllTrim(x[2])=="C7_LOCAL"})
Local n_PosLote     := aScan(aHeader,{|x| AllTrim(x[2])=="C7_FSLOTE"})
Local n_PosValid    := aScan(aHeader,{|x| AllTrim(x[2])=="C7_FSDTVAL"})

c_Produto   := aCols[n,n_PosCod]
c_Local     := aCols[n,n_PosLocal]
c_Lote      := aCols[n,n_PosLote]
d_DtValid   := aCols[n,n_PosValid]

// Verifica se a data de validade pode ser utilizada
//    nRegOrig:=Recno()

DbSelectArea("SB8")
SB8->( DbSetOrder(3))

If DbSeek(xFilial("SB8")+c_Produto+c_Local+M->c_Lote+"")
//        nRegSeek	:= Recno()
    If	d_DtValid # SB8->B8_DTVALID
        HelpAutoma(" ",1,"A240DTVALI")
        aCols[n,n_PosValid]   := SB8->B8_DTVALID
    EndIf
Endif

// Lote vencido
If l_LoteVenc
    If !Empty(c_Lote) .And. d_DtValid < dDataBase 
        HelpAutoma(" ",1,"DTVALIDINV")
    Endif
Else
    If !Empty(c_Lote) .And. d_DtValid < dDataBase
        HelpAutoma(" ",1,"LOTEVENC")
        l_Valido := .F.
    Endif        
Endif

Return(l_Valido) 
