Select 

	Produto.R_E_C_N_O_ as Recno, Rtrim(BM_GRUPO) + ' - ' + Rtrim(BM_DESC) AS Grupo, B1_COD as Codigo, B1_DESC as Produto, 
	Case when B1_RASTRO = 'L' then 'SIM' else 'NÃO' end as Rastro, 
	B1_FSCANVI as Anvisa, B1_LOCPAD as ArmPadrao,
	Case 
		When B1_TIPO = 'AI' then 'AI - ATIVO IMOBILIZADO' 
		When B1_TIPO = 'BN' then 'BN - BENEFICIAMENTO' 
		When B1_TIPO =' EM' then 'EM - EMBALAGEM' 
		When B1_TIPO = 'GE' then 'GE - GARANTIA ESTENDIDA' 
		When B1_TIPO = 'GG' then 'GG - GASTOS GERAIS' 
		When B1_TIPO = 'GN' then 'GN - GENERICO' 
		When B1_TIPO = 'IA' then 'IA - INSUMO AGRICOLA' 
		When B1_TIPO = 'II' then 'II - INSUMO INDUSTRIAIS' 
		When B1_TIPO = 'IN' then 'IN - PRODUTOS INDUSTRIAIS' 
		When B1_TIPO = 'KT' then 'KT - KIT' 
		When B1_TIPO = 'MC' then 'MC - MATERIAL DE CONSUMO' 
		When B1_TIPO = 'ME' then 'ME - MERCADORIA' 
		When B1_TIPO = 'MM' then 'MM - MATERIAIS MANFRO' 
		When B1_TIPO = 'MO' then 'MO - MAO DE OBRA' 
		When B1_TIPO = 'MP' then 'MP - MATERIA PRIMA'
		When B1_TIPO = 'OI' then 'OI - OUTROS INSUMOS' 
		When B1_TIPO = 'PA' then 'PA - PRODUTO ACABADO' 
		When B1_TIPO = 'PI' then 'PI - PRODUTO INTERMEDIARIO' 
		When B1_TIPO = 'PP' then 'PP - PRODUTO EM PROCESSO'
		When B1_TIPO = 'PV' then 'PV - PRODUTO VEICULO' 
		When B1_TIPO = 'SL' then 'SL - SELO DE CONTROLE'
		When B1_TIPO = 'SM' then 'SM - SEMENTES' 
		When B1_TIPO = 'SP' then 'SP - SUBPRODUTO'
		When B1_TIPO = 'SV' then 'SV - SERVIÇO'
	End  as TipoProduto,
	
	Case when B1_FSCANVI = '' then '' else Convert(Varchar(10),Convert(Datetime,B1_FSDTANV,112),103) end as DataAnvisa,
	
	Case when B1_FSCANVI = '' then 0 else  
		Case when DATEDIFF(Day,GetDate(),B1_FSDTANV) > 0 then DATEDIFF(Day,GetDate(),B1_FSDTANV) else 0 end 
	end as TempoAnvisa,

	Case when B1_FSCANVI = '' then 'SEM ANVISA' else  
		Case when DATEDIFF(Day,GetDate(),B1_FSDTANV) > 0 then 'VALIDO' else 'VENCIDO' end 
	end as ValidadeAnvisa,

	B1_IPI as IPI, B1_POSIPI as NCM, Rtrim(Origem.X5_CHAVE) + ' - ' + Upper(Origem.X5_DESCRI) as Origem, 
	Isnull(Rtrim(GrpTributacao.X5_CHAVE) + ' - ' + Upper(GrpTributacao.X5_DESCRI),'') as GrpTributacao, 
	B1_GRPTI as GrupoTES,
	B1_CONTAC as ContaCusto,
	B1_CONTA as CtaContabil,
	Case when B1_MSBLQL = 1 then 'SIM' else 'NÃO' end as Bloqueado
	
from SB1010 Produto (nolock)
Inner Join SBM010 Grupo (nolock) ON BM_FILIAL = ''
								AND Grupo.D_E_L_E_T_ <> '*' 
								AND Grupo.BM_GRUPO = B1_GRUPO
Left Join SX5010 Origem (nolock) ON Origem.X5_FILIAL = ''
								AND Origem.D_E_L_E_T_ <> '*'
								AND Origem.X5_TABELA = 'S0'
								AND Origem.X5_CHAVE = B1_ORIGEM
Left Join SX5010 GrpTributacao ON GrpTributacao.X5_FILIAL = ''
							   AND GrpTributacao.D_E_L_E_T_ <> '*' 
							   AND GrpTributacao.X5_TABELA = '21'
						   	   AND GrpTributacao.X5_CHAVE = B1_GRTRIB
								
Where 1=1
AND B1_FILIAL = ''
AND Produto.D_E_L_E_T_ <> '*' 
Order by B1_GRUPO, B1_COD