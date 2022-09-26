Select 
	Year(F2_EMISSAO) as Ano,
	Case 
		When Month(F2_EMISSAO) = 1 then '01 - JANEIRO' 
		When Month(F2_EMISSAO) = 2 then '02 - FEVEREIRO' 
		When Month(F2_EMISSAO) = 3 then '03 - MARÇO' 
		When Month(F2_EMISSAO) = 4 then '04 - ABRIL' 
		When Month(F2_EMISSAO) = 5 then '05 - MAIO' 
		When Month(F2_EMISSAO) = 6 then '06 - JUNHO' 
		When Month(F2_EMISSAO) = 7 then '07 - JULHO' 
		When Month(F2_EMISSAO) = 8 then '08 - AGOSTO' 
		When Month(F2_EMISSAO) = 9 then '09 - SETEMBRO' 
		When Month(F2_EMISSAO) = 10 then '10 - OUTUBRO' 
		When Month(F2_EMISSAO) = 11 then '11 - NOVEMBRO' 
		When Month(F2_EMISSAO) = 12 then '12 - DEZEMBRO' 
	End as Mes,	
  SD2.R_E_C_N_O_ as Recno, Fornecedor, A1_COD as Cliente_ID, A1_LOJA as Loja, A1_NOME as Cliente, A1_END as Endereco, 
  A1_MUN as Cidade, A1_CEP as CEP, A1_EST as UF, A1_BAIRRO as Bairro, A1_TEL as Telefone, 
  A1_EMAIL as Email, A1_PESSOA as Pessoa, A1_CGC as CNPJ, 
  Substring(D2_EMISSAO,1, 6) as SubmissionMth, D2_DOC as SalesDocNo, D2_EMISSAO as SalesDocDate, 
  '' as SellCode, '' as SellName, Case when A1_XMTRONI = '' then A1_CGC else A1_XMTRONI end as EndCustomerCode, A1_NOME as EndCustomerName, 
  ID as ProductCode,  Lote as LotSerial, UOM, D2_QUANT as Quantity, '' as NA, '' as NA2, '' as Comments, '' as SalesOutType  

FROM SF2010 SF2  (nolock)
INNER JOIN SA1010 (nolock) SA1 ON A1_FILIAL = ''
							  AND SA1.D_E_L_E_T_ <> '*' 
							  AND A1_COD = F2_CLIENTE 
							  AND A1_LOJA = F2_LOJA							  
INNER JOIN SD2010  SD2 (nolock) ON D2_FILIAL = '010101'
							   AND SD2.D_E_L_E_T_ <> '*' 
							   AND D2_DOC = F2_DOC
							   AND D2_SERIE = F2_SERIE
							   AND D2_TIPO = F2_TIPO
							   AND D2_CLIENTE = F2_CLIENTE
							   AND D2_LOJA = F2_LOJA
Inner Join 
 (

		Select 
		  'AUTO SUTURE' as Fornecedor, B1_GRUPO as Grupo_ID, BM_DESC as Grupo, D1_COD as ID,  B1_DESC as Produto, 
		  D1_LOTECTL as Lote, D1_DTVALID as DTValidade, 
		  Case when B1_UM = 'UN' then 'EA' else B1_UM end as UOM
		from SD1010 NotaEntrada (nolock)
		INNER JOIN SB1010 SB1 (nolock) ON B1_FILIAL = ''
									 AND SB1.D_E_L_E_T_ <> '*'
									 AND B1_COD = D1_COD 
		INNER JOIN SBM010 (nolock) SBM ON BM_FILIAL = ''
									  AND SBM.D_E_L_E_T_ <> '*' 
									  AND SBM.BM_GRUPO = B1_GRUPO 	
		Where 1=1 
		AND D1_FORNECE = '01645409' 
		AND D1_LOJA = '0390'

		UNION ALL 

		Select 
		  'MEDTRONIC' as Fornecedor, B1_GRUPO as Grupo_ID, BM_DESC as Grupo, D1_COD as ID,  B1_DESC as Produto, 
		  D1_LOTECTL as Lote, D1_DTVALID as DTValidade, 
		  Case when B1_UM = 'UN' then 'EA' else B1_UM end as UOM
		from SD1010 NotaEntrada (nolock)
		INNER JOIN SB1010 SB1 (nolock) ON B1_FILIAL = ''
									 AND SB1.D_E_L_E_T_ <> '*'
									 AND B1_COD = D1_COD 
		INNER JOIN SBM010 (nolock) SBM ON BM_FILIAL = ''
									  AND SBM.D_E_L_E_T_ <> '*' 
									  AND SBM.BM_GRUPO = B1_GRUPO 	
		Where 1=1 
		AND D1_FORNECE = '01772798' 
		AND D1_LOJA = '0667'

) ProdutoMedtronic ON ProdutoMedtronic.ID = D2_COD
				  AND ProdutoMedtronic.Lote = D2_LOTECTL
				  
Where 1=1
AND F2_FILIAL = '010101'
AND SF2.D_E_L_E_T_ <> '*'
AND F2_TIPO = 'N'
Order by SD2.R_E_C_N_O_ desc 				