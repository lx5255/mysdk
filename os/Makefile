
INCLUDEDIR 	:= -I$(shell pwd)/inc \

INCLUDEDIR += ${COM_INC}
				
CFLAGS 		+= -Wall -O2
CPPFLAGS   	:= -nostdinc $(INCLUDEDIR)

src :=  $(wildcard  ./*.c)
objs := ${patsubst %.c, %.o,$(src)} 

all: $(objs)
	echo ${COM_INC}

%.o:%.c
	${CC}  $(CPPFLAGS) $(CFLAGS)  -c -o $@ $<


