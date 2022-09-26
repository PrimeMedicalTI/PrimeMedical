#include "topconn.ch"
#INCLUDE 'RWMAKE.CH'
#include "protheus.ch"
#include "parmtype.ch"

User function FFATA005(c_Paciente, d_DtProc)

Local l_Ret     := .T.
Local cAliasC5  := GetNextAlias()

// Verifica de tem algum pedido de venda com o memso pacinte / Data do Procedimento
BeginSql Alias cAliasC5
    SELECT TOP 1 C5_NUM
    FROM  %table:SC5% SC5
    WHERE C5_FILIAL = %Exp:xFilial("SC5")% 
        AND  UPPER(TRIM(C5_PACIENT))= %Exp:Upper(Alltrim(c_Paciente))%
        AND C5_DTPROCE =%Exp:DtoS(d_DtProc)% 
        AND SC5.%NotDel%
EndSql 

If  !(cAliasC5)->( Eof() )
//	AVISO("Pedido de Procedimento", "Esse paciente/data procedimento já foram utilizados no pedido de venda " + (cAliasC5)->C5_NUM, { "OK" }, 1)
	ShowHelpDlg("Pedido de Procedimento",;
			{"Esse paciente/data procedimento já foram utilizados","no Pedido de Venda " + (cAliasC5)->C5_NUM},5,;
			{"Altere os dados do Paciente e/ou ","da Data do Procedimento"},5)
   l_Ret := .F. 
Endif

Return( l_Ret )
