
--Select 
--	Rtrim(FM_ID) as ID, Rtrim(FM_DESCR) as TesInteligente, 
--	TesInteligente.FM_TIPO + ' - ' + Tipo.X5_DESCRI as Tipo, FM_EST as UF,
--	Rtrim(FM_GRPROD) + ' - ' + Grupo.X5_DESCRI as GrupoProduto, FM_POSIPI as NCM, 
--	FM_TS + ' - ' + F4_TEXTO as Tes, F4_TIPO as TipoTes, TesInteligente.FM_GRPROD as GrupoProduto, TesInteligente.*
	
--from SFM010 TesInteligente (nolock)
--Inner Join SF4010 TES (nolock) ON F4_FILIAL = ''
--							 AND TES.D_E_L_E_T_ <> '*'
--							 AND F4_CODIGO = FM_TS	
--Left Join SX5010 Tipo (nolock) ON Tipo.X5_FILIAL = ''
--							   AND Tipo.D_E_L_E_T_ <> '*'
--							   AND Tipo.X5_TABELA = 'DJ'
--							   AND Tipo.X5_CHAVE = TesInteligente.FM_TIPO
--Left Join SX5010 Grupo (nolock) ON Grupo.X5_FILIAL = ''
--							   AND Grupo.D_E_L_E_T_ <> '*'
--							   AND Grupo.X5_TABELA = '21'
--							   AND Grupo.X5_CHAVE = FM_GRPROD
						 
--Where 1=1
--AND FM_FILIAL = '0101'
--AND TesInteligente.D_E_L_E_T_ <> '*'
--AND TesInteligente.FM_TIPO = '01'
--AND FM_GRPROD = '008'

--UNION ALL

Select 
	FM_FILIAL,
	Rtrim(FM_ID) as ID, Rtrim(FM_DESCR) as TesInteligente, 
	TesInteligente.FM_TIPO + ' - ' + Tipo.X5_DESCRI as Tipo, FM_EST as UF,
	Rtrim(FM_GRPROD) + ' - ' + Grupo.X5_DESCRI as GrupoProduto, FM_POSIPI as NCM, 
	FM_TE + ' - ' + F4_TEXTO as Tes, F4_TIPO as TipoTes, TesInteligente.FM_GRPROD as GrupoProduto, F4_CREDST
	
from SFM010 TesInteligente (nolock)
Inner Join SF4010 TES (nolock) ON F4_FILIAL = ''
							 AND TES.D_E_L_E_T_ <> '*'
							 AND F4_CODIGO = FM_TE	
Left Join SX5010 Tipo (nolock) ON Tipo.X5_FILIAL = ''
							   AND Tipo.D_E_L_E_T_ <> '*'
							   AND Tipo.X5_TABELA = 'DJ'
							   AND Tipo.X5_CHAVE = TesInteligente.FM_TIPO
Left Join SX5010 Grupo (nolock) ON Grupo.X5_FILIAL = ''
							   AND Grupo.D_E_L_E_T_ <> '*'
							   AND Grupo.X5_TABELA = '21'
							   AND Grupo.X5_CHAVE = FM_GRPROD
						 
Where 1=1
AND FM_FILIAL = '0101'
AND TesInteligente.D_E_L_E_T_ <> '*'	
AND TesInteligente.FM_TIPO in ('51','O')

Order by Tipo, TesInteligente

--Select D1_MARGEM, * from SD1010 where D1_TES = '011'


--Select Distinct D1_TES from SD1010 where D1_MARGEM > 0 AND D1_TIPO = 'N'
