prefix = /usr
datadir = $(prefix)/share
mandir = $(datadir)/man

adoctargets = $(shell echo *.adoc)
htmltargets = $(patsubst %.adoc, %.html, $(adoctargets))

all: docs

dist: docs

man: unoconv.1

docs: unoconv.1 $(htmltargets)

install: unoconv.1
	install -Dp -m0644 unoconv.1 $(DESTDIR)$(mandir)/man1/unoconv.1

clean:
	rm -f unconv.1 *.html *.xml

%.1.html: %.1.adoc
	asciidoc -d manpage $<

%.1: %.1.xml
	xmlto man $<

%.html: %.adoc
	asciidoc $<

%.1.xml: %.1.adoc
	asciidoc -b docbook -d manpage $<
