#include "rwmake.ch"    
#include "topconn.ch"    

/*
�������������������������������������������
Programa  :SF2460I    Autor  :Elisângela Souza    Data : Março/2021 
�������������������������������������������������������������������������͹��
���Desc.     :Ponto de entrada apos a geração da NF de Saida              
�������������������������������������������������������������������������͹��
���Uso       : SIGAFAT                                                    
�������������������������
�������������������������������������������������͹��
�������������������������������������������
*/

User Function SF2460I()

Local _cAlias	:= ALIAS( )
Local _cOrd  	:= IndexOrd()
Local _nReg  	:= Recno()     

//Obter dados 
Local c_FilE1	:= xFilial("SE1")
Local c_Cli		:= SF2->F2_CLIENTE
Local c_Loja 	:= SF2->F2_LOJA 
Local c_AdmFin	:= SC5->C5_FSCADM
Local c_Pacien	:= SC5->C5_PACIENT
Local c_CConve	:= SC5->C5_FSCCONV
Local c_Conven 	:= SC5->C5_CONVENI
Local d_Proced	:= SC5->C5_DTPROCE
Local n_TxAdm
Local c_HistTx
Local c_FPag	:= ""
Local n_NumPar
Local c_Parcela
Local d_Emissao	
Local d_Vencto 	
Local d_Vencrea	
Local c_NatPr

// Ientifica o número de parcelas
c_Qry := " SELECT COUNT(*) AS NPAR "
c_Qry += " FROM " + RetSqlName("SE1") + " SE1 " 
c_Qry += " WHERE SE1.D_E_L_E_T_ <> '*' "
c_Qry += " AND E1_NUM	  = '" + SF2->F2_DUPL     + "' "
c_Qry += " AND E1_PREFIXO = '" + SF2->F2_PREFIXO  + "' "
c_Qry += " AND E1_CLIENTE = '" + SF2->F2_CLIENTE  + "' "
c_Qry += " AND E1_LOJA	  = '" + SF2->F2_LOJA     + "' "
c_Qry += " AND E1_FILIAL  = '" + c_FilE1	      + "' "
c_Qry += " AND E1_TIPO    = 'NF' "

TcQuery c_Qry New Alias "QRYE1"

DbSelectArea("QRYE1")
QRYE1->( DbGoTop() )
n_NumPar := QRYE1->NPAR

QRYE1->( DbCloseArea())

//Obter dados de Adm.Financeira
If !Empty(c_AdmFin)
	DbSelectArea("SAE")
	SAE->( DbSetOrder(1))
	SAE->( DbSeek(xFilial("SAE")+c_AdmFin))

	n_TxAdm	:= SAE->AE_TAXA 
	c_FPag  := Rtrim(SAE->AE_TIPO) //Rtrim(Posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_FORMA"))

	// Verifica de possui a informação no item
	If n_TxAdm = 0
		DbSelectArea("MEN")
		MEN->( DbSetOrder(2))
		MEN->( DbSeek(xFilial("MEN")+c_AdmFin))
		While MEN->( !Eof() ) .And. MEN->MEN_CODADM = c_AdmFin
			If n_NumPar >= MEN->MEN_PARINI .And. n_NumPar <= MEN->MEN_PARFIN
				n_TxAdm := MEN->MEN_TAXADM	
			Endif

			MEN->( DbSkip())
		Enddo

	Endif

	// Condi��o de Pagamento
	If Empty(c_FPag)
		n_TxAdm	:= 0
	ElseIf c_FPag = "BOL"
		n_TxAdm	:= n_TxAdm
	Else
		n_TxAdm	:= n_TxAdm/100
	Endif	
Endif	

