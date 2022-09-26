User Function MT103EXC()

  Local l_Ret := .T.

  If !Empty(SF1->F1_FSNUMPV) 
    FwMsgRun(,{|oSay| l_Ret := u_FCOMA02C( SF1->F1_FSNUMPV ) },;
		"Exclusao do Pedido de Venda de Consignação",;
		"Aguarde....Excluindo Pedido.... " + SF1->F1_FSNUMPV )
  Endif
    
Return( l_Ret )
