
Select 
	 Isnull(Marca.Marca_ID + ' - ' + Marca,RTRIM(BM_GRUPO) + ' - ' + RTRIM(BM_DESC)) as Marca,
	 Rtrim(B8_LOCAL) + ' - ' + Rtrim(NNR_DESCRI) as Armazem, 
	 Rtrim(BM_GRUPO) + ' - ' + Rtrim(BM_DESC) AS Grupo,
	 Rtrim(B8_PRODUTO) as Produto_ID, Rtrim(B1_DESC) as Produto, B8_LOTECTL as Lote,
	 case when B1_FSDTANV = '' then 'SEM REGISTRO' else  Convert(Varchar(10),Convert(Datetime,B1_FSDTANV,112),103) end as ValidadeAnvisa,
	 case when B1_FSCANVI = '' then 'SEM REGISTRO' else B1_FSCANVI end as RegistroAnvisa,
	 B2_QATU as Saldo, B8_SALDO as SaldoLote, 
	 Convert(Varchar(10),Convert(Datetime,B8_DTVALID,112),103) as DataValidade,
	 Case when Convert(Datetime,B8_DTVALID,112) < GetDate() then 'VENCIDO' else 'OK' end StatusValidade, StatusEstoque
from SB8010	SaldoPorLote (nolock)
Inner Join SB2010	Saldo (nolock) ON B2_FILIAL = '010101'
								  AND Saldo.D_E_L_E_T_ <> '*'
								  AND B2_COD = B8_PRODUTO
								  AND B2_LOCAL = B8_LOCAL
Inner Join SB1010 Produto (nolock) ON B1_FILIAL = ''
								  AND Produto.D_E_L_E_T_ <> '*'
								  AND B1_COD = B8_PRODUTO
								  AND B1_RASTRO = 'L'
INNER JOIN SBM010 Grupo (nolock) ON BM_FILIAL = ''
							    AND Grupo.D_E_L_E_T_ <> '*' 
							    AND BM_GRUPO  = B1_GRUPO								  
Inner JOIN NNR010 Armazem ON NNR_FILIAL = '010101'
                       AND Armazem.D_E_L_E_T_ <> '*'
					   AND NNR_CODIGO  = B8_LOCAL 
Inner Join (

				Select 
					B2_COD as Produto_ID, B2_LOCAL as Armazem_ID, 
					Case when B2_QATU - SaldoPorLote = 0 then 'OK' else 'DESBALANCEADO' end as StatusEstoque  

				from SB2010 Saldo (nolock) 
				Inner Join ( 
							Select 
								B8_PRODUTO, B8_LOCAL, Sum(B8_SALDO) as SaldoPorLote 
							from SB8010 B8 (nolock)
							Where B8_FILIAL = '010101'
							AND B8.D_E_L_E_T_ <> '*'			
							Group by B8_PRODUTO, B8_LOCAL
				) as SaldoPorLote ON SaldoPorLote.B8_LOCAL = Saldo.B2_LOCAL
								 AND SaldoPorLote.B8_PRODUTO = Saldo.B2_COD
				Where B2_FILIAL = '010101'
				AND Saldo.D_E_L_E_T_ <> '*'
				AND Saldo.B2_QATU > 0

) StatusEstoque ON  StatusEstoque.Produto_ID = B2_COD
				AND StatusEstoque.Armazem_ID = B2_LOCAL
Left Join (
			Select 
				Substring(BM_GRUPO,1,2) as Marca_ID, BM_DESC as Marca 
			from SBM010 Marca (nolock)
			Where BM_FILIAL = ''
			AND Marca.D_E_L_E_T_ <> '*'
			AND Substring(BM_GRUPO,1,2) = BM_GRUPO
) Marca ON Marca.Marca_ID = Substring(Grupo.BM_GRUPO,1,2) 

Where 1=1
AND B8_FILIAL = '010101'
AND SaldoPorLote.D_E_L_E_T_ <> '*'
AND B8_SALDO <> 0

UNION ALL 

Select 
	 Isnull(Marca.Marca_ID + ' - ' + Marca,RTRIM(BM_GRUPO) + ' - ' + RTRIM(BM_DESC)) as Marca,
	 Rtrim(B2_LOCAL) + ' - ' + Rtrim(NNR_DESCRI) as Armazem, 
	 Rtrim(BM_GRUPO) + ' - ' + Rtrim(BM_DESC) AS Grupo,
	 Rtrim(B2_COD) as Produto_ID, Rtrim(B1_DESC) as Produto, '' as ValidadeAnvisa, '' as RegistroAnvisa,
	 '' as Lote, B2_QATU as Saldo, 0 as SaldoLote, 
	 '' as DataValidade, 'OK' StatusValidade, 'OK' StatusEstoque
from SB2010	Saldo (nolock)
Inner Join SB1010 Produto (nolock) ON B1_FILIAL = ''
								  AND Produto.D_E_L_E_T_ <> '*'
								  AND B1_COD = B2_COD
								  AND B1_RASTRO <> 'L'
INNER JOIN SBM010 Grupo (nolock) ON BM_FILIAL = ''
							    AND Grupo.D_E_L_E_T_ <> '*' 
							    AND BM_GRUPO  = B1_GRUPO								  
Inner JOIN NNR010 Armazem ON NNR_FILIAL = '010101'
                       AND Armazem.D_E_L_E_T_ <> '*'
					   AND NNR_CODIGO  = B2_LOCAL 	
Left Join (
			Select 
				Substring(BM_GRUPO,1,2) as Marca_ID, BM_DESC as Marca 
			from SBM010 Marca (nolock)
			Where BM_FILIAL = ''
			AND Marca.D_E_L_E_T_ <> '*'
			AND Substring(BM_GRUPO,1,2) = BM_GRUPO
) Marca ON Marca.Marca_ID = Substring(Grupo.BM_GRUPO,1,2) 

Where 1=1
AND B2_FILIAL = '010101'
AND Saldo.D_E_L_E_T_ <> '*'
AND B2_QATU <> 0

Order by Armazem, Produto