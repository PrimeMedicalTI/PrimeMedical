SELECT 

	'FATURAMENTO' as TipoVenda,
	F2_FILIAL AS Filial, 
	F2_DOC AS Nota,
	D2_ITEM as Item,
	F2_SERIE AS Serie, 
	CONVERT(Varchar(10),CONVERT(DATE,F2_EMISSAO,112),103) AS Emissao, 
	Case when F2_DTPROCE <> '' then Convert(Varchar(10),Convert(Datetime,F2_DTPROCE,112),103) else '' end as DtProcedimento, 
	Day(F2_EMISSAO) as Dia,

	Year(F2_EMISSAO) as Ano,

	Case 
		When Month(F2_EMISSAO) = 1 then '01 - JANEIRO' 
		When Month(F2_EMISSAO) = 2 then '02 - FEVEREIRO' 
		When Month(F2_EMISSAO) = 3 then '03 - MARÇO' 
		When Month(F2_EMISSAO) = 4 then '04 - ABRIL' 
		When Month(F2_EMISSAO) = 5 then '05 - MAIO' 
		When Month(F2_EMISSAO) = 6 then '06 - JUNHO' 
		When Month(F2_EMISSAO) = 7 then '07 - JULHO' 
		When Month(F2_EMISSAO) = 8 then '08 - AGOSTO' 
		When Month(F2_EMISSAO) = 9 then '09 - SETEMBRO' 
		When Month(F2_EMISSAO) = 10 then '10 - OUTUBRO' 
		When Month(F2_EMISSAO) = 11 then '11 - NOVEMBRO' 
		When Month(F2_EMISSAO) = 12 then '12 - DEZEMBRO' 
	End as Mes,	

	Case 
			When Month(F2_EMISSAO) = 1 then 
				Case when Day(F2_EMISSAO) <= 15 then '01 - JANEIRO' else  '02 - FEVEREIRO' end 
			When Month(F2_EMISSAO) = 2 then 
				Case when Day(F2_EMISSAO) <= 15 then '02 - FEVEREIRO' else '03 - MARÇO' end 
			When Month(F2_EMISSAO) = 3 then 
				Case when Day(F2_EMISSAO) <= 15 then '03 - MARÇO' else '04 - ABRIL' end 
			When Month(F2_EMISSAO) = 4 then 
				Case when Day(F2_EMISSAO) <= 15 then  '04 - ABRIL' else '05 - MAIO' end
			When Month(F2_EMISSAO) = 5 then 
				Case when Day(F2_EMISSAO) <= 15 then  '05 - MAIO' else '06 - JUNHO' end 
			When Month(F2_EMISSAO) = 6 then 
				Case when Day(F2_EMISSAO) <= 15 then  '06 - JUNHO' else '07 - JULHO' end 
			When Month(F2_EMISSAO) = 7 then 
				Case when Day(F2_EMISSAO) <= 15 then  '07 - JULHO' else '08 - AGOSTO' end
			When Month(F2_EMISSAO) = 8 then 
				Case when Day(F2_EMISSAO) <= 15 then  '08 - AGOSTO' else '09 - SETEMBRO' end
			When Month(F2_EMISSAO) = 9 then 
				Case when Day(F2_EMISSAO) <= 15 then  '09 - SETEMBRO' else '10 - OUTUBRO' end  
			When Month(F2_EMISSAO) = 10 then 
				Case when Day(F2_EMISSAO) <= 15 then  '10 - OUTUBRO' else '11 - NOVEMBRO'  end 
			When Month(F2_EMISSAO) = 11 then 
				Case when Day(F2_EMISSAO) <= 15 then  '11 - NOVEMBRO'  else '12 - DEZEMBRO' end 
			When Month(F2_EMISSAO) = 12 then 
				Case when Day(F2_EMISSAO) <= 15 then  '12 - DEZEMBRO'  else '01 - JANEIRO' end 	
	end as MesPremiacao,

	Case 
		When Month(F2_EMISSAO) = 12 then 
			Case when Day(F2_EMISSAO) > 15 then Year(F2_EMISSAO) - 1 else Year(F2_EMISSAO) end 
		else Year(F2_EMISSAO)
	end as AnoPremiacao, 
	
	Case when F2_FSCCONV = '' then '' else F2_FSCCONV + ' - ' + F2_CONVENI end as Convenio,	
	Rtrim(F2_CLIENTE)+ ' - ' + F2_LOJA AS Cliente_ID,  
	Cliente.A1_NOME AS Cliente, Cliente.A1_NREDUZ as Fantasia, Cliente.A1_CGC as CNPJ,
	Cliente.A1_EST AS UF, Ltrim(Rtrim(Cliente.A1_MUN)) AS Cidade, 
	Ltrim(Rtrim(Cliente.A1_FSREGI)) AS Regiao_ID, 
	Rtrim(Cliente.A1_FSDREGI) AS Regiao,

	Rtrim(F2_CLIENT)+ ' - ' + F2_LOJENT AS ClienteEntrega_ID,  
	ClienteEntrega.A1_NOME AS ClienteEntrega, ClienteEntrega.A1_NREDUZ as ClienteEntregaFantasia, ClienteEntrega.A1_CGC as ClienteEntregaCNPJ,
	ClienteEntrega.A1_EST AS ClienteEntregaUF, Ltrim(Rtrim(ClienteEntrega.A1_MUN)) AS ClienteEntregaCidade, 
	Ltrim(Rtrim(ClienteEntrega.A1_FSREGI)) AS ClienteEntregaRegiao_ID, 
	Rtrim(ClienteEntrega.A1_FSDREGI) AS ClienteEntregaRegiao,                      

	'SV01 - SERVICOS' AS Marca,
	Rtrim(D2_GRUPO) AS Grupo_ID, Rtrim(BM_DESC) AS Grupo, Rtrim(D2_COD) AS Produto_ID,
	Rtrim(Produto.B1_DESC) AS Produto, D2_LOTECTL as Lote, D2_QUANT AS QtdVenda, 
	CAST(D2_PRCVEN AS DECIMAL(15,2)) AS VUnitario, D2_VALIPI + D2_TOTAL AS TotalNota, 
	
	Case when D2_QUANT > 0 then Round(Cast(D2_CUSTO1 as Float)/Cast(D2_QUANT as Float),2) else 0 end as CustoMedioUnitario,
	D2_CUSTO1 as CustoTotal,
	 
	Case when F4_ICM = 'S' then 'Sim' else 'Não' end AS Incide_ICMS, 	
	D2_PICM as AliquotaICMS,
	Case when F4_IPI = 'S' then 'Sim' else 'Não' end AS Incide_IPI,	
	D2_IPI as AliquotaIPI,
	D2_VALIPI as ValorIPI, D2_VALICM as ValorICMS, 

	CASE 
		WHEN F4_PISCOF = '1' THEN 'INCIDE PIS' 
		WHEN F4_PISCOF = '2' THEN 'INCIDE COFINS' 
		WHEN F4_PISCOF = '3' THEN 'INCIDE PIS/COFINS' 
		WHEN F4_PISCOF = '4' THEN 'NÃO INCIDE' 
	END AS Incide_PisCofins,
		
	(Case when (F4_PISCOF = '4') then 0 else D2_ALQPIS end) as AliquotaPIS, 
	Round(((D2_PRCVEN * D2_QUANT) * ((Case when (F4_PISCOF = '4') then 0 else D2_ALQPIS end) * 0.01)),2) as ValorPIS,  
	(Case when (F4_PISCOF = '4') then 0 else D2_ALQCOF end) as AliquotaCOFINS, 
	Round(((D2_PRCVEN * D2_QUANT) * ((Case when (F4_PISCOF = '4') then 0 else D2_ALQCOF end) * 0.01)),2) as ValorCOFINS,  
	
	Rtrim(D2_CF) + ' - ' + Rtrim(CFOP.X5_DESCRI) AS CFOP, 	
	Rtrim(D2_TES) + ' - ' + F4_TEXTO AS TES, 	
	Case when F4_DUPLIC = 'S' then 'Sim' else 'Não' end AS GeraFinanceiro, 
	Case when F4_ESTOQUE = 'S' then 'Sim' else 'Não' end AS GeraEstoque,	 	
	D2_PEDIDO as Origem, Rtrim(F2_COND) + ' - ' + E4_DESCRI  as CondicaoPagamento, 
	Rtrim(D2_LOCAL) + ' - ' + Rtrim(Armazem.NNR_DESCRI) as Armazem, D2_CONTA as Conta
	
