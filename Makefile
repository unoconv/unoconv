name = unoconv
version = $(shell awk '/^Version: / {print $$2}' $(name).spec)

prefix = /usr
sysconfdir = /etc
bindir = $(prefix)/bin
sbindir = $(prefix)/sbin
libdir = $(prefix)/lib
datadir = $(prefix)/share
mandir = $(datadir)/man
localstatedir = /var

.PHONY: all install docs clean

bins = doc2odt odt2doc doc2ooxml ooxml2doc odp2pdf odp2ppt ppt2odp ods2pdf odt2bib odt2docbook odt2html odt2lt odt2ooxml ooxml2odt odt2pdf odt2sdw sdw2odt /odt2sxw sxw2odt odt2txt odt2xhtml odt2xml odt2rtf

all: docs
	@echo "There is nothing to be build. Try install !"

docs:
	$(MAKE) -C docs docs

docs-install:
	$(MAKE) -C docs install

install:
	install -Dp -m0755 unoconv $(DESTDIR)$(bindir)/unoconv
	install -Dp -m0644 docs/unoconv.1 $(DESTDIR)$(mandir)/man1/unoconv.1

install-links: $(bins)

$(filter %,$(bins)):
	ln -sf unoconv $(DESTDIR)$(bindir)/$@

### Remove odp because size > 300kB
dist: clean
	$(MAKE) -C docs dist
#	find . ! -path '*/.svn*' | pax -d -w -x ustar -s ',^.,$(name)-$(version),' | bzip2 >../$(name)-$(version).tar.bz2
	find . ! -path '*/.svn*' -a ! -path '*.odp' | pax -d -w -x ustar -s ',^.,$(name)-$(version),' | bzip2 >../$(name)-$(version).tar.bz2

rpm: dist
	rpmbuild -tb --clean --rmsource --rmspec --define "_rpmfilename %%{NAME}-%%{VERSION}-%%{RELEASE}.%%{ARCH}.rpm" --define "_rpmdir ../" ../$(name)-$(version).tar.bz2

srpm: dist
	rpmbuild -ts --clean --rmsource --rmspec --define "_rpmfilename %%{NAME}-%%{VERSION}-%%{RELEASE}.%%{ARCH}.rpm" --define "_srcrpmdir ../" ../$(name)-$(version).tar.bz2

clean:
	rm -f README*.html
	make -C tests clean
