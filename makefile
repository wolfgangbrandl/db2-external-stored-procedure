CC 		= 	/usr/bin/gcc
CC2		= 	/usr/bin/gcc
DATASOURCE      =       SAMPLE
DB2INSTANCEPATH =       /home/$(DB2INSTANCE)
CCFLAGS 	= 	-g -w  -Wunused 
CFLAGS 		= 	-g -w  -Wunused -m64 -fpic
SHRCFLAGS	=	-m64 -fpic -shared -Wl,-rpath,/home/users/db2inst1/sqllib/lib64 -L/home/users/db2inst1/sqllib/lib64
LIBDIR 		= 	-L$(DB2LIB) -ldb2
INCLUDE 	= 	-I$(DB2_HOME)/include
SHELL		=	/bin/bash
REPLVER         :=      $(shell date +%y%m%d%H%M%S)


.SUFFIXES:  .c .sqc
.sqc.c:
	db2 connect to $(DATASOURCE)
	echo VERSION $(REPLVER)
	db2 prep $< bindfile VERSION $(REPLVER)
	cp $*.bnd $*.bnd.tmp
	db2 bind $*.bnd
	cp $@ $@.tmp
	db2 terminate


all : init admcmd proc
init:
	db2 connect to $(DATASOURCE)
	db2 -vtf cr_proc.db
	db2 terminate
proc.c:	proc.sqc
proc:	proc.c
	rm -f $(DB2_HOME)/function/$@
	$(CC) $(CFLAGS) -I$(DB2_HOME)/include -c $< -D_REENTRANT
	$(CC) -o $@ proc.o $(SHRCFLAGS) -ldb2 -lpthread
	cp $@ $(DB2_HOME)/function
admcmd.c:	admcmd.sqc
admcmd:	admcmd.c
	$(CC) $(CCFLAGS) $(INCLUDE) $(LIBDIR) -o $@ $<
iotest: iotest.c
	$(CC) $(CCFLAGS) $(INCLUDE) $(LIBDIR) -o $@ $<
test:
	db2 connect to $(DATASOURCE)
	db2 "select * from DB2INST1.TESTPR"
	db2 terminate
	cat /tmp/output.out

clean:
	rm -f *.c.c *.i *.o *.bnd *.tmp $(OBJ) admcmd admcmd.c *.trc proc *.so proc.c
	> /tmp/output.out