FROM SF2010 Nota  (nolock)
INNER JOIN SA1010 Cliente (nolock) ON A1_FILIAL = ''
								  AND Cliente.D_E_L_E_T_ <> '*' 
								  AND A1_COD = F2_CLIENTE 
							      AND A1_LOJA = F2_LOJA							  
Inner JOIN SD2010 Item (nolock) ON D2_FILIAL = '010101'
							   AND Item.D_E_L_E_T_ <> '*' 
							   AND D2_DOC = F2_DOC
							   AND D2_SERIE = F2_SERIE
							   AND D2_TIPO = F2_TIPO
							   AND D2_CLIENTE = F2_CLIENTE
							   AND D2_LOJA = F2_LOJA
Inner Join NNR010 Armazem (Nolock) ON Armazem.NNR_FILIAL = '010101'
 								  AND Armazem.D_E_L_E_T_ <> '*'
 								  AND Armazem.NNR_CODIGO = D2_LOCAL 
Inner Join SX5010 CFOP ON CFOP.X5_FILIAL = ''
									 AND CFOP.D_E_L_E_T_ <> '*' 
									 AND CFOP.X5_TABELA = '13'
									 AND CFOP.X5_CHAVE = D2_CF
Inner JOIN SB1010 Produto (nolock) ON B1_FILIAL = ''
							  AND Produto.D_E_L_E_T_ <> '*'
							  AND B1_COD = D2_COD 
