#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"

/*/{Protheus.doc} TRPEDC
Relat�rio no modelo TReport que � respons�vel por imprimir os dados do cadatro de clientes, mais precisamente os campos CODIGO, LOJA e NOME
@type function
@author SISTEMATIZEI
@since 24/06/2019
@version 1.0
@see Com a tecla Ctrl PRESSIONADA clique --> https://www.youtube.com/watch?v=jy-ocHaYIKs
/*/
User Function zEST0003()

//VARIAVEIS 
Private oReport  := Nil
Private oSecCab	 := Nil
Private cPerg 	 := "OIJD1A"

//Fun��o que cria as perguntas/filtros que iremos usar no relat�rio, na SX1
ValidPerg()

//Fun��o respons�vel por chamar a pergunta criada na fun��o ValidaPerg, a vari�vel PRIVATE cPerg, � passada.
Pergunte(cPerg,.T.)

//CHAMAMOS AS FUN��ES QUE CONSTRUIR�O O RELAT�RIO
ReportDef()
oReport:PrintDialog()

Return 



/*/{Protheus.doc} ReportDef
Fun��o respons�vel por estruturar as se��es e campos que dar�o forma ao relat�rio, bem como outras caracter�sticas.
Aqui os campos contidos na querie, que voc� quer que apare�a no relat�rio, s�o adicionados
@type function
@author SISTEMATIZEI
@since 24/06/2019
@version 1.0
@see Com a tecla Ctrl PRESSIONADA clique --> https://www.youtube.com/watch?v=H25BvYyPDDY
/*/Static Function ReportDef()

oReport := TReport():New("TRPEDC","Relat�rio - Pedidos Liberados",cPerg,{|oReport| PrintReport(oReport)},"Relat�rio Pedidos Liberados")
oReport:SetLandscape(.T.) // SIGNIFICA QUE O RELAT�RIO SER� EM PAISAGEM

//TrSection serve para constrole da se��o do relat�rio, neste caso, teremos somente uma
oSecCab := TRSection():New( oReport , "Pedidos Liberados"  )

/*
TrCell serve para inserir os campos/colunas que voc� quer no relat�rio, lembrando que devem ser os mesmos campos que cont�m na QUERIE
Um detalhe importante, todos os campos contidos nas linhas abaixo, devem estar na querie, mas.. 
voc� pode colocar campos na querie e adcionar aqui embaixo, conforme a sua necessidade.
*/

//A2_COD, A2_NOME, C7_NUM, C7_EMISSAO,C7_PRODUTO, C7_QUANT

TRCell():New( oSecCab, "C9_PEDIDO"    , "SC9")
TRCell():New( oSecCab, "C9_CLIENTE"    , "SC9")
TRCell():New( oSecCab, "A1_NOME"    , "SA1")
TRCell():New( oSecCab, "C9_PRODUTO"    , "SC9")
TRCell():New( oSecCab, "B1_DESC"    , "SB1")
TRCell():New( oSecCab, "C9_QTDLIB "     , "SC9")
TRCell():New( oSecCab, "C9_LOCAL"    , "SC9")
TRCell():New( oSecCab, "C9_LOTECTL"    , "SC9")
TRCell():New( oSecCab, "C9_DTVALID"    , "SC9")
TRCell():New( oSecCab, "C9_DATALIB"    , "SC9")

oBreak := TRBreak():New(oSecCab,oSecCab:Cell("C9_PEDIDO"),"Sub Total Pedidos")

//ESTA LINHA IR� CONTAR A QUANTIDADE DE REGISTROS LISTADOS NO RELAT�RIO PARA A �NICA SE��O QUE TEMOS
//TRFunction():New(oSecCab:Cell("C9_ITEM"),NIL,"COUNT",oBreak)
//TRFunction():New(oSecCab:Cell("E2_SALDO"),NIL,"SUM",oBreak)

TRFunction():New(oSecCab:Cell("C9_PEDIDO"),,"COUNT")

Return 


/*/{Protheus.doc} PrintReport
Nesta fun��o � inserida a query utilizada para exibi��o dos dados;
A fun��o de PERGUNTAS  � chamada para que os filtros possam ser montados
@type function
@author SISTEMATIZEI
@since 24/06/2019
@version 1.0
@param oReport, objeto, (Descri��o do par�metro)
@see Com a tecla Ctrl PRESSIONADA clique --> https://www.youtube.com/watch?v=vSiJxbiSt8E
/*/Static Function PrintReport(oReport)
Local cAlias := GetNextAlias()


oSecCab:BeginQuery() //Relat�rio come�a a ser estruturado
//INICIO DA QUERY
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
		case when C9_DTVALID  < GETDATE( ) then 'PRODUTO VENCIDO' else CONVERT(Varchar(10),CONVERT(DATE,C9_DTVALID,112),103)  end ,
		CONVERT(Varchar(10),CONVERT(DATE,C9_DATALIB,112),103) 
		 

from %table:SC9% Pedido (Nolock)
inner join  %table:SB1% Produto (Nolock) ON Produto.D_E_L_E_T_ <> '*'
							         AND B1_COD = C9_PRODUTO
inner join  %table:SA1% Cliente (Nolock) ON Cliente.D_E_L_E_T_ <> '*'
							         AND A1_COD = C9_CLIENTE
									 AND A1_LOJA = C9_LOJA
Where 1=1
AND Pedido.C9_FILIAL = '010101'
AND Pedido.D_E_L_E_T_ <> '*'
AND C9_PEDIDO = %exp:(MV_PAR01)% 

//FIM DA QUERY
EndSql


oSecCab:EndQuery() //Fim da Query
oSecCab:Print() //� dada a ordem de impress�o, visto os filtros selecionados

//O Alias utilizado para execu��o da querie � fechado.
(cAlias)->(DbCloseArea())

Return 


/*/{Protheus.doc} ValidPerg
FUN��O RESPONS�VEL POR CRIAR AS PERGUNTAS NA SX1 
@type function
@author PLACIDO / SISTEMATIZEI
@since 24/06/2019
@version 1.0
@see Com a tecla Ctrl PRESSIONADA clique --> https://www.youtube.com/watch?v=vSiJxbiSt8E
/*/Static Function ValidPerg()
	Local aArea  := SX1->(GetArea())
	Local aRegs := {}
	Local i,j

	aadd( aRegs, { cPerg,"01","N�mero do pedido ?","N�mero do pedido ?","N�mero do pedido ?","MV_CH1","C", 10,0,0,"G","","mv_par01","","","mv_par01"," ","",""," ","","","","","","","","","","","","","","","","","","SC9"          } )
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
