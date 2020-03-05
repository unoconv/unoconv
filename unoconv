#!/usr/bin/env python

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation: version 2 only.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY, without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
# Copyright 2007-2010 Dag Wieers <dag@wieers.com>

from __future__ import print_function

from distutils.version import LooseVersion
import getopt
import glob
import os
import signal
import subprocess
import sys
import time

__version__ = '0.8.2'

doctypes = ('document', 'graphics', 'presentation', 'spreadsheet')

global convertor, office, ooproc, product
ooproc = None
uno = unohelper = None
exitcode = 0


class Office:
    def __init__(self, basepath, urepath, unopath, pyuno, binary, python, pythonhome):
        self.basepath = basepath
        self.urepath = urepath
        self.unopath = unopath
        self.pyuno = pyuno
        self.binary = binary
        self.python = python
        self.pythonhome = pythonhome

    def __str__(self):
        return self.basepath

    def __repr__(self):
        return self.basepath


# Implement a path normalizer to make unoconv work on MacOS X, on
# which 'program' is a symlink to 'MacOSX,' which seems to break unoconv.
def realpath(*args):
    """Implement a combination of os.path.join(), os.path.abspath() and
        os.path.realpath() in order to normalize path constructions."""
    ret = ''
    for arg in args:
        ret = os.path.join(ret, arg)
    return os.path.realpath(os.path.abspath(ret))


# The first thing we should do is find a suitable Office installation
# with a compatible pyuno library that we can import.
#
# See: http://user.services.openoffice.org/en/forum/viewtopic.php?f=45&t=36370&p=166783
def find_offices():
    ret = []
    extrapaths = []

    # Try using UNO_PATH first (in many incarnations, we'll see what sticks).
    if 'UNO_PATH' in os.environ:
        extrapaths += [os.environ['UNO_PATH'],
                       os.path.dirname(os.environ['UNO_PATH']),
                       os.path.dirname(os.path.dirname(os.environ['UNO_PATH']))]
    else:
        if os.name in ('nt', 'os2'):
            if 'PROGRAMFILES' in list(os.environ.keys()):
                extrapaths += glob.glob(os.environ['PROGRAMFILES']+'\\LibreOffice*') + \
                              glob.glob(os.environ['PROGRAMFILES']+'\\OpenOffice.org*')

            if 'PROGRAMFILES(X86)' in list(os.environ.keys()):
                extrapaths += glob.glob(os.environ['PROGRAMFILES(X86)']+'\\LibreOffice*') + \
                              glob.glob(os.environ['PROGRAMFILES(X86)']+'\\OpenOffice.org*')

            if 'PROGRAMW6432' in list(os.environ.keys()):
                extrapaths += glob.glob(os.environ['PROGRAMW6432']+'\\LibreOffice*') + \
                              glob.glob(os.environ['PROGRAMW6432']+'\\OpenOffice.org*')

        elif os.name == 'mac' or sys.platform == 'darwin':
            extrapaths += ['/Applications/LibreOffice.app/Contents',
                           '/Applications/NeoOffice.app/Contents',
                           '/Applications/OpenOffice.app/Contents',
                           '/Applications/OpenOffice.org.app/Contents']

        else:
            extrapaths += glob.glob('/usr/lib*/libreoffice*') + \
                          glob.glob('/usr/lib*/openoffice*') + \
                          glob.glob('/usr/lib*/ooo*') + \
                          glob.glob('/opt/libreoffice*') + \
                          glob.glob('/opt/openoffice*') + \
                          glob.glob('/opt/ooo*') + \
                          glob.glob('/usr/local/libreoffice*') + \
                          glob.glob('/usr/local/openoffice*') + \
                          glob.glob('/usr/local/ooo*') + \
                          glob.glob('/usr/local/lib/libreoffice*')

    # Find a working set for python UNO bindings.
    for basepath in extrapaths:
        if os.name in ('nt', 'os2'):
            officelibraries = ('pyuno.pyd',)
            officebinaries = ('soffice.exe',)
            pythonbinaries = ('python.exe',)
            pythonhomes = ()
        elif os.name == 'mac' or sys.platform == 'darwin':
            officelibraries = ('pyuno.so', 'libpyuno.dylib')
            officebinaries = ('soffice.bin', 'soffice')
            pythonbinaries = ('python.bin', 'python')
            pythonhomes = ('OOoPython.framework/Versions/*/lib/python*')
        else:
            officelibraries = ('pyuno.so',)
            officebinaries = ('soffice.bin',)
            pythonbinaries = ('python.bin', 'python')
            pythonhomes = ('python-core-*',)

        # Older LibreOffice/OpenOffice and Windows use basis-link/ or basis/
        libpath = 'error'
        for basis in ('basis-link', 'basis', ''):
            for lib in officelibraries:
                for libdir in ('program', 'Frameworks'):
                    if os.path.isfile(realpath(basepath, basis, libdir, lib)):
                        libpath = realpath(basepath, basis, libdir)
                        officelibrary = realpath(libpath, lib)
                        info(3, "Found %s in %s" % (lib, libpath))
                        # Break the inner loop...
                        break
                # Continue if the inner loop wasn't broken.
                else:
                    continue
                break
            # Continue if the inner loop wasn't broken.
            else:
                continue
            # Inner loop was broken, break the outer.
            break
        else:
            continue

        # MacOSX has soffice binaries installed in MacOS subdirectory, not program.
        unopath = 'error'
        for basis in ('basis-link', 'basis', ''):
            for bin in officebinaries:
                for bindir in ('program', '', 'MacOS'):
                    if os.path.isfile(realpath(basepath, basis, bindir, bin)):
                        unopath = realpath(basepath, basis, bindir)
                        officebinary = realpath(unopath, bin)
                        info(3, "Found %s in %s" % (bin, unopath))
                        # Break the inner loop.
                        break
                # Continue if the inner loop wasn't broken.
                else:
                    continue
                break
            # Continue if the inner loop wasn't broken.
            else:
                continue
            # Inner loop was broken; break the outer.
            break
        else:
            continue

        # Windows does not provide or need a URE/lib directory?
        urepath = ''
        for basis in ('basis-link', 'basis', ''):
            for ure in ('ure-link', 'ure', 'URE', ''):
                if os.path.isfile(realpath(basepath, basis, ure, 'lib', 'unorc')):
                    urepath = realpath(basepath, basis, ure)
                    info(3, "Found %s in %s" % ('unorc', realpath(urepath, 'lib')))
                    # Break the inner loop.
                    break
            # Continue if the inner loop wasn't broken.
            else:
                continue
            # Inner loop was broken; break the outer.
            break

        pythonhome = None
        for home in pythonhomes:
            if glob.glob(realpath(libpath, home)):
                pythonhome = glob.glob(realpath(libpath, home))[0]
                info(3, "Found %s in %s" % (home, pythonhome))
                break

        # if not os.path.isfile(realpath(basepath, program, officebinary)):
            # continue
        # info(3, "Found %s in %s" % (officebinary, realpath(basepath, program)))

        # if not glob.glob(realpath(basepath, basis, program, 'python-core-*')):
            # continue

        # Find suitable Python executable: regular unopath or MacOS version.
        # LibreOffice 5.4.6.2 on MacOS X 10.13.3 ships the Python executable
        # in the "Resources" folder.
        pythonpath_candidates = [unopath, realpath(basepath, 'Resources')]

        python_effective = find_executable(pythonpath_candidates, pythonbinaries)

        if python_effective:
            info(3, "Found Python at %s" % python_effective)
            office = Office(basepath, urepath, unopath, officelibrary, officebinary,
                            python_effective, pythonhome)
        else:
            info(3, "Considering %s" % basepath)
            office = Office(basepath, urepath, unopath, officelibrary, officebinary,
                            sys.executable, None)

        ret.append(office)

    return ret


def find_executable(folders, filenames):
    for folder in folders:
        for filename in filenames:
            candidate = realpath(folder, filename)
            if os.path.isfile(candidate):
                return candidate