Inner JOIN SBM010 Grupo (nolock) ON BM_FILIAL = ''
							    AND Grupo.D_E_L_E_T_ <> '*' 
							    AND BM_GRUPO  = D2_GRUPO 	
								
INNER JOIN SF4010 TipoEntradaSaida (nolock) ON F4_FILIAL = ''
										   AND TipoEntradaSaida.D_E_L_E_T_ <> '*'
										   AND F4_CODIGO = D2_TES 
										   AND F4_ESTOQUE = 'N'
										   AND F4_DUPLIC = 'S'
										   AND F4_TIPO = 'S'
INNER JOIN SA1010 ClienteEntrega ON ClienteEntrega.A1_FILIAL = ''
								 AND ClienteEntrega.D_E_L_E_T_ <> '*' 
								 AND ClienteEntrega.A1_COD = F2_CLIENT 
								 AND ClienteEntrega.A1_LOJA = F2_LOJENT
INNER JOIN SE4010 CondPag ON ClienteEntrega.A1_FILIAL = ''
								 AND ClienteEntrega.D_E_L_E_T_ <> '*' 
								 AND CondPag.E4_CODIGO = F2_COND								 
								 
Where 1=1
AND F2_FILIAL = '010101'
AND Nota.D_E_L_E_T_ <> '*'
AND F2_TIPO = 'N'
AND CONVERT(DATE,F2_EMISSAO,112) between :DATAINICIAL AND :DATAFIM

UNION ALL

