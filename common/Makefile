
INCLUDEDIR 	:= $(shell pwd)/inc
CFLAGS 		+= -Wall -O2
CPPFLAGS   	:= -nostdinc -I$(INCLUDEDIR)
# lib := libc.a
objs += malloc/malloc.o
all: $(objs)

%.o:%.c
	${CC}  $(CPPFLAGS) $(CFLAGS)  -c -o $@ $<


