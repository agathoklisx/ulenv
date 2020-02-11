# ULENV_VERSION    : 0.0.1
# MAKEFILE_VERSION : 0.0.1

# Issues begin from the end

# -------- Lua Implementations ------------
PRIO_LUA    =  lua
RAVI_LUA    =  ravi
AOT_LUA     =  aot
MOONJIT     =  moonjit
NELUA       =  nelua

# -------- Targets ------------------------
PRIO_LUA_TARGET  = prio-lua
RAVI_LUA_TARGET  = ravi-lua
AOT_LUA_TARGET   = aot-lua
MOONJIT_TARGET   = moonjit
NELUA_TARGET     = nelua

# --------- abstraction -----
OS          := $(shell uname -s)
MACHINE     := $(shell uname -m)
ISUNIX      := 1
GIT         := git
TAR         := tar
TAR_ARGS    := xf
UNZIP       := unzip
GET         := wget
GET_ARGS    :=
COPY        := cp
COPY_REC    := $(COPY) -r
REMOVE      := rm
REMOVE_REC  := $(REMOVE) -rf
MAKDIR      := mkdir
MAKDIR_P    := $(MAKDIR) -p
CHMOD       := chmod
TEST        := test
MAKE        := make
INSTALL      = install -p
INSTALL_EXEC = $(INSTALL) -m 0755
INSTALL_DATA = $(INSTALL) -m 0644
PATCH        = patch
CMAKE        = cmake
CC          := gcc
GET_VERBOSE_LEVEL := 0
UNPACK_METH_ARGS  :=

# --------  inner details ---------------
ROOTDIR          = $(shell pwd)
SYSDIR           = $(ROOTDIR)/sys/$(OS)/$(MACHINE)
SRCDIR           = $(ROOTDIR)/src

SYS_BINDIR       = $(SYSDIR)/bin
SYS_INCDIR       = $(SYSDIR)/include
SYS_LIBDIR       = $(SYSDIR)/lib
SYS_SHAREDIR     = $(SYSDIR)/share

BINDIR           = $(ROOTDIR)/sys/bin

THIS_DATADIR     = $(ROOTDIR)/.data
THIS_MAKEDIR     = $(THIS_DATADIR)/make
THIS_BUILDDIR    = $(ROOTDIR)/src/build

# -----  methods && arguments ------------

OS_TARGET :=
ifeq (-$(OS), -Linux)
  OS_TARGET = linux
endif

GIT_CLONE = $(GIT) clone
GIT_PULL  = $(GIT) pull

ifeq (-$(GET), -wget)
  ifeq ($(GET_VERBOSE_LEVEL), 0)
    GET_ARGS += --quiet
  endif

  GET_ARGS += -O
endif

ifeq (-$(GET), -curl)
  ifeq ($(GET_VERBOSE_LEVEL), 0)
    GET_ARGS += --silent
  else
    GET_ARGS += --verbose
  endif

  GET_ARGS += -L -o
endif

ifeq ($(GET_VERBOSE_LEVEL), 0)
  VERBOSE_ARG =
else
  VERBOSE_ARG = -v
endif

MAKE_ARGS =                                                   \
   "MAKEDIR=$(THIS_MAKEDIR)" "OS_TARGET=$(OS_TARGET)"         \
   "MACHINE=$(MACHINE)" "BINDIR=$(BINDIR)"                    \
   "GIT_CLONE=$(GIT_CLONE)" "GIT_PULL=$(GIT_PULL)"            \
   "GET=$(GET) $(GET_ARGS)" "TEST=$(TEST)"                    \
   "COPY=$(COPY)" "COPY_REC=$(COPY_REC)"                      \
   "REMOVE=$(REMOVE)" "REMOVE_REC=$(REMOVE_REC)"              \
   "MAKDIR=$(MAKDIR)" "MAKDIR_P=$(MAKDIR_P)" "CHMOD=$(CHMOD)" \
   "INSTALL=$(INSTALL)" "INSTALL_EXEC=$(INSTALL_EXEC)"        \
   "INSTALL_DATA=$(INSTALL_DATA)" "PATCH=$(PATCH)"            \
   "CMAKE=$(CMAKE)" "CC=$(CC)"

# ------- PUC Rio Lua Env and Targets -------------
PRIO_LUA_VERSION    := 5.3.5

PRIO_LUA_REPO        = https://github.com/lua/lua
PRIO_LUA_UPSTR_DIST  = https://www.lua.org/ftp
PRIO_LUA_SRCDIR      = $(SRCDIR)/$(PRIO_LUA)
PRIO_LUA_SRC_REPO    = $(PRIO_LUA_SRCDIR)/repo
PRIO_LUA_MAKEFILE    = $(PRIO_LUA_SRCDIR)/Makefile
PRIO_LUA_THISDIR     = $(THIS_DATADIR)/$(PRIO_LUA)
PRIO_LUA_MAKEFILE_IN = $(PRIO_LUA_THISDIR)/Makefile

PRIO_LUA_BUILDDIR    = $(THIS_BUILDDIR)/$(PRIO_LUA)
PRIO_LUA_PACK_FMT    = tar.gz
PRIO_LUA_UNPACK_METH = $(TAR)
PRIO_LUA_UNPACK_METH_ARGS = $(TAR_ARGS)

