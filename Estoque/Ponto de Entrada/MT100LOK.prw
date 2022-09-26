#INCLUDE "rwmake.ch"
#include "topconn.ch"

#DEFINE ENTER CHR(13)+CHR(10)

/*/{Protheus.doc} MT100LOK
centro de custo.  
Ponto de entrada utilizado para validar o preenchimento do
centro de custo.                                          

@type function
@version 12.1.27
@author Francis Macedo
@since 15/07/2016
@return variant, retorno boleano
/*/
User Function MT100LOK

Local c_Orig    := Alltrim(FunName())
Local l_Ret     := .T.
Local c_Mens	:=	""
Local l_vldOper := SuperGetMV("FS_PMVDOPE",.F.,.T.)
//Local c_Tipo 	:= C103TIPO
          
If c_Orig = "MATA103" .And. L103AUTO = .F. .And. aCols[n][Len(aHeader)+1] = .F.

	c_Rateio:= 	aCols[n][aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_RATEIO'})]
	c_Item  := 	aCols[n][aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_ITEM'})]
	c_CC    := 	aCols[n][aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_CC'})]
	c_OPER	:= 	aCols[n][aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_OPER'})]
	d_Valid	:= 	aCols[n][aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_DTVALID'})]
			
	If Empty(c_CC) .And. c_Rateio == '2'.And. FWCodEmp() <> "99"
		AVISO("MT100LOK", "O campo Centro Custo do item " + c_Item + "esta¡ em branco, favor preencher! ", { "OK" }, 1)
		l_Ret := .F.
	Endif
/*
	// Realizar a validação da data de validade do lote
	If c_Tipo <> "B" .And. !Empty(d_Valid) .And. d_Valid < dDataBase
		AVISO("MT100LOK", "A data de validade está menor que a data atual. Item: " + c_Item, { "OK" }, 1)
		l_Ret := .F.
	Endif*/

	If l_vldOper .And. Empty(c_OPER) .And. CTIPO == "B" //Operacao Vazia com Beneficiamento
		c_Mens	+=	"Existem itens da nota sem operação infomada." + ENTER
		c_Mens	+=	"Em notas de beneficiamento o campo operação no grid é obrigatorio." + ENTER
		c_Mens	+=	"Por favor informe-o em todas as linhas do grid."

		msgInfo(c_Mens,"Atenção")
		l_Ret := .F.
	Endif

Endif

Return l_Ret
