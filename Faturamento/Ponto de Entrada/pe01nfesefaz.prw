#include "protheus.ch"
#Include 'RwMake.ch'
#Include 'TopConn.ch'

#Define ENTER    Chr(13)+Chr(10)
/*
------------------------------------------------------------------------------------------------------------------
      Nome Programa              pe01nfesefaz.prw
      Descricao                  Ponto de entrada localizado na funùùo XmlNfeSef do rdmake NFESEFAZ. 
                                 Atravùs deste ponto ù possùvel realizar manipulaùùes nos dados do 
                                 produto, mensagens adicionais, destinatùrio, dados da nota, pedido 
                                 de venda ou compra, antes da montagem do XML, no momento da 
                                 transmissùo da NFe. 
      Autor                      Thiago Leal
      Dt criacao                 15/04/2021
-------------------------------------------------------------------------------------------------------------------
*/

User Function PE01NFESEFAZ()

	Local aProd     	:= PARAMIXB[1]
	Local cMensCli  	:= PARAMIXB[2]
	Local cMensFis  	:= PARAMIXB[3]
	Local aDest     	:= PARAMIXB[4] 
	Local aNota     	:= PARAMIXB[5]
	Local aInfoItem 	:= PARAMIXB[6]
	Local aDupl     	:= PARAMIXB[7]
	Local aTransp   	:= PARAMIXB[8]
	Local aEntrega  	:= PARAMIXB[9]
	Local aRetirada 	:= PARAMIXB[10]
	Local aVeiculo  	:= PARAMIXB[11]
	Local aReboque  	:= PARAMIXB[12]
	Local aNfVincRur	:= PARAMIXB[13]
	Local aEspVol     	:= PARAMIXB[14]
	Local aNfVinc     	:= PARAMIXB[15]
	Local AdetPag    	:= PARAMIXB[16]
	Local aObsCont      := PARAMIXB[17]
	Local aRetorno      := {}
    Local nx
	//Local cMsg          := ""

	For nx := 1 to Len(aProd)

		/*
		// Busca a validade do lote
		c_QRY := " SELECT CONVERT(smalldatetime, D5_DTVALID, 103) AS D5_DTVALID  "
		c_QRY += " FROM " + RetSqlName("SD5") 
		c_QRY += " WHERE D5_FILIAL  = '" + xFilial("SD5")    + "'"
		c_QRY += " AND   D5_DOC     = '" + aNota[2]          + "'"
		c_QRY += " AND   D5_SERIE   = '" + aNota[1]          + "'"
		c_QRY += " AND   D5_CLIFOR  = '" + LEFT(aDest[1],8)  + "'"
		c_QRY += " AND   D5_LOJA    = '" + RIGHT(aDest[1],4) + "'"
		c_QRY += " AND   D5_PRODUTO = '" + aProd[nx][2]  + "'"
		c_QRY += " AND   D5_LOTECTL = '" + aProd[nx][19] + "'"
		c_QRY += " AND D_E_L_E_T_  <> '*' "

		TcQuery c_Qry New Alias QRYVAL

		QRYVAL->( DbGoTop() )
		If QRYVAL->(!Eof())
			d_DTVALID := QRYVAL->D5_DTVALID
		Else
			d_DTVALID := " "
		Endif 

		ALERT(d_DTVALID)
		ALERT(valtype(d_DTVALID))

		QRYVAL->( DBCloseArea()) */

		c_CodANV		:= ""
		c_LOTE 			:= ""
		d_DTVALID 		:= ""
		c_CodANV 		:= Posicione("SB1",1,xFilial("SB1")+aProd[nx][2],"B1_FSCANVI")
		c_LOTE 			:= aProd[nx][19]
		d_DTVALID 		:= Posicione("SB8",5,xFilial("SB8")+aProd[nx][2]+aProd[nx][19],"B8_DTVALID")

		//0101010001385512  022486476   350-013-000              03  
