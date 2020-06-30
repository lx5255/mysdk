INCLUDEDIR 	:= -I$(shell pwd)/inc 
INCLUDEDIR 	:= -I$(CUR_DIR)/os 

INCLUDEDIR += ${COM_INC}
				
CFLAGS 		+= -Wall -O2
CPPFLAGS   	:= -nostdinc $(INCLUDEDIR)

src :=  $(wildcard  ./*.c)

OBJS := ${patsubst %.c, %.o,$(src)} 

LIB = ${OUTPUT_DIR}main/main.a


all:$(LIB) 

$(LIB):  $(OBJS)
	test -d ${dir $@} || mkdir -p ${dir $@}
	$(AR) $(ARFLAGS) $@ $(OBJS)

%.o:%.c
	${CC}  $(CPPFLAGS) $(CFLAGS)  -c -o $@ $<


