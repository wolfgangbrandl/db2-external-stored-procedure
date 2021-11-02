#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sqlda.h>
#include <sqlca.h>
#include <sqludf.h>
#include <sql.h>
#include <memory.h>
#include <syslog.h>

main()
{
  char            filename[]="/tmp/output.out";
  FILE            *pFile;
  char test[]="Hallo";



  /* Copy input parameters to host variables */
  pFile = fopen(filename, "a");
  if (pFile == NULL) {
    printf(">---- ERROR Opening File -------");
  }
  openlog ("slog",LOG_PID|LOG_CONS,LOG_USER);
  syslog (LOG_INFO,"Hallo");
  closelog();

  fprintf(pFile," CLOB %s\n",test);
  fclose (pFile);
  return 4;
}