def office_environ(office):
    # Set PATH so crash_report is found.
    path_prefix = realpath(office.basepath, 'program') + os.pathsep + realpath(office.basepath, 'Resources')
    if 'PATH' in os.environ:
        os.environ['PATH'] = path_prefix + os.pathsep + os.environ['PATH']
    else:
        os.environ['PATH'] = path_prefix

    # Set UNO_PATH so "officehelper.bootstrap()" can find soffice executable:
    os.environ['UNO_PATH'] = office.unopath

    # Set URE_BOOTSTRAP so "uno.getComponentContext()" bootstraps a complete UNO environment.
    if os.name in ('nt', 'os2'):
        os.environ['URE_BOOTSTRAP'] = 'vnd.sun.star.pathname:' + realpath(office.basepath, 'program', 'fundamental.ini')
    else:
        if os.path.isfile(realpath(office.basepath, 'program', 'fundamentalrc')):
            os.environ['URE_BOOTSTRAP'] = 'vnd.sun.star.pathname:' + realpath(office.basepath, 'program', 'fundamentalrc')
        else:
            os.environ['URE_BOOTSTRAP'] = 'vnd.sun.star.pathname:' + realpath(office.basepath, 'Resources', 'fundamentalrc')

        # Set LD_LIBRARY_PATH so that "import pyuno" finds libpyuno.so:
        if 'LD_LIBRARY_PATH' in os.environ:
            os.environ['LD_LIBRARY_PATH'] = office.unopath + os.pathsep + \
                                            realpath(office.urepath, 'lib') + os.pathsep + \
                                            os.environ['LD_LIBRARY_PATH']
        else:
            os.environ['LD_LIBRARY_PATH'] = office.unopath + os.pathsep + \
                                            realpath(office.urepath, 'lib')

    if office.pythonhome:
        for libpath in (realpath(office.pythonhome, 'lib'),
                        realpath(office.pythonhome, 'lib', 'lib-dynload'),
                        realpath(office.pythonhome, 'lib', 'lib-tk'),
                        realpath(office.pythonhome, 'lib', 'site-packages'),
                        office.unopath):
            sys.path.insert(0, libpath)
    else:
        # Still needed for system python using LibreOffice UNO bindings
        # Although we prefer to use a system UNO binding in this case
        sys.path.append(office.unopath)


def debug_office():
    if 'URE_BOOTSTRAP' in os.environ:
        print('URE_BOOTSTRAP=%s' % os.environ['URE_BOOTSTRAP'], file=sys.stderr)
    if 'UNO_PATH' in os.environ:
        print('UNO_PATH=%s' % os.environ['UNO_PATH'], file=sys.stderr)
    if 'UNO_TYPES' in os.environ:
        print('UNO_TYPES=%s' % os.environ['UNO_TYPES'], file=sys.stderr)
    print('PATH=%s' % os.environ['PATH'])
    if 'PYTHONHOME' in os.environ:
        print('PYTHONHOME=%s' % os.environ['PYTHONHOME'], file=sys.stderr)
    if 'PYTHONPATH' in os.environ:
        print('PYTHONPATH=%s' % os.environ['PYTHONPATH'], file=sys.stderr)
    if 'LD_LIBRARY_PATH' in os.environ:
        print('LD_LIBRARY_PATH=%s' % os.environ['LD_LIBRARY_PATH'], file=sys.stderr)


def python_switch(office):
    if office.pythonhome:
        os.environ['PYTHONHOME'] = office.pythonhome
        os.environ['PYTHONPATH'] = realpath(office.pythonhome, 'lib') + os.pathsep + \
                                   realpath(office.pythonhome, 'lib', 'lib-dynload') + os.pathsep + \
                                   realpath(office.pythonhome, 'lib', 'lib-tk') + os.pathsep + \
                                   realpath(office.pythonhome, 'lib', 'site-packages') + os.pathsep + \
                                   office.unopath

    os.environ['UNO_PATH'] = office.unopath

    info(3, "-> Switching from %s to %s" % (sys.executable, office.python))
    if os.name in ('nt', 'os2'):
        # os.execv is broken on Windows and can't properly parse command line
        # arguments and executable name if they contain whitespaces. subprocess
        # fixes that behavior.
        ret = subprocess.call([office.python, ] + sys.argv[0:])
        sys.exit(ret)
    else:

        # Set LD_LIBRARY_PATH so that "import pyuno" finds libpyuno.so:
        if 'LD_LIBRARY_PATH' in os.environ:
            os.environ['LD_LIBRARY_PATH'] = office.unopath + os.pathsep + \
                                            realpath(office.urepath, 'lib') + os.pathsep + \
                                            os.environ['LD_LIBRARY_PATH']
        else:
            os.environ['LD_LIBRARY_PATH'] = office.unopath + os.pathsep + \
                                            realpath(office.urepath, 'lib')

        try:
            os.execvpe(office.python, [office.python, ] + sys.argv[0:], os.environ)
        except OSError:
            # Mac OS X versions prior to 10.6 do not support execv in
            # a process that contains multiple threads.  Instead of
            # re-executing in the current process, start a new one
            # and cause the current process to exit.  This isn't
            # ideal since the new process is detached from the parent
            # terminal and thus cannot easily be killed with ctrl-C,
            # but it's better than not being able to autoreload at
            # all.
            # Unfortunately the errno returned in this case does not
            # appear to be consistent, so we can't easily check for
            # this error specifically.
            ret = os.spawnvpe(os.P_WAIT, office.python, [office.python, ] + sys.argv[0:], os.environ)
            if ret != 0:
                error("Switching Python to %s failed." % (office.python))
            sys.exit(ret)


class Fmt:
    def __init__(self, doctype, name, extension, summary, filter):
        self.doctype = doctype
        self.name = name
        self.extension = extension
        self.summary = summary
        self.filter = filter

    def __str__(self):
        return "%s [.%s]" % (self.summary, self.extension)

    def __repr__(self):
        return "%s/%s" % (self.name, self.doctype)


class FmtList:
    def __init__(self):
        self.list = []

    def add(self, doctype, name, extension, summary, filter):
        self.list.append(Fmt(doctype, name, extension, summary, filter))

    def byname(self, name):
        ret = []
        for fmt in self.list:
            if fmt.name == name:
                ret.append(fmt)
        return ret

    def byextension(self, extension):
        ret = []
        for fmt in self.list:
            if os.extsep + fmt.extension == extension:
                ret.append(fmt)
        return ret

    def bydoctype(self, doctype, name):
        ret = []
        for fmt in self.list:
            if fmt.name == name and fmt.doctype == doctype:
                ret.append(fmt)
        return ret

    def display(self, doctype):
        print("The following list of %s formats are currently available:\n" % doctype, file=sys.stderr)
        for fmt in self.list:
            if fmt.doctype == doctype:
                print("  %-8s - %s" % (fmt.name, fmt), file=sys.stderr)
        print(file=sys.stderr)


fmts = FmtList()

# TextDocument
fmts.add('document', 'bib', 'bib', 'BibTeX', 'BibTeX_Writer')  # 22
fmts.add('document', 'doc', 'doc', 'Microsoft Word 97/2000/XP', 'MS Word 97')  # 29
fmts.add('document', 'doc6', 'doc', 'Microsoft Word 6.0', 'MS WinWord 6.0')  # 24
fmts.add('document', 'doc95', 'doc', 'Microsoft Word 95', 'MS Word 95')  # 28
fmts.add('document', 'docbook', 'xml', 'DocBook', 'DocBook File')  # 39
fmts.add('document', 'docx', 'docx', 'Microsoft Office Open XML', 'Office Open XML Text')
fmts.add('document', 'docx7', 'docx', 'Microsoft Office Open XML', 'MS Word 2007 XML')
fmts.add('document', 'fodt', 'fodt', 'OpenDocument Text (Flat XML)', 'OpenDocument Text Flat XML')
fmts.add('document', 'html', 'html', 'HTML Document (OpenOffice.org Writer)', 'HTML (StarWriter)')  # 3
fmts.add('document', 'latex', 'ltx', 'LaTeX 2e', 'LaTeX_Writer')  # 31
fmts.add('document', 'mediawiki', 'txt', 'MediaWiki', 'MediaWiki')
fmts.add('document', 'odt', 'odt', 'ODF Text Document', 'writer8')  # 10
fmts.add('document', 'ooxml', 'xml', 'Microsoft Office Open XML', 'MS Word 2003 XML')  # 11
fmts.add('document', 'ott', 'ott', 'Open Document Text', 'writer8_template')  # 21
fmts.add('document', 'pdb', 'pdb', 'AportisDoc (Palm)', 'AportisDoc Palm DB')
fmts.add('document', 'pdf', 'pdf', 'Portable Document Format', 'writer_pdf_Export')  # 18
fmts.add('document', 'psw', 'psw', 'Pocket Word', 'PocketWord File')
fmts.add('document', 'rtf', 'rtf', 'Rich Text Format', 'Rich Text Format')  # 16
fmts.add('document', 'sdw', 'sdw', 'StarWriter 5.0', 'StarWriter 5.0')  # 23
fmts.add('document', 'sdw4', 'sdw', 'StarWriter 4.0', 'StarWriter 4.0')  # 2
fmts.add('document', 'sdw3', 'sdw', 'StarWriter 3.0', 'StarWriter 3.0')  # 20
fmts.add('document', 'stw', 'stw', 'Open Office.org 1.0 Text Document Template', 'writer_StarOffice_XML_Writer_Template')  # 9
fmts.add('document', 'sxw', 'sxw', 'Open Office.org 1.0 Text Document', 'StarOffice XML (Writer)')  # 1
fmts.add('document', 'text', 'txt', 'Text Encoded', 'Text (encoded)')  # 26
fmts.add('document', 'txt', 'txt', 'Text', 'Text')  # 34
fmts.add('document', 'uot', 'uot', 'Unified Office Format text', 'UOF text')  # 27
fmts.add('document', 'vor', 'vor', 'StarWriter 5.0 Template', 'StarWriter 5.0 Vorlage/Template')  # 6
fmts.add('document', 'vor4', 'vor', 'StarWriter 4.0 Template', 'StarWriter 4.0 Vorlage/Template')  # 5
fmts.add('document', 'vor3', 'vor', 'StarWriter 3.0 Template', 'StarWriter 3.0 Vorlage/Template')  # 4
fmts.add('document', 'wps', 'wps', 'Microsoft Works', 'MS_Works')
fmts.add('document', 'xhtml', 'html', 'XHTML Document', 'XHTML Writer File')  # 33
fmts.add('document', 'epub', 'epub', 'Electronic Publication', 'EPUB')
fmts.add('document', 'png', 'png', 'Portable Network Graphic', 'writer_png_Export') ### 2