PRIO_LUA_SYSDIR       = $(SYSDIR)/$(PRIO_LUA)/$(PRIO_LUA_VERSION)
PRIO_LUA_PACKAGE_NAME = $(PRIO_LUA)-$(PRIO_LUA_VERSION)
PRIO_LUA_PACKAGE_DIR  = $(PRIO_LUA_BUILDDIR)/$(PRIO_LUA_PACKAGE_NAME)
PRIO_LUA_PACK         = $(PRIO_LUA)-$(PRIO_LUA_VERSION).$(PRIO_LUA_PACK_FMT)
PRIO_LUA_URL          = $(PRIO_LUA_UPSTR_DIST)/$(PRIO_LUA_PACK)
PRIO_LUA_PACK_ABSPATH = $(PRIO_LUA_SRCDIR)/$(PRIO_LUA_PACK)
PRIO_LUA_PACKAGE_REPO_DIR = $(PRIO_LUA_BUILDDIR)/repo

PRIO_LUA_MAKE_ARGS    = $(MAKE_ARGS)                                          \
  "IMPLEMENTATION=$(PRIO_LUA)" "MYDIR=$(PRIO_LUA_THISDIR)"                    \
  "VERSION=$(PRIO_LUA_VERSION)" "UPSTREAM_REPO=$(PRIO_LUA_REPO)"              \
  "REPO_ABSPATH=$(PRIO_LUA_SRC_REPO)" "REPO_NAME=repo"                        \
  "SRCDIR=$(SRCDIR)/$(PRIO_LUA)" "PACKAGE_URL=$(PRIO_LUA_URL)"                \
  "PACKAGE_SRC=$(PRIO_LUA_PACK_ABSPATH)" "UNPACK=$(TAR) $(TAR_ARGS)"          \
  "BUILDDIR=$(PRIO_LUA_BUILDDIR)" "PACKAGE_DIR=$(PRIO_LUA_PACKAGE_DIR)"       \
  "SYSDIR=$(PRIO_LUA_SYSDIR)" "PACKAGE_REPO_DIR=$(PRIO_LUA_PACKAGE_REPO_DIR)" \
  "INCLUDE_SYSDIR=$(PRIO_LUA_SYSDIR)/include"

prio-lua: makeenv checkenv prio-lua-makeenv prio-lua-checkenv \
      prio-lua-update-makefile luarocks-get-package luarocks-extract-package
	@cd $(PRIO_LUA_SRCDIR) && $(MAKE) $(PRIO_LUA_MAKE_ARGS) build-package
	@cd $(LUAROCKS_SRCDIR) && $(MAKE) $(PRIO_LUA_MAKE_ARGS)  \
        $(LUAROCKS_MAKE_ARGS) luarocks-build

prio-lua-devel: makeenv checkenv prio-lua-makeenv prio-lua-checkenv \
      prio-lua-update-makefile luarocks-get-package luarocks-extract-package
	@cd $(PRIO_LUA_SRCDIR) && $(MAKE) $(PRIO_LUA_MAKE_ARGS)  \
        "SYSDIR=$(PRIO_LUA_SYSDIR)/../devel" "VERSION=devel" build-lua-devel
	@cd $(LUAROCKS_SRCDIR) && $(MAKE) $(PRIO_LUA_MAKE_ARGS)  \
        "SYSDIR=$(PRIO_LUA_SYSDIR)/../devel" "VERSION=devel" \
        $(LUAROCKS_MAKE_ARGS) luarocks-build

prio-lua-clone-repo: prio-lua-makeenv prio-lua-checkenv prio-lua-update-makefile
	@cd $(PRIO_LUA_SRCDIR) && $(MAKE) $(PRIO_LUA_MAKE_ARGS) clone-repo

prio-lua-update-repo: prio-lua-makeenv prio-lua-checkenv prio-lua-update-makefile
	@cd $(PRIO_LUA_SRCDIR) && $(MAKE) $(PRIO_LUA_MAKE_ARGS) update-repo

prio-lua-get-package: prio-lua-makeenv prio-lua-checkenv prio-lua-update-makefile
	@cd $(PRIO_LUA_SRCDIR) && $(MAKE) $(PRIO_LUA_MAKE_ARGS) get-package

prio-lua-extract-package: prio-lua-makeenv prio-lua-checkenv prio-lua-update-makefile
	@cd $(PRIO_LUA_SRCDIR) && $(MAKE) $(PRIO_LUA_MAKE_ARGS) extract-package

prio-lua-makeenv:
	@$(TEST) -d $(PRIO_LUA_SRCDIR)      || $(MAKDIR_P) $(VERBOSE_ARG) $(PRIO_LUA_SRCDIR)
	@$(TEST) -d $(PRIO_LUA_BUILDDIR)    || $(MAKDIR_P) $(PRIO_LUA_BUILDDIR)
	@$(TEST) -d $(PRIO_LUA_SYSDIR)      || $(MAKDIR_P) $(PRIO_LUA_SYSDIR)
	@$(TEST) -f $(PRIO_LUA_MAKEFILE)    || $(COPY) $(VERBOSE_ARG) $(PRIO_LUA_MAKEFILE_IN) $(PRIO_LUA_MAKEFILE)

prio-lua-checkenv:
	@$(TEST) -w $(PRIO_LUA_SRCDIR)      || exit 1
	@$(TEST) -w $(PRIO_LUA_BUILDDIR)    || exit 1
	@$(TEST) -w $(PRIO_LUA_SYSDIR)      || exit 1
	@$(TEST) -r $(PRIO_LUA_MAKEFILE)    || exit 1

