SELECT 
	'COMPRAS' as TipoCompra,
	F1_FILIAL AS Filial, 
	F1_DOC AS Nota,
	D1_ITEM as Item,
	F1_SERIE AS Serie, 
	CONVERT(Varchar(10),CONVERT(DATE,F1_DTDIGIT,112),103) AS Emissao,
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

	Rtrim(F1_FORNECE)+ ' - ' + F1_LOJA AS Fornecedor_ID, A2_NOME AS Fornecedor, A2_NREDUZ as Fantasia, 
	A2_EST AS UF, Ltrim(Rtrim(A2_MUN)) AS Cidade, 
 	Case when A2_CGC = '' then '00000000000000' else A2_CGC end as CNPJ,
	Rtrim(Marca_ID) + ' - ' + Rtrim(Marca) AS Marca,
	Rtrim(BM_GRUPO) + ' - ' + Rtrim(BM_DESC) AS Grupo,
	Rtrim(D1_COD) AS Produto_ID, 
	Rtrim(B1_DESC) AS Produto,
    D1_LOTECTL as Lote,
    D1_LOCAL + ' - ' + Armazem.NNR_DESCRI as Armazem,
	D1_QUANT AS QtdCompra, 
	CAST(D1_VUNIT AS DECIMAL(15,2)) AS VUnitario, 
	D1_TOTAL AS Total, D1_CUSTO as Custo,
	 
	Case when F4_ICM = 'S' then 'Sim' else 'Não' end AS Incide_ICMS, 	
	DevItem.D1_PICM as AliquotaICMS,
	Case when F4_IPI = 'S' then 'Sim' else 'Não' end AS Incide_IPI,	
	DevItem.D1_IPI as AliquotaIPI,
	D1_VALIPI as ValorIPI, D1_VALICM as ValorICMS, 

	CASE 
		WHEN F4_PISCOF = '1' THEN 'INCIDE PIS' 
		WHEN F4_PISCOF = '2' THEN 'INCIDE COFINS' 
		WHEN F4_PISCOF = '3' THEN 'INCIDE PIS/COFINS' 
		WHEN F4_PISCOF = '4' THEN 'NÃO INCIDE' 
	END AS Incide_PisCofins,

	(Case when (F4_PISCOF = '4') then 0 else D1_ALQPIS end) as AliquotaPIS, 
	Round(((D1_VUNIT * D1_QUANT) * ((Case when (F4_PISCOF = '4') then 0 else D1_ALQPIS end) * 0.01)),2) as ValorPIS,  
	(Case when (F4_PISCOF = '4') then 0 else D1_ALQCOF end) as AliquotaCOFINS, 
	Round(((D1_VUNIT * D1_QUANT) * ((Case when (F4_PISCOF = '4') then 0 else D1_ALQCOF end) * 0.01)),2) as ValorCOFINS, 
	
	RTRIM(TipoEntrada.F4_CF) + ' - ' + X5_DESCRI AS CFOP, 
	Rtrim(D1_TES) + ' - ' + TipoEntrada.F4_TEXTO AS TES,
	Case when TipoEntrada.F4_DUPLIC = 'S' then 'Sim' else 'Não' end AS GeraFinanceiro, 
	Case when TipoEntrada.F4_ESTOQUE = 'S' then 'Sim' else 'Não' end AS GeraEstoque		
	
from SD1010 DevItem (nolock)
Inner Join NNR010 Armazem (Nolock) ON Armazem.NNR_FILIAL = '010101'
 								  AND Armazem.D_E_L_E_T_ <> '*'
 								  AND Armazem.NNR_CODIGO = D1_LOCAL  
INNER JOIN SA2010 Fornecedor (nolock) ON A2_FILIAL = ''
								  AND Fornecedor.D_E_L_E_T_ <> '*' 
								  AND A2_COD = D1_FORNECE 
							      AND A2_LOJA = D1_LOJA
INNER JOIN SB1010 Produto (nolock) ON B1_FILIAL = ''
							  AND Produto.D_E_L_E_T_ <> '*'
							  AND B1_COD = D1_COD 
INNER JOIN SBM010 Grupo (nolock) ON BM_FILIAL = ''
							    AND Grupo.D_E_L_E_T_ <> '*' 
							    AND BM_GRUPO  = B1_GRUPO
Left Join (

			Select 
				Substring(BM_GRUPO,1,2) as Marca_ID, BM_DESC as Marca 
			from SBM010 Marca (nolock)
			Where BM_FILIAL = ''
			AND Marca.D_E_L_E_T_ <> '*'

			AND Substring(BM_GRUPO,1,2) = BM_GRUPO
) Marca ON Marca.Marca_ID = Substring(Grupo.BM_GRUPO,1,2)							    
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
										   AND TipoEntrada.F4_DUPLIC = 'N'
										   AND TipoEntrada.F4_TIPO = 'E'
Inner Join SX5010 CFOP (nolock) ON X5_FILIAL = ''
							   AND CFOP.D_E_L_E_T_ <> '*'
							   AND X5_TABELA = '13'
							   AND X5_CHAVE = TipoEntrada.F4_CF	

									   
Where 1=1
AND D1_FILIAL = '010101'	
AND D1_TIPO = 'D'
AND DevItem.D_E_L_E_T_ <> '*'
AND CONVERT(DATE,F1_DTDIGIT,112) between :DATAINICIAL AND :DATAFIM
Order by F1_DTDIGIT desc
