#Include 'Protheus.ch'
 
User Function MA261IN()
 
Local nPosCampo := aScan(aHeader, {|x| AllTrim(Upper(x[2]))=='D3_OBSERVA'})
 
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Customizacoes de usuario      �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
 
aCols[len(aCols),nPosCampo] := '0'
 
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Customizacoes de usuario      �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
 
Return Nil