prio-lua-update-makefile:
	@$(TEST) -f $(PRIO_LUA_MAKEFILE_IN) || exit 1
	@$(COPY) $(VERBOSE_ARG) $(PRIO_LUA_MAKEFILE_IN) $(PRIO_LUA_MAKEFILE)

# ------ Ravi Lua Env and Targets ----------------

RAVI_LUA_VERSION     := 1.0-beta3
RAVI_LUA_REPO         = https://github.com/dibyendumajumdar/ravi
RAVI_LUA_SRCDIR       = $(SRCDIR)/$(RAVI_LUA)
RAVI_LUA_SRC_REPO     = $(RAVI_LUA_SRCDIR)/repo
RAVI_LUA_THISDIR      = $(THIS_DATADIR)/$(RAVI_LUA)
RAVI_LUA_MAKEFILE_IN  = $(RAVI_LUA_THISDIR)/Makefile
RAVI_LUA_MAKEFILE     = $(RAVI_LUA_SRCDIR)/Makefile
RAVI_LUA_UPSTR_DIST   = https://github.com/dibyendumajumdar/ravi/archive

RAVI_LUA_BUILDDIR    = $(THIS_BUILDDIR)/$(RAVI_LUA)
RAVI_LUA_PACK_FMT     = zip
RAVI_LUA_UNPACK_METH := $(UNZIP)
RAVI_LUA_UNPACK_METH_ARGS :=

RAVI_LUA_SYSDIR       = $(SYSDIR)/$(RAVI_LUA)/$(RAVI_LUA_VERSION)
RAVI_LUA_PACKAGE_NAME = $(RAVI_LUA_VERSION)
RAVI_LUA_PACKAGE_DIR  = $(RAVI_LUA_BUILDDIR)/$(RAVI_LUA)-$(RAVI_LUA_PACKAGE_NAME)
RAVI_LUA_PACK         = $(RAVI_LUA_PACKAGE_NAME).$(RAVI_LUA_PACK_FMT)
RAVI_LUA_URL          = $(RAVI_LUA_UPSTR_DIST)/$(RAVI_LUA_PACK)
RAVI_LUA_PACK_ABSPATH = $(RAVI_LUA_SRCDIR)/$(RAVI_LUA_PACK)
RAVI_LUA_PACKAGE_REPO_DIR = $(RAVI_LUA_BUILDDIR)/repo

RAVI_LUA_MAKE_ARGS    = $(MAKE_ARGS)                                          \
  "IMPLEMENTATION=$(RAVI_LUA)" "MYDIR=$(RAVI_LUA_THISDIR)"                    \
  "VERSION=$(RAVI_LUA_VERSION)" "UPSTREAM_REPO=$(RAVI_LUA_REPO)"              \
  "REPO_ABSPATH=$(RAVI_LUA_SRC_REPO)" "REPO_NAME=repo"                        \
  "SRCDIR=$(SRCDIR)/$(RAVI_LUA)" "PACKAGE_URL=$(RAVI_LUA_URL)"                \
  "PACKAGE_SRC=$(RAVI_LUA_PACK_ABSPATH)" "UNPACK=$(UNZIP)"                    \
  "BUILDDIR=$(RAVI_LUA_BUILDDIR)" "PACKAGE_DIR=$(RAVI_LUA_PACKAGE_DIR)"       \
  "SYSDIR=$(RAVI_LUA_SYSDIR)" "PACKAGE_REPO_DIR=$(RAVI_LUA_PACKAGE_REPO_DIR)"

ravi-lua: makeenv checkenv ravi-lua-makeenv ravi-lua-checkenv ravi-lua-update-makefile
	@cd $(RAVI_LUA_SRCDIR) && $(MAKE) $(RAVI_LUA_MAKE_ARGS) build-ravi

ravi-lua-devel: makeenv checkenv ravi-lua-makeenv ravi-lua-checkenv ravi-lua-update-makefile 
	@cd $(RAVI_LUA_SRCDIR) && $(MAKE) $(RAVI_LUA_MAKE_ARGS)  \
        "SYSDIR=$(RAVI_LUA_SYSDIR)/../devel" "VERSION=devel" build-ravi-devel

ravi-lua-clone-repo: ravi-lua-makeenv ravi-lua-checkenv ravi-lua-update-makefile
	@cd $(RAVI_LUA_SRCDIR) && $(MAKE) $(RAVI_LUA_MAKE_ARGS) clone-repo

ravi-lua-update-repo: ravi-lua-makeenv ravi-lua-checkenv ravi-lua-update-makefile
	@cd $(RAVI_LUA_SRCDIR) && $(MAKE) $(RAVI_LUA_MAKE_ARGS) update-repo

ravi-lua-get-package: ravi-lua-makeenv ravi-lua-checkenv ravi-lua-update-makefile
	@cd $(RAVI_LUA_SRCDIR) && $(MAKE) $(RAVI_LUA_MAKE_ARGS) get-package

ravi-lua-extract-package: ravi-lua-makeenv ravi-lua-checkenv ravi-lua-update-makefile
	@cd $(RAVI_LUA_SRCDIR) && $(MAKE) $(RAVI_LUA_MAKE_ARGS) extract-package

