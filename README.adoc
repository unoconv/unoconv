= Automated conversion and styling using LibreOffice
Dag Wieers <dag@wieers.com>

Universal Office Converter (unoconv) is a command line tool to convert any
document format that LibreOffice can import to any document format that
LibreOffice can export. It makes use of the LibreOffice's UNO bindings for
non-interactive conversion of documents.

_For practical reasons we mention LibreOffice, but OpenOffice is supported by
unoconv as well._

== Installing unoconv
unoconv can be installed using packages coming from your distribution, or
simply by copying the unoconv python script to your system.

If you installed unoconv by hand, make sure you have the required LibreOffice
or OpenOffice packages installed. A hard requirement is the UNO python bindings
which are often inside a subpackage named +libreoffice-pyuno+ or
+libobasis4.4-pyuno+.

Various sub-packages are needed for specific import or export filters, e.g.
XML-based filters require the xsltfilter subpackage,
e.g. +libobasis4.4-xsltfilter+.

IMPORTANT: Neglecting these requirements will cause unoconv to fail with
unhelpful and confusing error messages.


== How does unoconv work ?
unoconv starts its own office instance (if it cannot find an existing
listener) that it then uses. There are some challenges to do this
correctly, but in general this works fine.

Typically you would convert an ODT document to PDF by running:

    unoconv -f pdf some-file.odt


== Start your own unoconv listener
However, you can always start an instance yourself at the default port 2002
(or specify another port with -p/--port) and after use you can tear it down:

----
unoconv --listener &
sleep 20
unoconv -f pdf *.odt
unoconv -f doc *.odt
unoconv -f html *.odt
kill -15 %-
----

It is also possible to use a listener or LibreOffice instance that accepts
connections on another system and use it from unoconv remotely. This
way the conversion tasks are performed on a dedicated system instead
of on the client system. This works only if you have a shared filesystem
mounted at the same location.


== Python and pyuno incompatibilities
Beware that the pyuno python module needs to be compiled with the exact
same version of python that you are using to load it. A lot of people that
run into problems loading pyuno are actually using a precompiled LibreOffice
that they downloaded somewhere and is incompatible with the python version
on their system.

To solve this issue, the project's office suite ships with its own python
interpreter located in the 'program' directory, this one should work
flawlessly.

The most recent unoconv works around this issue by automatically detecting
incompatibilities, and restarting itself using a compatible python (the same
one that ships with LibreOffice).

You can influence the automatic detection by setting the +UNO_PATH+ environment
variable to point to an alternative LibreOffice installation, e.g.:

    UNO_PATH=/opt/libreoffice4.4 unoconv -f pdf some-file.odt

But you can also force another python by using it to execute unoconv, e.g.:

    /opt/libreoffice4.4/program/python.bin unoconv -f pdf some-file.odt

or on macOS:

    /Applications/LibreOffice.app/Contents/MacOS/python unoconv -f pdf some-file.odt

or on Windows:

    C:\Program Files (x86)\LibreOffice 4.4\program\python.exe unoconv -f pdf some-file.odt

TIP: If you plan to use unoconv extensively (or in an automated fashion) it
is more efficient to use the correct python interpreter directly. Or event
put it directly in the Shebang (the first line) of the unoconv script !


== Using unoconv with no X display
Since OpenOffice 2.3 you do not need an X display for starting ooffice.
However you may need the openoffice.org-headless package from your
distribution. Since LibreOffice 2.4 nothing special is needed, running
in headless mode does not require X.

For any older OpenOffice releases, remember that ooffice requires an X
display, even when using it in headless mode. One solution is to use Xvfb
to create a headless X display for ooffice.

 - http://www.oooforum.org/forum/viewtopic.phtml?t=11890
 - http://www.wonko.be/2008/01/09/running-openoffice-headless-on-debian
 - http://ward.vandewege.net/writings/200510auto_doc_conv/
 - http://www.artofsolving.com/node/10


== Using unoconv with macOS
LibreOffice 3.6.0.1 or later is required to use unoconv under macOS.  This
is the first version distributed with an internal python script that works.
No version of OpenOffice for macOS (3.4 is the current version) works because
the necessary internal files are not included inside the application.


== Problems running unoconv from Nginx/Apache/PHP
Some people have had difficulties using unoconv through webservices. Here
is a list of probable causes and recommendations:

 - Use the latest version of unoconv (or GitHub master branch)

 - Use the most recent stable release of LibreOffice (less memory, more stable, fewer crashes)

 - Use the native LibreOffice python binary to run unoconv

 - Hardcode this native python path in the unoconv script shebang (or ensure PATH is set)

 - Ensure that the user running unoconv has write access to its HOME directory (ensure HOME is set)

 - Test with SELinux in permissive mode

It is recommended to open the unoconv script and modify the very first line to
point directly to your installed LibreOffice python binary, so replace this:

    #!/usr/bin/env python