SELECT 

	'FATURAMENTO' as TipoVenda,
	F2_FILIAL AS Filial, 
	F2_DOC AS Nota,
	D2_ITEM as Item,
	F2_SERIE AS Serie, 
	CONVERT(Varchar(10),CONVERT(DATE,F2_EMISSAO,112),103) AS Emissao, 
	Case when F2_DTPROCE <> '' then Convert(Varchar(10),Convert(Datetime,F2_DTPROCE,112),103) else '' end as DtProcedimento, 
	Day(F2_EMISSAO) as Dia,

	Year(F2_EMISSAO) as Ano,

	Case 
		When Month(F2_EMISSAO) = 1 then '01 - JANEIRO' 
		When Month(F2_EMISSAO) = 2 then '02 - FEVEREIRO' 
		When Month(F2_EMISSAO) = 3 then '03 - MARÇO' 
		When Month(F2_EMISSAO) = 4 then '04 - ABRIL' 
		When Month(F2_EMISSAO) = 5 then '05 - MAIO' 
		When Month(F2_EMISSAO) = 6 then '06 - JUNHO' 
		When Month(F2_EMISSAO) = 7 then '07 - JULHO' 
		When Month(F2_EMISSAO) = 8 then '08 - AGOSTO' 
		When Month(F2_EMISSAO) = 9 then '09 - SETEMBRO' 
		When Month(F2_EMISSAO) = 10 then '10 - OUTUBRO' 
		When Month(F2_EMISSAO) = 11 then '11 - NOVEMBRO' 
		When Month(F2_EMISSAO) = 12 then '12 - DEZEMBRO' 
	End as Mes,	

	Case 
			When Month(F2_EMISSAO) = 1 then 
				Case when Day(F2_EMISSAO) <= 15 then '01 - JANEIRO' else  '02 - FEVEREIRO' end 
			When Month(F2_EMISSAO) = 2 then 
				Case when Day(F2_EMISSAO) <= 15 then '02 - FEVEREIRO' else '03 - MARÇO' end 
			When Month(F2_EMISSAO) = 3 then 
				Case when Day(F2_EMISSAO) <= 15 then '03 - MARÇO' else '04 - ABRIL' end 
			When Month(F2_EMISSAO) = 4 then 
				Case when Day(F2_EMISSAO) <= 15 then  '04 - ABRIL' else '05 - MAIO' end
			When Month(F2_EMISSAO) = 5 then 
				Case when Day(F2_EMISSAO) <= 15 then  '05 - MAIO' else '06 - JUNHO' end 
			When Month(F2_EMISSAO) = 6 then 
				Case when Day(F2_EMISSAO) <= 15 then  '06 - JUNHO' else '07 - JULHO' end 
			When Month(F2_EMISSAO) = 7 then 
				Case when Day(F2_EMISSAO) <= 15 then  '07 - JULHO' else '08 - AGOSTO' end
			When Month(F2_EMISSAO) = 8 then 
				Case when Day(F2_EMISSAO) <= 15 then  '08 - AGOSTO' else '09 - SETEMBRO' end
			When Month(F2_EMISSAO) = 9 then 
				Case when Day(F2_EMISSAO) <= 15 then  '09 - SETEMBRO' else '10 - OUTUBRO' end  
			When Month(F2_EMISSAO) = 10 then 
				Case when Day(F2_EMISSAO) <= 15 then  '10 - OUTUBRO' else '11 - NOVEMBRO'  end 
			When Month(F2_EMISSAO) = 11 then 
				Case when Day(F2_EMISSAO) <= 15 then  '11 - NOVEMBRO'  else '12 - DEZEMBRO' end 
			When Month(F2_EMISSAO) = 12 then 
				Case when Day(F2_EMISSAO) <= 15 then  '12 - DEZEMBRO'  else '01 - JANEIRO' end 	
	end as MesPremiacao,

	Case 
		When Month(F2_EMISSAO) = 12 then 
			Case when Day(F2_EMISSAO) > 15 then Year(F2_EMISSAO) - 1 else Year(F2_EMISSAO) end 
		else Year(F2_EMISSAO)
	end as AnoPremiacao, 
	
	Case when F2_FSCCONV = '' then '' else F2_FSCCONV + ' - ' + F2_CONVENI end as Convenio,	
	Rtrim(F2_CLIENTE)+ ' - ' + F2_LOJA AS Cliente_ID,  
	Cliente.A1_NOME AS Cliente, Cliente.A1_NREDUZ as Fantasia, Cliente.A1_CGC as CNPJ,
	Cliente.A1_EST AS UF, Ltrim(Rtrim(Cliente.A1_MUN)) AS Cidade, 
	Ltrim(Rtrim(Cliente.A1_FSREGI)) AS Regiao_ID, 
	Rtrim(Cliente.A1_FSDREGI) AS Regiao,

	Rtrim(F2_CLIENT)+ ' - ' + F2_LOJENT AS ClienteEntrega_ID,  
	ClienteEntrega.A1_NOME AS ClienteEntrega, ClienteEntrega.A1_NREDUZ as ClienteEntregaFantasia, ClienteEntrega.A1_CGC as ClienteEntregaCNPJ,
	ClienteEntrega.A1_EST AS ClienteEntregaUF, Ltrim(Rtrim(ClienteEntrega.A1_MUN)) AS ClienteEntregaCidade, 
	Ltrim(Rtrim(ClienteEntrega.A1_FSREGI)) AS ClienteEntregaRegiao_ID, 
	Rtrim(ClienteEntrega.A1_FSDREGI) AS ClienteEntregaRegiao,

	Rtrim(Marca_ID) + ' - ' + Rtrim(Marca) AS Marca,
	Rtrim(D2_GRUPO) AS Grupo_ID, Rtrim(BM_DESC) AS Grupo, Rtrim(D2_COD) AS Produto_ID,
	Rtrim(Produto.B1_DESC) AS Produto, D2_LOTECTL as Lote, D2_QUANT AS QtdVenda, 
	CAST(D2_PRCVEN AS DECIMAL(15,2)) AS VUnitario, D2_VALIPI + D2_TOTAL AS TotalNota, 
	
	Case when D2_QUANT > 0 then Round(Cast(D2_CUSTO1 as Float)/Cast(D2_QUANT as Float),2) else 0 end as CustoMedioUnitario,
	D2_CUSTO1 as CustoTotal,
	 
	Case when F4_ICM = 'S' then 'Sim' else 'Não' end AS Incide_ICMS, 	
	D2_PICM as AliquotaICMS,
	Case when F4_IPI = 'S' then 'Sim' else 'Não' end AS Incide_IPI,	
	D2_IPI as AliquotaIPI,
	D2_VALIPI as ValorIPI, D2_VALICM as ValorICMS, 

	CASE 
		WHEN F4_PISCOF = '1' THEN 'INCIDE PIS' 
		WHEN F4_PISCOF = '2' THEN 'INCIDE COFINS' 
		WHEN F4_PISCOF = '3' THEN 'INCIDE PIS/COFINS' 
		WHEN F4_PISCOF = '4' THEN 'NÃO INCIDE' 
	END AS Incide_PisCofins,
		
	(Case when (F4_PISCOF = '4') then 0 else D2_ALQPIS end) as AliquotaPIS, 
	Round(((D2_PRCVEN * D2_QUANT) * ((Case when (F4_PISCOF = '4') then 0 else D2_ALQPIS end) * 0.01)),2) as ValorPIS,  
	(Case when (F4_PISCOF = '4') then 0 else D2_ALQCOF end) as AliquotaCOFINS, 
	Round(((D2_PRCVEN * D2_QUANT) * ((Case when (F4_PISCOF = '4') then 0 else D2_ALQCOF end) * 0.01)),2) as ValorCOFINS,  
	
	Rtrim(D2_CF) + ' - ' + Rtrim(CFOP.X5_DESCRI) AS CFOP, 	
	Rtrim(D2_TES) + ' - ' + F4_TEXTO AS TES, 	
	Case when F4_DUPLIC = 'S' then 'Sim' else 'Não' end AS GeraFinanceiro, 
	Case when F4_ESTOQUE = 'S' then 'Sim' else 'Não' end AS GeraEstoque,	 	
	D2_PEDIDO as Origem, Rtrim(F2_COND) + ' - ' + E4_DESCRI  as CondicaoPagamento, 
	Rtrim(D2_LOCAL) + ' - ' + Rtrim(Armazem.NNR_DESCRI) as Armazem, D2_CONTA as Conta
	
