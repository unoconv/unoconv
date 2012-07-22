name = unoconv
version := $(shell cat VERSION)
#version := $(shell awk 'BEGIN { FS="=" } /^VERSION = / { print $$2}' $(name))

### Get the branch information from git
git_date := $(shell git log -n 1 --format="%ai")
git_ref := $(shell git symbolic-ref -q HEAD)
git_branch ?= $(lastword $(subst /, ,$(git_ref)))
git_branch ?= HEAD

date := $(shell date --date="$(git_date)" +%Y%m%d%H%M)
release_date := $(shell date --date="$(git_date)" +%Y-%m-%d)

prefix = /usr
sysconfdir = /etc
bindir = $(prefix)/bin
sbindir = $(prefix)/sbin
libdir = $(prefix)/lib
datadir = $(prefix)/share
mandir = $(datadir)/man
localstatedir = /var

specfile = $(name).spec

DESTDIR =
OFFICIAL =

distversion = $(version)
debrelease = 0
rpmrelease =
ifeq ($(OFFICIAL),)
    distversion = $(version)-git$(date)
    debrelease = 0git$(date)
    rpmrelease = .git$(date)
endif

.PHONY: all install docs clean

to_doc = odt2doc ooxml2doc
to_html = odt2html
to_odp = ppt2odp 
to_ods = xls2ods
to_odt = doc2odt sdw2odt sxw2odt ooxml2odt
to_pdf = doc2pdf odp2pdf ods2pdf odt2pdf ooxml2pdf
to_ppt = odp2ppt
to_other = odt2rtf odt2txt odt2xhtml odt2xml odt2bib odt2docbook odt2lt odt2sdw odt2sxw
links = $(to_doc) $(to_html) $(to_odp) $(to_ods) $(to_odt) $(to_pdf) $(to_ppt) $(to_other)

all: docs
	@echo "There is nothing to be build. Try install !"

docs:
	$(MAKE) -C docs docs

docs-install:
	$(MAKE) -C docs install

install:
	install -d -m0755 $(DESTDIR)$(bindir)
	install -d -m0755 $(DESTDIR)$(mandir)/man1/
	install -p -m0755 unoconv $(DESTDIR)$(bindir)/unoconv
	install -p -m0644 docs/unoconv.1 $(DESTDIR)$(mandir)/man1/unoconv.1

install-links: $(links)

$(filter %,$(links)):
	ln -sf unoconv $(DESTDIR)$(bindir)/$@

### Remove odp because size > 300kB
dist: clean
	$(MAKE) -C docs dist
	echo -e "\033[1m== Building archive $(name)-$(distversion) ==\033[0;0m"
	git ls-tree -r --name-only --full-tree $(git_branch) | \
		tar -czf $(name)-$(distversion).tar.gz --transform='s,^,$(name)-$(distversion)/,S' --files-from=-

rpm: dist
	rpmbuild -tb --clean --rmsource --rmspec --define "_rpmfilename %%{NAME}-%%{VERSION}-%%{RELEASE}.%%{ARCH}.rpm" --define "_rpmdir ../" ../$(name)-$(version).tar.bz2

srpm: dist
	rpmbuild -ts --clean --rmsource --rmspec --define "_rpmfilename %%{NAME}-%%{VERSION}-%%{RELEASE}.%%{ARCH}.rpm" --define "_srcrpmdir ../" ../$(name)-$(version).tar.bz2

clean:
	rm -f README*.html
	make -C tests clean
