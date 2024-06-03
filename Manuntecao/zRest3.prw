//Bibliotecas
#Include "TOTVS.ch"

/*/{Protheus.doc} User Function zRest3
Exemplo de consumo de REST usando FWRest com Basic Token
@type  Function
@author Atilio
@since 30/10/2022
/*/

User Function zRest3()
    Local aArea         := FWGetArea()
    Local cUsrLogin     := Alltrim(SuperGetMV("MV_X_WSUSR", .F., "daniel.atilio"))
    Local cUsrSenha     := Alltrim(SuperGetMV("MV_X_WSPAS", .F., "tst123"))
    Local cBasicAuth    := Encode64(cUsrLogin + ":" + cUsrSenha)
    Local aHeader       := {}
    Local cURL          := "http://localhost:8400/rest/zWSProdutos"
    Local oRestClient   := FWRest():New(cURL)
 
    //Adiciona os headers que serão enviados via WS
    aAdd(aHeader, 'Authorization: Basic ' + cBasicAuth)
 
    //Define a url
    oRestClient:setPath("/get_id?id=F0002")
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
