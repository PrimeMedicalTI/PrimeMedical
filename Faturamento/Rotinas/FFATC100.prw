#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "TOTVS.CH"
#INCLUDE "SHELL.CH"
#INCLUDE "FILEIO.CH"

#DEFINE ENTER CHR(13)+CHR(10)

/*/{Protheus.doc} u_FFATC100
Rotina para Consulta detalhada de consignacao
@type function
@author Eduardo
@since 11/01/2022
@version 12.1.27
/*/    
Function u_FFATC100(c_RotTipo) 
    
    Local oBrowse	:=  Nil

    Default c_RotTipo   :=  "1" //1=Consignado;2=Procedimento

    Private c_FSTipo    :=  c_RotTipo //1=Consignado;2=Procedimento

    Private c_FSNTipo   :=  Iif(c_FSTipo=="1","Consignação","Procedimento")
    Private c_SB1Cam    :=  "B1_COD;B1_DESC;B1_UM;"
    Private c_SB2Cam    :=  "B2_COD;B2_LOCAL;B2_LOCALIZ;B2_QATU;B2_RESERVA;B2_QTNP;B2_QNPT;B2_QEMP;B2_QPEDVEN;" 
    Private c_SB6Cam    :=  "B6_CLIFOR;B6_LOJA;B6_NREDUZ;B6_PRODUTO;B6_LOCAL;B6_DOC;B6_SERIE;B6_TPCF;B6_FSTPP3;B6_UM;B6_PODER3;B6_TES;B6_TIPO;B6_ORIGLAN;B6_EMISSAO;B6_DTDIGIT;B6_QUANT;B6_SALDO;B6_PRUNIT;B6_CUSTO1;B6_PACIENT;B6_DTPROCE;B6_IDENT;;B6_FSLTCTL;B6_FSDTVLD"
    //Private c_SD2Cam    :=  "D2_ITEM;D2_COD;D2_UM;D2_QUANT;D2_PRCVEN;D2_TOTAL;D2_VALIPI;D2_VALICM;D2_TES;D2_CF;D2_IDENTB6;D2_LOTECTL;"
    Private c_SD1Cam    :=  "D1_ITEM;D1_COD;D1_UM;D1_QUANT;D1_VUNIT;D1_TOTAL;D1_VALIPI;D1_VALICM;D1_TES;D1_CF;D1_FSTPP3;D1_FORNECE;D1_LOJA;D1_LOCAL;D1_DOC;D1_EMISSAO;D1_DTDIGIT;D1_SERIE;D1_NFORI;D1_SERIORI;D1_ITEMORI;D1_QTDEDEV;D1_VALDEV;D1_IDENTB6;D1_LOTECTL;"

    Private c_SB6TCam   :=  "B6_CLIFOR;B6_LOJA;B6_NREDUZ;B6_PRODUTO;B6_QUANT;B6_FSLTCTL;B6_FSDTVLD;B6_TES;B6_FSTPP3;B6_UM;B6_SALDO;B6_TPCF;"

    Private aRotina	    :=  MenuDef()

	oBrowse	:= FWmBrowse():New()
	oBrowse:SetAlias("SB1")
    oBrowse:AddLegend( "B1_MSBLQL == '1'", "RED"		, "Inativo"            )   
    oBrowse:AddLegend( "B1_MSBLQL <> '1'", "GREEN"		, "Ativo"              )   
    oBrowse:Activate()

Return()

Static Function MenuDef()

	Local a_Rotina	:= {}

	ADD OPTION a_Rotina TITLE 'Visualizar'	        ACTION  'VIEWDEF.FFATC100'  OPERATION 2 ACCESS 0

Return( a_Rotina )   

