Select 
       'FORNECEDOR' as Tipo,
       FT_NFISCAN,
       FT_NFISCAL as 'Doc. Fiscal', RTRIM(FT_CLIEFOR) + ' - ' + RTRIM(A2_LOJA) as 'ClientFornID', A2_NOME as 'ClientForn',
       FT_SERIE as 'Série NF',
       Case when FT_TIPOMOV = 'E' then 'ENTRADA' else 'SAIDA' end as 'Tipo Movimento', 


       FT_NFORI  as 'NF Original', 
       FT_SERORI as 'Serie NF Ori',
       FT_ITEMORI as 'Item NF Orig',
       
       Convert(Datetime,FT_ENTRADA,112)  as 'Data Entrada',
       Convert(Datetime,FT_EMISSAO,112) as 'Data Emissão', 
       Year(FT_EMISSAO) as AnoEmissao,
	    Case 
                When Month(FT_EMISSAO) = 1 then '01 - JANEIRO' 
                When Month(FT_EMISSAO) = 2 then '02 - FEVEREIRO' 
                When Month(FT_EMISSAO) = 3 then '03 - MARÇO' 
                When Month(FT_EMISSAO) = 4 then '04 - ABRIL' 
                When Month(FT_EMISSAO) = 5 then '05 - MAIO' 
                When Month(FT_EMISSAO) = 6 then '06 - JUNHO' 
                When Month(FT_EMISSAO) = 7 then '07 - JULHO' 
                When Month(FT_EMISSAO) = 8 then '08 - AGOSTO' 
                When Month(FT_EMISSAO) = 9 then '09 - SETEMBRO' 
                When Month(FT_EMISSAO) = 10 then '10 - OUTUBRO' 
                When Month(FT_EMISSAO) = 11 then '11 - NOVEMBRO' 
                When Month(FT_EMISSAO) = 12 then '12 - DEZEMBRO' 
	    End as MesEmissao,
  
       FT_CFOP as 'Cod. Fiscal', FT_ALIQICM as 'Alíq. ICMS',  

       FT_VALCONT as 'Vlr Contábil', FT_BASEICM as 'Base ICMS',FT_VALICM as 'Valor ICMS', FT_ISENICM as 'Vlr Isen ICM',FT_OUTRICM as 'Vlr Out ICMS', FT_BASEIPI as 'Vlr Base IPI', 
       FT_VALIPI as 'Valor IPI',FT_ISENIPI as 'Vlr Isen IPI',FT_OUTRIPI as 'Vlr Outr IPI',FT_BASERET as 'Vlr Base Ret', FT_ESTADO as 'Estado Ref',FT_DIFAL as 'Difal ICMS',  
       FT_ALQFECP as 'Aliq FECP',FT_VALFECP as 'Valor FECP',FT_ICMSRET as 'Vlr ICMS Ret',FT_OBSERV as 'Obs Liv. Fis', FT_TIPO as 'Tipo Lanc', FT_ICMSCOM as 'Vlr ICMS Com',
       FT_IPIOBS as 'Vlr IPI Obs', FT_DTCANC as 'Data Cancel',FT_ESPECIE as 'Espécie NF', FT_CREDST as 'Crd/Deb ST',FT_CONTA as 'Conta Contáb',FT_PRODUTO as 'Cod. Produto', 
       FT_ITEM as 'Código Item',FT_ALIQIPI as 'Alíq IPI',FT_FORMUL as 'Form.Próprio',FT_CLASFIS as 'Sit.Tribut.',FT_CTIPI as 'Trib. IPI',FT_FRETE as 'Valor Frete',FT_SEGURO as 'Vlr Seguro',  
       FT_DESPESA as 'Vlr Despesas',FT_POSIPI as 'Cod. NCM',FT_QUANT as 'Quantidade',FT_PRCUNIT as 'Precio Unit.',FT_DESCONT as 'Vlr Desconto',FT_TOTAL  as 'Vlr Total',FT_BASEPIS as 'Base PIS',    
       FT_ALIQPIS as 'Aliq. PIS',FT_VALPIS as 'Valor PIS',FT_BASECOF as 'Base COFINS',FT_ALIQCOF as 'Aliq. COFINS',FT_VALCOF as 'Valor COFINS',FT_NFELETR as 'NF Eletr.',   
       FT_CHVNFE as 'Chave Nfe',FT_CSTPIS as 'CST Pis',FT_CSTCOF as 'CST COF',FT_CODBCC as 'Cod.BC Cred.',FT_INDNTFR as 'Ind.Nat.Fret',FT_CPPRODE as 'Crd.PRODEPE', 
       FT_TPPRODE as 'Tipo PRODEPE',FT_CSTISS as 'Sit.Trib.ISS',FT_TNATREC as 'Tabela Nat. da Receita',FT_NATOPER as 'Natureza da Operacao',FT_TES as 'Tipo E/S', 
       FT_PICEFET as '% ICMS Efet',FT_PDDES as 'Perc. Destin',FT_PDORI as 'Perc. Origem',FT_VICEFET as 'ICMS Eeftivo',FT_BICEFET as 'BC ICMS Efet',FT_BASEDES as 'Base. Destin',
       FT_DIFAL as 'Difal ICMS',FT_BSICMOR as 'BS.ICMS Ori.' 

