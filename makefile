# originating https://github.com/TheNetAdmin/Makefile-Templates
# tool marcros
#如果要指定特定的Makefile，你可以使用make的“-f”和“--file”参数，如：make –f Make.Linux或make –file Make.AIX。
#在Makefile使用include关键字可以把别的Makefile包含进来，这很像C语言的#include，被包含的文件会原模原样的放在当前文件的包含位置。include的语法是：
#include<filename>filename可以是当前操作系统Shell的文件模式（可以保含路径和通配符）

CC := g++
CCFLAG := -std=c++14
DBGFLAG := -g
CCOBJFLAG := $(CCFLAG) -c

# path marcros
BIN_PATH := bin
OBJ_PATH := obj
SRC_PATH := src
DBG_PATH := debug

# compile marcros
TARGET_NAME := main
ifeq ($(OS),Windows_NT)
    TARGET_NAME := $(addsuffix .exe,$(TARGET_NAME))
endif
TARGET := $(BIN_PATH)/$(TARGET_NAME)
TARGET_DEBUG := $(DBG_PATH)/$(TARGET_NAME)
MAIN_SRC := src/main.cpp

# src files & obj files
SRC := $(foreach x, $(SRC_PATH), $(wildcard $(addprefix $(x)/*,.c*)))
OBJ := $(addprefix $(OBJ_PATH)/, $(addsuffix .o, $(notdir $(basename $(SRC)))))
OBJ_DEBUG := $(addprefix $(DBG_PATH)/, $(addsuffix .o, $(notdir $(basename $(SRC)))))

# 反斜杠是换行符的意思
# clean files list
DISTCLEAN_LIST := $(OBJ) \
                  $(OBJ_DEBUG)
CLEAN_LIST := $(TARGET) \
              $(TARGET_DEBUG) \
              $(DISTCLEAN_LIST)

# default rule
default: all

# non-phony targets
$(TARGET): $(OBJ)
    $(CC) $(CCFLAG) -o $@ $?

$(OBJ_PATH)/%.o: $(SRC_PATH)/%.c*
    $(CC) $(CCOBJFLAG) -o $@ $<

$(DBG_PATH)/%.o: $(SRC_PATH)/%.c*
    $(CC) $(CCOBJFLAG) $(DBGFLAG) -o $@ $<

$(TARGET_DEBUG): $(OBJ_DEBUG)
    $(CC) $(CCFLAG) $(DBGFLAG) $? -o $@

# phony rules
.PHONY: all
all: $(TARGET)

.PHONY: debug
debug: $(TARGET_DEBUG)

.PHONY: clean
clean:
    @echo CLEAN $(CLEAN_LIST)
    @rm -f $(CLEAN_LIST)

.PHONY: distclean
distclean:
    @echo CLEAN $(CLEAN_LIST)
    @rm -f $(DISTCLEAN_LIST)