/* Comentado em 29/04/2022 - Elis?ela Souza - CGC : 02248647506    / CODIGO: 02248647 - LOJA: 6
 		d_DTVALID 		:= Posicione("SD2",3,xFilial("SD2")+aNota[2]+aNota[1]+LEFT(aDest[1],8)+RIGHT(aDest[1],9,4)+aProd[nx][2]+aInfoItem[nx][4],"D2_DTVALID")

		If Empty(d_DTVALID)
			d_DTVALID 		:= Posicione("SD1",1,xFilial("SD1")+aNota[2]+aNota[1]+LEFT(aDest[1],8)+RIGHT(aDest[1],4)+aProd[nx][2]+aInfoItem[nx][4],"D1_DTVALID")
		Endif
*/
//		aProd[nx][25] 	:= 'ANVISA N '+Alltrim(c_CodANV)+' LOTE: '+Alltrim(c_LOTE)+' VALIDADE: '+ d_DTVALID
		aProd[nx][25] 	:= 'ANVISA: '+Alltrim(c_CodANV)+' LOTE: '+Alltrim(c_LOTE)+' VALIDADE: '+ Dtoc(d_DTVALID)
	Next nx

	cMensFis	:= cMensFis + SF1->F1_FSOBS

	cPaciente	:= Posicione("SC5",1,xFilial("SC5")+aInfoItem[1][1],"C5_PACIENT")
	cMedico 	:= Posicione("SC5",1,xFilial("SC5")+aInfoItem[1][1],"C5_MEDICO")
	
	// Pedido do cliente
	cMensCli := cMensCli + " Pedido do Cliente: " + SC5->C5_FSPEDCL

	// Mensagem de procedimento
	If !Empty(cMedico)
		cMensCli	:= cMensCli + " Medico: " + Alltrim(cMedico) 
	Endif	
	
	If !Empty(cPaciente)
		cMensCli	:= cMensCli + " Paciente: " + Alltrim(cPaciente) + " - Data Procedimento: " + Dtoc(SC5->C5_DTPROCE) + "- Conv?o: " + Alltrim(SC5->C5_CONVENI)
	Endif

	cMensCli := cMensCli + " Pedido Prime: " + SC5->C5_NUM
	cMensCli := cMensCli + " "+ SC5->C5_OBSNOTA

  /*
	cMsg := 'Produto: '+aProd[1][4] + CRLF
	cMsg += 'Mensagem da nota: '+cMensCli + CRLF
	cMsg += 'Mensagem padrao: '+cMensFis + CRLF
	cMsg += 'Destinatario: '+aDest[2] + CRLF   	cMsg += 'Numero da nota: '+aNota[2] + CRLF
	cMsg += 'Pedido: ' +aInfoItem[1][1]+ 'Item PV: ' +aInfoItem[1][2]+ 'Codigo do Tes: ' +aInfoItem[1][3]+ 'Quantidade de itens no pedido: ' +aInfoItem[1][4] + CRLF
	cMsg += 'Existe Duplicata ' + If( len(aDupl) > 0, "SIM", "NAO" )  + CRLF
	cMsg += 'Existe Transporte ' + If( len(aTransp) > 0, "SIM", "NAO" ) + CRLF
	cMsg += 'Existe Entrega ' + If( len(aEntrega) > 0, "SIM", "NAO" ) + CRLF
	cMsg += 'Existe Retirada ' + If( len(aRetirada) > 0, "SIM", "NAO" ) + CRLF
	cMsg += 'Existe Veiculo ' + If( len(aVeiculo) > 0, "SIM", "NAO" ) + CRLF
	cMsg += 'Placa Reboque: ' + IIf(len(aReboque)> 0,aReboque[1],"NAO")+ 'Estado Reboque:' + IIf(len(aReboque) > 1, aReboque[2],"NAO")+ 'RNTC:' + IIf(len(aReboque) >2,aReboque[3],"NAO") + CRLF
	cMsg += 'Nota Produtor Rural Referenciada: ' + If( len(aVeiculo) > 0, "SIM", "SEM NOTA REF." ) + CRLF
	cMsg += 'Especie Volume: ' + If( len(aEspVol) > 0, "SIM", "NAO" ) + CRLF
	cMsg += 'NF Vinculada: ' + If( len(aNfVinc) > 0, "SIM", "NAO" ) + CRLF

	Alert(cMsg)
	//O retorno deve ser exatamente nesta ordem e passando o conteùdo completo dos arrays
	//pois no rdmake nfesefaz ù atribuido o retorno completo para as respectivas variùveis
	//Ordem:
	//      aRetorno[01] -> aProd
	//      aRetorno[02] -> cMensCli
	//      aRetorno[03] -> cMensFis
	//      aRetorno[04] -> aDest
	//      aRetorno[05] -> aNota
	//      aRetorno[06] -> aInfoItem
	//      aRetorno[07] -> aDupl
	//      aRetorno[08] -> aTransp
	//      aRetorno[09] -> aEntrega
	//      aRetorno[10] -> aRetirada
	//      aRetorno[11] -> aVeiculo
	//      aRetorno[12] -> aReboque
	//      aRetorno[13] -> aNfVincRur
	//      aRetorno[14] -> aEspVol
	//      aRetorno[15] -> aNfVinc
	//      aRetorno[16] -> AdetPag
	//      aRetorno[17] -> aObsCont
	*/
	
	aadd(aRetorno,aProd) 
	aadd(aRetorno,cMensCli)
	aadd(aRetorno,cMensFis)
	aadd(aRetorno,aDest)
	aadd(aRetorno,aNota)
	aadd(aRetorno,aInfoItem)
	aadd(aRetorno,aDupl)
	aadd(aRetorno,aTransp)
	aadd(aRetorno,aEntrega)
	aadd(aRetorno,aRetirada)
	aadd(aRetorno,aVeiculo)
	aadd(aRetorno,aReboque)
	aadd(aRetorno,aNfVincRur)
	aadd(aRetorno,aEspVol)
	aadd(aRetorno,aNfVinc)
	aadd(aRetorno,AdetPag)
	aadd(aRetorno,aObsCont)

Return aRetorno