# WebDocument
fmts.add('web', 'etext', 'txt', 'Text Encoded (OpenOffice.org Writer/Web)', 'Text (encoded) (StarWriter/Web)')  # 14
fmts.add('web', 'html10', 'html', 'OpenOffice.org 1.0 HTML Template', 'writer_web_StarOffice_XML_Writer_Web_Template')  # 11
fmts.add('web', 'html', 'html', 'HTML Document', 'HTML')  # 2
fmts.add('web', 'html', 'html', 'HTML Document Template', 'writerweb8_writer_template')  # 13
fmts.add('web', 'mediawiki', 'txt', 'MediaWiki', 'MediaWiki_Web')  # 9
fmts.add('web', 'pdf', 'pdf', 'PDF - Portable Document Format', 'writer_web_pdf_Export')  # 10
fmts.add('web', 'sdw3', 'sdw', 'StarWriter 3.0 (OpenOffice.org Writer/Web)', 'StarWriter 3.0 (StarWriter/Web)')  # 3
fmts.add('web', 'sdw4', 'sdw', 'StarWriter 4.0 (OpenOffice.org Writer/Web)', 'StarWriter 4.0 (StarWriter/Web)')  # 4
fmts.add('web', 'sdw', 'sdw', 'StarWriter 5.0 (OpenOffice.org Writer/Web)', 'StarWriter 5.0 (StarWriter/Web)')  # 5
fmts.add('web', 'txt', 'txt', 'OpenOffice.org Text (OpenOffice.org Writer/Web)', 'writerweb8_writer')  # 12
fmts.add('web', 'text10', 'txt', 'OpenOffice.org 1.0 Text Document (OpenOffice.org Writer/Web)', 'writer_web_StarOffice_XML_Writer')  # 15
fmts.add('web', 'text', 'txt', 'Text (OpenOffice.org Writer/Web)', 'Text (StarWriter/Web)')  # 8
fmts.add('web', 'vor4', 'vor', 'StarWriter/Web 4.0 Template', 'StarWriter/Web 4.0 Vorlage/Template')  # 6
fmts.add('web', 'vor', 'vor', 'StarWriter/Web 5.0 Template', 'StarWriter/Web 5.0 Vorlage/Template')  # 7

# Spreadsheet
fmts.add('spreadsheet', 'csv', 'csv', 'Text CSV', 'Text - txt - csv (StarCalc)')  # 16
fmts.add('spreadsheet', 'dbf', 'dbf', 'dBASE', 'dBase')  # 22
fmts.add('spreadsheet', 'dif', 'dif', 'Data Interchange Format', 'DIF')  # 5
fmts.add('spreadsheet', 'fods', 'fods', 'OpenDocument Spreadsheet (Flat XML)', 'OpenDocument Spreadsheet Flat XML')
fmts.add('spreadsheet', 'html', 'html', 'HTML Document (OpenOffice.org Calc)', 'HTML (StarCalc)')  # 7
fmts.add('spreadsheet', 'ods', 'ods', 'ODF Spreadsheet', 'calc8')  # 15
fmts.add('spreadsheet', 'ooxml', 'xml', 'Microsoft Excel 2003 XML', 'MS Excel 2003 XML')  # 23
fmts.add('spreadsheet', 'ots', 'ots', 'ODF Spreadsheet Template', 'calc8_template')  # 14
fmts.add('spreadsheet', 'pdf', 'pdf', 'Portable Document Format', 'calc_pdf_Export')  # 34
fmts.add('spreadsheet', 'pxl', 'pxl', 'Pocket Excel', 'Pocket Excel')
fmts.add('spreadsheet', 'sdc', 'sdc', 'StarCalc 5.0', 'StarCalc 5.0')  # 31
fmts.add('spreadsheet', 'sdc4', 'sdc', 'StarCalc 4.0', 'StarCalc 4.0')  # 11
fmts.add('spreadsheet', 'sdc3', 'sdc', 'StarCalc 3.0', 'StarCalc 3.0')  # 29
fmts.add('spreadsheet', 'slk', 'slk', 'SYLK', 'SYLK')  # 35
fmts.add('spreadsheet', 'stc', 'stc', 'OpenOffice.org 1.0 Spreadsheet Template', 'calc_StarOffice_XML_Calc_Template')  # 2
fmts.add('spreadsheet', 'sxc', 'sxc', 'OpenOffice.org 1.0 Spreadsheet', 'StarOffice XML (Calc)')  # 3
fmts.add('spreadsheet', 'uos', 'uos', 'Unified Office Format spreadsheet', 'UOF spreadsheet')  # 9
fmts.add('spreadsheet', 'vor3', 'vor', 'StarCalc 3.0 Template', 'StarCalc 3.0 Vorlage/Template')  # 18
fmts.add('spreadsheet', 'vor4', 'vor', 'StarCalc 4.0 Template', 'StarCalc 4.0 Vorlage/Template')  # 19
fmts.add('spreadsheet', 'vor', 'vor', 'StarCalc 5.0 Template', 'StarCalc 5.0 Vorlage/Template')  # 20
fmts.add('spreadsheet', 'xhtml', 'xhtml', 'XHTML', 'XHTML Calc File')  # 26
fmts.add('spreadsheet', 'xls', 'xls', 'Microsoft Excel 97/2000/XP', 'MS Excel 97')  # 12
fmts.add('spreadsheet', 'xls5', 'xls', 'Microsoft Excel 5.0', 'MS Excel 5.0/95')  # 8
fmts.add('spreadsheet', 'xls95', 'xls', 'Microsoft Excel 95', 'MS Excel 95')  # 10
fmts.add('spreadsheet', 'xlt', 'xlt', 'Microsoft Excel 97/2000/XP Template', 'MS Excel 97 Vorlage/Template')  # 6
fmts.add('spreadsheet', 'xlt5', 'xlt', 'Microsoft Excel 5.0 Template', 'MS Excel 5.0/95 Vorlage/Template')  # 28
fmts.add('spreadsheet', 'xlt95', 'xlt', 'Microsoft Excel 95 Template', 'MS Excel 95 Vorlage/Template')  # 21
fmts.add('spreadsheet', 'xlsx', 'xlsx', 'Microsoft Excel 2007/2010 XML', 'Calc MS Excel 2007 XML')

