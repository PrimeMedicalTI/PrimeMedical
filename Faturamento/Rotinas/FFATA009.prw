#include "topconn.ch"
#INCLUDE 'RWMAKE.CH'
#include "protheus.ch"
#include "parmtype.ch"

User Function FFATA009(c_Filial, c_Cod, c_Local, c_Lote, d_DtValid, d_Data)

    // Verifica se o registro está na tabela de saldo SB2
    DbSelectArea("SB2")
    SB2->( DbSetOrder(1))
    SB2->( DbSeek(c_Filial+c_Cod+c_Local))

    // Não encontrou na SB2
    If SB2->( !Found())
        // Grava SB2
        DbSelectArea("SB2")
        RecLock("SB2",.T.)
            SB2->B2_FILIAL  := c_Filial
            SB2->B2_COD     := c_Cod
            SB2->B2_LOCAL   := c_Local
            SB2->B2_STATUS  := '2'
            SB2->B2_TIPO    := '3'
        MsUnlock()
    Endif

    // Verifica se o registro está na tabela de saldo SB8
    DbSelectArea("SB8")
    SB8->( DbSetOrder(3))
    SB8->( DbSeek(c_Filial+c_Cod+c_Local+c_Lote))

    // Não encontrou na SB8
    If SB8->( !Found())

        // Grava SB8
        DbSelectArea("SB8")
        RecLock("SB8",.T.)
            SB8->B8_FILIAL  := c_Filial
            SB8->B8_PRODUTO := c_Cod
            SB8->B8_LOCAL   := c_Local
            SB8->B8_LOTECTL := c_Lote
            SB8->B8_DTVALID := d_DtValid
            SB8->B8_DATA    := d_Data
        MsUnlock()
    Endif
    
Return
