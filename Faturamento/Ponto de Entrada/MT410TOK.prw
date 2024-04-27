#include 'Totvs.ch'
 
/*------------------------------------------------------------------------------------------------------*
 | P.E.:  MT410TOK                                                                                      |
 | Desc:  Função executa antes de confirmar a inclusão do Pedido de Venda                               |
 | Links: http://tdn.totvs.com/display/public/mp/MA410MNU                                               |
 *------------------------------------------------------------------------------------------------------*/
 
User Function MT410TOK()
    Local lRet := .T.
    Local aArea    := GetArea()
    Local aAreaC9    := SC9->(GetArea())
    Local aAreaC5    := SC5->(GetArea())
    Local aAreaC6    := SC6->(GetArea())
    Local cMsg      := ""			// Mensagem de alerta
    Local nOpc      := PARAMIXB[1]	// Opcao de manutencao
    Local nPTES     := aScan(aHeader,{|x| AllTrim(x[2]) == 'C6_TES'}) 
    Local i         := 0
    Local cAlias := getNextAlias()
    
    BEGINSQL ALIAS cAlias
        Select 
            A1_FSBANCO, A1_FSAGENC, A1_FSCTA, A1_FSSUBCT, A1_NBANCO, A1_FSCADM
        From SA1010 (nolock)
        Where 1=1
        AND A1_FILIAL = '' 
        AND D_E_L_E_T_ <> '*'
        AND A1_COD = %Exp:M->C5_CLIENTE% 
        AND A1_LOJA = %Exp:M->C5_LOJACLI% 
    ENDSQL   
    
    
    if AllTrim((cAlias)->A1_FSCADM) <> ''
        if (AllTrim(M->C5_FSCADM) <> AllTrim((cAlias)->A1_FSCADM))
            cMsg :=  "Este cliente tem definido pelo Financeiro o Cod Adm padrão"
            Aviso("Validação",cMsg,{"OK"},3,,,, .F., ) 
            M->C5_FSCADM := (cAlias)->A1_FSCADM
        endif
    Endif

    if AllTrim((cAlias)->A1_FSBANCO+(cAlias)->A1_FSAGENC+(cAlias)->A1_FSCTA+(cAlias)->A1_FSSUBCT+(cAlias)->A1_NBANCO) <> ''
        if AllTrim(M->C5_FSBANCO+M->C5_FSAGENC+M->C5_FSCTA+M->C5_FSSUBCT+M->C5_NBANCO) <> AllTrim((cAlias)->A1_FSBANCO+(cAlias)->A1_FSAGENC+(cAlias)->A1_FSCTA+(cAlias)->A1_FSSUBCT+(cAlias)->A1_NBANCO)
            cMsg :=  "Este cliente tem definido pelo Financeiro o banco padrão"
            Aviso("Validação",cMsg,{"OK"},3,,,, .F., ) 
            M->C5_FSBANCO := (cAlias)->A1_FSBANCO
            M->C5_FSAGENC := (cAlias)->A1_FSAGENC
            M->C5_FSCTA := (cAlias)->A1_FSCTA
            M->C5_FSSUBCT := (cAlias)->A1_FSSUBCT
            M->C5_NBANCO := (cAlias)->A1_NBANCO
        endif
    Endif    
    
    // Verifica se o código da admnistradora foi informado
    If Empty(M->C5_FSCADM) .And. nOpc <> 1    
        DbSelectArea("SF4")
        DbSetOrder(1) 
        For i:= 1 to Len(aCols)
            
            If aCols[i][Len(aHeader) + 1] == .F.
                DbSeek(xFilial("SF4")+aCols[i][nPTES])
                If SF4->F4_DUPLIC = "S"
                    lRet := .F.                
                    cMsg :=  "O pedido de venda possui TES que gera duplicada, nessa situação é obrigatório a informação da adiministradora ."
                    Aviso("Validação",cMsg,{"OK"},3,,,, .F., )
                    Exit          
                Endif
            Endif     
        Next
    Endif

    (cAlias)->(DbCloseArea())
    RestArea(aAreaC6)
    RestArea(aAreaC5)
    RestArea(aAreaC9)
    RestArea(aArea)

Return(lRet)