# Graphics
fmts.add('graphics', 'bmp', 'bmp', 'Windows Bitmap', 'draw_bmp_Export')  # 21
fmts.add('graphics', 'emf', 'emf', 'Enhanced Metafile', 'draw_emf_Export')  # 15
fmts.add('graphics', 'eps', 'eps', 'Encapsulated PostScript', 'draw_eps_Export')  # 48
fmts.add('graphics', 'fodg', 'fodg', 'OpenDocument Drawing (Flat XML)', 'OpenDocument Drawing Flat XML')
fmts.add('graphics', 'gif', 'gif', 'Graphics Interchange Format', 'draw_gif_Export')  # 30
fmts.add('graphics', 'html', 'html', 'HTML Document (OpenOffice.org Draw)', 'draw_html_Export')  # 37
fmts.add('graphics', 'jpg', 'jpg', 'Joint Photographic Experts Group', 'draw_jpg_Export')  # 3
fmts.add('graphics', 'met', 'met', 'OS/2 Metafile', 'draw_met_Export')  # 43
fmts.add('graphics', 'odd', 'odd', 'OpenDocument Drawing', 'draw8')  # 6
fmts.add('graphics', 'otg', 'otg', 'OpenDocument Drawing Template', 'draw8_template')  # 20
fmts.add('graphics', 'pbm', 'pbm', 'Portable Bitmap', 'draw_pbm_Export')  # 14
fmts.add('graphics', 'pct', 'pct', 'Mac Pict', 'draw_pct_Export')  # 41
fmts.add('graphics', 'pdf', 'pdf', 'Portable Document Format', 'draw_pdf_Export')  # 28
fmts.add('graphics', 'pgm', 'pgm', 'Portable Graymap', 'draw_pgm_Export')  # 11
fmts.add('graphics', 'png', 'png', 'Portable Network Graphic', 'draw_png_Export')  # 2
fmts.add('graphics', 'ppm', 'ppm', 'Portable Pixelmap', 'draw_ppm_Export')  # 5
fmts.add('graphics', 'ras', 'ras', 'Sun Raster Image', 'draw_ras_Export')  # 31
fmts.add('graphics', 'std', 'std', 'OpenOffice.org 1.0 Drawing Template', 'draw_StarOffice_XML_Draw_Template')  # 53
fmts.add('graphics', 'svg', 'svg', 'Scalable Vector Graphics', 'draw_svg_Export')  # 50
fmts.add('graphics', 'svm', 'svm', 'StarView Metafile', 'draw_svm_Export')  # 55
fmts.add('graphics', 'swf', 'swf', 'Macromedia Flash (SWF)', 'draw_flash_Export')  # 23
fmts.add('graphics', 'sxd', 'sxd', 'OpenOffice.org 1.0 Drawing', 'StarOffice XML (Draw)')  # 26
fmts.add('graphics', 'sxd3', 'sxd', 'StarDraw 3.0', 'StarDraw 3.0')  # 40
fmts.add('graphics', 'sxd5', 'sxd', 'StarDraw 5.0', 'StarDraw 5.0')  # 44
fmts.add('graphics', 'sxw', 'sxw', 'StarOffice XML (Draw)', 'StarOffice XML (Draw)')
fmts.add('graphics', 'tiff', 'tiff', 'Tagged Image File Format', 'draw_tif_Export')  # 13
fmts.add('graphics', 'vor', 'vor', 'StarDraw 5.0 Template', 'StarDraw 5.0 Vorlage')  # 36
fmts.add('graphics', 'vor3', 'vor', 'StarDraw 3.0 Template', 'StarDraw 3.0 Vorlage')  # 35
fmts.add('graphics', 'wmf', 'wmf', 'Windows Metafile', 'draw_wmf_Export')  # 8
fmts.add('graphics', 'xhtml', 'xhtml', 'XHTML', 'XHTML Draw File')  # 45
fmts.add('graphics', 'xpm', 'xpm', 'X PixMap', 'draw_xpm_Export')  # 19

# Presentation
fmts.add('presentation', 'bmp', 'bmp', 'Windows Bitmap', 'impress_bmp_Export')  # 15
fmts.add('presentation', 'emf', 'emf', 'Enhanced Metafile', 'impress_emf_Export')  # 16
fmts.add('presentation', 'eps', 'eps', 'Encapsulated PostScript', 'impress_eps_Export')  # 17
fmts.add('presentation', 'fodp', 'fodp', 'OpenDocument Presentation (Flat XML)', 'OpenDocument Presentation Flat XML')
fmts.add('presentation', 'gif', 'gif', 'Graphics Interchange Format', 'impress_gif_Export')  # 18
fmts.add('presentation', 'html', 'html', 'HTML Document (OpenOffice.org Impress)', 'impress_html_Export')  # 43
fmts.add('presentation', 'jpg', 'jpg', 'Joint Photographic Experts Group', 'impress_jpg_Export')  # 19
fmts.add('presentation', 'met', 'met', 'OS/2 Metafile', 'impress_met_Export')  # 20
fmts.add('presentation', 'odg', 'odg', 'ODF Drawing (Impress)', 'impress8_draw')  # 29
fmts.add('presentation', 'odp', 'odp', 'ODF Presentation', 'impress8')  # 9
fmts.add('presentation', 'otp', 'otp', 'ODF Presentation Template', 'impress8_template')  # 38
fmts.add('presentation', 'pbm', 'pbm', 'Portable Bitmap', 'impress_pbm_Export')  # 21
fmts.add('presentation', 'pct', 'pct', 'Mac Pict', 'impress_pct_Export')  # 22
fmts.add('presentation', 'pdf', 'pdf', 'Portable Document Format', 'impress_pdf_Export')  # 23
fmts.add('presentation', 'pgm', 'pgm', 'Portable Graymap', 'impress_pgm_Export')  # 24
fmts.add('presentation', 'png', 'png', 'Portable Network Graphic', 'impress_png_Export')  # 25
fmts.add('presentation', 'potm', 'potm', 'Microsoft PowerPoint 2007/2010 XML Template', 'Impress MS PowerPoint 2007 XML Template')
fmts.add('presentation', 'pot', 'pot', 'Microsoft PowerPoint 97/2000/XP Template', 'MS PowerPoint 97 Vorlage')  # 3
fmts.add('presentation', 'ppm', 'ppm', 'Portable Pixelmap', 'impress_ppm_Export')  # 26
fmts.add('presentation', 'pptx', 'pptx', 'Microsoft PowerPoint 2007/2010 XML', 'Impress MS PowerPoint 2007 XML')  # 36
fmts.add('presentation', 'pps', 'pps', 'Microsoft PowerPoint 97/2000/XP (Autoplay)', 'MS PowerPoint 97 Autoplay')  # 36
fmts.add('presentation', 'ppt', 'ppt', 'Microsoft PowerPoint 97/2000/XP', 'MS PowerPoint 97')  # 36
fmts.add('presentation', 'pwp', 'pwp', 'PlaceWare', 'placeware_Export')  # 30
fmts.add('presentation', 'ras', 'ras', 'Sun Raster Image', 'impress_ras_Export')  # 27
fmts.add('presentation', 'sda', 'sda', 'StarDraw 5.0 (OpenOffice.org Impress)', 'StarDraw 5.0 (StarImpress)')  # 8
fmts.add('presentation', 'sdd', 'sdd', 'StarImpress 5.0', 'StarImpress 5.0')  # 6
fmts.add('presentation', 'sdd3', 'sdd', 'StarDraw 3.0 (OpenOffice.org Impress)', 'StarDraw 3.0 (StarImpress)')  # 42
fmts.add('presentation', 'sdd4', 'sdd', 'StarImpress 4.0', 'StarImpress 4.0')  # 37
fmts.add('presentation', 'sxd', 'sxd', 'OpenOffice.org 1.0 Drawing (OpenOffice.org Impress)', 'impress_StarOffice_XML_Draw')  # 31
fmts.add('presentation', 'sti', 'sti', 'OpenOffice.org 1.0 Presentation Template', 'impress_StarOffice_XML_Impress_Template')  # 5
fmts.add('presentation', 'svg', 'svg', 'Scalable Vector Graphics', 'impress_svg_Export')  # 14
fmts.add('presentation', 'svm', 'svm', 'StarView Metafile', 'impress_svm_Export')  # 13
fmts.add('presentation', 'swf', 'swf', 'Macromedia Flash (SWF)', 'impress_flash_Export')  # 34
fmts.add('presentation', 'sxi', 'sxi', 'OpenOffice.org 1.0 Presentation', 'StarOffice XML (Impress)')  # 41
fmts.add('presentation', 'tiff', 'tiff', 'Tagged Image File Format', 'impress_tif_Export')  # 12
fmts.add('presentation', 'uop', 'uop', 'Unified Office Format presentation', 'UOF presentation')  # 4
fmts.add('presentation', 'vor', 'vor', 'StarImpress 5.0 Template', 'StarImpress 5.0 Vorlage')  # 40
fmts.add('presentation', 'vor3', 'vor', 'StarDraw 3.0 Template (OpenOffice.org Impress)', 'StarDraw 3.0 Vorlage (StarImpress)')  # 1
fmts.add('presentation', 'vor4', 'vor', 'StarImpress 4.0 Template', 'StarImpress 4.0 Vorlage')  # 39
fmts.add('presentation', 'vor5', 'vor', 'StarDraw 5.0 Template (OpenOffice.org Impress)', 'StarDraw 5.0 Vorlage (StarImpress)')  # 2
fmts.add('presentation', 'wmf', 'wmf', 'Windows Metafile', 'impress_wmf_Export')  # 11
fmts.add('presentation', 'xhtml', 'xml', 'XHTML', 'XHTML Impress File')  # 33
fmts.add('presentation', 'xpm', 'xpm', 'X PixMap', 'impress_xpm_Export')  # 10


