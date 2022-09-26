//Bibliotecas
#Include 'Protheus.ch'
#Include 'RwMake.ch'
#Include 'TopConn.ch'

/*------------------------------------------------------------------------------------------------------*
 | P.E.:  MA410MNU                                                                                      |
 | Desc:  Adição de opção no menu de ações relacionadas do Pedido de Vendas                             |
 |                                            |
 *------------------------------------------------------------------------------------------------------*/
  
User Function MA410MNU()
    Local aArea := GetArea()
     
    //Adicionando fun��o de vincular
    aadd(aRotina,{"Salvar DANFE/XML/Boletos","U_FFATA004", 0 , 3, 0 , Nil})
      
    RestArea(aArea)
Return
