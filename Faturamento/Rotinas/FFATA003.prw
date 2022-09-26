#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} FFATA003
Programa responsavel pelo Cadastro de Convênio

@author elis.ssa
@since 03/12/2021
@version 1.0

@return ${return}, ${return_description}

@example
(examples)

@see (links_or_references)
/*/

User Function FFATA003()

Local oBrowse	:= Nil

oBrowse := FWmBrowse():New()
oBrowse:SetAlias("ZZ6")	//Cadastro de Convênio
oBrowse:SetDescription('Cadastro Convênio')
oBrowse:Activate()

Return()

/*/{Protheus.doc} MenuDef
Funcao responsavel pela criacao do menu de opcoes

@author elis.ssa
@since 03/12/2021
@version 1.0

@return Array, Retorna vetor com as opcoes do menu

@example
(examples)

@see (links_or_references)
/*/
Static Function MenuDef()

Private aRotina := {}

ADD OPTION aRotina TITLE '&Visualizar'	ACTION 'VIEWDEF.FFATA003' 	OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE '&Incluir'	    ACTION 'VIEWDEF.FFATA003' 	OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE '&Alterar'	    ACTION 'VIEWDEF.FFATA003' 	OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE '&Excluir'  	ACTION 'VIEWDEF.FFATA003' 	OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Im&primir'	ACTION 'VIEWDEF.FFATA003' 	OPERATION 8 ACCESS 0
ADD OPTION aRotina TITLE '&Copiar'		ACTION 'VIEWDEF.FFATA003' 	OPERATION 9 ACCESS 0

Return aRotina

//--------------------------------------------------------------------------------------------------------

/*/{Protheus.doc} ModelDef
Funcao responsavel pela ModelDef

@author elis.ssa
@since 03/12/2021
@version 1.0

@return Objeto, Retorna a Model

@example
(examples)

@see (links_or_references)
/*/

Static Function ModelDef()

Local oStruZZ6 := FWFormStruct(1, 'ZZ6' )
Local oModel	:= MPFormModel():New('FFATA03M')

oModel:AddFields( 'ZZ6MASTER', /*cOwner*/, oStruZZ6)
oModel:SetDescription( 'Cadastro de Convênio' )
oModel:GetModel( 'ZZ6MASTER' ):SetDescription( 'Cadastro de Convênio')

Return oModel

/*/{Protheus.doc} ViewDef
Funcao responsavel pela ViewDef

@author elis.ssa
@since 03/12/2021
@version 1.0

@return Objeto, Retorna a View

@example
(examples)

@see (links_or_references)
/*/
Static Function ViewDef()

Local oModel 	:= FWLoadModel( 'FFATA003' )
Local oStruZZ6 	:= FWFormStruct( 2, 'ZZ6' )
Local oView		:= FWFormView():New()

oView:SetModel( oModel )
oView:AddField( 'VIEW_ZZ6', oStruZZ6, 'ZZ6MASTER' )
oView:CreateHorizontalBox( 'TELAZZ6' , 100 )
oView:SetOwnerView( 'VIEW_ZZ6', 'TELAZZ6' )

Return oView
