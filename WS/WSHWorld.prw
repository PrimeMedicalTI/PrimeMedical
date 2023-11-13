#include "TOTVS.CH"
#include "RESTFUL.CH"


WSRESTFUL HelloWorld DESCRIPTION "A simple Hello World service" FORMAT APPLICATION_JSON
  
   WSMETHOD GET DESCRIPTION "Returns Hello World" WSSYNTAX "/helloworld"

END WSRESTFUL

WSMETHOD GET WSSERVICE HelloWorld

   ::cMessage := '{"message": "Hello, World!"}'      

Return .T. 
