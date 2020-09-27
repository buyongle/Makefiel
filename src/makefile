##一些基本命令
#.PHONY:sta  #生成静态库文件命令
##文件正常编译
##用此makefile的文件夹目录结构如下：
##Lib_a
##Lib_so
##src

CC      = gcc
CPP     = g++
RM      = rm -rf

## debug flag
DBG_ENABLE   = 1

## source file path
SRC_PATH   := .

## target exec file name
TARGET     := test

## get all source files
SRCS         += $(wildcard $(SRC_PATH)/*.c)  ##将SRC_PATH路径下的所有.c文件累加起来赋给变量SRCS
SRCE := $(wildcard *.c)                      ##将当前文件下的所有.c文件累加起来赋给变量SRCE
LIBNAME=$(SRCE:.c=)                          ##本想通过这种方式获得去掉文件后缀的文件名，好作为后面的库名
STATICLIB=$(SRCE:.c=.a)                      ## 将后缀.c全部换位后缀.a,但是我门只需要生成一个静态库文件，就不需要这样做，就定义一个文件名的静态库文件就可
STATICLIBS +=$(foreach name,$(STATICLIB),lib$(name))   ##将所有的文件加上lib
DYNLIB=$(SRCE:.c=.so)
DYNLIBS +=$(foreach name,$(DYNLIB),lib$(name))
DYNLIB_V=$(SRCE:.c=.so.1)
DYNLIBS_V +=$(foreach name,$(DYNLIB_V),lib$(name))


## all .o based on all .c
OBJS        := $(SRCS:.c=.o)


## need libs, add at here
LIBS := pthread

## used headers  file path
INCLUDE_PATH := .

## used include librarys file path
LIBRARY_PATH :=.

## debug for debug info, when use gdb to debug
ifeq (1, ${DBG_ENABLE}) 
	CFLAGS += -D_DEBUG -O0 -g -DDEBUG=1
endif

## get all include path
CFLAGS  += $(foreach dir, $(INCLUDE_PATH), -I$(dir))

## get all library path
LDFLAGS += $(foreach lib, $(LIBRARY_PATH), -L$(lib))

## get all librarys
LDFLAGS += $(foreach lib, $(LIBS), -l$(lib))

LIBNAME = $(notdir $(shell  pwd))
make_dir:=$(shell pwd)##得到当前文件所在目录的绝对路径
parent_dir_fname:=$(shell pwd)/$(lastword $(MAKEFILE_LIST))##MAKEFILE_LIST所有makefile文件名，lastword 最后一个名字，得到makefile的绝对路径
VERSION_SH	= $(shell pwd)/version.sh $(LIBNAME)
VER	= $(shell $(VERSION_SH); awk '/define\ $(LIBNAME)_version/{print $$3}' version.h)

all: clean build  #make all 先执行clean标签下的内容，再执行build标签下的内容

build:
	$(CC) -c $(CFLAGS) $(SRCS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS) $(LDFLAGS)
	$(RM) $(OBJS)

clean:
	$(RM) $(OBJS) $(TARGET) ../staticlib/$(OBJS)
	rm -rf *.o
	rm -rf ../Lib_so/*.so
	rm -rf ../Lib_so/*.so.1

##二。make static生成静态库文件;从源文件生成静态库文件到静态库目录文件夹

sta:
	 
	$(CC) -c $(SRCE)
	
	ar crs -o ../Lib_a/$(STATICLIBS) $(OBJS)s

##三.make dynamic生成动态库文件;从源文件生成动态库文件到动态库目录文件夹

dyn:
##生成目标文件也即.o文件
	$(CC) -c -fPIC $(SRCE)
##将所有的.o文件在动态库文件夹中链接生成版本号文1的文件
	$(CC) -shared -o ../Lib_so/libmain.so.1 $(OBJS)
##将版本号1的文件与动态库文件关联起来
	ln -s ../Lib_so/libmain.so.1 ../Lib_so/libmain.so

##整个程序的编译包含静态库或动态库的命令;静态库与动态库的使用都是一样的命令
bu:
	gcc $(SRCE) -L../Lib_so/ -L../Lib_a/ -lLib_so -lLib_a -Wl,-rpath=../Lib_so/,-rpath=../Lib_a/   -o $(TARGET)
##上面-L是指编译时库所在的路径（静态库和动态库都一样，这里是动态库用的是相对路径），-l是编译时需要的库文件（静态库和动态库都一样，这里是动态库文件sendmsg,）,-Wl,-rpath=后面接的是运行时
##动态库需要查找的路径（因为默认程序运行时是直接在bash目录下找的）



##下面这个主要是打印一些信息
P:
	
	@echo $(parent_dir_fname)
	@echo $(make_dir)
	@echo $(LIBNAME)
	@echo $(VERSION_SH)
	@echo $(VER)
	@echo $(SRCE)