Static Function ModelDef()

    Local oModel	:=  MPFormModel():New('FFATC1M' , /*{|o_Mdl| FF001PRE( oModel ) }*/,/*{|o_Mdl| FF001POS( oModel, d_CtFin, c_UserId ) }*/ ,/* { |oModel| FF001GRV( oModel ) }*/,/*bCancel*/)
	Local oStruSB1	:=  FWFormStruct( 1, 'SB1' ) //Cabeçalho - PRODUTOS
    Local oStruSB2	:=  FWFormStruct( 1, 'SB2' ) //Itens - SALDOS PRODUTOS POR ARMAZEM
    Local oStruSB6	:=  FWFormStruct( 1, 'SB6' ) //Itens - MOV ITENS DOC - SALDO EM P3
    //Local oStruSD2	:=  FWFormStruct( 1, 'SD2' ) //Itens - MOV ITENS DOC SAIDA
    Local oStruSD1	:=  FWFormStruct( 1, 'SD1' ) //Itens - MOV ITENS DOC ENTRADA(DEVOLUCAO)

    Local oStruSB6T	:=  FWFormStruct( 1, 'SB6' ) //Itens - MOV ITENS DOC - SALDO EM P3

    Local aStruSB2  := FWSX3Util():GetAllFields( "SB2" , .T. ) //SB2->(DbStruct())
    Local aStruSB6  := FWSX3Util():GetAllFields( "SB6" , .T. ) //SB6->(DbStruct())
    //Local aStruSD2  := FWSX3Util():GetAllFields( "SD2" , .T. ) //SD2->(DbStruct())
    Local aStruSD1  := FWSX3Util():GetAllFields( "SD1" , .T. ) //SD1->(DbStruct())
    Local aStruSB1  := FWSX3Util():GetAllFields( "SB1" , .T. ) //SB1->(DbStruct())

    Local aStruSB6T := FWSX3Util():GetAllFields( "SB6" , .T. ) //SB6->(DbStruct())

    Local nA        := 0
    Local nB        := 0
    //Local nC        := 0
    Local nD        := 0
    Local nE        := 0

    Local nF        := 0

    //Retira campos da SB2
    For nA := 1 To Len( aStruSB2 )
        
        If !(Alltrim( aStruSB2[ nA ] ) $ c_SB2Cam)
            oStruSB2:RemoveField( Alltrim( aStruSB2[ nA ] ) )
         EndIf
    Next

    //Retira campos da SB6
    For nB := 1 To Len( aStruSB6 )
        If !(Alltrim( aStruSB6[ nB ] ) $ c_SB6Cam)
            oStruSB6:RemoveField( Alltrim( aStruSB6[ nB ] ) )
         EndIf
    Next

    //Retira campos da SD2
    //For nC := 1 To Len( aStruSD2 )
    //    If !(Alltrim( aStruSD2[ nC ] ) $ c_SD2Cam)
    //        oStruSD2:RemoveField( Alltrim( aStruSD2[ nC ] ) )
    //     EndIf
    //Next

    //Retira campos da SD1
    For nD := 1 To Len( aStruSD1 )
        If !(Alltrim( aStruSD1[ nD ] ) $ c_SD1Cam)
            oStruSD1:RemoveField( Alltrim( aStruSD1[ nD ] ) )
         EndIf
    Next

    //Retira campos da SB1
    For nE := 1 To Len( aStruSB1 )
        If !(Alltrim( aStruSB1[ nE ] ) $ c_SB1Cam)
            oStruSB1:RemoveField( Alltrim( aStruSB1[ nE ] ) )
         EndIf
    Next

    //Retira campos da SB6 -T - TOTALIZADORES POR LOTE
    For nF := 1 To Len( aStruSB6T )
        If !(Alltrim( aStruSB6T[ nF ] ) $ c_SB6TCam)
            oStruSB6T:RemoveField( Alltrim( aStruSB6T[ nF ] ) )
         EndIf
    Next


 	oModel:AddFields('SB1MASTER',/*cOwner*/,oStruSB1, /*bPre*/, /*bPost*/, /*bLoad*/)

	oModel:AddGrid('SB2GRID'    ,'SB1MASTER',oStruSB2  )
    oModel:AddGrid('SB6GRID'    ,'SB1MASTER',oStruSB6  ,,,,,{|oModelGrid|u_FFATL100(oModelGrid,c_SB6Cam)})
    
    //oModel:AddGrid('SD2GRID'    ,'SB6GRID'  ,oStruSD2  )
    oModel:AddGrid('SD1GRID'    ,'SB6GRID'  ,oStruSD1  )

    oModel:AddGrid('SB6GRIDT'   ,'SB1MASTER',oStruSB6T ,,,,,{|oModelGrid|u_FFATJ100(oModelGrid,c_SB6TCam)})

    //Relacionamento entre cabeçalho x grid - Entre tabelas SB1 x SB2 - SALDOS EM ESTOQUE
    oModel:SetRelation('SB2GRID'   ,{ { 'B2_FILIAL', 'XFILIAL("SB2")' }, { 'B2_COD', 'B1_COD' } }, SB2->( IndexKey( 1 ) ) )
    //Relacionamento entre cabeçalho x grid - Entre tabelas SB1 x SB6 - SALDOS EM PODER DE TERCEIRO
    oModel:SetRelation('SB6GRID'   ,{ { 'B6_FILIAL', 'XFILIAL("SB6")' }, { 'B6_PRODUTO', 'B1_COD' } }, SB6->( IndexKey( 1 ) ) )
    
    //Relacionamento entre cabeçalho x grid - Entre tabelas SB6 x SD2 - SALDOS EM PODER DE TERCEIRO X ITENS DE DOC DE SAIDA
    //oModel:SetRelation('SD2GRID'   ,{ { 'D2_FILIAL', 'XFILIAL("SD2")' }, { 'D2_DOC', 'B6_DOC' }, { 'D2_SERIE', 'B6_SERIE' }, { 'D2_CLIENTE', 'B6_CLIFOR' }, { 'D2_LOJA', 'B6_LOJA' }, { 'D2_COD', 'B6_PRODUTO' }  }, SD2->( IndexKey( 3 ) ) ) //D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_COD, D2_ITEM
    
    //Relacionamento entre cabeçalho x grid - Entre tabelas SB6 x SD2 - SALDOS EM PODER DE TERCEIRO X ITENS DE DOC DE SAIDA
    oModel:SetRelation('SD1GRID'   ,{ { 'D1_FILIAL', 'XFILIAL("SB6")' }, { 'D1_NFORI', 'B6_DOC' }, { 'D1_SERIORI', 'B6_SERIE' }, { 'D1_FORNECE', 'B6_CLIFOR' }, { 'D1_LOJA', 'B6_LOJA' }, { 'D1_IDENTB6', 'B6_IDENT' }  }, SD1->( IndexKey( 26 ) ) ) //D1_FILIAL, D1_NFORI, D1_SERIORI, D1_FORNECE, D1_LOJA

    //Relacionamento entre cabeçalho x grid - Entre tabelas SB1 x SB6 - SALDOS EM PODER DE TERCEIRO - TOTALIZADOS POR LOTE
    oModel:SetRelation('SB6GRIDT'  ,{ { 'B6_FILIAL', 'XFILIAL("SB6")' }, { 'B6_PRODUTO', 'B1_COD' } }, SB6->( IndexKey( 1 ) ) )


    oModel:SetPrimaryKey({'B1_FILIAL','B1_COD'})
	
    //Permite que modelos sejam abertos somente para consulta desabilitando o model para o commit
    oModel:GetModel( "SB2GRID" ):SetOnlyQuery( .T. )
    oModel:GetModel( "SB6GRID" ):SetOnlyQuery( .T. )
    //oModel:GetModel( "SD2GRID" ):SetOnlyQuery( .T. )
    oModel:GetModel( "SD1GRID" ):SetOnlyQuery( .T. )
    
    oModel:GetModel( "SB6GRIDT"):SetOnlyQuery( .T. )

    //Permite fechar o formulario sem a necessidade de gravar itens nas grids
    oModel:GetModel( 'SB2GRID' ):SetOptional( .T.  )
    oModel:GetModel( 'SB6GRID' ):SetOptional( .T.  )
    //oModel:GetModel( 'SD2GRID' ):SetOptional( .T.  )
    oModel:GetModel( 'SD1GRID' ):SetOptional( .T.  )

    oModel:GetModel( 'SB6GRIDT'):SetOptional( .T.  )

    
    //Não permite nenhum tipo de manutencao nas linhas
    oModel:GetModel( 'SB2GRID' ):SetNoInsertLine( .T. )
    oModel:GetModel( 'SB2GRID' ):SetNoUpdateLine( .T. )
    oModel:GetModel( 'SB2GRID' ):SetNoDeleteLine( .T. )

    oModel:GetModel( 'SB6GRID' ):SetNoInsertLine( .T. )
    oModel:GetModel( 'SB6GRID' ):SetNoUpdateLine( .T. )
    oModel:GetModel( 'SB6GRID' ):SetNoDeleteLine( .T. )

    //oModel:GetModel( 'SD2GRID' ):SetNoInsertLine( .T. )
    //oModel:GetModel( 'SD2GRID' ):SetNoUpdateLine( .T. )
    //oModel:GetModel( 'SD2GRID' ):SetNoDeleteLine( .T. )

    oModel:GetModel( 'SD1GRID' ):SetNoInsertLine( .T. )
    oModel:GetModel( 'SD1GRID' ):SetNoUpdateLine( .T. )
    oModel:GetModel( 'SD1GRID' ):SetNoDeleteLine( .T. )

    oModel:GetModel( 'SB6GRIDT'):SetNoInsertLine( .T. )
    oModel:GetModel( 'SB6GRIDT'):SetNoUpdateLine( .T. )
    oModel:GetModel( 'SB6GRIDT'):SetNoDeleteLine( .T. )


    //Aumentando o numero maximo de linhas por grid
    oModel:GetModel('SB2GRID'):SetMaxLine(9999 )
    oModel:GetModel('SB6GRID'):SetMaxLine(9999 )
    //oModel:GetModel('SD2GRID'):SetMaxLine(9999 )
    oModel:GetModel('SD1GRID'):SetMaxLine(9999 )

    oModel:GetModel('SB6GRIDT'):SetMaxLine(9999 )

