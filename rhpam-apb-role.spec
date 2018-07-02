%if 0%{?copr}
%define build_timestamp .%(date +"%Y%m%d%H%M%%S")
%else
%define build_timestamp %{nil}
%endif

Name: 		rhpam-apb-role
Version:	1.0.0
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
mv playbooks %{buildroot}/opt/apb/actions
mv roles %{buildroot}/opt/ansible

%files
%doc
/opt/apb/actions
/opt/ansible/roles

%changelog

