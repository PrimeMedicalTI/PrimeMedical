SELECT     
	
					
			Pedido.R_E_C_N_O_ AS Recno, RTRIM(Pedido.C7_NUM) AS Pedido_ID, RTRIM(Pedido.C7_ITEM) AS Sequencia,					
			CONVERT(Varchar(10),CONVERT(DATE,C7_EMISSAO,112),103) AS Emissao,

			Year(C7_EMISSAO) as Ano,

			Case 
				When Month(C7_EMISSAO) = 1 then '01 - JANEIRO' 
				When Month(C7_EMISSAO) = 2 then '02 - FEVEREIRO' 
				When Month(C7_EMISSAO) = 3 then '03 - MARÇO' 
				When Month(C7_EMISSAO) = 4 then '04 - ABRIL' 
				When Month(C7_EMISSAO) = 5 then '05 - MAIO' 
				When Month(C7_EMISSAO) = 6 then '06 - JUNHO' 
				When Month(C7_EMISSAO) = 7 then '07 - JULHO' 
				When Month(C7_EMISSAO) = 8 then '08 - AGOSTO' 
				When Month(C7_EMISSAO) = 9 then '09 - SETEMBRO' 
				When Month(C7_EMISSAO) = 10 then '10 - OUTUBRO' 
				When Month(C7_EMISSAO) = 11 then '11 - NOVEMBRO' 
				When Month(C7_EMISSAO) = 12 then '12 - DEZEMBRO' 
			End as Mes,	

			CONVERT(Varchar(10),CONVERT(DATE,C7_DATPRF,112),103) AS 'Data Entrega',

			Year(C7_DATPRF) as 'Ano Entrega',

			Case 
				When Month(C7_DATPRF) = 1 then '01 - JANEIRO' 
				When Month(C7_DATPRF) = 2 then '02 - FEVEREIRO' 
				When Month(C7_DATPRF) = 3 then '03 - MARÇO' 
				When Month(C7_DATPRF) = 4 then '04 - ABRIL' 
				When Month(C7_DATPRF) = 5 then '05 - MAIO' 
				When Month(C7_DATPRF) = 6 then '06 - JUNHO' 
				When Month(C7_DATPRF) = 7 then '07 - JULHO' 
				When Month(C7_DATPRF) = 8 then '08 - AGOSTO' 
				When Month(C7_DATPRF) = 9 then '09 - SETEMBRO' 
				When Month(C7_DATPRF) = 10 then '10 - OUTUBRO' 
				When Month(C7_DATPRF) = 11 then '11 - NOVEMBRO' 
				When Month(C7_DATPRF) = 12 then '12 - DEZEMBRO' 
			End as 'Mes Entrega',	

			CASE 
				WHEN (C7_CONAPRO = 'L') AND (C7_QUJE = 0) AND (C7_RESIDUO = '') THEN 'LIBERADO' 
				WHEN (C7_CONAPRO = 'L') AND (C7_QUJE < C7_QUANT) THEN 'PARCIAL' 
				WHEN (C7_CONAPRO = 'L') AND (C7_QUJE >= C7_QUANT) THEN 'ATENDIDO' 
				WHEN (C7_CONAPRO = 'B') THEN 'BLOQUEADO' 
				WHEN (C7_RESIDUO = 'S') THEN 'ELIM. RESIDUO' 
			END AS Status, 
					 
			RTRIM(Pedido.C7_FORNECE) + ' - ' + Pedido.C7_LOJA AS Fornecedor_ID, Fornecedor.A2_NOME AS Fornecedor, Fornecedor.A2_NREDUZ AS NomeFantasia, 
			Rtrim(C7_LOCAL) + ' - ' + Armazem.NNR_DESCRI as Armazem,
			Fornecedor.A2_MUN as Cidade, Fornecedor.A2_EST as UF, 
			Rtrim(Marca_ID) + ' - ' + Rtrim(Marca) AS Marca,
			Rtrim(BM_GRUPO) + ' - ' + Grupo.BM_DESC as Grupo, 
			RTRIM(Pedido.C7_PRODUTO) AS Produto_ID, B1_DESC as Produto,  Pedido.C7_UM AS UnidadeMedida, 
			Pedido.C7_QUANT AS Quantidade, Pedido.C7_QUJE AS Atendida, Pedido.C7_QUANT - Pedido.C7_QUJE as Saldo,
			Pedido.C7_PRECO AS ValorUnitario, Pedido.C7_VALIPI AS IPI, Pedido.C7_TOTAL + Pedido.C7_VALIPI AS ValorTotal, 
			Rtrim(Pedido.C7_COND)  + ' - ' + CndPagamento.E4_DESCRI AS CndPagamento, 

			USR_CODIGO as Usuario

	FROM dbo.SC7010 Pedido WITH (nolock) 
	Inner Join SYS_USR Usuario (nolock) ON USR_ID = C7_USER
	Inner Join dbo.SB1010 AS Produto (nolock) ON Produto.B1_COD = Pedido.C7_PRODUTO 
												AND Produto.D_E_L_E_T_ <> '*' 
												AND B1_FILIAL = ''
	Inner Join dbo.SBM010 as Grupo (nolock) ON Grupo.BM_GRUPO = B1_GRUPO 
											AND Grupo.D_E_L_E_T_ <> '*' 
											AND BM_FILIAL = ''
	Left Join (
					Select 
						Substring(BM_GRUPO,1,2) as Marca_ID, BM_DESC as Marca 
					from SBM010 Marca (nolock)
					Where BM_FILIAL = ''
					AND Marca.D_E_L_E_T_ <> '*'
					AND Substring(BM_GRUPO,1,2) = BM_GRUPO
	) Marca ON Marca.Marca_ID = Substring(Grupo.BM_GRUPO,1,2)
	INNER JOIN dbo.SA2010 AS Fornecedor WITH (nolock) ON Fornecedor.D_E_L_E_T_ <> '*' 
														AND A2_FILIAL = '' 
														AND Fornecedor.A2_COD = Pedido.C7_FORNECE 
														AND Fornecedor.A2_LOJA = Pedido.C7_LOJA			
	INNER JOIN dbo.SE4010 CndPagamento (nolock) ON CndPagamento.D_E_L_E_T_ <> '*' 
												AND E4_FILIAL = '' 
												AND CndPagamento.E4_CODIGO = Pedido.C7_COND
	Inner Join NNR010 Armazem (Nolock) ON Armazem.NNR_FILIAL = '010101'
 							AND Armazem.D_E_L_E_T_ <> '*'
 							AND Armazem.NNR_CODIGO = C7_LOCAL 
	
	WHERE 1=1
	AND C7_FILIAL = '010101' 
	AND (Pedido.D_E_L_E_T_ <> '*') 
	AND CONVERT(DATE,C7_EMISSAO,112) between :DATAINICIAL AND :DATAFIM
	ORDER BY Pedido.R_E_C_N_O_ desc