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
	install -Dp -m0755 unoconv $(DESTDIR)$(bindir)/unoconv
	install -Dp -m0644 docs/unoconv.1 $(DESTDIR)$(mandir)/man1/unoconv.1

install-links: $(links)

$(filter %,$(links)):
	ln -sf unoconv $(DESTDIR)$(bindir)/$@

### Remove odp because size > 300kB
dist: clean
	$(MAKE) -C docs dist
	git ls-tree -r --name-only --full-tree $$(git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/') | pax -d -w -x ustar -s ,^,$(name)-$(version)/, | bzip2 >../$(name)-$(version).tar.bz2
#	svn list -R | grep -v '.odp$$' | pax -d -w -x ustar -s ',^.,$(name)-$(version),' | bzip2 >../$(name)-$(version).tar.bz2
#	svn st -v --xml | \
        xmlstarlet sel -t -m "/status/target/entry" -s A:T:U '@path' -i "wc-status[@revision]" -v "@path" -n | \
        pax -d -w -x ustar -s ,^,$(name)-$(version)/, | \
        bzip2 >../$(name)-$(version).tar.bz2

rpm: dist
	rpmbuild -tb --clean --rmsource --rmspec --define "_rpmfilename %%{NAME}-%%{VERSION}-%%{RELEASE}.%%{ARCH}.rpm" --define "_rpmdir ../" ../$(name)-$(version).tar.bz2

srpm: dist
	rpmbuild -ts --clean --rmsource --rmspec --define "_rpmfilename %%{NAME}-%%{VERSION}-%%{RELEASE}.%%{ARCH}.rpm" --define "_srcrpmdir ../" ../$(name)-$(version).tar.bz2

clean:
	rm -f README*.html
	make -C tests clean
