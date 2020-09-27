CC	= $(CROSS_PREFIX)gcc
CC_V	= $(CC)

LIBNAME		= $(notdir $(shell  pwd))
VERSION_SH	= $(shell pwd)/version.sh $(LIBNAME)
VER		= $(shell $(VERSION_SH); awk '/define\ $(LIBNAME)_version/{print $$3}' version.h)
TGT_LIB_H	= $(LIBNAME).h
TGT_LIB_A	= $(LIBNAME).a
TGT_LIB_SO	= $(LIBNAME).so
TGT_LIB_SO_VER	= $(TGT_LIB_SO).${VER}
TGT_UNIT_TEST	= test_$(LIBNAME)

OBJS_LIB	= $(LIBNAME).o
OBJS_UNIT_TEST	= test_$(LIBNAME).o
###############################################################################
# cflags and ldflags
###############################################################################

ifeq ($(MODE), release)
CFLAGS	:= -O2 -Wall -Werror -fPIC
LTYPE   := release
else
CFLAGS	:= -g -Wall -Werror -fPIC
LTYPE   := debug
endif
ifeq ($(OUTPUT),/usr/local)
OUTLIBPATH := /usr/local
else
OUTLIBPATH := $(OUTPUT)/$(LTYPE)
endif
CFLAGS	+= $($(ARCH)_CFLAGS)

SHARED	:= -shared

LDFLAGS	:= $($(ARCH)_LDFLAGS)
LDFLAGS	+= -pthread


main: send.o
	$(CC_V)  $^ -o $@
%.o:%.c
	$(CC_V) -c $(CFLAGS) $^ -o $@

clean:
	rm  -rf   *.o