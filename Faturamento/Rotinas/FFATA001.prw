#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

#define CODIGO 		1
#define DESCRICAO 	2
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FFATA001  �Autor  �ADRIANO ALVES       � Data � outubro/2010���
���          �          �Superv.�FRANCISCO REZENDE   �      �             ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa responsavel por exibir os enderecos filtrados no   ���
���          �momento em que o usuario clicar no botao acessar a consulta ���
���          �padrao do campo - Bairro. A consulta padrao (SXB) Z41 foi   ���
���          �criada para atender essa solicitacao da Citeluz.			  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Citeluz                                         ���
�������������������������������������������������������������������������͹��
���SXB       |XB_ALIAS|XB_TIPO|XB_SEQ|XB_COLUNA|XB_DESCRI|XB_CONTEM       ���
���          |Z41     |1      |01    |RE       |Comp. Bgs|Z41             ���
���          |Z41     |2      |01    |01       |         |U_FFATA001()    ���
���          |Z41     |5      |01    |         |         |VAR_IXB         ���
�������������������������������������������������������������������������͹��
���                        A L T E R A C O E S                            ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FFATA001()

	Local a_Cabec 		:= {"Codigo", "Descri��o", "Grupo"}			//Cabecalho da tela de enderecos
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

//���������������������������������������Ŀ
//�Seleciona os enderecos conforme filtro.�
//�����������������������������������������
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
		Aviso(SM0->M0_NOMECOM,"N�o h� dados a exibir. Verifique o filtro utilizado.",{"Voltar"},2,"Aten��o")
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RetVar_IXB�Autor  �FRANCISCO REZENDE   � Data �  29/10/2009 ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao responsavel por retornar o endereco selecionado pelo ���
���          �usuario.                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Citeluz                                         ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���          �                  �                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RetVAR_IXB()

	VAR_IXB := a_ItmCmp[oBrw:nAt][1]

Return (VAR_IXB)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �f_Tudo()  �Autor  �FRANCISCO REZENDE   � Data �  26/11/2009 ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao responsavel validar o Ok.                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Citeluz                                         ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���          �                  �                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function f_TudoOk()

Return(.T.)

function u_FFATA01A()

	Local a_Result	:= {}
	Local c_Codigo		:= Space( TamSX3("B1_COD")[1] )
	Local c_Descric		:= Space( TamSX3("B1_DESC")[1] )

	oFont2     := TFont():New( "Verdana",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )

	oDlgR      := MSDialog():New( 127,309,305,1160,"Filtro de produtos",,,.F.,,,,,,.T.,,oFont2,.T. )

	oSayR1      := TSay():New( 004,004,{||"C�digo:"},oDlgR,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
	oGetR1      := TGet():New( 002,048,{|u| if(pcount()>0,c_Codigo:=u,c_Codigo)},oDlgR,084,008,'',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

	oSayR2      := TSay():New( 004,136,{||"Descri��o:"},oDlgR,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	oGetR2      := TGet():New( 002,187,{|u| if(pcount()>0,c_Descric:=u,c_Descric)},oDlgR,088,008,'',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

	oGrp1      := TGroup():New( 015,003,083,426," Observa��es ",oDlgR,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay_1     := TSay():New( 030,007,{||"Utilize o caracter coringa % para melhorar o filtro. Por exemplo:"},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,376,008)
	oSay_2     := TSay():New( 040,007,{||"Descri��o que comece com a letra A => A%"},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,404,008)
	oSay_3     := TSay():New( 050,007,{||"Descri��o que termine com as letras TO => %TO"},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,400,008)
	oSay_4     := TSay():New( 060,007,{||"Descri��o que cotenha a palavra TOTVS en qualquer parte => %TOTVS%"},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,416,008)
	oSay_5     := TSay():New( 070,007,{||"Essa funcionlidade serve para os campos C�digo e Descri��o"},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,404,008)

	oSBtnR1     := SButton():New( 002,400,1,{|| oDlgR:End() },oDlgR,,"", )

	oDlgR:Activate(,,,.T.)

	AADD( a_Result, { c_Codigo, c_Descric } )

Return( a_Result )
