#include "TOTVS.CH"
#include "RESTFUL.CH"

WSRESTFUL CALCULARPORPRECOVENDA DESCRIPTION "Calcular Lucro definindo por um preço de venda"
    
    aUrl := '/calcularporprecovenda?'
	
	// Produto	
	aUrl += 'ProdutoID={cProdutoID}'
	//Consumidor Final? 
	aUrl += '&ConsumidorFinal={nConsumidorFinal}' 		
	// Estado de Venda
	aUrl += '&EstadoVenda={cEstadoVenda}' 
	// Receita de Venda
	aUrl += '&PrecoDeVenda={nPrecoDeVenda}' 
	// Comissão
	aUrl += '&ComissaoPerc={nComissaoPerc}' 
	// Custo Operacional
	aUrl += '&CustoOperacionalPerc={nCustoOperacionalPerc}' 
	// Outras Despesas 
	aUrl += '&OutrasDespesas={nOutrasDespesas}' 
	// FreteTerrestrePorto 
	aUrl += '&FreteTerrestrePorto={nFreteTerrestrePorto}' 
	// FreteMaritimo 
	aUrl += '&FreteMaritimo={nFreteMaritimo}' 	
	// Armazenagem 
	aUrl += '&Armazenagem={nArmazenagem}' 

	WSDATA cProdutoID AS STRING    
	WSDATA nConsumidorFinal AS int 	
	WSDATA cEstadoVenda AS STRING  
	WSDATA nPrecoDeVenda AS Float   
	WSDATA nComissaoPerc AS Float   
	WSDATA nCustoOperacionalPerc  AS Float  
	WSDATA nOutrasDespesas AS Float  
	WSDATA nFreteTerrestrePorto AS Float  
	WSDATA nFreteMaritimo AS Float  
	WSDATA nArmazenagem AS Float  	

    WSMETHOD GET  ALL DESCRIPTION '' ;
	WSSYNTAX aUrl PRODUCES APPLICATION_JSON

END WSRESTFUL

