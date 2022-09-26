 Select 
 	Emissao, 
	Day(Emissao) as Dia,  

	Case 
            When Month(Emissao) = 1 then '01 - JANEIRO' 
            When Month(Emissao) = 2 then '02 - FEVEREIRO' 
            When Month(Emissao) = 3 then '03 - MARÇO' 
            When Month(Emissao) = 4 then '04 - ABRIL' 
            When Month(Emissao) = 5 then '05 - MAIO' 
            When Month(Emissao) = 6 then '06 - JUNHO' 
            When Month(Emissao) = 7 then '07 - JULHO' 
            When Month(Emissao) = 8 then '08 - AGOSTO' 
            When Month(Emissao) = 9 then '09 - SETEMBRO' 
            When Month(Emissao) = 10 then '10 - OUTUBRO' 
            When Month(Emissao) = 11 then '11 - NOVEMBRO' 
            When Month(Emissao) = 12 then '12 - DEZEMBRO' 
	End as Mes,
		
	Year(Emissao) as Ano,

	Armazem, Tipo + ' - ' + TipoMovimento as TipoMovimento, 
 	Classificacao_ID + ' - ' + Classificacao as Classificacao, Documento, 
 	Rtrim(Produto_ID) + ' - ' + Rtrim(Produto) as Produto, 
 	Lote, Convert(Varchar(10),DataValidade,103) as Validade, 
 	Quantidade, Custo, Upper(Ltrim(Rtrim(Responsavel))) as Responsavel
 	
 from ( 
 
 		Select 
 
 			Estoque.D3_FILIAL as Empresa, 
 			CONVERT(Datetime,Estoque.D3_EMISSAO, 112) AS Emissao, 			
 			Rtrim(Estoque.D3_LOCAL) + ' - ' + Rtrim(Armazem.NNR_DESCRI) AS Armazem, 
 
 			Case 
 				When SUBSTRING(Estoque.D3_CF, 1, 2) = 'RE' then 'SAIDA'
 				When SUBSTRING(Estoque.D3_CF, 1, 2) = 'DE' then 'ENTRADA'
 				When SUBSTRING(Estoque.D3_CF, 1, 2) = 'PR' then 'ENTRADA'
 			end as Tipo, 
 
 			Case 
 				When SUBSTRING(Estoque.D3_CF, 1, 2) = 'RE' then 'S'
 				When SUBSTRING(Estoque.D3_CF, 1, 2) = 'DE' then 'E'
 				When SUBSTRING(Estoque.D3_CF, 1, 2) = 'PR' then 'E'
 			end as TipoCompacto, 
 
 			Estoque.D3_TM AS TipoMovimento_ID, 
 			Case 
 				When Estoque.D3_TM = '010' then 'PRODUCAO'
 				When Estoque.D3_TM = '100' then 'DEVOLUCAO AO ARMAZEM'
 				When Estoque.D3_TM = '102' then 'AJUSTE QTD (+)'
 				When Estoque.D3_TM = '200' then 'AJUSTE VALOR (+)'
 				When Estoque.D3_TM = '400' then 'MOVIMENTACAO INTERNA'
 				When Estoque.D3_TM = '499' then 'DEVOLUCÃO TOTVS'
 				When Estoque.D3_TM = '501' then 'REQUISICAO'
 				When Estoque.D3_TM = '502' then 'AJUSTE QTD (-)'
 				When Estoque.D3_TM = '503' then 'REPOSICAO DE PERDA'
 				When Estoque.D3_TM = '700' then 'AJUSTE DE VALOR (-)'
 				When Estoque.D3_TM = '999' then 'REQUISICAO TOTVS'
 			end as TipoMovimento,  
   
 			Estoque.D3_CF AS Classificacao_ID,  
   
 			Case   
 				WHEN D3_CF = 'DE0' then 'DEVOLUÇÃO MANUAL'
 				WHEN D3_CF = 'DE1' then 'DEVOLUÇÃO AUTOMÁTICA - ESTORNO DA PRODUÇÃO'
 				WHEN D3_CF = 'DE2' then 'DEVOLUÇÃO AUTOMÁTICA DE MATERIAL DE APROPRIAÇÃO INDIRETA - ESTORNO DA PRODUÇÃO'
 				WHEN D3_CF = 'DE3' then 'ESTORNO DE TRANSFERÊNCIA PARA LOCAL DE APROPRIAÇÃO INDIRETA'
 				WHEN D3_CF = 'DE4' then 'DEVOLUÇÃO DE TRANSFERÊNCIA ENTRE LOCAIS'
 				WHEN D3_CF = 'DE5' then 'DEVOLUÇÃO DE MATERIAL APROPRIADO EM OP - EXCLUSÃO DE NOTA FISCAL DE ENTRADA'
 				WHEN D3_CF = 'DE6' then 'DEVOLUÇÃO VALORIZADA'
 				WHEN D3_CF = 'DE7' then 'DEVOLUÇÃO DE TRANSFERÊNCIA DE UM PARA N'
 				WHEN D3_CF = 'RE0' then 'REQUISIÇÃO MANUAL'
 				WHEN D3_CF = 'RE1' then 'REQUISIÇÃO AUTOMÁTICA'
 				WHEN D3_CF = 'RE2' then 'REQUISIÇÃO AUTOMÁTICA DE MATERIAL DE APROPRIAÇÃO INDIRETA'
 				WHEN D3_CF = 'RE3' then 'TRANSFERÊNCIA PARA LOCAL DE APROPRIAÇÃO INDIRETA'
 				WHEN D3_CF = 'RE4' then 'REQUISIÇÃO POR TRANSFERÊNCIA'
 				WHEN D3_CF = 'RE5' then 'REQUISIÇÃO INFORMANDO OP NA NOTA FISCAL DE ENTRADA'
 				WHEN D3_CF = 'RE6' then 'REQUISIÇÃO  VALORIZADA'
 				WHEN D3_CF = 'RE7' then 'REQUISIÇÃO PARA TRANSFERÊNCIA DE UM PARA  N'
 				WHEN D3_CF = 'PR0' then 'PRODUÇÃO MANUAL'
 			END AS Classificacao, 
   
 			RTRIM(Estoque.D3_DOC) AS Documento, Estoque.D3_NUMSEQ AS Sequencia, 
 			RTRIM(Estoque.D3_COD) AS Produto_ID, Rtrim(Produto.B1_DESC) as Produto, Estoque.D3_TIPO AS ProdutoTipo, ISNULL(D5_QUANT,D3_QUANT) AS Quantidade, 
 			Rtrim(Estoque.D3_UM) AS Unidade, Isnull(Rtrim(D5_LOTECTL),D3_LOTECTL) AS Lote,
 			Isnull(Case When Year(D5_DTVALID) = 1900 then NULL else CONVERT(Datetime, D5_DTVALID, 112) end,CONVERT(Datetime, D3_DTVALID, 112)) AS DataValidade, 
 
 			Estoque.D3_IDENT AS Identidade, Estoque.D3_CONTA AS ContaContabil, Estoque.D3_OP AS OrdemProducao, Estoque.D3_CUSTO1 AS Custo, Estoque.D3_CC AS CentroCusto, 
 			Rtrim(UPPER(Estoque.D3_USUARIO)) AS Responsavel, Estoque.R_E_C_N_O_ AS Recno
 
 		from SD3010 Estoque (nolock) 
 		Inner Join NNR010 Armazem (Nolock) ON Armazem.NNR_FILIAL = '010101'
 														 AND Armazem.D_E_L_E_T_ <> '*'
 														 AND Armazem.NNR_CODIGO = Estoque.D3_LOCAL  
 		Inner Join SB1010 (nolock) Produto ON Produto.D_E_L_E_T_ <> '*'
 														 AND Produto.B1_FILIAL = ''
 														 AND Produto.B1_COD = Estoque.D3_COD   
 		Left Join SD5010 D5 (nolock) ON D5_FILIAL = '010101'
 				  										 AND D5.D_E_L_E_T_ <> '*'
 														   AND D5_ESTORNO <> 'S' 														    
 														   AND D5_PRODUTO = Estoque.D3_COD 
 														   AND D5_LOCAL = D3_LOCAL  
 														   AND D5_NUMSEQ = D3_NUMSEQ  
 		Where Estoque.D3_FILIAL = '010101'
 		AND (Estoque.D_E_L_E_T_ <> '*') 
 		AND Year(Estoque.D3_EMISSAO) = :Ano
 		AND RTRIM(Estoque.D3_COD) + Rtrim(Produto.B1_DESC) like '%' + :Produto + '%'          

		UNION ALL 
		
 		Select 
 
 			Estoque.D2_FILIAL as Empresa, 
 			CONVERT(Datetime,Estoque.D2_EMISSAO, 112) AS Emissao, 			
 			Rtrim(Estoque.D2_LOCAL) + ' - ' + Rtrim(Armazem.NNR_DESCRI) AS Armazem, 
 
			'SAIDA' as Tipo, 
 
			'S' as TipoCompacto, 
 
			Rtrim(D2_TES) AS TipoMovimento_ID, 
			TipoSaida.F4_TEXTO as TipoMovimento, 
   
 			Estoque.D2_CF AS Classificacao_ID,  
   
			'NOTA FISCAL DE SAIDA' as Classificacao, 
   
 			RTRIM(Estoque.D2_DOC) AS Documento, Estoque.D2_NUMSEQ AS Sequencia, 
 			RTRIM(Estoque.D2_COD) AS Produto_ID, Rtrim(Produto.B1_DESC) as Produto, Estoque.D2_TIPO AS ProdutoTipo, Estoque.D2_QUANT AS Quantidade, 
 			Rtrim(Estoque.D2_UM) AS Unidade, Rtrim(Estoque.D2_LOTECTL) AS Lote, 
			Case When Year(Estoque.D2_DTVALID) = 1900 then NULL else CONVERT(Datetime, Estoque.D2_DTVALID, 112) end AS DataValidade, 
 
 			Estoque.D2_IDENTB6 AS Identidade, Estoque.D2_CONTA AS ContaContabil, '' AS OrdemProducao, Estoque.D2_CUSTO1 AS Custo, Estoque.D2_CCUSTO AS CentroCusto, 
			
			(Select USR_CODIGO from SYS_USR where USR_ID in (

					Case when ( SUBSTRING(F2_USERLGA, 11,1)+SUBSTRING(F2_USERLGA, 15,1)+
								SUBSTRING(F2_USERLGA, 2, 1)+SUBSTRING(F2_USERLGA, 6, 1)+
								SUBSTRING(F2_USERLGA, 10,1)+SUBSTRING(F2_USERLGA, 14,1)+
								SUBSTRING(F2_USERLGA, 1, 1)+SUBSTRING(F2_USERLGA, 5, 1)+
								SUBSTRING(F2_USERLGA, 9, 1)+SUBSTRING(F2_USERLGA, 13,1)+
								SUBSTRING(F2_USERLGA, 17,1)+SUBSTRING(F2_USERLGA, 4, 1)+
								SUBSTRING(F2_USERLGA, 8, 1)) = '' 
			
								then 

								SUBSTRING(F2_USERLGI, 11,1)+SUBSTRING(F2_USERLGI, 15,1)+
								SUBSTRING(F2_USERLGI, 2, 1)+SUBSTRING(F2_USERLGI, 6, 1)+
								SUBSTRING(F2_USERLGI, 10,1)+SUBSTRING(F2_USERLGI, 14,1)+
								SUBSTRING(F2_USERLGI, 1, 1)+SUBSTRING(F2_USERLGI, 5, 1)+
								SUBSTRING(F2_USERLGI, 9, 1)+SUBSTRING(F2_USERLGI, 13,1)+
								SUBSTRING(F2_USERLGI, 17,1)+SUBSTRING(F2_USERLGI, 4, 1)+
								SUBSTRING(F2_USERLGI, 8, 1) 

								else 

								SUBSTRING(F2_USERLGA, 11,1)+SUBSTRING(F2_USERLGA, 15,1)+
								SUBSTRING(F2_USERLGA, 2, 1)+SUBSTRING(F2_USERLGA, 6, 1)+
								SUBSTRING(F2_USERLGA, 10,1)+SUBSTRING(F2_USERLGA, 14,1)+
								SUBSTRING(F2_USERLGA, 1, 1)+SUBSTRING(F2_USERLGA, 5, 1)+
								SUBSTRING(F2_USERLGA, 9, 1)+SUBSTRING(F2_USERLGA, 13,1)+
								SUBSTRING(F2_USERLGA, 17,1)+SUBSTRING(F2_USERLGA, 4, 1)+
								SUBSTRING(F2_USERLGA, 8, 1)

								end

			)) as Responsavel,
			
			Estoque.R_E_C_N_O_ AS Recno
 
 		from SD2010 Estoque (nolock) 
		INNER JOIN SF2010 NotaSaida (nolock) ON D2_FILIAL = '010101'
							   AND Estoque.D_E_L_E_T_ <> '*' 
							   AND D2_DOC = F2_DOC
							   AND D2_SERIE = F2_SERIE
							   AND D2_TIPO = F2_TIPO
							   AND D2_CLIENTE = F2_CLIENTE
							   AND D2_LOJA = F2_LOJA
		INNER JOIN SF4010 TipoSaida (nolock) ON TipoSaida.F4_FILIAL = ''
											 AND TipoSaida.D_E_L_E_T_ <> '*'
											 AND TipoSaida.F4_CODIGO = D2_TES 
											 AND TipoSaida.F4_TIPO = 'S'
	 	Inner Join NNR010 Armazem (Nolock) ON Armazem.NNR_FILIAL = '010101'
 														 AND Armazem.D_E_L_E_T_ <> '*'
 														 AND Armazem.NNR_CODIGO = Estoque.D2_LOCAL  
 		Inner Join SB1010 (nolock) Produto ON Produto.D_E_L_E_T_ <> '*'
 														 AND Produto.B1_FILIAL = ''
 														 AND Produto.B1_COD = Estoque.D2_COD   
 		Where Estoque.D2_FILIAL = '010101'
 		AND (Estoque.D_E_L_E_T_ <> '*') 
 		AND Year(Estoque.D2_EMISSAO) = :Ano
 		AND RTRIM(Estoque.D2_COD) + Rtrim(Produto.B1_DESC) like '%' + :Produto + '%'    
		
		UNION ALL 
 
 		Select 
 
 			Estoque.D1_FILIAL as Empresa, 
 			CONVERT(Datetime,Estoque.D1_DTDIGIT, 112) AS Emissao,  			
 			Rtrim(Estoque.D1_LOCAL) + ' - ' + Rtrim(Armazem.NNR_DESCRI) AS Armazem, 
 
			'ENTRADA' as Tipo, 'E' as TipoCompacto, 
			Rtrim(D1_TES) AS TipoMovimento_ID, 
			TipoEntrada.F4_TEXTO AS TipoMovimento,    
 			Estoque.D1_CF AS ClassificacaoID,  'NOTA FISCAL DE ENTRADA' as Classificacao, 
   
 			RTRIM(Estoque.D1_DOC) AS Documento, Estoque.D1_NUMSEQ AS Sequencia, 
 			RTRIM(Estoque.D1_COD) AS Produto_ID, Rtrim(Produto.B1_DESC) as Produto, Estoque.D1_TIPO AS ProdutoTipo, Estoque.D1_QUANT AS Quantidade, 
 			Rtrim(Estoque.D1_UM) AS Unidade, Rtrim(Estoque.D1_LOTECTL) AS Lote, Case When Year(Estoque.D1_DTVALID) = 1900 then NULL else CONVERT(Datetime, Estoque.D1_DTVALID, 112) end AS DataValidade, 
 
 			Estoque.D1_IDENTB6 AS Identidade, Estoque.D1_CONTA AS ContaContabil, '' AS OrdemProducao, Estoque.D1_CUSTO AS Custo, Estoque.D1_CC AS CentroCusto, 
			(Select USR_CODIGO from SYS_USR where USR_ID in (
				Case when ( SUBSTRING(F1_USERLGA, 11,1)+SUBSTRING(F1_USERLGA, 15,1)+
							SUBSTRING(F1_USERLGA, 2, 1)+SUBSTRING(F1_USERLGA, 6, 1)+
							SUBSTRING(F1_USERLGA, 10,1)+SUBSTRING(F1_USERLGA, 14,1)+
							SUBSTRING(F1_USERLGA, 1, 1)+SUBSTRING(F1_USERLGA, 5, 1)+
							SUBSTRING(F1_USERLGA, 9, 1)+SUBSTRING(F1_USERLGA, 13,1)+
							SUBSTRING(F1_USERLGA, 17,1)+SUBSTRING(F1_USERLGA, 4, 1)+
							SUBSTRING(F1_USERLGA, 8, 1)) = '' 
			
							then 

							SUBSTRING(F1_USERLGI, 11,1)+SUBSTRING(F1_USERLGI, 15,1)+
							SUBSTRING(F1_USERLGI, 2, 1)+SUBSTRING(F1_USERLGI, 6, 1)+
							SUBSTRING(F1_USERLGI, 10,1)+SUBSTRING(F1_USERLGI, 14,1)+
							SUBSTRING(F1_USERLGI, 1, 1)+SUBSTRING(F1_USERLGI, 5, 1)+
							SUBSTRING(F1_USERLGI, 9, 1)+SUBSTRING(F1_USERLGI, 13,1)+
							SUBSTRING(F1_USERLGI, 17,1)+SUBSTRING(F1_USERLGI, 4, 1)+
							SUBSTRING(F1_USERLGI, 8, 1) 

							else 

							SUBSTRING(F1_USERLGA, 11,1)+SUBSTRING(F1_USERLGA, 15,1)+
							SUBSTRING(F1_USERLGA, 2, 1)+SUBSTRING(F1_USERLGA, 6, 1)+
							SUBSTRING(F1_USERLGA, 10,1)+SUBSTRING(F1_USERLGA, 14,1)+
							SUBSTRING(F1_USERLGA, 1, 1)+SUBSTRING(F1_USERLGA, 5, 1)+
							SUBSTRING(F1_USERLGA, 9, 1)+SUBSTRING(F1_USERLGA, 13,1)+
							SUBSTRING(F1_USERLGA, 17,1)+SUBSTRING(F1_USERLGA, 4, 1)+
							SUBSTRING(F1_USERLGA, 8, 1)

							end
		))		 as Responsavel, Estoque.R_E_C_N_O_ AS Recno 
			 
 
 		from SD1010 Estoque (nolock) 
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
										   AND TipoEntrada.F4_TIPO = 'E'
 		Inner Join NNR010 Armazem (Nolock) ON Armazem.NNR_FILIAL = '010101'
 														 AND Armazem.D_E_L_E_T_ <> '*'
 														 AND Armazem.NNR_CODIGO = Estoque.D1_LOCAL   		
 		Inner Join SB1010 (nolock) Produto ON Produto.D_E_L_E_T_ <> '*'
 														 AND Produto.B1_FILIAL = ''
 														 AND Produto.B1_COD = Estoque.D1_COD   
 		Where Estoque.D1_FILIAL = '010101'
 		AND (Estoque.D_E_L_E_T_ <> '*') 
 		AND Year(Estoque.D1_DTDIGIT) = :Ano
 		AND RTRIM(Estoque.D1_COD) + Rtrim(Produto.B1_DESC) like '%' + :Produto + '%' 
		
 ) TB  
 Where 1=1  
 Order by Empresa, Armazem, Emissao desc, Produto_ID, Tipo  