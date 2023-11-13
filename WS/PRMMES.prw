#include "TOTVS.CH"
#include "RESTFUL.CH"

WSRESTFUL MEDTRONIC DESCRIPTION "Registro Mensal da Medtronic"
    
    WSDATA cbuscar AS STRING    
    WSMETHOD GET  ALL DESCRIPTION 'Retorna todos os registros' WSSYNTAX '/medtronic' PATH '/' PRODUCES APPLICATION_JSON

END WSRESTFUL

WSMETHOD GET ALL WSRECEIVE cbuscar WSREST MEDTRONIC
    Local lRet       := .T.
	Local nCount 	 := 1
	Local nRegistros := 0

	Local aQuery     := {}
    Local oJson      := JsonObject():New() 
    Local cJson      := ""   
    Local cAlias := getNextAlias()
    	
	BeginSql alias cAlias


		Select		 

			Substring(Convert(Varchar(10),GetDate() - Day(GetDate()),101),7,4) + Substring(Convert(Varchar(10),GetDate() - Day(GetDate()),101),1,2) as SubmissionMth,
			Case when RIGHT(B1_CODAPEL, 1) = '.' then  LEFT(B1_CODAPEL, LEN(B1_CODAPEL) - 1) else B1_CODAPEL end as productCodeCfn,
			'EA' as uom, SaldoLote.B8_SALDO as quantity,
			B8_DTVALID as expiryDate,

			Case 
				When B2_LOCAL = '88' then 'T0006V7VQI' 
				When B2_LOCAL = '89' then 'T0006V7VQI' 
				When B2_LOCAL = '66' then 'T0006V7VQI' 
				else '1434291'
			end as Location,
			
			Case 
				When B2_LOCAL = '78' then 'P' 
				When B2_LOCAL = '87' then 'P' 
				When B2_LOCAL = '88' then 'C' 
				When B2_LOCAL = '89' then 'C' 
				when Substring(B8_DTVALID,1,6) = Substring(Convert(Varchar(10),GetDate() - Day(GetDate()),101),7,4) + Substring(Convert(Varchar(10),GetDate() - Day(GetDate()),101),1,2) then 'E'
				else 'S'
			end as status,

			Case when RIGHT(B8_LOTECTL, 1) in ('.','/','\') then  LEFT(B8_LOTECTL, LEN(B8_LOTECTL) - 1) else B8_LOTECTL end as lotSerialNumber,

			'' as NA1, '' as NA2, 
				
			Case when B1_TIPO = 'AI' then 'ITEM IMOBILIZADO' else '' end as comments

			, Rtrim(B2_LOCAL) + ' - ' + Rtrim(Armazem.NNR_DESCRI) as Armazem, B1_TIPO as Tipo
			
		from SB2010 Saldo   (nolock)
		Inner Join NNR010 Armazem (Nolock) ON Armazem.NNR_FILIAL = '010101'
										AND Armazem.D_E_L_E_T_ <> '*'
										AND Armazem.NNR_CODIGO = B2_LOCAL 
										AND Armazem.NNR_CODIGO in ('01', '02', '20', '22', '23', '26', '28', '30', '31', '32', '34', '35', '36', '37', '38', '39', '40', '41', '78', '83', '84', '87', '89', '90', '91', '94', '95')
		Inner Join SB8010 SaldoLote (nolock) ON B8_FILIAL = '010101'
											AND SaldoLote.D_E_L_E_T_ <> '*'
											AND B8_PRODUTO = B2_COD 
											AND B8_LOCAL = B2_LOCAL									
											AND SaldoLote.B8_SALDO > 0
		INNER JOIN SB1010 Produto (nolock) ON B1_FILIAL = ''
											AND Produto.D_E_L_E_T_ <> '*'
											AND B1_COD = B8_PRODUTO
		INNER JOIN SBM010 Grupo (nolock) ON   BM_FILIAL = ''
											AND Grupo.D_E_L_E_T_ <> '*'
											AND BM_GRUPO = B1_GRUPO

		Inner Join (
					Select 
						Substring(BM_GRUPO,1,2) as Marca_ID, BM_DESC as Marca 
					from SBM010 Marca (nolock)
					Where BM_FILIAL = ''
					AND Marca.D_E_L_E_T_ <> '*'
					AND Substring(BM_GRUPO,1,2) in ('01','27')
					AND Substring(BM_GRUPO,1,2) = BM_GRUPO
		) Marca ON Marca.Marca_ID = Substring(Grupo.BM_GRUPO,1,2) 
		WHERE 1=1
		AND B2_FILIAL = '010101'
		AND Saldo.D_E_L_E_T_ <> '*'

		UNION ALL

		Select

			Substring(Convert(Varchar(10),GetDate() - Day(GetDate()),101),7,4) + Substring(Convert(Varchar(10),GetDate() - Day(GetDate()),101),1,2) as SubmissionMth,
			
			Case when RIGHT(B1_CODAPEL, 1) = '.' then  LEFT(B1_CODAPEL, LEN(B1_CODAPEL) - 1) else B1_CODAPEL end as productCodeCfn,
			

			'EA' as uom, B6_QUANT as quantity,
			D2_DTVALID as expiryDate,
			
			Case when Cliente.A1_XMTRONI = '' then A1_CGC else Ltrim(Rtrim(Cliente.A1_XMTRONI)) end as Location,	
			
			'C' as status,
			
			Case when RIGHT(D2_LOTECTL, 1) in ('.','/','\') then  LEFT(D2_LOTECTL, LEN(D2_LOTECTL) - 1) else D2_LOTECTL end as lotSerialNumber, 

			'' as NA1, '' as NA2,

			Case when B1_TIPO = 'AI' then 'ITEM IMOBILIZADO' else '' end as comments

			, Rtrim(B6_LOCAL) + ' - ' + Rtrim(Armazem.NNR_DESCRI) as Armazem, B1_TIPO as Tipo
			
		from SB6010 PoderTerceiros (nolock)
		Inner Join SD2010 Nota (nolock) ON D2_FILIAL = '010101'
									AND Nota.D_E_L_E_T_ <> '*'
									AND D2_COD = B6_PRODUTO   
									AND D2_IDENTB6 = B6_IDENT
		INNER JOIN SA1010 Cliente (nolock) ON A1_FILIAL = ''
										AND Cliente.D_E_L_E_T_ <> '*' 
										AND A1_COD = B6_CLIFOR 
										AND A1_LOJA = B6_LOJA
		Inner Join NNR010 Armazem (Nolock) ON Armazem.NNR_FILIAL = '010101'
										AND Armazem.D_E_L_E_T_ <> '*'
										AND Armazem.NNR_CODIGO = B6_LOCAL 
		INNER JOIN SF4010 F4 (nolock) ON F4_FILIAL = ''
									AND F4.D_E_L_E_T_ <> '*'
									AND F4_CODIGO = B6_TES
									AND F4_PODER3 = 'R'
		INNER JOIN SB1010 Produto (nolock) ON B1_FILIAL = ''
											AND Produto.D_E_L_E_T_ <> '*'
											AND B1_COD = B6_PRODUTO
		INNER JOIN SBM010 Grupo (nolock) ON   BM_FILIAL = ''
											AND Grupo.D_E_L_E_T_ <> '*'
											AND BM_GRUPO = B1_GRUPO

		Inner Join (
					Select 
						Substring(BM_GRUPO,1,2) as Marca_ID, BM_DESC as Marca 
					from SBM010 Marca (nolock)
					Where BM_FILIAL = ''
					AND Marca.D_E_L_E_T_ <> '*'
					AND Substring(BM_GRUPO,1,2) in ('01','27')
					AND Substring(BM_GRUPO,1,2) = BM_GRUPO
		) Marca ON Marca.Marca_ID = Substring(Grupo.BM_GRUPO,1,2) 
		Where B6_FILIAL = '010101'
		AND B6_PODER3 = 'R'
		AND B6_ATEND = ''

		Order by productCodeCfn

    EndSql
    
	Count to nRegistros	
	(cAlias)->(dbGoTop())	

	WHILE (cAlias)->(!EOF())
    	aAdd(aQuery,JsonObject():New())
			aQuery[nCount]['SubmissionMth']    	:= EncodeUTF8(AllTrim((cAlias)->SubmissionMth))
			aQuery[nCount]['productCodeCfn']   	:= EncodeUTF8(AllTrim((cAlias)->productCodeCfn))
			aQuery[nCount]['uom']              	:= EncodeUTF8(AllTrim((cAlias)->uom))
			aQuery[nCount]['quantity'] 			:= (cAlias)->quantity
			aQuery[nCount]['expiryDate']       	:= EncodeUTF8(AllTrim((cAlias)->expiryDate))
			aQuery[nCount]['Location']         	:= EncodeUTF8(AllTrim((cAlias)->Location))
			aQuery[nCount]['status']           	:= EncodeUTF8(AllTrim((cAlias)->status))
			aQuery[nCount]['lotSerialNumber']	:= EncodeUTF8(AllTrim((cAlias)->lotSerialNumber))
			aQuery[nCount]['NA1']              	:= EncodeUTF8(AllTrim((cAlias)->NA1))
			aQuery[nCount]['NA2']              	:= EncodeUTF8(AllTrim((cAlias)->NA2))
			aQuery[nCount]['comments']         	:= EncodeUTF8(AllTrim((cAlias)->comments))
			aQuery[nCount]['Armazem']          	:= EncodeUTF8(AllTrim((cAlias)->Armazem))
			aQuery[nCount]['Tipo']             	:= EncodeUTF8(AllTrim((cAlias)->Tipo))
		nCount++
		(cAlias)->(dbSkip())
	enddo 	

	(cAlias)->(dbCloseArea())

	if nRegistros > 0

		oJson["medtronic"] := aQuery 
		cJson   := FwJSonSerialize(oJson)
		::SetResponse(cJson) 			

	Else

		SetRestFault(400,EncodeUTF8('Nenhum registro encontrado!')) 
		lRet := .F.
		Return(lRet)

	Endif

    FreeObj(oJson)

Return lRet


