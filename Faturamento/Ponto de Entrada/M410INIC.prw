function u_M410INIC()

    If FindFunction("MATA103") .And. FWIsInCallStack("A103NFiscal")
        u_FCOMA02B()
    endif

return()
