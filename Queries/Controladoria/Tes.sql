
-- SYD010 - NCM

Select 
	F4_CODIGO, F4_TEXTO, CFOP, CFOP_Tipo, CFOP_Local, 
	Case when F4_IPI = 'S' then 'SIM' else 'NAO' end AS Incide_IPI
from SF4010 TES (nolock)
Inner Join (


				Select 
					X5_FILIAL, X5_CHAVE, Rtrim(X5_CHAVE) + ' - ' + X5_DESCRI as CFOP, SUBSTRING(X5_CHAVE,1,1) as CFOP_Classe,
					Case 
						when SUBSTRING(X5_CHAVE,1,1) in (1,2,3) then 'ENTRADA'
					Else 'SAIDA' end as CFOP_Tipo,

					Case 
						when SUBSTRING(X5_CHAVE,1,1) in (1,5) then 'DENTRO DO ESTADO'
						when SUBSTRING(X5_CHAVE,1,1) in (2,6) then 'FORA DO ESTADO'
						when SUBSTRING(X5_CHAVE,1,1) in (3,7) then 'EXTERIOR'
					end as CFOP_Local

				from SX5010 CFOP (nolock) 
				Where CFOP.D_E_L_E_T_ <> '*'
				AND CFOP.X5_TABELA = '13'
				AND X5_CHAVE not in ('000','999','99943')

) CFOP ON CFOP.X5_FILIAL = ''
	  AND CFOP.X5_CHAVE = F4_CF
Where F4_FILIAL <> '*'
AND TES.D_E_L_E_T_ <> '*'
Order by CFOP