ravi-lua-makeenv:
	@$(TEST) -d $(RAVI_LUA_SRCDIR)      || $(MAKDIR_P) $(VERBOSE_ARG) $(RAVI_LUA_SRCDIR)
	@$(TEST) -d $(RAVI_LUA_BUILDDIR)    || $(MAKDIR_P) $(RAVI_LUA_BUILDDIR)
	@$(TEST) -d $(RAVI_LUA_SYSDIR)      || $(MAKDIR_P) $(RAVI_LUA_SYSDIR)
	@$(TEST) -f $(RAVI_LUA_MAKEFILE)    || $(COPY) $(VERBOSE_ARG) $(RAVI_LUA_MAKEFILE_IN) $(RAVI_LUA_MAKEFILE)

ravi-lua-checkenv:
	@$(TEST) -w $(RAVI_LUA_SRCDIR)      || exit 1
	@$(TEST) -w $(RAVI_LUA_BUILDDIR)    || exit 1
	@$(TEST) -w $(RAVI_LUA_SYSDIR)      || exit 1
	@$(TEST) -r $(RAVI_LUA_MAKEFILE)    || exit 1

ravi-lua-update-makefile:
	@$(TEST) -f $(RAVI_LUA_MAKEFILE_IN) || exit 1
	@$(COPY) $(VERBOSE_ARG) $(RAVI_LUA_MAKEFILE_IN) $(RAVI_LUA_MAKEFILE)

#--------- Ahead Of Time Lua and Targets ---------
AOT_LUA_VERSION     := 5.4
AOT_LUA_REPO         = https://github.com/hugomg/lua-aot-5.4
AOT_LUA_SRCDIR       = $(SRCDIR)/$(AOT_LUA)
AOT_LUA_SRC_REPO     = $(AOT_LUA_SRCDIR)/repo
AOT_LUA_THISDIR      = $(THIS_DATADIR)/$(AOT_LUA)
AOT_LUA_MAKEFILE_IN  = $(AOT_LUA_THISDIR)/Makefile
AOT_LUA_MAKEFILE     = $(AOT_LUA_SRCDIR)/Makefile
AOT_LUA_UPSTR_DIST   = https://github.com/hugomg/lua-aot/archive

AOT_LUA_BUILDDIR     = $(THIS_BUILDDIR)/$(AOT_LUA)
AOT_LUA_PACK_FMT     = zip
AOT_LUA_UNPACK_METH := $(UNZIP)
AOT_LUA_UNPACK_METH_ARGS :=

AOT_LUA_SYSDIR       = $(SYSDIR)/$(AOT_LUA)/$(AOT_LUA_VERSION)
AOT_LUA_PACKAGE_NAME = $(AOT_LUA_VERSION)
AOT_LUA_PACKAGE_DIR  = $(AOT_LUA_BUILDDIR)/$(AOT_LUA)-$(AOT_LUA_PACKAGE_NAME)
AOT_LUA_PACK         = $(AOT_LUA_PACKAGE_NAME).$(AOT_LUA_PACK_FMT)
AOT_LUA_URL          = $(AOT_LUA_UPSTR_DIST)/$(AOT_LUA_PACK)
AOT_LUA_PACK_ABSPATH = $(AOT_LUA_SRCDIR)/$(AOT_LUA_PACK)
AOT_LUA_PACKAGE_REPO_DIR = $(AOT_LUA_BUILDDIR)/repo

AOT_LUA_MAKE_ARGS    = $(MAKE_ARGS)                                          \
  "IMPLEMENTATION=$(AOT_LUA)" "MYDIR=$(AOT_LUA_THISDIR)"                     \
  "VERSION=$(AOT_LUA_VERSION)" "UPSTREAM_REPO=$(AOT_LUA_REPO)"               \
  "REPO_ABSPATH=$(AOT_LUA_SRC_REPO)" "REPO_NAME=repo"                        \
  "SRCDIR=$(SRCDIR)/$(AOT_LUA)" "PACKAGE_URL=$(AOT_LUA_URL)"                 \
  "PACKAGE_SRC=$(AOT_LUA_PACK_ABSPATH)" "UNPACK=$(UNZIP)"                    \
  "BUILDDIR=$(AOT_LUA_BUILDDIR)" "PACKAGE_DIR=$(AOT_LUA_PACKAGE_DIR)"        \
  "SYSDIR=$(AOT_LUA_SYSDIR)" "PACKAGE_REPO_DIR=$(AOT_LUA_PACKAGE_REPO_DIR)"  \
  "INCLUDE_SYSDIR=$(AOT_LUA_SYSDIR)/include"

#aot-lua: makeenv checkenv aot-lua-makeenv aot-lua-checkenv aot-lua-update-makefile
#	@cd $(AOT_LUA_SRCDIR) && $(MAKE) $(AOT_LUA_MAKE_ARGS) build-package

aot-lua-devel: makeenv checkenv aot-lua-makeenv aot-lua-checkenv \
      aot-lua-update-makefile luarocks-get-package luarocks-extract-package
	@cd $(AOT_LUA_SRCDIR) && $(MAKE) $(AOT_LUA_MAKE_ARGS)   \
        "SYSDIR=$(AOT_LUA_SYSDIR)/../devel" "VERSION=devel" build-aot-devel
	@cd $(LUAROCKS_SRCDIR) && $(MAKE) $(AOT_LUA_MAKE_ARGS)  \
        "INCLUDE_SYSDIR=$(AOT_LUA_SYSDIR)/../devel/include" \
        "SYSDIR=$(AOT_LUA_SYSDIR)/../devel" "VERSION=devel" \
        $(LUAROCKS_MAKE_ARGS) luarocks-build