class Options:
    def __init__(self, args):
        self.connection = None
        self.debug = False
        self.doctype = None
        self.exportfilter = []
        self.exportfilteroptions = ""
        self.fields = {}
        self.filenames = []
        self.format = None
        self.importfilter = []
        self.importfiltername = None
        self.importfilteroptions = ""
        self.listener = False
        self.metadata = {}
        self.nolaunch = False
        self.output = None
        self.paperformat = None
        self.paperorientation = None
        self.papersize = None
        self.password = None
        self.pipe = None
        self.port = '2002'
        self.preserve = False
        self.server = '127.0.0.1'
        self.setprinter = False
        self.showlist = False
        self.stdin = False
        self.stdout = False
        self.template = None
        self.timeout = 60
        self.verbose = 0
        self.userProfile = None
        self.updateDocMode = NO_UPDATE
        self.updatehtmllinks = True

        # Get options from the commandline
        try:
            opts, args = getopt.getopt(args, 'c:Dd:e:F:f:hi:I:LlM:no:p:s:T:t:P:vV',
                ['disable-html-update-links', 'connection=', 'debug', 'doctype=', 'export=', 'field=', 'format=',
                 'help', 'import=', 'import-filter-name=', 'listener', 'meta=', 'no-launch',
                 'output=', 'outputpath', 'password=', 'pipe=', 'port=', 'preserve',
                 'server=', 'timeout=', 'user-profile=', 'show', 'stdin',
                 'stdout', 'template', 'printer=', 'unsafe-quiet-update', 'verbose', 'version'])
        except getopt.error as exc:
            print('unoconv: %s, try unoconv -h for a list of all the options' % str(exc))
            sys.exit(255)

        for opt, arg in opts:
            if opt in ['-h', '--help']:
                self.usage()
                print()
                self.help()
                sys.exit(0)
            elif opt in ['-c', '--connection']:
                self.connection = arg
            elif opt in ['--debug']:
                self.debug = True
            elif opt in ['-d', '--doctype']:
                self.doctype = arg
            elif opt in ['-e', '--export']:
                l = arg.split('=')
                if len(l) == 2:
                    (name, value) = l
                    if name in ('FilterOptions'):
                        self.exportfilteroptions = value
                    elif value in ('True', 'true'):
                        self.exportfilter.append(PropertyValue(name, 0, True, 0))
                    elif value in ('False', 'false'):
                        self.exportfilter.append(PropertyValue(name, 0, False, 0))
                    else:
                        try:
                            self.exportfilter.append(PropertyValue(name, 0, int(value), 0))
                        except ValueError:
                            self.exportfilter.append(PropertyValue(name, 0, value, 0))
                else:
                    print('Warning: Option %s cannot be parsed, ignoring.' % arg, file=sys.stderr)
            elif opt in ['-F', '--field']:
                l = arg.split('=')
                self.fields[l[0]] = '='.join(l[1:])
            elif opt in ['-f', '--format']:
                self.format = arg
            elif opt in ['-i', '--import']:
                l = arg.split('=')
                if len(l) == 2:
                    (name, value) = l
                    if name in ('FilterOptions'):
                        self.importfilteroptions = value
                    elif value in ('True', 'true'):
                        self.importfilter.append(PropertyValue(name, 0, True, 0))
                    elif value in ('False', 'false'):
                        self.importfilter.append(PropertyValue(name, 0, False, 0))
                    else:
                        try:
                            self.importfilter.append(PropertyValue(name, 0, int(value), 0))
                        except ValueError:
                            self.importfilter.append(PropertyValue(name, 0, value, 0))
                else:
                    print('Warning: Option %s cannot be parsed, ignoring.' % arg, file=sys.stderr)
            elif opt in ['-I', '--import-filter-name']:
                self.importfiltername = arg
            elif opt in ['-l', '--listener']:
                self.listener = True
            elif opt in ['-M', '--meta']:
                l = arg.split('=')
                self.metadata[l[0]] = '='.join(l[1:])
            elif opt in ['-n', '--no-launch']:
                self.nolaunch = True
            elif opt in ['-o', '--output']:
                self.output = arg
            elif opt in ['--outputpath']:
                print('Warning: This option is deprecated by --output.', file=sys.stderr)
                self.output = arg
            elif opt in ['--password']:
                self.password = arg
            elif opt in ['--pipe']:
                self.pipe = arg
            elif opt in ['-p', '--port']:
                self.port = arg
            elif opt in ['--preserve']:
                self.preserve = True
            elif opt in ['-s', '--server']:
                self.server = arg
            elif opt in ['--show']:
                self.showlist = True
            elif opt in ['--stdin']:
                self.stdin = True
            elif opt in ['--stdout']:
                self.stdout = True
            elif opt in ['-t', '--template']:
                self.template = arg
            elif opt in ['--disable-html-update-links']:
                self.updatehtmllinks = False
            elif opt in ['-T', '--timeout']:
                self.timeout = int(arg)
            elif opt in ['--unsafe-quiet-update']:
                # ref https://www.openoffice.org/api/docs/common/ref/com/sun/star/document/UpdateDocMode.html
                print('Warning: Do not use the option --unsafe-quiet-update with untrusted input.')
                self.updateDocMode = QUIET_UPDATE
            elif opt in ['-v', '--verbose']:
                self.verbose = self.verbose + 1
            elif opt in ['-V', '--version']:
                self.version()
                sys.exit(0)
            elif opt in ['-P', '--printer']:
                optKey, optValue = arg.split('=')
                if optKey in ['PaperFormat']:
                    self.paperformat = optValue
                    self.setprinter = True
                elif optKey in ['PaperOrientation']:
                    self.paperorientation = optValue.upper()
                    self.setprinter = True
                elif optKey in ['PaperSize']:
                    intFunc = int if sys.version_info.major > 2 else long
                    size = list(map(lambda s: intFunc(s), optValue.split('x')))
                    if (2 == len(size)):
                        self.papersize = size
                        self.setprinter = True
            elif opt in ['--user-profile']:
                self.userProfile = arg

        # Enable verbosity
        if self.verbose >= 2:
            print('Verbosity set to level %d' % self.verbose, file=sys.stderr)

        self.filenames = args

        if not self.listener and not self.showlist and not self.stdin and self.doctype != 'list' and not self.filenames:
            print('unoconv: you have to provide a filename or url as argument', file=sys.stderr)
            print('Try `unoconv -h\' for more information.', file=sys.stderr)
            sys.exit(255)

        # Set connection string
        if not self.connection:
            if not self.pipe:
                self.connection = "socket,host=%s,port=%s,tcpNoDelay=1;urp;StarOffice.ComponentContext" % (self.server, self.port)
            else:
                self.connection = "pipe,name=%s;urp;StarOffice.ComponentContext" % (self.pipe)

        # Make it easier for people to use a doctype (first letter is enough)
        if self.doctype:
            for doctype in doctypes:
                if doctype.startswith(self.doctype):
                    self.doctype = doctype

        # Check if the user request to see the list of formats
        if self.showlist or self.format == 'list':
            if self.doctype:
                fmts.display(self.doctype)
            else:
                for t in doctypes:
                    fmts.display(t)
            sys.exit(0)

        # If no format was specified, probe it or provide it.
        if not self.format:
            # Check if the command is in the form odt2pdf
            l = sys.argv[0].split('2')
            if len(l) == 2:
                self.format = l[1]
            # Use the extension of the output file
            elif self.output and os.path.basename(self.output).find('.') >= 0:
                self.format = os.path.splitext(self.output)[1].lstrip('.')

        # Default to PDF.
        if not self.format:
            self.format = 'pdf'

    def version(self):
        print('unoconv %s' % __version__)
        print('Written by Dag Wieers <dag@wieers.com>')
        print('Homepage at http://dag.wieers.com/home-made/unoconv/')
        print()
        print('platform %s/%s' % (os.name, sys.platform))
        print('python %s' % sys.version)

        if uno:
            # Get office product information.
            product = uno.getComponentContext().ServiceManager.createInstance("com.sun.star.configuration.ConfigurationProvider").createInstanceWithArguments("com.sun.star.configuration.ConfigurationAccess", UnoProps(nodepath="/org.openoffice.Setup/Product"))
            print(product.ooName, product.ooSetupVersionAboutBox)

    def usage(self):
        print('usage: unoconv [options] file [file2 ..]', file=sys.stderr)

    def help(self):
        print('''Convert from and to any format supported by LibreOffice

unoconv options:
  -c, --connection=string             use a custom connection string
  -d, --doctype=type                  specify document type
                                        (document, graphics, presentation, spreadsheet)
  -e, --export=name=value             set export filter options
                                        eg. -e PageRange=1-2
  -f, --format=format                 specify the output format
  -F, --field=name=value              replace user-defined text field with value
                                        eg. -F Client_Name="Oracle"
  -i, --import=string                 set import filter option string
                                        eg. -i utf8
  -I, --import-filter-name=string     set import filter name, useful when converting stdin
                                      or files without an extension)
                                        eg. -I ooxml
  -l, --listener                      start a permanent listener to use by unoconv clients
  -n, --no-launch                     fail if no listener is found (default: launch one)
  -o, --output=name                   output basename, filename or directory
      --pipe=name                     alternative method of connection using a pipe
  -p, --port=port                     specify the port (default: 2002)
                                        to be used by client or listener
      --password=string               provide a password to decrypt the document
      --preserve                      keep timestamp and permissions of the original document
  -s, --server=server                 specify the server address (default: 127.0.0.1)
                                        to be used by client or listener
      --show                          list the available output formats
      --stdin                         read from stdin (filenames are ignored if provided)
      --stdout                        write output to stdout
  -t, --template=file                 import the styles from template (.ott)
  -T, --timeout=secs                  timeout after secs if connection to listener fails
      --unsafe-quiet-update           allow rendered document to fetch external resources (Warning: this is unsafe with untrusted input)
  -v, --verbose                       be more and more verbose (-vvv for debugging)
      --version                       display version number of unoconv, OOo/LO and platform details
  -P, --printer=name=value            printer options
                                        PaperFormat: specify printer paper format
                                          eg. -P PaperFormat=A3
                                        PaperOrientation: specify printer paper orientation
                                          eg. -P PaperOrientation=landscape
                                        PapserSize: specify printer paper size, paper format should set to USER, size=widthxheight
                                          eg. -P PaperSize=130x200 means width=130, height=200
  --disable-html-update-links   disables the recheck for updating links missed by libreoffice
  --user-profile=path                 use a custom user profile path
''', file=sys.stderr)


