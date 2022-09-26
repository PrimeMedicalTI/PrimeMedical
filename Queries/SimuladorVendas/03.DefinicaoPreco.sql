
Declare @cProdutoID Varchar(50)
Set @cProdutoID =  '64082'

Declare @nConsumidorFinal Int
Set @nConsumidorFinal = 1

Declare @cEstadoVenda Varchar(2)
Set @cEstadoVenda = 'BA'

Declare @nPrecoDeVenda Float
Set @nPrecoDeVenda = 12000

Declare @nComissaoPerc Float
Set @nComissaoPerc = 2

Declare @nCustoOperacionalPerc Float
Set @nCustoOperacionalPerc = 20

Declare @nOutrasDespesas Float
Set @nOutrasDespesas = 0

Declare @nFreteTerrestrePorto Float
Set @nFreteTerrestrePorto = 0

Declare @nFreteMaritimo Float
Set @nFreteMaritimo = 0

Declare @nArmazenagem Float
Set @nArmazenagem = 0


	--Select

	--	Marca, Grupo, Produto_ID, Produto, Origem, Nota, Serie, Emissao, UFCompra, UFVenda, PrecoUnitario, PrecoUnitarioComIPI,											
	--	Incide_IPI, AliquotaIPI, ValorIPI, Incide_ICMS, AliquotaICMS, ValorICMS, PercentualMVA, ValorICMSST, 
	--	AliquotaICMSDif, ValorICMSDif, Incide_PisCofins, AliquotaPIS, ValorPIS, AliquotaCOFINS, ValorCOFINS, CFOP, TES,
	--	TotalComImpostos, CustoTotalDaCompra, CreditoICMS, CreditoPis, CreditoConfins,					
	--	CustoUnitarioProdutoVendido, PrecoDeVenda, ComissaoPerc, CustoOperacionalPerc, OutrasDespesas, FreteMaritimo, Armazenagem, FreteTerrestrePorto, ConsumidorFinal, 
	--	AliquotaICMSVendaDentroDaBahia, ICMSVenda, PisVenda, ConfinsVenda, ReceitaMenosImpostos, CustoOperacional, Comissao,
	--	ReceitaLiquidaIRPJ_CSLL, ImpostoDeRenda, CSLL,
	--	ReceitaLiquidaIRPJ_CSLL - (ImpostoDeRenda + CSLL) as LucroLiquido,
	--	Round(((ReceitaLiquidaIRPJ_CSLL - (ImpostoDeRenda + CSLL))/PrecoDeVenda) * 100,3) as MargemLiquida

	--from (

	--		Select 

	--			Marca, Grupo, Produto_ID, Produto, Origem, Nota, Serie, Emissao, UFCompra, UFVenda, PrecoUnitario, PrecoUnitarioComIPI,											
	--			Incide_IPI, AliquotaIPI, ValorIPI, Incide_ICMS, AliquotaICMS, ValorICMS, PercentualMVA, ValorICMSST, 
	--			AliquotaICMSDif, ValorICMSDif, Incide_PisCofins, AliquotaPIS, ValorPIS, AliquotaCOFINS, ValorCOFINS, CFOP, TES,
	--			TotalComImpostos, CustoTotalDaCompra, CreditoICMS, CreditoPis, CreditoConfins,					
	--			CustoUnitarioProdutoVendido, PrecoDeVenda, ComissaoPerc, CustoOperacionalPerc, OutrasDespesas, FreteMaritimo, Armazenagem, FreteTerrestrePorto, ConsumidorFinal, 
	--			AliquotaICMSVendaDentroDaBahia, ICMSVenda, PisVenda, ConfinsVenda, ReceitaMenosImpostos, CustoOperacional, Comissao,
	--			Round(ReceitaMenosImpostos - (CustoUnitarioProdutoVendido + CustoOperacional + Comissao),2) as ReceitaLiquidaIRPJ_CSLL,
	--			Round((ReceitaMenosImpostos - (CustoUnitarioProdutoVendido + CustoOperacional + Comissao)) * 0.25, 2) as ImpostoDeRenda,
	--			Round((ReceitaMenosImpostos - (CustoUnitarioProdutoVendido + CustoOperacional + Comissao)) * 0.09, 2) as CSLL
				
	--		from (

	--				Select 

	--					Marca, Grupo, Produto_ID, Produto, Origem, Nota, Serie, Emissao, UFCompra, UFVenda, PrecoUnitario, PrecoUnitarioComIPI,											
	--					Incide_IPI, AliquotaIPI, ValorIPI, Incide_ICMS, AliquotaICMS, ValorICMS, PercentualMVA, ValorICMSST, 
	--					AliquotaICMSDif, ValorICMSDif, Incide_PisCofins, AliquotaPIS, ValorPIS, AliquotaCOFINS, ValorCOFINS, CFOP, TES,
	--					TotalComImpostos, CustoTotalDaCompra, CreditoICMS, CreditoPis, CreditoConfins,					
	--					CustoUnitarioProdutoVendido, PrecoDeVenda, ComissaoPerc, Comissao, CustoOperacionalPerc, 						
	--					Round(CustoUnitarioProdutoVendido * (CustoOperacionalPerc * 0.01),2) as CustoOperacional,						
	--					OutrasDespesas, FreteMaritimo, Armazenagem, FreteTerrestrePorto, ConsumidorFinal,
	--					AliquotaICMSVendaDentroDaBahia, ICMSVenda, PisVenda, ConfinsVenda, ReceitaMenosImpostos

	--				from (

	--						Select 

	--							Marca, Grupo, Produto_ID, Produto, Origem, Nota, Serie, Emissao, UFCompra, UFVenda, PrecoUnitario,
	--							Round(PrecoUnitario + ValorIPI + ValorICMSST,2) as PrecoUnitarioComIPI,											
	--							Incide_IPI, AliquotaIPI, ValorIPI, Incide_ICMS, AliquotaICMS, ValorICMS, PercentualMVA, ValorICMSST, 
	--							AliquotaICMSDif, ValorICMSDif, Incide_PisCofins, AliquotaPIS, ValorPIS, AliquotaCOFINS, ValorCOFINS, CFOP, TES,
	--							PrecoUnitarioComIPI + ValorICMSDif as TotalComImpostos, 
	--							PrecoUnitarioComIPI + ValorICMSDif + FreteMaritimo + Armazenagem + FreteTerrestrePorto + OutrasDespesas as CustoTotalDaCompra, 
	--							AliquotaICMSVendaDentroDaBahia, ICMSVenda, PisVenda, ConfinsVenda, CreditoICMS, CreditoPis, CreditoConfins,					
	--							(PrecoUnitarioComIPI + ValorICMSDif + FreteMaritimo + Armazenagem + FreteTerrestrePorto + OutrasDespesas) - ((ValorICMS +  ValorICMSDif) + ValorPIS + ValorCOFINS) as CustoUnitarioProdutoVendido, 								
	--							PrecoDeVenda, ComissaoPerc, CustoOperacionalPerc, OutrasDespesas, FreteMaritimo, Armazenagem, FreteTerrestrePorto, ConsumidorFinal,								
	--							Round(PrecoDeVenda - (ICMSVenda + PisVenda + ConfinsVenda),2) as ReceitaMenosImpostos,								
	--							Round(PrecoDeVenda * (ComissaoPerc * 0.01),2) as Comissao	

	--						from (
	--									Select 

	--										Marca, Grupo, Produto_ID, Produto, Origem, Nota, Serie, Emissao, UFCompra, UFVenda, PrecoUnitario,
	--										Round(PrecoUnitario + ValorIPI + ValorICMSST,2) as PrecoUnitarioComIPI,											
	--										Incide_IPI, AliquotaIPI, ValorIPI, Incide_ICMS, AliquotaICMS, ValorICMS, PercentualMVA, ValorICMSST, 
	--										Case when PercentualMVA = 0 then AliquotaICMSDif else 0 end as AliquotaICMSDif, 
	--										Case when PercentualMVA = 0 then ValorICMSDif else 0 end as ValorICMSDif,
	--										Incide_PisCofins, AliquotaPIS, ValorPIS, AliquotaCOFINS, ValorCOFINS, CFOP, TES,
	--										Case when PercentualMVA = 0 then (ValorICMS +  ValorICMSDif) * -1 else 0 end as CreditoICMS,
	--										ValorPIS * -1 as CreditoPis, ValorCOFINS * -1 as CreditoConfins,											
	--										PrecoDeVenda, ComissaoPerc, CustoOperacionalPerc, OutrasDespesas, FreteMaritimo, Armazenagem, FreteTerrestrePorto, ConsumidorFinal,
											
	--										AliquotaICMSVendaDentroDaBahia,
	--										Case when Incide_ICMS = 'SIM' then PrecoDeVenda * (Case when ConsumidorFinal = 1 then AliquotaICMSVendaDentroDaBahia else 0.04 end) else 0 end as ICMSVenda,

	--										Case when Incide_PisCofins = 'INCIDE PIS' OR Incide_PisCofins = 'INCIDE PIS/COFINS' then (PrecoDeVenda - (PrecoDeVenda * (Case when ConsumidorFinal = 1 then 0.18 else 0.04 end))) * (AliquotaPIS * 0.01) else 0 end as PisVenda,	
	--										Case when Incide_PisCofins = 'INCIDE COFINS' OR Incide_PisCofins = 'INCIDE PIS/COFINS' then (PrecoDeVenda - (PrecoDeVenda * (Case when ConsumidorFinal = 1 then 0.18 else 0.04 end))) * (AliquotaCOFINS * 0.01) else 0 end as ConfinsVenda
																						
	--									from (

												Select 

													Rtrim(Marca_ID) + ' - ' + Rtrim(Marca) AS Marca, Grupo, Rtrim(D1.D1_COD) AS Produto_ID, Produto,  Origem, 	 
													D1_DOC as Nota, F1_SERIE as Serie, D1_EMISSAO as Emissao, F1_EST as UFCompra, @cEstadoVenda as UFVenda,
													Round((D1_VUNIT),2) as PrecoUnitario,																

													Case when F4_IPI = 'S' then 'SIM' else 'NAO' end AS Incide_IPI,	
													D1.D1_IPI as AliquotaIPI,
													
													Round(D1_VALIPI/D1_QUANT,2) as ValorIPI,															
																			
													Case when F4_ICM = 'S' then 'SIM' else 'NAO' end AS Incide_ICMS,
													Round((D1_VUNIT) * (D1.D1_PICM)/100,2) as ValorICMS,
													D1.D1_PICM as AliquotaICMS,													

													Case when D1_MARGEM > 0 then 
														0
													else
														(
															Select Top 1 Cast(X6_CONTENG as Float)/100 
															from SX6010 (nolock) 
															Where X6_FIL = '010101' 
															AND D_E_L_E_T_ <> '*' 
															AND X6_VAR = 'MV_ICMPAD'
													     ) 
													end as AliquotaICMSVendaDentroDaBahia,													

													D1_MARGEM as PercentualMVA, 
													Round(D1_ICMSRET/D1_QUANT,2) as ValorICMSST,

													Case when F4_ICM = 'S' then 18 - D1.D1_PICM  else 0 end as AliquotaICMSDif,
													Case when F4_ICM = 'S' then  Round((D1_VUNIT + D1_VALIPI/D1_QUANT) * (18 - D1.D1_PICM)/100,2) else 0 end as ValorICMSDif, 

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

													@nConsumidorFinal as ConsumidorFinal, 															 				
													@nPrecoDeVenda as PrecoDeVenda,   
													@nComissaoPerc as ComissaoPerc,   
													@nCustoOperacionalPerc as CustoOperacionalPerc,  
													@nOutrasDespesas as OutrasDespesas,  
													@nFreteTerrestrePorto as FreteTerrestrePorto,  
													@nFreteMaritimo as FreteMaritimo,  
													@nArmazenagem as Armazenagem																				

												from SD1010 D1 (nolock)
												INNER JOIN SF1010 Nota (nolock) ON F1_FILIAL  = '010101'
																			AND Nota.D_E_L_E_T_ <> '*'
																			AND F1_DOC = D1_DOC
																			AND F1_SERIE = D1_SERIE
																			AND F1_TIPO = D1_TIPO
																			AND F1_FORNECE = D1_FORNECE 
																			AND F1_LOJA = D1_LOJA
												Inner Join (

		
																SELECT 				
																	Top 1130 Max(D1.R_E_C_N_O_) as Recno, Rtrim(D1_COD) as ID, Rtrim(B1_DESC) AS Produto, B1_TIPO,				
																	Produto.B1_FSCANVI as ANVISA, BM_GRUPO + ' - ' + BM_DESC as Grupo, BM_GRUPO,
																	Rtrim(B1_ORIGEM) + ' - ' + Upper(Rtrim(Origem.X5_DESCRI)) as Origem, 
																	CASE WHEN B1_MSBLQL = 1 THEN 'SIM' ELSE 'NAO' END AS Bloqueado			

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
																AND Rtrim(D1_COD) = @cProdutoID
																Group by D1_COD, B1_DESC, BM_GRUPO, BM_DESC, B1_FSCANVI, B1_MSBLQL, B1_ORIGEM, Origem.X5_DESCRI, B1_TIPO 

												) UltimaNota ON UltimaNota.Recno = D1.R_E_C_N_O_
												INNER JOIN SF4010 TipoEntrada (nolock) ON TipoEntrada.F4_FILIAL = ''
																						AND TipoEntrada.D_E_L_E_T_ <> '*'
																						AND TipoEntrada.F4_CODIGO = D1_TES 
																						AND TipoEntrada.F4_ESTOQUE = 'S'
																						AND TipoEntrada.F4_DUPLIC = 'S'
																						AND TipoEntrada.F4_TIPO = 'E'
												Inner Join SX5010 CFOP (nolock) ON X5_FILIAL = ''
																			AND CFOP.D_E_L_E_T_ <> '*'
																			AND X5_TABELA = '13'
																			AND X5_CHAVE = TipoEntrada.F4_CF	

												Left Join (
															Select 
																Substring(BM_GRUPO,1,2) as Marca_ID, BM_DESC as Marca 
															from SBM010 Marca (nolock)
															Where BM_FILIAL = ''
															AND Marca.D_E_L_E_T_ <> '*'
															AND Substring(BM_GRUPO,1,2) = BM_GRUPO
												) Marca ON Marca.Marca_ID = Substring(BM_GRUPO,1,2)

	--										) TB

	--								) TB

	--						) TB

	--				) TB
		
	--) TB
					