aot-lua-clone-repo: aot-lua-makeenv aot-lua-checkenv aot-lua-update-makefile
	@cd $(AOT_LUA_SRCDIR) && $(MAKE) $(AOT_LUA_MAKE_ARGS) clone-repo

aot-lua-update-repo: aot-lua-makeenv aot-lua-checkenv aot-lua-update-makefile
	@cd $(AOT_LUA_SRCDIR) && $(MAKE) $(AOT_LUA_MAKE_ARGS) update-repo

# aot-lua-get-package: aot-lua-makeenv aot-lua-checkenv aot-lua-update-makefile
#	@cd $(AOT_LUA_SRCDIR) && $(MAKE) $(AOT_LUA_MAKE_ARGS) get-package

# aot-lua-extract-package: aot-lua-makeenv aot-lua-checkenv aot-lua-update-makefile
#	@cd $(AOT_LUA_SRCDIR) && $(MAKE) $(AOT_LUA_MAKE_ARGS) extract-package

aot-lua-makeenv:
	@$(TEST) -d $(AOT_LUA_SRCDIR)      || $(MAKDIR_P) $(VERBOSE_ARG) $(AOT_LUA_SRCDIR)
	@$(TEST) -d $(AOT_LUA_BUILDDIR)    || $(MAKDIR_P) $(AOT_LUA_BUILDDIR)
	@$(TEST) -d $(AOT_LUA_SYSDIR)      || $(MAKDIR_P) $(AOT_LUA_SYSDIR)
	@$(TEST) -f $(AOT_LUA_MAKEFILE)    || $(COPY) $(VERBOSE_ARG) $(AOT_LUA_MAKEFILE_IN) $(AOT_LUA_MAKEFILE)

aot-lua-checkenv:
	@$(TEST) -w $(AOT_LUA_SRCDIR)      || exit 1
	@$(TEST) -w $(AOT_LUA_BUILDDIR)    || exit 1
	@$(TEST) -w $(AOT_LUA_SYSDIR)      || exit 1
	@$(TEST) -r $(AOT_LUA_MAKEFILE)    || exit 1

aot-lua-update-makefile:
	@$(TEST) -f $(AOT_LUA_MAKEFILE_IN) || exit 1
	@$(COPY) $(VERBOSE_ARG) $(AOT_LUA_MAKEFILE_IN) $(AOT_LUA_MAKEFILE)

# ------- MoonJit Env and Targets --------------------
MOONJIT_VERSION     := 2.2.0
MOONJIT_REPO         = https://github.com/moonjit/moonjit
MOONJIT_SRCDIR       = $(SRCDIR)/$(MOONJIT)
MOONJIT_SRC_REPO     = $(MOONJIT_SRCDIR)/repo
MOONJIT_THISDIR      = $(THIS_DATADIR)/$(MOONJIT)
MOONJIT_MAKEFILE_IN  = $(MOONJIT_THISDIR)/Makefile
MOONJIT_MAKEFILE     = $(MOONJIT_SRCDIR)/Makefile
MOONJIT_UPSTR_DIST   = https://github.com/moonjit/moonjit/archive

MOONJIT_BUILDDIR     = $(THIS_BUILDDIR)/$(MOONJIT)
MOONJIT_PACK_FMT     = zip
MOONJIT_UNPACK_METH := $(UNZIP)
MOONJIT_UNPACK_METH_ARGS :=

MOONJIT_SYSDIR       = $(SYSDIR)/$(MOONJIT)/$(MOONJIT_VERSION)
MOONJIT_PACKAGE_NAME = $(MOONJIT_VERSION)
MOONJIT_PACKAGE_DIR  = $(MOONJIT_BUILDDIR)/$(MOONJIT)-$(MOONJIT_PACKAGE_NAME)
MOONJIT_PACK         = $(MOONJIT_PACKAGE_NAME).$(MOONJIT_PACK_FMT)
MOONJIT_URL          = $(MOONJIT_UPSTR_DIST)/$(MOONJIT_PACK)
MOONJIT_PACK_ABSPATH = $(MOONJIT_SRCDIR)/$(MOONJIT_PACK)
MOONJIT_PACKAGE_REPO_DIR = $(MOONJIT_BUILDDIR)/repo

MOONJIT_MAKE_ARGS    = $(MAKE_ARGS)                                           \
  "IMPLEMENTATION=$(MOONJIT)" "MYDIR=$(MOONJIT_THISDIR)"                      \
  "VERSION=$(MOONJIT_VERSION)" "UPSTREAM_REPO=$(MOONJIT_REPO)"                \
  "REPO_ABSPATH=$(MOONJIT_SRC_REPO)" "REPO_NAME=repo"                         \
  "SRCDIR=$(SRCDIR)/$(MOONJIT)" "PACKAGE_URL=$(MOONJIT_URL)"                  \
  "PACKAGE_SRC=$(MOONJIT_PACK_ABSPATH)" "UNPACK=$(UNZIP)"                     \
  "BUILDDIR=$(MOONJIT_BUILDDIR)" "PACKAGE_DIR=$(MOONJIT_PACKAGE_DIR)"         \
  "SYSDIR=$(MOONJIT_SYSDIR)" "PACKAGE_REPO_DIR=$(MOONJIT_PACKAGE_REPO_DIR)"