WSMETHOD GET ALL WSRECEIVE 	cProdutoID, nConsumidorFinal, cEstadoVenda, nPrecoDeVenda, nComissaoPerc, nCustoOperacionalPerc, nOutrasDespesas, nFreteTerrestrePorto, nFreteMaritimo, nArmazenagem WSREST CALCULARPORPRECOVENDA
    Local lRet       := .T.
	Local nCount 	 := 1
	Local nRegistros := 0

	Local aQuery     := {}
    Local oJson      := JsonObject():New() 
    Local cJson      := ""   
    Local cAlias := getNextAlias()

	Local cProdutoID := Self:cProdutoID
	Local nConsumidorFinal := Self:nConsumidorFinal 	
	Local cEstadoVenda := Self:cEstadoVenda
	Local nPrecoDeVenda := Self:nPrecoDeVenda 
	Local nComissaoPerc := Self:nComissaoPerc 
	Local nCustoOperacionalPerc := Self:nCustoOperacionalPerc 
	Local nOutrasDespesas := Self:nOutrasDespesas 
	Local nFreteTerrestrePorto := Self:nFreteTerrestrePorto 
	Local nFreteMaritimo := Self:nFreteMaritimo 
	Local nArmazenagem := Self:nArmazenagem 

	BeginSql alias cAlias

			Select 

				Marca, Grupo, Produto_ID, Produto, Nota, Serie, Emissao, UFCompra, UFVenda, PrecoUnitario, PrecoUnitarioComIPI, 
				Incide_IPI, AliquotaIPI, ValorIPI, Incide_ICMS, AliquotaICMSDif, AliquotaICMS, ValorICMS, ValorICMSDif,
				Incide_PisCofins, AliquotaPIS, ValorPIS, AliquotaCOFINS, ValorCOFINS, CFOP, TES,
				TotalComImpostos, CustoTotalDaCompra, CreditoICMS, CreditoPis, CreditoConfins,					
				CustoUnitarioProdutoVendido, PrecoDeVenda, ComissaoPerc, CustoOperacionalPerc, OutrasDespesas, FreteMaritimo, Armazenagem, FreteTerrestrePorto, ConsumidorFinal, 
				ICMSVenda, PisVenda, ConfinsVenda, ReceitaMenosImpostos, CustoOperacional, Comissao,
				ReceitaLiquidaIRPJ_CSLL, ImpostoDeRenda, CSLL,
				ReceitaLiquidaIRPJ_CSLL - (ImpostoDeRenda + CSLL) as LucroLiquido,
				Round(((ReceitaLiquidaIRPJ_CSLL - (ImpostoDeRenda + CSLL))/PrecoDeVenda) * 100,3) as MargemLiquida
				
			from (

					Select 

						Marca, Grupo, Produto_ID, Produto, Nota, Serie, Emissao, UFCompra, UFVenda, PrecoUnitario, PrecoUnitarioComIPI, 
						Incide_IPI, AliquotaIPI, ValorIPI, Incide_ICMS, AliquotaICMSDif, AliquotaICMS, ValorICMS, ValorICMSDif,
						Incide_PisCofins, AliquotaPIS, ValorPIS, AliquotaCOFINS, ValorCOFINS, CFOP, TES,
						TotalComImpostos, CustoTotalDaCompra, CreditoICMS, CreditoPis, CreditoConfins,					
						CustoUnitarioProdutoVendido, PrecoDeVenda, ComissaoPerc, Comissao, CustoOperacionalPerc, 
						CustoOperacional, OutrasDespesas, FreteMaritimo, Armazenagem, FreteTerrestrePorto, ConsumidorFinal,
						ICMSVenda, PisVenda, ConfinsVenda, ReceitaMenosImpostos, 
						Round(ReceitaMenosImpostos - (CustoUnitarioProdutoVendido + CustoOperacional + Comissao),2) as ReceitaLiquidaIRPJ_CSLL,
						Round((ReceitaMenosImpostos - (CustoUnitarioProdutoVendido + CustoOperacional + Comissao)) * 0.25, 2) as ImpostoDeRenda,
						Round((ReceitaMenosImpostos - (CustoUnitarioProdutoVendido + CustoOperacional + Comissao)) * 0.09, 2) as CSLL

					from (

							Select 
							
								Marca, Grupo, Produto_ID, Produto, Nota, Serie, Emissao, UFCompra, UFVenda, PrecoUnitario, PrecoUnitarioComIPI, 
								Incide_IPI, AliquotaIPI, ValorIPI, Incide_ICMS, AliquotaICMSDif, AliquotaICMS, ValorICMS, ValorICMSDif,
								Incide_PisCofins, AliquotaPIS, ValorPIS, AliquotaCOFINS, ValorCOFINS, CFOP, TES,
								TotalComImpostos, CustoTotalDaCompra, CreditoICMS, CreditoPis, CreditoConfins,					
								CustoUnitarioProdutoVendido, 
								
								PrecoDeVenda, ComissaoPerc, CustoOperacionalPerc, OutrasDespesas, 
								FreteMaritimo, Armazenagem, FreteTerrestrePorto, ConsumidorFinal,

								ICMSVenda, PisVenda, ConfinsVenda,
								Round(PrecoDeVenda - (ICMSVenda + PisVenda + ConfinsVenda),2) as ReceitaMenosImpostos,
								Round(CustoUnitarioProdutoVendido * (CustoOperacionalPerc * 0.01),2) as CustoOperacional,
								Round(PrecoDeVenda * (ComissaoPerc * 0.01),2) as Comissao	

							from (

										Select 

											Marca, Grupo, Produto_ID, Produto, Nota, Serie, Emissao, UFCompra, UFVenda, PrecoUnitario, PrecoUnitarioComIPI, 
											Incide_IPI, AliquotaIPI, ValorIPI, Incide_ICMS, AliquotaICMSDif, AliquotaICMS, ValorICMS, ValorICMSDif,
											Incide_PisCofins, AliquotaPIS, ValorPIS, AliquotaCOFINS, ValorCOFINS, CFOP, TES,
											
											PrecoUnitarioComIPI + ValorICMSDif as TotalComImpostos,
											PrecoUnitarioComIPI + ValorICMSDif + FreteMaritimo + Armazenagem + FreteTerrestrePorto + OutrasDespesas as CustoTotalDaCompra,
											(ValorICMS +  ValorICMSDif) * -1 as CreditoICMS, ValorPIS * -1 as CreditoPis, ValorCOFINS * -1 as CreditoConfins,
											(PrecoUnitarioComIPI + ValorICMSDif + FreteMaritimo + Armazenagem + FreteTerrestrePorto + OutrasDespesas) - ((ValorICMS +  ValorICMSDif) + ValorPIS + ValorCOFINS) as CustoUnitarioProdutoVendido,
											PrecoDeVenda, ComissaoPerc, CustoOperacionalPerc, OutrasDespesas, FreteMaritimo, Armazenagem, FreteTerrestrePorto, ConsumidorFinal,
											Case when Incide_ICMS = 'SIM' then PrecoDeVenda * (Case when ConsumidorFinal = 1 then 0.18 else 0.04 end) else 0 end as ICMSVenda,
											Case when Incide_PisCofins = 'INCIDE PIS' OR Incide_PisCofins = 'INCIDE PIS/COFINS' then (PrecoDeVenda - (PrecoDeVenda * (Case when ConsumidorFinal = 1 then 0.18 else 0.04 end))) * (AliquotaPIS * 0.01) else 0 end as PisVenda,	
											Case when Incide_PisCofins = 'INCIDE COFINS' OR Incide_PisCofins = 'INCIDE PIS/COFINS' then (PrecoDeVenda - (PrecoDeVenda * (Case when ConsumidorFinal = 1 then 0.18 else 0.04 end))) * (AliquotaCOFINS * 0.01) else 0 end as ConfinsVenda
											
										from (

													Select 

														Rtrim(Marca_ID) + ' - ' + Rtrim(Marca) AS Marca,
														Rtrim(BM_GRUPO) + ' - ' + Rtrim(BM_DESC) AS Grupo,
														Rtrim(D1.D1_COD) AS Produto_ID, 
														Produto,	
														D1_DOC as Nota, 
														F1_SERIE as Serie,
														D1_EMISSAO as Emissao, 
														F1_EST as UFCompra,
														%EXP:cEstadoVenda% as UFVenda,

														Round((D1_VUNIT),2) as PrecoUnitario,
														Round((D1_VUNIT + D1_VALIPI/D1_QUANT),2) as PrecoUnitarioComIPI,	

														Case when F4_IPI = 'S' then 'SIM' else 'NAO' end AS Incide_IPI,	
														D1.D1_IPI as AliquotaIPI,
														Round(D1_VALIPI/D1_QUANT,2) as ValorIPI,
																				
														Case when F4_ICM = 'S' then 'SIM' else 'NAO' end AS Incide_ICMS, 	
														D1.D1_PICM as AliquotaICMS,
														Case when F4_ICM = 'S' then 18 - D1.D1_PICM  else 0 end as AliquotaICMSDif,	
									
														Round((D1_VUNIT) * (D1.D1_PICM)/100,2) as ValorICMS,
														Case when F4_ICM = 'S' then  Round((D1_VUNIT + D1_VALIPI/D1_QUANT) * (18 - D1.D1_PICM)/100,2) else 0 end as ValorICMSDif, 
																	
														D1_MARGEM as PercentualMVA, 
														Round(D1_ICMSRET/D1_QUANT,2) as ValorICMSST,
																	
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
														Rtrim(D1_TES) + ' - ' + TipoEntrada.F4_TEXTO AS TES,

														%EXP:nConsumidorFinal% as ConsumidorFinal, 															 				
														%EXP:nPrecoDeVenda% as PrecoDeVenda,   
														%EXP:nComissaoPerc% as ComissaoPerc,   
														%EXP:nCustoOperacionalPerc% as CustoOperacionalPerc,  
														%EXP:nOutrasDespesas% as OutrasDespesas,  
														%EXP:nFreteTerrestrePorto% as FreteTerrestrePorto,  
														%EXP:nFreteMaritimo% as FreteMaritimo,  
														%EXP:nArmazenagem% as Armazenagem															

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
																	BM_GRUPO, BM_DESC, D1_COD, Rtrim(B1_DESC) AS Produto, Max(D1.R_E_C_N_O_) as Recno
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
																AND Rtrim(D1_COD) = %EXP:cProdutoID%
																Group by BM_GRUPO, BM_DESC, D1_COD, B1_DESC

													) UltimaNota ON UltimaNota.Recno = D1.R_E_C_N_O_
													INNER JOIN %table:SF4% TipoEntrada (nolock) ON TipoEntrada.F4_FILIAL = %xfilial:SF4%
																							AND TipoEntrada.%notDel%
																							AND TipoEntrada.F4_CODIGO = D1_TES 
																							AND TipoEntrada.F4_ESTOQUE = 'S'
																							AND TipoEntrada.F4_DUPLIC = 'S'
																							AND TipoEntrada.F4_TIPO = 'E'
													Inner Join %table:SX5%  CFOP (nolock) ON X5_FILIAL = ''
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

											) TB

									) TB

							) TB

					) TB

					

    EndSql
    
	Count to nRegistros	
	(cAlias)->(dbGoTop())	
			
	WHILE (cAlias)->(!EOF())
    	aAdd(aQuery,JsonObject():New())

			aQuery[nCount]['Marca']     	       				:= EncodeUTF8(AllTrim((cAlias)->Marca))
			aQuery[nCount]['Grupo']     	       				:= EncodeUTF8(AllTrim((cAlias)->Grupo)) 
			aQuery[nCount]['Produto_ID']     	   				:= EncodeUTF8(AllTrim((cAlias)->Produto_ID)) 
			aQuery[nCount]['Produto']     	    				:= EncodeUTF8(AllTrim((cAlias)->Produto)) 
			aQuery[nCount]['Nota']     	    					:= EncodeUTF8(AllTrim((cAlias)->Nota))
			aQuery[nCount]['Serie']     	    				:= EncodeUTF8(AllTrim((cAlias)->Serie))
			aQuery[nCount]['Emissao']     	    				:= (cAlias)->Emissao
			aQuery[nCount]['UFCompra']     	    				:= EncodeUTF8(AllTrim((cAlias)->UFCompra))
			aQuery[nCount]['UFVenda']     	    				:= EncodeUTF8(AllTrim((cAlias)->UFVenda))
			aQuery[nCount]['PrecoUnitario']     				:= (cAlias)->PrecoUnitario
			aQuery[nCount]['PrecoUnitarioComIPI']  				:= (cAlias)->PrecoUnitarioComIPI
			aQuery[nCount]['Incide_IPI']   						:= (cAlias)->Incide_IPI
			aQuery[nCount]['AliquotaIPI']   					:= (cAlias)->AliquotaIPI
			aQuery[nCount]['ValorIPI']   						:= (cAlias)->ValorIPI
			aQuery[nCount]['Incide_ICMS']   					:= (cAlias)->Incide_ICMS
			aQuery[nCount]['AliquotaICMSDif']   				:= (cAlias)->AliquotaICMSDif
			aQuery[nCount]['AliquotaICMS']   					:= (cAlias)->AliquotaICMS
			aQuery[nCount]['ValorICMS']   						:= (cAlias)->ValorICMS
			aQuery[nCount]['ValorICMSDif']   					:= (cAlias)->ValorICMSDif
			aQuery[nCount]['Incide_PisCofins']   				:= EncodeUTF8(AllTrim((cAlias)->Incide_PisCofins))
			aQuery[nCount]['AliquotaPIS']   					:= (cAlias)->AliquotaPIS
			aQuery[nCount]['ValorPIS']   						:= (cAlias)->ValorPIS
			aQuery[nCount]['AliquotaCOFINS']   					:= (cAlias)->AliquotaCOFINS
			aQuery[nCount]['ValorCOFINS']   					:= (cAlias)->ValorCOFINS
			aQuery[nCount]['CFOP']   							:= EncodeUTF8(AllTrim((cAlias)->CFOP))
			aQuery[nCount]['TES']   							:= EncodeUTF8(AllTrim((cAlias)->TES))			
			aQuery[nCount]['TotalComImpostos']   				:= (cAlias)->TotalComImpostos
			aQuery[nCount]['CustoTotalDaCompra']   				:= (cAlias)->CustoTotalDaCompra
			aQuery[nCount]['CreditoICMS']   					:= (cAlias)->CreditoICMS
			aQuery[nCount]['CreditoPis']   						:= (cAlias)->CreditoPis
			aQuery[nCount]['CreditoConfins']   					:= (cAlias)->CreditoConfins
			aQuery[nCount]['CustoUnitarioProdutoVendido']   	:= (cAlias)->CustoUnitarioProdutoVendido			
			aQuery[nCount]['PrecoDeVenda']   					:= (cAlias)->PrecoDeVenda			
			aQuery[nCount]['ICMSVenda']   						:= (cAlias)->ICMSVenda
			aQuery[nCount]['PisVenda']   						:= (cAlias)->PisVenda
			aQuery[nCount]['ConfinsVenda']   					:= (cAlias)->ConfinsVenda
			aQuery[nCount]['ReceitaMenosImpostos']   			:= (cAlias)->ReceitaMenosImpostos
			aQuery[nCount]['CustoOperacional']   				:= (cAlias)->CustoOperacional
			aQuery[nCount]['Comissao']   						:= (cAlias)->Comissao
			aQuery[nCount]['ReceitaLiquidaIRPJ_CSLL']   		:= (cAlias)->ReceitaLiquidaIRPJ_CSLL
			aQuery[nCount]['ImpostoDeRenda']   					:= (cAlias)->ImpostoDeRenda
			aQuery[nCount]['CSLL']   							:= (cAlias)->CSLL
			aQuery[nCount]['LucroLiquido']   					:= (cAlias)->LucroLiquido
 			aQuery[nCount]['MargemLiquida']  					:= (cAlias)->MargemLiquida
	
			aQuery[nCount]['ComissaoPerc']  					:= (cAlias)->ComissaoPerc
			aQuery[nCount]['CustoOperacionalPerc']  			:= (cAlias)->CustoOperacionalPerc
			aQuery[nCount]['OutrasDespesas']  					:= (cAlias)->OutrasDespesas
			aQuery[nCount]['FreteMaritimo']  					:= (cAlias)->FreteMaritimo
			aQuery[nCount]['Armazenagem']  						:= (cAlias)->Armazenagem
			aQuery[nCount]['FreteTerrestrePorto']  				:= (cAlias)->FreteTerrestrePorto
			aQuery[nCount]['ConsumidorFinal']  					:= (cAlias)->ConsumidorFinal

		nCount++
			 (cAlias)->(dbSkip())
	 enddo 
	 
	(cAlias)->(dbCloseArea())

	if nRegistros > 0

		oJson["Calculo"] := aQuery 
		cJson := FwJSonSerialize(oJson)
		::SetResponse(cJson) 			

	Else

		SetRestFault(400,EncodeUTF8('Calculo com problemas!')) 
		lRet := .F.
		Return(lRet)

	Endif

    FreeObj(oJson)

Return lRet


