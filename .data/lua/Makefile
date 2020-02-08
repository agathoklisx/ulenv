# ------- PUC RIO MAKEFILE --------

include $(MAKEDIR)/common.Makefile

build-lua-devel_: update-repo create-lua-devel-hierarchy
	@$(TEST) ! -d $(PACKAGE_REPO_DIR) || $(REMOVE_REC) $(PACKAGE_REPO_DIR)
	@$(MAKDIR) $(PACKAGE_REPO_DIR)
	@$(COPY) $(MYDIR)/devel.Makefile $(PACKAGE_REPO_DIR)/Makefile
	@$(COPY_REC) $(REPO_ABSPATH) $(PACKAGE_REPO_DIR)/src
	@cd $(PACKAGE_REPO_DIR) && $(MAKE) "INSTALL_TOP=$(SYSDIR)" linux
	@cd $(PACKAGE_REPO_DIR) && $(MAKE) "INSTALL_TOP=$(SYSDIR)" install

build-lua-devel: build-lua-devel_ copy-exec-wrapper

create-lua-devel-hierarchy:
	@$(TEST) -d $(SYSDIR)            || $(MAKDIR) $(SYSDIR)
	@$(TEST) -d $(SYSDIR)/bin        || $(MAKDIR) $(SYSDIR)/bin
	@$(TEST) -d $(SYSDIR)/lib        || $(MAKDIR) $(SYSDIR)/lib
	@$(TEST) -d $(SYSDIR)/include    || $(MAKDIR) $(SYSDIR)/include
