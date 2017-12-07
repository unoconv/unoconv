# Change Log

## [0.8](https://github.com/dagwieers/unoconv/tree/0.8) (2017-12-07)
[Full Changelog](https://github.com/dagwieers/unoconv/compare/0.7...0.8)

**Implemented enhancements:**

- Update README.adoc [\#370](https://github.com/dagwieers/unoconv/pull/370) ([Atalanttore](https://github.com/Atalanttore))
- Add a command line option to specify import filter name [\#343](https://github.com/dagwieers/unoconv/pull/343) ([MartijnVdS](https://github.com/MartijnVdS))
- manage office exit code 81 on listener [\#327](https://github.com/dagwieers/unoconv/pull/327) ([alikefia](https://github.com/alikefia))
- Typo in manpage [\#313](https://github.com/dagwieers/unoconv/pull/313) ([jacobmischka](https://github.com/jacobmischka))
- Handle SIGTERM when starting as listener [\#301](https://github.com/dagwieers/unoconv/pull/301) ([leture](https://github.com/leture))
- Add .travis.yml to run tests from 3.3 to 5.0 on OS X and Linux [\#296](https://github.com/dagwieers/unoconv/pull/296) ([pquentin](https://github.com/pquentin))
- fix misset printer for drawing [\#294](https://github.com/dagwieers/unoconv/pull/294) ([wmin0](https://github.com/wmin0))
- add printer options [\#282](https://github.com/dagwieers/unoconv/pull/282) ([wmin0](https://github.com/wmin0))
- Add extra bin/lib directories for LibreOffice on OS X [\#276](https://github.com/dagwieers/unoconv/pull/276) ([hubgit](https://github.com/hubgit))

**Fixed bugs:**

- Ambiguous message [\#326](https://github.com/dagwieers/unoconv/issues/326)
- Fix travis downloads [\#314](https://github.com/dagwieers/unoconv/pull/314) ([pquentin](https://github.com/pquentin))
- Fix for Python 3 to read binary data from stdin [\#309](https://github.com/dagwieers/unoconv/pull/309) ([kaysersoze](https://github.com/kaysersoze))

**Closed issues:**

- failed to replace variable 'A' with value 'B' in the document. [\#425](https://github.com/dagwieers/unoconv/issues/425)
- Add more maintainers [\#411](https://github.com/dagwieers/unoconv/issues/411)
- PPT changing color while converting with Unoconv [\#406](https://github.com/dagwieers/unoconv/issues/406)
- ERROR: No module named 'uno' [\#403](https://github.com/dagwieers/unoconv/issues/403)
- unoconv from pptx, text is rendered as image [\#401](https://github.com/dagwieers/unoconv/issues/401)
- Compare docs [\#400](https://github.com/dagwieers/unoconv/issues/400)
- Unoconv creates new file with root permissions [\#394](https://github.com/dagwieers/unoconv/issues/394)
- xsl:attribute: Cannot add attributes to an element if children have been already added to the element. [\#387](https://github.com/dagwieers/unoconv/issues/387)
- Output file is owned by root [\#381](https://github.com/dagwieers/unoconv/issues/381)
- PPT to PDF: Textboxes underneath images appearing on top of image [\#378](https://github.com/dagwieers/unoconv/issues/378)
- script works fine with CLI but do not work with browser [\#365](https://github.com/dagwieers/unoconv/issues/365)
- Problem to execute from PHP \(Ubuntu, XAMPP\) [\#353](https://github.com/dagwieers/unoconv/issues/353)
- Progress bar [\#346](https://github.com/dagwieers/unoconv/issues/346)
- Can't get remote listener to work [\#341](https://github.com/dagwieers/unoconv/issues/341)
- Can't run unoconv as www-data user in Ubuntu 14.04LTS [\#336](https://github.com/dagwieers/unoconv/issues/336)
- Segmentation fault on Alpine Linux [\#333](https://github.com/dagwieers/unoconv/issues/333)
- Some docx files that contained table does not be converted to pdf exactly [\#330](https://github.com/dagwieers/unoconv/issues/330)
- Can not convert ppt file to pdf file with file name which contain japanese character.  [\#325](https://github.com/dagwieers/unoconv/issues/325)
- How to install latest unoconv from github into ubuntu 14.40 headless terminal? [\#323](https://github.com/dagwieers/unoconv/issues/323)
- mac osx + emf conversion delegates to imagemagick which doesnt support it [\#320](https://github.com/dagwieers/unoconv/issues/320)
- Unable to use unoconv through php shell\_exec [\#302](https://github.com/dagwieers/unoconv/issues/302)
- Running 2+ instances of unoconv concurrently results in error [\#299](https://github.com/dagwieers/unoconv/issues/299)
- Missing help option in help output [\#297](https://github.com/dagwieers/unoconv/issues/297)
- OS X, LibreOffice 4.4 and 5.0: no suitable office installation [\#292](https://github.com/dagwieers/unoconv/issues/292)
- Enhancing the performance on converting text files [\#291](https://github.com/dagwieers/unoconv/issues/291)
- Cannot find a suitable pyuno library and python binary combination in /usr/lib/libreoffice [\#290](https://github.com/dagwieers/unoconv/issues/290)
- Conversion of a list from a docx to html [\#287](https://github.com/dagwieers/unoconv/issues/287)
- unoconv 0.7 hangs out of nowhere [\#274](https://github.com/dagwieers/unoconv/issues/274)
- pagination [\#268](https://github.com/dagwieers/unoconv/issues/268)
- LibreOffice Python Syntax Error Mac OS X [\#166](https://github.com/dagwieers/unoconv/issues/166)

**Merged pull requests:**

- \* make -F switch working for user-defined fields [\#426](https://github.com/dagwieers/unoconv/pull/426) ([belegnar](https://github.com/belegnar))
- Updated Changelog and docs [\#422](https://github.com/dagwieers/unoconv/pull/422) ([regebro](https://github.com/regebro))
- Added setup.py [\#421](https://github.com/dagwieers/unoconv/pull/421) ([regebro](https://github.com/regebro))
- Drop support for v3.3 and v3.4 [\#413](https://github.com/dagwieers/unoconv/pull/413) ([regebro](https://github.com/regebro))
- pass the password as openoffice expects it, so it will work for docum… [\#358](https://github.com/dagwieers/unoconv/pull/358) ([monomelodies](https://github.com/monomelodies))

## [0.7](https://github.com/dagwieers/unoconv/tree/0.7) (2015-07-08)
[Full Changelog](https://github.com/dagwieers/unoconv/compare/0.6...0.7)

**Implemented enhancements:**

- --version and --help commands should return 0 status code [\#222](https://github.com/dagwieers/unoconv/issues/222)
- Using unoconv with pyenv [\#204](https://github.com/dagwieers/unoconv/issues/204)
- Add --version option [\#183](https://github.com/dagwieers/unoconv/issues/183)
- Error using --stdout in a win32 box - CR + LF instead LF [\#112](https://github.com/dagwieers/unoconv/issues/112)
- python3 compatibility [\#107](https://github.com/dagwieers/unoconv/issues/107)
- unoconv includes deleted text when converting from doc to txt [\#40](https://github.com/dagwieers/unoconv/issues/40)
- Add an --stdin option to read content from stdin [\#35](https://github.com/dagwieers/unoconv/issues/35)
- Preserve the original timestamp, ownership and permissions [\#31](https://github.com/dagwieers/unoconv/issues/31)
- Minor readme addition about HOME directory \(\#87\) [\#265](https://github.com/dagwieers/unoconv/pull/265) ([pataquets](https://github.com/pataquets))
- Cycle through all images in input file [\#254](https://github.com/dagwieers/unoconv/pull/254) ([integritydc](https://github.com/integritydc))
- Add change log file. [\#253](https://github.com/dagwieers/unoconv/pull/253) ([skywinder](https://github.com/skywinder))
- Add a extra search path on MacOS X for OpenOffice [\#250](https://github.com/dagwieers/unoconv/pull/250) ([vittala](https://github.com/vittala))
- document --version option in help output [\#200](https://github.com/dagwieers/unoconv/pull/200) ([mmariani](https://github.com/mmariani))
- Add -F|--field to update user-defined fields before exporting document [\#193](https://github.com/dagwieers/unoconv/pull/193) ([raphink](https://github.com/raphink))
- Preserve timestamps and permissions [\#179](https://github.com/dagwieers/unoconv/pull/179) ([vincentbernat](https://github.com/vincentbernat))
- Correct output of "make help" [\#174](https://github.com/dagwieers/unoconv/pull/174) ([ojwb](https://github.com/ojwb))
- Find LibreOffice 4.1 on MacOSX [\#154](https://github.com/dagwieers/unoconv/pull/154) ([zopyx](https://github.com/zopyx))
- set format based on extension [\#151](https://github.com/dagwieers/unoconv/pull/151) ([urg](https://github.com/urg))
- Update README.asciidoc [\#140](https://github.com/dagwieers/unoconv/pull/140) ([simkimsia](https://github.com/simkimsia))
- Add XLSX support [\#131](https://github.com/dagwieers/unoconv/pull/131) ([josiasmontag](https://github.com/josiasmontag))
- Fix documentation typos [\#117](https://github.com/dagwieers/unoconv/pull/117) ([ojwb](https://github.com/ojwb))
- Add python 3 support [\#111](https://github.com/dagwieers/unoconv/pull/111) ([xrmx](https://github.com/xrmx))

**Fixed bugs:**

- Mismatch of output basename for file and dir [\#251](https://github.com/dagwieers/unoconv/issues/251)
- an error occurred when called by lua in nginx [\#224](https://github.com/dagwieers/unoconv/issues/224)
- On Mac OSX + LibreOffice 4.3 Not working [\#221](https://github.com/dagwieers/unoconv/issues/221)
- --output is broken in master [\#210](https://github.com/dagwieers/unoconv/issues/210)
- Handling exit code 81 [\#192](https://github.com/dagwieers/unoconv/issues/192)
- Failure to convert when specifying a non-existing output directory \(ErrCode 283\) [\#133](https://github.com/dagwieers/unoconv/issues/133)
- dyld: Library not loaded: /usr/local/libodep/lib/libintl.8.dylib [\#128](https://github.com/dagwieers/unoconv/issues/128)
- When converting odt to pdf table of contents may have wrong page numbers [\#120](https://github.com/dagwieers/unoconv/issues/120)
- unoconv: option --export must not have an argument [\#93](https://github.com/dagwieers/unoconv/issues/93)
- MathType equations in docx file generates very small images [\#91](https://github.com/dagwieers/unoconv/issues/91)
- Configuration of LibreOffice is changed [\#15](https://github.com/dagwieers/unoconv/issues/15)
- Fix python2 compatibility after 3249fd3 [\#175](https://github.com/dagwieers/unoconv/pull/175) ([xrmx](https://github.com/xrmx))
- Resolves: fdo\#70309 can't write bytes direct to stdout in python3 [\#170](https://github.com/dagwieers/unoconv/pull/170) ([caolanm](https://github.com/caolanm))
- \#133 fix export to non existent directory [\#134](https://github.com/dagwieers/unoconv/pull/134) ([gazofnaz](https://github.com/gazofnaz))
- Third attempt to make pull request for fixing issue \#120 [\#127](https://github.com/dagwieers/unoconv/pull/127) ([peterdemin](https://github.com/peterdemin))

**Closed issues:**

- unoconv Office probably died. Unsupported URL..all libreoffice packages have been installed [\#264](https://github.com/dagwieers/unoconv/issues/264)
- How to convert an encoded text file into a pdf one [\#262](https://github.com/dagwieers/unoconv/issues/262)
- Unoconv requires LibreOffice installed even when connecting to remote listener [\#260](https://github.com/dagwieers/unoconv/issues/260)
- sudo -u www unoconv -f pdf 1.ppt  erro   help me!! [\#259](https://github.com/dagwieers/unoconv/issues/259)
- ImportError: No module named 'com' \(or 'com.sun.star.document.UpdateDocMode.QUIET\_UPDATE' is unknown\) [\#258](https://github.com/dagwieers/unoconv/issues/258)
- Run unoconv with libre on another server [\#257](https://github.com/dagwieers/unoconv/issues/257)
- ImportError: No module named 'encodings' [\#255](https://github.com/dagwieers/unoconv/issues/255)
- Not able to manage/handle page breaks  [\#249](https://github.com/dagwieers/unoconv/issues/249)
- Row freeze won't survive conversion ods-\>xls [\#245](https://github.com/dagwieers/unoconv/issues/245)
- Support for pptx docx [\#244](https://github.com/dagwieers/unoconv/issues/244)
- Unoconv fails with error "Error: Unable to connect or start own listener. Aborting" if LibreOffice has never been run [\#241](https://github.com/dagwieers/unoconv/issues/241)
- unconv error "The document 'file:///tmp/file.xlsx' could not be opened [\#237](https://github.com/dagwieers/unoconv/issues/237)
- unoconv: Cannot find a suitable office installation on your system. [\#236](https://github.com/dagwieers/unoconv/issues/236)
- can not convert odt to ods [\#235](https://github.com/dagwieers/unoconv/issues/235)
- Libreoffice GraphicImport error [\#234](https://github.com/dagwieers/unoconv/issues/234)
- unoconv supports python 2.6? [\#233](https://github.com/dagwieers/unoconv/issues/233)
- unoconv: RuntimeException during import phase: Office probably died. Unsupported URL  [\#232](https://github.com/dagwieers/unoconv/issues/232)
- Cant convert a pdf file to a doc file [\#229](https://github.com/dagwieers/unoconv/issues/229)
- backtrace trying to convert \*.ods to xls format on Slackware64-14.1 \(ErrCode 3088\) [\#228](https://github.com/dagwieers/unoconv/issues/228)
- PDF to doc/xls/html/xhtml fails \(ErrCode 3088\) [\#226](https://github.com/dagwieers/unoconv/issues/226)
- display\(\) method used by --show should not output to stderr [\#223](https://github.com/dagwieers/unoconv/issues/223)
- problem in converting documents to pdf with argument "--stdout" \(ErrCode 3088\) [\#220](https://github.com/dagwieers/unoconv/issues/220)
- After starting the system,the fisrt time I use unoconv always fail. [\#219](https://github.com/dagwieers/unoconv/issues/219)
- not generating content [\#217](https://github.com/dagwieers/unoconv/issues/217)
- centos 6 unoconv doesn't work [\#216](https://github.com/dagwieers/unoconv/issues/216)
- UNO IllegalArgument during import phase: Source file cannot be read. Unsupported URL [\#215](https://github.com/dagwieers/unoconv/issues/215)
- Setting page size for pdf conversion [\#208](https://github.com/dagwieers/unoconv/issues/208)
- Missing binary location [\#207](https://github.com/dagwieers/unoconv/issues/207)
- libre office 4.3 requires double-dash args \(--headless instead of -headless\) [\#205](https://github.com/dagwieers/unoconv/issues/205)
- Facing problem during conversion [\#196](https://github.com/dagwieers/unoconv/issues/196)
- can't find libreoffice 4.2.2.1 [\#195](https://github.com/dagwieers/unoconv/issues/195)
- Unoconv gets stuck converting one HTML into PDF [\#191](https://github.com/dagwieers/unoconv/issues/191)
- Combines with asciidoc and docbook2odf/xhtml2odt to create PDF or Word \(.doc\) files  [\#188](https://github.com/dagwieers/unoconv/issues/188)
- any way to make the convert faster? [\#187](https://github.com/dagwieers/unoconv/issues/187)
- unoconv doesn't ouput UTF-8 text files on windows. [\#185](https://github.com/dagwieers/unoconv/issues/185)
- uno bridge removed on ubuntu 13.10 \(ErrCode 283\) [\#182](https://github.com/dagwieers/unoconv/issues/182)
- unoconv: Cannot find a suitable office installation on your system MAC [\#163](https://github.com/dagwieers/unoconv/issues/163)
- How to Install unoconv install mac Os-x 10.8.4 ?  [\#162](https://github.com/dagwieers/unoconv/issues/162)
- CSV export - FilterOptions ignored [\#161](https://github.com/dagwieers/unoconv/issues/161)
- UNO IllegalArgument during import phase: Source file cannot be read. [\#160](https://github.com/dagwieers/unoconv/issues/160)
- Error: Unable to connect or start own listener. Aborting. [\#155](https://github.com/dagwieers/unoconv/issues/155)
- unoconv doc to txt with russian symbols: output "?????? ?????" [\#148](https://github.com/dagwieers/unoconv/issues/148)
- Gdk-WARNING \*\*: locale not supported by C library [\#147](https://github.com/dagwieers/unoconv/issues/147)
- UNO IllegalArgument during import phase: Source file cannot be read. URL seems to be an unsupported one [\#145](https://github.com/dagwieers/unoconv/issues/145)
- My unoconv works perfectly in terminal using www-data, but no pdf file when executed through php [\#139](https://github.com/dagwieers/unoconv/issues/139)
- Export options to PDF does not work [\#138](https://github.com/dagwieers/unoconv/issues/138)
- Document does not maintain format when converting to PDF [\#137](https://github.com/dagwieers/unoconv/issues/137)
- weirdly quoted output [\#135](https://github.com/dagwieers/unoconv/issues/135)
- unoconv freezes randomly [\#130](https://github.com/dagwieers/unoconv/issues/130)
- Source file cannot be read. Unsupported URL [\#129](https://github.com/dagwieers/unoconv/issues/129)
- Installing / running unoconv on Mac Os X [\#125](https://github.com/dagwieers/unoconv/issues/125)
- UnoException when converting xlsx to html \(ErrCode 3088\) [\#119](https://github.com/dagwieers/unoconv/issues/119)
- SyntaxError: invalid syntax [\#114](https://github.com/dagwieers/unoconv/issues/114)
- UNOCONV unable to convert pdf back to pptx. [\#110](https://github.com/dagwieers/unoconv/issues/110)
- Add switch to break image links in text docs. [\#109](https://github.com/dagwieers/unoconv/issues/109)
- PPT/ODP Exporting hidden pages option when exporting to PDF [\#108](https://github.com/dagwieers/unoconv/issues/108)
- doc/docx conversions errors [\#106](https://github.com/dagwieers/unoconv/issues/106)
- please add LICENSE file [\#105](https://github.com/dagwieers/unoconv/issues/105)
- PDF Export security options [\#104](https://github.com/dagwieers/unoconv/issues/104)
- SyntaxError except getopt.error, exc:  [\#102](https://github.com/dagwieers/unoconv/issues/102)
- creation of executable memory area failed: Permission denied on CENTOS 5 [\#99](https://github.com/dagwieers/unoconv/issues/99)
- Default options for Text \(encoded\) export filter with LibreOffice [\#98](https://github.com/dagwieers/unoconv/issues/98)
- Unsupported URL [\#96](https://github.com/dagwieers/unoconv/issues/96)
- Unsupported URL on 64bit Ubuntu 12.04 [\#95](https://github.com/dagwieers/unoconv/issues/95)
- Pb unoconv landscape/portrait in .xls [\#92](https://github.com/dagwieers/unoconv/issues/92)
- unoconv command in debug mode to trace library path [\#89](https://github.com/dagwieers/unoconv/issues/89)
- Problem converting txt files \(ErrCode 2074\) [\#86](https://github.com/dagwieers/unoconv/issues/86)
- Creation of executable memory area failed: Permission denied [\#85](https://github.com/dagwieers/unoconv/issues/85)
- Problem converting cyrillic .doc OR .odt file to .txt [\#73](https://github.com/dagwieers/unoconv/issues/73)
- unoconv: UnoException during export phase [\#66](https://github.com/dagwieers/unoconv/issues/66)
- cannot find suitable pyuno library [\#62](https://github.com/dagwieers/unoconv/issues/62)
- Issue using on webserver [\#58](https://github.com/dagwieers/unoconv/issues/58)
- Converting filenames with non-ascii characters \(ErrCode 2074\) [\#18](https://github.com/dagwieers/unoconv/issues/18)

**Merged pull requests:**

- add Microsoft Works \(.wps\) import filter [\#159](https://github.com/dagwieers/unoconv/pull/159) ([josiasmontag](https://github.com/josiasmontag))
- make sure LOdev gets new param styles [\#144](https://github.com/dagwieers/unoconv/pull/144) ([clkao](https://github.com/clkao))

## [0.6](https://github.com/dagwieers/unoconv/tree/0.6) (2012-09-10)
[Full Changelog](https://github.com/dagwieers/unoconv/compare/0.5...0.6)

**Implemented enhancements:**

- unoconv --version fails to display revision number [\#82](https://github.com/dagwieers/unoconv/issues/82)
- Issue with named ubuntu server and office listener. [\#80](https://github.com/dagwieers/unoconv/issues/80)
- Python path variable using env [\#72](https://github.com/dagwieers/unoconv/pull/72) ([petross](https://github.com/petross))

**Fixed bugs:**

- Permission in unoconv aren't applied to PDF [\#75](https://github.com/dagwieers/unoconv/issues/75)
- Improve 'make install' under MacOS X [\#63](https://github.com/dagwieers/unoconv/issues/63)
- Starting listener fails with "No Info.plist file in application bundle or no NSPrincipalClass in the Info.plist file" [\#60](https://github.com/dagwieers/unoconv/issues/60)
- selinux.txt not a valid asciidoc document [\#53](https://github.com/dagwieers/unoconv/issues/53)
- Installation under Windows? "Cannot find a suitable office installation" [\#52](https://github.com/dagwieers/unoconv/issues/52)
- Unoconv version check is incorrect, fails on older LibreOffice [\#50](https://github.com/dagwieers/unoconv/issues/50)
- Not working on Mac [\#27](https://github.com/dagwieers/unoconv/issues/27)
- Endless recursion fix for windows... [\#71](https://github.com/dagwieers/unoconv/pull/71) ([vpa](https://github.com/vpa))
- Random seg.faults in unoconv [\#67](https://github.com/dagwieers/unoconv/pull/67) ([vpa](https://github.com/vpa))

**Closed issues:**

- unoconv and MacOS [\#81](https://github.com/dagwieers/unoconv/issues/81)
- Export filter problem in unoconv-0.5 PropertyValue not defined [\#78](https://github.com/dagwieers/unoconv/issues/78)
- The fix for Issue \#75 causes "NameError: global name 'PropertyValue' is not defined" [\#77](https://github.com/dagwieers/unoconv/issues/77)
- r [\#76](https://github.com/dagwieers/unoconv/issues/76)
- word document conversion failed [\#70](https://github.com/dagwieers/unoconv/issues/70)
- soffice couldn't connect at first time [\#68](https://github.com/dagwieers/unoconv/issues/68)
- unoconv A New File Name [\#65](https://github.com/dagwieers/unoconv/issues/65)
- Remove support for OpenOffice under MacOS X [\#64](https://github.com/dagwieers/unoconv/issues/64)
- unoconv not working [\#61](https://github.com/dagwieers/unoconv/issues/61)
- Trouble upgrading to CentOS 6 [\#56](https://github.com/dagwieers/unoconv/issues/56)
- upgrade from unoconv 0.3-6 - ubuntu 10.10 [\#55](https://github.com/dagwieers/unoconv/issues/55)
- unoconv convert doc to pdf  make error! [\#54](https://github.com/dagwieers/unoconv/issues/54)
- Basic installation process [\#51](https://github.com/dagwieers/unoconv/issues/51)
- unoconv: Cannot find a suitable pyuno library and python binary combination [\#49](https://github.com/dagwieers/unoconv/issues/49)
- UNO IllegalArgument during import phase: Source file cannot be read. URL seems to be an unsupported one. [\#47](https://github.com/dagwieers/unoconv/issues/47)

**Merged pull requests:**

- added explicit check in Listener\(\) if soffice is already running on given \(host, port\) [\#74](https://github.com/dagwieers/unoconv/pull/74) ([vpa](https://github.com/vpa))

## [0.5](https://github.com/dagwieers/unoconv/tree/0.5) (2012-04-16)
[Full Changelog](https://github.com/dagwieers/unoconv/compare/0.4...0.5)

**Implemented enhancements:**

- Missing DocTypes?! [\#36](https://github.com/dagwieers/unoconv/issues/36)
- Change/force the document encoding during conversion \(UTF-8\) [\#33](https://github.com/dagwieers/unoconv/issues/33)
- Convert after launching listener [\#30](https://github.com/dagwieers/unoconv/issues/30)
- Close after launching listener [\#29](https://github.com/dagwieers/unoconv/issues/29)
- SElinux Problems When Running Indirectly [\#19](https://github.com/dagwieers/unoconv/issues/19)
- Deprecated command [\#14](https://github.com/dagwieers/unoconv/issues/14)
- extrapath for LO on OpenBSD [\#8](https://github.com/dagwieers/unoconv/issues/8)
- Fix a typo in unoconv manual page. [\#41](https://github.com/dagwieers/unoconv/pull/41) ([vincentbernat](https://github.com/vincentbernat))

**Fixed bugs:**

- pyuno.so location not inserted into sys.path on Gentoo [\#46](https://github.com/dagwieers/unoconv/issues/46)
- unoconv doesn't work anymore on Fedora 17 [\#45](https://github.com/dagwieers/unoconv/issues/45)
- Launching with single/double hyphen [\#28](https://github.com/dagwieers/unoconv/issues/28)
- LibreOffice 3.5.0 crashes when using python UNO [\#26](https://github.com/dagwieers/unoconv/issues/26)
- uno.RuntimeException: URP-Bridge: disposed\(tid=3\) Unexpected connection closure [\#22](https://github.com/dagwieers/unoconv/issues/22)
- Exception if file doesn't exist [\#17](https://github.com/dagwieers/unoconv/issues/17)
- com.sun.star.beans.PropertyValue may not yet been imported when Options initializing [\#16](https://github.com/dagwieers/unoconv/issues/16)
- unoconv needs 2 times to connect to LibreOffice [\#7](https://github.com/dagwieers/unoconv/issues/7)
- unoconv: Cannot find the pyuno library in sys.path and known paths. [\#4](https://github.com/dagwieers/unoconv/issues/4)
- unoconv: UnoException during conversion [\#3](https://github.com/dagwieers/unoconv/issues/3)

**Closed issues:**

- IIS socket problem? [\#44](https://github.com/dagwieers/unoconv/issues/44)
- Converting with LibreOffice 3.5.0 doesn't work every time [\#43](https://github.com/dagwieers/unoconv/issues/43)
- Unable to run unoconv from PHP [\#42](https://github.com/dagwieers/unoconv/issues/42)
- UnoException during import phase [\#25](https://github.com/dagwieers/unoconv/issues/25)
- SystemError: dynamic module not initialized properly [\#24](https://github.com/dagwieers/unoconv/issues/24)
- ODT use problem [\#23](https://github.com/dagwieers/unoconv/issues/23)
- JPEG export filter seems to have a size limit [\#13](https://github.com/dagwieers/unoconv/issues/13)
- LibreOffice should use SVG natively [\#11](https://github.com/dagwieers/unoconv/issues/11)
- DLL load failed on windows [\#10](https://github.com/dagwieers/unoconv/issues/10)
- Support for .docx conversion [\#1](https://github.com/dagwieers/unoconv/issues/1)

**Merged pull requests:**

- Daemon [\#38](https://github.com/dagwieers/unoconv/pull/38) ([lars-sh](https://github.com/lars-sh))
- SElinux Problems When Running Indirectly [\#21](https://github.com/dagwieers/unoconv/pull/21) ([dks](https://github.com/dks))
- int values in export filters [\#9](https://github.com/dagwieers/unoconv/pull/9) ([damycra](https://github.com/damycra))
- Option --no-launch [\#6](https://github.com/dagwieers/unoconv/pull/6) ([eagleas](https://github.com/eagleas))
- Add extrapath for official rpm [\#5](https://github.com/dagwieers/unoconv/pull/5) ([eagleas](https://github.com/eagleas))
- Add support for libreoffice [\#2](https://github.com/dagwieers/unoconv/pull/2) ([graaff](https://github.com/graaff))

## [0.4](https://github.com/dagwieers/unoconv/tree/0.4) (2010-10-20)
[Full Changelog](https://github.com/dagwieers/unoconv/compare/0.3...0.4)

## [0.3](https://github.com/dagwieers/unoconv/tree/0.3) (2007-09-01)
[Full Changelog](https://github.com/dagwieers/unoconv/compare/0.2...0.3)

## [0.2](https://github.com/dagwieers/unoconv/tree/0.2) (2007-05-20)
[Full Changelog](https://github.com/dagwieers/unoconv/compare/0.1...0.2)

## [0.1](https://github.com/dagwieers/unoconv/tree/0.1) (2007-05-19)


\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*