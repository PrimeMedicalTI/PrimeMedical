#include "Protheus.ch"
#include "Restful.ch"
#include "TBIConn.ch"
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include 'TopConn.ch'
#include "RwMake.ch"

#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

//Variáveis Estáticas
Static cTitulo := "Comissionamento de Vendedores"
/*
------------------------------------------------------------------------------------------------------------
Função		: PRIMEMAIN.PRW
Tipo		: Programa
Descrição	: Programa em MVC para cadastramento do comissionamento dos vendedores
Chamado     : 
Parâmetros	: 
Retorno		:
------------------------------------------------------------------------------------------------------------
Atualizações:
- 31/03/2021 - Fabio A. Moraes - Construção inicial do Fonte
------------------------------------------------------------------------------------------------------------
*/
User Function PRIMEMAIN()

	Local aArea   		:= GetArea()
	Local oBrowse

	Private lMsErroAuto := .F.
	Private nOpc 		:= 0

	//Instânciando FWMBrowse - Somente com dicionário de dados
	oBrowse := FWMBrowse():New()

	//Setando a tabela de cadastro de Autor/Interprete
	oBrowse:SetAlias("ZZ1")
	//Setando a descrição da rotina
	oBrowse:SetDescription(cTitulo)

	//Ativa a Browse
	oBrowse:Activate()

	SetKey( VK_F5 , Nil )

	RestArea(aArea)
Return

Static Function MenuDef()
	Local aRot := {}

	//Adicionando opções
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.PRIMEMAIN' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.PRIMEMAIN' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.PRIMEMAIN' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.PRIMEMAIN' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5

Return aRot

Static Function ModelDef()
	Local oModel 	:= Nil
	Local oRegiao 	:= FWFormStruct(1, 'ZZ0')
	Local oVend 	:= FWFormStruct(1, 'ZZ1')
	Local oGrupo    := FWFormStruct(1, 'ZZ3')
	Local oProduto	:= FWFormStruct(1, 'ZZ4')
	Local aZZ0Rel   := {}
	Local aZZ3Rel	:= {}
	Local aZZ4Rel	:= {}

	//Criando o modelo e os relacionamentos
	//oModel := MPFormModel():New('MD_PRIMEMAIN',,{|oModel|PrimeMainV(oModel)},/*{||commit()}*/,/*{||cancel()}*/)
	oModel := MPFormModel():New('MD_PRIMEMAIN',,,/*{||commit()}*/,/*{||cancel()}*/)
	oModel:AddFields('ZZ1MASTER',,oVend)
	oModel:AddGrid('ZZ0DETAIL','ZZ1MASTER',oRegiao)
	oModel:AddGrid('ZZ3DETAIL','ZZ1MASTER',oGrupo)
	oModel:AddGrid('ZZ4DETAIL','ZZ3DETAIL',oProduto,{|oModel, nLine, cAction, cIDField, xValue, xCurrentValue| u_VldZZ4(oModel, nLine, cAction, cIDField, xValue, xCurrentValue)})

	//Relacionamento entre Região e Vendedor
	aAdd(aZZ0Rel, {'ZZ0_FILIAL','FWxFilial("ZZ0")'})
	aAdd(aZZ0Rel, {'ZZ0_FSCODV','ZZ1_FSCODV'})

	//Fazendo o relacionamento entre Grupo e Vendedor
	aAdd(aZZ3Rel, {'ZZ3_FILIAL','FWxFilial("ZZ3")'})
	aAdd(aZZ3Rel, {'ZZ3_FSCODV','ZZ1_FSCODV'})
//	aAdd(aZZ3Rel, {'ZZ3_FSCODV','ZZ0_FSCODV'})

	//Fazendo o relacionamento entre Produto, Grupo e Vendedor
	aAdd(aZZ4Rel, {'ZZ4_FILIAL','FWxFilial("ZZ4")'})
	aAdd(aZZ4Rel, {'ZZ4_FSCODV','ZZ1_FSCODV'})
