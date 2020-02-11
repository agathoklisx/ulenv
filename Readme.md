```C
/*
            UNITED LUA LANGUAGE ENVIRONMENT

This is to explore some possibilities and aims to demonstrate the power of diversity
in the Lua Universe.


At this stage is at the prototype level, but already usefull at least as a testing
tool and as a basis to extend Lua on other domains besides embedded environments.

It builds the following targets:

  - PUC Rio Lua
    -  5.1.5
    -  5.2.4
    -  5.3.5
    -  development sources (seems Linux only)

  - Ravi Lua - https://ravilang.github.io/
    -  1.0-beta3
    -  development sources with mir as jit backend (Linux and X86-64 only)

  - Ahead Of Time Lua - https://github.com/hugomg/lua-aot
    -  development sources targeting Lua 5.4

  - MoonJit Lua - https://github.com/moonjit/moonjit
    -  2.2.0
    -  development sources

  - NeLua - https://github.com/edubart/nelua-lang
    - dev-1

Usage:
*/

```sh
  # by default builds PUC Rio Lua 5.3.5 plus luarocks at the same sys hierarchy
  make

  # same but use clang as a C compiler
  make CC=clang

  # older releases plus current development plus luarocks
  make PRIO_LUA_VERSION=5.2.4 prio-lua
  make PRIO_LUA_VERSION=5.1.5 prio-lua
  make prio-lua-devel

  #  Ravi Lua but without luarocks
  make ravi-lua
  make ravi-lua-devel

  #  Ahead Of Time Lua with luarocks (only development sources)
  make aot-lua-devel

  #  MoonJit with luarocks (recognized as luajit and targets 5.1)
  make moonjit
  make moonjit-devel

  #  NeLua (this builds by default lua-5.3.5 and calls luarocks to install NeLua's
  #  compiler - it doesn't provide a wrapper for now, NeLua does it by itself)
  make nelua

  # and this builds all the above targets
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

  make nelua-clone-repo
  make nelua-update-repo

  # Hierarchy:

  # ROOTDIR (this directory)

  # sources directory
  # $ROOTDIR/src/{lua,ravi,aot,moonjit,nelua}/{RELEASE,repo}

  # build directory
  # $ROOTDIR/src/build/{lua,ravi,aot,moonjit}/{RELEASE,repo}

  # sys directory
  # $ROOTDIR/sys/`uname -s`/`uname -m`/{VERSION,devel}/{bin,lib,include,share}

  # bin directory with wrappers to invoke and without classes the above interpreters
  # $ROOTDIR/sys/bin

  # data dir (internal details: Makefiles, wrappers, patches)
  # $ROOTDIR/.data/{lua,ravi,aot,moonjit}
  # here you develop $ROOTDIR/.data/IMPLEMENTATION/Makefile
  # as at any target this updated automatically, or explicitly by (e.g. for ravi):
  # make ravi-lua-update-makefile

  # Note: the zsh shell offers excellent tab completion for make.
```
```C
/*

Development under Linux and with GNU make as make utility.
Tested with gcc-9.1.0 and clang-9.0.0

The low revision is implemented with Makefiles.

Development:

Provide a Lua Standard Library (lstl) see at:
http://lua-users.org/lists/lua-l/2020-01/msg00178.html

Make it work under other Operating Systems (needs feedback).

And the supposedly end goal and which is to offer:

  - multiply ways to write and express

  - independable micro-environments
    - their SYSDIR will have to have anything to be fully functional

  - a supervisor environment to provide services to the environment
    - independable, that means can even provide C and C++ compilers (at some point)
      or|and a libc, that means even a minimal C runtime, see for instance:
         https://github.com/lpsantil/rt0

   - basic system commands like: lcp, lrm, lmkdir, ... (though __lcp might be faster
     in tab completions) and ... an init. We really want here to be pid 1 at some
     point

   - applications, like... a really really tiny web browser

  And with Lua in the middle.

And that is and the only ambition, which is to be realized by the community, this
tremendous power that comes from the diversity, and which brings us to a path of
an eternal evolution and at the end to sensible innovations full of conscience.

Licensed with the same License with PUC Rio Lua, that is MIT LICENSE (note:

   There is another view here: as normally no human being should need any kind of an
   enforcement to do the right "loyal" thing: as supposedly those beings that don't
   respect the logic and other human beings here, they are on prisons right now and
   the rest live in full conscience and pride.

   Here is a bit more conscience and the single most important: it had been proved by
   the open source movement (headed and established by the GNU and FSF organizations),
   that is a quite logical and smart choise also, as the code evolution in this case
   is:

     - too much much faster
     - and much more accurate, as the open sourced code is seen by a gigantic pool of
       coders this time on earth, where some (if not most), looks very keen with the
       details

   And the least important which is about "the real economy". It is utterly stupid to
   invest in closed source products, if they have a value: as it is much more clever
   to built a community around it and let the community to do the work for you! How
   does it sound? The most you pay for a couple of experts to make the commits and be
   done with that. And we have to know also that in a court with a Jury with some of
   the people we admire and respect, like Socrates or Jesus or Budha, this is a quite
   of an easy case, as obviously is unethical to pay for a tool, but yet doesn't owe
   this tool to you. The obvious right thing to do here is to give also to the proud
   customer and the source code with every payment. But it is also stupid and because
   the people have the illusion. that without exposing the code to the wild you have
   some kind of safety. What an unbelievable huge fallacy!!! As it has been proved by
   the mere facts of the history, that it is quite the contrary. Anyway, since we can
   not do without licenses for now, there is no other choise than this license. Sorry.
)
*/
```
