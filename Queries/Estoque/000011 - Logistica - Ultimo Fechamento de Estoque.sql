

Select 

	* 

from (

			Select 

				B9_COD, B9_LOCAL, B9_DATA, Saldo, SaldoPorLote, CustoMedio, ValorEstoque,
				Case when  (Saldo - SaldoPorLote) = 0 then 'OK' else 'DESBALANCEADO' end Status

			from (

						Select 
							B9_COD, B9_LOCAL, B9_DATA, B9_QINI as Saldo, B9_CM1 as CustoMedio, B9_VINI1 as ValorEstoque

						from SB9010 Fechamento 
						Where 1=1
						AND B9_FILIAL = '010101'
						AND Fechamento.D_E_L_E_T_ <> '*'
						AND B9_DATA IN (

												Select 
													X6_CONTEUD 
												from SX6010 X6 (nolock)
												Where 1=1
												AND X6_FIL = '010101'
												AND D_E_L_E_T_ <> '*'
												AND X6_VAR = 'MV_ULMES'		

									)

			) Fechamento 
			Inner Join (

							Select 

								BJ_LOCAL, BJ_DATA, BJ_COD, SUM(BJ_QINI) AS SaldoPorLote 

							from (

										Select 
											 BJ_LOCAL, BJ_DATA, BJ_COD, BJ_LOTECTL, BJ_DTVALID, BJ_QINI
										from SBJ010 FechamentoPorLote (nolock)
										Where 1=1
										AND BJ_FILIAL = '010101'
										AND D_E_L_E_T_ <> '*'
										AND BJ_DATA IN (

													Select 
														X6_CONTEUD 
													from SX6010 X6 (nolock)
													Where 1=1
													AND X6_FIL = '010101'
													AND D_E_L_E_T_ <> '*'
													AND X6_VAR = 'MV_ULMES'		

										)
							) TB
							GROUP by BJ_LOCAL, BJ_DATA, BJ_COD

			) FechamentoPorLote ON FechamentoPorLote.BJ_COD = Fechamento.B9_COD
							   AND FechamentoPorLote.BJ_DATA = Fechamento.B9_DATA 
							   AND FechamentoPorLote.BJ_LOCAL = Fechamento.B9_LOCAL


) TB
Where Status <> 'OK'