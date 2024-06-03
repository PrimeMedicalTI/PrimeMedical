//Bibliotecas
#Include "TOTVS.ch"

/*/{Protheus.doc} User Function zRest2
Exemplo de consumo de REST usando HttpGet
@type  Function
@author Atilio
@since 30/10/2022
@obs Exemplo original em https://terminaldeinformacao.com/2020/08/06/exemplo-de-integracao-com-viacep-usando-fwrest/
/*/

User Function zRest2()
    Local aArea         := FWGetArea()
    Local cResult       := ''
    Local cCep          := '17054679'

    //Aciona WS REST via HttpGet
    cResult := HttpGet(;
        "https://viacep.com.br/ws/" + cCep + "/json/",; // cURL
        ,; // cGetParms
        ,; // nTimeOut
        ,; // aHeadStr
        ;  // cHeaderGet
    )
 
    //Exibe o resultado que veio do WS
    ShowLog(cResult)

    FWRestArea(aArea)
Return