Return oModel

Static Function ViewDef()

	Local oView		:=  FWFormView():New()
	Local oModel	:=  FWLoadModel('FFATC100')

	Local oStruSB1	:=  FWFormStruct( 2, 'SB1' ) //Cabeçalho - PRODUTOS
    Local oStruSB2	:=  FWFormStruct( 2, 'SB2' ) //Itens - SALDOS PRODUTOS POR ARMAZEM
    Local oStruSB6	:=  FWFormStruct( 2, 'SB6' , { |x| ALLTRIM(x) $ c_SB6Cam } ) //Itens - MOV ITENS DOC - SALDO EM P3
    //Local oStruSD2	:=  FWFormStruct( 2, 'SD2' ) //Itens - MOV ITENS DOC SAIDA
    Local oStruSD1	:=  FWFormStruct( 2, 'SD1' ) //Itens - MOV ITENS DOC ENTRADA(DEVOLUCAO)

    Local oStruSB6T	:=  FWFormStruct( 2, 'SB6' , { |x| ALLTRIM(x) $ c_SB6TCam } ) //TOTALIZADORES POR LOTE - MOV ITENS DOC - SALDO EM P3

    Local aStruSB2  := FWSX3Util():GetAllFields( "SB2" , .T. ) //SB2->(DbStruct())
    Local aStruSB6  := FWSX3Util():GetAllFields( "SB6" , .T. ) //SB6->(DbStruct())
    //Local aStruSD2  := FWSX3Util():GetAllFields( "SD2" , .T. ) //SD2->(DbStruct())
    Local aStruSD1  := FWSX3Util():GetAllFields( "SD1" , .T. ) //SD1->(DbStruct())
    Local aStruSB1  := FWSX3Util():GetAllFields( "SB1" , .T. ) //SB1->(DbStruct())

    Local aStruSB6T := FWSX3Util():GetAllFields( "SB6" , .T. ) //SB6->(DbStruct())

    Local nA        := 0
    Local nB        := 0
    //Local nC        := 0
    Local nD        := 0
    Local nE        := 0

    Local nF        := 0

    //Retira campos da SB2
    For nA := 1 To Len( aStruSB2 )
        
        If !(Alltrim( aStruSB2[ nA ] ) $ c_SB2Cam)
            oStruSB2:RemoveField( Alltrim( aStruSB2[ nA ] ) )
         EndIf
    Next

    //Retira campos da SB6
    For nB := 1 To Len( aStruSB6 )
        If !(Alltrim( aStruSB6[ nB ] ) $ c_SB6Cam)
            oStruSB6:RemoveField( Alltrim( aStruSB6[ nB ] ) )
         EndIf
    Next

    //Retira campos da SD2
    //For nC := 1 To Len( aStruSD2 )
    //    If !(Alltrim( aStruSD2[ nC ] ) $ c_SD2Cam)
    //        oStruSD2:RemoveField( Alltrim( aStruSD2[ nC ] ) )
    //     EndIf
    //Next

    //Retira campos da SD1
    For nD := 1 To Len( aStruSD1 )
        If !(Alltrim( aStruSD1[ nD ] ) $ c_SD1Cam)
            oStruSD1:RemoveField( Alltrim( aStruSD1[ nD ] ) )
         EndIf
    Next

    //Retira campos da SB1
    For nE := 1 To Len( aStruSB1 )
        If !(Alltrim( aStruSB1[ nE ] ) $ c_SB1Cam)
            oStruSB1:RemoveField( Alltrim( aStruSB1[ nE ] ) )
         EndIf
    Next

    //Retira campos da SB6 - TOTALIZADORES POR LOTE
    For nF := 1 To Len( aStruSB6T )
        If !(Alltrim( aStruSB6T[ nF ] ) $ c_SB6TCam)
            oStruSB6T:RemoveField( Alltrim( aStruSB6T[ nF ] ) )
         EndIf
    Next

	oView:SetModel( oModel )

    //------------- Orcamento
	oView:AddField('SB1_VIEW',oStruSB1,'SB1MASTER')

	//------------- Itens - SALDOS EM P3 - TOTALIZADORES POR LOTE
	oView:AddGrid('SB6_VIEWT',oStruSB6T,'SB6GRIDT')


	//------------- Itens - SALDOS EM ESTOQUE
	oView:AddGrid('SB2_VIEW',oStruSB2,'SB2GRID' )

	//------------- Itens - SALDOS EM P3
	oView:AddGrid('SB6_VIEW',oStruSB6,'SB6GRID')

	//------------- Itens - DOCS DE SAIDA
	//oView:AddGrid('SD2_VIEW',oStruSD2,'SD2GRID')

	//------------- Itens - DOCS DE ENTRADA
	oView:AddGrid('SD1_VIEW',oStruSD1,'SD1GRID')

    oView:CreateHorizontalBox( 'SUPERIOR', 30 )
    oView:CreateHorizontalBox( 'INFERIOR', 70 )

    // Cria Folder na view
    oView:CreateFolder( 'PASTAS', "INFERIOR" )

    // Cria pastas nas folders
    oView:AddSheet( 'PASTAS', 'ABA01', 'Saldo em Estoque'               )
    oView:AddSheet( 'PASTAS', 'ABA05', 'Sld.Poder 3o por Lote'          )
    oView:AddSheet( 'PASTAS', 'ABA02', 'Remessa - Sld.Poder 3o por Doc' )
    
    //oView:AddSheet( 'PASTAS', 'ABA03', 'Remessa - Doc de Saida'         )
    
    oView:AddSheet( 'PASTAS', 'ABA04', 'Retorno - Doc de Entrada'       )    
   

    oView:CreateHorizontalBox( 'SB2'    , 100,,, "PASTAS", "ABA01" )
    oView:CreateHorizontalBox( 'SB6T'   , 100,,, "PASTAS", "ABA05" )
    oView:CreateHorizontalBox( 'SB6'    , 100,,, "PASTAS", "ABA02" )
    
    //oView:CreateHorizontalBox( 'SD2'    , 100,,, "PASTAS", "ABA03" )
    
    oView:CreateHorizontalBox( 'SD1'    , 100,,, "PASTAS", "ABA04" )
    
	oView:SetOwnerView( 'SB1_VIEW', 'SUPERIOR'  )
	oView:SetOwnerView( 'SB2_VIEW', 'SB2'       )
    oView:SetOwnerView( 'SB6_VIEWT', 'SB6T'     )
    oView:SetOwnerView( 'SB6_VIEW', 'SB6'       )
	
    //oView:SetOwnerView( 'SD2_VIEW', 'SD2'       )
    
    oView:SetOwnerView( 'SD1_VIEW', 'SD1'       )

	oView:EnableTitleView( 'SB1_VIEW', "Produto - Consulta por "+c_FSNTipo  )
	oView:EnableTitleView( 'SB2_VIEW', 'Saldo em Estoque'                   )
    oView:EnableTitleView( 'SB6_VIEWT','Sld.Poder 3o por Lote'              )
    oView:EnableTitleView( 'SB6_VIEW', 'Remessa - Sld.Poder 3o por Doc'     )
	
    //oView:EnableTitleView( 'SD2_VIEW', 'Remessa - Doc de Saida'             )
	
    oView:EnableTitleView( 'SD1_VIEW', 'Retorno - Doc de Entrada'           )

