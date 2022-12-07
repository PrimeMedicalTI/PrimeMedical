#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"

/*/{Protheus.doc} TRPEDC
Relatório no modelo TReport que é responsável por imprimir os dados do cadatro de clientes, mais precisamente os campos CODIGO, LOJA e NOME
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

//Função que cria as perguntas/filtros que iremos usar no relatório, na SX1
ValidPerg()

//Função responsável por chamar a pergunta criada na função ValidaPerg, a variável PRIVATE cPerg, é passada.
Pergunte(cPerg,.T.)

//CHAMAMOS AS FUNÇÕES QUE CONSTRUIRÃO O RELATÓRIO
ReportDef()
oReport:PrintDialog()

Return 



/*/{Protheus.doc} ReportDef
Função responsável por estruturar as seções e campos que darão forma ao relatório, bem como outras características.
Aqui os campos contidos na querie, que você quer que apareça no relatório, são adicionados
@type function
@author SISTEMATIZEI
@since 24/06/2019
@version 1.0
@see Com a tecla Ctrl PRESSIONADA clique --> https://www.youtube.com/watch?v=H25BvYyPDDY
/*/Static Function ReportDef()

oReport := TReport():New("TRPEDC","Relatório - Pedidos Liberados",cPerg,{|oReport| PrintReport(oReport)},"Relatório Pedidos Liberados")
oReport:SetLandscape(.T.) // SIGNIFICA QUE O RELATÓRIO SERÁ EM PAISAGEM

//TrSection serve para constrole da seção do relatório, neste caso, teremos somente uma
oSecCab := TRSection():New( oReport , "Pedidos Liberados"  )

/*
TrCell serve para inserir os campos/colunas que você quer no relatório, lembrando que devem ser os mesmos campos que contém na QUERIE
Um detalhe importante, todos os campos contidos nas linhas abaixo, devem estar na querie, mas.. 
você pode colocar campos na querie e adcionar aqui embaixo, conforme a sua necessidade.
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

//ESTA LINHA IRÁ CONTAR A QUANTIDADE DE REGISTROS LISTADOS NO RELATÓRIO PARA A ÚNICA SEÇÃO QUE TEMOS
//TRFunction():New(oSecCab:Cell("C9_ITEM"),NIL,"COUNT",oBreak)
//TRFunction():New(oSecCab:Cell("E2_SALDO"),NIL,"SUM",oBreak)

TRFunction():New(oSecCab:Cell("C9_PEDIDO"),,"COUNT")

Return 


/*/{Protheus.doc} PrintReport
Nesta função é inserida a query utilizada para exibição dos dados;
A função de PERGUNTAS  é chamada para que os filtros possam ser montados
@type function
@author SISTEMATIZEI
@since 24/06/2019
@version 1.0
@param oReport, objeto, (Descrição do parâmetro)
@see Com a tecla Ctrl PRESSIONADA clique --> https://www.youtube.com/watch?v=vSiJxbiSt8E
/*/Static Function PrintReport(oReport)
Local cAlias := GetNextAlias()


oSecCab:BeginQuery() //Relatório começa a ser estruturado
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
oSecCab:Print() //É dada a ordem de impressão, visto os filtros selecionados

//O Alias utilizado para execução da querie é fechado.
(cAlias)->(DbCloseArea())

Return 


/*/{Protheus.doc} ValidPerg
FUNÇÃO RESPONSÁVEL POR CRIAR AS PERGUNTAS NA SX1 
@type function
@author PLACIDO / SISTEMATIZEI
@since 24/06/2019
@version 1.0
@see Com a tecla Ctrl PRESSIONADA clique --> https://www.youtube.com/watch?v=vSiJxbiSt8E
/*/Static Function ValidPerg()
	Local aArea  := SX1->(GetArea())
	Local aRegs := {}
	Local i,j

	aadd( aRegs, { cPerg,"01","Número do pedido ?","Número do pedido ?","Número do pedido ?","MV_CH1","C", 10,0,0,"G","","mv_par01","","","mv_par01"," ","",""," ","","","","","","","","","","","","","","","","","","SC9"          } )
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