with something like this:

    #!/opt/libreoffice4.4/program/python

== Conversion problems
If you encounter problems converting files, it often helps to try again. If
you are using a listener, restarting the listener may help as well.

The reason for conversion failures are unclear, and they are not
deterministic. unoconv is not the only project to have noticed problems
with import and export filters using PyUNO. We assume these are related
to internal state or timing issues that under certain conditions fail
to correctly work.

If you can reproduce the problem on a specific file, please take the time to
open the file in LibreOffice directly and export it to the desired format. If
this fails, it needs to be reported to the LibreOffice project directly. If
that works, we need to know !

We are looking into this with the LibreOffice developers to:

 - Collaborate closer to find, report and fix unexpected failures
 - Allow end-users to increase debugging and improve reporting to the project


== Troubleshooting instructions
If you encounter a problem with converting documents using unoconv, please
consider that this could be caused by a number of things:

 - incomplete LibreOffice installation
 - LibreOffice bug or regression specific to your version/distribution
 - LibreOffice import or export filter issue
 - problem related to stale lock files
 - problem related to the source document
 - problem related to permissions or SELinux
 - problem related to the python UNO bindings
 - problem related to the unoconv python script

It is recommended to follow all of the below steps to pinpoint the problem:

 - if this is the first time you are using LibreOffice/OpenOffice, make sure
   you have all the required sub-packages installed, depending on the
   distribution this could be the +xsltfilter+, +headless+, +writer+,
   +calc+, +impress+ or +draw+ sub-packages.

 - check if there is no existing LibreOffice process running on the system
   that could interfere with proper functioning

        # pgrep -l 'office|writer|calc'

 - check that there are no stale lock files present, e.g. '.~lock.file.pdf#' or
   '.~lock.index.html#'

 - check that the LibreOffice instance handling UNO requests is not handling
   multiple requests at the same time

 - try using the latest unoconv release, or the latest version on Github at:
   https://github.com/dagwieers/unoconv/downloads

 - try the conversion by opening the file in LibreOffice and exporting
   it through LibreOffice directly

 - try unoconv with a different minor or major LibreOffice version to test
   whether it is a regression in LibreOffice

 - try to load the UNO bindings in python manually:

   * do this with the python executable that ships with the LibreOffice
     package/installer

        # /opt/libreoffice4.4/program/python.bin -c 'import uno, unohelper'

   * or alternatively, run the distribution python (with the distribution
     LibreOffice)

        # python -c 'import uno, unohelper'

 - try unoconv with a different python interpreter manually:

    # /opt/libreoffice4.4/program/python.bin unoconv -f pdf test-file.odt

If you tried all of the above, and the issue still remains, the issue might
still be related to import/export filters, LibreOffice or unoconv, so please
report any information to reproduce the problem on the Github issue-tracker
at: https://github.com/dagwieers/unoconv/issues

And do mention that you already tried the above hints to troubleshoot the issue.


== Interesting information
If you're interested to help out with development, here are some pointers to
interesting sources:

 - [Tutorial] Import uno module to a different Python install
   http://user.services.openoffice.org/en/forum/viewtopic.php?f=45&t=36370&p=166783

 - UDK: UNO Development Kit
   http://udk.openoffice.org/

 - Python-UNO bridge
   http://www.openoffice.org/udk/python/python-bridge.html

 - Python and OpenOffice.org
   http://wiki.services.openoffice.org/wiki/Python

 - OpenOffice.org developer manual
   http://api.openoffice.org/DevelopersGuide/DevelopersGuide.html

 - Framework/Article/Filter/FilterList OOo 2 1
   http://wiki.services.openoffice.org/wiki/Framework/Article/Filter/FilterList_OOo_2_1

 - Framework/Article/Filter/FilterList OOo 3 0
   http://wiki.services.openoffice.org/wiki/Framework/Article/Filter/FilterList_OOo_3_0


== Other implementations
Other implementations using python and UNO:

 - convwatch
   http://cgit.freedesktop.org/libreoffice/core/tree/bin/convwatch.py

 - oooconv
   https://svn.infrae.com/oooconv/trunk/src/oooconv/filters.py

 - officeshots.org
   http://code.officeshots.org/trac/officeshots/browser/trunk/factory/src/backends/oooserver.py

 - cloudooo
   http://svn.erp5.org/erp5/trunk/utils/cloudooo.handler/ooo/cloudooo/handler/ooo/


== Related tools
Other tools that are useful or similar in operation:

 - Text based document generation:
   http://www.methods.co.nz/asciidoc/

 - DocBook to OpenDocument XSLT:
   http://open.comsultia.com/docbook2odf/

 - Simple (and stupid) converter from OpenDocument Text to plain text:
   http://stosberg.net/odt2txt/

 - Another python tool to aid in converting files using UNO:
   http://www.artofsolving.com/files/DocumentConverter.py
   http://www.artofsolving.com/opensource/pyodconverter
