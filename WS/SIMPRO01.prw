#include "TOTVS.CH"
#include "RESTFUL.CH"

WSRESTFUL PRODUTOS DESCRIPTION "Listar Produtos para uso do Simulador de Vendas da Prime"
    
    WSDATA cbuscar AS STRING    
    WSMETHOD GET  ALL DESCRIPTION 'Retorna todos os registros' WSSYNTAX '/produtos/lista?{cbuscar}' PATH 'lista' PRODUCES APPLICATION_JSON

END WSRESTFUL

WSMETHOD GET ALL WSRECEIVE cbuscar WSREST PRODUTOS
    Local lRet       := .T.
	Local nCount 	 := 1
	Local nRegistros := 0

	Local aQuery     := {}
    Local oJson      := JsonObject():New() 
    Local cJson      := ""   
    Local cAlias := getNextAlias()

    Local cBuscador  := Self:cbuscar
    	
	BeginSql alias cAlias

			SELECT 

				Top 30 Max(D1.R_E_C_N_O_) as Recno, Rtrim(D1_COD) as ID, Rtrim(B1_DESC) AS Produto, 				
				Produto.B1_FSCANVI as ANVISA, BM_GRUPO + ' - ' + BM_DESC as Grupo, 
				Rtrim(B1_ORIGEM) + ' - ' + Upper(Rtrim(Origem.X5_DESCRI)) as Origem, B1_POSIPI as NCM,
				CASE WHEN B1_MSBLQL = 1 THEN 'SIM' ELSE 'NAO' END AS Bloqueado,				
				Isnull((Select Sum(B2_QATU) from SB2010 B2 where B2_FILIAL = '010101' AND D_E_L_E_T_ <> '*' AND B2_COD = D1_COD AND B2_LOCAL in ('01','30')),0) as EstoqueSaldo,
				Isnull((Select Sum(B2_RESERVA) from SB2010 B2 where B2_FILIAL = '010101' AND D_E_L_E_T_ <> '*' AND B2_COD = D1_COD AND B2_LOCAL in ('01','30')),0) as EstoqueReserva,
				Isnull((Select Sum(B2_QATU) - Sum(B2_RESERVA) from SB2010 B2 where B2_FILIAL = '010101' AND D_E_L_E_T_ <> '*' AND B2_COD = D1_COD AND B2_LOCAL in ('01','30')),0) as EstoqueDisponivel
				
			FROM SD1010 D1 (nolock)
			INNER JOIN SB1010 Produto (nolock) ON B1_FILIAL = ''
												   AND Produto.D_E_L_E_T_ <> '*'
												   AND B1_COD = D1.D1_COD
			INNER JOIN SBM010 Grupo (nolock) ON BM_FILIAL = ''
											     AND Grupo.D_E_L_E_T_ <> '*'
											     AND BM_GRUPO = B1_GRUPO
			INNER JOIN SF4010 TipoEntrada (nolock) ON TipoEntrada.F4_FILIAL = ''
													   AND TipoEntrada.D_E_L_E_T_ <> '*'
													   AND TipoEntrada.F4_CODIGO = D1_TES 
													   AND TipoEntrada.F4_ESTOQUE = 'S'
													   AND TipoEntrada.F4_DUPLIC = 'S'
													   AND TipoEntrada.F4_TIPO = 'E'
			Inner Join SX5010 CFOP (nolock) ON CFOP.X5_FILIAL = ''
												AND CFOP.D_E_L_E_T_ <> '*'
												AND CFOP.X5_TABELA = '13'
												AND CFOP.X5_CHAVE = TipoEntrada.F4_CF
			Inner Join SX5010 Origem (nolock) ON Origem.X5_FILIAL = ''
												AND Origem.D_E_L_E_T_ <> '*'
												AND Origem.X5_TABELA = 'S0'
												AND Origem.X5_CHAVE = B1_ORIGEM												
			WHERE D1_FILIAL = '010101'
			AND D1.D_E_L_E_T_ <> '*'
			AND D1_TIPO = 'N'
			AND CFOP.X5_DESCRI like '%COMPRA%'
			AND (Rtrim(D1_COD) + Rtrim(B1_DESC) + Rtrim(B1_FSCANVI)) like '%' + %EXP:cBuscador% + '%'
			Group by D1_COD, B1_DESC, BM_GRUPO, BM_DESC, B1_FSCANVI, B1_MSBLQL, B1_ORIGEM, Origem.X5_DESCRI, B1_POSIPI 
			Order by D1_COD, B1_DESC

    EndSql
    
	Count to nRegistros	
	(cAlias)->(dbGoTop())	
			
	WHILE (cAlias)->(!EOF())
    	aAdd(aQuery,JsonObject():New())
			aQuery[nCount]['Recno']     			:= PADL(ALLTRIM(STR((cAlias)->Recno)),10,"0")    
			aQuery[nCount]['ID']     				:= EncodeUTF8(AllTrim((cAlias)->ID))   
			aQuery[nCount]['Produto']   			:= EncodeUTF8(AllTrim((cAlias)->Produto))   
			aQuery[nCount]['Origem']   				:= EncodeUTF8(AllTrim((cAlias)->Origem)) 
			aQuery[nCount]['NCM']    				:= EncodeUTF8(AllTrim((cAlias)->NCM))
			aQuery[nCount]['ANVISA']    			:= EncodeUTF8(AllTrim((cAlias)->ANVISA))   
			aQuery[nCount]['Grupo']     			:= EncodeUTF8(AllTrim((cAlias)->Grupo))   
			aQuery[nCount]['Bloqueado'] 			:= EncodeUTF8(AllTrim((cAlias)->Bloqueado))  
			aQuery[nCount]['EstoqueSaldo'] 			:= (cAlias)->EstoqueSaldo
			aQuery[nCount]['EstoqueReserva'] 		:= (cAlias)->EstoqueReserva
			aQuery[nCount]['EstoqueDisponivel'] 	:= (cAlias)->EstoqueDisponivel	
		nCount++
		(cAlias)->(dbSkip())
	enddo 
	 
	(cAlias)->(dbCloseArea())

	if nRegistros > 0

		oJson["produtos"] := aQuery 
		cJson   := FwJSonSerialize(oJson)
		::SetResponse(cJson) 			

	Else

		SetRestFault(400,EncodeUTF8('Código do Produto não encontrado!')) 
		lRet := .F.
		Return(lRet)

	Endif

    FreeObj(oJson)

Return lRet