moonjit: makeenv checkenv moonjit-makeenv moonjit-checkenv \
      moonjit-update-makefile luarocks-get-package luarocks-extract-package
	@cd $(MOONJIT_SRCDIR) && $(MAKE) $(MOONJIT_MAKE_ARGS) build-moonjit
	@cd $(LUAROCKS_SRCDIR) && $(MAKE) $(MOONJIT_MAKE_ARGS)        \
        "INCLUDE_SYSDIR=$(MOONJIT_SYSDIR)/include/$(MOONJIT)-2.2" \
        $(LUAROCKS_MAKE_ARGS) luarocks-build

moonjit-devel: makeenv checkenv moonjit-makeenv moonjit-checkenv \
      moonjit-update-makefile luarocks-get-package luarocks-extract-package
	@cd $(MOONJIT_SRCDIR) && $(MAKE) $(MOONJIT_MAKE_ARGS)  \
        "SYSDIR=$(MOONJIT_SYSDIR)/../devel" "VERSION=devel" build-moonjit-devel
	@cd $(LUAROCKS_SRCDIR) && $(MAKE) $(PRIO_LUA_MAKE_ARGS)                \
        "INCLUDE_SYSDIR=$(MOONJIT_SYSDIR)/../devel/include/$(MOONJIT)-2.3" \
        "SYSDIR=$(MOONJIT_SYSDIR)/../devel" "VERSION=devel"                \
        $(LUAROCKS_MAKE_ARGS) luarocks-build

moonjit-clone-repo: moonjit-makeenv moonjit-checkenv moonjit-update-makefile
	@cd $(MOONJIT_SRCDIR) && $(MAKE) $(MOONJIT_MAKE_ARGS) clone-repo

moonjit-update-repo: moonjit-makeenv moonjit-checkenv moonjit-update-makefile
	@cd $(MOONJIT_SRCDIR) && $(MAKE) $(MOONJIT_MAKE_ARGS) update-repo

moonjit-get-package: moonjit-makeenv moonjit-checkenv moonjit-update-makefile
	@cd $(MOONJIT_SRCDIR) && $(MAKE) $(MOONJIT_MAKE_ARGS) get-package

moonjit-extract-package: moonjit-makeenv moonjit-checkenv moonjit-update-makefile
	@cd $(MOONJIT_SRCDIR) && $(MAKE) $(MOONJIT_MAKE_ARGS) extract-package

moonjit-makeenv:
	@$(TEST) -d $(MOONJIT_SRCDIR)      || $(MAKDIR_P) $(VERBOSE_ARG) $(MOONJIT_SRCDIR)
	@$(TEST) -d $(MOONJIT_BUILDDIR)    || $(MAKDIR_P) $(MOONJIT_BUILDDIR)
	@$(TEST) -d $(MOONJIT_SYSDIR)      || $(MAKDIR_P) $(MOONJIT_SYSDIR)
	@$(TEST) -f $(MOONJIT_MAKEFILE)    || $(COPY) $(VERBOSE_ARG) $(MOONJIT_MAKEFILE_IN) $(MOONJIT_MAKEFILE)

moonjit-checkenv:
	@$(TEST) -w $(MOONJIT_SRCDIR)      || exit 1
	@$(TEST) -w $(MOONJIT_BUILDDIR)    || exit 1
	@$(TEST) -w $(MOONJIT_SYSDIR)      || exit 1
	@$(TEST) -r $(MOONJIT_MAKEFILE)    || exit 1

moonjit-update-makefile:
	@$(TEST) -f $(MOONJIT_MAKEFILE_IN) || exit 1
	@$(COPY) $(VERBOSE_ARG) $(MOONJIT_MAKEFILE_IN) $(MOONJIT_MAKEFILE)

# ------ NELUA env and targets ----------------
NELUA_VERSION     :=
NELUA_REPO         = https://github.com/edubart/nelua-lang
NELUA_ROCKSPEC     = https://raw.githubusercontent.com/edubart/nelua-lang/master/rockspecs/nelua-dev-1.rockspec
NELUA_SRCDIR       = $(SRCDIR)/$(NELUA)
NELUA_SRC_REPO     = $(NELUA_SRCDIR)/repo
NELUA_THISDIR      = $(THIS_DATADIR)/$(NELUA)
NELUA_MAKEFILE_IN  = $(NELUA_THISDIR)/Makefile
NELUA_MAKEFILE     = $(NELUA_SRCDIR)/Makefile

NELUA_SYSDIR       = $(SYSDIR)/$(NELUA)/$(NELUA_VERSION)
NELUA_PACKAGE_NAME = $(NELUA_VERSION)
NELUA_PACKAGE_DIR  = $(NELUA_BUILDDIR)/$(NELUA)-$(NELUA_PACKAGE_NAME)
NELUA_PACK         = $(NELUA_PACKAGE_NAME).$(NELUA_PACK_FMT)
NELUA_URL          = $(NELUA_UPSTR_DIST)/$(NELUA_PACK)
NELUA_PACK_ABSPATH = $(NELUA_SRCDIR)/$(NELUA_PACK)
NELUA_PACKAGE_REPO_DIR = $(NELUA_BUILDDIR)/repo

