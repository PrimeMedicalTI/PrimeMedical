SELECT DISTINCT
	
  		Case 
            when C5_LIBEROK  = '' AND C5_NOTA = '' AND C5_BLQ = '' then 'EM ABERTO' 
            when C5_LIBEROK = 'S' AND C5_NOTA = '' AND C5_BLQ = '' then 'LIBERADO'  
            When C5_NOTA <> '' AND C5_BLQ = '' then 'ENCERRADO'  
            When C5_BLQ = '1' then 'BLOQ. REGRA' 
            When C5_BLQ = '2' then 'BLOQ. VERBA' 
        END as Status,	
	
	C9.R_E_C_N_O_ as Recno, C9_PEDIDO as Pedido, C6_ITEM as Item,C5_EMISSAO as Emissao, C9_NFISCAL as NotaFiscal, C9_DATALIB as DataLiberacao,
	C9_CLIENTE as Cliente_ID, C9_LOJA as Loja,  A1_NOME as Cliente, A1_EST as Estado, A1_MUN as Municipio, C9_PRODUTO as Produto_ID, B1_DESC as Produto, B1_GRUPO as Grupo_ID, BM_DESC as Grupo,
	C6_LOTECTL as Lote, C6_DTVALID as Datavalidade, C6_QTDVEN as QtdVendida, C9_QTDLIB AS QtdLiberada, C6_UM as UM, C6_LOCAL as Armazem, 
	C6_PRCVEN as PrecoVenda, C9_BLEST as BloqueioEstoque, C9_BLCRED as BloqueioCredito, 
	C6_TES as TES_ID, F4_TEXTO as TES, C9_FSNOME as NomeUsuario

FROM SC9010 (nolock) C9
INNER JOIN SA1010 (nolock) A1 ON  A1_FILIAL = ''
							  AND A1.D_E_L_E_T_ <> '*'
							  AND A1_COD = C9_CLIENTE  
							  AND A1_LOJA = C9_LOJA 
INNER JOIN SC5010 (nolock) C5 ON C5_FILIAL = '010101'
							  AND C5.D_E_L_E_T_ <> '*'
							  AND C5_NUM = C9_PEDIDO 
INNER JOIN SC6010 (nolock) C6 ON C6_FILIAL = '010101'
							  AND C6.D_E_L_E_T_ <> '*'
							  AND C6_FILIAL = C5_FILIAL
							  AND C6_NUM = C9_PEDIDO
							  AND C6_ITEM = C9_ITEM
INNER JOIN SB1010 (nolock) B1 ON B1_FILIAL = ''
							  AND B1.D_E_L_E_T_ <> '*'
							  AND B1_COD = C9_PRODUTO	
INNER JOIN SBM010 (nolock) BM ON BM_FILIAL = ''
							  AND BM.D_E_L_E_T_ <> '*'
							  AND BM_GRUPO = B1_GRUPO					  
INNER JOIN SF4010 (nolock) F4 ON F4_FILIAL = ''
							  AND F4.D_E_L_E_T_ <> '*'
							  AND F4_CODIGO = C6_TES
Where 1=1
AND C9_FILIAL = '010101'							  
AND C9.D_E_L_E_T_ <> '*'
AND C9_NFISCAL = ''
Order by C9.R_E_C_N_O_ desc