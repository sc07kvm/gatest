DEBUG ?= 0

ifneq (, $(shell which clang))
	CC = clang
else ifneq (, $(shell which gcc))
	CC = gcc
else
	CC = cc
endif

PREFIX ?= /usr
BINDIR ?= $(PREFIX)/bin
SYS := $(shell $(CC) -dumpmachine)
GITVER := $(shell git describe --tags)
INSTALL_DATA := -pDm755

ifeq ($(GITVER),)
	GITVER = "unknown"
endif

# LINUX
ifneq (, $(findstring linux, $(SYS)))
	ifneq (, $(findstring musl, $(SYS)))
		LIBS = 
	else
		LIBS = -lm -lrt -ldl -lpthread -lpcre -lssl -lcrypto -lz -lpthread
	endif
	INCLUDES =
	FLAGS2 = 
endif

# MAC OS X
ifneq (, $(findstring darwin, $(SYS)))
	LIBS = -L/usr/local/opt/openssl/lib -lm -lssl -lcrypto -lpcre
	INCLUDES = -I/usr/local/opt/openssl/include
	FLAGS2 = 
	INSTALL_DATA = -pm755
endif

# MinGW on Windows
ifneq (, $(findstring mingw, $(SYS)))
	INCLUDES = -Ivs10/include
	LIBS = -L vs10/lib -lIPHLPAPI -lWs2_32
	FLAGS2 = -march=i686
endif

# Cygwin
ifneq (, $(findstring cygwin, $(SYS)))
	INCLUDES =
	LIBS = 
	FLAGS2 = 
endif

# OpenBSD
ifneq (, $(findstring openbsd, $(SYS)))
	LIBS = -lm -lpthread
	INCLUDES =
	FLAGS2 = 
endif

# FreeBSD
ifneq (, $(findstring freebsd, $(SYS)))
	LIBS = -lm -lpthread
	INCLUDES =
	FLAGS2 =
endif

# NetBSD
ifneq (, $(findstring netbsd, $(SYS)))
	LIBS = -lm -lpthread
	INCLUDES =
	FLAGS2 =
endif

ifeq ($(DEBUG), 1)
    DEFINES = -DDEBUG
	CFLAGS = -g $(FLAGS2) $(INCLUDES) $(DEFINES) -Wall -Werror -O0 -fsanitize=address -fsanitize=undefined
	LDFLAGS = -fsanitize=address -fsanitize=undefined
else
    DEFINES = -DNDEBUG
	CFLAGS = -g $(FLAGS2) $(INCLUDES) $(DEFINES) -Wall -Werror -O2
	LDFLAGS = 
endif

ifeq ($(COVERAGE), 1)
	CFLAGS += -fprofile-instr-generate -fcoverage-mapping
endif


.SUFFIXES: .c .cpp

all: bin/ga-test


tmp/%.o: src/%.c src/*.h
	$(CC) $(CFLAGS) -c $< -o $@


SRC = $(sort $(wildcard src/*.c))
OBJ = $(addprefix tmp/, $(notdir $(addsuffix .o, $(basename $(SRC))))) 


bin/ga-test: $(OBJ)
	$(CC) $(CFLAGS) -o $@ $(OBJ) $(LDFLAGS) $(LIBS)

clean:
	rm -f tmp/*.o
	rm -f bin/ga-test

regress: bin/ga-test
	bin/ga-test --selftest

test: regress

install: bin/ga-test
	install $(INSTALL_DATA) bin/ga-test $(DESTDIR)$(BINDIR)/ga-test
	
default: bin/ga-test
