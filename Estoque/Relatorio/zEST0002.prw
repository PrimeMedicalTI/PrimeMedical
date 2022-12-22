#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"

User Function zEST0002()
Private oReport    := Nil
Private oSection1  := Nil //Primeira Sessão
Private oSection2  := Nil //Segunda  Sessão
Private oSection3  := Nil //Terceira  Sessão
Private cPerg 	 := "EST0002"


ValidPerg()


Pergunte(cPerg,.T.)


ReportDef()
oReport:PrintDialog()


Return 

Static Function ReportDef()
oReport := TReport():New("EST0002","Relatório - Pedido Liberado",cPerg,{|oReport| PrintReport(oReport)},"Relatório - Pedido Liberado")
oReport:SetLandscape(.T.) 

oSection1 := TRSection():New(oReport,"Pedido","SC9")
TRCell():New( oSection1, "C9_PEDIDO"      , "SC9")
TRCell():New( oSection1, "C9_CLIENTE"    , "SC9")
TRCell():New( oSection1, "A1_NOME"     , "SA1")
TRCell():New( oSection1, "A1_END"    , "SA1")
TRCell():New( oSection1, "A1_MUN"  , "SA1")
TRCell():New( oSection1, "A1_BAIRRO"  , "SA1")

oSection2 := TRSection():New( oSection1 , "C5_OBSINTE","SC5" ) 
TRCell():New( oSection2, "C5_OBSINTE"     , "SC5")

oSection3 := TRSection():New( oSection2 , "C9_PRODUTO","SC9" ) 
TRCell():New( oSection3, "C9_PRODUTO"     , "SC9")
TRCell():New( oSection3, "B1_DESC"     , "SB1")
TRCell():New( oSection3, "C9_QTDLIB"     , "SC9")
TRCell():New( oSection3, "C9_LOCAL"     , "SC9")
TRCell():New( oSection3, "C9_LOTECTL"     , "SC9")
TRCell():New( oSection3, "C9_DTVALID"     , "SC9")

//TRFunction():New(oSection2:Cell("C5_OBSINTE"),,"SC5")
//TRFunction():New(oSection2:Cell("F1_DOC"),,"COUNT")

Return 

Static Function PrintReport(oReport)
Local cAlias := GetNextAlias()

oSection1:BeginQuery() 
BeginSql Alias cAlias

select 
		C9_PEDIDO ,
		C9_CLIENTE,
		A1_NOME ,
		C9_PRODUTO , 
		B1_DESC ,
		C9_QTDLIB,
		C9_LOCAL ,
		C9_LOTECTL,
		C9_DTVALID ,
		C5_OBSINTE, A1_END,A1_BAIRRO,A1_MUN
	
from %table:SC9% Pedido (Nolock)
inner join  %table:SB1% Produto (Nolock) ON Produto.D_E_L_E_T_ <> '*'
							         AND B1_COD = C9_PRODUTO
inner join  %table:SA1% Cliente (Nolock) ON Cliente.D_E_L_E_T_ <> '*'
							         AND A1_COD = C9_CLIENTE
									 AND A1_LOJA = C9_LOJA
inner join  %table:SC5% ped (Nolock) ON ped.D_E_L_E_T_ <> '*'
							         AND C9_PEDIDO = C5_NUM
									 AND C9_CLIENTE = C5_CLIENTE									 
Where 1=1
//AND Pedido.C9_FILIAL = '010101'
AND Pedido.D_E_L_E_T_ <> '*'
AND C9_PEDIDO = %exp:(MV_PAR01)%   
		
EndSql

oSection1:EndQuery() //Fim da Query
oSection2:SetParentQuery() 
oSection3:SetParentQuery() 

//oSection2:SetParentFilter({|cForLoja| (cAlias)->C9_CLIENTE+(cAlias)->A1_NOME = cForLoja},{|| (cAlias)->C9_CLIENTE+(cAlias)->A1_NOME})

oSection1:Print() 
oSection2:Print()
oSection3:Print() 

//O Alias utilizado para execução da querie é fechado.
(cAlias)->(DbCloseArea())

Return 


Static Function ValidPerg()
	Local aArea  := SX1->(GetArea())
	Local aRegs := {}
	Local i,j

	aadd( aRegs, { cPerg,"01","Pedido ?","Pedido ?","Pedido ?","MV_CH0","C", 6,0,0,"G","","mv_par01","","",""," ","",""," ","","","","","","","","","","","","","","","","","","SC9"          } )
	//aadd( aRegs, { cPerg,"02","Fornecedor ate ?","Fornecedor ate ?","Fornecedor ate ?","mv_ch2","C", 6,0,0,"G","","mv_par02","","","mv_par02"," ","",""," ","","","","","","","","","","","","","","","","","","SA2"       } )

	DbselectArea('SX1')
	SX1->(DBSETORDER(1))
	For i:= 1 To Len(aRegs)
		If ! SX1->(DBSEEK( AvKey(cPerg,"X1_GRUPO") +aRegs[i,2]) )
			Reclock('SX1', .T.)
			FOR j:= 1 to SX1->( FCOUNT() )
				IF j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				ENDIF
			Next j
			SX1->(MsUnlock())
		Endif
	Next i 
	RestArea(aArea) 
Return(cPerg)
