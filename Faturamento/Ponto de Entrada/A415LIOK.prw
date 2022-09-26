

User Function A415LIOK()

   Local _lOk   := .T.
   
   If TMP1->CK_PRCVEN == 0
       Alert("Nao pode ser cadastrado orcamento com Preco de Venda zerado")
      _lOk := .F.
   EndIf

Return _lOk
