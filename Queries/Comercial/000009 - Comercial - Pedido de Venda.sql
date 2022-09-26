/*
 Criado por: Rosiclei
 Data: 30/03/2022
 Objetivo: Criação de Cubo no RM para atender o setor do Comercial 
 Solicitantes: Naiara, Renata e Jean 
*/
	
SELECT 
        C5_NUM as Pedido, C5_FSPEDCL as PedidoCliente,

        Case 
            when C5_LIBEROK  = '' AND C5_NOTA = '' AND C5_BLQ = '' then 'EM ABERTO' 
            when C5_LIBEROK = 'S' AND C5_NOTA = '' AND C5_BLQ = '' then 'LIBERADO'  
            When C5_NOTA <> '' AND C5_BLQ = '' then 'ENCERRADO'  
            When C5_BLQ = '1' then 'BLOQ. REGRA' 
            When C5_BLQ = '2' then 'BLOQ. VERBA' 
        END as Status,

        RTRIM(C5_CLIENTE) + ' - ' + RTRIM(C5_LOJACLI ) as Cliente_ID, 	
		Cliente.A1_NOME AS Cliente, Cliente.A1_NREDUZ as Fantasia, Cliente.A1_CGC as CNPJ,
		Cliente.A1_EST AS UF, Ltrim(Rtrim(Cliente.A1_MUN)) AS Cidade, 
		Ltrim(Rtrim(Cliente.A1_FSREGI)) AS Regiao_ID, 
		Rtrim(Cliente.A1_FSDREGI) AS Regiao,

        RTRIM(C5_CLIENT) + ' - ' + RTRIM(C5_LOJAENT ) as ClienteEntrega_ID, 
		ClienteEntrega.A1_NOME AS ClienteEntrega, ClienteEntrega.A1_NREDUZ as ClienteEntregaFantasia, ClienteEntrega.A1_CGC as ClienteEntregaCNPJ,
		ClienteEntrega.A1_EST AS ClienteEntregaUF, Ltrim(Rtrim(ClienteEntrega.A1_MUN)) AS ClienteEntregaCidade, 
		Ltrim(Rtrim(ClienteEntrega.A1_FSREGI)) AS ClienteEntregaRegiao_ID, 
		Rtrim(ClienteEntrega.A1_FSDREGI) AS ClienteEntregaRegiao,

        Convert(Varchar(10),Convert(Datetime,C5_EMISSAO,112),103) as Emissao, 
        Year(C5_EMISSAO) as Ano,
	    Case 
                When Month(C5_EMISSAO) = 1 then '01 - JANEIRO' 
                When Month(C5_EMISSAO) = 2 then '02 - FEVEREIRO' 
                When Month(C5_EMISSAO) = 3 then '03 - MARÇO' 
                When Month(C5_EMISSAO) = 4 then '04 - ABRIL' 
                When Month(C5_EMISSAO) = 5 then '05 - MAIO' 
                When Month(C5_EMISSAO) = 6 then '06 - JUNHO' 
                When Month(C5_EMISSAO) = 7 then '07 - JULHO' 
                When Month(C5_EMISSAO) = 8 then '08 - AGOSTO' 
                When Month(C5_EMISSAO) = 9 then '09 - SETEMBRO' 
                When Month(C5_EMISSAO) = 10 then '10 - OUTUBRO' 
                When Month(C5_EMISSAO) = 11 then '11 - NOVEMBRO' 
                When Month(C5_EMISSAO) = 12 then '12 - DEZEMBRO' 
	    End as Mes,
        
        Convert(Varchar(10),Convert(Datetime,C6_ENTREG,112),103) as DataEntrega,
        Year(C6_ENTREG) as AnoEntrega,
	    Case 
                When Month(C6_ENTREG) = 1 then '01 - JANEIRO' 
                When Month(C6_ENTREG) = 2 then '02 - FEVEREIRO' 
                When Month(C6_ENTREG) = 3 then '03 - MARÇO' 
                When Month(C6_ENTREG) = 4 then '04 - ABRIL' 
                When Month(C6_ENTREG) = 5 then '05 - MAIO' 
                When Month(C6_ENTREG) = 6 then '06 - JUNHO' 
                When Month(C6_ENTREG) = 7 then '07 - JULHO' 
                When Month(C6_ENTREG) = 8 then '08 - AGOSTO' 
                When Month(C6_ENTREG) = 9 then '09 - SETEMBRO' 
                When Month(C6_ENTREG) = 10 then '10 - OUTUBRO' 
                When Month(C6_ENTREG) = 11 then '11 - NOVEMBRO' 
                When Month(C6_ENTREG) = 12 then '12 - DEZEMBRO' 
	    End as MesEntrega,

        Case 
             When (C5_TPFRETE) = 'C' then 'C - CIF' 
             When (C5_TPFRETE) = 'F' then 'F - FOB' 
             When (C5_TPFRETE) = 'T' then 'T - POR CONTA TERCEIROS' 
             When (C5_TPFRETE) = 'F' then 'R - POR CONTA REMETENTE'
			 When (C5_TPFRETE) = 'D' then 'D - POR CONTA DESTINATARIO'
			 When (C5_TPFRETE) = 'S' then 'S - SEM FRETE'
        End as TipoFrete,

        C5_SERIE as Serie, Rtrim(B1_GRUPO) + ' - ' + BM_DESC as Grupo, C6_PRODUTO as Produto_ID, B1_DESC as Produto,
        C6_LOTECTL as Lote, C6_DTVALID as DataValidade, C5_FSNOME as Usuario,
        C6_PRCVEN as ValorUnitario, C6_QTDVEN as QTDVendida, C6_QTDENT as QTDEntregue, 
        
        C6_QTDVEN - C6_QTDENT as Saldo, 
        Case When ((C6_QTDVEN - C6_QTDENT= 0) OR (C5_NOTA <> '')) 
            then 'SIM' 
            else 'NÃO' 
        end as "Entregue?", 
        
        C6_VALOR as ValorTotal, C5_NOTA as Nota, 
		Rtrim(C6_TES) + ' - ' + F4_TEXTO AS TES,

		Rtrim(E4_CODIGO) as CondPagamento_FK, Rtrim(E4_DESCRI) as CondPagamento

