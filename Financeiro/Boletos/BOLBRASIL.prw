#include "rwmake.ch"
#include "protheus.ch"
#INCLUDE "Report.CH"
#INCLUDE 'TOPCONN.CH'

#define DMPAPER_A4 9
// A4 210 x 297 mm

/*/
Programa : BOLBRASIL
Autor    : Eliene Cerqueira
Descricao: IMPRESSAO DE BOLETO PARA BANCO DO BRASIL
Uso      : Financeiro
/*/

User Function BOLBRASIL(c_SerNf, c_Agen, c_Cta, c_Subc)
Local   aMarked := {}
Local _stru:={}
Local aCpoBro := {}
Local n_Clic:= 0
Private lInverte := .F.
Private cMark   := GetMark()
Private oMark
PRIVATE Exec    := .F.
PRIVATE cIndexName := ''
PRIVATE cIndexKey  := ''
PRIVATE cFilter    := ''
PRIVATE nCB1Linha    := 14.4
PRIVATE nCB2Linha    := 25.4
Private nCBColuna    := 1.3
Private nCBLargura   := 0.0220
Private nCBAltura    := 1.285
Private l_GeraNN := .F.
Default c_SerNf	:= ''
Default	c_Agen	:= ''
Default c_Cta	:= ''
Default c_Subc	:= ''

AADD(_stru,{"OK"     	, "C",  2, 0})
AADD(_stru,{"E1_PREFIXO", "C", TAMSX3("E1_PREFIXO")[1], 0})
AADD(_stru,{"E1_NUM"   	, "C", TAMSX3("E1_NUM")[1], 0})
AADD(_stru,{"E1_TIPO"   , "C", TAMSX3("E1_TIPO")[1], 0})
AADD(_stru,{"E1_CLIENTE", "C", TAMSX3("E1_CLIENTE")[1], 2})
AADD(_stru,{"E1_LOJA"   , "C", TAMSX3("E1_LOJA")[1], 0})
AADD(_stru,{"E1_VALOR" 	, "N", 17, 2})
AADD(_stru,{"E1_VENCTO" , "D", 8, 0})
AADD(_stru,{"E1_NUMBOR" , "C", TAMSX3("E1_NUMBOR")[1], 0})
AADD(_stru,{"E1_PORTADO", "C", TAMSX3("E1_PORTADO")[1], 0})
AADD(_stru,{"E1_AGEDEP" , "C", TAMSX3("E1_AGEDEP")[1], 0})
AADD(_stru,{"E1_CONTA" 	, "C", TAMSX3("E1_CONTA")[1], 0})
AADD(_stru,{"E1_PARCELA", "C", TAMSX3("E1_PARCELA")[1], 0})
AADD(_stru,{"E1_SITUACA", "C", TAMSX3("E1_SITUACA")[1], 0})
AADD(_stru,{"E1_SALDO" 	, "N", 17, 2})
AADD(_stru,{"E1_EMISSAO", "D", 8, 0})
AADD(_stru,{"E1_NUMBCO" , "C", TAMSX3("E1_NUMBCO")[1], 0})
AADD(_stru,{"E1_NOMCLI" , "C", TAMSX3("E1_NOMCLI")[1], 0})
AADD(_stru,{"E1_FSFORMA"   , "C", TAMSX3("E1_FSFORMA")[1], 0})

//cArq:=Criatrab(_stru,.T.)
//DBUSEAREA(.t.,,carq,"TTRB")
oTempTable := FWTemporaryTable():New( "TTRB" )
oTemptable:SetFields( _stru )

oTempTable:Create()

If 	Len(c_SerNf) > 0
	c_QRY := " SELECT * "
	c_QRY += " FROM " + RetSqlName("SE1")
	c_QRY += " WHERE E1_FILIAL = '" + xFilial("SE1")+ "'"
	c_QRY += " AND E1_PREFIXO+E1_NUM IN "+FormatIn(c_SerNf,";")
	c_QRY += " AND E1_SALDO > 0"
	c_QRY += " AND SUBSTRING(E1_TIPO,3,1) <> '-' "
	c_QRY += " AND E1_FSFORMA = 'BOL ' "
	c_QRY += " AND D_E_L_E_T_ <> '*'
	c_QRY += " ORDER BY E1_PREFIXO, E1_NUM, E1_PARCELA

	TcQuery c_QRY New Alias 'TRB'

	DBSELECTAREA("TRB")
	TRB->(dbGoTop())

	IF	TRB->(Eof())
        msgalert("Nenhum t�tulo encontrado em aberto para esta sele��o.")	
		TRB->(DBCLOSEAREA())
		TTRB->(DBCLOSEAREA())
		Return
	ENDIF

	While  TRB->(!Eof())
		DbSelectArea("TTRB")
		RecLock("TTRB",.T.)
		TTRB->OK			:= cMark
		TTRB->E1_PREFIXO	:=  TRB->E1_PREFIXO
		TTRB->E1_NUM		:=  TRB->E1_NUM
		TTRB->E1_TIPO		:=  TRB->E1_TIPO
		TTRB->E1_CLIENTE	:=  TRB->E1_CLIENTE
		TTRB->E1_LOJA		:=  TRB->E1_LOJA
		TTRB->E1_VALOR		:=  TRB->E1_VALOR
		TTRB->E1_VENCTO		:=  stod(TRB->E1_VENCTO)
		TTRB->E1_NUMBOR		:=  TRB->E1_NUMBOR
		TTRB->E1_PORTADO	:=  TRB->E1_PORTADO
		TTRB->E1_AGEDEP		:=  TRB->E1_AGEDEP
		TTRB->E1_CONTA		:=  TRB->E1_CONTA
		TTRB->E1_PARCELA	:=  TRB->E1_PARCELA
		TTRB->E1_SITUACA	:=  TRB->E1_SITUACA
		TTRB->E1_SALDO		:=  TRB->E1_SALDO
		TTRB->E1_EMISSAO	:=  STOD(TRB->E1_EMISSAO)
		TTRB->E1_NUMBCO		:=  TRB->E1_NUMBCO
		TTRB->E1_NOMCLI	:=  TRB->E1_NOMCLI
		TTRB->E1_FSFORMA	:=  TRB->E1_FSFORMA
		MsunLock()

		AADD(aMarked,.T.)
		TRB->(DbSkip())
	Enddo
	TRB->(DBCLOSEAREA())

	TTRB->(dbGoTop())

	Processa({|lEnd|MontaRel(aMarked, c_Banco, c_Agen, c_Cta, c_Subc)})

