
			SELECT 				
				Top 1130 Max(D1.R_E_C_N_O_) as Recno, Rtrim(D1_COD) as ID, Rtrim(B1_DESC) AS Produto, 				
				Produto.B1_FSCANVI as ANVISA, BM_GRUPO + ' - ' + BM_DESC as Grupo,
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
			Inner Join SX5010 CFOP (nolock) ON X5_FILIAL = ''
												AND CFOP.D_E_L_E_T_ <> '*'
												AND X5_TABELA = '13'
												AND X5_CHAVE = TipoEntrada.F4_CF	
			WHERE D1_FILIAL = '010101'
			AND D1.D_E_L_E_T_ <> '*'
			AND D1_TIPO = 'N'
			AND X5_DESCRI like '%COMPRA%'
			AND (Rtrim(D1_COD) + Rtrim(B1_DESC) + Rtrim(B1_FSCANVI)) like '%%'
			Group by D1_COD, B1_DESC, BM_GRUPO, BM_DESC, B1_FSCANVI, B1_MSBLQL 
			Order by D1_COD, B1_DESC