//	aAdd(aZZ4Rel, {'ZZ4_FSCODV','ZZ0_FSCODV'})
	aAdd(aZZ4Rel, {'ZZ4_FSCODG','ZZ3_FSCODG'}) 		//Amarracao pelo Grupo

	// Região
	oModel:SetRelation('ZZ0DETAIL', aZZ0Rel, ZZ0->(IndexKey(1))) //IndexKey -> quero a ordenação e depois filtrado
	oModel:GetModel('ZZ0DETAIL'):SetUniqueLine({"ZZ0_FILIAL","ZZ0_FSCODV","ZZ0_FSREGI"})	//Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
	oModel:SetPrimaryKey({})

	// Grupo
	oModel:SetRelation('ZZ3DETAIL', aZZ3Rel, ZZ3->(IndexKey(1))) //IndexKey -> quero a ordenação e depois filtrado
	oModel:GetModel('ZZ3DETAIL'):SetUniqueLine({"ZZ3_FILIAL","ZZ3_FSCODV","ZZ3_FSCODG"})	//Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
	oModel:SetPrimaryKey({})

	// Produto
	oModel:SetRelation('ZZ4DETAIL', aZZ4Rel, ZZ4->(IndexKey(3))) //IndexKey -> quero a ordenação e depois filtrado
	oModel:GetModel('ZZ4DETAIL'):SetUniqueLine({"ZZ4_FILIAL","ZZ4_FSCODV","ZZ4_FSCODG","ZZ4_FSCODP"})	//Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
	oModel:SetPrimaryKey({})

	//Setando as descrições
	oModel:SetDescription("Vendedores")
	oModel:GetModel('ZZ1MASTER'):SetDescription('Modelo Cabeçalho')
	oModel:GetModel('ZZ0DETAIL'):SetDescription('Modelo Itens Filho')
	oModel:GetModel('ZZ3DETAIL'):SetDescription('Modelo Itens Neto')
	oModel:GetModel('ZZ4DETAIL'):SetDescription('Modelo Itens BNeto')

	oModel:GetModel('ZZ0DETAIL'):SetOptional(.T.)
	oModel:GetModel('ZZ3DETAIL'):SetOptional(.T.)
	oModel:GetModel('ZZ4DETAIL'):SetOptional(.T.)

	oModel:SetActivate( {|oModel| SetKey ( VK_F5, {|| u_MarkPrdGrp() } ) } )
	oModel:SetDeActivate( {|oModel| SetKey ( VK_F5, {|| } )} )

Return oModel

Static Function ViewDef()
	Local oView		:= Nil
	Local oModel	:= FWLoadModel('PRIMEMAIN')
	Local oVend		:= FWFormStruct(2, 'ZZ1')
	Local oRegiao	:= FWFormStruct(2, 'ZZ0')
	Local oGrupo	:= FWFormStruct(2, 'ZZ3')
	Local oProduto	:= FWFormStruct(2, 'ZZ4')

	oRegiao:RemoveField("ZZ0_FSCODV")
	oGrupo:RemoveField("ZZ3_FSCODV")
	oGrupo:RemoveField("ZZ3_FSCODC")
	oProduto:RemoveField("ZZ4_FSCODV")
	oProduto:RemoveField("ZZ4_FSCODC")
	oProduto:RemoveField("ZZ4_FSCODG")

	//Criando a View
	oView := FWFormView():New()
	oView:SetModel(oModel)

	//Adicionando os campos do cabeçalho e o grid dos filhos
	oView:AddField('VIEW_ZZ1', oVend   ,'ZZ1MASTER')
	oView:AddGrid('VIEW_ZZ0' , oRegiao ,'ZZ0DETAIL')
	oView:AddGrid('VIEW_ZZ3' , oGrupo  ,'ZZ3DETAIL')
	oView:AddGrid('VIEW_ZZ4' , oProduto,'ZZ4DETAIL')

	//Setando o dimensionamento de tamanho
	oView:CreateHorizontalBox('CABEC',15)
	oView:CreateHorizontalBox('GRID1',25)
	oView:CreateHorizontalBox('GRID2',25)
	oView:CreateHorizontalBox('GRID3',35)

	//Amarrando a view com as box
	oView:SetOwnerView('VIEW_ZZ1','CABEC')
	oView:SetOwnerView('VIEW_ZZ0','GRID1')
	oView:SetOwnerView('VIEW_ZZ3','GRID2')
	oView:SetOwnerView('VIEW_ZZ4','GRID3')

	//Habilitando título
	oView:EnableTitleView('VIEW_ZZ1','Vendedor')
	oView:EnableTitleView('VIEW_ZZ0','Regiao')
	oView:EnableTitleView('VIEW_ZZ3','Grupos de Produtos')
	oView:EnableTitleView('VIEW_ZZ4','Produtos')

	//Adicionando botão para acionar banco de conhecimento de dentro do modelo.
	oView:AddUserButton("Produtos",'CLIPS',{|| u_MarkPrdGrp() })

Return oView