Else
	cPerg  :="BOLBRASIL"
	CriaPerg()

	If !Pergunte(cPerg,.T.)
		Return()
	EndIf

	c_QRY := " SELECT * "
	c_QRY += " FROM " + RetSqlName("SE1")
	c_QRY += " WHERE E1_FILIAL = '" + xFilial("SE1")+ "'"
	c_QRY += " AND E1_EMISSAO BETWEEN '" + Dtos(MV_PAR05) + "' AND '" + Dtos(MV_PAR06) + "'"
	c_QRY += " AND E1_VENCTO BETWEEN '" + Dtos(MV_PAR07) + "' AND '" + Dtos(MV_PAR08) + "'"
	c_QRY += " AND E1_CLIENTE BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR11 + "'"
	c_QRY += " AND E1_LOJA BETWEEN '" + MV_PAR10 + "' AND '" + MV_PAR12 + "'"
	c_QRY += " AND E1_NUM BETWEEN '" + MV_PAR13 + "' And '" + MV_PAR14 + "'"
	c_QRY += " AND E1_PORTADO IN ('','"+MV_PAR01+"')
	c_QRY += " AND E1_SALDO > 0"
	c_QRY += " AND SUBSTRING(E1_TIPO,3,1) <> '-' "
	c_QRY += " AND E1_FSFORMA = 'BOL ' "
	c_QRY += " AND D_E_L_E_T_ <> '*'
	c_QRY += " ORDER BY E1_PREFIXO, E1_NUM, E1_PARCELA

	TcQuery c_QRY New Alias 'TRB'

	DBSELECTAREA("TRB")
	TRB->(dbGoTop())

	While  TRB->(!Eof())
		DbSelectArea("TTRB")
		RecLock("TTRB",.T.)
		TTRB->E1_PREFIXO	:=  TRB->E1_PREFIXO
		TTRB->E1_NUM		:=  TRB->E1_NUM
		TTRB->E1_TIPO		:=  TRB->E1_TIPO
		TTRB->E1_CLIENTE	:=  TRB->E1_CLIENTE
		TTRB->E1_LOJA		:=  TRB->E1_LOJA
		TTRB->E1_VALOR		:=  TRB->E1_VALOR
		TTRB->E1_VENCTO		:=  stod(TRB->E1_VENCTO)
		TTRB->E1_NUMBOR		:=  TRB->E1_NUMBOR
		TTRB->E1_PORTADO	:=  TRB->E1_PORTADO
		TTRB->E1_AGEDEP		:=  TRB->E1_AGEDEP
		TTRB->E1_CONTA		:=  TRB->E1_CONTA
		TTRB->E1_PARCELA	:=  TRB->E1_PARCELA
		TTRB->E1_SITUACA	:=  TRB->E1_SITUACA
		TTRB->E1_SALDO		:=  TRB->E1_SALDO
		TTRB->E1_EMISSAO	:=  STOD(TRB->E1_EMISSAO)
		TTRB->E1_NUMBCO		:=  TRB->E1_NUMBCO
		TTRB->E1_NOMCLI	:=  TRB->E1_NOMCLI
		TTRB->E1_FSFORMA	:=  TRB->E1_FSFORMA
		MsunLock()
		TRB->(DbSkip())
	Enddo

	DBSELECTAREA("TRB")
	TRB->(DBCLOSEAREA())

	aCpoBro	:= {{ "OK"		    ,, " "            ,"@!"},;
				{ "E1_PREFIXO"  ,, "Prefixo"	  ,"@!"},;
				{ "E1_NUM"	    ,, "Numero"       ,"@!"},;
				{ "E1_PARCELA"  ,, "Parcela"      ,"@!"},;
				{ "E1_EMISSAO"   ,, "Emiss�o"   , "@!"},;				
				{ "E1_CLIENTE"  ,, "Cliente"      ,"@!"},;
				{ "E1_NOMCLI"  ,, "Nome"      ,"@!"},;
				{ "E1_VALOR"    ,, "Valor"        ,"@E 999,999,999.99"},;
				{ "E1_VENCTO"   ,, "Vencimento"   , "@!"},;
				{ "E1_NUMBCO"   ,, "Nosso Numero" ,"@!"},;
				{ "E1_PORTADOR" ,, "Portador"     ,"@!"}}

	DEFINE MSDIALOG oDlg TITLE "Titulos" From 9,0 To 315,800 PIXEL
	DbSelectArea("TTRB")
	TTRB->(DbGotop())

	oMark := MsSelect():New("TTRB","OK","",aCpoBro,@lInverte,@cMark,{40,1,150,400},,,,,)
	oMark:bMark := {|| Disp()}
	oMark:oBrowse:bAllMark := {|| FILMARK()}
	oMark:oBrowse:lCanAllMark:= .T.
	oMark:oBrowse:lHasMark:= .T.

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| n_Clic:= 1, oDlg:End()},{|| n_Clic:= 2, oDlg:End()})

	IF n_Clic = 1
		TTRB->(dbGoTop())
		While TTRB->(!Eof())
			If TTRB->OK = cMark
				AADD(aMarked,.T.)
			Else
				AADD(aMarked,.F.)
			EndIf
			TTRB->(dbSkip())
		EndDo

		dbGoTop()

		c_Banco := MV_PAR01
		c_Agen := MV_PAR02
		c_Cta := MV_PAR03
		c_Subc := MV_PAR04
		If 	MV_PAR15 = 2 //Sobrepoe Nosso Numero
			l_GeraNN := .T.
		Endif

		Processa({|lEnd|MontaRel(aMarked, c_Banco, c_Agen, c_Cta, c_Subc)})

	ENDIF
Endif

DBSELECTAREA("TTRB")
DBCLOSEAREA()

Return Nil

Static Function Disp()
RecLock("TTRB",.F.)
If Marked("OK")
	TTRB->OK := cMark
Else
	TTRB->OK := ""
Endif
MSUNLOCK()
oMark:oBrowse:Refresh()
Return()

Static Function FILMARK()

TTRB->(dbGoTop())
While TTRB->(!EOF())
	RecLock("TTRB",.F.)
	If Empty(TTRB->OK)
		TTRB->OK := cMark
	Else
		TTRB->OK := ""
	Endif
	MsUnLock()
	TTRB->(dbSkip())
EndDo

TTRB->(dbGoTop())
oMark:oBrowse:Refresh()
Return()

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  MontaRel� Autor �                       � Data � 01/08/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Clientes Microsiga                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MontaRel(aMarked, c_Banco, c_Agen, c_Cta, c_Subc)
Local oPrint
Local n := 0
Local aDadosEmp    := {	SM0->M0_NOMECOM                                                             ,; //[1]Nome da Empresa
                        SM0->M0_ENDCOB                                                              ,; //[2]Endere�o
                        AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
                        "CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
                        "PABX/FAX: "+SM0->M0_TEL                                                    ,; //[5]Telefones
                        "C.N.P.J.: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          ; //[6]
                        Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
                        Subs(SM0->M0_CGC,13,2)                                                     ,; //[6]CGC
                        "I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
                        Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                         }  //[7]I.E

