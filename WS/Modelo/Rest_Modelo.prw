#include "TOTVS.CH"
#include "RESTFUL.CH"

WSRESTFUL NOME_SERVICO DESCRIPTION "Nome do Serviço"
    
    WSDATA cbuscar AS STRING    
    WSMETHOD GET  ALL DESCRIPTION 'Detalhamento do que é este Serviço' WSSYNTAX '/nome_servico' PATH '/' PRODUCES APPLICATION_JSON

END WSRESTFUL

WSMETHOD GET ALL WSRECEIVE cbuscar WSREST NOME_SERVICO
    Local lRet       := .T.
	Local nCount 	 := 1
	Local nRegistros := 0

	Local aQuery     := {}
    Local oJson      := JsonObject():New() 
    Local cJson      := ""   
    Local cAlias := getNextAlias()
    	
	BeginSql alias cAlias

		Select 
			B8_FILIAL as Empresa, EstoquePorLote.R_E_C_N_O_ as Recno, 	
			Rtrim(Marca_ID) + ' - ' + Rtrim(Marca) AS Marca,
			Rtrim(B1_GRUPO) + ' - ' + Rtrim(BM_DESC) AS Grupo,
			B8_PRODUTO as ID, B1_DESC as Produto, B8_LOTECTL as Lote, B8_DTVALID as Validade, B8_DATA as Entrada, B8_SALDO as Saldo, B8_LOCAL + ' - ' + NNR_DESCRI as Local 
		from SB8010 EstoquePorLote
		Inner Join NNR010 Armazem ON NNR_FILIAL = B8_FILIAL
								AND Armazem.D_E_L_E_T_ <> '*'
								AND Armazem.NNR_CODIGO = B8_LOCAL
		Inner Join SB1010 Produto (nolock) On Produto.B1_FILIAL = ''
										AND Produto.D_E_L_E_T_ <> '*'
										AND Produto.B1_COD = B8_PRODUTO
		INNER JOIN SBM010 Grupo (nolock) ON BM_FILIAL = ''
										AND Grupo.D_E_L_E_T_ <> '*' 
										AND BM_GRUPO  = B1_GRUPO 
		Inner Join (
					Select 
						Substring(BM_GRUPO,1,2) as Marca_ID, BM_DESC as Marca 
					from SBM010 Marca (nolock)
					Where BM_FILIAL = ''
					AND Marca.D_E_L_E_T_ <> '*'
					AND Substring(BM_GRUPO,1,2) = BM_GRUPO
		) Marca ON Marca.Marca_ID = Substring(Grupo.BM_GRUPO,1,2)	
		Where 1=1
		AND EstoquePorLote.D_E_L_E_T_ <> '*'
		AND B8_SALDO > 0
		Order by ID

    EndSql
    
	Count to nRegistros	
	(cAlias)->(dbGoTop())	
			
	WHILE (cAlias)->(!EOF())
    	aAdd(aQuery,JsonObject():New())
			aQuery[nCount]['Recno']              := PADL(ALLTRIM(STR((cAlias)->Recno)),10,"0")    
			aQuery[nCount]['COF_CodSitTrib']     := EncodeUTF8(AllTrim((cAlias)->COF_CodSitTrib))
			aQuery[nCount]['PIS_Perc']     		 := (cAlias)->PIS_Perc
			aQuery[nCount]['COF_Perc']    		 := (cAlias)->COF_Perc			
			aQuery[nCount]['Filial']             := EncodeUTF8(AllTrim((cAlias)->Filial))
		nCount++
		(cAlias)->(dbSkip())
	enddo 
	 
	(cAlias)->(dbCloseArea())

	if nRegistros > 0

		oJson["nome_servico"] := aQuery 
		cJson   := FwJSonSerialize(oJson)
		::SetResponse(cJson) 			

	Else

		SetRestFault(400,EncodeUTF8('Registro Não encontrado!')) 
		lRet := .F.
		Return(lRet)

	Endif

    FreeObj(oJson)

Return lRet


