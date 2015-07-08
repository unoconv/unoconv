%define rpmrelease %nil

Summary: Tool to convert between any document format supported by LibreOffice
Name: unoconv
Version: 0.7
Release: 1%{?rpmrelease}%{?dist}
License: GPL
Group: System Environment/Base
URL: http://dag.wieers.com/home-made/unoconv/

Source: https://github.com/downloads/dagwieers/unoconv/unoconv-%{version}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root

BuildArch: noarch
BuildRequires: python >= 2.0
Requires: python >= 2.0

%description
unoconv converts between any document format that LibreOffice understands.
It uses LibreOffice's UNO bindings for non-interactive conversion of
documents.

Supported document formats include: Open Document Text (.odt),
Open Document Draw (.odd), Open Document Presentation (.odp),
Open Document calc (.odc), MS Word (.doc), MS PowerPoint (.pps/.ppt),
MS Excel (.xls), MS Office Open/OOXML (.xml),
Portable Document Format (.pdf), DocBook (.xml), LaTeX (.ltx),
HTML, XHTML, RTF, Docbook (.xml), GIF, PNG, JPG, SVG, BMP, EPS
and many more...

%prep
%setup

%build
%{__make} doc

%install
%{__rm} -rf %{buildroot}
%{__make} install DESTDIR="%{buildroot}"

%clean
%{__rm} -rf %{buildroot}

%files
%defattr(-, root, root, 0755)
%doc AUTHORS ChangeLog COPYING README* doc/*.adoc doc/*.html
%doc %{_mandir}/man1/unoconv.1*
%{_bindir}/unoconv

%changelog
* Thu Jul 09 2015 Dag Wieers <dag@wieers.com> - 0.7-1
- Updated to release 0.7.

* Mon Sep 10 2012 Dag Wieers <dag@wieers.com> - 0.6-1
- Updated to release 0.6.

* Mon Apr 16 2012 Dag Wieers <dag@wieers.com> - 0.5-1
- Updated to release 0.5.

* Wed Oct 20 2010 Dag Wieers <dag@wieers.com> - 0.4-1
- Updated to release 0.4.

* Fri Aug 31 2007 Dag Wieers <dag@wieers.com> - 0.3-1
- Updated to release 0.3.

* Sun May 20 2007 Dag Wieers <dag@wieers.com> - 0.2-1
- Updated to release 0.2.

* Sat May 19 2007 Dag Wieers <dag@wieers.com> - 0.1-1
- Initial package. (using DAR)
