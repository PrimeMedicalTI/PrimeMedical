Select 
	BM_GRUPO + ' - ' + BM_DESC as Grupo, 
	Rtrim(B1_COD) as ID, Rtrim(B1_DESC) as Produto, 
	CASE WHEN B1_MSBLQL = 1 THEN 'SIM' ELSE 'NAO' END AS Bloqueado, B1_FSCANVI as ANVISA,
	B1_POSIPI as NCM, Rtrim(B1_GRTRIB) + ' - ' + GrupoTributario.X5_DESCRI as GrupoTributario, 
	FM_TE + ' - ' + F4_TEXTO as Tes, RTRIM(TES.F4_CF) + ' - ' + Rtrim(CFOP.X5_DESCRI) AS CFOP, 
	Rtrim(B1_ORIGEM) + ' - ' + Upper(Rtrim(Origem.X5_DESCRI)) as Origem, 
	B1_UPRC as UltimoPreco,
	Case when F4_IPI = 'S' then 'SIM' else 'NAO' end AS IPI_Incide,	
	Case when F4_CREDIPI = 'S' then 'SIM' else 'NAO' end AS IPI_Credita,	
	B1_IPI as IPI_Aliquota, 
	
	CASE 
		WHEN F4_PISCOF = '1' THEN 'INCIDE PIS' 
		WHEN F4_PISCOF = '2' THEN 'INCIDE COFINS' 
		WHEN F4_PISCOF = '3' THEN 'INCIDE PIS/COFINS' 
		WHEN F4_PISCOF = '4' THEN 'NÃO INCIDE' 
	END AS Incide_PisCofins,
	
	Case when F4_ICM = 'S' then 'SIM' else 'NAO' end AS ICMS_Incide,

	
	F4_CREDST
	
	--, Round((B1_UPRC * (B1_IPI/100)),2) as ValorIPI, Round(B1_UPRC + (B1_UPRC * (B1_IPI/100)),2) as UltimpPrecoComIPI
from SB1010 B1 (nolock)
INNER JOIN SBM010 Grupo (nolock) ON BM_FILIAL = ''
										AND Grupo.D_E_L_E_T_ <> '*'
										AND BM_GRUPO = B1_GRUPO
Inner Join SFM010 TesInteligente (nolock) ON FM_FILIAL = '0101'
										 AND TesInteligente.D_E_L_E_T_ <> '*'
										 AND FM_GRPROD = B1_GRTRIB
										 AND FM_TIPO = 'O'
Inner Join SF4010 TES (nolock) ON F4_FILIAL = ''
							 AND TES.D_E_L_E_T_ <> '*'
							 AND F4_CODIGO = FM_TE
Inner Join SX5010 CFOP (nolock) ON X5_FILIAL = ''
							AND CFOP.D_E_L_E_T_ <> '*'
							AND X5_TABELA = '13'
							AND X5_CHAVE = TES.F4_CF
Inner Join SX5010 Origem (nolock) ON Origem.X5_FILIAL = ''
									AND Origem.D_E_L_E_T_ <> '*'
									AND Origem.X5_TABELA = 'S0'
									AND Origem.X5_CHAVE = B1_ORIGEM	
Inner Join SX5010 GrupoTributario (nolock) ON GrupoTributario.X5_FILIAL = ''
										  AND GrupoTributario.D_E_L_E_T_ <> '*'
										  AND GrupoTributario.X5_TABELA = '21'
										  AND GrupoTributario.X5_CHAVE = B1_GRTRIB

where 1=1
AND B1.D_E_L_E_T_ <> '*'
AND B1_ORIGEM = 1
AND B1_COD = 'M1K7B-PA00061'