FROM SF2010 Nota  (nolock)
INNER JOIN SA1010 Cliente (nolock) ON A1_FILIAL = ''
								  AND Cliente.D_E_L_E_T_ <> '*' 
								  AND A1_COD = F2_CLIENTE 
							      AND A1_LOJA = F2_LOJA							  
INNER JOIN SD2010 Item (nolock) ON D2_FILIAL = '010101'
							   AND Item.D_E_L_E_T_ <> '*' 
							   AND D2_DOC = F2_DOC
							   AND D2_SERIE = F2_SERIE
							   AND D2_TIPO = F2_TIPO
							   AND D2_CLIENTE = F2_CLIENTE
							   AND D2_LOJA = F2_LOJA
Inner Join NNR010 Armazem (Nolock) ON Armazem.NNR_FILIAL = '010101'
 								  AND Armazem.D_E_L_E_T_ <> '*'
 								  AND Armazem.NNR_CODIGO = D2_LOCAL 
Inner Join SX5010 CFOP ON CFOP.X5_FILIAL = ''
									 AND CFOP.D_E_L_E_T_ <> '*' 
									 AND CFOP.X5_TABELA = '13'
									 AND CFOP.X5_CHAVE = D2_CF
INNER JOIN SB1010 Produto (nolock) ON B1_FILIAL = ''
							  AND Produto.D_E_L_E_T_ <> '*'
							  AND B1_COD = D2_COD 
INNER JOIN SBM010 Grupo (nolock) ON BM_FILIAL = ''
							    AND Grupo.D_E_L_E_T_ <> '*' 
							    AND BM_GRUPO  = D2_GRUPO 	
Left Join (
			Select 
				Substring(BM_GRUPO,1,2) as Marca_ID, BM_DESC as Marca 
			from SBM010 Marca (nolock)
			Where BM_FILIAL = ''
			AND Marca.D_E_L_E_T_ <> '*'
			AND Substring(BM_GRUPO,1,2) = BM_GRUPO
) Marca ON Marca.Marca_ID = Substring(Grupo.BM_GRUPO,1,2)									
INNER JOIN SF4010 TipoEntradaSaida (nolock) ON F4_FILIAL = ''
										   AND TipoEntradaSaida.D_E_L_E_T_ <> '*'
										   AND F4_CODIGO = D2_TES 
										   AND F4_ESTOQUE = 'S'
										   AND F4_DUPLIC = 'S'
										   AND F4_TIPO = 'S'
INNER JOIN SA1010 ClienteEntrega ON ClienteEntrega.A1_FILIAL = ''
								 AND ClienteEntrega.D_E_L_E_T_ <> '*' 
								 AND ClienteEntrega.A1_COD = F2_CLIENT 
								 AND ClienteEntrega.A1_LOJA = F2_LOJENT
INNER JOIN SE4010 CondPag ON ClienteEntrega.A1_FILIAL = ''
								 AND ClienteEntrega.D_E_L_E_T_ <> '*' 
								 AND CondPag.E4_CODIGO = F2_COND								 
								 
