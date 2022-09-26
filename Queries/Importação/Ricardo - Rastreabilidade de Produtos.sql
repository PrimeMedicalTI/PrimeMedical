


 Select 
 	* 
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
 
 			Estoque.D3_TM AS TipoMovimento_FK, 
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
   
 			Estoque.D3_CF AS Classificacao_FK,  
   
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
 			RTRIM(Estoque.D3_COD) AS Produto_FK, Rtrim(Produto.B1_DESC) as Produto, Estoque.D3_TIPO AS ProdutoTipo, ISNULL(D5_QUANT,D3_QUANT) AS Quantidade, 
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

		UNION ALL 
		
 		Select 
 
 			Estoque.D2_FILIAL as Empresa, 
 			CONVERT(Datetime,Estoque.D2_EMISSAO, 112) AS Emissao, 			
 			Rtrim(Estoque.D2_LOCAL) + ' - ' + Rtrim(Armazem.NNR_DESCRI) AS Armazem, 
 
			'SAIDA' as Tipo, 
 
			'S' as TipoCompacto, 
 
			'NFS' AS TipoMovimento_FK, 
			'NOTA FISCAL DE SAIDA' as TipoMovimento, 
   
 			Estoque.D2_CF AS Classificacao_FK,  
   
			'NOTA FISCAL DE SAIDA' as Classificacao, 
   
 			RTRIM(Estoque.D2_DOC) AS Documento, Estoque.D2_NUMSEQ AS Sequencia, 
 			RTRIM(Estoque.D2_COD) AS Produto_FK, Rtrim(Produto.B1_DESC) as Produto, Estoque.D2_TIPO AS ProdutoTipo, Estoque.D2_QUANT AS Quantidade, 
 			Rtrim(Estoque.D2_UM) AS Unidade, Rtrim(Estoque.D2_LOTECTL) AS Lote, 
			Case When Year(Estoque.D2_DTVALID) = 1900 then NULL else CONVERT(Datetime, Estoque.D2_DTVALID, 112) end AS DataValidade, 
 
 			Estoque.D2_IDENTB6 AS Identidade, Estoque.D2_CONTA AS ContaContabil, '' AS OrdemProducao, Estoque.D2_CUSTO1 AS Custo, Estoque.D2_CCUSTO AS CentroCusto, 
			'' AS Responsavel, Estoque.R_E_C_N_O_ AS Recno
 
 		from SD2010 Estoque (nolock) 
 		Inner Join NNR010 Armazem (Nolock) ON Armazem.NNR_FILIAL = '010101'
 														 AND Armazem.D_E_L_E_T_ <> '*'
 														 AND Armazem.NNR_CODIGO = Estoque.D2_LOCAL  
 		Inner Join SB1010 (nolock) Produto ON Produto.D_E_L_E_T_ <> '*'
 														 AND Produto.B1_FILIAL = ''
 														 AND Produto.B1_COD = Estoque.D2_COD   
 		Where Estoque.D2_FILIAL = '010101'
 		AND (Estoque.D_E_L_E_T_ <> '*')  
		
		UNION ALL 
 
 		Select 
 
 			Estoque.D1_FILIAL as Empresa, 
 			CONVERT(Datetime,Estoque.D1_DTDIGIT, 112) AS Emissao,  			
 			Rtrim(Estoque.D1_LOCAL) + ' - ' + Rtrim(Armazem.NNR_DESCRI) AS Armazem, 
 
			'ENTRADA' as Tipo, 'E' as TipoCompacto, 'NFE' AS TipoMovimento_FK, 'NOTA FISCAL DE ENTRADA' as TipoMovimento,    
 			Estoque.D1_CF AS Classificacao_FK,  'NOTA FISCAL DE ENTRADA' as Classificacao, 
   
 			RTRIM(Estoque.D1_DOC) AS Documento, Estoque.D1_NUMSEQ AS Sequencia, 
 			RTRIM(Estoque.D1_COD) AS Produto_FK, Rtrim(Produto.B1_DESC) as Produto, Estoque.D1_TIPO AS ProdutoTipo, Estoque.D1_QUANT AS Quantidade, 
 			Rtrim(Estoque.D1_UM) AS Unidade, Rtrim(Estoque.D1_LOTECTL) AS Lote, Case When Year(Estoque.D1_DTVALID) = 1900 then NULL else CONVERT(Datetime, Estoque.D1_DTVALID, 112) end AS DataValidade, 
 
 			Estoque.D1_IDENTB6 AS Identidade, Estoque.D1_CONTA AS ContaContabil, '' AS OrdemProducao, Estoque.D1_CUSTO AS Custo, Estoque.D1_CC AS CentroCusto, 
			'' AS Responsavel, Estoque.R_E_C_N_O_ AS Recno 
			 
 
 		from SD1010 Estoque (nolock) 
 		Inner Join NNR010 Armazem (Nolock) ON Armazem.NNR_FILIAL = '010101'
 														 AND Armazem.D_E_L_E_T_ <> '*'
 														 AND Armazem.NNR_CODIGO = Estoque.D1_LOCAL   		
 		Inner Join SB1010 (nolock) Produto ON Produto.D_E_L_E_T_ <> '*'
 														 AND Produto.B1_FILIAL = ''
 														 AND Produto.B1_COD = Estoque.D1_COD   
 		Where Estoque.D1_FILIAL = '010101'
 		AND (Estoque.D_E_L_E_T_ <> '*')      

		
 ) TB  
 Where 1=1  
 Order by Empresa, Armazem, Emissao desc, Produto_FK, Tipo  
 
 