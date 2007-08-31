# $Id$
# Authority: dag
# Upstream: Dag Wieers <dag$wieers,com>

%{?dist: %{expand: %%define %dist 1}}

%{?el4:%define _with_openoffice.org2 1}

Summary: Tool to convert between any document format supported by OpenOffice
Name: unoconv
Version: 0.3
Release: 1
License: GPL
Group: System Environment/Base
URL: http://dag.wieers.com/home-made/unoconv/

Packager: Dag Wieers <dag@wieers.com>
Vendor: Dag Apt Repository, http://dag.wieers.com/apt/

Source: http://dag.wieers.com/home-made/unoconv/unoconv-%{version}.tar.bz2
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root

BuildArch: noarch
BuildRequires: python >= 2.0
Requires: python >= 2.0
%{!?_with_openoffice.org2:Requires:openoffice.org-pyuno >= 2.0}
%{?_with_openoffice.org2:Requires:openoffice.org2-pyuno >= 2.0}

%description
unoconv converts between any document format that OpenOffice understands.
It uses OpenOffice's UNO bindings for non-interactive conversion of
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

%install
%{__rm} -rf %{buildroot}
%{__make} install DESTDIR="%{buildroot}"

%clean
%{__rm} -rf %{buildroot}

%files
%defattr(-, root, root, 0755)
%doc AUTHORS ChangeLog COPYING README TODO WISHLIST docs/ tests/
%{_bindir}/unoconv

%changelog
* Fri Aug 31 2007 Dag Wieers <dag@wieers.com> - 0.3-1
- Updated to release 0.3.

* Sun May 20 2007 Dag Wieers <dag@wieers.com> - 0.2-1
- Updated to release 0.2.

* Sat May 19 2007 Dag Wieers <dag@wieers.com> - 0.1-1
- Initial package. (using DAR)