class Convertor:
    def __init__(self):
        global exitcode, ooproc, office, product
        unocontext = None

        # Do the LibreOffice component dance
        self.context = uno.getComponentContext()
        self.svcmgr = self.context.ServiceManager
        resolver = self.svcmgr.createInstanceWithContext("com.sun.star.bridge.UnoUrlResolver", self.context)

        # Test for an existing connection
        info(3, 'Connection type: %s' % op.connection)
        unocontext = self.connect(resolver)

        if not unocontext:
            die(251, "Unable to connect or start own listener. Aborting.")

        # And some more LibreOffice magic
        unosvcmgr = unocontext.ServiceManager
        self.desktop = unosvcmgr.createInstanceWithContext("com.sun.star.frame.Desktop", unocontext)
        self.cwd = unohelper.systemPathToFileUrl(os.getcwd())

        # List all filters
        # self.filters = unosvcmgr.createInstanceWithContext("com.sun.star.document.FilterFactory", unocontext)
        # for filter in self.filters.getElementNames():
            # print filter
            # print dir(filter), dir(filter.format)

    def connect(self, resolver):
        global ooproc, product, office
        unocontext = None

        try:
            unocontext = resolver.resolve("uno:%s" % op.connection)
        except NoConnectException as e:
            # info(3, "Existing listener not found.\n%s" % e)
            info(3, "Existing listener not found.")

            if op.nolaunch:
                die(113, "Existing listener not found. Unable start listener by parameters. Aborting.")

            # Start our own OpenOffice instance
            info(3, "Launching our own listener using %s." % office.binary)
            try:
                product = self.svcmgr.createInstance("com.sun.star.configuration.ConfigurationProvider").createInstanceWithArguments("com.sun.star.configuration.ConfigurationAccess", UnoProps(nodepath="/org.openoffice.Setup/Product"))
                if product.ooName not in ('LibreOffice', 'LOdev') or LooseVersion(product.ooSetupVersion) <= LooseVersion('3.3'):
                    args = [office.binary, "-headless", "-invisible", "-nocrashreport", "-nodefault", "-nofirststartwizard", "-nologo", "-norestore", "-accept=%s" % op.connection]
                else:
                    args = [office.binary, "--headless", "--invisible", "--nocrashreport", "--nodefault", "--nofirststartwizard", "--nologo", "--norestore", "--accept=%s" % op.connection]
                if op.userProfile:
                    args.append("-env:UserInstallation=file://" + realpath(op.userProfile))
                info(2, '%s listener arguments are %s.' % (product.ooName, args))
                ooproc = subprocess.Popen(args, env=os.environ)
                info(2, '%s listener successfully started. (pid=%s)' % (product.ooName, ooproc.pid))

                # Try connection to it for op.timeout seconds (flakky OpenOffice)
                timeout = 0
                while timeout <= op.timeout:
                    # Is it already/still running?
                    retcode = ooproc.poll()
                    if retcode == 81:
                        info(3, "Caught exit code 81 (new installation). Restarting listener.")
                        return self.connect(resolver)
                        break

                    elif retcode is not None:
                        info(3, "Process %s (pid=%s) exited with %s." % (office.binary, ooproc.pid, retcode))
                        break

                    try:
                        unocontext = resolver.resolve("uno:%s" % op.connection)
                        break
                    except NoConnectException:
                        time.sleep(0.5)
                        timeout += 0.5
                    except:
                        raise
                else:
                    error("Failed to connect to %s (pid=%s) in %d seconds.\n%s" % (office.binary, ooproc.pid, op.timeout, e))
            except Exception as e:
                raise
                error("Launch of %s failed.\n%s" % (office.binary, e))

        return unocontext

    def getimportformat(self):
        if op.doctype:
            importformat = fmts.bydoctype(op.doctype, op.importfiltername)
        else:
            importformat = fmts.byname(op.importfiltername)

        if not importformat:
            error('Import format [%s] is not known to unoconv.' % importformat)

        return importformat[0]

    def getformat(self, inputfn):
        doctype = None

        # Get the output format from mapping
        if op.doctype:
            outputfmt = fmts.bydoctype(op.doctype, op.format)
        else:
            outputfmt = fmts.byname(op.format)

            if not outputfmt:
                outputfmt = fmts.byextension(os.extsep + op.format)

        # If no doctype given, check list of acceptable formats for input file ext doctype.
        # FIXME: This should go into the for-loop to match each individual input filename.
        if outputfmt:
            inputext = os.path.splitext(inputfn)[1]
            inputfmt = fmts.byextension(inputext)
            if inputfmt:
                for fmt in outputfmt:
                    if inputfmt[0].doctype == fmt.doctype:
                        doctype = inputfmt[0].doctype
                        outputfmt = fmt
                        break
                else:
                    outputfmt = outputfmt[0]
    #       print >>sys.stderr, 'Format `%s\' is part of multiple doctypes %s, selecting `%s\'.' % (format, [fmt.doctype for fmt in outputfmt], outputfmt[0].doctype)
            else:
                outputfmt = outputfmt[0]

        # No format found, throw error
        if not outputfmt:
            if doctype:
                error('Format [%s/%s] is not known to unoconv.' % (op.doctype, op.format))
            else:
                error('Format [%s] is not known to unoconv.' % op.format)
            die(1)

        return outputfmt

    def preserve(self, inputfn, outputfn):
        # Get timestamp of input file.
        s = os.stat(inputfn)
        times = (s.st_atime, s.st_mtime)
        mode = s.st_mode
        # Set it to output file.
        with open(outputfn, "a") as f:
            os.utime(f.fileno()
                     if hasattr(os, "supports_fd") and os.utime in os.supports_fd else inputfn,
                     times=times)
            os.chmod(f.fileno()
                     if hasattr(os, "supports_fd") and os.chmod in os.supports_fd else inputfn,
                     mode)

    def convert(self, inputfn):
        global exitcode

        document = None
        outputfmt = self.getformat(inputfn)

        if op.verbose > 0:
            print('Input file:', inputfn, file=sys.stderr)

        try:
            # Import phase.
            phase = "import"

            # Load inputfile.
            inputprops = UnoProps(Hidden=True, ReadOnly=True, UpdateDocMode=op.updateDocMode)

            if op.password:
                inputprops += UnoProps(Password=op.password)

            # Cannot use UnoProps for FilterData property.
            if op.importfilteroptions:
                # print "Import filter options: %s" % op.importfilteroptions
                inputprops += UnoProps(FilterOptions=op.importfilteroptions)

            # Cannot use UnoProps for FilterData property.
            if op.importfilter:
                inputprops += (PropertyValue("FilterData", 0, uno.Any("[]com.sun.star.beans.PropertyValue", tuple(op.importfilter), ), 0), )

            if op.importfiltername:
                importformat = self.getimportformat()
                inputprops += UnoProps(FilterName=importformat.filter)

            if op.stdin:
                inputStream = self.svcmgr.createInstanceWithContext("com.sun.star.io.SequenceInputStream", self.context)
                inputStream.initialize((uno.ByteSequence(inputfn),))
                inputprops += UnoProps(InputStream=inputStream)
                inputurl = 'private:stream'
            elif os.path.exists(inputfn):
                inputurl = unohelper.absolutize(self.cwd, unohelper.systemPathToFileUrl(inputfn))
            else:
                inputurl = inputfn
            document = self.desktop.loadComponentFromURL(inputurl, "_blank", 0, inputprops)

            if not document:
                raise UnoException("The document '%s' could not be opened." % inputurl, None)

            # Import style template.
            phase = "import-style"
            if op.template:
                if os.path.exists(op.template):
                    info(1, "Template file: %s" % op.template)
                    templateprops = UnoProps(OverwriteStyles=True)
                    templateurl = unohelper.absolutize(self.cwd, unohelper.systemPathToFileUrl(op.template))
                    document.StyleFamilies.loadStylesFromURL(templateurl, templateprops)
                else:
                    print('unoconv: template file `%s\' does not exist.' % op.template, file=sys.stderr)
                    exitcode = 1

            # Force all cells to recalculate if we are able to. This will get rid of errors in cells.
            # FIXME: We cannot recalculate the cells because it breaks issue #97 (cells get #VALUE)
            # phase = "recalculate"
            # try:
                # document.calculateAll()
            # except AttributeError:
                # pass

            # Update document links if appropriate
            if op.updateDocMode != NO_UPDATE:
                phase = "update-links"
                try:
                    document.updateLinks()
                    # Found that when converting HTML files with external images, OO would only load five or six of
                    # the images in the file. In the resulting document, the rest of the images did not appear. Cycling
                    # through all the image references in the document seems to force OO to actually load them. Found
                    # some helpful guidance in this thread:
                    # https://forum.openoffice.org/en/forum/viewtopic.php?f=30&t=23909
                    # Ideally we would like to have the option to embed the images into the document, but I have not been
                    # able to figure out how to do this yet.
                    if op.updatehtmllinks:
                        graphObjs = document.GraphicObjects
                        for i in range(0, graphObjs.getCount()):
                            graphObj = graphObjs.getByIndex(i)
                except AttributeError:
                    # the document doesn't implement the XLinkUpdate interface
                    pass

            # Add/Replace variables
            phase = "replace-fields"
            for f in op.fields:
                try:
                    field = document.TextFieldMasters.getByName("com.sun.star.text.fieldmaster.User.%s" % f)
                    field.setPropertyValue('Content', op.fields[f])
                except UnoException:
                    error("unoconv: failed to replace variable '%s' with value '%s' in the document." % (f, op.fields[f]))
                    pass

            # Add/Replace metadata
            phase = "replace-metadata"
            props = document.getDocumentProperties()
            user_props = props.getUserDefinedProperties()
            for prop, value in op.metadata.items():
                for container in (props, user_props):
                    curr = getattr(container, prop, None)
                    if curr is not None:
                        setattr(container, prop, value)
                        break
                else:
                    user_props.addProperty(prop, 0, '')
                    user_props.setPropertyValue(prop, value)

            # Update document indexes
            phase = "update-indexes"
            for ii in range(2):
                # At first, update Table-of-Contents.
                # ToC grows, so page numbers grow too.
                # On second turn, update page numbers in ToC.
                try:
                    document.refresh()
                    indexes = document.getDocumentIndexes()
                except AttributeError:
                    # The document doesn't implement the XRefreshable and/or
                    # XDocumentIndexesSupplier interfaces
                    break
                else:
                    for i in range(0, indexes.getCount()):
                        indexes.getByIndex(i).update()

            info(1, "Selected output format: %s" % outputfmt)
            info(2, "Selected office filter: %s" % outputfmt.filter)
            info(2, "Used doctype: %s" % outputfmt.doctype)

            # Document properties phase
            phase = "disable-showchanges"
            try:
                document.ShowChanges = False
            except AttributeError:
                pass

            # Export phase
            phase = "export"

            outputprops = UnoProps(FilterName=outputfmt.filter, OutputStream=OutputStream(), Overwrite=True)

            # Set default filter options
            if op.exportfilteroptions:
                # print "Export filter options: %s" % op.exportfilteroptions
                outputprops += UnoProps(FilterOptions=op.exportfilteroptions)
            elif outputfmt.filter == 'Text (encoded)':
                outputprops += UnoProps(FilterOptions="UTF8,LF")
            elif outputfmt.filter == 'Text':
                outputprops += UnoProps(FilterOptions="UTF8")
            elif outputfmt.filter == 'Text - txt - csv (StarCalc)':
                outputprops += UnoProps(FilterOptions="44,34,UTF8")

            # Set printer options
            if op.setprinter:
                printer = document.getPrinter()
                for i in range(len(printer)):
                    if printer[i].Name == 'PaperOrientation' and op.paperorientation is not None:
                        printer[i].Value = uno.Enum('com.sun.star.view.PaperOrientation', op.paperorientation)
                    elif printer[i].Name == 'PaperFormat' and op.paperformat is not None:
                        printer[i].Value = uno.Enum('com.sun.star.view.PaperFormat', op.paperformat)
                    elif (printer[i].Name == 'PaperSize' and op.papersize is not None and len(op.papersize) == 2):
                        printer[i].Value.Width = op.papersize[0]
                        printer[i].Value.Height = op.papersize[1]
                document.setPrinter(printer)

            # Cannot use UnoProps for FilterData property
            if op.exportfilter:
                outputprops += (PropertyValue("FilterData", 0, uno.Any("[]com.sun.star.beans.PropertyValue", tuple(op.exportfilter), ), 0), )

            if op.stdout:
                # Ensure binary data to stdout works
                # http://stackoverflow.com/questions/2374427/python-2-x-write-binary-output-to-stdout
                if sys.platform == "win32":
                    import msvcrt
                    msvcrt.setmode(sys.stdout.fileno(), os.O_BINARY)
                outputurl = "private:stream"
            else:
                if os.path.exists(inputfn):
                    (inbase, ext) = os.path.splitext(inputfn)
                else:
                    (inbase, ext) = os.path.splitext(os.path.basename(inputfn))
                if op.output:
                    (outbase, ext) = os.path.splitext(op.output)
                    if len(op.filenames) > 1:
                        outputfn = realpath(outbase, os.path.basename(inbase) + os.extsep + outputfmt.extension)
                    else:
                        outputfn = realpath(outbase + os.extsep + outputfmt.extension)
                else:
                    outputfn = realpath(inbase + os.extsep + outputfmt.extension)

                outputurl = unohelper.absolutize(self.cwd, unohelper.systemPathToFileUrl(outputfn))

            info(1, "Output file: %s" % outputurl)

            try:
                document.storeToURL(outputurl, tuple(outputprops))
            except IOException as e:
                raise UnoException("Unable to store document to %s (Error %s)\n\nProperties: %s" % (outputurl, e.value, outputprops), None)

            phase = "dispose"
            document.dispose()
            document.close(True)
            if not op.stdout and op.preserve:
                self.preserve(inputfn, outputfn)

        except SystemError as e:
            error("unoconv: SystemError during %s phase:\n%s" % (phase, e))
            exitcode = 1

        except RuntimeException as e:
            error("unoconv: RuntimeException during %s phase:\nOffice probably died. %s" % (phase, e))
            exitcode = 6

        except DisposedException as e:
            error("unoconv: DisposedException during %s phase:\nOffice probably died. %s" % (phase, e))
            exitcode = 7

        except IllegalArgumentException as e:
            error("UNO IllegalArgument during %s phase:\nSource file cannot be read. %s" % (phase, e))
            exitcode = 8

        except IOException as e:
            # for attr in dir(e): print '%s: %s', (attr, getattr(e, attr))
            error("unoconv: IOException during %s phase:\n%s" % (phase, e.Message))
            exitcode = 3

        except CannotConvertException as e:
            # for attr in dir(e): print '%s: %s', (attr, getattr(e, attr))
            error("unoconv: CannotConvertException during %s phase:\n%s" % (phase, e.Message))
            exitcode = 4

        except UnoException as e:
            if hasattr(e, 'ErrCode'):
                error("unoconv: UnoException during %s phase in %s (ErrCode %d)" % (phase, repr(e.__class__), e.ErrCode))
                exitcode = e.ErrCode
                pass
            if hasattr(e, 'Message'):
                error("unoconv: UnoException during %s phase:\n%s" % (phase, e.Message))
                exitcode = 5
            else:
                error("unoconv: UnoException during %s phase in %s" % (phase, repr(e.__class__)))
                exitcode = 2
                pass


