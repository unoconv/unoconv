# Change Log

## [Unreleased](https://github.com/dagwieers/unoconv/tree/HEAD)

[Full Changelog](https://github.com/dagwieers/unoconv/compare/0.6...HEAD)

**Implemented enhancements:**

- python3 compatibility [\#107](https://github.com/dagwieers/unoconv/issues/107)

- Preserve the original timestamp, ownership and permissions [\#31](https://github.com/dagwieers/unoconv/issues/31)

**Fixed bugs:**

- On Mac OSX + LibreOffice 4.3 Not working [\#221](https://github.com/dagwieers/unoconv/issues/221)

- dyld: Library not loaded: /usr/local/libodep/lib/libintl.8.dylib [\#128](https://github.com/dagwieers/unoconv/issues/128)

- unoconv: option --export must not have an argument [\#93](https://github.com/dagwieers/unoconv/issues/93)

- Configuration of LibreOffice is changed [\#15](https://github.com/dagwieers/unoconv/issues/15)

**Closed issues:**

- unoconv: Cannot find a suitable office installation on your system. [\#236](https://github.com/dagwieers/unoconv/issues/236)

- Libreoffice GraphicImport error [\#234](https://github.com/dagwieers/unoconv/issues/234)

- display\(\) method used by --show should not output to stderr [\#223](https://github.com/dagwieers/unoconv/issues/223)

- not generating content [\#217](https://github.com/dagwieers/unoconv/issues/217)

- UNO IllegalArgument during import phase: Source file cannot be read. Unsupported URL [\#215](https://github.com/dagwieers/unoconv/issues/215)

- can't find libreoffice 4.2.2.1 [\#195](https://github.com/dagwieers/unoconv/issues/195)

- unoconv doesn't ouput UTF-8 text files on windows. [\#185](https://github.com/dagwieers/unoconv/issues/185)

- --version [\#183](https://github.com/dagwieers/unoconv/issues/183)

- uno bridge removed on ubuntu 13.10 [\#182](https://github.com/dagwieers/unoconv/issues/182)

- Cannot Install in centos 6.5 [\#178](https://github.com/dagwieers/unoconv/issues/178)

- My unoconv works perfectly in terminal using www-data, but no pdf file when executed through php [\#139](https://github.com/dagwieers/unoconv/issues/139)

- weirdly quoted output [\#135](https://github.com/dagwieers/unoconv/issues/135)

- please add LICENSE file [\#105](https://github.com/dagwieers/unoconv/issues/105)

**Merged pull requests:**

- Add a extra search path on MacOS X for OpenOffice [\#250](https://github.com/dagwieers/unoconv/pull/250) ([vittala](https://github.com/vittala))

- document --version option in help output [\#200](https://github.com/dagwieers/unoconv/pull/200) ([mmariani](https://github.com/mmariani))

- Add -F|--field to update user-defined fields before exporting document [\#193](https://github.com/dagwieers/unoconv/pull/193) ([raphink](https://github.com/raphink))

- Preserve timestamps and permissions [\#179](https://github.com/dagwieers/unoconv/pull/179) ([vincentbernat](https://github.com/vincentbernat))

- Resolves: fdo\#70309 can't write bytes direct to stdout in python3 [\#170](https://github.com/dagwieers/unoconv/pull/170) ([caolanm](https://github.com/caolanm))

- add Microsoft Works \(.wps\) import filter [\#159](https://github.com/dagwieers/unoconv/pull/159) ([josiasmontag](https://github.com/josiasmontag))

- Find LibreOffice 4.1 on MacOSX [\#154](https://github.com/dagwieers/unoconv/pull/154) ([zopyx](https://github.com/zopyx))

- set format based on extension [\#151](https://github.com/dagwieers/unoconv/pull/151) ([urg](https://github.com/urg))

- make sure LOdev gets new param styles [\#144](https://github.com/dagwieers/unoconv/pull/144) ([clkao](https://github.com/clkao))

- Update README.asciidoc [\#140](https://github.com/dagwieers/unoconv/pull/140) ([simkimsia](https://github.com/simkimsia))

- \#133 fix export to non existent directory [\#134](https://github.com/dagwieers/unoconv/pull/134) ([gazofnaz](https://github.com/gazofnaz))

- Add XLSX support [\#131](https://github.com/dagwieers/unoconv/pull/131) ([josiasmontag](https://github.com/josiasmontag))

- Third attempt to make pull request for fixing issue \#120 [\#127](https://github.com/dagwieers/unoconv/pull/127) ([peterdemin](https://github.com/peterdemin))

- Fix documentation typos [\#117](https://github.com/dagwieers/unoconv/pull/117) ([ojwb](https://github.com/ojwb))

- Add python 3 support [\#111](https://github.com/dagwieers/unoconv/pull/111) ([xrmx](https://github.com/xrmx))

## [0.6](https://github.com/dagwieers/unoconv/tree/0.6) (2012-09-10)

[Full Changelog](https://github.com/dagwieers/unoconv/compare/0.5...0.6)

**Implemented enhancements:**

- unoconv --version fails to display revision number [\#82](https://github.com/dagwieers/unoconv/issues/82)

- Issue with named ubuntu server and office listener. [\#80](https://github.com/dagwieers/unoconv/issues/80)

**Fixed bugs:**

- Permission in unoconv aren't applied to PDF [\#75](https://github.com/dagwieers/unoconv/issues/75)

- Improve 'make install' under MacOS X [\#63](https://github.com/dagwieers/unoconv/issues/63)

- Starting listener fails with "No Info.plist file in application bundle or no NSPrincipalClass in the Info.plist file" [\#60](https://github.com/dagwieers/unoconv/issues/60)

- selinux.txt not a valid asciidoc document [\#53](https://github.com/dagwieers/unoconv/issues/53)

- Installation under Windows? "Cannot find a suitable office installation" [\#52](https://github.com/dagwieers/unoconv/issues/52)

- Unoconv version check is incorrect, fails on older LibreOffice [\#50](https://github.com/dagwieers/unoconv/issues/50)

- Not working on Mac [\#27](https://github.com/dagwieers/unoconv/issues/27)

**Closed issues:**

- r [\#76](https://github.com/dagwieers/unoconv/issues/76)

**Merged pull requests:**

- added explicit check in Listener\(\) if soffice is already running on given \(host, port\) [\#74](https://github.com/dagwieers/unoconv/pull/74) ([vpa](https://github.com/vpa))

- Python path variable using env [\#72](https://github.com/dagwieers/unoconv/pull/72) ([petross](https://github.com/petross))

- Endless recursion fix for windows... [\#71](https://github.com/dagwieers/unoconv/pull/71) ([vpa](https://github.com/vpa))

- Random seg.faults in unoconv [\#67](https://github.com/dagwieers/unoconv/pull/67) ([vpa](https://github.com/vpa))

## [0.5](https://github.com/dagwieers/unoconv/tree/0.5) (2012-04-16)

[Full Changelog](https://github.com/dagwieers/unoconv/compare/0.4...0.5)

**Implemented enhancements:**

- Missing DocTypes?! [\#36](https://github.com/dagwieers/unoconv/issues/36)

- Convert after launching listener [\#30](https://github.com/dagwieers/unoconv/issues/30)

- Close after launching listener [\#29](https://github.com/dagwieers/unoconv/issues/29)

- Deprecated command [\#14](https://github.com/dagwieers/unoconv/issues/14)

- extrapath for LO on OpenBSD [\#8](https://github.com/dagwieers/unoconv/issues/8)

**Fixed bugs:**

- pyuno.so location not inserted into sys.path on Gentoo [\#46](https://github.com/dagwieers/unoconv/issues/46)

- unoconv doesn't work anymore on Fedora 17 [\#45](https://github.com/dagwieers/unoconv/issues/45)

- Launching with single/double hyphen [\#28](https://github.com/dagwieers/unoconv/issues/28)

- LibreOffice 3.5.0 crashes when using python UNO [\#26](https://github.com/dagwieers/unoconv/issues/26)

- uno.RuntimeException: URP-Bridge: disposed\(tid=3\) Unexpected connection closure [\#22](https://github.com/dagwieers/unoconv/issues/22)

- Exception if file doesn't exist [\#17](https://github.com/dagwieers/unoconv/issues/17)

- com.sun.star.beans.PropertyValue may not yet been imported when Options initializing [\#16](https://github.com/dagwieers/unoconv/issues/16)

- unoconv: Cannot find the pyuno library in sys.path and known paths. [\#4](https://github.com/dagwieers/unoconv/issues/4)

- unoconv: UnoException during conversion [\#3](https://github.com/dagwieers/unoconv/issues/3)

**Closed issues:**

- Unable to run unoconv from PHP [\#42](https://github.com/dagwieers/unoconv/issues/42)

- Change/force the document encoding during conversion \(UTF-8\) [\#33](https://github.com/dagwieers/unoconv/issues/33)

- SElinux Problems When Running Indirectly [\#19](https://github.com/dagwieers/unoconv/issues/19)

- JPEG export filter seems to have a size limit [\#13](https://github.com/dagwieers/unoconv/issues/13)

- LibreOffice should use SVG natively [\#11](https://github.com/dagwieers/unoconv/issues/11)

- unoconv needs 2 times to connect to LibreOffice [\#7](https://github.com/dagwieers/unoconv/issues/7)

- Support for .docx conversion [\#1](https://github.com/dagwieers/unoconv/issues/1)

**Merged pull requests:**

- Fix a typo in unoconv manual page. [\#41](https://github.com/dagwieers/unoconv/pull/41) ([vincentbernat](https://github.com/vincentbernat))

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