INSTALL_TOP :=
INSTALL_BIN  = $(INSTALL_TOP)/bin
INSTALL_INC  = $(INSTALL_TOP)/include
INSTALL_LIB  = $(INSTALL_TOP)/lib

TO_BIN = lua
TO_INC = lua.h luaconf.h lualib.h lauxlib.h
TO_LIB = liblua.a

linux:
	@cd src && $(MAKE)

install:
	cd src && $(INSTALL_EXEC) $(TO_BIN) $(INSTALL_BIN)
	cd src && $(INSTALL_DATA) $(TO_INC) $(INSTALL_INC)
	cd src && $(INSTALL_DATA) $(TO_LIB) $(INSTALL_LIB)