Where 1=1
AND F2_FILIAL = '010101'
AND Nota.D_E_L_E_T_ <> '*'
AND F2_TIPO = 'N'
AND CONVERT(DATE,F2_EMISSAO,112) between :DATAINICIAL AND :DATAFIM

UNION ALL

SELECT 
	
	'DEVOLUCAO' as TipoVenda,
	F1_FILIAL AS Filial, 
	D1_NFORI AS Nota,
	D1_ITEMORI as Item,
	D1_SERIORI AS Serie, 
	CONVERT(Varchar(10),CONVERT(DATE,F1_DTDIGIT,112),103) AS Emissao,
	Case when F2_DTPROCE <> '' then Convert(Varchar(10),Convert(Datetime,F2_DTPROCE,112),103) else '' end as DtProcedimento, 
	Day(F1_DTDIGIT) as Dia,
	Year(F1_DTDIGIT) as Ano,
	
	Case 
		When Month(F1_DTDIGIT) = 1 then '01 - JANEIRO' 
		When Month(F1_DTDIGIT) = 2 then '02 - FEVEREIRO' 
		When Month(F1_DTDIGIT) = 3 then '03 - MARÇO' 
		When Month(F1_DTDIGIT) = 4 then '04 - ABRIL' 
		When Month(F1_DTDIGIT) = 5 then '05 - MAIO' 
		When Month(F1_DTDIGIT) = 6 then '06 - JUNHO' 
		When Month(F1_DTDIGIT) = 7 then '07 - JULHO' 
		When Month(F1_DTDIGIT) = 8 then '08 - AGOSTO' 
		When Month(F1_DTDIGIT) = 9 then '09 - SETEMBRO' 
		When Month(F1_DTDIGIT) = 10 then '10 - OUTUBRO' 
		When Month(F1_DTDIGIT) = 11 then '11 - NOVEMBRO' 
		When Month(F1_DTDIGIT) = 12 then '12 - DEZEMBRO' 
	End as Mes,	

	Case 
			When Month(F1_DTDIGIT) = 1 then 
				Case when Day(F1_DTDIGIT) <= 15 then '01 - JANEIRO' else  '02 - FEVEREIRO' end 
			When Month(F1_DTDIGIT) = 2 then 
				Case when Day(F1_DTDIGIT) <= 15 then '02 - FEVEREIRO' else '03 - MARÇO' end 
			When Month(F1_DTDIGIT) = 3 then 
				Case when Day(F1_DTDIGIT) <= 15 then '03 - MARÇO' else '04 - ABRIL' end 
			When Month(F1_DTDIGIT) = 4 then 
				Case when Day(F1_DTDIGIT) <= 15 then  '04 - ABRIL' else '05 - MAIO' end
			When Month(F1_DTDIGIT) = 5 then 
				Case when Day(F1_DTDIGIT) <= 15 then  '05 - MAIO' else '06 - JUNHO' end 
			When Month(F1_DTDIGIT) = 6 then 
				Case when Day(F1_DTDIGIT) <= 15 then  '06 - JUNHO' else '07 - JULHO' end 
			When Month(F1_DTDIGIT) = 7 then 
				Case when Day(F1_DTDIGIT) <= 15 then  '07 - JULHO' else '08 - AGOSTO' end
			When Month(F1_DTDIGIT) = 8 then 
				Case when Day(F1_DTDIGIT) <= 15 then  '08 - AGOSTO' else '09 - SETEMBRO' end
			When Month(F1_DTDIGIT) = 9 then 
				Case when Day(F1_DTDIGIT) <= 15 then  '09 - SETEMBRO' else '10 - OUTUBRO' end  
			When Month(F1_DTDIGIT) = 10 then 
				Case when Day(F1_DTDIGIT) <= 15 then  '10 - OUTUBRO' else '11 - NOVEMBRO'  end 
			When Month(F1_DTDIGIT) = 11 then 
				Case when Day(F1_DTDIGIT) <= 15 then  '11 - NOVEMBRO'  else '12 - DEZEMBRO' end 
			When Month(F1_DTDIGIT) = 12 then 
				Case when Day(F1_DTDIGIT) <= 15 then  '12 - DEZEMBRO'  else '01 - JANEIRO' end 	
	end as MesPremiacao,

	Case 
		When Month(F1_DTDIGIT) = 12 then 
			Case when Day(F1_DTDIGIT) > 15 then Year(F1_DTDIGIT) - 1 else Year(F1_DTDIGIT) end 
		else Year(F1_DTDIGIT)
	end as AnoPremiacao,
	
    Case when F2_FSCCONV = '' then '' else F2_FSCCONV + ' - ' + F2_CONVENI end as Convenio,
	Rtrim(F2_CLIENTE)+ ' - ' + F2_LOJA AS Cliente_ID,  
	Cliente.A1_NOME AS Cliente, Cliente.A1_NREDUZ as Fantasia, Cliente.A1_CGC as CNPJ,
	Cliente.A1_EST AS UF, Ltrim(Rtrim(Cliente.A1_MUN)) AS Cidade, 
	Ltrim(Rtrim(Cliente.A1_FSREGI)) AS Regiao_ID, 
	Rtrim(Cliente.A1_FSDREGI) AS Regiao,

	Rtrim(F2_CLIENT)+ ' - ' + F2_LOJENT AS ClienteEntrega_ID,  
	ClienteEntrega.A1_NOME AS ClienteEntrega, ClienteEntrega.A1_NREDUZ as ClienteEntregaFantasia, ClienteEntrega.A1_CGC as ClienteEntregaCNPJ,
	ClienteEntrega.A1_EST AS ClienteEntregaUF, Ltrim(Rtrim(ClienteEntrega.A1_MUN)) AS ClienteEntregaCidade, 
	Ltrim(Rtrim(ClienteEntrega.A1_FSREGI)) AS ClienteEntregaRegiao_ID, 
	Rtrim(ClienteEntrega.A1_FSDREGI) AS ClienteEntregaRegiao,

	Rtrim(Marca_ID) + ' - ' + Rtrim(Marca) AS Marca,
	Rtrim(D1_GRUPO) AS Grupo_ID, Rtrim(BM_DESC) AS Grupo, Rtrim(D1_COD) AS Produto_ID, 
	Rtrim(B1_DESC) AS Produto, D1_LOTECTL as Lote, -1 * D1_QUANT AS QtdVenda, 
	CAST(D1_VUNIT AS DECIMAL(15,2)) AS VUnitario, -1 * (D1_TOTAL + D1_VALIPI) AS TotalNota, 

	Case when D2_QUANT > 0 then Round(Cast(D2_CUSTO1 as Float)/Cast(D2_QUANT as Float),2) else 0 end as CustoMedioUnitario,
	D1_CUSTO as CustoTotal,
	 
	Case when TipoEntrada.F4_ICM = 'S' then 'Sim' else 'Não' end AS Incide_ICMS, 	
	DevItem.D1_PICM as AliquotaICMS,
	Case when TipoEntrada.F4_IPI = 'S' then 'Sim' else 'Não' end AS Incide_IPI,	
	DevItem.D1_IPI as AliquotaIPI,
	D1_VALIPI as ValorIPI, D1_VALICM as ValorICMS, 

	CASE 
		WHEN TipoEntrada.F4_PISCOF = '1' THEN 'INCIDE PIS' 
		WHEN TipoEntrada.F4_PISCOF = '2' THEN 'INCIDE COFINS' 
		WHEN TipoEntrada.F4_PISCOF = '3' THEN 'INCIDE PIS/COFINS' 
		WHEN TipoEntrada.F4_PISCOF = '4' THEN 'NÃO INCIDE' 
	END AS Incide_PisCofins,

	(Case when (TipoEntrada.F4_PISCOF = '4') then 0 else D1_ALQPIS end) as AliquotaPIS, 
	Round(((D1_VUNIT * D1_QUANT) * ((Case when (TipoEntrada.F4_PISCOF = '4') then 0 else D1_ALQPIS end) * 0.01)),2) as ValorPIS,  
	(Case when (TipoEntrada.F4_PISCOF = '4') then 0 else D1_ALQCOF end) as AliquotaCOFINS, 
	Round(((D1_VUNIT * D1_QUANT) * ((Case when (TipoEntrada.F4_PISCOF = '4') then 0 else D1_ALQCOF end) * 0.01)),2) as ValorCOFINS, 
	
	RTRIM(TipoEntrada.F4_CF) + ' - ' + X5_DESCRI AS CFOP, 
	Rtrim(D1_TES) + ' - ' + TipoEntrada.F4_TEXTO AS TES,
	Case when TipoEntrada.F4_DUPLIC = 'S' then 'Sim' else 'Não' end AS GeraFinanceiro, 
	Case when TipoEntrada.F4_ESTOQUE = 'S' then 'Sim' else 'Não' end AS GeraEstoque,
	F1_DOC as Origem, Rtrim(F2_COND) + ' - ' + E4_DESCRI  as CondicaoPagamento, 
	Rtrim(D1_LOCAL) + ' - ' + Rtrim(Armazem.NNR_DESCRI) as Armazem, D2_CONTA as Conta
	
