#
# 'make depend' uses makedepend to automatically generate dependencies 
#               (dependencies are added to end of Makefile)
# 'make'        build executable file 'mycc'
# 'make clean'  removes all .o and executable files
#

# define the C compiler to use
CC = gcc
#CC = mips-openwrt-linux-gcc
#CC = arm-linux-gnueabihf-gcc
#CC = aarch64-linux-gnu-gcc

# define any compile-time flags
#CFLAGS = -Wall -g -O
CFLAGS = -Wall -s -O -static

# define any directories containing header files other than /usr/include
#
#INCLUDES = -I/home/newhall/include  -I../include
INCLUDES =

# define library paths in addition to /usr/lib
#   if I wanted to include libraries not in /usr/lib I'd specify
#   their path using -Lpath, something like:
#LFLAGS = -L/home/newhall/lib  -L../lib
LFLAGS =

# define any libraries to link into executable:
#   if I want to link in libraries (libx.so or libx.a) I use the -llibname 
#   option, something like (this will link in libmylib.so and libm.so:
#LIBS = -lmylib -lm
LIBS =

#define any compiletime functions
FFLAGS = -fopenmp
#FFLAGS =

# define any compile-time definitions
#DFLAGS = -DSTREAM_ARRAY_SIZE=100000	# ~2.3M
#DFLAGS = -DSTREAM_ARRAY_SIZE=1000000	# ~22M
#DFLAGS = -DSTREAM_ARRAY_SIZE=10000000	# ~0.2G
DFLAGS = -DSTREAM_ARRAY_SIZE=20000000	# ~0.4G
#DFLAGS = -DSTREAM_ARRAY_SIZE=40000000	# ~0.9G
#DFLAGS = -DSTREAM_ARRAY_SIZE=60000000	# ~1.3G
#DFLAGS = -DSTREAM_ARRAY_SIZE=80000000	# ~1.8G

# define the C source files
#SRCS = emitter.c error.c init.c lexer.c main.c symbol.c parser.c
SRCS = src/stream.c

# define the C object files
#
# This uses Suffix Replacement within a macro:
#   $(name:string1=string2)
#         For each word in 'name' replace 'string1' with 'string2'
# Below we are replacing the suffix .c of all words in the macro SRCS
# with the .o suffix
#
OBJS = $(SRCS:.c=.o)

# define the executable file
MAIN = membench

#
# The following part of the makefile is generic; it can be used to
# build any executable just by changing the definitions above and by
# deleting dependencies appended to the file from 'make depend'
#

.PHONY:	depend clean

all:	$(MAIN)
	@echo $(MAIN) has been compiled

$(MAIN):	$(OBJS)
	$(CC) $(CFLAGS) $(DFLAGS) $(FFLAGS) $(INCLUDES) -o $(MAIN) $(OBJS) $(LFLAGS) $(LIBS)

# this is a suffix replacement rule for building .o's from .c's
# it uses automatic variables $<: the name of the prerequisite of
# the rule(a .c file) and $@: the name of the target of the rule (a .o file) 
# (see the gnu make manual section about automatic variables)
.c.o:
	$(CC) $(CFLAGS) $(DFLAGS) $(FFLAGS) $(INCLUDES) -c $<  -o $@

clean:
	$(RM) src/*.o *.o *~ $(MAIN)

depend:	$(SRCS)
	makedepend $(INCLUDES) $^

# DO NOT DELETE THIS LINE -- make depend needs it
