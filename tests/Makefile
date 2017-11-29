### Please modify and send me improvements

python=/tmp/python
unoconv=../unoconv

# failing filters doc6 doc95 sdw3 sdw4 sdw sxw
# fails on osx: docbook mediawiki ooxml uot xhtml
all: clean doc fodt html pdf rtf text txt
	@echo "== Tests finished."

#xml: curriculum-vitae-dag-wieers.txt
#	asciidoc -b docbook -d article curriculum-vitae-dag-wieers.txt

#odt: xml
#	rm -f curriculum-vitae-dag-wieers.odt
#	docbook2odf --params generate.meta=0 curriculum-vitae-dag-wieers.xml

%:
#	-killall ooffice soffice.bin
	@echo "- Convert document-example.odt to $@..."
	$(python) $(unoconv) -vvv -p 2002 -T60 -f $@ document-example.odt
	@echo
#	@ps aux | grep office
#	-unoconv -f $@ dag.gif
#	docbook2pdf -d curriculum-vitae.dsl#print curriculum-vitae-dag-wieers.xml

clean:
	@echo "== Tests started. (some may fail)"
	@rm -f *.{bib,doc,html,pdb,pdf,psw,rtf,ltx,sdw,sxw,txt,xml}
	@rm -f *.{jpg,png,svg,wmf}
	@rm -f *.{xls}
	@rm -f *.{pps,ppt}