If  SF2->F2_TIPO == "D" //Nf de Devolucao
	//Obter codigo do produto
	Dbselectarea("SD2")
	SD2->( Dbsetorder(1) )
	SD2->( Dbseek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,.T.) )
	
	c_Nome	:= Posicione("SA2",1,xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A2_NOME") 
	c_Hist	:= "DEVOL DE VENDA"
	c_NCli	:= c_Nome    
Else
	c_Nome	:= Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_NOME") 
	c_Hist	:= c_Nome                               
	
	If	c_FPag$"CC/CD"   
		c_Cli 	:= SAE->AE_CODCLI
		c_Loja	:= SAE->AE_LOJCLI
		c_NCli	:= Posicione("SA1",1,xFilial("SA1")+c_Cli+c_Loja,"A1_NOME")    
	Else
		c_NCli	:= c_Nome
	Endif
Endif

//Atualizando Contas a Receber
DbSelectarea("SE1")
SE1->( DbSetorder(1) )
SE1->( DbSeek(c_FilE1+SF2->F2_PREFIXO+SF2->F2_DUPL,.T.) )

While SE1->(!Eof()) .And. SE1->E1_FILIAL = c_FilE1 .And. SE1->E1_PREFIXO == SF2->F2_PREFIXO .And. SE1->E1_NUM == SF2->F2_DUPL
	
	If	SE1->E1_TIPO="AB-"
		SE1->( DbSkip() )
		Loop
	Endif

    Reclock("SE1",.F.)           
    	SE1->E1_NOMCLI 	:= c_NCli                                                                                                         
		SE1->E1_FSFORMA := c_FPag
       	SE1->E1_HIST   	:= c_Hist
		SE1->E1_PACIENT := c_Pacien
		SE1->E1_FSCCONV	:= c_CConve
		SE1->E1_CONVENI	:= c_Conven
		SE1->E1_DTPROCE	:= d_Proced
    MsUnlock()

    c_Parcela	:= SE1->E1_PARCELA  
	d_Emissao	:= SE1->E1_EMISSAO
	d_Vencto 	:= SE1->E1_VENCTO
	d_Vencrea	:= SE1->E1_VENCREA
	c_NatPr		:= SE1->E1_NATUREZ

	If	n_TxAdm > 0 
		Reclock("SE1",.F.)           
    		SE1->E1_CLIENTE	:= c_Cli
   			SE1->E1_LOJA   	:= c_Loja                                  
	    MsUnlock()  

		_nReg	:= SE1->(RECNO())

		If c_FPag="BOL"
			n_Taxa		:= n_TxAdm	
			c_HistTx	:= "Tx.Adm.Boleto Bancario "
		ElseIf c_FPag$"CC/CD"   
			n_Taxa		:= (SE1->E1_VALOR*n_TxAdm) 
			c_HistTx	:= "Tx.Adm. "+Alltrim(c_NCli)
		Else
			n_Taxa		:= 0
			c_HistTx	:= "Tx.Adm." + c_FPag
		Endif	 
		
		// Prepara o array para o execauto
		aVetSE1 := {}
		aAdd(aVetSE1, {"E1_FILIAL"	, c_FilE1			, Nil})
		aAdd(aVetSE1, {"E1_NUM"		, SF2->F2_DUPL		, Nil})
		aAdd(aVetSE1, {"E1_PREFIXO"	, SF2->F2_PREFIXO	, Nil})
		aAdd(aVetSE1, {"E1_FSFORMA"	, c_FPag			, Nil})
		aAdd(aVetSE1, {"E1_PARCELA"	, c_Parcela			, Nil})
		aAdd(aVetSE1, {"E1_TIPO"	, "AB-" 			, Nil})
		aAdd(aVetSE1, {"E1_NATUREZ"	, c_NatPr			, Nil})
		aAdd(aVetSE1, {"E1_CLIENTE"	, c_Cli				, Nil})
		aAdd(aVetSE1, {"E1_LOJA"	, c_Loja			, Nil})
		aAdd(aVetSE1, {"E1_NOMCLI"	, c_NCli			, Nil})
		aAdd(aVetSE1, {"E1_EMISSAO"	, d_Emissao			, Nil})
		aAdd(aVetSE1, {"E1_EMIS1"	, d_Emissao			, Nil})
		aAdd(aVetSE1, {"E1_MOEDA"	,  1				, Nil})
		aAdd(aVetSE1, {"E1_LA"		, "S"				, Nil})
		aAdd(aVetSE1, {"E1_VALOR"	, Round(n_Taxa,2)	, Nil})
		aAdd(aVetSE1, {"E1_SALDO"	, Round(n_Taxa,2)	, Nil})
		aAdd(aVetSE1, {"E1_VLCRUZ"	, Round(n_Taxa,2)	, Nil})
		aAdd(aVetSE1, {"E1_HIST"	, c_HistTx			, Nil})
		aAdd(aVetSE1, {"E1_VENCORI"	, d_Vencto			, Nil})
		aAdd(aVetSE1, {"E1_VENCTO"	, d_Vencto			, Nil})
		aAdd(aVetSE1, {"E1_VENCREA"	, d_Vencrea			, Nil})
		aAdd(aVetSE1, {"E1_STATUS"	, "A"				, Nil})
		aAdd(aVetSE1, {"E1_PACIENT" ,  c_Pacien         , Nil})
		aAdd(aVetSE1, {"E1_FSCCONV" ,  c_CConve 		, Nil})
		aAdd(aVetSE1, {"E1_CONVENI" ,  c_Conven			, Nil})
		aAdd(aVetSE1, {"E1_DTPROCE" ,  d_Proced			, Nil})
	
		//Inicia o controle de transação
		Begin Transaction
			//Chama a rotina automática
			lMsErroAuto := .F.
			MSExecAuto({|x,y| FINA040(x,y)}, aVetSE1, 3)
			
			//Se houve erro, mostra o erro ao usuário e desarma a transação
			If lMsErroAuto
				MostraErro()
				DisarmTransaction()
			EndIf
		//Finaliza a transação
		End Transaction

		SE1->( dbGoTo(_nReg))
	Endif

    SE1->( DbSkip() )
Enddo

//DEVOLVE POSICAO DO SIGA DEPOIS DE EXECUTADO O PONTO DE ENTRADA
DbSelectArea(_cAlias)
DbSetOrder(_cOrd)
DbGoto(_nReg)

Return(nil) 