FROM SC5010 Pedido (nolock)
INNER JOIN SC6010 Item (nolock) ON C6_FILIAL = '010101'
							AND Item.D_E_L_E_T_ <> '*' 
							AND C6_NUM = C5_NUM
INNER JOIN SA1010 Cliente (nolock) ON Cliente.A1_FILIAL = ''
							AND Cliente.D_E_L_E_T_ <> '*' 
							AND Cliente.A1_COD = C5_CLIENTE
							AND Cliente.A1_LOJA = C5_LOJACLI
INNER JOIN SA1010 ClienteEntrega (nolock) ON ClienteEntrega.A1_FILIAL = ''
							AND ClienteEntrega.D_E_L_E_T_ <> '*' 
							AND ClienteEntrega.A1_COD = C5_CLIENT
							AND ClienteEntrega.A1_LOJA = C5_LOJAENT
Inner Join SE4010 CondPagamento (nolock) ON CondPagamento.E4_FILIAL = ''
										AND CondPagamento.D_E_L_E_T_ <> '*'
										AND CondPagamento.E4_CODIGO = C5_CONDPAG	
INNER JOIN SB1010 Produto (nolock) ON B1_FILIAL = ''
							AND Produto.D_E_L_E_T_ <> '*' 
							AND B1_COD = C6_PRODUTO
Inner Join SBM010 Grupo (nolock) ON BM_FILIAL = ''
							 AND Grupo.D_E_L_E_T_ <> '*'
							 AND BM_GRUPO = B1_GRUPO
