
INCLUDEDIR 	:= $(shell pwd)/inc
CFLAGS 		+= -Wall -O2
CPPFLAGS   	:= -nostdinc -I$(INCLUDEDIR) ${COM_INC}

# lib := libc.a
objs += log/log.o
objs += malloc/malloc.o

all: $(objs)

%.o:%.c
	${CC}  $(CPPFLAGS) $(CFLAGS)  -c -o $@ $<