Static Function PrimeMainV(oModel)

	//Validações de campos na gravação ou atualização - 3 inclusão - 4 Atualização
	Local nOperation  := oModel:GetOperation()
	Local lRet        := .T.
	Local nCont       := 0

	nOpc := 3

	If nOperation == 3
		//Valida preenchimento do grid de região
		nQLin  := oModel:GetModel("ZZ0DETAIL"):Length()
		For nCont := 1 To nQlin
			If Empty(oModel:aAllSubModels[2]:aDataModel[nCont][1][1][3]) .or. Empty(oModel:aAllSubModels[2]:aDataModel[nCont][1][1][4]) .or. Empty(oModel:aAllSubModels[2]:aDataModel[nCont][1][1][5])
				MessageBox("Preencha as informações para a região.","Prime Medical - Comissão de Vendedores", 48)
				lRet := .F.
				Return lRet
			EndIf
		Next
/*
		//Valida preenchimento do grid de grupos
		nQLin  := oModel:GetModel("ZZ3DETAIL"):Length()
		For nCont := 1 To nQlin
			If Empty(oModel:aAllSubModels[3]:aDataModel[nCont][1][1][5]) .or. Empty(oModel:aAllSubModels[3]:aDataModel[nCont][1][1][6]) .or. oModel:aAllSubModels[3]:aDataModel[nCont][1][1][7] = 0
				MessageBox("Preencha as informações para o grupo de produtos.","Prime Medical - Comissão de Vendedores", 48)
				lRet := .F.
				Return lRet
			EndIf
		Next

		//Valida preenchimento do grid de produtos
		nQLin  := oModel:GetModel("ZZ4DETAIL"):Length()
		For nCont := 1 To nQlin
			If Empty(oModel:aAllSubModels[4]:aDataModel[nCont][1][1][6]) .or. Empty(oModel:aAllSubModels[4]:aDataModel[nCont][1][1][7]) .or. oModel:aAllSubModels[4]:aDataModel[nCont][1][1][8] = 0
				MessageBox("Preencha as informações para o produto.","Prime Medical - Comissão de Vendedores", 48)
				lRet := .F.
				Return lRet
			EndIf
		Next
*/
	ElseIf nOperation == 4
		//Valida preenchimento do grid de região
		nQLin  := oModel:GetModel("ZZ0DETAIL"):Length()
		For nCont := 1 To nQlin
			If Empty(oModel:aAllSubModels[2]:aDataModel[nCont][1][1][3]) .or. Empty(oModel:aAllSubModels[2]:aDataModel[nCont][1][1][4]) .or. Empty(oModel:aAllSubModels[2]:aDataModel[nCont][1][1][5])
				MessageBox("Preencha as informações para a região.","Prime Medical - Comissão de Vendedores", 48)
				lRet := .F.
				Return lRet
			EndIf
		Next
/*
		//Valida preenchimento do grid de grupos
		nQLin  := oModel:GetModel("ZZ3DETAIL"):Length()
		For nCont := 1 To nQlin
			If Empty(oModel:aAllSubModels[3]:aDataModel[nCont][1][1][5]) .or. Empty(oModel:aAllSubModels[3]:aDataModel[nCont][1][1][6]) .or. oModel:aAllSubModels[3]:aDataModel[nCont][1][1][7] = 0
				MessageBox("Preencha as informações para o grupo de produtos.","Prime Medical - Comissão de Vendedores", 48)
				lRet := .F.
				Return lRet
			EndIf
		Next

		//Valida preenchimento do grid de produtos
		nQLin  := oModel:GetModel("ZZ4DETAIL"):Length()
		For nCont := 1 To nQlin
			If Empty(oModel:aAllSubModels[4]:aDataModel[nCont][1][1][6]) .or. Empty(oModel:aAllSubModels[4]:aDataModel[nCont][1][1][7]) .or. oModel:aAllSubModels[4]:aDataModel[nCont][1][1][8] = 0
				MessageBox("Preencha as informações para o produto.","Prime Medical - Comissão de Vendedores", 48)
				lRet := .F.
			EndIf
		Next
*/	ElseIf nOperation == 5

	EndIf
Return lRet

Function u_VldZZ4(oModel, nLine, cAction, cIDField, xValue, xCurrentValue)

	Local l_Ret		:= .T.
	Local c_GrpDig	:= ""
	Local c_PrdDig	:= ""

	Local o_Model	    :=	FWModelActive()
	//Local n_Operation 	:=  o_Model:GetOperation()
	//Local oStruZZ3	    :=  o_Model:GetModel('ZZ3DETAIL')
	Local oStruZZ4	    :=  o_Model:GetModel('ZZ4DETAIL')

	If !oStruZZ4:IsDeleted()
		c_GrpDig    := o_Model:GetValue( 'ZZ3DETAIL', 'ZZ3_FSCODG' )
		c_PrdDig	:= o_Model:GetValue( 'ZZ4DETAIL', 'ZZ4_FSCODP' )

		DbSelectArea("SB1")
		DbSetOrder(1)
		If DbSeek(FWxFilial("SB1") + c_PrdDig, .T. )
			If c_GrpDig <> SB1->B1_GRUPO
				Help( ,, 'Atenção',, "Este produto não pertence ao grupo selecionado!", 1, 0 )
				l_Ret := .F.
			Endif
		Endif
	Endif

