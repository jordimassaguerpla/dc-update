#
# spec file for dc-update
#
# Copyright (c) 2015 SUSE LINUX Products GmbH, Nuernberg, Germany.
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

Name:           dc-update
Version:        1.0
Release:        1.0
License:        MIT
Summary:        Docker Containment Update
Url:            http://github.con/jordimassaguerpla/dc-update
Source:         http://github.con/jordimassaguerpla/dc-update
BuildRoot:      %{_tmppath}/%{name}-%{version}-build

%description

%prep
%setup -q

%build
echo "Nothing to be built"

%install
mkdir -p %{buildroot}/usr/share/dc-update
cp -r bin %{buildroot}/usr/share/dc-update
chmod 755 %{buildroot}/usr/share/dc-update/bin/*
cp -r lib %{buildroot}/usr/share/dc-update
cp package/dc-update %{buildroot}/usr/bin
chmod 755 %{buildroot}/usr/bin/*

%files
%defattr(-,root,root)
/usr/share/dc-update
/usr/bin/dc-update

%changelog

