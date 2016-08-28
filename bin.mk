ifeq ($(origin BIN), undefined)
	$(error "No target defined")
endif

ifeq ($(origin CFLAGS), undefined)
	CFLAGS :=
endif

ifeq ($(origin CXX_FLAGS), undefined)
	CXX_FLAGS := 
endif

ifeq  ($(origin LD_FLAGS), undefined)
	LD_FLAGS := 
endif

VPATH := $(SRC)

ifneq ($(origin DEBUG), undefined)
	CXX_FLAGS := $(CXX_FLAGS) -g
	CFLAGS := $(CFLAGS) -g
	LD_FLAGS := $(LD_FLAGS) -g
endif

C_SRC := $(wildcard $(SRC)/*.c)
CXX_SRC := $(wildcard $(SRC)/*.cpp)
SRC := $(CXX_SRC) $(C_SRC)

C_HEADER_DEPS := $(patsubst $(SRC)/%.c,%.d,$(C_SRC))
CXX_HEADER_DEPS := $(patsubst $(SRC)/%.cpp,%.d,$(CXX_SRC))
HEADER_DEPS := $(C_HEADER_DEPS) $(CXX_HEADER_DEPS)

-include $(HEADER_DEPS)

CXX_OBJ := $(patsubst $(SRC)/%.cpp,%.o,$(CXX_SRC))
C_OBJ := $(patsubst $(SRC)/%.c,%.o,$(C_SRC))
OBJ := $(CXX_OBJ) $(C_OBJ)

ifneq ($(CXX_OBJ), )
	LD := $(CXX)
else
	LD := $(CC)
endif

all:$(BIN)

$(BIN):$(OBJ)
	$(LD) $(LD_FLAGS) -o  $@ $^
	
%.o:%.cpp
	$(CXX) -c $(CXX_FLAGS) -o $@ $<

%.o:%.c
	$(CC) -c $(CFLAGS) -o $@ $<

%.d:%.c
	$(CC) -MM $(CPPFLAGS) $< > $@.$$$$; \
	sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
	$(RM) -f $@.$$$$

%.d:%.cpp
	$(CXX) -MM $(CPPFLAGS) $< > $@.$$$$; \
	sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
	$(RM) -f $@.$$$$

clean:
	$(RM) -rf $(BIN) $(OBJ) $(HEADER_DEPS)

.PHONY:all, clean