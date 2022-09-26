//Bibliotecas
#Include "Protheus.ch"
#Include "TBIConn.ch" 
#Include "Colors.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"
 
/*/{Protheus.doc} zGerDanfe
Função que gera a danfe e o xml de uma nota em uma pasta passada por parâmetro
@author Thiago Leal
@since 09/12/2020
/*/
User Function zGerDanfe(a_DocSer, n_Mostra)
    Local aArea     := GetArea()
    Local cIdent    := ""
    Local cArquivo  := ""
    Local oDanfe    := Nil
    Local lEnd      := .F.
    Local nTamNota  := TamSX3('F2_DOC')[1]
    Local nTamSerie := TamSX3('F2_SERIE')[1]
    Local I
    Local c_Msg     := ''
    Local l_Gera    := .F.
    Private PixelX
    Private PixelY
    Private nConsNeg
    Private nConsTex
    Private oRetNF
    Private nColAux
    Default cNota   := ""
    Default cSerie  := ""
    Default cretorno:= ""
    Default ccodret := ""
    Default cPasta  := Alltrim(SUPERGetMV("FS_LOCXML",.F.,"C:\TEMP\")) //GetTempPath()
    //Default cPasta  := "C:\temp\"

    For I := 1 to Len(a_DocSer)
        cNota   := a_DocSer[I,1]
        cSerie  := a_DocSer[I,2]
        l_Gera := .T.

        DbSelectArea("SF3")
        DbSetOrder(6) // Filial + Nota Fiscal + Serie N.F.                                              
        DbSeek(xFilial("SF3") + cNota + cSerie)
        cretorno := SF3->F3_DESCRET
        ccodret  := SF3->F3_CODRSEF
            
        IF  Empty(ccodret)
            IF  Len(c_Msg) > 0
                c_Msg += CHR(13)    
            Endif
            c_Msg += "NF "+cNota+"/"+cSerie + " - Falha no schema do XML."
            l_Gera := .F.
//            msgalert("Falha no schema do XML. Verificar o problema na tela de monitoramento da nota.")	
        ENDIF
            
        IF ! Empty(ccodret) .and. ccodret <> "100"
            IF  Len(c_Msg) > 0
                c_Msg += CHR(13)    
            Endif
            c_Msg += "NF "+cNota+"/"+cSerie + " - Não autorizada - Cod Ret Nfe = " + ccodret + " Msg Retorno NF-e = " + cretorno
            l_Gera := .F.
            
//            msgalert("Nota não autorizada" +CHR(13)+"Cod Ret Nfe = " + ccodret + CHR(13) + "Msg Retorno NF-e = " + cretorno  )	
        ENDIF    
    
        //Se existir nota
        If  l_Gera
            //Pega o IDENT da empresa
            cIdent := RetIdEnti()
            
            //Se o último caracter da pasta não for barra, será barra para integridade
            If  SubStr(cPasta, Len(cPasta), 1) != "\"
                cPasta += "\"
            EndIf
            
            //Gera o XML da Nota
            cArquivo := "NF_" + cNota + "_" + SUBSTR(cSerie,1,1) + "_" + dToS(Date()) + "_" + StrTran(Time(), ":", "-")
            u_zSpedXML(cNota, cSerie, cPasta + UPPER(cArquivo)  + ".xml", .F.)
            
            //Define as perguntas da DANFE
            Pergunte("NFSIGW",.F.)
            MV_PAR01 := PadR(cNota,  nTamNota)     //Nota Inicial
            MV_PAR02 := PadR(cNota,  nTamNota)     //Nota Final
            MV_PAR03 := PadR(cSerie, nTamSerie)    //Série da Nota
            MV_PAR04 := 2                          //NF de Saida
            MV_PAR05 := 2                          //Frente e Verso = nao
            MV_PAR06 := 2                          //DANFE simplificado = Nao
            
            //Cria a Danfe
            oDanfe := FWMSPrinter():New(UPPER(cArquivo), IMP_PDF, .F., , .T.)
            
            //Propriedades da DANFE
            oDanfe:SetResolution(78)
            oDanfe:SetPortrait()
            oDanfe:SetPaperSize(DMPAPER_A4)
            oDanfe:SetMargin(60, 60, 60, 60)
            
            //Força a impressão em PDF
            oDanfe:nDevice  := 6
            oDanfe:cPathPDF := cPasta                
            oDanfe:lServer  := .F.
            If  n_Mostra = 1
                oDanfe:lViewPDF := .T.
            Else
                oDanfe:lViewPDF := .F.
            Endif            
            
            //Variáveis obrigatórias da DANFE (pode colocar outras abaixo)
            PixelX    := oDanfe:nLogPixelX()
            PixelY    := oDanfe:nLogPixelY()
            nConsNeg  := 0.4
            nConsTex  := 0.5
            oRetNF    := Nil
            nColAux   := 0
            
            //Chamando a impressão da danfe no RDMAKE
            //RptStatus({|lEnd| StaticCall(DANFEII, DanfeProc, @oDanfe, @lEnd, cIdent, , , .F.)}, "Imprimindo Danfe...")
            RPTStatus({|lEnd| U_DANFEProc(@oDanfe, @lEnd, cIDEnt, Nil, Nil, .F., .F.,,.F. )}, "Imprimindo Danfe...")
            oDanfe:Print()

        EndIf
    Next     
    IF  Len(c_Msg) > 0
        msgalert(c_Msg)
    ENDIF    
    RestArea(aArea)
Return
