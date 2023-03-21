#Include 'Protheus.ch'
 
User Function MA261IN()
 
Local nPosCampo := aScan(aHeader, {|x| AllTrim(Upper(x[2]))=='D3_OBSERVA'})
 
//зддддддддддддддддддддддддддддддд©
//Ё Customizacoes de usuario      Ё
//юддддддддддддддддддддддддддддддды
 
aCols[len(aCols),nPosCampo] := '0'
 
//зддддддддддддддддддддддддддддддд©
//Ё Customizacoes de usuario      Ё
//юддддддддддддддддддддддддддддддды
 
Return Nil



