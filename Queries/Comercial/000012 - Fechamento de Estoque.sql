Select
	Isnull(Marca.Marca_ID + ' - ' + Marca,RTRIM(BM_GRUPO) + ' - ' + RTRIM(BM_DESC)) as Marca,
	RTRIM(BM_GRUPO) + ' - ' + RTRIM(BM_DESC)  as Grupo, B9_LOCAL as Armazem,
	B1_COD as Produto_ID, B1_DESC as Produto, 
	Convert(Varchar(10),Convert(Datetime,B9_DATA ,112),103)as DataEstoque, B9_QINI as Saldo,
	Year(B9_DATA) as Ano,
	Case 
		When Month(B9_DATA) = 1 then '01 - JANEIRO' 
		When Month(B9_DATA) = 2 then '02 - FEVEREIRO' 
		When Month(B9_DATA) = 3 then '03 - MARÇO' 
		When Month(B9_DATA) = 4 then '04 - ABRIL' 
		When Month(B9_DATA) = 5 then '05 - MAIO' 
		When Month(B9_DATA) = 6 then '06 - JUNHO' 
		When Month(B9_DATA) = 7 then '07 - JULHO' 
		When Month(B9_DATA) = 8 then '08 - AGOSTO' 
		When Month(B9_DATA) = 9 then '09 - SETEMBRO' 
		When Month(B9_DATA) = 10 then '10 - OUTUBRO' 
		When Month(B9_DATA) = 11 then '11 - NOVEMBRO' 
		When Month(B9_DATA) = 12 then '12 - DEZEMBRO' 
	End as Mes 
from SB1010 Produto  (nolock)
INNER JOIN SB9010 Saldo (nolock) ON B9_FILIAL = '010101'
									AND Saldo.D_E_L_E_T_ <> '*'
									AND B9_COD = B1_COD 
INNER JOIN SBM010 Grupo (nolock) ON   BM_FILIAL = ''
									  AND Grupo.D_E_L_E_T_ <> '*'
									  AND BM_GRUPO = B1_GRUPO

Left Join (
			Select 
				Substring(BM_GRUPO,1,2) as Marca_ID, BM_DESC as Marca 
			from SBM010 Marca (nolock)
			Where BM_FILIAL = ''
			AND Marca.D_E_L_E_T_ <> '*'
			AND Substring(BM_GRUPO,1,2) = BM_GRUPO
) Marca ON Marca.Marca_ID = Substring(Grupo.BM_GRUPO,1,2) 
WHERE 1=1
AND B1_FILIAL = ''
AND Produto.D_E_L_E_T_ <> '*'
--AND BM_GRUPO BETWEEN '01' AND '0112' 
ORDER BY Convert(Datetime,B9_DATA ,112) Desc, Grupo