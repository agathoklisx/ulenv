# ------- PUC RIO MAKEFILE --------

include $(MAKEDIR)/common.Makefile

build-ravi: create-sys-hierarchy get-package extract-package \
            patch-ravi-1.0-beta3                             \
            build-package_ copy-exec-wrapper

patch-ravi-1.0-beta3:
	@cd $(PACKAGE_DIR) && $(PATCH) -Np0 -i $(MYDIR)/patches/ravi-1.0-beta3_fix_include.patch

build-ravi-devel: update-repo copy-repo build-mir copy-exec-wrapper

build-mir:
	@cd $(PACKAGE_REPO_DIR) && $(MAKDIR) buildmir
	@cd $(PACKAGE_REPO_DIR)/buildmir && \
        $(CMAKE) -DCMAKE_INSTALL_PREFIX=$(SYSDIR) -DCMAKE_BUILD_TYPE=Release -G "Unix Makefiles" -DMIR_JIT=ON ..
	@cd $(PACKAGE_REPO_DIR)/buildmir && $(MAKE) install
