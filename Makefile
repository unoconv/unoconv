# In some dists (e.g. Ubuntu) bash is not the default shell. Statements like·
# #   cp -a etc/rear/{mappings,templates} ...
# # assumes bash. So its better to set SHELL
# SHELL=/bin/bash

DESTDIR =
OFFICIAL =

name = unoconv
version := $(shell awk "/^__version__ *= */ { gsub(/^__version__[ ]*=[ ']*|[ ']*$$/,\"\"); print}" $(name))

### Get the branch information from git
git_date := $(shell git log -n 1 --format="%ai")
git_ref := $(shell git symbolic-ref -q HEAD)
git_branch ?= $(lastword $(subst /, ,$(git_ref)))
git_branch ?= HEAD

#date := $(shell date --date="$(git_date)" +%Y%m%d%H%M)
#release_date := $(shell date --date="$(git_date)" +%Y-%m-%d)
date := $(shell echo "$(git_date)" | sed -e 's/[-: ]//g'  | cut -c1-12)
release_date := $(shell echo "$(git_date)" | cut -c1-10 )

prefix = /usr
sysconfdir = /etc
bindir = $(prefix)/bin
sbindir = $(prefix)/sbin
libdir = $(prefix)/lib
datadir = $(prefix)/share
mandir = $(datadir)/man
localstatedir = /var

specfile = packaging/rpm/$(name).spec

distversion = $(version)
debrelease = 0
rpmrelease = %nil
ifeq ($(OFFICIAL),)
    distversion = $(version)-git$(date)
    debrelease = 0git$(date)
    rpmrelease = .git$(date)
endif

.PHONY: all install doc clean

to_doc = odt2doc ooxml2doc
to_html = odt2html
to_odp = ppt2odp
to_ods = xls2ods
to_odt = doc2odt sdw2odt sxw2odt ooxml2odt
to_pdf = doc2pdf odp2pdf ods2pdf odt2pdf ooxml2pdf
to_ppt = odp2ppt
to_other = odt2rtf odt2txt odt2xhtml odt2xml odt2bib odt2docbook odt2lt odt2sdw odt2sxw
links = $(to_doc) $(to_html) $(to_odp) $(to_ods) $(to_odt) $(to_pdf) $(to_ppt) $(to_other)

all: doc
	@echo "__version__ = $(version)"
	@echo "There is nothing to be build. Try install !"

help:
	@echo -e "unoconv make targets:\n\
\n\
  install         - Install unoconv (may replace files)\n\
  dist            - Create tar file\n\
  rpm             - Create RPM package\n\
\n\
unoconv make variables (optional):\n\
\n\
  DESTDIR=        - Location to install to\n\
  OFFICIAL=       - Build an official release\n\
"

man:
	@echo -e "\033[1m== Prepare manual ==\033[0;0m"
	$(MAKE) -C doc man

doc:
	@echo -e "\033[1m== Prepare documentation ==\033[0;0m"
	$(MAKE) -C doc docs

ifneq ($(git_date),)
rewrite:
	@echo -e "\033[1m== Rewriting $(specfile) ==\033[0;0m"
	sed -i.orig \
		-e 's#^Source:.*#Source: $(name)-$(distversion).tar.gz#' \
		-e 's#^Version:.*#Version: $(version)#' \
		-e 's#^%define rpmrelease.*#%define rpmrelease $(rpmrelease)#' \
		-e 's#^%setup.*#%setup -q -n $(name)-$(distversion)#' \
		$(specfile)
#	sed -i.orig \
		-e 's#^Version:.*#Version: $(version)-$(debrelease)#' \
		$(dscfile)

restore:
	@echo -e "\033[1m== Restoring $(specfile) and $(rearbin) ==\033[0;0m"
	mv -f $(specfile).orig $(specfile)
else
rewrite:
	@echo "Nothing to do."

restore:
	@echo "Nothing to do."
endif

doc-install:
	$(MAKE) -C doc install

install:
	install -d -m0755 $(DESTDIR)$(bindir)
	install -d -m0755 $(DESTDIR)$(mandir)/man1/
	install -p -m0755 unoconv $(DESTDIR)$(bindir)/unoconv
	install -p -m0644 doc/unoconv.1 $(DESTDIR)$(mandir)/man1/unoconv.1

install-links: $(links)

$(filter %,$(links)):
	ln -sf unoconv $(DESTDIR)$(bindir)/$@

### Remove odp because size > 300kB
dist: clean man rewrite $(name)-$(distversion).tar.gz restore

$(name)-$(distversion).tar.gz:
	@echo -e "\033[1m== Building archive $(name)-$(distversion) ==\033[0;0m"
	git checkout $(git_branch)
	git ls-tree -r --name-only --full-tree $(git_branch) | \
		tar -czf $(name)-$(distversion).tar.gz --transform='s,^,$(name)-$(distversion)/,S' --files-from=-

rpm: dist
	@echo -e "\033[1m== Building RPM package $(name)-$(distversion) ==\033[0;0m"
	rpmbuild -tb --clean \
		--define "_rpmfilename %%{NAME}-%%{VERSION}-%%{RELEASE}.%%{ARCH}.rpm" \
		--define "debug_package %{nil}" \
		--define "_rpmdir %(pwd)" $(name)-$(distversion).tar.gz

clean:
	rm -f README*.html
	make -C tests clean
