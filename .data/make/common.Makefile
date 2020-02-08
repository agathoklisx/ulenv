clone-repo:
	@$(TEST) -d $(REPO_ABSPATH) || \
      (cd $(SRCDIR) && $(GIT_CLONE) $(UPSTREAM_REPO) $(REPO_NAME))

update-repo: clone-repo
	@cd $(REPO_ABSPATH) && $(GIT_PULL)

get-package:
	$(TEST) -f $(PACKAGE_SRC) || $(GET) $(PACKAGE_SRC) $(PACKAGE_URL)

extract-package: clean-build-directory
	@cd $(BUILDDIR) && $(UNPACK) $(PACKAGE_SRC)

clean-build-directory:
	$(TEST) ! -d $(PACKAGE_DIR) || $(REMOVE_REC) $(PACKAGE_DIR)

build-package_:
	@cd $(PACKAGE_DIR) && $(MAKE) "INSTALL_TOP=$(SYSDIR)" $(OS_TARGET)
	@cd $(PACKAGE_DIR) && $(MAKE) "INSTALL_TOP=$(SYSDIR)" install

build-package: create-sys-hierarchy get-package extract-package \
               build-package_ copy-exec-wrapper

copy-repo:
	@$(TEST) ! -d $(PACKAGE_REPO_DIR) || $(REMOVE_REC) $(PACKAGE_REPO_DIR)
	@$(COPY_REC) $(REPO_ABSPATH) $(PACKAGE_REPO_DIR)

build-devel_:
	@cd $(PACKAGE_REPO_DIR) && $(MAKE) "INSTALL_TOP=$(SYSDIR)" $(OS_TARGET)
	@cd $(PACKAGE_REPO_DIR) && $(MAKE) "INSTALL_TOP=$(SYSDIR)" install

build-devel: update-repo copy-repo build-devel_

copy-exec-wrapper:
	@$(COPY) $(MYDIR)/$(OS_TARGET)-$(MACHINE)-$(IMPLEMENTATION)-$(VERSION) $(BINDIR)
	@$(CHMOD) 755 $(BINDIR)/$(OS_TARGET)-$(MACHINE)-$(IMPLEMENTATION)-$(VERSION)

luarocks-get-package:
	@$(TEST) -f $(LUAROCKS_PACKAGE_SRC) || $(GET) $(LUAROCKS_PACKAGE_SRC) $(LUAROCKS_PACKAGE_URL)

luarocks-extract-package:
	@cd $(LUAROCKS_BUILDDIR) && $(UNPACK) $(LUAROCKS_PACKAGE_SRC)

luarocks-build:
	@cd $(LUAROCKS_PACKAGE_DIR) &&         \
       ./configure --with-lua=$(SYSDIR)    \
       --prefix=$(SYSDIR)                  \
       --with-lua-include=$(INCLUDE_SYSDIR)
	@cd $(LUAROCKS_PACKAGE_DIR) && $(MAKE) install

create-sys-hierarchy:
	@$(TEST) -d $(SYSDIR)            || $(MAKDIR) $(SYSDIR)
	@$(TEST) -d $(SYSDIR)/bin        || $(MAKDIR) $(SYSDIR)/bin
	@$(TEST) -d $(SYSDIR)/lib        || $(MAKDIR) $(SYSDIR)/lib
	@$(TEST) -d $(SYSDIR)/include    || $(MAKDIR) $(SYSDIR)/include
	@$(TEST) -d $(SYSDIR)/share      || $(MAKDIR) $(SYSDIR)/share
	@$(TEST) -d $(SYSDIR)/share/man  || $(MAKDIR) $(SYSDIR)/share/man
	@$(TEST) -d $(SYSDIR)/share/man1 || $(MAKDIR) $(SYSDIR)/share/man1
