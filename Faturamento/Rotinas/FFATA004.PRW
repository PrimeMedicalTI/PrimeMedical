//Bibliotecas
#Include 'Protheus.ch'
#Include 'RwMake.ch'
#Include 'TopConn.ch'

#DEFINE ENTER CHR( 13 ) + CHR( 10 )

User Function FFATA004()
Local c_Msg1	:= "Para a geração de Danfe/XML, serão consideradas apenas NF autorizadas pela Sefaz."
Local c_Msg2	:= "Para a geração de boletos, serão consideradas apenas as notas com origem em  "
Local c_Msg3	:= "pedidos onde foi indicado os dados bancários para impressão de boletos."
Private cPerg   :="FFATA004"
CriaPerg()

SetPrvt("oFont1","oDlg1","oGrp1","oSay1","oSay2","oGrp2","oSay3","oGet1","oBtn1","oGrp3","oSBtn1","oSBtn2")

oFont1     :=  TFont():New( "Arial Unicode MS",0,-12,,.F.,0,,400,.F.,.F.,,,,,, )

oDlg1      :=  MSDialog():New( 092,235,255,750,"Geração Danfe/XML/Boletos",,,.F.,,,,,,.T.,,oFont1,.T. )

oGrp1      :=  TGroup():New( 004,004,045,256,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      :=  TSay():New( 009,008,{|| c_Msg1 },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,244,008)
oSay2      :=  TSay():New( 020,008,{|| c_Msg2 },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,244,008)
oSay3      :=  TSay():New( 031,008,{|| c_Msg3 },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,244,008)

oGrp3      :=  TGroup():New( 050,004,075,256,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

o_BtIns := TButton():New(057,020,"Danfe/XML",oGrp3,{|| GeraDan('1')},037,012,,oFont1,,.T.,,"",,,,.F. )
o_BtIns := TButton():New(057,080,"Boletos",oGrp3,{|| GeraBol('1')},037,012,,oFont1,,.T.,,"",,,,.F.)
o_BtIns := TButton():New(057,140,"Ambos",oGrp3,{|| GeraAmbos()},037,012,,oFont1,,.T.,,"",,,,.F.)
o_BtIns := TButton():New(057,200,"Fecha",oGrp3,{|| oDlg1:End()},037,012,,oFont1,,.T.,,"",,,,.F.)

oDlg1:Activate(,,,.T.,)

Return

Static Function GeraDan(Opt)
Local a_DocSer := {}

IF  Opt = '1'
    If  !F_Param()
        Return
    Endif
ELSE
    Pergunte(cPerg,.F.)
ENDIF

c_QRY := " SELECT F2_FILIAL, F2_DOC, F2_SERIE " + ENTER
c_QRY += " FROM " + RetSqlName("SF2") + " SF2 " + ENTER
c_QRY += " INNER JOIN " + RetSqlName("SF3") + " SF3 ON (F2_FILIAL = F3_FILIAL AND F2_DOC = F3_NFISCAL AND F2_SERIE = F3_SERIE AND SF3.D_E_L_E_T_ <> '*') " + ENTER
c_QRY += " WHERE SF2.D_E_L_E_T_ <> '*' " + ENTER
c_QRY += " AND F2_FILIAL = '"+xFilial("SF2")+"' " + ENTER
c_QRY += " AND F2_SERIE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' " + ENTER
c_QRY += " AND F2_DOC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' " + ENTER
c_QRY += " AND F2_CLIENTE+F2_LOJA BETWEEN '"+MV_PAR05+MV_PAR06+"' AND '"+MV_PAR07+MV_PAR08+"' " + ENTER
c_QRY += " AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR09)+"' AND '"+DTOS(MV_PAR10)+"' " + ENTER
c_QRY += " ORDER BY F2_DOC, F2_SERIE " + ENTER
If 	Select("QRYREG") <> 0
    QRYREG->(dbCloseArea())
ENDIF

//cAliasA	:= "C:\TEMP\FFATA004DAN"
//MemoWrite( cAliasA+".SQL", c_QRY )

TcQuery c_Qry New Alias QRYREG

QRYREG->( DbGoTop() )
IF	QRYREG->(Eof())
    msgalert("Nenhuma nota encontrada para esta seleção.")	
    Return
ENDIF
Do	While QRYREG->(!Eof())

    AADD(a_DocSer,{QRYREG->F2_DOC, QRYREG->F2_SERIE})

    QRYREG->(DbSkip())
Enddo

U_zGerDanfe(a_DocSer, MV_PAR11)

Return

Static Function GeraBol(Opt)
Local c_SerNf := ''

IF  Opt = '1'
    If  !F_Param()
        Return
    Endif
ELSE
    Pergunte(cPerg,.F.)
ENDIF

c_QRY := " SELECT F2_FILIAL, F2_DOC, F2_SERIE, C5_FSCADM, C5_FSBANCO, C5_FSAGENC, C5_FSCTA, C5_FSSUBCT " + ENTER
c_QRY += " FROM " + RetSqlName("SF2") + " SF2 " + ENTER
c_QRY += " INNER JOIN " + RetSqlName("SC5") + " SC5 ON (F2_FILIAL = C5_FILIAL AND F2_DOC = C5_NOTA AND F2_SERIE = C5_SERIE AND SC5.D_E_L_E_T_ <> '*') " + ENTER
c_QRY += " WHERE SF2.D_E_L_E_T_ <> '*' " + ENTER
c_QRY += " AND F2_FILIAL = '"+xFilial("SF2")+"' " + ENTER
c_QRY += " AND F2_SERIE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' " + ENTER
c_QRY += " AND F2_DOC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' " + ENTER
c_QRY += " AND F2_CLIENTE+F2_LOJA BETWEEN '"+MV_PAR05+MV_PAR06+"' AND '"+MV_PAR07+MV_PAR08+"' " + ENTER
c_QRY += " AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR09)+"' AND '"+DTOS(MV_PAR10)+"' " + ENTER
//c_QRY += " AND C5_FSCADM = '001'  " + ENTER
c_QRY += " AND C5_FSCADM <> ''  " + ENTER
c_QRY += " AND C5_FSBANCO <> '' " + ENTER
c_QRY += " AND C5_FSAGENC <> '' " + ENTER
c_QRY += " AND C5_FSCTA <> '' " + ENTER
c_QRY += " AND C5_FSSUBCT <> '' " + ENTER
c_QRY += " ORDER BY C5_FSBANCO, F2_DOC, F2_SERIE " + ENTER
If 	Select("QRYREG") <> 0
    QRYREG->(dbCloseArea())
ENDIF

//cAliasA	:= "C:\TEMP\FFATA004BOL"
//MemoWrite( cAliasA+".SQL", c_QRY )

TcQuery c_Qry New Alias QRYREG

QRYREG->( DbGoTop() )
IF	QRYREG->(Eof())
    msgalert("Nenhuma nota encontrada para esta seleção.")	
    Return
ENDIF

c_Banco := ''
Do	While QRYREG->(!Eof())
    If  QRYREG->C5_FSBANCO <> c_Banco .or. QRYREG->C5_FSAGENC <> c_Agen .or. QRYREG->C5_FSCTA <> c_Cta .or. QRYREG->C5_FSSUBCT <> c_Subc
        c_Banco := QRYREG->C5_FSBANCO
        c_Agen  := QRYREG->C5_FSAGENC 
        c_Cta   := QRYREG->C5_FSCTA
        c_Subc  := QRYREG->C5_FSSUBCT
        c_SerNf := ''
        While QRYREG->C5_FSBANCO + QRYREG->C5_FSAGENC + QRYREG->C5_FSCTA + QRYREG->C5_FSSUBCT = c_Banco+c_Agen+c_Cta+c_Subc .and. QRYREG->(!Eof())
            If	Len(c_SerNf) > 1
                c_SerNf += ";"	    
            Endif
            c_SerNf += QRYREG->F2_SERIE+QRYREG->F2_DOC 

            QRYREG->(DbSkip())
        End
    Endif
    If  c_Banco = '001'
        U_Bolbrasil(c_SerNf, c_Agen, c_Cta, c_Subc)
    ElseIf  c_Banco = '004'
        U_Bolbnb(c_SerNf, c_Agen, c_Cta, c_Subc)
    ElseIf  c_Banco = '033'
        U_Bolsanta(c_SerNf, c_Agen, c_Cta, c_Subc)
    ElseIf  c_Banco = '237'
        U_Bolbrad(c_SerNf, c_Agen, c_Cta, c_Subc)
    ElseIf  c_Banco = '341'
        U_Bolitau(c_SerNf, c_Agen, c_Cta, c_Subc)
    ElseIf  c_Banco = '748'
        U_Bolsicred(c_SerNf, c_Agen, c_Cta, c_Subc)
    ElseIf  c_Banco = '637'
        U_BOLSOFISA(c_SerNf, c_Agen, c_Cta, c_Subc) 
    Endif
    Enddo
Return

Static Function GeraAmbos()
If  !F_Param()
    Return
Endif

GeraDan('2')
GeraBol('2')

Return

Static Function F_Param()

If  !Pergunte(cPerg,.T.)
    Return(.F.)
EndIf

Return(.T.)

************************
Static Function CriaPerg()
************************
Local aRegs   := {}
Local i, j
cPerg := PADR(cPerg,10)

dbSelectArea("SX1")
dbSetOrder(1)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Serie de        ?","","","mv_ch1","C",03,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Serie ate       ?","","","mv_ch2","C",03,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Nota de         ?","","","mv_ch3","C",09,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Nota ate        ?","","","mv_ch4","C",09,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Cliente de      ?","","","mv_ch5","C",08,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
aAdd(aRegs,{cPerg,"06","Loja de         ?","","","mv_ch6","C",04,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Cliente ate     ?","","","mv_ch7","C",08,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
aAdd(aRegs,{cPerg,"08","Loja ate        ?","","","mv_ch8","C",04,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Emissao de      ?","","","mv_ch9","D",08,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","Emissao ate     ?","","","mv_cha","D",08,0,0,"G","","MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"11","Mostra Danfe    ?","","","mv_chb","N",01,0,0,"C","","MV_PAR11","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","",""})

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

