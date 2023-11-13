#include "TOTVS.CH"
#include "RESTFUL.CH" //Include utilizada para construção de WebServices REST

//Inicio a criação do meu SERVIÇO REST
WSRESTFUL WSRESTPROD DESCRIPTION "Serviço REST para manipulação de Produtos/SB1"

//Parametro utilizado para busca do produto e para exclusão via método delete
WSDATA CODPRODUTO AS STRING

//Inicio a criação dos métodos que o meu WebService terá
WSMETHOD GET buscarproduto;
DESCRIPTION "Retorna dados do Produto";
WSSYNTAX "/buscarproduto";
PATH "buscarproduto" PRODUCES APPLICATION_JSON

WSMETHOD POST inserirproduto    DESCRIPTION "Inserir dados Produto"   WSSYNTAX "/inserirproduto"      PATH "inserirproduto"   PRODUCES APPLICATION_JSON

WSMETHOD PUT atualizarproduto   DESCRIPTION "Alterar dados Produto"   WSSYNTAX "/atualizarproduto"    PATH "atualizarproduto" PRODUCES APPLICATION_JSON

WSMETHOD DELETE deletarproduto  DESCRIPTION "Deletar dados Produto"   WSSYNTAX "/deletarproduto"      PATH "deletarproduto"   PRODUCES APPLICATION_JSON

ENDWSRESTFUL


//Construção de Método para trazer dados da tabela SB1/PRODUTOS

WSMETHOD GET buscarproduto WSRECEIVE CODPRODUTO WSREST WSRESTPROD
Local lRet  := .T. //Variável lógica de retorno do método

//Recuperamos o produto que está sendo utilizado na URL/PARAMETRO 
Local cCodProd  := Self:CODPRODUTO //Self = Interno = Deste mesmo font = desta mesma estrutura
Local aArea     := GetArea()

Local oJson     := JsonObject():New() //Instanciando a classe JsonObject para transformar a variável oJson na estruura JSon
Local cJson     := ""

Local oReturn   //Caso o produto não seja encontrado retorna uma mensagem de erro
Local cReturn   //Retorno de sucesso adicional

Local aProd     := {} //Array que receberá os dados de Produto e  será passado para Json

/*
O Objetivo é trazer do banco de dados os campos: 
Código de Produto / Descrição / Unidade de Medida / Tipo / NCM / Grupo de Produto / Bloqueado ou Não
*/
Local cStatus := "" //Bloqueado ou não
Local cGrupo  := "" //Bloqueado ou não


//Faço a busca de dados, via DbSelectArea()
DbSelectArea("SB1") //Seleciono a área da Tabela SB1
SB1->(DbSetOrder(1)) //Faço a ordenação pelo índice 1 (FILIAL+CÓDIGODEPRODUTO)
IF SB1->(DbSeek(xFilial("SB1")+cCodProd))
    cStatus := IIF(SB1->B1_MSBLQL == "1","Bloqueado","Desbloqueado")
    //Posiciono na SBM com o índice 1 e através do código do grupo do produto eu busco a descrição do grupo
    cGrupo  := Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_DESC") 

    aAdd(aProd,JsonObject():New()) //Passo o array para Json
    /*Como só tenho 1 linha, pois só podem existir 1 produto com o mesmo código no sistema
    logo coloco 1 na posição do índice do array*/  
    aProd[1]['prodcod']     := AllTrim(SB1->B1_COD)
    aProd[1]['proddesc']    := AllTrim(SB1->B1_DESC)
    aProd[1]['produm']      := AllTrim(SB1->B1_UM)
    aProd[1]['prodtipo']    := AllTrim(SB1->B1_TIPO)
    aProd[1]['prodncm']     := AllTrim(SB1->B1_POSIPI)
    aProd[1]['prodgrupo']   := cGrupo
    aProd[1]['prodstatus']  := cStatus


    oReturn := JsonObject():New()
    oReturn['cRet']     := "200"
    oReturn['cmessage'] := "Produto encontrado com sucesso!"
    cReturn := FwJSonSerialize(oReturn) //Serializo esse retorno


    //Passo para o Json com Header Produtos e itens que são os campos que estão acima com os dados da SB1
    oJson["produtos"] := aProd
    //Precisamos FAZER A SERIALIZAÇÃO DO JSON /Trnasformo o retorno de itens em Json, através do FwJsonSerialize(oJson)
    cJson   := FwJSonSerialize(oJson)

    ::SetResponse(cJson)
    ::SetResponse(cReturn)
ELSE
   SetRestFault(400,'Código do Produto não encontrado!') //Setando um erro
   lRet := .F.
   Return(lRet)
ENDIF

SB1->(dbCloseArea())

RestArea(aArea)

//Libero os objetos Json e Retorno
FreeObj(oJson)
FreeObj(oReturn)

RETURN(lRet)



/* Modelo de Json
    {
    "produtos": 
        {
            "proddesc": "WHEY PROTEIN CARNIVOR 2KG",
            "prodcod": "WHEY.000066",
            "produm": "UN",
            "prodtipo": "PA",
            "prodgrupo": "0008"
        }
    }
*/