Local aDadosTit
Local aDadosBanco
Local aDatSacado
Local nMulta       	:= SUPERGetMV("FS_MULTA",.F.,2) 
Local nJuros       	:= SUPERGetMV("FS_JUROS",.F.,0.08) 
Local nMark        	:= 1
Local CB_RN_NN     	:= {}
Local nRec         	:= 0
Local _nVlrAbat    	:= 0
Local c_Titulo		:= ""
Local _nVlrDesc    	:= 0
Local _nVlrCred    	:= 0

//Posiciona o SA6 (Bancos)
DbSelectArea("SA6")
DbSetOrder(1)
If	!DbSeek(xFilial("SA6")+c_Banco+c_Agen+c_Cta,.T.)
	Msgbox("Banco/agencia/conta n�o localizado!")
	Return
Endif

//Posiciona na Arq de Parametros CNAB
DbSelectArea("SEE")
DbSetOrder(1)
If	!DbSeek(xFilial("SEE")+c_Banco+c_Agen+c_Cta+c_Subc,.T.)
	Msgbox("Parametros de banco n�o localizado!")
	Return
Endif

oPrint:= TMSPrinter():New( "Boleto Laser" )
oPrint:Setup()
oPrint:SetPortrait() // ou SetLandscape()
oPrint:SetPaperSize( DMPAPER_A4 )
oPrint:StartPage()   // Inicia uma nova p�gina

DbSelectArea("TTRB")
TTRB->(dbGoTop())
While TTRB->(!EOF())
	nRec := nRec + 1
	TTRB->(dbSkip())
EndDo
dbGoTop()

ProcRegua(nRec)

Do While TTRB->(!EOF())

	If TTRB->OK = cMark
		cCart   := Alltrim(SEE->EE_CODCART)
	    DBSELECTAREA("TTRB")
		//Posiciona o SA1 (Cliente)
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial("SA1")+TTRB->E1_CLIENTE+TTRB->E1_LOJA)

		DbSelectArea("TTRB")
		aDadosBanco  := {Alltrim(SA6->A6_COD)           		                ,; // [1]Numero do Banco
	   	            	 SA6->A6_NOME      	            	                    ,; // [2]Nome do Banco
	    	             SUBSTR(SA6->A6_AGENCIA, 1, 4)                          ,; // [3]Ag�ncia
	        	         Subs(SA6->A6_NUMCON,1,7)    							,; // [4]Conta Corrente
	            	     SA6->A6_DVCTA                                          ,; // [5]D�gito da conta corrente
	                	 cCart                                            		,; // [6]Codigo da Carteira
						 Subs(SA6->A6_DVAGE,1,1)    							}  // [7]Digito da Agencia

		If Empty(SA1->A1_ENDCOB)
			aDatSacado   := {AllTrim(SA1->A1_NOME)                            ,;     // [1]Raz�o Social
			                 AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;     // [2]C�digo
			                 AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;     // [3]Endere�o
			                 AllTrim(SA1->A1_MUN )                             ,;     // [4]Cidade
			                 SA1->A1_EST                                       ,;     // [5]Estado
			                 SA1->A1_CEP                                       ,;     // [6]CEP
			                 SA1->A1_CGC									   ,;     // [7]CGC
			                 SA1->A1_PESSOA									  }       // [8]CGC
		Else
			aDatSacado   := {AllTrim(SA1->A1_NOME)                               ,;   // [1]Raz�o Social
			                 AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   // [2]C�digo
			                 AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   // [3]Endere�o
			                 AllTrim(SA1->A1_MUNC)	                              ,;   // [4]Cidade
			                 SA1->A1_ESTC	                                      ,;   // [5]Estado
			                 SA1->A1_CEPC                                         ,;   // [6]CEP
			                 SA1->A1_CGC									   ,;     // [7]CGC
			                 SA1->A1_PESSOA									  }       // [8]CGC
		Endif

		DbSelectArea("SE1")
		DBSETORDER(1)
		DBSEEK(XFILIAL("SE1")+TTRB->E1_PREFIXO+TTRB->E1_NUM+TTRB->E1_PARCELA+TTRB->E1_TIPO)

		_nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
		_nVlrDesc   :=  SE1->E1_DECRESC
		_nVlrCred   :=  SE1->E1_ACRESC

		CB_RN_NN    :=Ret_cBarra(aDadosBanco[1], aDadosBanco[3], aDadosBanco[4], aDadosBanco[5], (SE1->E1_SALDO-_nVlrAbat), aDadosBanco[6], "9")

		c_Titulo := If(!Empty(SE1->E1_NFELETR),SE1->E1_NFELETR,SE1->E1_NUM)
//		aDadosTit    := {AllTrim(SE1->E1_NUM)+AllTrim(SE1->E1_PARCELA)							,;  // [1] N�mero do t�tulo

		aDadosTit    := {AllTrim(c_Titulo)+AllTrim(SE1->E1_PARCELA)							,;  // [1] N�mero do t�tulo
	                    SE1->E1_EMISSAO                              					,;  // [2] Data da emiss�o do t�tulo
	                    Date()                                  					,;  // [3] Data da emiss�o do boleto
	                    SE1->E1_VENCTO                 					,;  // [4] Data do vencimento
	                    (SE1->E1_SALDO-_nVlrAbat)   				               					,;  // [5] Valor do t�tulo
	                    CB_RN_NN[3]                             					,;  // [6] Nosso n�mero (Ver f�rmula para calculo)
	                    SE1->E1_PREFIXO                               					,;  // [7] Prefixo da NF
	                    SE1->E1_TIPO	                               						,;   // [8] Tipo do Titulo
						SE1->E1_DECRESC	                               						}  // [9] Tipo do Titulo

		Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,CB_RN_NN,nMulta,nJuros)
		n := n + 1

//		l_ok := oPrint:SaveAllAsJpeg( '\bol'+strzero(n,3), 1120, 840, 140, 100 )
    EndIf

	DbSelectArea("TTRB")
	TTRB->(dbSkip())
	IncProc()
	nMark++
EndDo

//oPrint:Print()
//oPrint:EndPage()     // Finaliza a p�gina
oPrint:Preview()     // Visualiza antes de imprimir
Return nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  Impress � Autor �                       � Data � 01/08/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Clientes Microsiga                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,CB_RN_NN,nMulta,nJuros)
LOCAL oFont8
LOCAL oFont11c
LOCAL oFont10
LOCAL oFont14
LOCAL oFont16n
LOCAL oFont15
LOCAL oFont14n
LOCAL oFont24
LOCAL nI := 0
//Local nTxPerm := GetMV('MV_TXPER') 

//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)

