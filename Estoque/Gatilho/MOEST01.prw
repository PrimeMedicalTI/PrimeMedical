#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"    
#INCLUDE "protheus.ch"
#INCLUDE "totvs.ch"

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³ MOCEST01 º Autor ³ Elisângela Souza   º Data ³  22/05/18   º±±
±±ºAjustado  ³ Welington Junior                      º Data ³  28/08/18   º±±
±± Ajustado  ³ Bruno Bouzas/ Francisco Rezende       º Data ³  01/10/19   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDescricao ³ Gatilho para gerar o sequencial do cadastro do produto.    º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ Geral                                                      º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

User Function MOEST01()

    // (4)Grupo + (4)|Sequencial
    Local _xCod         := ""
    Local _xGrupo       := M->B1_GRUPO
    Local _xRef         := M->B1_FSCTRRE
    Local a_AreaB1      := SB1->(GetArea())
    Local a_AreaBM      := SBM->(GetArea())
   // Local c_Alias       := GetNextAlias()

    If _xRef = "N"
        If Len(RTRIM(M->B1_GRUPO)) <> 4
            MsgBox("Utilize o codigo analitico, codigo com 4 caracteres!")
            _xCod := ""
        Else
            cQry := " SELECT TOP 1 SUBSTRING(B1_COD,5,4) SEQ "
            cQry += " FROM " + RetSqlName("SB1")
            cQry += " WHERE B1_FILIAL = '" + xFilial("SB1") + "'"
            cQry += " AND B1_GRUPO    = '" + _xGrupo + "'"
            cQry += " AND B1_FSCTRRE  = 'N' " 
            cQry += " AND D_E_L_E_T_ <> '*' "
            cQry += " ORDER BY B1_COD DESC "

            TcQuery cQry New Alias "QRY"

            DbSelectArea("QRY")
            QRY->( DbGoTop() )

            // Se for final de arquivo
            If QRY->( Eof() )
                _xCod := _xGrupo + "0001"
            Else
                _xCod := _xGrupo + StrZero( ( Val( QRY->SEQ ) + 1 ), 4 )
            Endif

            QRY->( DbCloseArea() )
        Endif
    Else
        _xCod := M->B1_COD
    Endif
    
    RestArea( a_AreaB1 )
    RestArea( a_AreaBM )
Return _xCod
