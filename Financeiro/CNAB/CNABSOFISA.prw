#include "rwmake.ch"    

/*      
PROGRAMA  : CNABSOFISA
DATA      : 25/10/22
DESCRIÇÃO : Retorna a chave da nota fiscal
UTILIZAÇÃO: CNAB sofisa a raceber 
*/   

User Function CNABSOFISA()        

Local chave          := ""	
chave      := Posicione("SF2",1,xFilial("SF2")+SE1->E1_NUM +SE1->E1_PREFIXO+SE1->E1_CLIENTE+SE1->E1_LOJA,"F2_CHVNFE")

STRTRAN(chave,"-","")                                                                                                

RETURN(chave)
