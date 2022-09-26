#include "rwmake.ch"    
#include "topconn.ch"    

/*
�������������������������������������������
Programa  :SF2520E   Autor  :Elisângela Souza    Data : Março/2021 
�������������������������������������������������������������������������͹��
Desc.     :Ponto de entrada antes da exclusao da NF de Saida           
�������������������������������������������������������������������������͹��
Uso       : SIGAFAT                                                    
�������������������������������������������������������������������������͹��
�������������������������������������������
*/

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

	If Alltrim(SE1->E1_TIPO) = "NF" .And. (Alltrim(SE1->E1_FSFORMA) = "CC" .Or. Alltrim(SE1->E1_FSFORMA) = "CD" ) // Cartão de Crédito ou débito
	
			// Prepara o array para o execauto
			aVetSE1 := {}
			aAdd(aVetSE1, {"E1_FILIAL"	, _cFilE1			, Nil})
			aAdd(aVetSE1, {"E1_NUM"		, SF2->F2_DUPL		, Nil})
			aAdd(aVetSE1, {"E1_PREFIXO"	, SF2->F2_PREFIXO	, Nil})
			aAdd(aVetSE1, {"E1_PARCELA"	, SE1->E1_PARCELA	, Nil})	
			aAdd(aVetSE1, {"E1_TIPO"	, SE1->E1_TIPO		, Nil})	

			//Inicia o controle de transação
			Begin Transaction
				//Chama a rotina automática
				lMsErroAuto := .F.
				MSExecAuto({|x,y| FINA040(x,y)}, aVetSE1, 5)
				
				//Se houve erro, mostra o erro ao usuário e desarma a transação
				If lMsErroAuto
					//MostraErro()
					DisarmTransaction()
				EndIf 
			//Finaliza a transação
			End Transaction
	Endif
	
    SE1->( DbSkip() )
Enddo

//DEVOLVE POSICAO DO SIGA DEPOIS DE EXECUTADO O PONTO DE ENTRADA
DbSelectArea(_cAlias)
DbSetOrder(_cOrd)
DbGoto(_nReg)

Return(nil)       
