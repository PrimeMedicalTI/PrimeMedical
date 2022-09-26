
SELECT 
	'COMPRAS' as TipoVenda,
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

	Rtrim(F1_FORNECE)+ ' - ' + F1_LOJA AS Fornecedor_ID, A2_NOME AS Cliente, A2_NREDUZ as Fantasia, 
	A2_EST AS UF, Ltrim(Rtrim(A2_MUN)) AS Cidade, 
 Case when A2_CGC = '' then '00000000000000' else A2_CGC end as CNPJ,
	Rtrim(BM_GRUPO) + ' - ' + Rtrim(BM_DESC) AS Grupo,
	Rtrim(D1_COD) AS Produto_ID, 
	Rtrim(B1_DESC) AS Produto,
    D1_LOTECTL as Lote,
	D1_QUANT AS QtdCompra, 
	CAST(D1_VUNIT AS DECIMAL(15,2)) AS VUnitario, 
	D1_TOTAL AS Total, 
	RTRIM(TipoEntrada.F4_CF) + ' - ' + X5_DESCRI AS CFOP, 
	Rtrim(D1_TES) + ' - ' + TipoEntrada.F4_TEXTO AS TES,
	TipoEntrada.F4_DUPLIC AS Financeiro, 
	TipoEntrada.F4_ESTOQUE AS Estoque,	
	D1_PEDIDO as Origem
	
from SD1010 DevItem (nolock)
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
Inner Join SX5010 CFOP (nolock) ON X5_FILIAL = ''
							   AND CFOP.D_E_L_E_T_ <> '*'
							   AND X5_TABELA = '13'
							   AND X5_CHAVE = TipoEntrada.F4_CF	

									   
Where 1=1
AND D1_FILIAL = '010101'	
AND D1_TIPO = 'N'
AND DevItem.D_E_L_E_T_ <> '*'
Order by Emissao desc