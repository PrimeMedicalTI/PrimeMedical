#INCLUDE "TOTVS.CH"
User Function zRest1()
    Local aArea := FWGetArea()
    Local aHeader := {}
    Local oRestClient := FWRest():New("https://viacep.com.br/ws")
    Local cCep := "40735610"
    
    // Adiciona os headers que serão enviados via WS
    Add(aHeader, "User-Agent: Mozilla/4.0 (compatible; Protheus *GetBuild()*")
    Add(aHeader, "Content-Type: application/json; charset=utf-8")
    
    // Define a URL conforme o CEP e aciona o método GET
    oRestClient:setPath("/" + cCep + "/json")
    If oRestClient:Get(aHeader)
        // Exibe o resultado que veio do WS
        ShowLog(oRestClient:cResult)
    Else
        // Senão, pega os erros, e exibe em um Alert
        cLastError := oRestClient:GetLastError()
        cErrorDetail := oRestClient:GetResult()
        Alert(cErrorDetail)
    EndIf

    FWRestArea(aArea)
Return
