%if 0%{?copr}
%define build_timestamp .%(date +"%Y%m%d%H%M%%S")
%else
%define build_timestamp %{nil}
%endif

Name: 		rhpam-apb-role
Version:	1.0.3
Release:	1%{build_timestamp}%{?dist}
Summary:	Ansible Playbook Bundle for Red Hat Process Automation Manager

License:	ASL 2.0
URL:		https://github.com/ansibleplaybookbundle/RHPAM-APB
Source0:	https://github.com/ansibleplaybookbundle/RHPAM-APB/archive/%{name}-%{version}.tar.gz
BuildArch:  noarch

%description
%{summary}

%prep
%setup -q -n %{name}-%{version}

%install
mkdir -p %{buildroot}/opt/apb/ %{buildroot}/opt/ansible/
mv playbooks %{buildroot}/opt/apb/project
mv roles %{buildroot}/opt/ansible

%files
%doc
/opt/apb/project
/opt/ansible/roles

%changelog
* Fri Oct 05 2018 Ruben Romero Montes <rromerom@redhat.com> 1.0.3-1
- [RHPAM-1493] Adapt to 7.1 (rromerom@redhat.com)
- Added cekit support (rromerom@redhat.com)

* Tue Aug 14 2018 Ruben Romero Montes <rromerom@redhat.com> 1.0.2-1
- [RHPAM-1448] Apply review changes (rromerom@redhat.com)
- Refactor tests and follow asbroker team recommendations (rromerom@redhat.com)
- udpated demo gif (rromerom@redhat.com)

* Mon Jul 02 2018 Ruben Romero Montes <rromerom@redhat.com> 1.0.1-1
- new package built with tito


