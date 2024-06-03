//Bibliotecas
#Include "TOTVS.ch"

/*/{Protheus.doc} User Function zRest4
Exemplo de consumo de REST usando FWRest com Bearer Token
@type  Function
@author Atilio
@since 30/10/2022
/*/

User Function zRest4()
    Local aArea         := FWGetArea()
    Local cUsrLogin     := Alltrim(SuperGetMV("MV_X_WSUSR", .F., "daniel.atilio"))
    Local cUsrSenha     := Alltrim(SuperGetMV("MV_X_WSPAS", .F., "tst123"))
    Local cBearerAut    := fBearer(cUsrLogin, cUsrSenha)
    Local aHeader       := {}
    Local cURL          := "http://localhost:8400/rest/zWSProdutos"
    Local oRestClient
 
    //Se houver token
    If ! Empty(cBearerAut)
        oRestClient   := FWRest():New(cURL)

        //Adiciona os headers que serão enviados via WS
        aAdd(aHeader, 'Authorization: Bearer ' + cBearerAut)
    
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
    EndIf

    FWRestArea(aArea)
Return

Static Function fBearer(cUsrLogin, cUsrSenha)
    Local oRestToken
    Local cUrl := "http://localhost:8400/rest/api/oauth2/v1/"
    Local cToken := ""
    Local aHeaders := {}
    Local jResponse
    Default cUsrLogin := ""
    Default cUsrSenha := ""

    //Instancia o WS
    oRestToken   := FWRest():New(cURL)

    //Define a url
    oRestToken:setPath("token?grant_type=password&password=" + cUsrSenha + "&username=" + cUsrLogin)
    If oRestToken:Post(aHeaders)

        //Pega o JSON de resposta, e pega o token
        jResponse := JsonObject():New()
        jResponse:FromJson(oRestToken:cResult)

        //Pega o Token de acesso
        cToken := Iif( ValType(jResponse['access_token']) != "U", jResponse['access_token'], "")
    EndIf

Return cToken
