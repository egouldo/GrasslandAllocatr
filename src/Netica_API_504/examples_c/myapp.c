#include "Netica.h"
#include <stdlib.h>
#include <stdio.h>
environ_ns* env;
int main (void){
   char mesg[MESG_LEN_ns];
   int res;
   //    Region A ...
env = NewNeticaEnviron_ns (NULL, NULL, NULL);
// replace first NULL above with your license string if desired
   res = InitNetica2_bn (env, mesg);
   printf ("%s\n", mesg);
   if (res < 0)  exit (-1);
   //    Region B ...
   res = CloseNetica_bn (env, mesg);
   printf ("%s\n", mesg);
   if (res < 0)  exit (-1);
   //    Region C ...
}