INNER JOIN SF4010 TipoEntradaSaida (nolock) ON F4_FILIAL = ''
										   AND TipoEntradaSaida.D_E_L_E_T_ <> '*'
										   AND F4_CODIGO = C6_TES
INNER Join SX5010 CFOP (nolock) ON CFOP.X5_FILIAL = '' 
								AND CFOP.D_E_L_E_T_ = ''
								AND CFOP.X5_TABELA = '13'
								AND CFOP.X5_CHAVE = TipoEntradaSaida.F4_CF												   
WHERE 1=1
AND C5_FILIAL = '010101'
AND Pedido.D_E_L_E_T_ <> '*'
AND CONVERT(DATE,C5_EMISSAO,112) between :DATAINICIAL AND :DATAFIM

UNION ALL

Select 

		CJ_NUM as Pedido, '' as PedidoCliente, 'ORCAMENTO' AS Status,

		RTRIM(CJ_CLIENTE) + ' - ' + RTRIM(CJ_LOJA ) as Cliente_ID, 	
		Cliente.A1_NOME AS Cliente, Cliente.A1_NREDUZ as Fantasia, Cliente.A1_CGC as CNPJ,
		Cliente.A1_EST AS UF, Ltrim(Rtrim(Cliente.A1_MUN)) AS Cidade, 
		Ltrim(Rtrim(Cliente.A1_FSREGI)) AS Regiao_ID, 
		Rtrim(Cliente.A1_FSDREGI) AS Regiao,

		RTRIM(CJ_CLIENT) + ' - ' + RTRIM(CJ_LOJAENT ) as ClienteEntrega_ID, 
		ClienteEntrega.A1_NOME AS ClienteEntrega, ClienteEntrega.A1_NREDUZ as ClienteEntregaFantasia, ClienteEntrega.A1_CGC as ClienteEntregaCNPJ,
		ClienteEntrega.A1_EST AS ClienteEntregaUF, Ltrim(Rtrim(ClienteEntrega.A1_MUN)) AS ClienteEntregaCidade, 
		Ltrim(Rtrim(ClienteEntrega.A1_FSREGI)) AS ClienteEntregaRegiao_ID, 
		Rtrim(ClienteEntrega.A1_FSDREGI) AS ClienteEntregaRegiao,

		Convert(Varchar(10),Convert(Datetime,CJ_EMISSAO,112),103) as Emissao, 
		Year(CJ_EMISSAO) as Ano,
		Case 
				When Month(CJ_EMISSAO) = 1 then '01 - JANEIRO' 
				When Month(CJ_EMISSAO) = 2 then '02 - FEVEREIRO' 
				When Month(CJ_EMISSAO) = 3 then '03 - MARÇO' 
				When Month(CJ_EMISSAO) = 4 then '04 - ABRIL' 
				When Month(CJ_EMISSAO) = 5 then '05 - MAIO' 
				When Month(CJ_EMISSAO) = 6 then '06 - JUNHO' 
				When Month(CJ_EMISSAO) = 7 then '07 - JULHO' 
				When Month(CJ_EMISSAO) = 8 then '08 - AGOSTO' 
				When Month(CJ_EMISSAO) = 9 then '09 - SETEMBRO' 
				When Month(CJ_EMISSAO) = 10 then '10 - OUTUBRO' 
				When Month(CJ_EMISSAO) = 11 then '11 - NOVEMBRO' 
				When Month(CJ_EMISSAO) = 12 then '12 - DEZEMBRO' 
		End as Mes,

		Convert(Varchar(10),Convert(Datetime,CK_ENTREG,112),103) as DataEntrega,
		Year(CK_ENTREG) as AnoEntrega,
		Case 
				When Month(CK_ENTREG) = 1 then '01 - JANEIRO' 
				When Month(CK_ENTREG) = 2 then '02 - FEVEREIRO' 
				When Month(CK_ENTREG) = 3 then '03 - MARÇO' 
				When Month(CK_ENTREG) = 4 then '04 - ABRIL' 
				When Month(CK_ENTREG) = 5 then '05 - MAIO' 
				When Month(CK_ENTREG) = 6 then '06 - JUNHO' 
				When Month(CK_ENTREG) = 7 then '07 - JULHO' 
				When Month(CK_ENTREG) = 8 then '08 - AGOSTO' 
				When Month(CK_ENTREG) = 9 then '09 - SETEMBRO' 
				When Month(CK_ENTREG) = 10 then '10 - OUTUBRO' 
				When Month(CK_ENTREG) = 11 then '11 - NOVEMBRO' 
				When Month(CK_ENTREG) = 12 then '12 - DEZEMBRO' 
		End as MesEntrega,

		'SEM FRETE' as TipoFrete, 

		'' as Serie, Rtrim(B1_GRUPO) + ' - ' + BM_DESC as Grupo, CK_PRODUTO as Produto_ID, B1_DESC as Produto,
		'' as Lote, '' as DataValidade, '' as Usuario,
		CK_PRCVEN as ValorUnitario, CK_QTDVEN as QTDVendida, 0 as QTDEntregue, 
        
		0 as Saldo, 
		'NÃO' as "Entregue?", 
        
		CK_QTDVEN * CK_PRCVEN as ValorTotal, '' as Nota, 
		Rtrim(CK_TES) + ' - ' + F4_TEXTO AS TES,

		Rtrim(E4_CODIGO) as CondPagamento_FK, Rtrim(E4_DESCRI) as CondPagamento
					  