oFont8  := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11  := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont9   := TFont():New("Arial",9,9,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14  := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16  := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

oPrint:StartPage()   // Inicia uma nova p�gina

/******************/
/* PRIMEIRA PARTE */
/******************/

nRow1 := 0
 
oPrint:Line (nRow1+0150,500,nRow1+0070, 500)
oPrint:Line (nRow1+0150,710,nRow1+0070, 710)

oPrint:Say  (nRow1+0084,100,aDadosBanco[2],oFont9 )	// [2]Nome do Banco
oPrint:Say  (nRow1+0075,513,aDadosBanco[1]+"-7",oFont16 )		// [1]Numero do Banco

oPrint:Say  (nRow1+0084,1850,"Comprovante de Entrega",oFont10)
oPrint:Line (nRow1+0150,100,nRow1+0150,2300)

oPrint:Say  (nRow1+0150,100,"Benefici�rio",oFont8)
oPrint:Say  (nRow1+0200,100,aDadosEmp[1],oFont9)				//Nome + CNPJ

oPrint:Say  (nRow1+0150,1060,"Ag�ncia/C�digo Benefici�rio",oFont8)
oPrint:Say  (nRow1+0200,1060,SUBSTR(aDadosBanco[3],1,4)+"-"+aDadosBanco[7]+"/"+ALLTRIM(aDadosBanco[4])+"-"+aDadosBanco[5],oFont10)

oPrint:Say  (nRow1+0150,1510,"Nro.Documento",oFont8)
oPrint:Say  (nRow1+0200,1510,aDadosTit[1],oFont10) //Numero+Parcela

oPrint:Say  (nRow1+0250,100 ,"Nome do Pagador",oFont8)
oPrint:Say  (nRow1+0300,100 ,subs(aDatSacado[1],1,38),oFont10)				//Nome

oPrint:Say  (nRow1+0250,1060,"Vencimento",oFont8)
oPrint:Say  (nRow1+0300,1060,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)

oPrint:Say  (nRow1+0250,1510,"Valor do Documento",oFont8)
oPrint:Say  (nRow1+0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say  (nRow1+0400,0100,"ESTE BOLETO REPRESENTA DUPLICATA CEDIDA FIDUCIARIAMENTE AO BANCO DO BRASIL,",oFont10)
oPrint:Say  (nRow1+0450,0100,"FICANDO VEDADO O PAGAMENTO DE QUALQUER OUTRA FORMA QUE N�O ATRAV�S DO PRESENTE BOLETO.",oFont10)

oPrint:Line (nRow1+0250, 100,nRow1+0250,2300 )
oPrint:Line (nRow1+0350, 100,nRow1+0350,2300 )
oPrint:Line (nRow1+0550, 100,nRow1+0550,2300 )

oPrint:Line (nRow1+0350,1050,nRow1+0150,1050 )
oPrint:Line (nRow1+0350,1500,nRow1+0150,1500 ) 

          

/*****************/
/* SEGUNDA PARTE */
/*****************/

nRow2 := 0

//Pontilhado separador
For nI := 100 to 2300 step 50
	oPrint:Line(nRow2+0580, nI,nRow2+0580, nI+30)
Next nI

oPrint:Line (nRow2+0710,100,nRow2+0710,2300)
oPrint:Line (nRow2+0710,500,nRow2+0630, 500)
oPrint:Line (nRow2+0710,710,nRow2+0630, 710)

//oPrint:sayBitmap(0600, 100, "Logo_bb.BMP", 320, 100)
oPrint:Say  (nRow2+0644,100,aDadosBanco[2],oFont9 )		// [2]Nome do Banco
oPrint:Say  (nRow2+0635,513,aDadosBanco[1]+"-7",oFont16 )	// [1]Numero do Banco
oPrint:Say  (nRow2+0644,755,CB_RN_NN[2],oFont15n)			//	Linha Digitavel do Codigo de Barras

oPrint:Line (nRow2+0810,100,nRow2+0810,2300 )
oPrint:Line (nRow2+0910,100,nRow2+0910,2300 )
oPrint:Line (nRow2+0980,100,nRow2+0980,2300 )
oPrint:Line (nRow2+1050,100,nRow2+1050,2300 )

oPrint:Line (nRow2+0910,500,nRow2+1050,500)
oPrint:Line (nRow2+0980,750,nRow2+1050,750)
oPrint:Line (nRow2+0910,1000,nRow2+1050,1000)
oPrint:Line (nRow2+0910,1300,nRow2+0980,1300)
oPrint:Line (nRow2+0910,1480,nRow2+1050,1480)

oPrint:Say  (nRow2+0710,100 ,"Local de Pagamento",oFont8)
oPrint:Say  (nRow2+0750,100 ,"PAG�VEL EM QUALQUER BANCO DO SISTEMA DE COMPENSA��O",oFont8)
oPrint:Say  (nRow2+0765,400 ,"",oFont10)

oPrint:Say  (nRow2+0710,1810,"Vencimento"                                     ,oFont8)
cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+0750,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0810,100 ,"Benefici�rio"                                        ,oFont8)
oPrint:Say  (nRow2+0840,100 ,aDadosEmp[1]+" - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
oPrint:Say  (nRow2+0875,100 ,aDadosEmp[2]+" "+aDadosEmp[3]	,oFont8) //Endereco

oPrint:Say  (nRow2+0810,1810,"Ag�ncia/C�digo Benefici�rio",oFont8)
cString := SUBSTR(aDadosBanco[3],1,4)+"-"+aDadosBanco[7]+"/"+ALLTRIM(aDadosBanco[4])+"-"+aDadosBanco[5]
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+0850,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0910,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say  (nRow2+0940,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

oPrint:Say  (nRow2+0910,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (nRow2+0940,605 ,aDadosTit[1]						,oFont10) //Numero+Parcela

oPrint:Say  (nRow2+0910,1005,"Esp�cie Doc."                                   ,oFont8)
oPrint:Say  (nRow2+0940,1050,"DS"										,oFont10) //Tipo do Titulo

oPrint:Say  (nRow2+0910,1305,"Aceite"                                         ,oFont8)
oPrint:Say  (nRow2+0940,1400,"N"                                             ,oFont10)

oPrint:Say  (nRow2+0910,1485,"Data do Processamento"                          ,oFont8)
oPrint:Say  (nRow2+0940,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao

oPrint:Say  (nRow2+0910,1810,"Nosso N�mero"                                   ,oFont8)
oPrint:Say  (nRow2+0940,1850,Alltrim(aDadosTit[6])                            ,oFont10)

oPrint:Say  (nRow2+0980,100 ,"Uso do Banco"                                   ,oFont8)

oPrint:Say  (nRow2+0980,505 ,"Carteira"                                       ,oFont8)
oPrint:Say  (nRow2+1010,555 ,aDadosBanco[6]                             	 ,oFont10)

oPrint:Say  (nRow2+0980,755 ,"Esp�cie"                                        ,oFont8)
oPrint:Say  (nRow2+1010,805 ,"R$"                                             ,oFont10)

oPrint:Say  (nRow2+0980,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (nRow2+0980,1485,"Valor"                                          ,oFont8)

oPrint:Say  (nRow2+0980,1810,"Valor do Documento"                          	,oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+1010,nCol,cString ,oFont11c)

oPrint:Say  (nRow2+1050,100 ,"Instru��es (Todas informa��es deste bloqueto s�o de exclusiva responsabilidade do benefici�rio)",oFont8)

IF aDadosTit[9] = 0
oPrint:Say  (nRow2+1130,100 ,"AP�S VENCIMENTO COBRAR MULTA DE R$ "+AllTrim(Transform((aDadosTit[5]*nMulta)/100,"@E 99,999.99")),oFont10)
ELSE
oPrint:Say  (nRow2+1130,100 ,"AP�S VENCIMENTO COBRAR MULTA DE R$ "+AllTrim(Transform((aDadosTit[5]*nMulta)/100,"@E 99,999.99"))+" APLICAR DESCONTO DE R$ "+AllTrim(Transform((aDadosTit[9]),"@E 99,999.99")),oFont10)
END IF
oPrint:Say  (nRow2+1180,100 ,"AP�S VENCIMENTO COBRAR JUROS DE MORA R$ "+AllTrim(Transform(((aDadosTit[5]*nJuros)/100),"@E 99,999.99"))+" POR DIA DE ATRASO",oFont10)
//oPrint:Say  (nRow2+1250,100 ,"PROTESTAR AP�S 10 DIAS DO VENCIMENTO",oFont10)
oPrint:Say  (nRow2+1230,100 ,"N�O ACEITAMOS DEP�SITO PARA LIQUIDA��O DO T�TULO.",oFont10)
oPrint:Say  (nRow2+1280,100 ,"QUALQUER ALTERA��O NA DATA DE VENCIMENTO SER� COBRADO TAXA ADICIONAL.",oFont10)
oPrint:Say  (nRow2+1330,100 ,"NEGATIVA��O NO SERASA E PROTESTO AUTOM�TICO AP�S O VENCIMENTO.",oFont10)

oPrint:Say  (nRow2+1050,1810,"(-)Desconto/Abatimento"                         ,oFont8)
oPrint:Say  (nRow2+1120,1810,"(-)Outras Dedu��es"                             ,oFont8)

oPrint:Say  (nRow2+1190,1810,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (nRow2+1260,1810,"(+)Outros Acr�scimos"                           ,oFont8)
oPrint:Say  (nRow2+1330,1810,"(=)Valor Cobrado"                               ,oFont8)

oPrint:Say  (nRow2+1400,100 ,"Nome do Pagador"                                ,oFont8)
oPrint:Say  (nRow2+1430,470 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
oPrint:Say  (nRow2+1483,470 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (nRow2+1536,470 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

if aDatSacado[8] = "J"
	oPrint:Say  (nRow2+1589,470 ,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
Else
	oPrint:Say  (nRow2+1589,470 ,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
EndIf

oPrint:Say  (nRow2+1589,1750,Alltrim(aDadosTit[6])  ,oFont10)

oPrint:Say  (nRow2+1605,100 ,"Sacador/Avalista",oFont8)
oPrint:Say  (nRow2+1645,1500,"Autentica��o Mec�nica",oFont8)
oPrint:Say  (nRow2+1645,1800,"Recibo do Pagador",oFont8)

oPrint:Line (nRow2+0710,1800,nRow2+1400,1800 ) 
oPrint:Line (nRow2+1120,1800,nRow2+1120,2300 )
oPrint:Line (nRow2+1190,1800,nRow2+1190,2300 )
oPrint:Line (nRow2+1260,1800,nRow2+1260,2300 )
oPrint:Line (nRow2+1330,1800,nRow2+1330,2300 )
oPrint:Line (nRow2+1400,100 ,nRow2+1400,2300 )
oPrint:Line (nRow2+1640,100 ,nRow2+1640,2300 )
//MSBAR3("INT25",nRow2+1350,nRow2+100,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)          
//MSBAR3("INT25",25,1,aCB_RN_NN[1],oPrint,.F.,,.T.,0.028,1.13,Nil,Nil,Nil,.F.)

//////////////////////////oPrint:Line (nRow3+2850,100,nRow3+2850,2300  )

/******************/
/* TERCEIRA PARTE */
/******************/

nRow3 := 0

For nI := 100 to 2300 step 50
	oPrint:Line(nRow3+1880, nI, nRow3+1880, nI+30)
Next nI

oPrint:Line (nRow3+2000,100,nRow3+2000,2300)
oPrint:Line (nRow3+2000,500,nRow3+1920, 500)
oPrint:Line (nRow3+2000,710,nRow3+1920, 710)

//oPrint:sayBitmap(1904, 100, "Logo_bb.BMP", 320, 100)
oPrint:Say  (nRow3+1934,100,aDadosBanco[2],oFont9 )		// 	[2]Nome do Banco
oPrint:Say  (nRow3+1925,513,aDadosBanco[1]+"-7",oFont16 )	// 	[1]Numero do Banco
oPrint:Say  (nRow3+1934,755,CB_RN_NN[2],oFont15n)			//	Linha Digitavel do Codigo de Barras

oPrint:Line (nRow3+2100,100,nRow3+2100,2300 )
oPrint:Line (nRow3+2200,100,nRow3+2200,2300 )
oPrint:Line (nRow3+2270,100,nRow3+2270,2300 )
oPrint:Line (nRow3+2340,100,nRow3+2340,2300 )

oPrint:Line (nRow3+2200,500 ,nRow3+2340,500 )
oPrint:Line (nRow3+2270,750 ,nRow3+2340,750 )
oPrint:Line (nRow3+2200,1000,nRow3+2340,1000)
oPrint:Line (nRow3+2200,1300,nRow3+2270,1300)
oPrint:Line (nRow3+2200,1480,nRow3+2340,1480)

oPrint:Say  (nRow3+2000,100 ,"Local de Pagamento",oFont8)
oPrint:Say  (nRow3+2040,100 ,"PAG�VEL EM QUALQUER BANCO DO SISTEMA DE COMPENSA��O",oFont8)
oPrint:Say  (nRow3+2055,400 ,"",oFont10)
           
oPrint:Say  (nRow3+2000,1810,"Vencimento",oFont8)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol	 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2040,nCol,cString,oFont11c)

oPrint:Say  (nRow3+2100,100 ,"Benefici�rio",oFont8)
oPrint:Say  (nRow3+2140,100 ,aDadosEmp[1]+" - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (nRow3+2100,1810,"Ag�ncia/C�digo Benefici�rio",oFont8)
cString := SUBSTR(aDadosBanco[3],1,4)+"-"+aDadosBanco[7]+"/"+ALLTRIM(aDadosBanco[4])+"-"+aDadosBanco[5]
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2140,nCol,cString ,oFont11c)

oPrint:Say  (nRow3+2200,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say (nRow3+2230,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)


oPrint:Say  (nRow3+2200,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (nRow3+2230,605 ,aDadosTit[1]						,oFont10) //Numero+Parcela

oPrint:Say  (nRow3+2200,1005,"Esp�cie Doc."                                   ,oFont8)
oPrint:Say  (nRow3+2230,1050,"DS"										,oFont10) //Tipo do Titulo

oPrint:Say  (nRow3+2200,1305,"Aceite"                                         ,oFont8)
oPrint:Say  (nRow3+2230,1400,"N"                                             ,oFont10)

oPrint:Say  (nRow3+2200,1485,"Data do Processamento"                          ,oFont8)
oPrint:Say  (nRow3+2230,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao


oPrint:Say  (nRow3+2200,1810,"Nosso N�mero"                                   ,oFont8)
oPrint:Say  (nRow3+2230,1850,Alltrim(aDadosTit[6])                   ,oFont10)

oPrint:Say  (nRow3+2270,100 ,"Uso do Banco"                                   ,oFont8)

oPrint:Say  (nRow3+2270,505 ,"Carteira"                                       ,oFont8)
oPrint:Say  (nRow3+2300,555 ,aDadosBanco[6]                                   ,oFont10)

oPrint:Say  (nRow3+2270,755 ,"Esp�cie"                                        ,oFont8)
oPrint:Say  (nRow3+2300,805 ,"R$"                                             ,oFont10)

oPrint:Say  (nRow3+2270,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (nRow3+2270,1485,"Valor"                                          ,oFont8)

oPrint:Say  (nRow3+2270,1810,"Valor do Documento"                          	,oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2300,nCol,cString,oFont11c)

oPrint:Say  (nRow3+2340,100 ,"Instru��es (Todas informa��es deste bloqueto s�o de exclusiva responsabilidade do benefici�rio)",oFont8)
IF aDadosTit[9] = 0
oPrint:Say  (nRow2+2420,100 ,"AP�S VENCIMENTO COBRAR MULTA DE R$ "+AllTrim(Transform((aDadosTit[5]*nMulta)/100,"@E 99,999.99")),oFont10)
ELSE
oPrint:Say  (nRow2+2420,100 ,"AP�S VENCIMENTO COBRAR MULTA DE R$ "+AllTrim(Transform((aDadosTit[5]*nMulta)/100,"@E 99,999.99"))+" APLICAR DESCONTO DE R$ "+AllTrim(Transform((aDadosTit[9]),"@E 99,999.99")),oFont10)
END IF
oPrint:Say  (nRow2+2470,100 ,"AP�S VENCIMENTO COBRAR JUROS DE R$ "+AllTrim(Transform(((aDadosTit[5]*nJuros)/100),"@E 99,999.99"))+" AO DIA",oFont10)
//oPrint:Say  (nRow2+2540,100 ,"PROTESTAR AP�S 10 DIAS DO VENCIMENTO",oFont10)
oPrint:Say  (nRow2+2520,100 ,"N�O ACEITAMOS DEP�SITO PARA LIQUIDA��O DO T�TULO.",oFont10)
oPrint:Say  (nRow2+2570,100 ,"QUALQUER ALTERA��O NA DATA DE VENCIMENTO SER� COBRADO TAXA ADICIONAL.",oFont10)
oPrint:Say  (nRow2+2620,100 ,"NEGATIVA��O NO SERASA E PROTESTO AUTOM�TICO AP�S O VENCIMENTO.",oFont10)

oPrint:Say  (nRow3+2340,1810,"(-)Desconto/Abatimento"                         ,oFont8)
oPrint:Say  (nRow3+2410,1810,"(-)Outras Dedu��es"                             ,oFont8)
oPrint:Say  (nRow3+2480,1810,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (nRow3+2550,1810,"(+)Outros Acr�scimos"                           ,oFont8)
oPrint:Say  (nRow3+2620,1810,"(=)Valor Cobrado"                               ,oFont8)

oPrint:Say  (nRow3+2690,100 ,"Nome do Pagador"                                         ,oFont8)
oPrint:Say  (nRow3+2700,470 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)

oPrint:Say  (nRow3+2753,470 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (nRow3+2806,470 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

if aDatSacado[8] = "J"
	oPrint:Say  (nRow2+2859,470 ,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
Else
	oPrint:Say  (nRow2+2859,470 ,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
EndIf

oPrint:Say  (nRow3+2859,1750,Alltrim(aDadosTit[6])  ,oFont10)

oPrint:Say  (nRow3+2872,100 ,"Sacador/Avalista"                               ,oFont8)
oPrint:Say  (nRow3+2930,1500,"Autentica��o Mec�nica - Ficha de Compensa��o"                        ,oFont8)

oPrint:Line (nRow3+2000,1800,nRow3+2690,1800 )
oPrint:Line (nRow3+2410,1800,nRow3+2410,2300 )
oPrint:Line (nRow3+2480,1800,nRow3+2480,2300 )
oPrint:Line (nRow3+2550,1800,nRow3+2550,2300 )
oPrint:Line (nRow3+2620,1800,nRow3+2620,2300 )
oPrint:Line (nRow3+2690,100 ,nRow3+2690,2300 )
oPrint:Line (nRow3+2920,100 ,nRow3+2920,2300  )

MsBar("INT25"  ,nCB1Linha,nCBColuna,CB_RN_NN[1]  ,oPrint,.F.,,,nCBLargura,nCBAltura,,,,.F.)
MsBar("INT25"  ,nCB2Linha,nCBColuna,CB_RN_NN[1]  ,oPrint,.F.,,,nCBLargura,nCBAltura,,,,.F.)
  
MsUnlock()

oPrint:EndPage() // Finaliza a p�gina

Return Nil

Static Function Ret_cBarra(	cBanco, cAgencia, cConta, cDacCC, nValor, cCart, cMoeda	)

Local cNosso		:= ""
Local cDigNosso		:= ""
Local NNUM			:= ""
Local cCampoL		:= ""
Local cFatorValor	:= ""
Local cLivre		:= ""
Local cDigBarra		:= ""
Local cBarra		:= ""
Local cParte1		:= ""
Local cDig1			:= ""
Local cParte2		:= ""
Local cDig2			:= ""
Local cParte3		:= ""
Local cDig3			:= ""
Local cParte4		:= ""
Local cParte5		:= ""
Local cDigital		:= ""
Local aRet			:= {}

//DEFAULT nValor := 0

cAgencia:=STRZERO(Val(cAgencia),4)
		
If 	Empty(SE1->E1_NUMBCO) .or. l_GeraNN	//MV_PAR15 = 2 //Sobrepoe Nosso Numero
	RecLock("SEE",.F.)
		SEE->EE_FAXATU:=Strzero(Val(SEE->EE_FAXATU)+1,10)
	MsUnlock()

	NNUM      := STRZERO(Val(SEE->EE_FAXATU),10)
	cNosso    := Alltrim(SEE->EE_CODEMP) + NNUM
	cDigNosso := U_CALC_di9(cNosso)
              
	dbSelectArea("SE1")
	RecLock("SE1",.F.)    
		SE1->E1_NUMBCO := NNUM
		SE1->E1_NUMDV  := cDigNosso
		SE1->E1_PORTADO := '001'
	MsUnlock()
Else
	cNosso     := Alltrim(SEE->EE_CODEMP) + Alltrim(SE1->E1_NUMBCO)
	cDigNosso  := SE1->E1_NUMDV
Endif
cAgencia:=STRZERO(Val(cAgencia),4)
cConta  :=STRZERO(Val(cConta),8)
cCampoL := "000000" + cNosso + "17"

//campo livre do codigo de barra                   // verificar a conta
If nValor > 0
	cFatorValor  := u_fatorbb()+strzero(nValor*100,10)
Else
	cFatorValor  := u_fatorbb()+strzero(SE1->E1_VALOR*100,10)
Endif

/* 
COMPOSI�AO DO C�DIGO DE BARRAS
POSI��ES  DESCRI��O
01 a 03   C�digo do Banco na C�mara de Compensa��o = '001' 
04 a 04   C�digo da Moeda = 9 (Real)
05 a 05   Digito Verificador (DV) do c�digo de Barras
06 a 09   Fator de Vencimento
10 a 19   Valor
20 a 44   Campo Livre
*/

cLivre := "001" + "9" + cFatorValor + cCampoL

// campo do codigo de barra
cDigBarra := U_CALC_5p(cLivre)          

cBarra    := Substr(cLivre,1,4)+cDigBarra+Substr(cLivre,5,40)

//msgbox(cBarra + "-" + "cod barras") //mostra o nosso n�mero - PAULO QUEIROZ

// composicao da linha digitavel
cParte1  := cBanco+cMoeda
cParte1  := cParte1 + SUBSTR(cCampoL,1,5)
cDig1    := U_DIGIT001( cParte1 )
cParte2  := SUBSTR(cCampoL,6,10)
cDig2    := U_DIGIT001( cParte2 )
cParte3  := SUBSTR(cCampoL,16,10)
cDig3    := U_DIGIT001( cParte3 )
cParte4  := " "+cDigBarra+" "
cParte5  := cFatorValor

cDigital := substr(cParte1,1,5)+"."+substr(cparte1,6,4)+cDig1+" "+;
			substr(cParte2,1,5)+"."+substr(cparte2,6,5)+cDig2+" "+;
			substr(cParte3,1,5)+"."+substr(cparte3,6,5)+cDig3+" "+;
			cParte4+cParte5

Aadd(aRet,cBarra)
Aadd(aRet,cDigital)
Aadd(aRet,cNosso)		
Aadd(aRet,cDigNosso)		

Return aRet

User Function CALC_di9(cVariavel)
Local Auxi := 0, sumdig := 0

cbase  := cVariavel
lbase  := LEN(cBase)
base   := 9
sumdig := 0
Auxi   := 0
iDig   := lBase
While iDig >= 1
	If base == 1
		base := 9
	EndIf
	auxi   := Val(SubStr(cBase, idig, 1)) * base
	sumdig := SumDig+auxi
	base   := base - 1
	iDig   := iDig-1
EndDo
auxi := mod(Sumdig,11)
If auxi == 10
	auxi := "X"
Else
	auxi := str(auxi,1,0)
EndIf
Return(auxi)

User function Fatorbb()

If Len(ALLTRIM(SUBSTR(DTOC(SE1->E1_VENCTO),7,4))) = 4
	cData := SUBSTR(DTOC(SE1->E1_VENCTO),7,4)+SUBSTR(DTOC(SE1->E1_VENCTO),4,2)+SUBSTR(DTOC(SE1->E1_VENCTO),1,2)
Else
	cData := "20"+SUBSTR(DTOC(SE1->E1_VENCTO),7,2)+SUBSTR(DTOC(SE1->E1_VENCTO),4,2)+SUBSTR(DTOC(SE1->E1_VENCTO),1,2)
EndIf
cFator := STR(1000+(STOD(cData)-STOD("20000703")),4)
Return(cFator)

User Function CALC_5p(cVariavel)
Local Auxi := 0, sumdig := 0

cbase  := cVariavel
lbase  := LEN(cBase)
base   := 2
sumdig := 0
Auxi   := 0
iDig   := lBase
While iDig >= 1
	If base >= 10
		base := 2
	EndIf
	auxi   := Val(SubStr(cBase, idig, 1)) * base
	sumdig := SumDig+auxi
	base   := base + 1
	iDig   := iDig-1
EndDo
auxi := mod(sumdig,11)
If auxi == 0 .or. auxi == 1 .or. auxi >= 10
	auxi := 1
Else
	auxi := 11 - auxi
EndIf

Return(str(auxi,1,0))

User Function DIGIT001(cVariavel)
Local Auxi := 0, sumdig := 0

cbase  := cVariavel
lbase  := LEN(cBase)
umdois := 2
sumdig := 0
Auxi   := 0
iDig   := lBase
While iDig >= 1
	auxi   := Val(SubStr(cBase, idig, 1)) * umdois
	sumdig := SumDig+If (auxi < 10, auxi, (auxi-9))
	umdois := 3 - umdois
	iDig:=iDig-1
EndDo
cValor:=AllTrim(STR(sumdig,12))


// Pelo pessoal da Microsiga n�o existia a linha abaixo
if sumdig<10
  nDezena=10
else 
  nDezena:=VAL(ALLTRIM(STR(VAL(SUBSTR(cvalor,1,1))+1,12))+"0")
endif
//// Aqui termina as modifica��es
  
auxi := nDezena - sumdig

If auxi >= 10
	auxi := 0
EndIf
Return(str(auxi,1,0))

************************
Static Function CriaPerg
************************
Local aRegs   := {}
Local i, j
cPerg := PADR(cPerg,10)

dbSelectArea("SX1")
dbSetOrder(1)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Banco         ?","","","mv_ch1","C",03,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SA6"})
aAdd(aRegs,{cPerg,"02","Agencia       ?","","","mv_ch2","C",05,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Conta         ?","","","mv_ch3","C",10,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","SubConta      ?","","","mv_ch4","C",03,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Da Emissao    ?","","","mv_ch5","D",08,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Ate Emissao	  ?","","","mv_ch6","D",08,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Do Vencimento ?","","","mv_ch7","D",08,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Ate Vencimento?","","","mv_ch8","D",08,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Do Cliente    ?","","","mv_ch9","C",06,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
aAdd(aRegs,{cPerg,"10","Da Loja       ?","","","mv_cha","C",02,0,0,"G","","MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"11","Ate o Cliente ?","","","mv_chb","C",06,0,0,"G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
aAdd(aRegs,{cPerg,"12","Ate Loja      ?","","","mv_chc","C",02,0,0,"G","","MV_PAR12","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"13","Do Numero     ?","","","mv_chd","C",09,0,0,"G","","MV_PAR13","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"14","Ate Numero    ?","","","mv_che","C",09,0,0,"G","","MV_PAR14","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"15","Sobrepoe N.Num?","","","mv_cha","N",01,0,1,"C","","MV_PAR15","Nao","","","","","Sim","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to Len(aRegs[i])
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    Endif
Next

Return

/*  
Banco do Brasil
O c�digo fornecido para a impress�o de boletos do Banco do Brasil em ADVPL � extenso e possui v�rias fun��es e procedimentos importantes para garantir a correta gera��o e impress�o dos boletos. A seguir, apresento uma an�lise detalhada das principais partes do c�digo, incluindo as fun��es principais, fun��es auxiliares e os procedimentos utilizados.

Fun��es Principais

	1. User Function BOLBRASIL(c_SerNf, c_Agen, c_Cta, c_Subc)
		Objetivo: Fun��o principal para gerar boletos do Banco do Brasil.
		Par�metros:
		c_SerNf: S�rie da nota fiscal.
		c_Agen: Ag�ncia banc�ria.
		c_Cta: Conta banc�ria.
		c_Subc: Subconta banc�ria.

	2. Static Function MontaRel(aMarked, c_Banco, c_Agen, c_Cta, c_Subc)
		Objetivo: Monta o relat�rio de boletos para impress�o.
		Par�metros:
		aMarked: Array de registros marcados.
		c_Banco: C�digo do banco.
		c_Agen: Ag�ncia banc�ria.
		c_Cta: Conta banc�ria.
		c_Subc: Subconta banc�ria.
		Descri��o: Configura e imprime os boletos com base nos dados fornecidos.

Fun��es Auxiliares

	1. Static Function Disp()
		Objetivo: Marca os registros que devem ser processados.
		Descri��o: Alterna a marca��o dos registros na tabela tempor�ria TTRB.

	2. Static Function FILMARK()
		Objetivo: Marca ou desmarca todos os registros na tabela tempor�ria TTRB.
		Descri��o: Itera sobre os registros, alternando o valor do campo OK.

	3. Static Function Impress(oPrint, aDadosEmp, aDadosTit, aDadosBanco, aDatSacado, CB_RN_NN, nMulta, nJuros)
		Objetivo: Fun��o de impress�o detalhada do boleto.
		Par�metros:
		oPrint: Objeto de impress�o.
		aDadosEmp: Dados da empresa.
		aDadosTit: Dados do t�tulo.
		aDadosBanco: Dados do banco.
		aDatSacado: Dados do sacado.
		CB_RN_NN: C�digo de barras e linha digit�vel.
		nMulta: Valor da multa.
		nJuros: Valor dos juros.
		Descri��o: Realiza a impress�o do boleto em tr�s partes distintas.

	4. Static Function Ret_cBarra(cBanco, cAgencia, cConta, cDacCC, nValor, cCart, cMoeda)
		Objetivo: Gera o c�digo de barras para o boleto.
		Par�metros:
		cBanco: C�digo do banco.
		cAgencia: C�digo da ag�ncia.
		cConta: N�mero da conta.
		cDacCC: D�gito verificador da conta.
		nValor: Valor do boleto.
		cCart: C�digo da carteira.
		cMoeda: C�digo da moeda.
		Descri��o: Calcula e retorna o c�digo de barras e a linha digit�vel.

	5. User Function CALC_di9(cVariavel)
		Objetivo: Calcula o d�gito verificador usando o m�dulo 11.
		Par�metros: cVariavel - N�mero para c�lculo.
		Descri��o: Realiza a soma ponderada dos d�gitos e calcula o d�gito verificador.

	6. User Function Fatorbb()
		Objetivo: Calcula o fator de vencimento para a linha digit�vel.
		Descri��o: Usa a data base 07/03/2000 para calcular a diferen�a de dias at� a data de vencimento do boleto.

	7. User Function CALC_5p(cVariavel)
		Objetivo: Calcula o d�gito verificador para o c�digo de barras.
		Par�metros: cVariavel - N�mero para c�lculo.
		Descri��o: Realiza a soma ponderada dos d�gitos e calcula o d�gito verificador.

	8. User Function DIGIT001(cVariavel)
		Objetivo: Calcula o d�gito verificador para a linha digit�vel.
		Par�metros: cVariavel - N�mero para c�lculo.
		Descri��o: Realiza a soma ponderada dos d�gitos e calcula o d�gito verificador.

	9. Static Function CriaPerg()
		Objetivo: Cria a estrutura de perguntas para coletar par�metros do usu�rio.
		Descri��o: Adiciona registros na tabela SX1 para armazenar as perguntas e respostas necess�rias para a execu��o do programa.

Fluxo Geral do C�digo

	1.Inicializa��o e Configura��o:
		O programa come�a definindo a estrutura dos dados (_stru) e criando uma tabela tempor�ria TTRB para armazenar os registros a serem processados.
		
	2.Consulta e Marca��o dos Registros:
		Se c_SerNf estiver preenchido, o programa realiza uma consulta na tabela SE1 para obter os registros correspondentes e os marca na tabela TTRB.
		Se c_SerNf estiver vazio, o programa solicita os par�metros ao usu�rio e realiza a consulta com base nesses par�metros.

	3.Processamento dos Registros:
		O programa itera sobre os registros marcados na tabela TTRB e monta o relat�rio de boletos, chamando a fun��o MontaRel.

	4.Impress�o dos Boletos:
		A fun��o Impress � respons�vel pela impress�o detalhada dos boletos, organizando as informa��es e formatando o layout do boleto.

	5.Gera��o do C�digo de Barras e Linha Digit�vel:
		As fun��es Ret_cBarra, CALC_di9, CALC_5p, e DIGIT001 s�o usadas para calcular o c�digo de barras e a linha digit�vel, que s�o essenciais para a valida��o e pagamento dos boletos.

Considera��es Gerais
	Manuten��o de Estado: O c�digo utiliza v�rias vari�veis privadas e locais para manter o estado durante a execu��o.
	Intera��o com o Usu�rio: A fun��o CriaPerg define a interface de perguntas para obter os par�metros de execu��o do usu�rio, garantindo que todas as informa��es necess�rias sejam coletadas antes da execu��o do programa.
	C�lculo de D�gitos Verificadores: As fun��es auxiliares de c�lculo de d�gitos verificadores garantem que os c�digos de barras e linhas digit�veis sejam v�lidos e sigam as normas banc�rias.
	Gerenciamento de Tabelas Tempor�rias: O uso de tabelas tempor�rias (TTRB) facilita o processamento e marca��o dos registros que ser�o utilizados na gera��o dos boletos.

*/