Return oView


/*/{Protheus.doc} U_FFATN100
Retorna conteudo do campo virtual B6_NREDUZ com nome do cliente ou fornecedor na SB6

exemplo:

U_FFATN100(SB6->B6_TPCF,SB6->B6_CLIFOR,SB6->B6_LOJA)

@type function
@version 12.1.27
@author Eduardo
@since 17/01/2022
@return variant, Nome do cliente / fornecedor
/*/
Function U_FFATN100(c_TpCF,c_CliFor,c_Loja)
Local c_NReduz  :=  ""
Local c_Chave   :=  ""
Local n_TamNRed :=  TamSx3("B6_NREDUZ")[1]
Local c_CampoSA1:=  SuperGetMV("FS_CAMSA1",.F.,"A1_NOME")
Local c_CampoSA2:=  SuperGetMV("FS_CAMSA2",.F.,"A2_NOME")

Default c_TpCF  :=  SB6->B6_TPCF
Default c_CliFor:=  SB6->B6_CLIFOR
Default c_Loja  :=  SB6->B6_LOJA

If !Empty(c_TpCF) .And. !Empty(c_CliFor) .And. !Empty(c_Loja)
    c_Chave   :=  Padr(c_CliFor,TamSx3("B6_CLIFOR")[1]) + Padr(c_Loja,TamSx3("B6_LOJA")[1])
    If      c_TpCF == "C"
        c_NReduz    :=  SubStr( POSICIONE("SA1",1,xFILIAL("SA1")+c_Chave,c_CampoSA1), 1, n_TamNRed )
    ElseIf  c_TpCF == "C"
        c_NReduz    :=  SubStr( POSICIONE("SA2",1,xFILIAL("SA2")+c_Chave,c_CampoSA2), 1, n_TamNRed )
    Endif
