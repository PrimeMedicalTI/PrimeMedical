SELECT 
        A1_CGC as CNPJ, RTRIM(A1_COD) + ' - ' + RTRIM(A1_LOJA) as Cliente_ID, A1_NOME as Cliente,A1_NREDUZ Fantasia, 
        RTRIM(A1_END) + ' / BAIRRO: ' + RTRIM(A1_BAIRRO) as Endereco, A1_EST as UF, A1_MUN as Municipio, A1_EMAIL as Email, A1_INSCR as InscriçãoEstadual,
        case when A1_CONTRIB = '1' then '1-Sim' When A1_CONTRIB = '2' then '2-Nao' else A1_CONTRIB end  as Contribuinte, 
        Case 
            when A1_TIPO = 'F'  then 'CONS. FINAL' 
            when A1_TIPO = 'L'  then 'PRODUTOR RURAL'  
            When A1_TIPO = 'R'  then 'REVENDEDOR'  
            When A1_TIPO = 'S' then 'SOLIDARIO' 
            When A1_TIPO = 'X' then 'EXPORTACAO' 
        END as TipoCliente, Case when A1_PESSOA = 'F' THEN 'FISICA' when A1_PESSOA = 'J' THEN 'JURIDICA' else A1_PESSOA END as Pessoa, A1_CEP as CepCliente, 
		case when A1_IENCONT = '1' then '1-Sim' When A1_IENCONT = '2' then '2-Nao'  else A1_IENCONT end  as DestacaIE

FROM SA1010 Cliente (nolock)
WHERE 1=1
AND A1_FILIAL = ''
AND Cliente.D_E_L_E_T_ <> '*'   