all: clean bib doc6 doc95 doc docbook html ooxml pdb pdf psw rtf latex sdw3 sdw4 sdw sxw text txt xhtml

#xml: curriculum-vitae-dag-wieers.txt
#	asciidoc -b docbook -d article curriculum-vitae-dag-wieers.txt

#odt: xml
#	rm -f curriculum-vitae-dag-wieers.odt
#	docbook2odf --params generate.meta=0 curriculum-vitae-dag-wieers.xml

%:
	-unoconv -f $@ curriculum-vitae-dag-wieers.odt
#	docbook2pdf -d curriculum-vitae.dsl#print curriculum-vitae-dag-wieers.xml

clean: 
	rm -f *.{bib,doc,html,pdb,pdf,psw,rtf,ltx,sdw,sxw,txt,xml}