Endif

Return(c_NReduz)

/*/{Protheus.doc} U_FFATP100
Retorna conteudo do campo virtual B6_FSTPP3 com tipo de controle de poder de terceiro na prime medical
Retorna conteudo do campo virtual D1_FSTPP3 com tipo de controle de poder de terceiro na prime medical
exemplo:

U_FFATP100(SB6->B6_TES)
U_FFATP100(SD1->D1_TES)

@type function
@version 12.1.27
@author Eduardo
@since 17/01/2022
@return variant, Nome do cliente / fornecedor
/*/
Function U_FFATP100(c_TES)
Local c_NTPP3   :=  ""
Local c_Ret     :=  ""

Default c_TES   :=  SB6->B6_TES

If !Empty(c_TES)
    c_NTPP3 :=  POSICIONE("SF4",1,xFILIAL("SF4")+c_TES,"F4_FSTIPO")
    If !Empty(c_NTPP3)
        If c_NTPP3 == "1"
            c_Ret   := "Consignacao"
        ElseIf c_NTPP3 == "2"
            c_Ret   := "Procedimento"
        Else
            c_Ret   :=  c_NTPP3
        Endif
    Endif
Endif

Return(c_Ret)

/*/{Protheus.doc} u_FFATL100
Carrega Load de dados dos campos associados a Aba Saldos em poder de terceiro - EXTRATO SB6


@type function
@version 12.1.27
@author Eduardo
@since 18/01/2022

/*/
Function u_FFATL100(oModelGrid,c_SB6Cam)
Local a_Load := {}
Local c_Alias:= getNextAlias()
Local c_Query:= ""
Local a_Campo:= {}
Local n_Xn   := 0
Local a_Linha:= {}
Local x_Campo:= ""
Local a_SB6  := FWSX3Util():GetAllFields( "SB6" , .T. )
Local a_SB6Cam:= {}

Default oModelGrid  :=  {}
Default c_SB6Cam    :=  ""

//a_SB6Cam:= StrTokArr2(c_SB6Cam,";",.F.)
For n_Xn := 1 to len(a_SB6)
    If Alltrim( a_SB6[n_Xn] ) $ c_SB6Cam
        x_Campo := Alltrim( a_SB6[n_Xn] )
        Aadd(a_SB6Cam, { x_Campo, Alltrim(	GetSx3Cache(x_Campo,"X3_ORDEM") )  }  )
    Endif
Next
a_SB6Cam := ASort(a_SB6Cam,,,  { | x,y | x[2] < y[2] } )
//ASORT(aIndice, , , { | x,y | x[2] > y[2] } )
For n_Xn := 1 to len(a_SB6Cam)
    Aadd(a_Campo,  a_SB6Cam[n_Xn][1] )
Next

c_Query +=  "SELECT " +ENTER
c_Query +=  " SB6.R_E_C_N_O_ " +ENTER
For n_Xn := 1 to Len(a_Campo)
    x_Campo     :=  a_Campo[n_Xn]
    x_TpCam     :=  Alltrim(	GetSx3Cache(x_Campo,"X3_TIPO")	)
    x_Contexto  :=  Alltrim(	GetSx3Cache(x_Campo,"X3_CONTEXT")	)
    l_CampoReal :=  (x_Contexto <> "V")
    If l_CampoReal    
        If (x_TpCam = "M") //campo memo
            c_Query +=  ","+a_Campo[n_Xn]+"="+"ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), "+a_Campo[n_Xn]+")),' ') " +ENTER
        Else
            c_Query +=  ","+a_Campo[n_Xn] + ENTER
        Endif
    Else
        //Carregando campos virtuais
        If      x_Campo $ "B6_PACIENT"
            c_Query +=  ",  B6_PACIENT	=	C5_PACIENT " +ENTER
        ElseIf  x_Campo $ "B6_DTPROCE"
            c_Query +=  ",	B6_DTPROCE	=	C5_DTPROCE " +ENTER
        ElseIf      x_Campo $ "B6_FSLTCTL"
            c_Query +=  ",  B6_FSLTCTL	=	D2_LOTECTL " +ENTER
        ElseIf  x_Campo $ "B6_FSDTVLD"
            c_Query +=  ",	B6_FSDTVLD	=	D2_DTVALID " +ENTER
        Endif         
    Endif