class Listener:
    def __init__(self):
        global product

        info(1, "Start listener on %s:%s" % (op.server, op.port))
        self.context = uno.getComponentContext()
        self.svcmgr = self.context.ServiceManager
        try:
            resolver = self.svcmgr.createInstanceWithContext("com.sun.star.bridge.UnoUrlResolver", self.context)
            product = self.svcmgr.createInstance("com.sun.star.configuration.ConfigurationProvider").createInstanceWithArguments("com.sun.star.configuration.ConfigurationAccess", UnoProps(nodepath="/org.openoffice.Setup/Product"))
            try:
                unocontext = resolver.resolve("uno:%s" % op.connection)
            except NoConnectException:
                pass
            else:
                info(1, "Existing %s listener found, nothing to do." % product.ooName)
                return
            if product.ooName != "LibreOffice" or LooseVersion(product.ooSetupVersion) <= LooseVersion('3.3'):
                cmd = [office.binary, "-headless", "-invisible", "-nocrashreport", "-nodefault", "-nologo", "-nofirststartwizard", "-norestore", "-accept=%s" % op.connection]
            else:
                cmd = [office.binary, "--headless", "--invisible", "--nocrashreport", "--nodefault", "--nologo", "--nofirststartwizard", "--norestore", "--accept=%s" % op.connection]

            # The rationale for using subprocess.Popen is to be able to handle
            # a SIGTERM signal below and properly terminate the started office
            # process then. This makes it possible to put the command unoconv -l
            # under control of supervisor to deamonize it. Supervisor terminates
            # via sending SIGTERM and sending SIGTERM to a running unoconv -l
            # without the handler below will not terminate the office process
            # together with it leaving the office process running.
            office_process = subprocess.Popen(cmd, env=os.environ)

            def sigterm_handler(signum, frame):
                office_process.terminate()
                die(6, 'Exiting on SIGTERM')

            signal.signal(signal.SIGTERM, sigterm_handler)

            ret = office_process.wait()
            if ret == 81:
                info(1, "Restarting %s (first start - 81 exit code)" % product.ooName)
                office_process = subprocess.Popen(cmd, env=os.environ)
                office_process.wait()
            else:
                raise Exception("%s crashed - exit code: %s" % (product.ooName, ret))
        except Exception as e:
            error("Launch of %s failed.\n%s" % (office.binary, e))


