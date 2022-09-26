#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} FFATA002
Programa responsavel pelo Cadastro de Região

@author elis.ssa
@since 30/09/2021
@version 1.0

@return ${return}, ${return_description}

@example
(examples)

@see (links_or_references)
/*/

User Function FFATA002()

Local oBrowse	:= Nil

oBrowse := FWmBrowse():New()
oBrowse:SetAlias("ZZ5")	//Cadastro de Região
oBrowse:SetDescription('Cadastro Região')
oBrowse:Activate()

Return()

/*/{Protheus.doc} MenuDef
Funcao responsavel pela criacao do menu de opcoes

@author elis.ssa
@since 30/09/2021
@version 1.0

@return Array, Retorna vetor com as opcoes do menu

@example
(examples)

@see (links_or_references)
/*/
Static Function MenuDef()

Private aRotina := {}

ADD OPTION aRotina TITLE '&Visualizar'	ACTION 'VIEWDEF.FFATA002' 	OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE '&Incluir'	    ACTION 'VIEWDEF.FFATA002' 	OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE '&Alterar'	    ACTION 'VIEWDEF.FFATA002' 	OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE '&Excluir'  	ACTION 'VIEWDEF.FFATA002' 	OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Im&primir'	ACTION 'VIEWDEF.FFATA002' 	OPERATION 8 ACCESS 0
ADD OPTION aRotina TITLE '&Copiar'		ACTION 'VIEWDEF.FFATA002' 	OPERATION 9 ACCESS 0

Return aRotina

//--------------------------------------------------------------------------------------------------------

/*/{Protheus.doc} ModelDef
Funcao responsavel pela ModelDef

@author elis.ssa
@since 30/09/2021
@version 1.0

@return Objeto, Retorna a Model

@example
(examples)

@see (links_or_references)
/*/

Static Function ModelDef()

Local oStruZZ5 := FWFormStruct(1, 'ZZ5' )
Local oModel	:= MPFormModel():New('FFATA02M')

oModel:AddFields( 'ZZ5MASTER', /*cOwner*/, oStruZZ5)
oModel:SetDescription( 'Cadastro de Região' )
oModel:GetModel( 'ZZ5MASTER' ):SetDescription( 'Cadastro de Região')

Return oModel

/*/{Protheus.doc} ViewDef
Funcao responsavel pela ViewDef

@author elis.ssa
@since 30/09/2021
@version 1.0

@return Objeto, Retorna a View

@example
(examples)

@see (links_or_references)
/*/
Static Function ViewDef()

Local oModel 	:= FWLoadModel( 'FFATA002' )
Local oStruZZ5 	:= FWFormStruct( 2, 'ZZ5' )
Local oView		:= FWFormView():New()

oView:SetModel( oModel )
oView:AddField( 'VIEW_ZZ5', oStruZZ5, 'ZZ5MASTER' )
oView:CreateHorizontalBox( 'TELAZZ5' , 100 )
oView:SetOwnerView( 'VIEW_ZZ5', 'TELAZZ5' )

Return oView