Next
c_Query +=  "FROM "+RetSqlName("SB6")+" SB6 " +ENTER
c_Query +=  "INNER JOIN "+RetSqlName("SF4")+" SF4 " +ENTER
c_Query +=  "ON     SF4.D_E_L_E_T_  <>  '*' "   +ENTER
c_Query +=  "AND    SF4.F4_FILIAL   =   '"+xFilial("SF4")+"' "  +ENTER
c_Query +=  "AND    SF4.F4_CODIGO   =   SB6.B6_TES "  +ENTER
c_Query +=  "AND    SF4.F4_FSTIPO   =   '"+c_FSTipo+"' " +ENTER
c_Query +=  "INNER JOIN "+RetSqlName("SD2")+ " SD2 " +ENTER
c_Query +=  "ON	    SD2.D_E_L_E_T_	<>	'*' " +ENTER
c_Query +=  "AND	D2_FILIAL	    =   '"+xFilial("SD2")+"' "  +ENTER
c_Query +=  "AND	D2_DOC		    =   B6_DOC " +ENTER
c_Query +=  "AND	D2_SERIE	    =   B6_SERIE " +ENTER
c_Query +=  "AND	D2_CLIENTE	    =   B6_CLIFOR " +ENTER
c_Query +=  "AND	D2_LOJA		    =   B6_LOJA " +ENTER
c_Query +=  "AND	D2_IDENTB6	    =   B6_IDENT " +ENTER
c_Query +=  "INNER JOIN "+RetSqlName("SC5")+" SC5 " +ENTER
c_Query +=  "ON	    SC5.D_E_L_E_T_	<>	'*' " +ENTER
c_Query +=  "AND	C5_FILIAL	    =   '"+xFilial("SC5")+"' "  +ENTER
c_Query +=  "AND	C5_NUM		    = D2_PEDIDO " +ENTER
c_Query +=  "LEFT JOIN "+RetSqlName("SD5")+ " SD5 " +ENTER
c_Query +=  "ON	    SD5.D_E_L_E_T_	<>	'*' " +ENTER
c_Query +=  "AND	D5_FILIAL	    =   '"+xFilial("SD5")+"' "  +ENTER
c_Query +=  "AND	D5_DOC		    =   D2_DOC "  +ENTER
c_Query +=  "AND	D5_SERIE	    =   D2_SERIE "  +ENTER
c_Query +=  "AND    D5_CLIFOR	    =   D2_CLIENTE "  +ENTER
c_Query +=  "AND    D5_LOJA		    =   D2_LOJA "  +ENTER
c_Query +=  "AND    D5_LOTECTL	    =   D2_LOTECTL "  +ENTER
c_Query +=  "AND    D5_NUMSEQ	    =   D2_NUMSEQ "  +ENTER
c_Query +=  "WHERE " +ENTER
c_Query +=  "       SB6.D_E_L_E_T_  <>  '*' "   +ENTER
c_Query +=  "AND    SB6.B6_FILIAL   =   '"+xFilial("SB6")+"' "  +ENTER
c_Query +=  "AND    SB6.B6_PRODUTO  =   '"+SB1->B1_COD+"' "    +ENTER
c_Query +=  "AND    SB6.B6_TPCF     =   'C' " +ENTER
c_Query +=  "AND    SB6.B6_PODER3   =   'R' " +ENTER
c_Query +=  "ORDER BY " +ENTER
c_Query +=  "   SB6.B6_FILIAL " +ENTER
c_Query +=  ",  SB6.B6_CLIFOR " +ENTER
c_Query +=  ",  SB6.B6_LOJA " +ENTER
c_Query +=  ",  SB6.B6_SERIE " +ENTER
c_Query +=  ",  SB6.B6_DOC " +ENTER
c_Query +=  ",  SB6.B6_PRODUTO " +ENTER
c_Query +=  ",  SB6.B6_LOCAL " +ENTER

DbUseArea(.T., "TOPCONN", TcGenQry(,,c_Query), c_Alias, .T., .T.)

(c_Alias)->(dbGoTop())
If (c_Alias)->(!Eof())
    a_Linha :=  {}
    While (c_Alias)->(!Eof())
        a_Linha := {}
        For n_Xn := 1 to Len(a_Campo)
            x_Campo     :=  a_Campo[n_Xn]
            x_TpCam     :=  Alltrim(	GetSx3Cache(x_Campo,"X3_TIPO")	)
            x_Contexto  :=  Alltrim(	GetSx3Cache(x_Campo,"X3_CONTEXT")	)
            l_CampoReal :=  (x_Contexto <> "V")
            
            If l_CampoReal
                
                x_Dado  :=  (c_Alias)->(&(a_Campo[n_Xn]))

                If x_TpCam == "D" //Data
                    If Valtype(x_Dado) <> "D"
                        If  Valtype(x_Dado) == "C"
                            x_Dado  :=  StoD( x_Dado )
                        Else
                            x_Dado  :=  CtoD("  /  /  ")
                        Endif
                    Endif
                ElseIf x_TpCam == "N" //Numerico
                    If Valtype(x_Dado) <> "N"
                        If  Valtype(x_Dado) == "C"
                            x_Dado  :=  Val( x_Dado )
                        Else
                            x_Dado  :=  0.0
                        Endif
                    Endif
                ElseIf x_TpCam $ "C/M" //Caractere / Numerico /MEMO
                    x_Dado := cValToChar( x_Dado )
                ElseIf x_TpCam == "L" //Logico
                    If Valtype(x_Dado) <> "L"                    
                        x_Dado  :=  .F.
                    Endif
                Endif
                
            Else
                //Carregando campos virtuais
                If      x_Campo $ "B6_NREDUZ"
                    x_Relacao   :=  U_FFATN100((c_Alias)->B6_TPCF,(c_Alias)->B6_CLIFOR,(c_Alias)->B6_LOJA)
                ElseIf  x_Campo $ "B6_FSTPP3"
                    x_Relacao   :=  U_FFATP100((c_Alias)->B6_TES)
                ElseIf  x_Campo $ "B6_PACIENT"
                    x_Dado      :=  (c_Alias)->(&(a_Campo[n_Xn]))
                    x_Relacao   :=   cValToChar( x_Dado )
                ElseIf  x_Campo $ "B6_DTPROCE"
                   x_Dado  :=  (c_Alias)->(&(a_Campo[n_Xn]))
                    If !Empty(x_Dado)
                        x_Relacao   :=  StoD( x_Dado )
                    Endif
                    If Empty(x_Relacao)
                        x_Relacao   :=  CtoD("  /  /  ")
                    Endif
               ElseIf   x_Campo $ "B6_FSLTCTL"
                    x_Dado  :=  (c_Alias)->(&(a_Campo[n_Xn]))  
                    x_Relacao   :=  cValToChar( x_Dado )
                ElseIf  x_Campo $ "B6_FSDTVLD"
                    x_Dado  :=  (c_Alias)->(&(a_Campo[n_Xn]))
                    If !Empty(x_Dado)
                        x_Relacao   :=  StoD( x_Dado )
                    Endif
                    If Empty(x_Relacao)
                        x_Relacao   :=  CtoD("  /  /  ")
                    Endif
                Endif
                
                x_Dado := x_Relacao
            
            Endif

            //x_Campo
            aAdd(a_Linha, x_Dado  )
        Next
        
        aAdd(a_Load, {(c_Alias)->R_E_C_N_O_,a_Linha})
        (c_Alias)->(dbSkip())
    Enddo