NELUA_MAKE_ARGS    = $(MAKE_ARGS)                                          \
  "IMPLEMENTATION=$(NELUA)" "MYDIR=$(NELUA_THISDIR)"                       \
  "VERSION=$(NELUA_VERSION)" "UPSTREAM_REPO=$(NELUA_REPO)"                 \
  "REPO_ABSPATH=$(NELUA_SRC_REPO)" "REPO_NAME=repo"                        \
  "SRCDIR=$(SRCDIR)/$(NELUA)" "PACKAGE_URL=$(NELUA_URL)"                   \
  "PACKAGE_SRC=$(NELUA_PACK_ABSPATH)" "UNPACK=$(UNZIP)"                    \
  "BUILDDIR=$(NELUA_BUILDDIR)" "PACKAGE_DIR=$(NELUA_PACKAGE_DIR)"          \
  "SYSDIR=$(NELUA_SYSDIR)" "PACKAGE_REPO_DIR=$(NELUA_PACKAGE_REPO_DIR)"    \
  "INCLUDE_SYSDIR=$(NELUA_SYSDIR)/include"

nelua: makeenv checkenv nelua-makeenv nelua-checkenv \
      nelua-update-makefile luarocks-get-package luarocks-extract-package
	@cd $(NELUA_SRCDIR) && $(MAKE) $(PRIO_LUA_MAKE_ARGS)  \
      "SYSDIR=$(NELUA_SYSDIR)"  build-package
	@cd $(LUAROCKS_SRCDIR) && $(MAKE) $(PRIO_LUA_MAKE_ARGS)  \
      "SYSDIR=$(NELUA_SYSDIR)"   $(LUAROCKS_MAKE_ARGS) luarocks-build
	@cd $(NELUA_SYSDIR)/bin && ./luarocks install $(NELUA_ROCKSPEC)

nelua-clone-repo: nelua-makeenv nelua-checkenv nelua-update-makefile
	@cd $(NELUA_SRCDIR) && $(MAKE) $(NELUA_MAKE_ARGS) clone-repo

nelua-update-repo: nelua-makeenv nelua-checkenv nelua-update-makefile
	@cd $(NELUA_SRCDIR) && $(MAKE) $(NELUA_MAKE_ARGS) update-repo

nelua-makeenv:
	@$(TEST) -d $(NELUA_SRCDIR)      || $(MAKDIR_P) $(VERBOSE_ARG) $(NELUA_SRCDIR)
	@$(TEST) -d $(NELUA_BUILDDIR)    || $(MAKDIR_P) $(NELUA_BUILDDIR)
	@$(TEST) -d $(NELUA_SYSDIR)      || $(MAKDIR_P) $(NELUA_SYSDIR)
	@$(TEST) -f $(NELUA_MAKEFILE)    || $(COPY) $(VERBOSE_ARG) $(NELUA_MAKEFILE_IN) $(NELUA_MAKEFILE)

nelua-checkenv:
	@$(TEST) -w $(NELUA_SRCDIR)      || exit 1
	@$(TEST) -w $(NELUA_BUILDDIR)    || exit 1
	@$(TEST) -w $(NELUA_SYSDIR)      || exit 1
	@$(TEST) -r $(NELUA_MAKEFILE)    || exit 1

nelua-update-makefile:
	@$(TEST) -f $(NELUA_MAKEFILE_IN) || exit 1
	@$(COPY) $(VERBOSE_ARG) $(NELUA_MAKEFILE_IN) $(NELUA_MAKEFILE)

# --------- end of targets ---------------------

all: prio-lua prio-lua-devel ravi-lua ravi-lua-devel aot-lua-devel moonjit-devel \
     moonjit nelua

# --------- Lua Rocks --------------------------

LUAROCKS                   = luarocks
LUAROCKS_VERSION          := 3.3.1
LUAROCKS_UPSTR_DIST        = http://luarocks.org/releases
LUAROCKS_THISDIR           = $(THIS_DATADIR)/$(LUAROCKS)
LUAROCKS_MAKEFILE_IN       = $(LUAROCKS_THISDIR)/Makefile
LUAROCKS_MAKEFILE          = $(LUAROCKS_SRCDIR)/Makefile
LUAROCKS_SRCDIR            = $(ROOTDIR)/src/$(LUAROCKS)
LUAROCKS_BUILDDIR          = $(THIS_BUILDDIR)/$(LUAROCKS)
LUAROCKS_PACKAGE_NAME      = $(LUAROCKS)-$(LUAROCKS_VERSION)
LUAROCKS_PACK_FMT         := tar.gz
LUAROCKS_PACK              = $(LUAROCKS_PACKAGE_NAME).$(LUAROCKS_PACK_FMT)
LUAROCKS_URL               = $(LUAROCKS_UPSTR_DIST)/$(LUAROCKS_PACK)
LUAROCKS_PACK_ABSPATH      = $(LUAROCKS_SRCDIR)/$(LUAROCKS_PACK)
LUAROCKS_PACKAGE_DIR       = $(LUAROCKS_BUILDDIR)/$(LUAROCKS_PACKAGE_NAME)
LUAROCKS_UNPACK_METH      := $(TAR)
LUAROCKS_UNPACK_METH_ARGS := $(TAR_ARGS)

LUAROCKS_MAKE_ARGS  = $(MAKE_ARGS)                       \
  "IMPLEMENTATION=" "LUAROCKS_DIR=$(LUAROCKS_THISDIR)"   \
  "LUAROCKS_SRCDIR=$(LUAROCKS_SRCDIR)"                   \
  "LUAROCKS_PACKAGE_URL=$(LUAROCKS_URL)"                 \
  "LUAROCKS_PACKAGE_SRC=$(LUAROCKS_PACK_ABSPATH)"        \
  "UNPACK=$(TAR) $(TAR_ARGS)"                            \
  "LUAROCKS_BUILDDIR=$(LUAROCKS_BUILDDIR)"               \
  "LUAROCKS_PACKAGE_DIR=$(LUAROCKS_PACKAGE_DIR)"

