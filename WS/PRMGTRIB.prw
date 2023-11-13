#include "TOTVS.CH"
#include "RESTFUL.CH"

WSRESTFUL GRUPOTRIBUTARIOENTRADA DESCRIPTION "Grupo Tributario de Entrada"
    
    WSDATA cbuscar AS STRING    
    WSMETHOD GET  ALL DESCRIPTION 'Retorna todos os registros' WSSYNTAX '/grupotributarioentrada' PATH '/' PRODUCES APPLICATION_JSON

END WSRESTFUL

WSMETHOD GET ALL WSRECEIVE cbuscar WSREST GRUPOTRIBUTARIOENTRADA
    Local lRet       := .T.
	Local nCount 	 := 1
	Local nRegistros := 0

	Local aQuery     := {}
    Local oJson      := JsonObject():New() 
    Local cJson      := ""   
    Local cAlias := getNextAlias()
    	
	BeginSql alias cAlias

		Select 
	
				TesInteligente.R_E_C_N_O_ as Recno, Rtrim(FM_ID) as ID, TesInteligente.FM_GRPROD as GrupoProduto_ID, Rtrim(FM_DESCR) as TesInteligente, 
				TesInteligente.FM_TIPO + ' - ' + Tipo.X5_DESCRI as Tipo, FM_EST as UF,
				Rtrim(FM_GRPROD) + ' - ' + Grupo.X5_DESCRI as GrupoProduto, 
				FM_TE + ' - ' + F4_TEXTO as Tes, F4_TIPO as TipoTes,  
								
				Rtrim(F4_CTIPI) + ' - ' + Upper(CST_IPI.X5_DESCRI) as IPI_CST, 
				Case when F4_IPI = 'S' then 'Sim' else 'Não' end AS IPI_Incide,
				Case when F4_CREDIPI = 'S' then 'Sim' else 'Não' end AS IPI_Credita,

				Case when F4_ICM = 'S' then 'Sim' else 'Não' end AS ICMS_Incide,				
				Rtrim(F4_SITTRIB) + ' - ' + Upper(CST_ICMS.X5_DESCRI) as ICMS_CST, 
								
			
				CASE 
					WHEN F4_PISCOF = '1' THEN 'INCIDE PIS' 
					WHEN F4_PISCOF = '2' THEN 'INCIDE COFINS' 
					WHEN F4_PISCOF = '3' THEN 'INCIDE PIS/COFINS' 
					WHEN F4_PISCOF = '4' THEN 'NÃO INCIDE' 
				END AS PisCofins_Incide, 
								
				Case when F4_CREDST = 4 then 'Sim' else 'Não' end as TemSubsTributaria,


				Case 
					when F4_PISCOF = 1 then 'PIS'
					when F4_PISCOF = 2 then 'COFINS'
					when F4_PISCOF = 3 then 'AMBOS'		
					when F4_PISCOF = 4 then 'NAO CONSIDERA'		
				end as PisCof_Status, 			

				Case 
					when F4_PISCRED = 1 then 'CREDITA'
					when F4_PISCRED = 2 then 'DEBITA'
					when F4_PISCRED = 3 then 'NAO CALCULA'
					when F4_PISCRED = 4 then 'CALCULA'
					when F4_PISCRED = 5 then 'EXCLUSAO DE BASE'
				end as PisCof_Aplica, 

				Case when F4_PISCRED = 1 then (Select Cast(X6_CONTEUD as Float) from SX6010 (nolock) where X6_VAR = 'MV_TXPIS') else 0 end as PIS_Perc,
				Case when F4_PISCRED = 1 then (Select Cast(X6_CONTEUD as Float) from SX6010 (nolock) where X6_VAR = 'MV_TXCOFIN') else 0 end as COF_Perc,

				F4_CSTPIS as PIS_CodSitTrib, F4_CSTCOF as COF_CodSitTrib,

				FM_FILIAL as Filial
	
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
		Left Join SX5010 CST_ICMS (nolock) ON CST_ICMS.X5_FILIAL = ''
										AND CST_ICMS.D_E_L_E_T_ <> '*'
										AND CST_ICMS.X5_TABELA = 'S2'
										AND CST_ICMS.X5_CHAVE = F4_SITTRIB
		Left Join SX5010 CST_IPI (nolock) ON CST_IPI.X5_FILIAL = ''
										AND CST_IPI.D_E_L_E_T_ <> '*'
										AND CST_IPI.X5_TABELA = 'S3'
										AND CST_IPI.X5_CHAVE = F4_CTIPI				
				 
		Where 1=1
		AND FM_FILIAL = '0101'
		AND TesInteligente.D_E_L_E_T_ <> '*'	
		AND TesInteligente.FM_TIPO in ('51','O')
		AND FM_ID not in ('000030', '000031', '000033')
		Order by FM_GRPROD

    EndSql
    
	Count to nRegistros	
	(cAlias)->(dbGoTop())	
			
	WHILE (cAlias)->(!EOF())
    	aAdd(aQuery,JsonObject():New())
			aQuery[nCount]['Recno']              := PADL(ALLTRIM(STR((cAlias)->Recno)),10,"0")    
			aQuery[nCount]['ID']                 := EncodeUTF8(AllTrim((cAlias)->ID))   
			aQuery[nCount]['GrupoProduto_ID']    := EncodeUTF8(AllTrim((cAlias)->GrupoProduto_ID))   
			aQuery[nCount]['TesInteligente']     := EncodeUTF8(AllTrim((cAlias)->TesInteligente)) 
			aQuery[nCount]['Tipo']               := EncodeUTF8(AllTrim((cAlias)->Tipo))
			aQuery[nCount]['UF']                 := EncodeUTF8(AllTrim((cAlias)->UF))   
			aQuery[nCount]['GrupoProduto']       := EncodeUTF8(AllTrim((cAlias)->GrupoProduto))   
			aQuery[nCount]['Tes']                := EncodeUTF8(AllTrim((cAlias)->Tes))  
			aQuery[nCount]['TipoTes']            := EncodeUTF8(AllTrim((cAlias)->TipoTes))
			aQuery[nCount]['IPI_CST']            := EncodeUTF8(AllTrim((cAlias)->IPI_CST))
			aQuery[nCount]['IPI_Incide']         := EncodeUTF8(AllTrim((cAlias)->IPI_Incide))
			aQuery[nCount]['IPI_Credita']        := EncodeUTF8(AllTrim((cAlias)->IPI_Credita))
			aQuery[nCount]['ICMS_Incide']        := EncodeUTF8(AllTrim((cAlias)->ICMS_Incide))
			aQuery[nCount]['ICMS_CST']           := EncodeUTF8(AllTrim((cAlias)->ICMS_CST))
			aQuery[nCount]['PisCofins_Incide']   := EncodeUTF8(AllTrim((cAlias)->PisCofins_Incide))
			aQuery[nCount]['TemSubsTributaria']  := EncodeUTF8(AllTrim((cAlias)->TemSubsTributaria))
			aQuery[nCount]['PisCof_Status']      := EncodeUTF8(AllTrim((cAlias)->PisCof_Status))
			aQuery[nCount]['PisCof_Aplica']      := EncodeUTF8(AllTrim((cAlias)->PisCof_Aplica))
			aQuery[nCount]['PIS_CodSitTrib']     := EncodeUTF8(AllTrim((cAlias)->PIS_CodSitTrib))
			aQuery[nCount]['COF_CodSitTrib']     := EncodeUTF8(AllTrim((cAlias)->COF_CodSitTrib))
			aQuery[nCount]['PIS_Perc']     		 := (cAlias)->PIS_Perc
			aQuery[nCount]['COF_Perc']    		 := (cAlias)->COF_Perc			
			aQuery[nCount]['Filial']             := EncodeUTF8(AllTrim((cAlias)->Filial))
		nCount++
		(cAlias)->(dbSkip())
	enddo 
	 
	(cAlias)->(dbCloseArea())

	if nRegistros > 0

		oJson["grupotributarioentrada"] := aQuery 
		cJson   := FwJSonSerialize(oJson)
		::SetResponse(cJson) 			

	Else

		SetRestFault(400,EncodeUTF8('Código do Grupo Tributário não encontrado!')) 
		lRet := .F.
		Return(lRet)

	Endif

    FreeObj(oJson)

Return lRet