Endif
(c_Alias)->(dbCloseArea())

Return(a_Load)

/*/{Protheus.doc} u_FFATJ100
Carrega Load de dados dos campos associados a Aba Saldos por Lote em Poder 3o - SB6 totalizado por lote

@type function
@version 12.1.27
@author Eduardo
@since 18/01/2022

/*/
Function u_FFATJ100(oModelGrid,c_SB6TCam)
Local a_Load := {}
Local c_Alias:= getNextAlias()
Local c_Query:= ""
Local a_Campo:= {}
Local n_Xn   := 0
Local a_Linha:= {}
Local x_Campo:= ""
Local a_SB6  := FWSX3Util():GetAllFields( "SB6" , .T. )
Local a_SB6TCam:= {}

Default oModelGrid  :=  {}
Default c_SB6TCam    :=  ""

//a_SB6Cam:= StrTokArr2(c_SB6Cam,";",.F.)
For n_Xn := 1 to len(a_SB6)
    If Alltrim( a_SB6[n_Xn] ) $ c_SB6TCam
        x_Campo := Alltrim( a_SB6[n_Xn] )
        Aadd(a_SB6TCam, { x_Campo, Alltrim(	GetSx3Cache(x_Campo,"X3_ORDEM") )  }  )
    Endif
Next
a_SB6TCam := ASort(a_SB6TCam,,,  { | x,y | x[2] < y[2] } )
//ASORT(aIndice, , , { | x,y | x[2] > y[2] } )
For n_Xn := 1 to len(a_SB6TCam)
    Aadd(a_Campo,  a_SB6TCam[n_Xn][1] )
Next

c_Query +=  "SELECT " +ENTER
c_Query +=  " TOTALIZADOR = 'SALDO POR LOTE'  " +ENTER
For n_Xn := 1 to Len(a_Campo)
    x_Campo     :=  a_Campo[n_Xn]
    x_TpCam     :=  Alltrim(	GetSx3Cache(x_Campo,"X3_TIPO")	)
    x_Contexto  :=  Alltrim(	GetSx3Cache(x_Campo,"X3_CONTEXT")	)
    l_CampoReal :=  (x_Contexto <> "V")
    If l_CampoReal    
        If x_Campo $ "B6_QUANT"
            c_Query +=  ",	B6_QUANT	=	SUM(B6_QUANT) " +ENTER
        ElseIf x_Campo $ "B6_SALDO"
            c_Query +=  ",	B6_SALDO	=	SUM(B6_SALDO) " +ENTER
        ElseIf (x_TpCam = "M") //campo memo
            c_Query +=  ","+a_Campo[n_Xn]+"="+"ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), "+a_Campo[n_Xn]+")),' ') " +ENTER
        Else
            c_Query +=  ","+a_Campo[n_Xn] + ENTER
        Endif
    Else
        //Carregando campos virtuais
        If      x_Campo $ "B6_FSLTCTL"
            c_Query +=  ",  B6_FSLTCTL	=	D2_LOTECTL " +ENTER
        ElseIf  x_Campo $ "B6_FSDTVLD"
            c_Query +=  ",	B6_FSDTVLD	=	MAX(D2_DTVALID) " +ENTER
        Endif
    Endif
Next