from SD1010 DevItem (nolock)
Inner Join NNR010 Armazem (Nolock) ON Armazem.NNR_FILIAL = '010101'
 								  AND Armazem.D_E_L_E_T_ <> '*'
 								  AND Armazem.NNR_CODIGO = D1_LOCAL 
INNER JOIN SF1010 Nota (nolock) ON F1_FILIAL = '010101'
							   AND Nota.D_E_L_E_T_ <> '*' 
							   AND F1_DOC = D1_DOC
							   AND F1_SERIE = D1_SERIE
							   AND F1_TIPO = D1_TIPO
							   AND F1_FORNECE = D1_FORNECE 
							   AND F1_LOJA = D1_LOJA								  
INNER JOIN SF4010 TipoEntrada (nolock) ON TipoEntrada.F4_FILIAL = ''
										   AND TipoEntrada.D_E_L_E_T_ <> '*'
										   AND TipoEntrada.F4_CODIGO = D1_TES 
										   AND TipoEntrada.F4_ESTOQUE = 'S'
										   AND TipoEntrada.F4_DUPLIC = 'S'
										   AND TipoEntrada.F4_TIPO = 'E'
Inner Join SX5010 CFOP ON CFOP.X5_FILIAL = ''
									 AND CFOP.D_E_L_E_T_ <> '*' 
									 AND CFOP.X5_TABELA = '13'
									 AND CFOP.X5_CHAVE = D1_CF