from SCJ010 (nolock) Orcamento
Inner Join  SCK010 (nolock) Item ON Item.D_E_L_E_T_ <> '*' 
								AND Item.CK_FILIAL = '010101' 
								AND Item.CK_NUM = Orcamento.CJ_NUM
INNER JOIN  SA1010 AS Cliente WITH (nolock) ON Cliente.A1_FILIAL = ''
											AND Cliente.D_E_L_E_T_ <> '*'
											AND Cliente.A1_COD = Orcamento.CJ_CLIENTE 
											AND Cliente.A1_LOJA = Orcamento.CJ_LOJA
INNER JOIN SA1010 ClienteEntrega (nolock) ON ClienteEntrega.A1_FILIAL = ''
							AND ClienteEntrega.D_E_L_E_T_ <> '*' 
							AND ClienteEntrega.A1_COD = CJ_CLIENT
							AND ClienteEntrega.A1_LOJA = CJ_LOJAENT
Inner Join SE4010 CondPagamento (nolock) ON CondPagamento.E4_FILIAL = ''
										AND CondPagamento.D_E_L_E_T_ <> '*'
										AND CondPagamento.E4_CODIGO = CJ_CONDPAG														 
INNER JOIN SB1010 Produto (nolock) ON B1_FILIAL = ''
							AND Produto.D_E_L_E_T_ <> '*' 
							AND B1_COD = Item.CK_PRODUTO
Inner Join SBM010 Grupo (nolock) ON BM_FILIAL = ''
								AND Grupo.D_E_L_E_T_ <> '*'
								AND BM_GRUPO = B1_GRUPO
INNER JOIN SF4010 TipoEntradaSaida (nolock) ON F4_FILIAL = ''
											AND TipoEntradaSaida.D_E_L_E_T_ <> '*'
											AND F4_CODIGO = Item.CK_TES 
INNER Join SX5010 CFOP (nolock) ON CFOP.X5_FILIAL = '' 
								AND CFOP.D_E_L_E_T_ = ''
								AND CFOP.X5_TABELA = '13'
								AND CFOP.X5_CHAVE = TipoEntradaSaida.F4_CF										   

Where Orcamento.D_E_L_E_T_ <> '*'
AND Orcamento.CJ_FILIAL = '010101'
AND Orcamento.CJ_STATUS = 'A'
AND CONVERT(DATE,CJ_EMISSAO,112) between :DATAINICIAL AND :DATAFIM

Order by Emissao desc
