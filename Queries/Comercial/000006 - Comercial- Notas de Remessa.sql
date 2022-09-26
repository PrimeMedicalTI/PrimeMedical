Select 
	
     Item.R_E_C_N_O_ as Recno,  RTRIM(NNR_DESCRI) + ' (' + D2_LOCAL + ')' as Armazem, 
	 RTRIM(B6_CLIFOR) + ' - ' + Rtrim(B6_LOJA) as Cliente_ID,  Rtrim(A1_NOME) as Cliente,
	 RTRIM(A1_MUN) as Cidade, A1_EST as UF,	 
	 D2_DOC as Nota, D2_TES as TES_ID, F4_TEXTO as TES, D2_TIPO as Tipo,
	 Convert(Varchar(10),Convert(Datetime,D2_EMISSAO,112),103) as Emissao, Rtrim(B1_GRUPO) + ' - ' + BM_DESC as Grupo,
	 Rtrim(D2_COD) as Produto_ID, D2_ITEM as Item, Produto.B1_DESC as Produto, D2_LOTECTL as Lote, Convert(Varchar(10),Convert(Datetime,D2_DTVALID,112),103)  as DataValidade,       
	 B1_UM as UndMedida, B6_QUANT as Qtd, B6_QUANT - B6_SALDO as QtdAtentida, B6_SALDO as Saldo, B6_PRUNIT as ValorUnitario, 
	 D2_TOTAL as Custo, (B6_QUANT - B6_SALDO) * B6_PRUNIT as CustoAtentida, 
	 Case when B6_ATEND = 'S' then 'FINALIZADO' else 'EM ABERTO' end as Status,
	 F2_PACIENT as Paciente, Case when F2_FSCCONV = '' then '' else F2_FSCCONV + ' - ' + F2_CONVENI end as Convenio, 
	 Case when F2_DTPROCE <> '' then Convert(Varchar(10),Convert(Datetime,F2_DTPROCE,112),103) else '' end as DtProcedimento, 
	 F2_FSNOME AS Usuario	 	 
	 
FROM SF2010 Nota  (nolock)				  
INNER JOIN SD2010 Item (nolock) ON D2_FILIAL = '010101'
							   AND Item.D_E_L_E_T_ <> '*' 
							   AND D2_DOC = F2_DOC
							   AND D2_SERIE = F2_SERIE
							   AND D2_TIPO = F2_TIPO
							   AND D2_CLIENTE = F2_CLIENTE
							   AND D2_LOJA = F2_LOJA
Inner Join SB1010 (nolock) Produto ON B1_FILIAL = ''
								  AND Produto.D_E_L_E_T_ <> '*'
								  AND Produto.B1_COD = D2_COD
Inner Join SBM010 Grupo (nolock) ON BM_FILIAL = ''
							 AND Grupo.D_E_L_E_T_ <> '*'
							 AND BM_GRUPO = B1_GRUPO								  
Inner Join NNR010 Armazem (nolock)  ON NNR_FILIAL = '010101'
								  AND Armazem.D_E_L_E_T_ <> '*'	
								  AND NNR_CODIGO = D2_LOCAL	
INNER JOIN SF4010 F4 (nolock) ON F4_FILIAL = ''
							  AND F4.D_E_L_E_T_ <> '*'
							  AND F4_CODIGO = D2_TES
							  AND F4_PODER3 = 'R'
Inner Join SB6010 PoderTerceiros (nolock) ON B6_FILIAL = '010101'
										 AND PoderTerceiros.D_E_L_E_T_ <> '*'
										 AND B6_PRODUTO = D2_COD 
										 AND B6_IDENT = D2_IDENTB6
                                         AND B6_PODER3 = 'R'
Inner Join SA1010 (nolock) Cliente ON A1_FILIAL = ''
							      AND Cliente.D_E_L_E_T_ <> '*' 
								  AND A1_COD = B6_CLIFOR 
								  AND A1_LOJA = B6_LOJA	

Where F2_FILIAL = '010101'
AND Nota.D_E_L_E_T_ <> '*' 
AND F2_TIPO = 'N'
AND CONVERT(DATE,F2_EMISSAO,112) between :DATAINICIAL AND :DATAFIM

UNION ALL

Select 
	
     Item.R_E_C_N_O_ as Recno,  RTRIM(NNR_DESCRI) + ' (' + D2_LOCAL + ')' as Armazem, 
	 RTRIM(F2_CLIENTE) + ' - ' + Rtrim(F2_LOJA) as Cliente_ID,  Rtrim(A1_NOME) as Cliente,
	 RTRIM(A1_MUN) as Cidade, A1_EST as UF,	 
	 D2_DOC as Nota, D2_TES as TES_ID, F4_TEXTO as TES, D2_TIPO as Tipo,
	 Convert(Varchar(10),Convert(Datetime,D2_EMISSAO,112),103) as Emissao, Rtrim(B1_GRUPO) + ' - ' + BM_DESC as Grupo,
	  Rtrim(D2_COD) as Produto_ID, D2_ITEM as Item, Produto.B1_DESC as Produto, D2_LOTECTL as Lote, Convert(Varchar(10),Convert(Datetime,D2_DTVALID,112),103)  as DataValidade,       
	 B1_UM as UndMedida, D2_QUANT as Qtd, D2_QUANT as QtdAtentida, D2_QUANT as Saldo, D2_PRUNIT as ValorUnitario, 
	 D2_TOTAL as Custo, D2_TOTAL as CustoAtentida, 
	 'FINALIZADO' as Status,
	 F2_PACIENT as Paciente, Case when F2_FSCCONV = '' then '' else F2_FSCCONV + ' - ' + F2_CONVENI end as Convenio, 
	 Case when F2_DTPROCE <> '' then Convert(Varchar(10),Convert(Datetime,F2_DTPROCE,112),103) else '' end as DataProcedimento, 
	 F2_FSNOME AS Usuario	 	 
	 
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
Inner Join SB1010 (nolock) Produto ON B1_FILIAL = ''
								  AND Produto.D_E_L_E_T_ <> '*'
								  AND Produto.B1_COD = D2_COD
Inner Join SBM010 Grupo (nolock) ON BM_FILIAL = ''
							 AND Grupo.D_E_L_E_T_ <> '*'
							 AND BM_GRUPO = B1_GRUPO								  
Inner Join NNR010 Armazem (nolock)  ON NNR_FILIAL = '010101'
								  AND Armazem.D_E_L_E_T_ <> '*'	
								  AND NNR_CODIGO = D2_LOCAL	
INNER JOIN SF4010 TES (nolock) ON F4_FILIAL = ''
							  AND TES.D_E_L_E_T_ <> '*'
							  AND F4_CODIGO = D2_TES
							  AND F4_PODER3 =  'N'
Inner Join SX5010 CFOP ON X5_FILIAL = ''
					  AND CFOP.D_E_L_E_T_ <> '*'
					  AND X5_TABELA = '13'
					  AND X5_DESCRI like 'REMESSA%'
					  AND X5_CHAVE = F4_CF

Where F2_FILIAL = '010101'
AND Nota.D_E_L_E_T_ <> '*' 
AND F2_TIPO = 'N'
AND CONVERT(DATE,F2_EMISSAO,112) between :DATAINICIAL AND :DATAFIM

Order by Emissao desc, Nota, Item