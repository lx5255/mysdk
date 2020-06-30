ifdef CFG
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

endif #ifdef CFG
code :=  $(wildcard  ./*.c) 

OUTPUT_DIR := $(shell pwd)/out/${CFG}/
CUR_DIR := $(shell pwd)/
export OUTPUT_DIR
export CUR_DIR


SUBDIRS = common/ os/ # main/ 

.PHONY : $(SUBDIRS)
# SUBDIRS := $(shell ls -l | grep ^d | awk '{print $$9}')

COM_INC := -I$(shell pwd)/common/inc 
COM_INC  +=-I /usr/include
COM_INC  +=-I /usr/lib/gcc-cross/arm-linux-gnueabihf/5/include

export COM_INC

INCLUDEDIR 	:=-I $(shell pwd)

LIBS := main/main.a
LIBS += os/os.a


.PHONY : $(LIBS)

LIBS_A := $(addprefix $(OUTPUT_DIR), $(LIBS))

# CPPFLAGS   	:= -nostdinc $(INCLUDEDIR)
# CPPLIB 			:= -L/tools/gcc-3.4.5-glibc-2.3.6/arm-linux/lib/-static -lgcc_s  
#
# PLATFORM_LIBS += -L $(shell dirname `$(CC) $(CFLAGS) -print-libgcc-file-name`) -lgcc
objs_ex	+= ${patsubst %.c, %.o,$(code)} 
export objs_ex

ALL :=	sdk.bin
all: ${SUBDIRS}	${ALL}
	echo ${SUBDIRS} $< 

sdk.bin: ${LIBS}
	echo ${LIBS}  
	${LD} ${LDLDS} -o ${CFG}.elf   ${LIBS_A}  ${LDFLASG}
	${OBJCOPY} -O binary -S ${CFG}.elf $@
	${OBJDUMP} -D -m  ${CFG}.elf > ${CFG}.dis
	${NM} -v -l ${CFG}.elf > ${CFG}.map

$(SUBDIRS):
	echo $(SUBDIRS) 
	$(MAKE) -C $@ all  

$(LIBS):
	$(MAKE) -C $(dir $(subst ,,$@)) all

%.o:%.c
	${CC}  $(CPPFLAGS) $(CFLAGS)  -c -o $@ $<

%.o:%.S
	${CC} $(CPPFLAGS) $(CFLAGS) -c -o $@ $<

clean:
	@rm -f ${CFG}.bin ${CFG}.elf ${CFG}.dis *.o 
	@rm -f ${LIBS} 
	@find . -depth -name '*.o' -type f -print -exec rm -rf {} \; 

swp:
	find . -depth -name '*.swp' -type f -print -exec rm -rf {} \; 

back:
	bash back.sh
