#
# spec file for package _service:set_version:_service:extract_file:perl
#
# Copyright (c) 2013 SUSE LINUX Products GmbH, Nuernberg, Germany.
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via http://bugs.opensuse.org/
#


Name:           perl-Date-Holidays-CZ
Version:        0.07
Release:        0
Summary:        Czech Republic bank holidays
License:        Artistic-2.0
%define cpan_name Date-Holidays-CZ
Group:          Development/Libraries/Perl
Url:            https://sourceforge.net/projects/date-holidays-cz
Source:         %{cpan_name}-%{version}.tar.gz
BuildRequires:  perl
BuildRequires:  perl-macros
%{perl_requires}
Requires:       perl(Date::Easter)
Requires:       perl(Date::Simple)
BuildArch:      noarch
BuildRequires:  perl(Date::Easter)
BuildRequires:  perl(Date::Simple)

BuildRoot:      %{_tmppath}/%{name}-%{version}-build

%description
In its current, primitive form, this module provides a way to get
information on Czech Republic bank holidays. The author hopes the
holiday dates and names provided by the module are correct, but no
guarantee is given. The module may contain errors, and the information
it provides might be wrong.

%prep
%setup -q -n %{cpan_name}-%{version}

%build
%{__perl} Makefile.PL INSTALLDIRS=vendor
%{__make} %{?_smp_mflags}

%check
%{__make} test

%install
%perl_make_install
%perl_process_packlist
%perl_gen_filelist

%clean
%{__rm} -rf %{buildroot}

%files
%defattr(-,root,root)
%dir %{perl_vendorlib}/Date/Holidays
%{perl_vendorlib}/Date/Holidays/CZ.pm
%{_mandir}/man3/Date::Holidays::CZ.3pm.gz
%doc Changes README README.packaging

%changelog