from SFT010 FT (nolock)
inner join SA2010 Fornecedor on A2_FILIAL = ''
							AND Fornecedor.D_E_L_E_T_ <> '*'
							AND	A2_COD = FT_CLIEFOR
Where FT_FILIAL = '010101'
AND FT.D_E_L_E_T_ <> '*' 
--AND FT_EMISSAO between '20220501' AND '20220509' 
--Order by FT.FT_EMISSAO desc, FT.FT_NFISCAL desc
AND CONVERT(DATE,FT_EMISSAO,112) between :DATAINICIAL AND :DATAFIM

UNION ALL

Select 
	'CLIENTE' as Tipo,	
       FT_NFISCAN,
       FT_NFISCAL as 'Doc. Fiscal', RTRIM(FT_CLIEFOR) + ' - ' + RTRIM(A1_LOJA) as 'ClientFornID', A1_NOME as 'ClientForn',
       FT_SERIE as 'Série NF',
       Case when FT_TIPOMOV = 'E' then 'ENTRADA' else 'SAIDA' end as 'Tipo Movimento', 


       FT_NFORI  as 'NF Original', 
       FT_SERORI as 'Serie NF Ori',
       FT_ITEMORI as 'Item NF Orig',
       
       Convert(Datetime,FT_ENTRADA,112)  as 'Data Entrada',
       Convert(Datetime,FT_EMISSAO,112) as 'Data Emissão', 
	   Year(FT_EMISSAO) as AnoEmissao,
	    Case 
                When Month(FT_EMISSAO) = 1 then '01 - JANEIRO' 
                When Month(FT_EMISSAO) = 2 then '02 - FEVEREIRO' 
                When Month(FT_EMISSAO) = 3 then '03 - MARÇO' 
                When Month(FT_EMISSAO) = 4 then '04 - ABRIL' 
                When Month(FT_EMISSAO) = 5 then '05 - MAIO' 
                When Month(FT_EMISSAO) = 6 then '06 - JUNHO' 
                When Month(FT_EMISSAO) = 7 then '07 - JULHO' 
                When Month(FT_EMISSAO) = 8 then '08 - AGOSTO' 
                When Month(FT_EMISSAO) = 9 then '09 - SETEMBRO' 
                When Month(FT_EMISSAO) = 10 then '10 - OUTUBRO' 
                When Month(FT_EMISSAO) = 11 then '11 - NOVEMBRO' 
                When Month(FT_EMISSAO) = 12 then '12 - DEZEMBRO' 
	    End as MesEmissao,
  
       FT_VALCONT as 'Vlr Contábil', FT_BASEICM as 'Base ICMS',FT_VALICM as 'Valor ICMS', FT_ISENICM as 'Vlr Isen ICM',FT_OUTRICM as 'Vlr Out ICMS', FT_BASEIPI as 'Vlr Base IPI', 
       FT_VALIPI as 'Valor IPI',FT_ISENIPI as 'Vlr Isen IPI',FT_OUTRIPI as 'Vlr Outr IPI',FT_BASERET as 'Vlr Base Ret', FT_ESTADO as 'Estado Ref',FT_DIFAL as 'Difal ICMS',  
       FT_ALQFECP as 'Aliq FECP',FT_VALFECP as 'Valor FECP',FT_ICMSRET as 'Vlr ICMS Ret',FT_OBSERV as 'Obs Liv. Fis', FT_TIPO as 'Tipo Lanc', FT_ICMSCOM as 'Vlr ICMS Com',
       FT_IPIOBS as 'Vlr IPI Obs', FT_DTCANC as 'Data Cancel',FT_ESPECIE as 'Espécie NF', FT_CREDST as 'Crd/Deb ST',FT_CONTA as 'Conta Contáb',FT_PRODUTO as 'Cod. Produto', 
       FT_ITEM as 'Código Item',FT_ALIQIPI as 'Alíq IPI',FT_FORMUL as 'Form.Próprio',FT_CLASFIS as 'Sit.Tribut.',FT_CTIPI as 'Trib. IPI',FT_FRETE as 'Valor Frete',FT_SEGURO as 'Vlr Seguro',  
       FT_DESPESA as 'Vlr Despesas',FT_POSIPI as 'Cod. NCM',FT_QUANT as 'Quantidade',FT_PRCUNIT as 'Precio Unit.',FT_DESCONT as 'Vlr Desconto',FT_TOTAL  as 'Vlr Total',FT_BASEPIS as 'Base PIS',    
       FT_ALIQPIS as 'Aliq. PIS',FT_VALPIS as 'Valor PIS',FT_BASECOF as 'Base COFINS',FT_ALIQCOF as 'Aliq. COFINS',FT_VALCOF as 'Valor COFINS',FT_NFELETR as 'NF Eletr.',   
       FT_CHVNFE as 'Chave Nfe',FT_CSTPIS as 'CST Pis',FT_CSTCOF as 'CST COF',FT_CODBCC as 'Cod.BC Cred.',FT_INDNTFR as 'Ind.Nat.Fret',FT_CPPRODE as 'Crd.PRODEPE', 
       FT_TPPRODE as 'Tipo PRODEPE',FT_CSTISS as 'Sit.Trib.ISS',FT_TNATREC as 'Tabela Nat. da Receita',FT_NATOPER as 'Natureza da Operacao',FT_TES as 'Tipo E/S', 
       FT_PICEFET as '% ICMS Efet',FT_PDDES as 'Perc. Destin',FT_PDORI as 'Perc. Origem',FT_VICEFET as 'ICMS Eeftivo',FT_BICEFET as 'BC ICMS Efet',FT_BASEDES as 'Base. Destin',
       FT_DIFAL as 'Difal ICMS',FT_BSICMOR as 'BS.ICMS Ori.' 

from SFT010 FT (nolock)
inner join SA1010 Cliente on A1_FILIAL = ''
							AND Cliente.D_E_L_E_T_ <> '*'
							AND	A1_COD = FT_CLIEFOR
Where FT_FILIAL = '010101'
AND FT.D_E_L_E_T_ <> '*'
--AND FT_EMISSAO between '20220501' AND '20220509' 
--Order by FT.FT_EMISSAO desc, FT.FT_NFISCAL desc
AND CONVERT(DATE,FT_EMISSAO,112) between :DATAINICIAL AND :DATAFIM