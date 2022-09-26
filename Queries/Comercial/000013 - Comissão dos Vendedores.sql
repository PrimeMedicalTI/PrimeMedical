SELECT

	Vendedor,
	Recno, Titulo, Parcela, 

	Case 
		when (Status = 'ABERTO' AND DiasVencidos = 0 AND ValorPago = 0) then 'A PAGAR'
		when (Status = 'ABERTO' AND DiasVencidos > 0 AND ValorPago = 0) then 'VENCIDO'
		when (Status = 'ABERTO' AND DiasVencidos = 0 AND ValorPago > 0) then 'PARCIAL A PAGAR'
		when (Status = 'ABERTO' AND DiasVencidos > 0 AND ValorPago > 0) then 'PARCIAL VENCIDO'
		when (Status = 'BAIXADO') then 'BAIXADO'
	end as Status, 
	
	Tipo, Banco, AgendaConta, ValorTitulo, ValorPago, Saldo, 
	ComissaoPerc, Comissao,	Emissao, Vencimento, DataPagamento, RegistroPagamento, DiasVencidos, 
	Cliente_ID, Cliente, Regiao, Cidade, UF, ProdutoID, ProdutoPos, ProdutoLote, ProdutoQtd, ProdutoValorUnitario

FROM (
				SELECT

						ContaAReceber.R_E_C_N_O_ as Recno,
						E1_NUM as Titulo, Case when E1_PARCELA = '' then '00' else E1_PARCELA end as Parcela, 
						CASE WHEN E1_FSFORMA = '' then E1_TIPO else E1_FSFORMA end as Tipo, 

						CASE WHEN E1_PORTADO = '' then '237 - BRADESCO' else E1_PORTADO + ' - ' + A6_NREDUZ end as Banco, 
						CASE WHEN (E1_AGEDEP = '' AND E1_CONTA = '') then '2864  - 34507' else E1_AGEDEP + ' - ' + E1_CONTA end as AgendaConta,

						CASE 
							WHEN E1_STATUS = 'A' THEN 'ABERTO' 
							WHEN E1_STATUS = 'B' THEN 'BAIXADO' 
							WHEN E1_STATUS = 'R' THEN 'RELIQUIDADO' 
						END AS Status,

						E1_VALOR as ValorTitulo, E1_DESCONT as Desconto, E1_MULTA as Multa, E1_JUROS as Juros, 
						Isnull(ValorPago,0) as ValorPago, E1_SALDO as Saldo, E1_VALOR - Isnull(ValorPago,0) as SaldoCalc,
						E1_COMIS1 as ComissaoPerc, (E1_BASCOM1 * E1_COMIS1)/100 as Comissao,
	
						Convert(Datetime,E1_EMISSAO,112) as Emissao, 
						Convert(Datetime,E1_VENCREA,112) as Vencimento, DataPagamento,  FK1_IDDOC as RegistroPagamento,
		
						Case When E1_SALDO = 0 then 0 else		

							   Case 
									When ((DATEDIFF(Day,Convert(Datetime,E1_VENCREA,112),GetDate()) <= 0)) then 0 
							   else 	
									DATEDIFF(Day,Convert(Datetime,E1_VENCREA,112),GetDate()) 
							   end
						end as DiasVencidos,  	
	
						E1_CLIENTE + ' - ' + E1_LOJA as Cliente_ID, A1_NOME as Cliente, A1_MUN as Cidade, A1_EST as UF,
						Ltrim(Rtrim(Cliente.A1_FSREGI)) + ' - ' + Rtrim(Cliente.A1_FSDREGI) AS Regiao,
						D2_COD as ProdutoID, D2_ITEM as ProdutoPos, D2_LOTECTL as ProdutoLote, D2_QUANT as ProdutoQtd, 
						D2_PRCVEN as ProdutoValorUnitario, D2_TOTAL as ProdutoTotal, A3_NOME as Vendedor

				from SE1010 ContaAReceber (nolock)
				Inner Join SA3010 Vendedor ON A3_FILIAL = ''
										  AND Vendedor.D_E_L_E_T_ <> '*' 
										  AND A3_COD = E1_VEND1
				Inner Join SD2010 Produtos (nolock) ON D2_FILIAL = '010101'
												   AND Produtos.D_E_L_E_T_ <> '*'
												   AND D2_DOC = ContaAReceber.E1_NUM
												   AND D2_COMIS1 > 0
				INNER JOIN SB1010 Produto (nolock) ON B1_FILIAL = ''
											  AND Produto.D_E_L_E_T_ <> '*'
											  AND B1_COD = D2_COD 
				INNER JOIN SBM010 Grupo (nolock) ON BM_FILIAL = ''
												AND Grupo.D_E_L_E_T_ <> '*' 
												AND BM_GRUPO  = D2_GRUPO 
				Inner Join SA1010 Cliente (Nolock) ON A1_FILIAL = ''
												  AND Cliente.D_E_L_E_T_ <> '*' 
												  AND Cliente.A1_COD = E1_CLIENTE
												  AND Cliente.A1_LOJA = E1_LOJA
				Left Join (

								Select 
									FK1_IDDOC, FK7_NUM, FK7_PARCEL, FK7_TIPO, FK7_CLIFOR, FK7_LOJA, 
									Sum(FK1_VALOR) as ValorPago, Convert(Datetime,Max(FK1_DATA),112) as DataPagamento
								from FK7010 Auxiliar (nolock)
								Inner Join FK1010 Pagamento (nolock) ON FK1_FILIAL = '010101'
 																	  AND Pagamento.D_E_L_E_T_ <> '*'	 
																	  AND FK1_RECPAG = 'R'
																	  AND FK1_MOTBX <> 'DEV'
																	  AND FK1_IDDOC = FK7_IDDOC
													  
								Where 1=1
								AND FK7_FILIAL = '010101'
								AND Auxiliar.D_E_L_E_T_ <> '*'
								AND FK7_ALIAS = 'SE1'
								Group by FK1_IDDOC, FK7_NUM, FK7_PARCEL, FK7_TIPO, FK7_CLIFOR, FK7_LOJA 

				) Baixas ON Baixas.FK7_NUM = E1_NUM
						AND Baixas.FK7_PARCEL = E1_PARCELA 
						AND Baixas.FK7_TIPO = E1_TIPO
						AND Baixas.FK7_CLIFOR = E1_CLIENTE
						AND Baixas.FK7_LOJA = E1_LOJA
				Left Join (
				
							Select Distinct 
								A6_COD, A6_NREDUZ
							 from SA6010 Banco (Nolock)
							 Where A6_FILIAL = '010101'
							 AND D_E_L_E_T_ <> '*'

				) Banco ON Banco.A6_COD = E1_PORTADO
				Where 1=1
				AND ContaAReceber.E1_FILIAL = '010101'
				AND ContaAReceber.D_E_L_E_T_ <> '*'				
				AND E1_VEND1 <> ''			

				UNION ALL

				SELECT

						ContaAReceber.R_E_C_N_O_ as Recno,
						E1_NUM as Titulo, Case when E1_PARCELA = '' then '00' else E1_PARCELA end as Parcela, 
						CASE WHEN E1_FSFORMA = '' then E1_TIPO else E1_FSFORMA end as Tipo, 

						CASE WHEN E1_PORTADO = '' then '237 - BRADESCO' else E1_PORTADO + ' - ' + A6_NREDUZ end as Banco, 
						CASE WHEN (E1_AGEDEP = '' AND E1_CONTA = '') then '2864  - 34507' else E1_AGEDEP + ' - ' + E1_CONTA end as AgendaConta,

						CASE 
							WHEN E1_STATUS = 'A' THEN 'ABERTO' 
							WHEN E1_STATUS = 'B' THEN 'BAIXADO' 
							WHEN E1_STATUS = 'R' THEN 'RELIQUIDADO' 
						END AS Status,

						E1_VALOR as ValorTitulo, E1_DESCONT as Desconto, E1_MULTA as Multa, E1_JUROS as Juros, 
						Isnull(ValorPago,0) as ValorPago, E1_SALDO as Saldo, E1_VALOR - Isnull(ValorPago,0) as SaldoCalc,
						E1_COMIS2 as ComissaoPerc, (E1_BASCOM2 * E1_COMIS2)/100 as Comissao,
	
						Convert(Datetime,E1_EMISSAO,112) as Emissao, 
						Convert(Datetime,E1_VENCREA,112) as Vencimento, DataPagamento,  FK1_IDDOC as RegistroPagamento,
		
						Case When E1_SALDO = 0 then 0 else		

							   Case 
									When ((DATEDIFF(Day,Convert(Datetime,E1_VENCREA,112),GetDate()) <= 0)) then 0 
							   else 	
									DATEDIFF(Day,Convert(Datetime,E1_VENCREA,112),GetDate()) 
							   end
						end as DiasVencidos,  	
	
						E1_CLIENTE + ' - ' + E1_LOJA as Cliente_ID, A1_NOME as Cliente, A1_MUN as Cidade, A1_EST as UF,
						Ltrim(Rtrim(Cliente.A1_FSREGI)) + ' - ' + Rtrim(Cliente.A1_FSDREGI) AS Regiao,
						D2_COD as ProdutoID, D2_ITEM as ProdutoPos, D2_LOTECTL as ProdutoLote, D2_QUANT as ProdutoQtd, 
						D2_PRCVEN as ProdutoValorUnitario, D2_TOTAL as ProdutoTotal, A3_NOME as Vendedor

				from SE1010 ContaAReceber (nolock)
				Inner Join SA3010 Vendedor ON A3_FILIAL = ''
										  AND Vendedor.D_E_L_E_T_ <> '*' 
										  AND A3_COD = E1_VEND2
				Inner Join SD2010 Produtos (nolock) ON D2_FILIAL = '010101'
												   AND Produtos.D_E_L_E_T_ <> '*'
												   AND D2_DOC = ContaAReceber.E1_NUM
												   AND D2_COMIS2 > 0
				INNER JOIN SB1010 Produto (nolock) ON B1_FILIAL = ''
											  AND Produto.D_E_L_E_T_ <> '*'
											  AND B1_COD = D2_COD 
				INNER JOIN SBM010 Grupo (nolock) ON BM_FILIAL = ''
												AND Grupo.D_E_L_E_T_ <> '*' 
												AND BM_GRUPO  = D2_GRUPO 
				Inner Join SA1010 Cliente (Nolock) ON A1_FILIAL = ''
												  AND Cliente.D_E_L_E_T_ <> '*' 
												  AND Cliente.A1_COD = E1_CLIENTE
												  AND Cliente.A1_LOJA = E1_LOJA
				Left Join (

								Select 
									FK1_IDDOC, FK7_NUM, FK7_PARCEL, FK7_TIPO, FK7_CLIFOR, FK7_LOJA, 
									Sum(FK1_VALOR) as ValorPago, Convert(Datetime,Max(FK1_DATA),112) as DataPagamento
								from FK7010 Auxiliar (nolock)
								Inner Join FK1010 Pagamento (nolock) ON FK1_FILIAL = '010101'
 																	  AND Pagamento.D_E_L_E_T_ <> '*'	 
																	  AND FK1_RECPAG = 'R'
																	  AND FK1_MOTBX <> 'DEV'
																	  AND FK1_IDDOC = FK7_IDDOC
													  
								Where 1=1
								AND FK7_FILIAL = '010101'
								AND Auxiliar.D_E_L_E_T_ <> '*'
								AND FK7_ALIAS = 'SE1'
								Group by FK1_IDDOC, FK7_NUM, FK7_PARCEL, FK7_TIPO, FK7_CLIFOR, FK7_LOJA 

				) Baixas ON Baixas.FK7_NUM = E1_NUM
						AND Baixas.FK7_PARCEL = E1_PARCELA 
						AND Baixas.FK7_TIPO = E1_TIPO
						AND Baixas.FK7_CLIFOR = E1_CLIENTE
						AND Baixas.FK7_LOJA = E1_LOJA
				Left Join (
				
							Select Distinct 
								A6_COD, A6_NREDUZ
							 from SA6010 Banco (Nolock)
							 Where A6_FILIAL = '010101'
							 AND D_E_L_E_T_ <> '*'

				) Banco ON Banco.A6_COD = E1_PORTADO
				Where 1=1
				AND ContaAReceber.E1_FILIAL = '010101'
				AND ContaAReceber.D_E_L_E_T_ <> '*'				
				AND E1_VEND2 <> ''

				UNION ALL

				SELECT

						ContaAReceber.R_E_C_N_O_ as Recno,
						E1_NUM as Titulo, Case when E1_PARCELA = '' then '00' else E1_PARCELA end as Parcela, 
						CASE WHEN E1_FSFORMA = '' then E1_TIPO else E1_FSFORMA end as Tipo, 

						CASE WHEN E1_PORTADO = '' then '237 - BRADESCO' else E1_PORTADO + ' - ' + A6_NREDUZ end as Banco, 
						CASE WHEN (E1_AGEDEP = '' AND E1_CONTA = '') then '2864  - 34507' else E1_AGEDEP + ' - ' + E1_CONTA end as AgendaConta,

						CASE 
							WHEN E1_STATUS = 'A' THEN 'ABERTO' 
							WHEN E1_STATUS = 'B' THEN 'BAIXADO' 
							WHEN E1_STATUS = 'R' THEN 'RELIQUIDADO' 
						END AS Status,

						E1_VALOR as ValorTitulo, E1_DESCONT as Desconto, E1_MULTA as Multa, E1_JUROS as Juros, 
						Isnull(ValorPago,0) as ValorPago, E1_SALDO as Saldo, E1_VALOR - Isnull(ValorPago,0) as SaldoCalc,
						E1_COMIS3 as ComissaoPerc, (E1_BASCOM3 * E1_COMIS3)/100 as Comissao,
	
						Convert(Datetime,E1_EMISSAO,112) as Emissao, 
						Convert(Datetime,E1_VENCREA,112) as Vencimento, DataPagamento,  FK1_IDDOC as RegistroPagamento,
		
						Case When E1_SALDO = 0 then 0 else		

							   Case 
									When ((DATEDIFF(Day,Convert(Datetime,E1_VENCREA,112),GetDate()) <= 0)) then 0 
							   else 	
									DATEDIFF(Day,Convert(Datetime,E1_VENCREA,112),GetDate()) 
							   end
						end as DiasVencidos,  	
	
						E1_CLIENTE + ' - ' + E1_LOJA as Cliente_ID, A1_NOME as Cliente, A1_MUN as Cidade, A1_EST as UF,
						Ltrim(Rtrim(Cliente.A1_FSREGI)) + ' - ' + Rtrim(Cliente.A1_FSDREGI) AS Regiao,
						D2_COD as ProdutoID, D2_ITEM as ProdutoPos, D2_LOTECTL as ProdutoLote, D2_QUANT as ProdutoQtd, 
						D2_PRCVEN as ProdutoValorUnitario, D2_TOTAL as ProdutoTotal, A3_NOME as Vendedor

				from SE1010 ContaAReceber (nolock)
				Inner Join SA3010 Vendedor ON A3_FILIAL = ''
										  AND Vendedor.D_E_L_E_T_ <> '*' 
										  AND A3_COD = E1_VEND3
				Inner Join SD2010 Produtos (nolock) ON D2_FILIAL = '010101'
												   AND Produtos.D_E_L_E_T_ <> '*'
												   AND D2_DOC = ContaAReceber.E1_NUM
												   AND D2_COMIS3 > 0
				INNER JOIN SB1010 Produto (nolock) ON B1_FILIAL = ''
											  AND Produto.D_E_L_E_T_ <> '*'
											  AND B1_COD = D2_COD 
				INNER JOIN SBM010 Grupo (nolock) ON BM_FILIAL = ''
												AND Grupo.D_E_L_E_T_ <> '*' 
												AND BM_GRUPO  = D2_GRUPO 
				Inner Join SA1010 Cliente (Nolock) ON A1_FILIAL = ''
												  AND Cliente.D_E_L_E_T_ <> '*' 
												  AND Cliente.A1_COD = E1_CLIENTE
												  AND Cliente.A1_LOJA = E1_LOJA
				Left Join (

								Select 
									FK1_IDDOC, FK7_NUM, FK7_PARCEL, FK7_TIPO, FK7_CLIFOR, FK7_LOJA, 
									Sum(FK1_VALOR) as ValorPago, Convert(Datetime,Max(FK1_DATA),112) as DataPagamento
								from FK7010 Auxiliar (nolock)
								Inner Join FK1010 Pagamento (nolock) ON FK1_FILIAL = '010101'
 																	  AND Pagamento.D_E_L_E_T_ <> '*'	 
																	  AND FK1_RECPAG = 'R'
																	  AND FK1_MOTBX <> 'DEV'
																	  AND FK1_IDDOC = FK7_IDDOC
													  
								Where 1=1
								AND FK7_FILIAL = '010101'
								AND Auxiliar.D_E_L_E_T_ <> '*'
								AND FK7_ALIAS = 'SE1'
								Group by FK1_IDDOC, FK7_NUM, FK7_PARCEL, FK7_TIPO, FK7_CLIFOR, FK7_LOJA 

				) Baixas ON Baixas.FK7_NUM = E1_NUM
						AND Baixas.FK7_PARCEL = E1_PARCELA 
						AND Baixas.FK7_TIPO = E1_TIPO
						AND Baixas.FK7_CLIFOR = E1_CLIENTE
						AND Baixas.FK7_LOJA = E1_LOJA
				Left Join (
				
							Select Distinct 
								A6_COD, A6_NREDUZ
							 from SA6010 Banco (Nolock)
							 Where A6_FILIAL = '010101'
							 AND D_E_L_E_T_ <> '*'

				) Banco ON Banco.A6_COD = E1_PORTADO
				Where 1=1
				AND ContaAReceber.E1_FILIAL = '010101'
				AND ContaAReceber.D_E_L_E_T_ <> '*'				
				AND E1_VEND3 <> ''				

) TB
Order by TB.Recno desc