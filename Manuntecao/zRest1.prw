//Bibliotecas
#Include "TOTVS.ch"

/*/{Protheus.doc} User Function zRest1
Exemplo de consumo de REST usando FWRest
@type  Function
@author Atilio
@since 30/10/2022
@obs Exemplo original em https://terminaldeinformacao.com/2020/08/06/exemplo-de-integracao-com-viacep-usando-fwrest/
/*/

User Function zRest1()
    Local aArea         := FWGetArea()
    Local aHeader       := {}    
    Local oRestClient   := FWRest():New("https://viacep.com.br/ws")
    Local cCep          := '40735610'
 
    //Adiciona os headers que serão enviados via WS
    aAdd(aHeader,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
    aAdd(aHeader,'Content-Type: application/json; charset=utf-8')
 
    //Define a url conforme o CEP e aciona o método GET
    oRestClient:setPath("/"+cCep+"/json/")
    If oRestClient:Get(aHeader)
        
        //Exibe o resultado que veio do WS
        ShowLog(oRestClient:cResult)

    //Senão, pega os erros, e exibe em um Alert
    Else
        cLastError := oRestClient:GetLastError()
        cErrorDetail := oRestClient:GetResult()
        Alert(cErrorDetail)
    Endif  

    FWRestArea(aArea)
Return
