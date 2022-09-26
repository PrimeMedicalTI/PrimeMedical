#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*/{Protheus.doc} PCCGA003
Programa responsavel pela tela de importacao de cadastros e rotinas

@author francisco.ssa
@since 08/09/2014
@version 11.80

@param c_Rotina, character, (Descrição do parâmetro)

@return Numerico, Retorna 1 se o usurio clicou no botao ok

@example
(examples)

@see (links_or_references)
/*/
User Function PCCGA003( c_Rotina )

	Local n_Ret		:= 0

	//Private c_Arquivo	:= Space(50)

	SetPrvt("oFont1","oDlg1","oGrp1","oSay1","oSay2","oGrp2","oSay3","oGet1","oBtn1","oSBtn1","oSBtn2")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Chamar funcao para validacao de CNPJ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*
	Private o_vldTemp  	 :=clsVldTemplate():new()

	If	!o_vldTemp:mtdAceleradores()

		Return()

	Endif
	*/

	oFont1     := TFont():New( "Verdana",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )

	oDlg1      := MSDialog():New( 092,232,340,714,"Importacoes de Cadastros e Rotinas",,,.F.,,,,,,.T.,,oFont1,.T. )

	oGrp1      := TGroup():New( 004,004,052,244,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay1      := TSay():New( 012,008,{||"Esta rotina tem a finalidade de importar cadastros básicos e rotinas do sistema"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,232,008)
	oSay2      := TSay():New( 036,149,{||"Desenvolvimento Totvs Bahia"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,088,008)

	oGrp2      := TGroup():New( 056,004,108,244,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay3      := TSay():New( 069,008,{||"Localize o layout de importacao:"},oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,096,008)
	oGet1      := TGet():New( 069,104,{|u| iif(pcount()>0, c_Arquivo:=u, c_Arquivo )},oGrp2,136,008,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	oBtn1      := TButton():New( 081,203,"...",oGrp2,{|| f_BuscaLayout() },037,012,,oFont1,,.T.,,"",,,,.F. )

	oSBtn1     := SButton():New( 112,216,1,{|| n_Ret:=1, oDlg1:End() },oDlg1,,"", )
	oSBtn2     := SButton():New( 112,188,2,{|| n_Ret:=2, oDlg1:End() },oDlg1,,"", )

	oDlg1:Activate(,,,.T.)

Return(n_Ret)

/*/{Protheus.doc} f_BuscaLayout
Funcao responsavel por abertura do explorer

@author francisco.ssa
@since 07/04/2014
@version 11.80

@param c_Rotina, character, Nome da Rotina

@return Nil, Nao esperado

@example
(examples)

@see (links_or_references)
/*/
Static Function f_BuscaLayout()

	Local c_Titulo1  	:= "Selecione o arquivo"
	Local c_Extens   	:= "CSV | *.*"
	Local c_Caminho		:= "C:\"

	c_Arquivo	:= cGetFile(c_Extens,c_Titulo1,,c_Caminho,.T.)

Return()
