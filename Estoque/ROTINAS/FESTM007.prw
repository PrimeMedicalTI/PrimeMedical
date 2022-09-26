#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFESTM007  บAutor  ณBeatriz (Totvs Bahia)บData ณ Marco/2022  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ CONSULTA PADRรO PRODUTOS E LOTES			   				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAEST                                                    บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A T U A L I Z A C O E S                           บฑฑ
ฑฑฬออออออออออหอออออออออออออออออออหออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      บANALISTA           บALTERACOES                              บฑฑ
ฑฑบ	         บ					 บ          							  บฑฑ
ฑฑศออออออออออสอออออออออออออออออออสออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

************************
User Function FESTM007()
************************
Local c_Qry		:=""
Local d_Ref		:=Dtos(Date())
Local a_Cabec	:={} 
Local a_Itens	:={}
Local a_RetPesq	:={}
Local l_Ret 	:=.T.

PRIVATE cIndexName := ''
PRIVATE cIndexKey  := ''
PRIVATE cFilter    := ''

a_RetPesq := u_FESTM07A()

a_Cabec := { "Codigo", "Lote", "Validade", "Almox", "Quantidade", "Descricao" } 
a_Itens := {} 

c_Qry+="SELECT B8_PRODUTO, B1_DESC, B8_LOCAL, B8_LOTECTL, B8_DTVALID, B8_SALDO "+CHR(13)+CHR(10)
c_Qry+="FROM "+RetSqlName("SB8")+" SB8 "+CHR(13)+CHR(10)
c_Qry+="	INNER JOIN "+RetSqlName("SB1")+" SB1 ON B8_PRODUTO=B1_COD "+CHR(13)+CHR(10)
c_Qry+="		AND SB1.D_E_L_E_T_<>'*' "+CHR(13)+CHR(10)
c_Qry+="WHERE SB8.D_E_L_E_T_<>'*' "+CHR(13)+CHR(10)
c_Qry+="	AND B8_DTVALID>='"+d_Ref+"' "+CHR(13)+CHR(10)
c_Qry+="	AND B8_SALDO>0 "+CHR(13)+CHR(10)
If		!Empty( a_RetPesq[1][ 1 ] ) .And. !Empty( a_RetPesq[1][ 2 ] )
		c_Qry+="	AND  "+CHR(13)+CHR(10)
		c_Qry+="		( "+CHR(13)+CHR(10)
		c_Qry+="			 B8_PRODUTO LIKE ('%" + Alltrim( a_RetPesq[1][ 1 ] ) + "%') AND B8_LOTECTL LIKE ('%" + Alltrim( a_RetPesq[1][ 2 ] ) + "%') "+CHR(13)+CHR(10)
		c_Qry+="		) "+CHR(13)+CHR(10)
ElseIf 	!Empty( a_RetPesq[1][ 1 ] ) .And. Empty( a_RetPesq[1][ 2 ] )
		c_Qry+="	AND  "+CHR(13)+CHR(10)
		c_Qry+="		( "+CHR(13)+CHR(10)
		c_Qry+="			B8_PRODUTO LIKE ('%" + Alltrim( a_RetPesq[1][ 1 ] ) + "%') "+CHR(13)+CHR(10)
		c_Qry+="		) "+CHR(13)+CHR(10)
Elseif 	Empty( a_RetPesq[1][ 1 ] ) .And. !Empty( a_RetPesq[1][ 2 ] )
		c_Qry+="	AND  "+CHR(13)+CHR(10)
		c_Qry+="		( "+CHR(13)+CHR(10)
		c_Qry+="			B8_LOTECTL LIKE ('%" + Alltrim( a_RetPesq[1][ 2 ] ) + "%') "+CHR(13)+CHR(10)
		c_Qry+="		) "+CHR(13)+CHR(10)
Endif

c_Qry+="ORDER BY B8_PRODUTO, B8_LOTECTL, B8_LOCAL "+CHR(13)+CHR(10)

Memowrite("C:\temp\FESTM007.TXT",c_Qry)

TCQUERY c_Qry NEW ALIAS "q_QRY"
	
q_QRY->(dbGoTop())
	
Do 	While q_QRY->(EoF())=.F.                     

	AAdd( a_Itens, {q_QRY->B8_PRODUTO, q_QRY->B8_LOTECTL, StoD(q_QRY->B8_DTVALID), q_QRY->B8_LOCAL, q_QRY->B8_SALDO, q_QRY->B1_DESC } )            
	
	q_QRY->( dbSkip() ) 
EndDo 
	
q_QRY->(dbCloseArea())  
	
If	Len(a_Itens)=0
	AAdd( a_Itens, {Space(25),Space(40),Ctod(Space(8)),"  ","  ","  "} ) 
Endif

l_Filtro:=.F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTela com os enderecos filtradasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oDlg2      		:= MSDialog():New( 135,254,400,800,"Produtos x Lotes",,,.F.,,,,,,.T.,,,.T. )
oBrw 			:= TWBrowse():New(10,10,10,10,, a_Cabec,,oDlg2,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oBrw:SetArray(a_Itens)
oBrw:Align 		:= CONTROL_ALIGN_ALLCLIENT
oBrw:bLine 		:= {|| a_Itens[oBrw:nAT]}
oBrw:bLDblClick	:= {|| RetVAR_IXB(a_Itens), oDlg2:End()}

oDlg2:Activate(,,,.T.,,,{|| EnchoiceBar(oDlg2,{|| RetVAR_IXB(a_Itens),oDlg2:End()},{|| oDlg2:End()},.F.)})

If 	ValType(VAR_IXB)="U"
	l_Ret:=.F.
Endif 

Return(l_Ret)

***********************************
Static Function RetVAR_IXB(a_Itens)
***********************************

VAR_IXB:=a_Itens[oBrw:nAt][1]+a_Itens[oBrw:nAt][2]+DtoC(a_Itens[oBrw:nAt][3])

Return (VAR_IXB)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณf_Tudo()  บAutor  ณFRANCISCO REZENDE   บ Data ณ  26/11/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao responsavel validar o Ok.                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Prime                                           บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑบ          บ                  บ                                         บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FESTM07A()

Local a_Result	:= {}
Local c_Codigo		:= Space( TamSX3("B1_COD")[1] )
Local c_Lote		:= Space( TamSX3("B8_LOTECTL")[1] )

oFont2     := TFont():New( "Verdana",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )

//oDlgR      := MSDialog():New( 127,309,305,1160,"Filtro de produtos",,,.F.,,,,,,.T.,,oFont2,.T. )
oDlgR      := MSDialog():New( 135,254,250,900,"Filtro de produtos",,,.F.,,,,,,.T.,,oFont2,.T. )
oSayR1      := TSay():New( 004,004,{||"C๓digo:"},oDlgR,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oGetR1      := TGet():New( 002,048,{|u| if(pcount()>0,c_Codigo:=u,c_Codigo)},oDlgR,084,008,'',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayR2      := TSay():New( 004,156,{||"Lote:"},oDlgR,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
oGetR2      := TGet():New( 002,187,{|u| if(pcount()>0,c_Lote:=u,c_Lote)},oDlgR,088,008,'',,CLR_BLACK,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSBtnR1     := SButton():New( 002,280,1,{|| oDlgR:End() },oDlgR,,"", )

oDlgR:Activate(,,,.T.)

AADD( a_Result, { c_Codigo, c_Lote } )

Return( a_Result )