Return( l_Ret )

Function u_MarkPrdGrp()

	Local o_Model	    :=	FWModelActive()
	Local o_View	    :=  FWViewActive()
	//Local oStruZZ3	    :=  o_Model:GetModel('ZZ3DETAIL')
	Local oStruZZ4	    :=  o_Model:GetModel('ZZ4DETAIL')
	Local o_Table 		:= FWTemporaryTable():New( "TRB" )
	Local a_Fields 		:= {}
	Local a_Campos		:= {}
	Local n_Opca		:= 0
	Local c_Codigo		:= Space( TamSX3("B1_COD")[1] )
	Local c_Descric		:= Space( TamSX3("B1_DESC")[1] )

	Private c_Alias		:= GetNextAlias()
	Private c_Marca 	:= GetMark()
	Private c_Grupo		:=  o_Model:GetValue( 'ZZ3DETAIL', 'ZZ3_FSCODG' )
	Private oFont1
	Private Dlg1
	Private Grp1
	Private Say1
	Private Say2
	Private Say3
	Private Say4
	Private Say5
	Private Say6
	Private Say7
	Private Get1
	Private Get2
	Private oGrp2
	Private Brw1
	Private SBtn2
	Private SBtn3

	//--------------------------
	//Monta os campos da tabela
	//--------------------------
	aadd( a_Fields,{"FS_OK"			,"C",2,0} )
	aadd( a_Fields,{"FS_CODIGO"		,"C",TamSX3("B1_COD")[1],0} )
	aadd( a_Fields,{"FS_DESC"		,"C",TamSX3("B1_DESC")[1],0} )

	o_Table:SetFields( a_Fields )
	o_Table:AddIndex("I1", {"FS_CODIGO", "FS_DESC"} )
	o_Table:Create()

	f_SelectProdutos()

	aAdd( a_Campos	,{ "FS_OK"			,,'  '					,'@!' } )
	aAdd( a_Campos	,{ "FS_CODIGO"		,,'Código'				,'@!' } )
	aAdd( a_Campos	,{ "FS_DESC"		,,'Descrição'			,'@!' } )

	oFont1     := TFont():New( "Verdana",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )

	oDlg1      := MSDialog():New( 092,232,660,1270,"Multipla Seleção de Produtos",,,.F.,,,,,,.T.,,oFont1,.T. )

	oGrp1      := TGroup():New( 002,002,052,520," Filtro ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oSay1      := TSay():New( 012,006,{||"Código:"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGet1      := TGet():New( 010,042,{|u| if(pcount()>0,c_Codigo:=u,c_Codigo)},oGrp1,044,008,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

	oSay2      := TSay():New( 024,006,{||"Descrição:"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGet2      := TGet():New( 022,042,{|u| if(pcount()>0,c_Descric:=u,c_Descric)},oGrp1,124,008,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

	oSay3      := TSay():New( 006,177,{||"Utilize o caracter coringa % para melhorar o filtro. Por exemplo:"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,336,008)
	oSay4      := TSay():New( 015,177,{||"Descrição que comece com a letra A => A%"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,336,008)
	oSay5      := TSay():New( 024,177,{||"Descrição que termine com as letras TO => %TO"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,340,008)
	oSay6      := TSay():New( 032,177,{||"Descrição que cotenha a palavra TOTVS en qualquer parte => %TOTVS%"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,340,008)
	oSay7      := TSay():New( 041,177,{||"Essa funcionlidade serve para os campos Código e Descrição"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,336,008)

	oBtn1      := TButton():New( 034,128,"Filtrar",oGrp1,{|| f_SelectProdutos( c_Codigo, c_Descric ) },037,012,,oFont1,,.T.,,"",,,,.F. )

	oGrp2      := TGroup():New( 056,002,268,520," Produtos ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oBrw1      := MsSelect():New( "TRB","FS_OK",,a_Campos,.F.,c_Marca,{064,006,264,514},,, oGrp2 )
	oBrw1:oBrowse:Refresh()
	oBrw1:oBrowse:lHasMark		:= .T.
	oBrw1:oBrowse:lCanAllmark	:= .F.
	oBrw1:oBrowse:bAllMark		:= {|| f_InvertMark() }

	oSBtn2     := SButton():New( 270,493,1,{|| n_Opca := 1, oDlg1:End() },oDlg1,,"", )
	oSBtn3     := SButton():New( 270,466,2,{|| n_Opca := 2, oDlg1:End() },oDlg1,,"", )

	oDlg1:Activate(,,,.T.)

	If n_Opca == 1	

		TRB->( DbGoTop() )
		
//		If !oStruZZ4:IsDeleted() .And. ( ( o_Model:GetValue( 'ZZ4DETAIL', 'ZZ4_FSCOMP' ) ) > 0 .Or. Empty( o_Model:GetValue( 'ZZ4DETAIL', 'ZZ4_FSCODP' ) ))
		If !oStruZZ4:IsDeleted() .And. Empty( o_Model:GetValue( 'ZZ4DETAIL', 'ZZ4_FSCODP' ) )
			oStruZZ4:DeleteLine()
		Endif

		While TRB->( !Eof() )

			If TRB->FS_OK == ThisMark()
				
				oStruZZ4:AddLine()
				oStruZZ4:SetValue( "ZZ4_FSCODP", TRB->FS_CODIGO )
				oStruZZ4:SetValue( "ZZ4_FSDESP", TRB->FS_DESC )

			Endif

			TRB->( Dbskip() )
		Enddo

		oStruZZ4:GoLine( 1 )
		o_View:Refresh('ZZ4DETAIL')

	Endif

	TRB->( DbCloseArea() )

Return()

Static Function f_InvertMark()

	DbSelectArea("TRB")
	TRB->( DbGoTop() )
	while TRB->(!Eof())

		RecLock("TRB",.F.)
		If  TRB->FS_OK <> ThisMark()
			TRB->FS_OK := ThisMark()
		Else
			TRB->FS_OK := "  "
		Endif
		MsUnlock()

		TRB->( DbSkip())

	Enddo

	TRB->( DbGoTop() )
	oBrw1:oBrowse:Refresh()

Return()

Static Function f_SelectProdutos( c_Codigo, c_Descric )

	Local c_Query	:= ""

	If Empty( c_Grupo )
		Help( ,, 'Atenção',, "É necessário informar o Grupo de Produtos!", 1, 0 )
	Else

		If Select( c_Alias ) > 0
			( c_Alias )->( DbCloseArea() )
		EndIf

		TRB->( DbGoTop() )
		While TRB->( !Eof() )

			RecLock( "TRB", .F.)
				DbDelete()
			MsUnlock()

			TRB->( Dbskip())
		Enddo

		c_Query := " SELECT "
		c_Query += " 	B1_COD,  "
		c_Query += "	B1_DESC "
		c_Query += " FROM "
		c_Query += 		RetSqlName("SB1") +  " B1 "
		c_Query += " WHERE "
		c_Query += "	B1.D_E_L_E_T_ = '' "
		c_Query += "	AND B1.B1_GRUPO = '" + c_Grupo + "' "

		If !Empty( c_Codigo ) .And.!Empty( c_Descric )
			c_Query += "	AND  "
			c_Query += "		( "
			c_Query += "			B1.B1_COD LIKE ('" + Alltrim( c_Codigo ) + "') OR B1.B1_DESC LIKE ('" + Alltrim( c_Descric ) + "') "
			c_Query += "		) "
		ElseIf !Empty( c_Codigo ) .And. Empty( c_Descric )

			c_Query += "	AND  "
			c_Query += "		( "
			c_Query += "			B1.B1_COD LIKE ('" + Alltrim( c_Codigo ) + "') "
			c_Query += "		) "

		ElseIf Empty( c_Codigo ) .And. !Empty( c_Descric )

			c_Query += "	AND  "
			c_Query += "		( "
			c_Query += "			B1.B1_DESC LIKE ('" + Alltrim( c_Descric ) + "') "
			c_Query += "		) "

		Endif

		DbUseArea(.T., "TOPCONN", TCGenQry(,,ChangeQuery( c_Query )), c_Alias, .F., .F.)

		While ( c_Alias )->(!Eof())

			RecLock( "TRB", .T.)
				TRB->FS_CODIGO		:= ( c_Alias )->B1_COD
				TRB->FS_DESC		:= ( c_Alias )->B1_DESC
			MsUnlock()

			( c_Alias )->( DbSkip())
		Enddo

		( c_Alias )->( DbCloseArea() )

		TRB->( DbGoTop() )
	Endif

Return()