c_Query +=  "FROM "+RetSqlName("SB6")+" SB6 " +ENTER
c_Query +=  "INNER JOIN "+RetSqlName("SF4")+" SF4 " +ENTER
c_Query +=  "ON     SF4.D_E_L_E_T_  <>  '*' "   +ENTER
c_Query +=  "AND    SF4.F4_FILIAL   =   '"+xFilial("SF4")+"' "  +ENTER
c_Query +=  "AND    SF4.F4_CODIGO   =   SB6.B6_TES "  +ENTER
c_Query +=  "AND    SF4.F4_FSTIPO   =   '"+c_FSTipo+"' " +ENTER
c_Query +=  "INNER JOIN "+RetSqlName("SD2")+" SD2 " +ENTER
c_Query +=  "ON	    SD2.D_E_L_E_T_	<>	'*' " +ENTER
c_Query +=  "AND    SD2.D2_FILIAL   =   '"+xFilial("SD2")+"' "  +ENTER
c_Query +=  "AND	D2_DOC		    =   B6_DOC " +ENTER
c_Query +=  "AND	D2_SERIE	    =   B6_SERIE " +ENTER
c_Query +=  "AND    D2_CLIENTE	    =   B6_CLIFOR " +ENTER
c_Query +=  "AND    D2_LOJA		    =   B6_LOJA " +ENTER
c_Query +=  "AND    D2_IDENTB6	    =   B6_IDENT " +ENTER
c_Query +=  "INNER JOIN "+RetSqlName("SC5")+" SC5 " +ENTER
c_Query +=  "ON	    SC5.D_E_L_E_T_	<>	'*' " +ENTER
c_Query +=  "AND	C5_FILIAL	    =   '"+xFilial("SC5")+"' "  +ENTER
c_Query +=  "AND	C5_NUM		    = D2_PEDIDO " +ENTER
c_Query +=  "LEFT JOIN "+RetSqlName("SD5")+" SD5 " +ENTER
c_Query +=  "ON	    SD5.D_E_L_E_T_	<>	'*' " +ENTER
c_Query +=  "AND    SD5.D5_FILIAL   =   '"+xFilial("SD5")+"' "  +ENTER
c_Query +=  "AND	D5_DOC		    =   D2_DOC " +ENTER
c_Query +=  "AND	D5_SERIE	    =   D2_SERIE " +ENTER
c_Query +=  "AND    D5_CLIFOR	    =   D2_CLIENTE " +ENTER
c_Query +=  "AND    D5_LOJA		    =   D2_LOJA " +ENTER
c_Query +=  "AND	D5_LOTECTL	    =   D2_LOTECTL " +ENTER
c_Query +=  "AND    D5_NUMSEQ	    =   D2_NUMSEQ " +ENTER
c_Query +=  "WHERE " +ENTER
c_Query +=  "       SB6.D_E_L_E_T_  <>  '*' "   +ENTER
c_Query +=  "AND    SB6.B6_FILIAL   =   '"+xFilial("SB6")+"' "  +ENTER
c_Query +=  "AND    SB6.B6_PRODUTO  =   '"+SB1->B1_COD+"' "    +ENTER
c_Query +=  "AND    SB6.B6_TPCF     =   'C' " +ENTER
c_Query +=  "AND    SB6.B6_PODER3   =   'R' " +ENTER
c_Query +=  "GROUP BY " +ENTER
c_Query +=  "	    B6_CLIFOR " +ENTER
c_Query +=  ",	    B6_LOJA " +ENTER
c_Query +=  ",	    B6_PRODUTO " +ENTER
c_Query +=  ",	    B6_TPCF " +ENTER
c_Query +=  ",	    B6_UM " +ENTER
c_Query +=  ",	    B6_TES " +ENTER
c_Query +=  ",	    D2_LOTECTL " +ENTER

DbUseArea(.T., "TOPCONN", TcGenQry(,,c_Query), c_Alias, .T., .T.)

(c_Alias)->(dbGoTop())
If (c_Alias)->(!Eof())
    a_Linha :=  {}
    n_Reg   :=  0
    While (c_Alias)->(!Eof())
        n_Reg++
        a_Linha := {}
        For n_Xn := 1 to Len(a_Campo)
            x_Campo     :=  a_Campo[n_Xn]
            x_TpCam     :=  Alltrim(	GetSx3Cache(x_Campo,"X3_TIPO")	)
            x_Contexto  :=  Alltrim(	GetSx3Cache(x_Campo,"X3_CONTEXT")	)
            l_CampoReal :=  (x_Contexto <> "V")
            
            If l_CampoReal
                
                x_Dado  :=  (c_Alias)->(&(a_Campo[n_Xn]))

                If x_TpCam == "D" //Data
                    If Valtype(x_Dado) <> "D"
                        If  Valtype(x_Dado) == "C"
                            x_Dado  :=  StoD( x_Dado )
                        Else
                            x_Dado  :=  CtoD("  /  /  ")
                        Endif
                    Endif
                ElseIf x_TpCam == "N" //Numerico
                    If Valtype(x_Dado) <> "N"
                        If  Valtype(x_Dado) == "C"
                            x_Dado  :=  Val( x_Dado )
                        Else
                            x_Dado  :=  0.0
                        Endif
                    Endif
                ElseIf x_TpCam $ "C/M" //Caractere / Numerico /MEMO
                    x_Dado := cValToChar( x_Dado )
                ElseIf x_TpCam == "L" //Logico
                    If Valtype(x_Dado) <> "L"                    
                        x_Dado  :=  .F.
                    Endif
                Endif
                
            Else
                //Carregando campos virtuais
                If      x_Campo $ "B6_FSLTCTL"
                    x_Dado  :=  (c_Alias)->(&(a_Campo[n_Xn]))  
                    x_Relacao   :=  cValToChar( x_Dado )
                ElseIf  x_Campo $ "B6_FSDTVLD"
                    x_Dado  :=  (c_Alias)->(&(a_Campo[n_Xn]))
                    If !Empty(x_Dado)
                        x_Relacao   :=  StoD( x_Dado )
                    Endif
                    If Empty(x_Relacao)
                        x_Relacao   :=  CtoD("  /  /  ")
                    Endif
                ElseIf  x_Campo $ "B6_NREDUZ"
                    x_Relacao   :=  U_FFATN100((c_Alias)->B6_TPCF,(c_Alias)->B6_CLIFOR,(c_Alias)->B6_LOJA)
                ElseIf  x_Campo $ "B6_FSTPP3"
                    x_Relacao   :=  U_FFATP100((c_Alias)->B6_TES)
                Endif                
                
                x_Dado := x_Relacao
            
            Endif

            //x_Campo
            aAdd(a_Linha, x_Dado  )
        Next
        
        aAdd(a_Load, {n_Reg,a_Linha})
        (c_Alias)->(dbSkip())
    Enddo
Endif
(c_Alias)->(dbCloseArea())

Return(a_Load)

/*/{Protheus.doc} u_FFATD100
User function usada para chamar rotina de FFATAC100 - Consulta Poder de terceiro Prime 
filtrando por tipo igual a PROCEDIMENTO.
@type function
@version  12.1.27
@author Eduardo
@since 18/01/2022
@return variant, SEM RETORNO
/*/
Function u_FFATD100() 
    Local c_FSTipo    :=  "2" //1=Consignado;2=Procedimento
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SB1")
    oBrowse:SetMenuDef("FFATC100")    
    u_FFATC100(c_FSTipo) 

RETURN