def error(msg, file=sys.stderr):
    """Output error message."""
    print(msg, file=file)


def info(level, msg):
    """Output info message."""
    if 'op' not in globals():
        pass
    elif op.verbose >= 3 and level >= 3:
        print("DEBUG:", msg, file=sys.stderr)
    elif not op.stdout and level <= op.verbose:
        print(msg, file=sys.stdout)
    elif level <= op.verbose:
        print(msg, file=sys.stderr)


def die(ret, msg=None):
    """Print optional error and exit with errorcode."""
    global convertor, ooproc, office

    if msg:
        error('Error: %s' % msg)

    # Did we start our own listener instance?
    if not op.listener and ooproc and convertor:

        # If there is a GUI now attached to the instance, disable listener.
        if convertor.desktop.getCurrentFrame():
            info(2, 'Trying to stop %s GUI listener.' % product.ooName)
            try:
                if product.ooName != "LibreOffice" or product.ooSetupVersion <= 3.3:
                    subprocess.Popen([office.binary, "-headless", "-invisible", "-nocrashreport", "-nodefault", "-nofirststartwizard", "-nologo", "-norestore", "-unaccept=%s" % op.connection], env=os.environ)
                else:
                    subprocess.Popen([office.binary, "--headless", "--invisible", "--nocrashreport", "--nodefault", "--nofirststartwizard", "--nologo", "--norestore", "--unaccept=%s" % op.connection], env=os.environ)
                ooproc.wait()
                info(2, '%s listener successfully disabled.' % product.ooName)
            except Exception as e:
                error("Terminate using %s failed.\n%s" % (office.binary, e))

        # If there is no GUI attached to the instance, terminate instance.
        else:
            info(3, 'Terminating %s instance.' % product.ooName)
            try:
                convertor.desktop.terminate()
            except DisposedException:
                info(2, '%s instance unsuccessfully closed, sending TERM signal.' % product.ooName)
                try:
                    ooproc.terminate()
                except AttributeError:
                    os.kill(ooproc.pid, 15)
            info(3, 'Waiting for %s instance to exit.' % product.ooName)
            ooproc.wait()

        # LibreOffice processes may get stuck and we have to kill them.
        # Is it still running?
        if ooproc.poll() is None:
            info(1, '%s instance still running, please investigate...' % product.ooName)
            ooproc.wait()
            info(2, '%s instance unsuccessfully terminated, sending KILL signal.' % product.ooName)
            try:
                ooproc.kill()
            except AttributeError:
                os.kill(ooproc.pid, 9)
            info(3, 'Waiting for %s with pid %s to disappear.' % (ooproc.pid, product.ooName))
            ooproc.wait()

    # Allow Python GC to garbage collect pyuno object *before* exit call
    # which avoids random segmentation faults --vpa
    convertor = None

    sys.exit(ret)


def main():
    global convertor, exitcode
    convertor = None

    try:
        if op.listener:
            listener = Listener()

        if op.stdin:
            # Read stdin buffer in Python 3 in order to correctly handle binary streams.
            # ref: https://docs.python.org/3.1/library/sys.html#sys.stdin
            if sys.version_info.major > 2:
                inputfn = sys.stdin.buffer.read()
            else:
                inputfn = sys.stdin.read()
            convertor = Convertor()
            convertor.convert(inputfn)
        elif op.filenames:
            convertor = Convertor()
            for inputfn in op.filenames:
                convertor.convert(inputfn)

    except NoConnectException:
        error("unoconv: could not find an existing connection to LibreOffice at %s:%s." % (op.server, op.port))
        if op.connection:
            info(0, "Please start an LibreOffice instance on server '%s' by doing:\n\n    unoconv --listener --server %s --port %s\n\nor alternatively:\n\n    soffice -nologo -nodefault -accept=\"%s\"" % (op.server, op.server, op.port, op.connection))
        else:
            info(0, "Please start an LibreOffice instance on server '%s' by doing:\n\n    unoconv --listener --server %s --port %s\n\nor alternatively:\n\n    soffice -nologo -nodefault -accept=\"socket,host=%s,port=%s;urp;\"" % (op.server, op.server, op.port, op.server, op.port))
            info(0, "Please start an soffice instance on server '%s' by doing:\n\n    soffice -nologo -nodefault -accept=\"socket,host=127.0.0.1,port=%s;urp;\"" % (op.server, op.port))
        exitcode = 1
    # except UnboundLocalError:
        # die(252, "Failed to connect to remote listener.")
    except OSError:
        error("Warning: failed to launch Office suite. Aborting.")


# Main entrance
if __name__ == '__main__':
    exitcode = 0

    info(3, 'sysname=%s, platform=%s, python=%s, python-version=%s' % (os.name, sys.platform, sys.executable, sys.version))

    for of in find_offices():
        if of.python != sys.executable and not sys.executable.startswith(of.basepath):
            python_switch(of)
        office_environ(of)
        # debug_office()
        try:
            import uno
            import unohelper
            office = of
            break
        except:
            # debug_office()
            print("unoconv: Cannot find a suitable pyuno library and python binary combination in %s" % of, file=sys.stderr)
            print("ERROR:", sys.exc_info()[1], file=sys.stderr)
            print(file=sys.stderr)
    else:
        # debug_office()
        print("unoconv: Cannot find a suitable office installation on your system.", file=sys.stderr)
        print("ERROR: Please locate your office installation and send your feedback to:", file=sys.stderr)
        print("       http://github.com/dagwieers/unoconv/issues", file=sys.stderr)
        sys.exit(1)

    # Working pyuno library found. Import classes.
    from com.sun.star.beans import PropertyValue
    from com.sun.star.connection import NoConnectException
    from com.sun.star.document.UpdateDocMode import NO_UPDATE, QUIET_UPDATE
    from com.sun.star.io import IOException, XOutputStream
    from com.sun.star.lang import DisposedException, IllegalArgumentException
    from com.sun.star.script import CannotConvertException
    from com.sun.star.uno import Exception as UnoException
    from com.sun.star.uno import RuntimeException

    # Build on imported classes.
    class OutputStream(unohelper.Base, XOutputStream):
        def __init__(self):
            self.closed = 0

        def closeOutput(self):
            self.closed = 1

        def writeBytes(self, seq):
            try:
                sys.stdout.buffer.write(seq.value)
            except AttributeError:
                sys.stdout.write(seq.value)

        def flush(self):
            pass

    def UnoProps(**args):
        props = []
        for key in args:
            prop = PropertyValue()
            prop.Name = key
            prop.Value = args[key]
            props.append(prop)
        return tuple(props)

    op = Options(sys.argv[1:])

    info(2, "Using office base path: %s" % office.basepath)
    info(2, "Using office binary path: %s" % office.unopath)

    try:
        main()
    except KeyboardInterrupt:
        die(6, 'Exiting on user request')
    die(exitcode)
