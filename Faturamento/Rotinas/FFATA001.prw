#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

#define CODIGO 		1
#define DESCRICAO 	2
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FFATA001  ºAutor  ³ADRIANO ALVES       º Data ³ outubro/2010º±±
±±º          ³          ºSuperv.³FRANCISCO REZENDE   º      ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa responsavel por exibir os enderecos filtrados no   º±±
±±º          ³momento em que o usuario clicar no botao acessar a consulta º±±
±±º          ³padrao do campo - Bairro. A consulta padrao (SXB) Z41 foi   º±±
±±º          ³criada para atender essa solicitacao da Citeluz.			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Citeluz                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSXB       |XB_ALIAS|XB_TIPO|XB_SEQ|XB_COLUNA|XB_DESCRI|XB_CONTEM       º±±
±±º          |Z41     |1      |01    |RE       |Comp. Bgs|Z41             º±±
±±º          |Z41     |2      |01    |01       |         |U_FFATA001()    º±±
±±º          |Z41     |5      |01    |         |         |VAR_IXB         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                        A L T E R A C O E S                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FFATA001()

	Local a_Cabec 		:= {"Codigo", "Descrição", "Grupo"}			//Cabecalho da tela de enderecos
	Local VAR_IXB 		:= Space(14)	//Variavel de retorno da tela de enderecos
	Local c_Query		:= ""
	Local c_Alias		:= GetNextAlias()

	Local o_Model	    :=	FWModelActive()
	Local oStruZZ3	    :=  o_Model:GetModel('ZZ3DETAIL')
	Local c_Grupo		:=  o_Model:GetValue( 'ZZ3DETAIL', 'ZZ3_FSCODG' )

	Local a_RetPesq		:= {}
	Local a_Buttons		:= {{'Pesquisar', {|| a_RetPesq := u_FFATA01A() },'Pesquisar'}}

	Private a_ItmCmp 	:= {}

	Private oFont1     := TFont():New( "Calibri",0,-12,,.F.,0,,400,.F.,.F.,,,,,, )

	a_RetPesq := u_FFATA01A()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Seleciona os enderecos conforme filtro.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	c_Query := " SELECT "
	c_Query += " 	B1_COD,  "
	c_Query += "	B1_DESC, "
	c_Query += "	B1_GRUPO "
	c_Query += " FROM "
	c_Query += 		RETSQLNAME("SB1") +  " B1 "
	c_Query += " WHERE "
	c_Query += "	B1.D_E_L_E_T_ = '' "
	c_Query += "	AND B1.B1_GRUPO = '" + c_Grupo + "' "

	if !Empty( a_RetPesq[1][ 1 ] ) .And.!Empty( a_RetPesq[1][ 2 ] )
		c_Query += "	AND  "
		c_Query += "		( "
		c_Query += "			B1.B1_COD LIKE ('" + Alltrim( a_RetPesq[1][ 1 ] ) + "') OR B1.B1_DESC LIKE ('" + Alltrim( a_RetPesq[1][ 2 ] ) + "') "
		c_Query += "		) "
	elseif !Empty( a_RetPesq[1][ 1 ] ) .And. Empty( a_RetPesq[1][ 2 ] )

		c_Query += "	AND  "
		c_Query += "		( "
		c_Query += "			B1.B1_COD LIKE ('" + Alltrim( a_RetPesq[1][ 1 ] ) + "') "
		c_Query += "		) "

	elseif Empty( a_RetPesq[1][ 1 ] ) .And. !Empty( a_RetPesq[1][ 2 ] )

		c_Query += "	AND  "
		c_Query += "		( "
		c_Query += "			B1.B1_DESC LIKE ('" + Alltrim( a_RetPesq[1][ 2 ] ) + "') "
		c_Query += "		) "

	endif

	DbUseArea(.T., "TOPCONN", TCGenQry(,,ChangeQuery( c_Query )), c_Alias, .F., .F.)

	WHILE ( c_Alias )->(!Eof())
		AAdd(a_ItmCmp, { ( c_Alias )->B1_COD, ( c_Alias )->B1_DESC, ( c_Alias )->B1_GRUPO } )
		( c_Alias )->(dbskip())
	ENDDO
	( c_Alias )->(DBCLOSEAREA())

	IF LEN(a_ItmCmp) == 0
		Aviso(SM0->M0_NOMECOM,"Não há dados a exibir. Verifique o filtro utilizado.",{"Voltar"},2,"Atenção")
		Return(.T.)
	ENDIF

	oDlgN      := MSDialog():New( 127,309,389,1185,"Projetos Totvs Leste",,,.F.,,,,,,.T.,,oFont1,.T. )
	oBrw 		:= TWBrowse():New(16,10,120,428,, a_Cabec,,oDlgN,,,,,,,,,,,,.F.,,.T.,,.F.,,,)

	oBrw:SetArray(a_ItmCmp)
	oBrw:Align 		:= CONTROL_ALIGN_ALLCLIENT
	oBrw:bLine 		:= {|| a_ItmCmp[oBrw:nAT]}
	oBrw:bLDblClick	:= {|| RetVAR_IXB(), oDlgN:End()}

	oDlgN:Activate(,,,.T.,,,{|| EnchoiceBar(oDlgN,{|| RetVAR_IXB(),oDlgN:End()},{|| oDlgN:End()},.F.)})	//,a_Buttons)})

