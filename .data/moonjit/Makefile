# ------- MOONJIT MAKEFILE --------

include $(MAKEDIR)/common.Makefile

build-moonjit_: create-sys-hierarchy get-package extract-package
	@cd $(PACKAGE_DIR) && $(MAKE) "PREFIX=$(SYSDIR)"
	@cd $(PACKAGE_DIR) && $(MAKE) "PREFIX=$(SYSDIR)" install

build-moonjit: build-moonjit_ copy-exec-wrapper

build-moonjit-devel: update-repo copy-repo copy-exec-wrapper
	@cd $(PACKAGE_REPO_DIR) && $(MAKE) "PREFIX=$(SYSDIR)"
	@cd $(PACKAGE_REPO_DIR) && $(MAKE) "PREFIX=$(SYSDIR)" install