INNER JOIN SB1010 Produto (nolock) ON B1_FILIAL = ''
							  AND Produto.D_E_L_E_T_ <> '*'
							  AND B1_COD = D1_COD 
INNER JOIN SBM010 Grupo (nolock) ON BM_FILIAL = ''
							    AND Grupo.D_E_L_E_T_ <> '*' 
							    AND BM_GRUPO  = D1_GRUPO 
INNER JOIN SD2010 Item (nolock) ON D2_FILIAL = '010101'
							   AND Item.D_E_L_E_T_ <> '*' 
							   AND D2_DOC = D1_NFORI
							   AND D2_SERIE = D1_SERIORI
							   AND D2_ITEM = D1_ITEMORI	
Left Join (
			Select 
				Substring(BM_GRUPO,1,2) as Marca_ID, BM_DESC as Marca 
			from SBM010 Marca (nolock)
			Where BM_FILIAL = ''
			AND Marca.D_E_L_E_T_ <> '*'
			AND Substring(BM_GRUPO,1,2) = BM_GRUPO
) Marca ON Marca.Marca_ID = Substring(Grupo.BM_GRUPO,1,2)	
INNER JOIN SF2010 NotaSaida (nolock) ON D2_FILIAL = '010101'
							   AND Item.D_E_L_E_T_ <> '*' 
							   AND D2_DOC = F2_DOC
							   AND D2_SERIE = F2_SERIE
							   AND D2_TIPO = F2_TIPO
							   AND D2_CLIENTE = F2_CLIENTE
							   AND D2_LOJA = F2_LOJA
INNER JOIN SA1010 Cliente (nolock) ON Cliente.A1_FILIAL = ''
								  AND Cliente.D_E_L_E_T_ <> '*' 
								  AND Cliente.A1_COD = F2_CLIENTE 
							      AND Cliente.A1_LOJA = F2_LOJA	
INNER JOIN SA1010 ClienteEntrega (nolock) ON ClienteEntrega.A1_FILIAL = ''
								  AND Cliente.D_E_L_E_T_ <> '*' 
								  AND ClienteEntrega.A1_COD = F2_CLIENT 
							      AND ClienteEntrega.A1_LOJA = F2_LOJENT	
INNER JOIN SF4010 TipoSaida (nolock) ON TipoSaida.F4_FILIAL = ''
									 AND TipoSaida.D_E_L_E_T_ <> '*'
									 AND TipoSaida.F4_CODIGO = D2_TES 
									 AND TipoSaida.F4_ESTOQUE = 'S'
									 AND TipoSaida.F4_DUPLIC = 'S'
									 AND TipoSaida.F4_TIPO = 'S'								  
INNER JOIN SE4010 CondPag ON ClienteEntrega.A1_FILIAL = ''
								 AND ClienteEntrega.D_E_L_E_T_ <> '*' 
								 AND CondPag.E4_CODIGO = F2_COND									   
Where 1=1
AND D1_FILIAL = '010101'	
AND DevItem.D_E_L_E_T_ <> '*'
AND CONVERT(DATE,F1_DTDIGIT,112) between :DATAINICIAL AND :DATAFIM

ORDER BY EMISSAO DESC