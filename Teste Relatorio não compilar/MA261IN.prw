#Include 'Protheus.ch'
 
User Function MA261IN()
 
Local nPosCampo := aScan(aHeader, {|x| AllTrim(Upper(x[2]))=='D3_OBSERVA'})
 
//�������������������������������Ŀ
//� Customizacoes de usuario      �
//���������������������������������
 
aCols[len(aCols),nPosCampo] := '0'
 
//�������������������������������Ŀ
//� Customizacoes de usuario      �
//���������������������������������
 
Return Nil