Return(.T.)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RetVar_IXBºAutor  ³FRANCISCO REZENDE   º Data ³  29/10/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao responsavel por retornar o endereco selecionado pelo º±±
±±º          ³usuario.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Citeluz                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±º          º                  º                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RetVAR_IXB()

	VAR_IXB := a_ItmCmp[oBrw:nAt][1]

Return (VAR_IXB)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³f_Tudo()  ºAutor  ³FRANCISCO REZENDE   º Data ³  26/11/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao responsavel validar o Ok.                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Citeluz                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±º          º                  º                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function f_TudoOk()

Return(.T.)

function u_FFATA01A()

	Local a_Result	:= {}
	Local c_Codigo		:= Space( TamSX3("B1_COD")[1] )
	Local c_Descric		:= Space( TamSX3("B1_DESC")[1] )

	oFont2     := TFont():New( "Verdana",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )

	oDlgR      := MSDialog():New( 127,309,305,1160,"Filtro de produtos",,,.F.,,,,,,.T.,,oFont2,.T. )

	oSayR1      := TSay():New( 004,004,{||"Código:"},oDlgR,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
	oGetR1      := TGet():New( 002,048,{|u| if(pcount()>0,c_Codigo:=u,c_Codigo)},oDlgR,084,008,'',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

	oSayR2      := TSay():New( 004,136,{||"Descrição:"},oDlgR,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	oGetR2      := TGet():New( 002,187,{|u| if(pcount()>0,c_Descric:=u,c_Descric)},oDlgR,088,008,'',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

	oGrp1      := TGroup():New( 015,003,083,426," Observações ",oDlgR,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay_1     := TSay():New( 030,007,{||"Utilize o caracter coringa % para melhorar o filtro. Por exemplo:"},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,376,008)
	oSay_2     := TSay():New( 040,007,{||"Descrição que comece com a letra A => A%"},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,404,008)
	oSay_3     := TSay():New( 050,007,{||"Descrição que termine com as letras TO => %TO"},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,400,008)
	oSay_4     := TSay():New( 060,007,{||"Descrição que cotenha a palavra TOTVS en qualquer parte => %TOTVS%"},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,416,008)
	oSay_5     := TSay():New( 070,007,{||"Essa funcionlidade serve para os campos Código e Descrição"},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,404,008)

	oSBtnR1     := SButton():New( 002,400,1,{|| oDlgR:End() },oDlgR,,"", )

	oDlgR:Activate(,,,.T.)

	AADD( a_Result, { c_Codigo, c_Descric } )

Return( a_Result )
