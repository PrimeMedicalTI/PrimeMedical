Select 
		Item.CK_NUM AS Orcamento, 
		
		Rtrim(CJ_CLIENTE)+ ' - ' + CJ_LOJA AS Cliente_ID,  
		Cliente.A1_NOME AS Cliente, Cliente.A1_NREDUZ as Fantasia, Cliente.A1_CGC as CNPJ,
		Cliente.A1_EST AS UF, Ltrim(Rtrim(Cliente.A1_MUN)) AS Cidade, 
		Ltrim(Rtrim(Cliente.A1_FSREGI)) + ' - ' + Rtrim(Cliente.A1_FSDREGI) AS Regiao,
	
		CONVERT(Datetime, CJ_EMISSAO, 112) as Emissao, Day(CJ_EMISSAO) as Dia,		
		Case 
			When Month(CJ_EMISSAO) = 1 then '01 - JANEIRO' 
			When Month(CJ_EMISSAO) = 2 then '02 - FEVEREIRO' 
			When Month(CJ_EMISSAO) = 3 then '03 - MARÇO' 
			When Month(CJ_EMISSAO) = 4 then '04 - ABRIL' 
			When Month(CJ_EMISSAO) = 5 then '05 - MAIO' 
			When Month(CJ_EMISSAO) = 6 then '06 - JUNHO' 
			When Month(CJ_EMISSAO) = 7 then '07 - JULHO' 
			When Month(CJ_EMISSAO) = 8 then '08 - AGOSTO' 
			When Month(CJ_EMISSAO) = 9 then '09 - SETEMBRO' 
			When Month(CJ_EMISSAO) = 10 then '10 - OUTUBRO' 
			When Month(CJ_EMISSAO) = 11 then '11 - NOVEMBRO' 
			When Month(CJ_EMISSAO) = 12 then '12 - DEZEMBRO' 
		End as Mes,	
		Year(CJ_EMISSAO) as Ano,

		CONVERT(Datetime, Item.CK_ENTREG, 112) AS DataEntrega, Day(CK_ENTREG) as DiaEntrega,

		Case 
			When Month(CK_ENTREG) = 1 then '01 - JANEIRO' 
			When Month(CK_ENTREG) = 2 then '02 - FEVEREIRO' 
			When Month(CK_ENTREG) = 3 then '03 - MARÇO' 
			When Month(CK_ENTREG) = 4 then '04 - ABRIL' 
			When Month(CK_ENTREG) = 5 then '05 - MAIO' 
			When Month(CK_ENTREG) = 6 then '06 - JUNHO' 
			When Month(CK_ENTREG) = 7 then '07 - JULHO' 
			When Month(CK_ENTREG) = 8 then '08 - AGOSTO' 
			When Month(CK_ENTREG) = 9 then '09 - SETEMBRO' 
			When Month(CK_ENTREG) = 10 then '10 - OUTUBRO' 
			When Month(CK_ENTREG) = 11 then '11 - NOVEMBRO' 
			When Month(CK_ENTREG) = 12 then '12 - DEZEMBRO' 
		End as MesEntrega,	
		Year(CK_ENTREG) as AnoEntrega,

		Rtrim(Marca_ID) + ' - ' + Rtrim(Marca) AS Marca,
		Rtrim(B1_GRUPO) AS Grupo_ID, Rtrim(BM_DESC) AS Grupo, Rtrim(CK_PRODUTO) AS Produto_ID,
		Rtrim(Produto.B1_DESC) AS Produto, Item.CK_QTDVEN AS Quantidade, 0 AS Atendida, Item.CK_QTDVEN AS Saldo,

		Item.CK_PRCVEN AS ValorUnitario,

		CASE	
			WHEN (Item.CK_QTDVEN) > 0 THEN Item.CK_PRCVEN * (Item.CK_QTDVEN) 
			ELSE (Item.CK_PRCVEN * Item.CK_QTDVEN) 
		END AS Valor, 
		Rtrim(CK_TES) + ' - ' + F4_TEXTO AS TES

	
from dbo.SCJ010 (nolock) Orcamento
INNER JOIN SA1010 Cliente (nolock) ON A1_FILIAL = ''
								  AND Cliente.D_E_L_E_T_ <> '*' 
								  AND A1_COD = Orcamento.CJ_CLIENTE 
							      AND A1_LOJA = Orcamento.CJ_LOJA
						  
Inner Join dbo.SCK010 (nolock) Item ON Item.D_E_L_E_T_ <> '*' 
												AND Item.CK_FILIAL = '010101' 
												AND Item.CK_NUM = Orcamento.CJ_NUM
INNER JOIN SF4010 TipoEntradaSaida (nolock) ON F4_FILIAL = ''
										   AND TipoEntradaSaida.D_E_L_E_T_ <> '*'
										   AND F4_CODIGO = CK_TES 
Inner JOIN SB1010 Produto (nolock) ON B1_FILIAL = ''
							  AND Produto.D_E_L_E_T_ <> '*'
							  AND B1_COD = CK_PRODUTO 
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

Where Orcamento.D_E_L_E_T_ <> '*'
AND Orcamento.CJ_FILIAL = '010101'			
Order by Orcamento.R_E_C_N_O_ desc