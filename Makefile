GET_ARCH		 = $(target)

include config/${CFG}/config.mk

ifeq ($(ARCH), x86)
COMPILE =  
LDLDS := 
CFLAGS 			:=  -O2
LIBDIR := /usr/lib/gcc/i686-linux-gnu/5.4.0/
LDFLASG +=  -Lgcc  #-dynamic-linker ${LIBDIR}crtbeginS.o ${LIBDIR}crtendS.o # ${LIBDIR}crtn.o

CC      = ${COMPILE}gcc
LD      = ${COMPILE}gcc
AR      = ${COMPILE}ar
NM      = ${COMPILE}nm
OBJCOPY = ${COMPILE}objcopy
OBJDUMP = ${COMPILE}objdump

else ifeq ($(ARCH), arm)
COMPILE		 = arm-linux-
LDLDS := -Tconfig/${CFG}/ld.lds 
CFLAGS 			:= -WALL -O2
# LDFLASG     := -L $(shell dirname `$(CC) $(CFLAGS) -print-libgcc-file-name`) -lgcc
# LDFLASG    += -L $(shell dirname `$(CC) $(CFLAGS) -print-libgcc-file-name`) -lm
#
CC      = ${COMPILE}gcc
LD      = ${COMPILE}ld
AR      = ${COMPILE}ar
NM      = ${COMPILE}nm
OBJCOPY = ${COMPILE}objcopy
OBJDUMP = ${COMPILE}objdump
else
 	echo ${ARCH}
endif
code :=  $(wildcard  ./*.c) \
		$(wildcard  ./main/*.c) 



INCLUDEDIR 	:=-I $(shell pwd)
INCLUDEDIR  +=-I /usr/include

# CPPFLAGS   	:= -nostdinc $(INCLUDEDIR)
# CPPLIB 			:= -L/tools/gcc-3.4.5-glibc-2.3.6/arm-linux/lib/-static -lgcc_s  
objs 				:= ${patsubst %.c, %.o,$(code)} 

${CFG}.bin: $(objs)
	echo ${ARCH} ${TARGET_x86} 
	${LD} ${LDLDS} -o ${CFG}.elf   $^ ${LDFLASG}
	${OBJCOPY} -O binary -S ${CFG}.elf $@
	${OBJDUMP} -D -m  ${CFG}.elf > ${CFG}.dis
	${NM} -v -l ${CFG}.elf > ${CFG}.map
%.o:%.c
	${CC}  $(CPPFLAGS) $(CFLAGS)  -c -o $@ $<

%.o:%.S
	${CC} $(CPPFLAGS) $(CFLAGS) -c -o $@ $<
clean:
	rm -f ${CFG}.bin ${CFG}.elf ${CFG}.dis *.o 
	find . -depth -name '*.o' -type f -print -exec rm -rf {} \; 

back:
	bash back.sh
