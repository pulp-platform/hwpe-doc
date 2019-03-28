# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
SOURCEDIR     = .
BUILDDIR      = _build

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

_ext/svprettyplot:
	mkdir -p _ext;
	cd _ext; git clone https://github.com/FrancescoConti/svprettyplot

_ext/sphinxcontrib:
	mkdir -p _ext/sphinxcontrib;
	cd _ext; git clone https://github.com/bavovanachte/sphinx-wavedrom; mv sphinx-wavedrom/sphinxcontrib/* sphinxcontrib/; rm -rf sphinx-wavedrom

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile _ext/svprettyplot _ext/sphinxcontrib
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
