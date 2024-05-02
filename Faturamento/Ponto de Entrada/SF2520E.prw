#include "rwmake.ch"    
#include "topconn.ch"    

/*/{Protheus.doc} Ponto de Entrada SF2520E - Estorno do Documento de Saída
description O ponto de entrada SF2520E não espera nenhum retorno lógico em sua execução por isso não pode impedir que o processo continue, ele tem a finalidade de permitir a execução de procedimentos antes que o estorno do documento de saída seja finalizado.
@author Elisagela Souza 
@since 01/03/2021
@return 
/*/

User Function SF2520E()

_cAlias	:= ALIAS( )
_cOrd  	:= IndexOrd()
_nReg  	:= Recno()     

_cFilE1	:= xFilial("SE1")

//Atualizando Contas a Receber
DbSelectarea("SE1")
SE1->( DbSetorder(1) )
SE1->( DbSeek(_cFilE1+SF2->F2_PREFIXO+SF2->F2_DUPL,.T.) )

While SE1->( !Eof() ) .And. SE1->E1_FILIAL=_cFilE1 .And. SE1->E1_PREFIXO == SF2->F2_PREFIXO .And. SE1->E1_NUM == SF2->F2_DUPL

	If Alltrim(SE1->E1_TIPO) = "NF" .And. (Alltrim(SE1->E1_FSFORMA) = "CC" .Or. Alltrim(SE1->E1_FSFORMA) = "CD" ) // CartÃ£o de CrÃ©dito ou dÃ©bito
	
			// Prepara o array para o execauto
			aVetSE1 := {}
			aAdd(aVetSE1, {"E1_FILIAL"	, _cFilE1			, Nil})
			aAdd(aVetSE1, {"E1_NUM"		, SF2->F2_DUPL		, Nil})
			aAdd(aVetSE1, {"E1_PREFIXO"	, SF2->F2_PREFIXO	, Nil})
			aAdd(aVetSE1, {"E1_PARCELA"	, SE1->E1_PARCELA	, Nil})	
			aAdd(aVetSE1, {"E1_TIPO"	, SE1->E1_TIPO		, Nil})	

			//Inicia o controle de transaÃ§Ã£o
			Begin Transaction
				//Chama a rotina automÃ¡tica
				lMsErroAuto := .F.
				MSExecAuto({|x,y| FINA040(x,y)}, aVetSE1, 5)
				
				//Se houve erro, mostra o erro ao usuÃ¡rio e desarma a transaÃ§Ã£o
				If lMsErroAuto
					//MostraErro()
					DisarmTransaction()
				EndIf 
			//Finaliza a transaÃ§Ã£o
			End Transaction
	Endif
	
    SE1->( DbSkip() )
Enddo

//DEVOLVE POSICAO DO SIGA DEPOIS DE EXECUTADO O PONTO DE ENTRADA
DbSelectArea(_cAlias)
DbSetOrder(_cOrd)
DbGoto(_nReg)

Return(nil)       
