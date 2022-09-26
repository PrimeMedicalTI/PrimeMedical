#include "TOTVS.CH"
#include "RESTFUL.CH"

WSRESTFUL PRODUTOESCOLHIDO DESCRIPTION "Listar Produto Escolhido"
    
    WSDATA cbuscar AS STRING    
    WSMETHOD GET  ALL DESCRIPTION 'Retorna dados do Produto Escolhido' WSSYNTAX '/produtoescolhido/id?{cbuscar}' PATH 'id' PRODUCES APPLICATION_JSON

END WSRESTFUL

WSMETHOD GET ALL WSRECEIVE cbuscar WSREST PRODUTOESCOLHIDO
    Local lRet       := .T.
	Local nCount 	 := 1
	Local nRegistros := 0

	Local aQuery     := {}
    Local oJson      := JsonObject():New() 
    Local cJson      := ""   
    Local cAlias := getNextAlias()

    Local cBuscador  := Self:cbuscar
    	
	BeginSql alias cAlias

		Select 

			Rtrim(Marca_ID) + ' - ' + Rtrim(Marca) AS Marca,
			Rtrim(BM_GRUPO) + ' - ' + Rtrim(BM_DESC) AS Grupo,
			Rtrim(D1.D1_COD) AS ID, Produto, ANVISA, Bloqueado,			
			D1_DOC as Nota, 
			F1_SERIE as Serie,
			D1_EMISSAO as Emissao, 
			F1_EST as UFCompra, 

			Round((D1_VUNIT),2) as PrecoUnitario,
			Round((D1_VUNIT + D1_VALIPI/D1_QUANT),2) as PrecoUnitarioComIPI,	

			Case when F4_IPI = 'S' then 'SIM' ELSE 'NAO' end AS Incide_IPI,	
			D1.D1_IPI as AliquotaIPI,
			Round(D1_VALIPI/D1_QUANT,2) as ValorIPI, 
  
			Case when F4_ICM = 'S' then 'SIM' ELSE 'NAO' end AS Incide_ICMS, 	
			D1.D1_PICM as AliquotaICMS,
			18 - D1.D1_PICM as AliquotaICMSDif,	
		
			Round((D1_VUNIT) * (D1.D1_PICM)/100,2) as ValorICMS,
			Round((D1_VUNIT + D1_VALIPI/D1_QUANT) * (18 - D1.D1_PICM)/100,2) as ValorICMSDif, 

			CASE 
				WHEN F4_PISCOF = '1' THEN 'INCIDE PIS' 
				WHEN F4_PISCOF = '2' THEN 'INCIDE COFINS' 
				WHEN F4_PISCOF = '3' THEN 'INCIDE PIS/COFINS' 
				WHEN F4_PISCOF = '4' THEN 'NÃO INCIDE' 
			END AS Incide_PisCofins,

			(Case when (F4_PISCOF = '4') then 0 else D1_ALQPIS end) as AliquotaPIS, 
			Round(((D1_VUNIT - (D1.D1_VALICM/D1_QUANT)) * ((Case when (F4_PISCOF = '4') then 0 else D1_ALQPIS end) * 0.01)),2) as ValorPIS,  
			(Case when (F4_PISCOF = '4') then 0 else D1_ALQCOF end) as AliquotaCOFINS, 
			Round(((D1_VUNIT - (D1.D1_VALICM/D1_QUANT)) * ((Case when (F4_PISCOF = '4') then 0 else D1_ALQCOF end) * 0.01)),2) as ValorCOFINS, 
	
			RTRIM(TipoEntrada.F4_CF) + ' - ' + X5_DESCRI AS CFOP, 
			Rtrim(D1_TES) + ' - ' + TipoEntrada.F4_TEXTO AS TES

		from %table:SD1% D1 (nolock)
		INNER JOIN %table:SF1% Nota (nolock) ON F1_FILIAL = %xfilial:SF1%
										AND Nota.%notDel% 
										AND F1_DOC = D1_DOC
										AND F1_SERIE = D1_SERIE
										AND F1_TIPO = D1_TIPO
										AND F1_FORNECE = D1_FORNECE 
										AND F1_LOJA = D1_LOJA
		Inner Join (
            
					Select 
						BM_GRUPO, BM_DESC, D1_COD, Rtrim(B1_DESC) AS Produto, 
                        Produto.B1_FSCANVI as ANVISA, BM_GRUPO + ' - ' + BM_DESC as Grupo,
				        CASE WHEN B1_MSBLQL = 1 THEN 'SIM' ELSE 'NAO' END AS Bloqueado, 
                        Max(D1.R_E_C_N_O_) as Recno
					from %table:SD1% D1 (nolock)
					INNER JOIN %table:SB1% Produto (nolock) ON B1_FILIAL = %xfilial:SB1%
														AND Produto.%notDel%
														AND B1_COD = D1.D1_COD
					INNER JOIN %table:SBM% Grupo (nolock) ON BM_FILIAL = %xfilial:SBM%
													AND Grupo.%notDel% 
													AND BM_GRUPO = B1_GRUPO
					INNER JOIN %table:SF4% TipoEntrada (nolock) ON TipoEntrada.F4_FILIAL = %xfilial:SF4%
																AND TipoEntrada.%notDel%
																AND TipoEntrada.F4_CODIGO = D1_TES 
																AND TipoEntrada.F4_ESTOQUE = 'S'
																AND TipoEntrada.F4_DUPLIC = 'S'
																AND TipoEntrada.F4_TIPO = 'E'
					Inner Join %table:SX5% CFOP (nolock) ON X5_FILIAL = %xfilial:SX5%
													AND CFOP.%notDel%
													AND X5_TABELA = '13'
													AND X5_CHAVE = TipoEntrada.F4_CF	
					where 1=1
					AND D1_FILIAL = %xfilial:SD1%
					AND D1.%notDel%
					AND D1_TIPO = 'N'
					AND X5_DESCRI like '%COMPRA%'
					AND Rtrim(D1_COD) = %EXP:cBuscador%
					Group by BM_GRUPO, BM_DESC, D1_COD, B1_DESC, B1_FSCANVI, B1_MSBLQL

		) UltimaNota ON UltimaNota.Recno = D1.R_E_C_N_O_
		INNER JOIN %table:SF4% TipoEntrada (nolock) ON TipoEntrada.F4_FILIAL = %xfilial:SF4%
													AND TipoEntrada.%notDel%
													AND TipoEntrada.F4_CODIGO = D1_TES 
													AND TipoEntrada.F4_ESTOQUE = 'S'
													AND TipoEntrada.F4_DUPLIC = 'S'
													AND TipoEntrada.F4_TIPO = 'E'
		Inner Join %table:SX5% CFOP (nolock) ON X5_FILIAL = %xfilial:SX5%
										AND CFOP.%notDel%
										AND X5_TABELA = '13'
										AND X5_CHAVE = TipoEntrada.F4_CF	

		Left Join (
					Select 
						Substring(BM_GRUPO,1,2) as Marca_ID, BM_DESC as Marca 
					from %table:SBM% Marca (nolock)
					Where BM_FILIAL = %xfilial:SBM%
					AND Marca.%notDel%
					AND Substring(BM_GRUPO,1,2) = BM_GRUPO
		) Marca ON Marca.Marca_ID = Substring(BM_GRUPO,1,2)

    EndSql
    
	Count to nRegistros	
	(cAlias)->(dbGoTop())	
			
	WHILE (cAlias)->(!EOF())
    	aAdd(aQuery,JsonObject():New())

            aQuery[nCount]['Marca']     	                := EncodeUTF8(AllTrim((cAlias)->Marca))        
		    aQuery[nCount]['Grupo']     	                := EncodeUTF8(AllTrim((cAlias)->Grupo))   
			aQuery[nCount]['ID']     		                := EncodeUTF8(AllTrim((cAlias)->ID))   
			aQuery[nCount]['Produto']   	                := EncodeUTF8(AllTrim((cAlias)->Produto))   
            aQuery[nCount]['ANVISA']    	                := EncodeUTF8(AllTrim((cAlias)->ANVISA)) 
            aQuery[nCount]['Bloqueado'] 	                := EncodeUTF8(AllTrim((cAlias)->Bloqueado))			
            aQuery[nCount]['Nota'] 	                        := EncodeUTF8(AllTrim((cAlias)->Nota))			
            aQuery[nCount]['Serie'] 	                    := EncodeUTF8(AllTrim((cAlias)->Serie))
            aQuery[nCount]['Emissao'] 	                    := (cAlias)->Emissao
            aQuery[nCount]['UFCompra'] 	                    := EncodeUTF8(AllTrim((cAlias)->UFCompra))
            
			aQuery[nCount]['PrecoUnitario']                 := (cAlias)->PrecoUnitario
            aQuery[nCount]['PrecoUnitarioComIPI']           := (cAlias)->PrecoUnitarioComIPI
            aQuery[nCount]['Incide_IPI'] 	                := EncodeUTF8(AllTrim((cAlias)->Incide_IPI))
            aQuery[nCount]['AliquotaIPI']                   := (cAlias)->AliquotaIPI
            aQuery[nCount]['ValorIPI']                      := (cAlias)->ValorIPI 
            aQuery[nCount]['Incide_ICMS'] 	                := EncodeUTF8(AllTrim((cAlias)->Incide_ICMS))
            
			aQuery[nCount]['AliquotaICMS']                  := (cAlias)->AliquotaICMS
            aQuery[nCount]['AliquotaICMSDif']               := (cAlias)->AliquotaICMSDif  
            aQuery[nCount]['ValorICMS']                     := (cAlias)->ValorICMS
            aQuery[nCount]['ValorICMSDif']                  := (cAlias)->ValorICMSDif
            aQuery[nCount]['Incide_PisCofins'] 	            := EncodeUTF8(AllTrim((cAlias)->Incide_PisCofins))
            
			aQuery[nCount]['AliquotaPIS']                   := (cAlias)->AliquotaPIS
            aQuery[nCount]['ValorPIS']                      := (cAlias)->ValorPIS
            aQuery[nCount]['AliquotaCOFINS']                := (cAlias)->AliquotaCOFINS
            aQuery[nCount]['ValorCOFINS']                   := (cAlias)->ValorCOFINS
            
			aQuery[nCount]['CFOP'] 	                        := EncodeUTF8(AllTrim((cAlias)->CFOP))            
            aQuery[nCount]['TES'] 	                        := EncodeUTF8(AllTrim((cAlias)->TES))					
			 
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


