#include "TOTVS.CH"
#include "RESTFUL.CH" //Include utilizada para constru��o de WebServices REST

//Inicio a cria��o do meu SERVI�O REST
WSRESTFUL WSRESTPROD DESCRIPTION "Servi�o REST para manipula��o de Produtos/SB1"

//Parametro utilizado para busca do produto e para exclus�o via m�todo delete
WSDATA CODPRODUTO AS STRING

//Inicio a cria��o dos m�todos que o meu WebService ter�
WSMETHOD GET buscarproduto;
DESCRIPTION "Retorna dados do Produto";
WSSYNTAX "/buscarproduto";
PATH "buscarproduto" PRODUCES APPLICATION_JSON

WSMETHOD POST inserirproduto    DESCRIPTION "Inserir dados Produto"   WSSYNTAX "/inserirproduto"      PATH "inserirproduto"   PRODUCES APPLICATION_JSON

WSMETHOD PUT atualizarproduto   DESCRIPTION "Alterar dados Produto"   WSSYNTAX "/atualizarproduto"    PATH "atualizarproduto" PRODUCES APPLICATION_JSON

WSMETHOD DELETE deletarproduto  DESCRIPTION "Deletar dados Produto"   WSSYNTAX "/deletarproduto"      PATH "deletarproduto"   PRODUCES APPLICATION_JSON

ENDWSRESTFUL


//Constru��o de M�todo para trazer dados da tabela SB1/PRODUTOS

WSMETHOD GET buscarproduto WSRECEIVE CODPRODUTO WSREST WSRESTPROD
Local lRet  := .T. //Vari�vel l�gica de retorno do m�todo

//Recuperamos o produto que est� sendo utilizado na URL/PARAMETRO 
Local cCodProd  := Self:CODPRODUTO //Self = Interno = Deste mesmo font = desta mesma estrutura
Local aArea     := GetArea()

Local oJson     := JsonObject():New() //Instanciando a classe JsonObject para transformar a vari�vel oJson na estruura JSon
Local cJson     := ""

Local oReturn   //Caso o produto n�o seja encontrado retorna uma mensagem de erro
Local cReturn   //Retorno de sucesso adicional

Local aProd     := {} //Array que receber� os dados de Produto e  ser� passado para Json

/*
O Objetivo � trazer do banco de dados os campos: 
C�digo de Produto / Descri��o / Unidade de Medida / Tipo / NCM / Grupo de Produto / Bloqueado ou N�o
*/
Local cStatus := "" //Bloqueado ou n�o
Local cGrupo  := "" //Bloqueado ou n�o


//Fa�o a busca de dados, via DbSelectArea()
DbSelectArea("SB1") //Seleciono a �rea da Tabela SB1
SB1->(DbSetOrder(1)) //Fa�o a ordena��o pelo �ndice 1 (FILIAL+C�DIGODEPRODUTO)
IF SB1->(DbSeek(xFilial("SB1")+cCodProd))
    cStatus := IIF(SB1->B1_MSBLQL == "1","Bloqueado","Desbloqueado")
    //Posiciono na SBM com o �ndice 1 e atrav�s do c�digo do grupo do produto eu busco a descri��o do grupo
    cGrupo  := Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_DESC") 

    aAdd(aProd,JsonObject():New()) //Passo o array para Json
    /*Como s� tenho 1 linha, pois s� podem existir 1 produto com o mesmo c�digo no sistema
    logo coloco 1 na posi��o do �ndice do array*/  
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


    //Passo para o Json com Header Produtos e itens que s�o os campos que est�o acima com os dados da SB1
    oJson["produtos"] := aProd
    //Precisamos FAZER A SERIALIZA��O DO JSON /Trnasformo o retorno de itens em Json, atrav�s do FwJsonSerialize(oJson)
    cJson   := FwJSonSerialize(oJson)

    ::SetResponse(cJson)
    ::SetResponse(cReturn)
ELSE
   SetRestFault(400,'C�digo do Produto n�o encontrado!') //Setando um erro
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
