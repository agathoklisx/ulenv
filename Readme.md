```C
            UNITED LUA LANGUAGE ENVIRONMENT

This is to explore some possibilities and aims to demonstrate the power of diversity
in the Lua Universe.

At this stage is at the prototype level, but already usefull at least as a testing
tool.

It builds the following targets:

  - PUC Rio Lua
    -  5.1.5
    -  5.2.4
    -  5.3.5
    - development sources (Linux)

  - Ravi Lua - https://ravilang.github.io/
    - 1.0-beta3
    - development sources with mir (Linux and X86-64)

  - Ahead Of Time Lua - https://github.com/hugomg/lua-aot
    - development sources targeting Lua 5.4

  - MoonJit Lua - https://github.com/moonjit/moonjit
    - 2.2.0
    - development sources

Usage:

  # by default builds PUC Rio Lua 5.3.5 with gcc
  make

  # same but use clang
  make CC=clang

  # other releases and development sources
  make PRIO_LUA_VERSION=5.2.4 prio-lua
  make PRIO_LUA_VERSION=5.1.5 prio-lua
  make prio-lua-devel

  #  Ravi Lua
  make ravi-lua
  make ravi-lua-devel

  #  Ahead Of Time Lua
  make aot-lua-devel

  #  MoonJit
  make moonjit
  make moonjit-devel

  # this builds all targets
  make all

  # those deal with development sources (cloning and updating)
  make prio-lua-clone-repo
  make prio-lua-update-repo

  make ravi-lua-clone-repo
  make ravi-lua-update-repo

  make aot-lua-clone-repo
  make aot-lua-update-repo

  make moonjit-clone-repo
  make moonjit-update-repo

Hierarchy:
  # ROOTDIR (this directory)

  # sources directory
  $ROOTDIR/src/{lua,ravi,aot,moonjit}/{RELEASE,repo}

  # build directory
  $ROOTDIR/src/build/{lua,ravi,aot,moonjit}/{RELEASE,repo}

  # sys directory
  $ROOTDIR/sys/`uname -s`/`uname -m`/{VERSION,devel}/{bin,lib,include,share}

  # bin directory with wrappers
  $ROOTDIR/sys/bin

  # data dir (internal details: Makefiles, wrappers, patches)
  $ROOTDIR/.data/{lua,ravi,aot,moonjit}

  # you develop $ROOTDIR/.data/IMPLEMENTATION/Makefile
  # at any target this updated automatically, or by:
  make ravi-lua-update-makefile

Note that the zsh shell offers tab completion for make.

Initial development is under Linux, with GNU make.
Tested with gcc-9.1.0 and clang-9.0.0

I
The low revision is implemented with Makefiles.

Development:

Provide a Lua Standard Library (lstl) see at:
http://lua-users.org/lists/lua-l/2020-01/msg00178.html

Make it work under other Operating Systems (needs feedback).


Licensed with the same License with PUC Rio Lua, that is MIT LICENSE.

```
