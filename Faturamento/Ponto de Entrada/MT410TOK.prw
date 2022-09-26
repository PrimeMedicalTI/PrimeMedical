#include "protheus.ch"
#include "totvs.ch"

User Function MT410TOK()

Local l_Ret     := .T.			// Conteudo de retorno
Local cMsg      := ""			// Mensagem de alerta
Local nOpc      := PARAMIXB[1]	// Opcao de manutencao
Local aRecTiAdt := PARAMIXB[2]	// Array com registros de adiantamentoc
Local nPTES     := aScan(aHeader,{|x| AllTrim(x[2]) == 'C6_TES'}) 
Local i         := 0

// Verifica se o código da admnistradora foi informado
If Empty(M->C5_FSCADM) .And. nOpc <> 1
    
    DbSelectArea("SF4")
    DbSetOrder(1) 

    For i:= 1 to Len(aCols)
        
        If aCols[i][Len(aHeader) + 1] == .F.
            DbSeek(xFilial("SF4")+aCols[i][nPTES])
            If SF4->F4_DUPLIC = "S"
                l_Ret := .F.
                
                cMsg :=  "O pedido de venda possui TES que gera duplicada, nessa situação é obrigatório a informação da adiministradora ."
                Aviso("Validação",cMsg,{"OK"},3,,,, .F., )
                Exit          
            Endif
        Endif     
    Next
Endif

Return(l_Ret)