luarocks-get-package: luarocks-makeenv luarocks-checkenv luarocks-update-makefile
	@cd $(LUAROCKS_SRCDIR) && $(MAKE) $(LUAROCKS_MAKE_ARGS) luarocks-get-package

luarocks-extract-package: luarocks-makeenv luarocks-checkenv luarocks-update-makefile
	@cd $(LUAROCKS_SRCDIR) && $(MAKE) $(LUAROCKS_MAKE_ARGS) luarocks-extract-package

luarocks-makeenv:
	@$(TEST) -d $(LUAROCKS_SRCDIR)    || $(MAKDIR_P) $(VERBOSE_ARG) $(LUAROCKS_SRCDIR)
	@$(TEST) -d $(LUAROCKS_BUILDDIR)  || $(MAKDIR_P) $(LUAROCKS_BUILDDIR)
	@$(TEST) -f $(LUAROCKS_MAKEFILE)  || $(COPY) $(VERBOSE_ARG) $(LUAROCKS_MAKEFILE_IN) $(LUAROCKS_MAKEFILE)

luarocks-checkenv:
	@$(TEST) -w $(LUAROCKS_SRCDIR)    || exit 1
	@$(TEST) -w $(LUAROCKS_BUILDDIR)  || exit 1
	@$(TEST) -r $(LUAROCKS_MAKEFILE)  || exit 1

luarocks-update-makefile:
	@$(TEST) -f $(LUAROCKS_MAKEFILE_IN) || exit 1
	$(COPY) $(VERBOSE_ARG) $(LUAROCKS_MAKEFILE_IN) $(LUAROCKS_MAKEFILE)

# ----- inner targets ----------
makeenv:
	@$(TEST) -d $(SYSDIR) || $(MAKDIR_P) $(VERBOSE_ARG) $(SYSDIR)
	@$(TEST) -d $(BINDIR) || $(MAKDIR)   $(VERBOSE_ARG) $(BINDIR)

checkenv:
	@$(TEST) -w $(SYSDIR) || exit 1
	@$(TEST) -w $(BINDIR) || exit 1

#---------- debug ------------------
debug:
	@echo $(ROOTDIR)
	@echo $(THIS_MAKEDIR)
	@echo $(THIS_DATADIR)
	@echo $(PRIO_LUA_SRCDIR)
	@echo $(SRCDIR_RAVI_LUA)
	@echo $(SRCDIR_AOT_LUA)
	@echo $(SRCDIR_MOONJIT)
	@echo $(SYS_LIBDIR)
	@echo $(PRIO_LUA_MAKEFILE)
	@echo $(PRIO_LUA_THISDIR)
	@echo "makefile in " $(PRIO_LUA_MAKEFILE_IN)
	@echo $(PRIO_LUA_SRC_REPO)

VALGRIND = valgrind
VALGRIND_ARGS = --leak-check=full --show-leak-kinds=all -v --track-origins=yes
GDB = gdb
GDB_ARGS = --quiet -ex "set logging file /tmp/gdb.txt" -ex "set logging on" -ex run --args

#----------------------------------------------------------#
# 0011 add an info target to output some information

# 0010 is += portable to BSD make?

# 0009 build readline (even better a Lua made readline)

# 0008 symlink to sys/bin/lua which by default will point to current PUC Rio Lua
# make a target to manipulate
#
# 0007 export LUA_PATH in the wrappers
# which path will be best? see .data/lua/linux-x86_64-lua-5.3.5 or:
#
# OS=$(uname -s)
# MACHINE=$(uname -m)
# 
# INTERPRETER_NAME=lua
# TARGET=lua
# SRCDIR=5.3.5
# BRANCH=5.3
# 
# SYSDIR=$(realpath \
# $(cd "$(dirname "$0")" && pwd)/../$OS/$MACHINE/$TARGET/$SRCDIR)
# 
# LUA_SHAREDIR=$SYSDIR/share/lua/$BRANCH
# LUA_PATH=$LUA_SHAREDIR/?.lua\;$LUA_SHAREDIR/?/init.lua
# 
# LUA_LIBDIR=$SYSDIR/lib/lua/$BRANCH
# LUA_CPATH=$LUA_LIBDIR/?.so\;$LUA_SHAREDIR/?.so
# 
# export LUA_PATH LUA_CPATH
# 
# BINDIR=$SYSDIR/bin
# LIBDIR=$SYSDIR/lib
# 
# LD_LIBRARY_PATH=$LIBDIR  $BINDIR/$INTERPRETER_NAME $*
# resol: is it portable to dmake of BSD?

# 0006 wrappers for 32bits systems

# 0005 hide more details
# put more targets in their corresponded Makefile

# 0004 lua-devel
# a. builds for linux only
# b. doesn't build luac
# resol: ignore for now

# 0003 MKDIR classes with MKDIR from upstrean
# solution: rename this to MAKDIR (DONE)

# 0002  ISUNIX
# ifeq (-$(OS), -Linux)
#   ISUNIX = 1
# else
#   ...
# endif
# 
# Resol: maybe usefull (ignore for now)

# 0001  Portability
# OS       := $(shell uname -s)
# MACHINE  := $(shell uname -m)
# ROOTDIR  := $(shell pwd)
# Resol: need info

# ----- issues  --------
